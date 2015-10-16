class Member < ActiveRecord::Base
  has_many :master_relations, :foreign_key => "apprentice_id", :class_name => "Relation", dependent: :destroy
  has_many :masters, :through => :master_relations
  has_many :apprentice_relations, :foreign_key => "master_id", :class_name => "Relation", dependent: :destroy
  has_many :apprentices, :through => :apprentice_relations

  belongs_to  :user,  :class_name => 'User'

  has_many :member_activities, :class_name => 'MemberActivity', :foreign_key => 'member_id'
  has_many :activities, :through => :member_activities
  has_many :member_contacts, :class_name => 'MemberContact', :foreign_key => 'member_id'
  has_many :contacts, :through => :member_contacts
  has_one :contact_comment, :class_name => 'ContactComment', :foreign_key => 'member_id'

  has_many :follow_relations, :foreign_key => "member_id", :class_name => "FollowRelation", dependent: :destroy
  has_many :follows, :through => :follow_relations
  has_many :follower_relations, :foreign_key => "follow_id", :class_name => "FollowRelation", dependent: :destroy
  has_many :followers, :through => :follower_relations

  def self.search str
    grade = str.to_i
    if grade > 0
      members = Member.select(:id, :name, :grade).where("grade = ?", str)
    else
      members = Member.select(:id, :name, :grade).where("name like ?", "%" + str + "%")
    end
    return members
  end

end
