class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, null: false, index: true
      t.references :target, null: false, index: true, polymorphic: true
      t.integer :kind, null: false
      t.text :parameters
      t.timestamps
    end
  end
end
