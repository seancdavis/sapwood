# frozen_string_literal: true

class User < ApplicationRecord

  # ---------------------------------------- Plugins

  include Presenter

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  # ---------------------------------------- Associations

  has_many :property_users
  has_many :properties, through: :property_users
  has_many :notifications

  # ---------------------------------------- Scopes

  scope :admins, -> { where(is_admin: true) }
  scope :alpha, -> { order(name: :asc) }

  # ---------------------------------------- Callbacks

  before_save :set_avatar_url

  def set_avatar_url
    return if avatar_url.present?
    hash = Digest::MD5.hexdigest(email.downcase)
    self.avatar_url = "https://www.gravatar.com/avatar/#{hash}?s=100&d=retro"
  end

  # ---------------------------------------- Instance Methods

  def accessible_properties
    # TODO: Would prefer to come up with a caching mechanism and avoid memoizing
    # within a model.
    @accessible_properties ||= begin
      return Property.all.to_a if is_admin?
      properties.to_a
    end
  end

  def has_access_to?(property)
    accessible_properties.include?(property)
  end

  def is_admin_of?(property)
    return true if is_admin?
    property_users.find_by_property_id(property.id).try(:is_admin?) || false
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

  def make_admin_in_properties!(ids)
    property_users.where(property_id: ids).update_all(is_admin: true)
  end

  def set_sign_in_key!
    update_columns(sign_in_key: SecureRandom.hex(32))
  end

  def delete_sign_in_key!
    update_columns(sign_in_key: nil)
  end

  def sign_in_id
    Digest::MD5.hexdigest("#{id}//#{created_at}")
  end

end
