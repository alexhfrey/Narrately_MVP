class ProjectsController < ApplicationController
  def new
	@user = User.find(params[:user_id])
	@project = @user.projects.build
	params[:user_id] = params[:user_id]
  end

  def create
	@user = User.find(params[:project][:user_id])
	@project = @user.projects.build(params[:project])
	
	if @project.save
		render :confirmation
	else 
	
	render 'new'
	end
  end

  def show
  @project = Project.find(params[:id])
  
  end
  
  def confirmation
  end

end
