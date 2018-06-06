# == Schema Information
#
# Table name: element_associations
#
#  id         :integer          not null, primary key
#  source_id  :integer
#  target_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ElementAssociation < ApplicationRecord

  # ---------------------------------------- Associations

  belongs_to :source, :class_name => 'Element'
  belongs_to :target, :class_name => 'Element'

end
