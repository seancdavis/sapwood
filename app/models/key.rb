# frozen_string_literal: true

class Key < ApplicationRecord

  # ---------------------------------------- | Plugins

  include Encryptable

  # ---------------------------------------- | Associations

  belongs_to :property

  # ---------------------------------------- | Validations

  validates_presence_of :title, :encrypted_value

  # ---------------------------------------- | Instance Methods

  def generate_value!
    self.value = SecureRandom.hex(32)
  end

  def readable?
    !writable?
  end

end
