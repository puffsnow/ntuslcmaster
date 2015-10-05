class Activity < ActiveRecord::Base
  has_many :user_activities, :class_name => 'UserActivity', :foreign_key => 'activity_id'

end
