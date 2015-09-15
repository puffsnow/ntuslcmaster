class Relation < ActiveRecord::Base
  belongs_to :master, :foreign_key => "master_id", :class_name => "Member"
  belongs_to :apprentice, :foreign_key => "apprentice_id", :class_name => "Member"
end
