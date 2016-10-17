# == Schema Information
#
# Table name: notifications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  property_id   :integer
#  template_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Notification < ActiveRecord::Base

  # ---------------------------------------- Associations

  belongs_to :user
  belongs_to :property

  # ---------------------------------------- Scopes

  scope :in_property, ->(property) { where(:property_id => property.id) }
  scope :for_template, ->(template) { where(:template_name => template.name) }
  scope :without_user, ->(user) { where('user_id != ?', user.id) }

  # ---------------------------------------- Validations

  validates :user_id, :property_id, :template_name, :presence => true

end