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

require 'rails_helper'

RSpec.describe Response, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
