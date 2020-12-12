# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  base            :float
#  cash            :float
#  current_value   :float
#  email           :string
#  first_name      :string
#  last_name       :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
  has_many(:securities, { :class_name => "Security", :foreign_key => "owner_id", :dependent => :destroy })

  def update 
    owned = Security.where({ :owner_id => self.id })
    num = owned.count
    sum = self.cash  
    for i in 0..(num-1) 
      temp = owned.at(i) 
      sum += temp.current_price * temp.number_of_shares
    end 
    self.current_value = sum 
    self.save
  end  

  def equity 
    return self.current_value - self.base 
  end 
end
