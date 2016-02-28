class CreatePojSubmissions < ActiveRecord::Migration
  def change
    create_table :poj_submissions do |t|
      t.string :user, null: false
      t.integer :problem_id, null: false
      t.string :result, null: false
      t.integer :memory
      t.integer :time
      t.string :language, null: false
      t.integer :length, null: false
      t.datetime :submitted_at, null: false

      t.timestamps null: false

      t.index :user
      t.index :problem_id
      t.index :submitted_at
    end
  end
end
