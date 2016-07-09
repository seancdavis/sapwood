# == Schema Information
#
# Table name: properties
#
#  id                   :integer          not null, primary key
#  title                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  color                :string
#  labels               :json
#  templates_raw        :text
#  forms_raw            :text
#  hidden_labels        :text             default([]), is an Array
#  api_key              :string
#  collection_types_raw :text
#

class Property < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  # ---------------------------------------- Attributes

  attr_accessor :template_name, :csv

  # ---------------------------------------- Associations

  has_many :elements, :dependent => :destroy
  has_many :collections, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :responses, :dependent => :destroy
  has_many :property_users, :dependent => :destroy
  has_many :users, :through => :property_users

  # ---------------------------------------- Validations

  validates :title, :presence => true

  # ---------------------------------------- Scopes

  scope :alpha, -> { order(:title => :asc) }

  # ---------------------------------------- Callbacks

  after_create :generate_api_key!

  def generate_api_key!
    update_columns(:api_key => SecureRandom.hex(25))
  end

  after_save :set_default_collection_type

  def set_default_collection_type
    if collection_types_raw.blank?
      c = [{ :title => 'Collection' }]
      update_columns(:collection_types_raw => JSON.pretty_generate(c))
    end
  end

  after_touch :expire_caches
  after_save :expire_caches

  def expire_caches
    Rails.cache.delete_matched(/p#{id}\_(.*)/)
  end

  # ---------------------------------------- Class Methods

  def self.labels
    %w(elements documents collections responses users)
  end

  # ---------------------------------------- Instance Methods

  def to_s
    title
  end

  def label(name)
    return name.titleize if labels.blank? || labels[name].blank?
    labels[name]
  end

  def hide_label!(name)
    return false unless label(name).present?
    update_columns(:hidden_labels => hidden_labels << name)
  end

  def unhide_label!(name)
    return false unless label(name).present?
    update_columns(:hidden_labels => hidden_labels - [name])
  end

  def label_hidden?(name)
    hidden_labels.include?(name)
  end

  def templates
    return [] if templates_raw.blank?
    templates = []
    JSON.parse(templates_raw).each do |t|
      templates << Template.new(t)
    end
    templates
  end

  def valid_templates?
    begin
      return true if templates
    rescue
      false
    end
  end

  def find_template(name)
    templates.select { |t| t.title == name || t.slug == name }.first
  end

  def collection_types
    return [] if collection_types_raw.blank?
    types = []
    JSON.parse(collection_types_raw).each do |ct|
      types << CollectionType.new(ct)
    end
    types
  end

  def valid_collection_types?
    begin
      return true if collection_types
    rescue
      false
    end
  end

  def find_collection_type(name)
    collection_types.select { |t| t.title == name || t.slug == name }.first
  end

  def users_with_access
    (users + User.admins).flatten.uniq
  end

end
