# == Schema Information
#
# Table name: documents
#
#  id          :integer          not null, primary key
#  title       :string
#  f           :string
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Document < ActiveRecord::Base

  # ---------------------------------------- Associations

  belongs_to :property

end
