class CreateContactsAndMemberContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string  :name, null: false

      t.timestamps null: false
    end

    create_table :member_contacts, id: false do |t|
      t.integer  :member_id, null: false
      t.integer  :contact_id, null: false
      t.string   :account

      t.timestamps null: false
    end
  end
end
