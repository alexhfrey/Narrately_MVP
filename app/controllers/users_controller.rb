class UsersController < ApplicationController
	
  def new
  @identity = env['omniauth.identity']
	end
 
  def show
  @user = User.find(params[:id])
  end

end
