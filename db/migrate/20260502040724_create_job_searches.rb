class CreateJobSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :job_searches do |t|
      t.string :query, null: false
      t.integer :salary_min
      t.integer :salary_max
      t.string :seniority
      t.string :mode

      t.timestamps
    end
  end
end
