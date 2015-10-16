class Contact < ActiveRecord::Base
  has_many :member_contacts, :class_name => 'MemberContact', :foreign_key => 'contact_id'

end
