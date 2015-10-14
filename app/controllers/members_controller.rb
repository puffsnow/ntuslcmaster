class MembersController < ApplicationController
  before_action :authenticate_user!, except: :search
  before_action :authenticate_member, except: [:search, :index, :sign_up, :register]

  def index
    @member = current_user.member
    redirect_to action: 'sign_up' if @member.nil?
    @all_activties = Activity.all
    @all_contacts = Contact.all
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

  def update_relation
    member_id = params[:member_id].to_i if params[:member_id] != nil
    type = params[:type].to_i
    return render_error_message("您未選擇社員或社員不存在") if member_id == 0
    member = Member.find_by_id(member_id)
    member_self = current_user.member
    return render_error_message("您未選擇社員或社員不存在") if member.nil?
    if member.grade < member_self.grade
      master_id = member.id
      apprentice_id = member_self.id
    elsif member.grade > member_self.grade
      master_id = member_self.id
      apprentice_id = member.id
    else
      return render_error_message("同級別的社員不存在師徒關係")
    end
    
    relation = Relation.where("master_id = ? AND apprentice_id = ?", master_id, apprentice_id).first
    if relation.nil? && type > 0
      relation = Relation.new
      relation.master_id = master_id
      relation.apprentice_id = apprentice_id
      relation.is_primary = type == 1 ? true : false
      relation.save
    elsif relation != nil && type == 0
      relation.delete
    elsif relation != nil
      relation.is_primary = type == 1 ? true : false
      relation.save
    end

    log_description = "member update relation with member " + member.id.to_s + " with type " + params[:type]
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def update_contact
    activities = params[:activities].nil? ? [] : params[:activities].map{|x| x.to_i}
    contacts = params[:contacts].nil? ? [] : params[:contacts].map{|x| x.to_i} 

    contact_comment = current_user.contact_comment
    contact_comment = ContactComment.new and contact_comment.user_id = current_user.id if contact_comment.nil?
    contact_comment.activity_comment = params[:activity_comment]
    contact_comment.contact_comment = params[:contact_comment]
    contact_comment.all_activities = activities.index(10000).nil? ? false : true
    contact_comment.none_activities = activities.index(0).nil? ? false : true
    contact_comment.save

    UserActivity.where(user_id: current_user.id).delete_all
    UserContact.where(user_id:current_user).delete_all

    activities.each do |activity_id|
      next if activity_id == 10000 || activity_id == 0
      UserActivity.create(user_id: current_user.id, activity_id: activity_id)
    end

    contacts.each do |contact_id|
      UserContact.create(user_id: current_user.id, contact_id: contact_id)
    end

    log_description = "user update contact data"
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def search
    str = params[:str]
    members = Member.search(str)
    render :json => { members: members }
  end

  private

  def authenticate_member
    if current_user.member.nil?
      respond_to do |format|
        format.html { redirect_to "/members/index" }
        format.json { render_error_message "您尚未被認證為社員，不允許進行這項操作" }
      end
      return false
    end
  end

end
