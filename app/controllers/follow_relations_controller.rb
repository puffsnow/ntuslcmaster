class FollowRelationsController < ApplicationController
  #before_action :authenticate_user!
  #before_action :authenticate_member

  def show
    member = Member.find(params[:id])
    contact_comment = ContactComment.select(:all_activities, :none_activities, :activity_comment, :contact_comment).where({member_id: member.id}).first
    activities = member.activities.select(:name)
    contacts = member.contacts.select(:name)

    response = Hash.new
    response["contact_comment"] = contact_comment
    response["activities"] = activities
    response["contacts"] = contacts
    response["success"] = true
    render :json => { response: response }
  end

  def create
    member = current_user.member
    follow_id = params[:follow_id].to_i
    follow_member = Member.find(follow_id)
    follow_relation = member.follow_relations.where(follow_id: follow_id)
    return render_error_message("您已經在追蹤此社員") if follow_relation.length > 0
    follow_relation = FollowRelation.new
    follow_relation.member_id = member.id
    follow_relation.follow_id = follow_id
    follow_relation.save

    log_description = "member create follow relation with " + params[:follow_id]
    Log.create({user_id: current_user.id, description: log_description})

    response = Hash.new
    response["success"] = true
    response["contact_comment"] = follow_member.contact_comment if follow_member.user != nil
    render :json => { response: response }
  end

  def destroy
    member = current_user.member
    FollowRelation.where({member_id: member.id, follow_id: params[:id].to_i}).first.destroy

    log_description = "member destroy follow relation with " + params[:id]
    Log.create({user_id: current_user.id, description: log_description})

    render_success
  end
  
end
