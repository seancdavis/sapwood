# == Schema Information
#
# Table name: property_users
#
#  id          :integer          not null, primary key
#  property_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_admin    :boolean          default(FALSE)
#

class PropertyUser < ActiveRecord::Base

  # ---------------------------------------- Associations

  belongs_to :property
  belongs_to :user

end
