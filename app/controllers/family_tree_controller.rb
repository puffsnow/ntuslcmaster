class FamilyTreeController < ApplicationController
  def index
    @all_members = Member.all
    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end
end
