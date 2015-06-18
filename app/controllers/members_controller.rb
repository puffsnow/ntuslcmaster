class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
    @member = current_user.member
    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end

  def admin
    
  end

  def create

  end

  def update

  end

  def destroy

  end

end
