# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  position      :integer          default(0)
#  body          :text
#  template_data :json
#  ancestry      :string
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :element do
    title "MyString"
slug "MyString"
property_id 1
template_name "MyString"
position 1
body "MyText"
template_data ""
ancestry "MyString"
publish_at "2016-01-16 16:15:28"
  end

end
