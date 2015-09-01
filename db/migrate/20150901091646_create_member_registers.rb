class CreateMemberRegisters < ActiveRecord::Migration
  def change
    create_table :member_registers do |t|
      t.integer :user_id, null: false
      t.integer :member_id
      t.integer :grade
      t.string  :name
      t.integer :admin_user_id
      t.boolean :accepted

      t.timestamps null: false
    end
  end
end
