class CreateContactOptionsAndUserContactOptions < ActiveRecord::Migration
  def change
    create_table :contact_options do |t|
      t.string  :name, null: false

      t.timestamps null: false
    end

    create_table :user_contact_options do |t|
      t.integer  :user_id, null: false
      t.integer  :contact_option_id, null: false
      t.string   :account
      t.boolean  :is_used, null: false

      t.timestamps null: false
    end
  end
end
