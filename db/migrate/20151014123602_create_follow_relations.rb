class CreateFollowRelations < ActiveRecord::Migration
  def change
    create_table :follow_relations, id: false do |t|
      t.integer :member_id, null: false
      t.integer :follow_id, null: false

      t.timestamps null: false
    end
  end
end
