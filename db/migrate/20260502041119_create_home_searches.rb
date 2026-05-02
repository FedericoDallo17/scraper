class CreateHomeSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :home_searches do |t|
      t.integer :area_min
      t.integer :area_max
      t.integer :price_min
      t.integer :price_max
      t.integer :rooms

      t.timestamps
    end
  end
end
