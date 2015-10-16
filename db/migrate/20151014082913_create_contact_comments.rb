class CreateContactComments < ActiveRecord::Migration
  def change
    create_table :contact_comments do |t|
      t.integer :member_id, null: false
      t.boolean :all_activities, null: false
      t.boolean :none_activities, null: false
      t.text  :activity_comment
      t.text  :contact_comment

      t.timestamps null: false
    end
  end
end
