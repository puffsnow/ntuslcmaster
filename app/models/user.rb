class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  extend OmniauthCallbacks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_one :member, :class_name => 'Member', :foreign_key => 'user_id'
  has_many :member_registers, :class_name => 'MemberRegister', :foreign_key => 'user_id'
  has_many :user_activities, :class_name => 'UserActivity', :foreign_key => 'user_id'
  has_many :user_contacts, :class_name => 'UserContact', :foreign_key => 'user_id'
  has_one :contact_comment, :class_name => 'ContactComment', :foreign_key => 'user_id'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      user.url = auth.info.urls.Facebook
    end
  end
end
