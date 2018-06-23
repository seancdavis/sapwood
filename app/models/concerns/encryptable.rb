module Encryptable

  extend ActiveSupport::Concern

  included do

    # ---------------------------------------- | Attributes

    attr_writer :value

    # ---------------------------------------- | Callbacks

    before_validation :set_encrypted_value

    # ---------------------------------------- | Instance Methods

    def value
      @value ||= begin
        return nil if encrypted_value.blank? || !Key.encryptable?
        self.class.decrypt_value(encrypted_value)
      end
    end

    # ---------------------------------------- | Private Methods

    private

      def set_encrypted_value
        return false unless self.class.encryptable? && value.present?
        self.encrypted_value = self.class.encrypt_value(value)
      end

  end

  class_methods do

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

    def encryptable_options
      { key: Key.encryption_key, iv: Key.encryption_iv, salt: Key.encryption_salt }
    end

    def encrypt_value(value)
      Base64.encode64(Encryptor.encrypt(encryptable_options.merge(value: value)))
    end

    def decrypt_value(value)
      Encryptor.decrypt(encryptable_options.merge(value: Base64.decode64(value)))
    end

    def find_by_value(value)
      find_by(encrypted_value: encrypt_value(value))
    end

  end

end
