class CreateCodeforcesSubmissions < ActiveRecord::Migration
  def change
    create_table :codeforces_submissions do |t|
      t.string :problem_id
      t.string :handle
      t.datetime :submission_time
      t.string :verdict
      t.string :programming_language
      t.integer :time_consumed_millis
      t.integer :memory_consumed_bytes

      t.timestamps

      t.index :handle
      t.index :problem_id
      t.index :submission_time
    end

    add_column :users, :codeforces_user, :string
  end
end
