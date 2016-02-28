class CreateCodeforcesSubmissions < ActiveRecord::Migration
  def change
    create_table :codeforces_submissions do |t|
      t.string :problem_id, null: false
      t.string :handle, null: false
      t.datetime :submission_time, null: false
      t.string :verdict, null: false
      t.string :programming_language, null: false
      t.integer :time_consumed_millis, null: false
      t.integer :memory_consumed_bytes, null: false

      t.timestamps null: false

      t.index :handle
      t.index :problem_id
      t.index :submission_time
    end

    add_column :users, :codeforces_user, :string, null: false
  end
end
