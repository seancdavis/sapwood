# == Schema Information
#
# Table name: documents
#
#  id          :integer          not null, primary key
#  title       :string
#  url         :string
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  archived    :boolean          default(FALSE)
#

class Document < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  # ---------------------------------------- Associations

  belongs_to :property

  # ---------------------------------------- Scopes

  default_scope { where(:archived => false) }

  # ---------------------------------------- Callbacks

  after_save :set_title_if_blank

  # ---------------------------------------- Instance Methods

  def filename
    url.split('/').last
  end

  def filename_no_ext
    filename.split('.')[0..-2].join('.')
  end

  def file_ext
    url.split('.').last.downcase
  end

  def image?
    %(jpeg jpg png gif svg).include?(file_ext)
  end

  def archive!
    update_columns(:archived => true)
  end

  def as_json(options = {})
    {
      :id => id,
      :title => title,
      :url => url
    }
  end

  # ---------------------------------------- Private Methods

  private

    def set_title_if_blank
      if title.blank?
        update_columns(:title => url.split('/').last.split('.').first.titleize)
      end
    end

end
