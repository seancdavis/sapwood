class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :title
      t.string :url
      t.integer :property_id

      t.timestamps
    end
  end
end
