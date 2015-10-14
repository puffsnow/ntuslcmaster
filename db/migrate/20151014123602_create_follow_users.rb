class CreateFollowUsers < ActiveRecord::Migration
  def change
    create_table :follow_users, id: false do |t|
      t.integer :user_id, null: false
      t.integer :follow_id, null: false

      t.timestamps null: false
    end
  end
end
