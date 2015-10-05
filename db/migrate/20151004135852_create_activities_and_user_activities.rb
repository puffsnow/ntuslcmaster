class CreateActivitiesAndUserActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string  :name, null: false

      t.timestamps null: false
    end

    create_table :user_activities do |t|
      t.integer  :user_id, null: false
      t.integer  :activity_id, null: false
      t.boolean  :is_contacted, null: false

      t.timestamps null: false
    end
  end
end
