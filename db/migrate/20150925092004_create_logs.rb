class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.text    :description 

      t.timestamps null: false
    end
  end
end
