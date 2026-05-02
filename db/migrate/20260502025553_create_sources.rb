class CreateSources < ActiveRecord::Migration[8.1]
  def change
    create_table :sources do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :slug, null: false, index: { unique: true }
      t.string :base_url, null: false, index: { unique: true }
      t.string :kind, null: false, index: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
