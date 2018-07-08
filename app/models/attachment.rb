class Attachment < ApplicationRecord

  # ---------------------------------------- | Plugins

  include AttachmentDecorator, PgSearch

  pg_search_scope :search_by_title, against: :title,
                  using: { tsearch: { prefix: true, dictionary: 'english' } }

  # ---------------------------------------- | Associations

  belongs_to :property, touch: true

  # ---------------------------------------- | Scopes

  scope :by_title, -> { order(title: :asc) }
  scope :by_last_updated, -> { order(updated_at: :desc) }

  # ---------------------------------------- | Callbacks

  after_save :set_title_if_blank

  # ---------------------------------------- | Instance Methods

  def as_json(options = {})
    { id: id, title: title, url: url }
  end

  # ---------------------------------------- | Private Methods

  private

    def set_title_if_blank
      return unless title.blank?
      update_columns(title: filename(false).humanize.titleize)
    end


end
