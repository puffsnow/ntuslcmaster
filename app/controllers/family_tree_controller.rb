class FamilyTreeController < ApplicationController
  def index
    @all_members = Member.all
    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end


  def get_relations
    member_id = params[:member_id].to_i
    member = Member.find(member_id)

    response = Hash.new
    response["relations"] = get_member_relations(member_id)
    response["success"] = true
    render :json => { response: response }
  end

  private

  def get_member_relations(member_id)
    relations = []
    relations += get_master_relations(member_id, true)
    relations += get_apprentice_relations(member_id, true)
    relations
  end

  def get_master_relations(member_id, include_sub)
    relations = []
    member = Member.find(member_id)
    if include_sub == true
      relations += member.master_relations.where( {is_primary: false} )
    end
    primary_master_relations = member.master_relations.where( {is_primary: true} )
    relations += primary_master_relations
    primary_master_relations.each do |relation|
      relations += get_master_relations(relation.master_id, false)
    end
    relations
  end

  def get_apprentice_relations(member_id, include_sub)
    relations = []
    member = Member.find(member_id)
    if include_sub == true
      relations += member.apprentice_relations.where( {is_primary: false} )
    end
    primary_apprentice_relations = member.apprentice_relations.where( {is_primary: true} )
    relations += primary_apprentice_relations
    primary_apprentice_relations.each do |relation|
      relations += get_apprentice_relations(relation.apprentice_id, false)
    end
    relations
  end

end
