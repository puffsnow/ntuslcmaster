class AdminController < ApplicationController
  #before_action :authenticate_user!
  #before_action :authenticate_admin

  def index
    @member_registers = MemberRegister.pending
    @activities = Activity.all
    @contacts = Contact.all
  end


  def create_member
    return render_error_message("輸入級別有問題") if params["grade"].to_i < 50
    return render_error_message("輸入姓名有問題") if params["name"].nil? || params["name"].empty?
    member = Member.new
    member.grade = params["grade"].to_i
    member.name = params["name"]
    member.save
    return render_error_message("建立社員時發生錯誤，請洽詢管理員") if member.id.nil?

    log_description = "admin create member " + member.id.to_s + " with name " + params["name"] + " and grade " + params["grade"]
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def update_member
    return render_error_message("輸入級別有問題") if params["grade"].to_i < 50
    return render_error_message("輸入姓名有問題") if params["name"].nil? || params["name"].empty?
    member = Member.find_by_id(params["member_id"].to_i)
    return render_error_message("無法找到您指定的社員") if member.nil?
    member.attributes = { grade: params["grade"].to_i, name: params["name"] }
    member.save

    log_description = "admin update member " + member.id.to_s + " with name " + params["name"] + " and grade " + params["grade"]
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def destroy_member
    return render_error_message("輸入有問題") if params["member_id"].nil? || params["member_id"].to_i <= 0
    member = Member.find_by_id(params["member_id"].to_i)
    return render_error_message("無法找到您指定的社員") if member.nil?
    member.destroy

    log_description = "admin destroy member " + member.id.to_s
    Log.create({user_id: current_user.id, description: log_description})
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

    log_description = "admin accept member register " + member_register.id.to_s
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def reject_register
    member_register = MemberRegister.find(params[:id])
    return render_error_message("這個申請不存在") if member_register.nil? || member_register.is_accept != nil
    member_register.is_accept = false
    member_register.admin_user_id = current_user.id
    member_register.save

    log_description = "admin reject member register " + member_register.id.to_s
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def update_relation
    master_id = params[:master_id].to_i
    apprentice_id = params[:apprentice_id].to_i
    type = params[:type].to_i
    return render_error_message("您未選擇社員或社員不存在") if master_id == 0 || apprentice_id == 0
    master = Member.find_by_id(master_id)
    apprentice = Member.find_by_id(apprentice_id)
    return render_error_message("您未選擇社員或社員不存在") if master.nil? || apprentice.nil?
    return render_error_message("師父的級別應要比徒弟大") if master.grade >= apprentice.grade
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

    log_description = "admin update member relation " + params[:master_id] + " - " + params["apprentice_id"] + " with type " + params[:type] 
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def create_activity
    name = params[:name]
    return render_error_message("您未輸入活動名稱") if name.nil? || name == ""
    Activity.create({name: name})

    log_description = "admin create activity " + name
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  def create_contact
    name = params[:name]
    return render_error_message("您未輸入聯繫方式名稱") if name.nil? || name == ""
    Contact.create({name: name})

    log_description = "admin create contact option " + name
    Log.create({user_id: current_user.id, description: log_description})
    render_success
  end

  private

  def authenticate_admin
    if current_user.is_admin == false
      respond_to do |format|
        format.html { redirect_to "/members/index" }
        format.json { render_error_message "你沒有管理員的權限" }
      end
      return false
    end
  end
end
