class Member < ActiveRecord::Base
  has_many :master_relations, :foreign_key => "apprentice_id", :class_name => "Relation", :dependent => :destroy
  has_many :masters, :through => :master_relations
  has_many :apprentice_relations, :foreign_key => "master_id", :class_name => "Relation", :dependent => :destroy
  has_many :apprentices, :through => :apprentice_relations

  belongs_to  :user,  :class_name => 'User'

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
