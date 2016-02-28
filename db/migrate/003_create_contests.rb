class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name, null: false
      t.text :message, default: '', null: false
      t.integer :owner_id

      t.index :owner_id

      t.timestamps null: false
    end
  end
end
