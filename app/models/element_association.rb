# frozen_string_literal: true

class ElementAssociation < ApplicationRecord
  # ---------------------------------------- Associations

  belongs_to :source, class_name: 'Element'
  belongs_to :target, class_name: 'Element'
end
