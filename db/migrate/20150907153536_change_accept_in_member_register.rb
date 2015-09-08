class ChangeAcceptInMemberRegister < ActiveRecord::Migration
  def change
    rename_column :member_registers, :accepted, :is_accept
  end
end
