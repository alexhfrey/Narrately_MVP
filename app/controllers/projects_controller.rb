class ProjectsController < ApplicationController
  def new
	@user = current_user
	@project = @user.projects.build
	
  end
  
  def index
  end
  
  def edit
  end
  
  def update
  @project = Project.find(params[:id])

  if @project.update_attributes(:x1 => params[:x1], :y1 => params[:y1], :width => params[:width], :height => params[:height])
    flash[:notice] = "Successfully updated user."
   
  else
    render  'crop'
  end

  end
  def download
	@file_object = Project.find(params[:id])
	redirect_to @file_object.output_file.expiring_url(10)
  end
  def create
	@user = current_user
	@project = @user.projects.build(params[:project])
	
	if @project.save
		flash[:success] = "Thanks for your submission! Care to optimize your project image?"		
		redirect_to :action => 'crop', :id => @project.id
	else 
		flash[:error] = "A few minor issues..."
		render 'new'
	end
  end
  def crop
  @project = Project.find(params[:id])
  
  end

  def show
  if !current_user && params[:referral]        #if this is a new user and they have a referral code store this for later DB use
		session[:referral] = params[:referral]
  end
  @project = Project.find(params[:id])
  @creator = @project.user
  @shares = @project.shares
  
  tweets = @project.shares.select {|p| p.medium == "Twitter"}
  if tweets.length > 0 
  if tweets .last .share_id .nil?
	Share.updateDbWithTwitterIds
  end 
  end
  # for testing purposes
  if @project.promotion_limit.nil?
	@project.promotion_limit = 20
  end
  ###
   
  
  @promotions_left = @project.promotion_limit - @shares.length
  @promotions_clear = ( @promotions_left > 0 )
  
  
  
  if current_user 
	@promotions_clear = (@promotions_clear && Share.find_by_user_id_and_project_id(current_user.id, @project.id).nil?  )
	
  end
  @shared = false
  if Share.find_by_user_id_and_project_id(current_user.id, @project.id).present?
	@shared = true
  end
  
 end
  def confirmation
  end

end
