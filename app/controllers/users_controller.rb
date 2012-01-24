class UsersController < ApplicationController
  def new
  @user = User.new
  end

  def create
  @user = User.new(params[:user])
  if @user.save
	redirect_to :controller => 'projects', :action => 'new', :user_id => @user.id

  else
	render 'new'
  end
  end

  def show
  @user = User.find(params[:id])
  end

end
