class UsersController < ApplicationController
	
  def new
  if current_user 
  redirect_to current_user
  end
  @identity = env['omniauth.identity']
	end
 
  def show
  @user = User.find(params[:id])
  @first_project = @user.projects.first
  @shares = @user.shares
  end

end
