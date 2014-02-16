class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.text :message, default: ''
      t.integer :owner_id

      t.index :owner_id

      t.timestamps
    end
  end
end
