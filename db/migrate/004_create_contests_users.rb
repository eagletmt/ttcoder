class CreateContestsUsers < ActiveRecord::Migration
  def change
    create_table :contests_users do |t|
      t.references :contest, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
