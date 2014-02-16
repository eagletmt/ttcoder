class CreateSiteProblems < ActiveRecord::Migration
  def up
    create_table :contests_site_problems do |t|
      t.references :contest
      t.references :site_problem
      t.integer :position
    end

    create_table :site_problems do |t|
      t.string :site, null: false
      t.string :problem_id, null: false

      t.index [:site, :problem_id], unique: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
