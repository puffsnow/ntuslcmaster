class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :grade, :null => false
      t.string  :name,  :null => false

      t.timestamps null: false
    end
  end
end
