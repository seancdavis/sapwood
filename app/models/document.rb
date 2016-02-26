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

  # ---------------------------------------- Private Methods

  private

    def set_title_if_blank
      if title.blank?
        update_columns(:title => url.split('/').last.split('.').first.titleize)
      end
    end

end
