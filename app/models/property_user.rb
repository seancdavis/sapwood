class PropertyUser < ApplicationRecord

  # ---------------------------------------- Associations

  belongs_to :property
  belongs_to :user

end
