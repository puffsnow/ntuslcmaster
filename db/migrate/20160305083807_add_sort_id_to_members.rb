class AddSortIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :sort_id, :integer
    Member.all.each do |member|
      member.sort_id = member.id
      member.save
    end
    change_column :members, :sort_id, :integer, :null => false
  end
end
