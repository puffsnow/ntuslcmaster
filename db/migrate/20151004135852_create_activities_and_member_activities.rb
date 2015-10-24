class CreateActivitiesAndMemberActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string  :name, null: false

      t.timestamps null: false
    end

    create_table :member_activities do |t|
      t.integer  :member_id, null: false
      t.integer  :activity_id, null: false

      t.timestamps null: false
    end

    add_index(:member_activities, [:member_id, :activity_id], :unique => true)
  end
end
