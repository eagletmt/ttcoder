class CreateContestsUsers < ActiveRecord::Migration
  def change
    create_table :contests_users do |t|
      t.references :contest, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
