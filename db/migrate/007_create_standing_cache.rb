class CreateStandingCache < ActiveRecord::Migration
  def change
    create_table :standing_caches do |t|
      t.string :user, null: false
      t.string :problem_type, null: false
      t.string :problem_id, null: false
      t.string :status, null: false
      t.datetime :submitted_at, null: false

      t.timestamps null: false
    end
    add_index :standing_caches, [:user, :problem_type, :problem_id], unique: true
  end
end
