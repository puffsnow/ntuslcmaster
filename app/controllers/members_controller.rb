class MembersController < ApplicationController
  before_action :authenticate_user!, except: :search

  def index
    @member = current_user.member
    redirect_to action: 'sign_up' if @member.nil?

    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end

  def sign_up

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
