class UserActivity < ActiveRecord::Base
  belongs_to  :user, :class_name => 'User', dependent: :destroy
  belongs_to  :activity, :class_name => 'Activity', dependent: :destroy

end