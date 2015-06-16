class Relation < ActiveRecord::Base
  belongs_to :master, :class_name => "Member", :foreign_key => "master_id"
  belongs_to :apprentice, :class_name => "Member", :foreign_key => "apprentice_id"
end
