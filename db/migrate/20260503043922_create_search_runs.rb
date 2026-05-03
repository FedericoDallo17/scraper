class CreateSearchRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :search_runs do |t|
      t.references :search, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true

      t.datetime :started_at
      t.datetime :finished_at

      t.string :status, null: false, index: true
      t.integer :results_count
      t.string :error_class
      t.string :error_message

      t.timestamps
    end
  end
end
