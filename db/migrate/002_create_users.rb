class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :poj_user
      t.string :aoj_user

      t.timestamps
    end
  end
end
