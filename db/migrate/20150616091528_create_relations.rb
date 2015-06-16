class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :master_id, null: false
      t.integer :apprentice_id, null: false
      t.boolean :is_primary, null: false

      t.timestamps null: false
    end

    add_index :relations, [:master_id, :apprentice_id], unique: true
  end
end
