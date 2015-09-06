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
      @member = Member.find(@member_register.member_id)
      @no_await_register = false
    end
  end

  def admin
    
  end



  def create

  end

  def register
    member_id = params[:member_id].to_i if params[:member_id] != nil
    grade = params[:grade].to_i if params[:grade] != nil && params[:grade].to_i > 0
    name = params[:name] if params[:name] != nil
    member_registers = current_user.member_registers

    if member_id != nil && member_id > 0
      render_error_message("您已經擁有社員身份，無法再申請") if current_user.member != nil
      render_error_message("您已經有一份申請正等待管理員核可") if member_registers.any? { |register| register.accepted.nil? }
      render_error_message("您申請的社員不存在，請再確認") if member.nil?
      render_error_message("您申請的社員已經被註冊，請再確認") if member.user_id != nil && member.user_id > 0

      member_register = current_user.member_registers.create(member_id: member_id)
      render_error_message("系統錯誤，請向管理員確認") if member_register.nil?      
    else
      render_error_message("您輸入的級別有問題，請再確認") if grade <= 50 
      render_error_message("您輸入的姓名有問題，請再確認") if name.nil? || name == ""

      member_register = current_user.member_registers.create(grade: grade, name: name)
      render_error_message("系統錯誤，請向管理員確認") if member_register.nil?
    end

    response = Hash.new
    response["success"] = true

    render :json => { response: response }
  end

  def update

  end

  def destroy

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

end
