class MigrateFromActsAsTaggableOn < ActiveRecord::Migration
  def change
    change_table :taggings do |t|
      t.rename :taggable_id, :site_problem_id
    end
  end
end
