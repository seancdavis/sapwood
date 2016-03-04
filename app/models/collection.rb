# == Schema Information
#
# Table name: collections
#
#  id          :integer          not null, primary key
#  title       :string
#  property_id :integer
#  item_data   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Collection < ActiveRecord::Base

  # ---------------------------------------- Associations

  belongs_to :property

  # ---------------------------------------- Validations

  validates :title, :presence => true

end
