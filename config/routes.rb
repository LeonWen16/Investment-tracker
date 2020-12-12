Rails.application.routes.draw do

  get("/", { :controller => "application", :action => "home" })

  # Routes for the Security resource:

  # CREATE
  post("/buy_sell", { :controller => "securities", :action => "execute" })
          
  # READ
  get("/portfolio", { :controller => "securities", :action => "index" })
  
  get("/securities/:path_id", { :controller => "securities", :action => "show" })
  
  # UPDATE
  post("/funds", { :controller => "user_authentication", :action => "move_money" })
  
  # DELETE
  get("/delete_security/:path_id", { :controller => "securities", :action => "destroy" })
  get("/added", { :controller => "securities", :action => "old" })
  get("/low_fund", { :controller => "securities", :action => "more" })
  #------------------------------

  # Routes for the User account:

  # SIGN UP FORM
  get("/user_sign_up", { :controller => "user_authentication", :action => "sign_up_form" })        
  # CREATE RECORD
  post("/insert_user", { :controller => "user_authentication", :action => "create"  })
      
  # EDIT PROFILE FORM        
  get("/edit_user_profile", { :controller => "user_authentication", :action => "edit_profile_form" })       
  # UPDATE RECORD
  post("/modify_user", { :controller => "user_authentication", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_user_account", { :controller => "user_authentication", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })
             
  #------------------------------

end
