# frozen_string_literal: true

class CreateElementAssociations < ActiveRecord::Migration

  def change
    create_table :element_associations do |t|
      t.integer :source_id
      t.integer :target_id

      t.timestamps null: false
    end

    Element.all.each { |e| e.update! }
  end

end
