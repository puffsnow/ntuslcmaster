class Contact < ActiveRecord::Base
  has_many :user_contacts, :class_name => 'UserContact', :foreign_key => 'contact_id'

end
