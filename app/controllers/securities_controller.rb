class SecuritiesController < ApplicationController
  def index
    matching_securities = Security.where({ :owner_id => @current_user.id })

    @list_of_securities = matching_securities

    render({ :template => "securities/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_securities = Security.where({ :id => the_id })

    @the_security = matching_securities.at(0)

    render({ :template => "securities/show.html.erb" })
  end

  def execute
    this_ticker = params.fetch("query_ticker")
    price = params.fetch("query_price").to_f 
    owner_id = @current_user.id
    number_of_shares = params.fetch("query_number_of_shares").to_i
    commission = params.fetch("query_commission").to_f 
  
    # read and parse the URL data with Alphavantage_key 
    url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + this_ticker + "&apikey=" + ENV.fetch("Alphavantage_key")
    raw_data = open(url).read
    parsed_data = JSON.parse(raw_data) 
    all_data = parsed_data.fetch("Global Quote") 
    
    # check if ticker symbol is valid
    if all_data.empty?
      redirect_to("/portfolio", { :notice => "Invalid ticker symbol" })
    end 

    if params[:buy_sell] == "buy" 
      # check if user has enough cash for this trade 
      if @current_user.cash < (price * number_of_shares + commission)
        redirect_to("/low_fund", { :alert => "Insufficient funds"}) 
      else 
        @current_user.cash -= price * number_of_shares + commission
        @current_user.save
        # check if user already owns this security
        # if they do, just update the instance of that ticker in the database 
        matching = Security.where({ :owner_id => @current_user.id }).where({ :ticker => this_ticker })
        if matching.empty? == false  
          the_security = matching.first 
          the_security.average_price = (the_security.average_price * the_security.number_of_shares + number_of_shares * price) / (the_security.number_of_shares + number_of_shares)  
          the_security.current_price = all_data.fetch("05. price")
          the_security.last_price = all_data.fetch("08. previous close")
          the_security.number_of_shares += number_of_shares
          the_security.save 
          @current_user.update() 
          redirect_to("/portfolio", { :notice => "Added " + number_of_shares.to_s + " shares of " + this_ticker })
        else  
          # create a new security instance in the database 
          the_security = Security.new
          the_security.ticker = this_ticker.upcase 
          the_security.average_price = price
          the_security.number_of_shares = number_of_shares
          the_security.last_price = all_data.fetch("08. previous close")
          the_security.current_price = all_data.fetch("05. price")
          the_security.owner_id = @current_user.id 
          the_security.save 
          @current_user.update() 
          redirect_to("/portfolio", { :notice => "Bought " + number_of_shares.to_s + " shares of " + this_ticker })
        end 
      end 
    else # sell case   
      # check if the user already owns this 
      x = Security.where({ :owner_id => @current_user.id }).where({ :ticker => this_ticker })
      if x == nil 
        redirect_to("/portfolio", { :alert => "You cannot sell a security you do not own" })
      elsif x.first.number_of_shares < number_of_shares
        redirect_to("/portfolio", { :alert => "You do not have enough shares for this trade" })  
      else
        the_security = x.first 
        @current_user.cash +=  number_of_shares * price - commission 
        @current_user.save
        owned_shares = the_security.number_of_shares
        if owned_shares = number_of_shares 
          the_security.destroy 
          @current_user.update()
          redirect_to("/portfolio", { :notice => "Successfully sold " + number_of_shares.to_s + " shares of " + this_ticker.to_s + " at " + price.to_s} )
        else  
          the_security.quantity -= number_of_shares 
          the_security.save 
          @current_user.update()
          redirect_to("/portfolio", { :notice => "Successfully sold " + number_of_shares.to_s + " shares of " + this_ticker.to_s + " at " + price.to_s} )
        end 
      end 
    end 
  end 

  def destroy
    the_id = params.fetch("path_id")
    the_security = Security.where({ :id => the_id }).at(0)

    the_security.destroy

    redirect_to("/securities", { :notice => "Security deleted successfully."} )
  end

  def old 
    redirect_to("portfolios", { :notice => "Successfully added to position" })
  end 

  def more
    redirect_to("portfolios", { :alert => "Insufficient funds" })
  end
end
