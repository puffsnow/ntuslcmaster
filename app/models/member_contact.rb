class MemberContact < ActiveRecord::Base
  belongs_to  :member, :class_name => 'Member', dependent: :destroy
  belongs_to  :contact, :class_name => 'Contact', dependent: :destroy

end