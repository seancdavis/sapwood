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

require 'rails_helper'

RSpec.describe Collection, :type => :model do
end
