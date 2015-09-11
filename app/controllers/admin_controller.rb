class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to "/members/index" if current_user.is_admin == false
    @member_registers = MemberRegister.pending
  end

  def accept_register
    return render_error_message("您沒有這個權限") if current_user.is_admin == false
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
    return render_error_message("您沒有這個權限") if current_user.is_admin == false
    member_register = MemberRegister.find(params[:id])
    return render_error_message("這個申請不存在") if member_register.nil? || member_register.is_accept != nil
    member_register.is_accept = false
    member_register.admin_user_id = current_user.id
    member_register.save

    render_success
  end
end
