class ProjectsController < ApplicationController
before_filter :require_permission, :only => :download
  def new
	@user = current_user
	if @user.nil?
		redirect_to login_path
	end
	@project = @user.projects.build
	
  end
  
  def index
  @user = current_user
  if @user.nil? 
	@user = User.new
  end
  
  end
  
  def edit
  end
  
  def update
  #Right now this is being used by the cropping view
  @user = current_user
  @project = Project.find(params[:id])

  if @project.update_attributes(:x1 => params[:x1], :y1 => params[:y1], :width => params[:width], :height => params[:height])
    flash[:success] = "Successfully updated user."
	redirect_to edit_user_path(@user)
   
  else
    render  'edit'
  end

  end
  def download
	
	@file_object = Project.find(params[:id])
	redirect_to @file_object.output_file.expiring_url(10)
  end
  
  def require_permission
	@user = current_user
	path = nil
	if @user.nil?
		flash[:notice] = "You must be logged in to access rewards."
		path = signin_path 
	else
		@project = Project.find(params[:id])
		unless @project.shares.collect {|s| s.user } .include?(@user)
			flash[:notice] = "You must share the project before you can claim any rewards."
			 path = @project
		end
	end
	unless path.nil? 
	redirect_to path 
  end
  end
  def create
	@user = current_user
	@project = @user.projects.build(params[:project])
	
	if @project.save
		flash[:success] = "Thanks for your submission! Now you can optimize your project image"		
		redirect_to :action => 'crop', :id => @project.id
	else 
		flash[:error] = "We don't like to be alarmists, but there were a few things missing in your form"
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
   
  
 
  @promotions_clear = ( @project.left > 0 )
  
  
  if current_user 
	@promotions_clear = (@promotions_clear && Share.find_by_user_id_and_project_id(current_user.id, @project.id).nil?  )	
  end
   
 end
  def confirmation
  end

end
