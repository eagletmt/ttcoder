class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :poj_user, null: false
      t.string :aoj_user, null: false

      t.timestamps null: false
    end
  end
end
