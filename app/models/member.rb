class Member < ActiveRecord::Base
  has_many :master_relations, :foreign_key => "apprentice_id", :class_name => "Relation", :dependent => :destroy
  has_many :masters, :through => :master_relations
  has_many :apprentice_relations, :foreign_key => "master_id", :class_name => "Relation", :dependent => :destroy
  has_many :apprentices, :through => :apprentice_relations
end
