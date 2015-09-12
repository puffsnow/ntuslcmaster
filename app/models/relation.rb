class Relation < ActiveRecord::Base
  belongs_to :master, :class_name => "Member"
  belongs_to :apprentice, :class_name => "Member"
end
