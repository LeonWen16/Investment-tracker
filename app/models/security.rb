# == Schema Information
#
# Table name: securities
#
#  id               :integer          not null, primary key
#  average_price    :float
#  company_name     :string
#  current_price    :float
#  last_price       :float
#  number_of_shares :integer
#  ticker           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :integer
#
class Security < ApplicationRecord
  belongs_to(:owner, { :required => false, :class_name => "User", :foreign_key => "owner_id" })
end
