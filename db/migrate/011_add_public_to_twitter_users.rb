class AddPublicToTwitterUsers < ActiveRecord::Migration
  def change
    add_column :twitter_users, :public, :boolean, default: false, null: false
  end
end
