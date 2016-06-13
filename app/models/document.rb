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
#

class Document < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  # ---------------------------------------- Associations

  belongs_to :property

  # ---------------------------------------- Callbacks

  after_save :set_title_if_blank

  # ---------------------------------------- Instance Methods

  def image?
    %(jpeg jpg png gif svg).include?(url.split('.').last.downcase)
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
