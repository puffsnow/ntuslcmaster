class UserContact < ActiveRecord::Base
  belongs_to  :user, :class_name => 'User', dependent: :destroy
  belongs_to  :contact, :class_name => 'Contact', dependent: :destroy

end