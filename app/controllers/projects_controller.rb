class ProjectsController < ApplicationController
  def new
	@user = current_user
	@project = @user.projects.build
	
  end

  def create
	@user = current_user
	@project = @user.projects.build(params[:project])
	
	if @project.save
		flash[:success] = "Thanks for your submission!"
		render :confirmation
	else 
		flash[:error] = "A few minor issues..."
		render 'new'
	end
  end

  def show
  @project = Project.find(params[:id])
  @creator = @project.user
  # for testing purposes
  if @project.promotion_limit.nil?
	@project.promotion_limit = 10
  end
  ###
   
  
  @promotions_left = @project.promotion_limit - Shares.find_all_by_project_id(@project.id).length
  @promotions_clear = ( @promotions_left > 0 )
  
  if current_user 
	@promotions_clear = (@promotions_clear && Shares.find_by_user_id_and_project_id(current_user.id, @project.id).nil?  )
	else
  end
 end
  def confirmation
  end

end
