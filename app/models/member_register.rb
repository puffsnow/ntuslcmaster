class MemberRegister < ActiveRecord::Base
  belongs_to  :user, :class_name => 'User'

  scope :pending, -> { where(is_accept: nil) }

end
