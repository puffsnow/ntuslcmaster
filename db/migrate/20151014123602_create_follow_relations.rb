class CreateFollowRelations < ActiveRecord::Migration
  def change
    create_table :follow_relations do |t|
      t.integer :member_id, null: false
      t.integer :follow_id, null: false

      t.timestamps null: false
    end

    add_index(:follow_relations, [:member_id, :follow_id], :unique => true)
  end
end
