class MembersController < ApplicationController
  before_action :authenticate_user!, except: :search

  def index
    @member = current_user.member
    redirect_to action: 'sign_up' if @member.nil?
  end

  def sign_up
    @no_await_register = true
    @member_registers = current_user.member_registers
    if @member_registers.any? { |register| register.is_accept.nil? }
      @pending_member_register = @member_registers.select{ |register| register.is_accept.nil? }.first
      @member = Member.find(@pending_member_register.member_id) if @pending_member_register.member_id != nil
      @no_await_register = false
    end
  end

  def register
    member_id = params[:member_id].to_i if params[:member_id] != nil
    grade = params[:grade].to_i if params[:grade] != nil && params[:grade].to_i > 0
    name = params[:name] if params[:name] != nil
    member_registers = current_user.member_registers

    if member_id != nil && member_id > 0
      member = Member.find(member_id)
      return render_error_message("您已經擁有社員身份，無法再申請") if current_user.member != nil
      return render_error_message("您已經有一份申請正等待管理員核可") if member_registers.any? { |register| register.is_accept.nil? }
      return render_error_message("您申請的社員不存在，請再確認") if member.nil?
      return render_error_message("您申請的社員已經被註冊，請再確認") if member.user_id != nil && member.user_id > 0

      member_register = current_user.member_registers.create(member_id: member_id)
      return render_error_message("系統錯誤，請向管理員確認") if member_register.nil?      
    else
      return render_error_message("您輸入的級別有問題，請再確認") if grade <= 50 
      return render_error_message("您輸入的姓名有問題，請再確認") if name.nil? || name == ""

      member_register = current_user.member_registers.create(grade: grade, name: name)
      return render_error_message("系統錯誤，請向管理員確認") if member_register.nil?
    end

    render_success
  end

  def search
    str = params[:str]
    members = Member.search(str)
    render :json => { members: members }
  end

end
