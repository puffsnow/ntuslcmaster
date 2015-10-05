class UserContactOption < ActiveRecord::Base
  belongs_to  :user, :class_name => 'User', dependent: :destroy
  belongs_to  :contact_option, :class_name => 'ContactOption', dependent: :destroy

end