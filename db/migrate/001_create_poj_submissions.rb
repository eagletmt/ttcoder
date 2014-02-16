class CreatePojSubmissions < ActiveRecord::Migration
  def change
    create_table :poj_submissions do |t|
      t.string :user
      t.integer :problem_id
      t.string :result
      t.integer :memory
      t.integer :time
      t.string :language
      t.integer :length
      t.datetime :submitted_at

      t.timestamps

      t.index :user
      t.index :problem_id
      t.index :submitted_at
    end
  end
end
