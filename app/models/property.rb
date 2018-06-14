# frozen_string_literal: true

class Property < ApplicationRecord

  # ---------------------------------------- Attributes

  attr_accessor :template_name, :csv

  # ---------------------------------------- Associations

  has_many :elements, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :property_users, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :keys, dependent: :destroy

  has_many :users, through: :property_users

  # ---------------------------------------- Validations

  validates :title, presence: true

  # ---------------------------------------- Scopes

  scope :alpha, -> { order(title: :asc) }

  # ---------------------------------------- Callbacks

  after_create :generate_api_key!

  def generate_api_key!
    update_columns(api_key: SecureRandom.hex(25))
  end

  after_save :expire_caches

  def expire_caches(force = false)
    return true unless force || (SapwoodCache.enabled? && templates_raw_changed?)
    SapwoodCache.rebuild_property(self)
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
