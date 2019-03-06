class DeleteSortId < ActiveRecord::Migration
  def change
    remove_column :members, :sort_id
  end
end
