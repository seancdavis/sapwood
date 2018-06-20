class CreateViews < ActiveRecord::Migration[5.2]
  def up
    create_table :views do |t|
      t.string :title
      t.integer :property_id
      t.string :sort_by, default: 'updated_at'
      t.string :sort_in, default: 'desc'
      t.integer :nav_position, default: 0
      t.text :template_names, array: true, default: []
      t.jsonb :column_config, default: {}

      t.timestamps
    end

    Property.all.each do |property|
      property.views.create(title: 'Recent')

      property.templates.sort_by(&:title).each_with_index do |tmpl, idx|
        property.views.create(title: tmpl.title, nav_position: idx + 1, template_names: [tmpl.title])
      end
    end
  end

  def down
    drop_table :views
  end
end
