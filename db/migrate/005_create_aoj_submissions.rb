class CreateAojSubmissions < ActiveRecord::Migration
  def change
    create_table :aoj_submissions do |t|
      t.integer :run_id, null: false
      t.string :user_id, null: false
      t.string :problem_id, null: false
      t.datetime :submission_date, null: false
      t.string :status, null: false
      t.string :language, null: false
      t.integer :cputime, null: false
      t.integer :memory, null: false
      t.integer :code_size, null: false

      t.index :run_id
      t.index :user_id
      t.index :problem_id
      t.index :submission_date

      t.timestamps null: false
    end
  end
end
