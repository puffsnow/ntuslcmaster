class MembersController < ApplicationController
  before_action :authenticate_user!, except: :search

  def index
    @member = current_user.member

    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end

  def admin
    
  end



  def create

  end

  def link

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

end
