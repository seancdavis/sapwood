class Key < ApplicationRecord

  # ---------------------------------------- | Associations

  belongs_to :property

  # ---------------------------------------- | Validations

  validates_presence_of :title, :encrypted_value

  # ---------------------------------------- | Callbacks

  before_validation :set_encrypted_value

  # ---------------------------------------- | Instance Methods

  def generate_value!
    self.value = SecureRandom.hex(32)
  end

  def readable?
    !writeable?
  end

  def value
    @value ||= begin
      return nil if encrypted_value.blank? || crypt.blank?
      crypt.decrypt_and_verify(encrypted_value)
    end
  end

  def value=(v)
    @value = v
  end

  # ---------------------------------------- | Private Methods

  private

  def set_encrypted_value
    return false if crypt.blank? || value.blank?
    self.encrypted_value = crypt.encrypt_and_sign(value)
  end

  def crypt
    @crypt ||= begin
      return nil if ENV['API_ENCRYPTION_KEY'].blank? || ENV['API_ENCRYPTION_SALT'].blank?
      key_gen = ActiveSupport::KeyGenerator.new(ENV['API_ENCRYPTION_KEY'])
      key = key_gen.generate_key(ENV['API_ENCRYPTION_SALT'], 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
    end
  end

end
