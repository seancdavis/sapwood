class View < ApplicationRecord

  # ---------------------------------------- | Associations

  belongs_to :property

  # ---------------------------------------- | Validations

  validates_presence_of :title, :slug

  # ---------------------------------------- | Scopes

  default_scope { order(:nav_position) }

  # ---------------------------------------- | Callbacks

  before_validation :create_slug, on: :create
  after_create :verify_slug_uniqueness

  # ---------------------------------------- | Private Methods

  private

    def create_slug
      return slug if slug.present?
      self.slug = title.parameterize
    end

    def verify_slug_uniqueness
      return true unless property.views.where(slug: slug).count > 1
      self.slug = "#{slug}-#{id}"
    end

end
