class MemberRegister < ActiveRecord::Base
  belongs_to  :user, :class_name => 'User'

  scope :pending, -> { where(accepted: nil) }

end
