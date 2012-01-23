class UsersController < ApplicationController
  def new
  @user = User.new
  end

  def create
  @user = User.new(params[:user])
  if @user.save
	flash("Success")
	redirect_to @user
  else
	render 'new'
  end
 
  
  end

  def show
  end

end
