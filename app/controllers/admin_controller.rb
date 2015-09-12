class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @member_registers = MemberRegister.pending
  end

  def create_member
    render_error_message("輸入級別有問題") if params["grade"].to_i < 50
    render_error_message("輸入姓名有問題") if params["name"].nil? || params["name"].empty?
    member = Member.new
    member.grade = params["grade"].to_i
    member.name = params["name"]
    member.save
    render_error_message("建立社員時發生錯誤，請洽詢管理員") if member.id.nil?

    render_success
  end

  def accept_register
    member_register = MemberRegister.find(params[:id])
    return render_error_message("這個申請不存在") if member_register.nil? || member_register.is_accept != nil
    user = member_register.user
    return render_error_message("這個用戶已經有其他社員身份") if user.member != nil
    if member_register.member_id.nil?
      member = Member.new
      member.grade = member_register.grade
      member.name = member_register.name
      member.save
      user.member = member
      user.save
    else
      user.member = Member.find(member_register.member_id)
      user.save
    end
    member_register.is_accept = true
    member_register.admin_user_id = current_user.id
    member_register.save

    render_success
  end

  def reject_register
    member_register = MemberRegister.find(params[:id])
    return render_error_message("這個申請不存在") if member_register.nil? || member_register.is_accept != nil
    member_register.is_accept = false
    member_register.admin_user_id = current_user.id
    member_register.save

    render_success
  end

  private

  def authenticate_admin
    if current_user.is_admin == false
      respond_to do |format|
        format.html { redirect_to "/members/index" }
        format.json { render_error_message "You don't have access" }
      end
      return false
    end
  end
end
