class UsersController < ApplicationController
	
  def new
	if current_user 
		redirect_to current_user
	end
	@identity = env['omniauth.identity']
  end
 
  def show
	@user = User.find(params[:id])
	@projects = @user.projects
	@shares = @user.shares
  end
  
  def edit
  @user = current_user
  end
  
  def update
  @user = current_user
  if @user.update_attributes(params[:user])
    flash[:notice] = "Successfully updated user."
	redirect_to @user
  end

end
end
