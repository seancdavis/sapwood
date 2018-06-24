class CreateViews < ActiveRecord::Migration[5.2]
  def up
    create_table :views do |t|
      t.string :title
      t.string :slug
      t.integer :property_id
      t.string :q
      t.integer :nav_position, default: 0
      t.jsonb :column_config, default: {}

      t.timestamps
    end

    Property.all.each do |property|
      property.views.create(title: 'Recent')

      property.templates.sort_by(&:title).each_with_index do |tmpl, idx|
        property.views.create(title: tmpl.title, nav_position: idx + 1, q: "template:#{tmpl.title}")
      end
    end
  end

  def down
    drop_table :views
  end
end