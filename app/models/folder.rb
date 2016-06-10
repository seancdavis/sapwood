# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  title       :string
#  slug        :string
#  ancestry    :string
#  property_id :integer
#  position    :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Folder < ActiveRecord::Base

  # ---------------------------------------- Plugins

  has_ancestry

  has_superslug :title, :slug, :context => :property

  # ---------------------------------------- Associations

  belongs_to :property

  has_many :elements

  # ---------------------------------------- Validations

  validates :title, :presence => true

  # ---------------------------------------- Instance Methods

  def to_param
    id.to_s
  end

end
