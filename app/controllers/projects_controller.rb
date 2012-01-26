class ProjectsController < ApplicationController
  def new
	@user = current_user
	@project = @user.projects.build
	
  end

  def create
	@user = current_user
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
