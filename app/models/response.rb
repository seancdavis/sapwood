class Response < ApplicationRecord

  # ---------------------------------------- Associations

  belongs_to :property, :touch => true

end
