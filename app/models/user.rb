# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  name                   :string
#  sign_in_key            :string
#

class User < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  # ---------------------------------------- Associations

  has_many :property_users
  has_many :properties, :through => :property_users

  # ---------------------------------------- Scopes

  scope :admins, -> { where(:is_admin => true) }
  scope :alpha, -> { order(:name => :asc) }

  # ---------------------------------------- Instance Methods

  def accessible_properties
    @accessible_properties ||= begin
      return Property.all.to_a if is_admin?
      properties.to_a
    end
  end

  def has_access_to?(property)
    accessible_properties.include?(property)
  end

  def property_ids
    accessible_properties.collect(&:id)
  end

  def set_properties!(ids)
    (property_ids - ids).each do |missing_id|
      properties.delete(Property.find_by_id(missing_id))
    end
    (ids - property_ids).each do |new_id|
      properties << Property.find_by_id(new_id)
    end
  end

  def set_sign_in_key!
    update_columns(:sign_in_key => SecureRandom.hex(64))
  end

  def delete_sign_in_key!
    update_columns(:sign_in_key => nil)
  end

end
