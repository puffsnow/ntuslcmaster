class MembersController < ApplicationController
  before_action :authenticate_user!, except: :search
  before_action :get_grades

  def index
    @member = current_user.member
    redirect_to action: 'sign_up' if @member.nil?
  end

  def sign_up

  end

  def admin
    
  end



  def create

  end

  def link
    member_id = params[:member_id].to_i
    member_registers = current_user.member_registers
    member = Member.find(member_id)
    response = Hash.new
    if current_user.member != nil
      response["success"] = false
      response["message"] = "您已經擁有社員身份，無法再申請"
    elsif member_registers.any? { |register| register.accepted.nil? }
      response["success"] = false
      response["message"] = "您已經有一份申請正等待管理員核可"
    elsif member.nil?
      response["success"] = false
      response["message"] = "您申請的社員不存在，請再確認"
    elsif member.user_id != nil && member.user_id > 0
      response["success"] = false
      response["message"] = "您申請的社員已經被註冊，請再確認"
    else
      member_register = current_user.member_registers.create(member_id: member_id)
      if member_register != nil
        response["success"] = true
      else
        response["success"] = false
        response["message"] = "系統錯誤，請向管理員確認"
      end
    end
    render :json => { response: response }
  end

  def create_and_link

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

end
