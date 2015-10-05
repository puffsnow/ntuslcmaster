class Activity < ActiveRecord::Base
  has_many :user_activities, :class_name => 'User_Activity', :foreign_key => 'activity_id'
  
end
