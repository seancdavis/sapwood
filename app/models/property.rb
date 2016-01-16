# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  title      :string
#  config     :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Property < ActiveRecord::Base

  # ---------------------------------------- Associations

  has_many :elements
  has_many :property_users
  has_many :users, :through => :property_users

end
