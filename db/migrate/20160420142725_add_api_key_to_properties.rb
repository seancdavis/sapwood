# frozen_string_literal: true

class AddApiKeyToProperties < ActiveRecord::Migration

  def change
    add_column :properties, :api_key, :string

    Property.reset_column_information

    Property.all.each { |p| p.generate_api_key! }
  end

end
