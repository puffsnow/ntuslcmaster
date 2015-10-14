class FollowRelation < ActiveRecord::Base
  belongs_to :follow, :foreign_key => "user_id", :class_name => "User"
  belongs_to :follower, :foreign_key => "follow_id", :class_name => "User"
end
