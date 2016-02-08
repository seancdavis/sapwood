# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  labels        :json
#  templates_raw :text
#  forms_raw     :text
#

class Property < ActiveRecord::Base

  # ---------------------------------------- Associations

  has_many :elements
  has_many :collections
  has_many :documents
  has_many :responses
  has_many :property_users
  has_many :users, :through => :property_users

  # ---------------------------------------- Validations

  validates :title, :presence => true

  # ---------------------------------------- Class Methods

  def self.labels
    %w(elements documents collections responses)
  end

end
