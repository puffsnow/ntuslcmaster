class FollowRelation < ActiveRecord::Base
  belongs_to :follow, :foreign_key => "member_id", :class_name => "Member"
  belongs_to :follower, :foreign_key => "follow_id", :class_name => "User"
end
