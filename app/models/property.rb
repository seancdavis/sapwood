# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  templates_raw :text
#  api_key       :string
#

class Property < ActiveRecord::Base

  # ---------------------------------------- Attributes

  attr_accessor :template_name, :csv

  # ---------------------------------------- Associations

  has_many :collections, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :elements, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :property_users, :dependent => :destroy
  has_many :responses, :dependent => :destroy

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

  after_touch :expire_caches
  after_save :expire_caches

  def expire_caches
    Rails.cache.delete_matched(/\_p#{id}\_(.*)/) if Rails.env.production?
  end

  # ---------------------------------------- Instance Methods

  def to_s
    title
  end

  def templates
    begin
      return [] if templates_raw.blank?
      templates = []
      JSON.parse(templates_raw).each do |t|
        templates << Template.new(t)
      end
      templates
    rescue
      return []
    end
  end

  def valid_templates?
    begin
      return true if templates_raw.blank?
      JSON.parse(templates_raw)
      true
    rescue
      false
    end
  end

  def find_template(name)
    templates.select { |t| t.title == name || t.slug == name }.first
  end

  def find_templates(names)
    templates.select { |t| names.include?(t.title) || names.include?(t.slug) }
  end

  def users_with_access
    (users + User.admins).flatten.uniq
  end

  def menu
    menu = []
    used_spaces = []
    templates.each do |template|
      next if used_spaces.include?(template.namespace) || template.hidden?
      if template.namespace.nil?
        menu << template
      else
        menu << templates.select { |t| t.namespace == template.namespace }
        used_spaces << template.namespace
      end
    end
    menu
  end

end
