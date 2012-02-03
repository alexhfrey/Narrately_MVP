class ProjectsController < ApplicationController
  def new
	@user = current_user
	@project = @user.projects.build
	
  end
  
  def index
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
  if params[:referral] 
		session[:referral] = params[:referral]
  
  @project = Project.find(params[:id])
  @creator = @project.user
  @shares = @project.shares
  
  User.update_image(@creator)                   #for testing purposes
  # for testing purposes
  if @project.promotion_limit.nil?
	@project.promotion_limit = 10
  end
  ###
   
  
  @promotions_left = @project.promotion_limit - @shares.length
  @promotions_clear = ( @promotions_left > 0 )
  
  if current_user 
	@promotions_clear = (@promotions_clear && Share.find_by_user_id_and_project_id(current_user.id, @project.id).nil?  )
	else
  end
  
  ##Tweets
  @tweets = Twitter.search("narrately.com/projects/" + @project.id.to_s)
  
  
 end
  def confirmation
  end

end
