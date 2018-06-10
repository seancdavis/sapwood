# frozen_string_literal: true

# == Schema Information
#
# Table name: responses
#
#  id          :integer          not null, primary key
#  property_id :integer
#  data        :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Response < ApplicationRecord
  # ---------------------------------------- Associations

  belongs_to :property, touch: true
end
