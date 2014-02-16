class CreateAojSubmissions < ActiveRecord::Migration
  def change
    create_table :aoj_submissions do |t|
      t.integer :run_id
      t.string :user_id
      t.string :problem_id
      t.datetime :submission_date
      t.string :status
      t.string :language
      t.integer :cputime
      t.integer :memory
      t.integer :code_size

      t.index :run_id
      t.index :user_id
      t.index :problem_id
      t.index :submission_date

      t.timestamps
    end
  end
end
