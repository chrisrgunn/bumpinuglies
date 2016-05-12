class UsersController < ApplicationController#Devise::Registrations#
  def show
#     @user = User.find(params[:id])
  end

  def new
    super
#     @user = User.new

    @user.CustomStatement.create(:statement => "Is first", :importance => 0, :degree_of_truth => 0)

    pust "called new in UsersController!"
  end
end

