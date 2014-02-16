class AddOmniauthProviderTwitter < ActiveRecord::Migration
  def change
    create_table(:twitter_users, id: false, primary_key: :uid) do |t|
      t.string :uid, null: false
      t.string :name, null: false
      t.string :token, null: false
      t.string :secret, null: false
      t.references :user, null: false
    end
  end
end
