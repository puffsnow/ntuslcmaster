class MemberActivity < ActiveRecord::Base
  belongs_to  :member, :class_name => 'Member', dependent: :destroy
  belongs_to  :activity, :class_name => 'Activity', dependent: :destroy

end