# frozen_string_literal: true

class DropResponses < ActiveRecord::Migration[5.2]

  def change
    drop_table :responses
  end

end
