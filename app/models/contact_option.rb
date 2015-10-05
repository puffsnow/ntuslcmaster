class ContactOption < ActiveRecord::Base
  has_many :user_contact_options, :class_name => 'UserContactOption', :foreign_key => 'contact_option_id'

end
