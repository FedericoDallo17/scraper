class CreateSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :searches do |t|
      t.string :name, null: false
      t.string :notes
      t.references :user, null: false, foreign_key: true
      t.boolean :active, null: false, default: true
      t.references :searchable, null: false, polymorphic: true

      t.timestamps
    end
  end
end
