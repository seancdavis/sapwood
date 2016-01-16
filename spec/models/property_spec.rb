# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  title      :string
#  config     :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Property, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
