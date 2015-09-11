class MembersController < ApplicationController
  before_action :authenticate_user!, except: :search
  before_action :get_grades

  def index
    @member = current_user.member
    redirect_to action: 'sign_up' if @member.nil?
  end

  def sign_up
    @no_await_register = true
    member_registers = current_user.member_registers
    if member_registers.any? { |register| register.accepted.nil? }
      @member_register = member_registers.select{ |register| register.accepted.nil? }.first
      @member = Member.find(@member_register.member_id) if @member_register.member_id != nil
      @no_await_register = false
    end
  end

  def admin
    redirect_to action: 'index' if current_user.is_admin == false
    @member_registers = MemberRegister.pending
  end



  def create

  end

  def update

  end

  def destroy

  end 

  def register
    member_id = params[:member_id].to_i if params[:member_id] != nil
    grade = params[:grade].to_i if params[:grade] != nil && params[:grade].to_i > 0
    name = params[:name] if params[:name] != nil
    member_registers = current_user.member_registers

    if member_id != nil && member_id > 0
      member = Member.find(member_id)
      return render_error_message("您已經擁有社員身份，無法再申請") if current_user.member != nil
      return render_error_message("您已經有一份申請正等待管理員核可") if member_registers.any? { |register| register.accepted.nil? }
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

  def accept
    return render_error_message("您沒有這個權限") if current_user.is_admin == false
    member_register = MemberRegister.find(params[:id])
    return render_error_message("這個申請不存在") if member_register.nil? || member_register.accept != nil
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

  def reject
    return render_error_message("您沒有這個權限") if current_user.is_admin == false
    member_register = MemberRegister.find(params[:id])
    return render_error_message("這個申請不存在") if member_register.nil? || member_register.accept != nil
    member_register.is_accept = false
    member_register.admin_user_id = current_user.id
    member_register.save

    render_success
  end

  def search
    str = params[:str]
    members = Member.search(str)
    render :json => { members: members }
  end

  private

  def get_grades
    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end

  def render_error_message(message)
    response = Hash.new
    response["success"] = false
    response["message"] = message
    render :json => { response: response }
  end

  def render_success
    response = Hash.new
    response["success"] = true
    render :json => { response: response }
  end

end
