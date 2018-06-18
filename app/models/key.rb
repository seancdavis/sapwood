class Key < ApplicationRecord

  class << self
    def encryptable?
      encryption_key.present? && encryption_salt.present? && encryption_iv.present?
    end

    def encryption_key
      Base64.decode64(ENV['API_ENCRYPTION_KEY'])
    end

    def encryption_iv
      Base64.decode64(ENV['API_ENCRYPTION_IV'])
    end

    def encryption_salt
      Base64.decode64(ENV['API_ENCRYPTION_SALT'])
    end
  end

  # ---------------------------------------- | Attributes

  attr_writer :value

  # ---------------------------------------- | Associations

  belongs_to :property

  # ---------------------------------------- | Validations

  validates_presence_of :title, :encrypted_value

  # ---------------------------------------- | Callbacks

  before_validation :set_encrypted_value

  # ---------------------------------------- | Class Methods

  def self.find_by_value(value)
    encrypted_value = Encryptor.encrypt(
      value: value,
      key: Key.encryption_key,
      iv: Key.encryption_iv,
      salt: Key.encryption_salt
    )
    find_by(encrypted_value: Base64.encode64(encrypted_value))
  end

  # ---------------------------------------- | Instance Methods

  def generate_value!
    self.value = SecureRandom.hex(32)
  end

  def readable?
    !writeable?
  end

  def value
    @value ||= begin
      return nil if encrypted_value.blank? || !encryptable?
      Encryptor.decrypt(
        value: Base64.decode64(encrypted_value),
        key: Key.encryption_key,
        iv: Key.encryption_iv,
        salt: Key.encryption_salt
      )
    end
  end

  # ---------------------------------------- | Private Methods

  private

  def set_encrypted_value
    return false unless encryptable?
    encrypted_value = Encryptor.encrypt(
      value: value,
      key: Key.encryption_key,
      iv: Key.encryption_iv,
      salt: Key.encryption_salt
    )
    self.encrypted_value = Base64.encode64(encrypted_value)
  end

  def encryptable?
    Key.encryptable? && value.present?
  end

end
