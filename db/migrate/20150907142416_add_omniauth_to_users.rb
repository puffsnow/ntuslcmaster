class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_index :users, :provider
    add_column :users, :uid, :string
    add_index :users, :uid
    remove_column :users, :fb_id, :string
    add_column :users, :url, :string
    add_column :users, :image, :string
  end
end
