class ProjectsController < ApplicationController
before_filter :owns_project, :only => [:edit, :update, :admin]
before_filter :eligible_for_reward, :only => [:download, :backers, :actions]
before_filter :twitter_authorized, :only => [:backers, :actions]

  def new
	@user = current_user
	if @user.nil?
	flash[:notice] = "Please login to post a project."

		redirect_to signin_path and return
	end
	@project = @user.projects.build
	 #uploader = @project.file1
     #@uploader.success_action_redirect = new_project_url
  end
  
  def index
  @user = current_user
  if @user.nil? 
	@user = User.new
  end
  
  end
  
  def edit
  @project = Project.find(params[:id])
  @user = current_user
  @creator = @project.user
  end
  
  def update
  @project = Project.find(params[:id])
  if @project.update_attributes(params[:project])
    
	
	
	if params[:project][:file1].present?
	flash[:success] = "Looks great. Please crop your image appropriately below."
	session[:redirect] = "Update"
	redirect_to :action => 'crop', :id => @project.id and return
	else
	flash[:success] = "Your project has been updated, thanks!"
	redirect_to @project
	end
   
  else
    render  'edit'
  end
  end
  
  def cropped
  #Right now this is being used by the cropping view
  @user = current_user
  @project = Project.find(params[:id])
   ratio = @project.crop_ratio
  if @project.update_attributes(:x1 => params[:x1].to_f * ratio, :y1 => params[:y1].to_f * ratio, :width => params[:width].to_f * ratio, :height => params[:height].to_f * ratio)
    @project.reprocess_image
	if session[:redirect].present?
	session[:redirect] = nil
	redirect_to @project and return
	else
	flash[:success] = "Well Done! We'll review your project soon. Now tell us a little about yourself."
	redirect_to edit_user_path(@user)
   end
  else
    render  'edit'
  end

  end
  def download
	
	@file_object = Project.find(params[:id])
	redirect_to @file_object.file2_url
  end
  
  def owns_project
	@user = current_user
	if @user.nil?
		flash[:notice] = "You must sign in to access this page"
		session[:redirect] = request.url
		redirect_to signin_path and return
	end
	@project = Project.find(params[:id])
	if @user == @project.user || @user.id == 10 || @user.id == 7

	else
	flash[:error] = "You must be the owner of this project to view this page."
	redirect_to @project
	end
   end
  
  def eligible_for_reward
    @project = Project.find(params[:id])
	@user = current_user
	path = nil
	if @user.nil?
		flash[:notice] = "Please click 'Join Now' to to become a member"
		path = @project 
	else
		unless @project.shares.collect {|s| s.user } .include?(@user)
			flash[:notice] = "You are trying to access a members only page. Please join the program first."
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
		@share = @project.shares.build(:user_id => @project.user.id)
		@share.save
	
	    @project.user.add_to_chimp_creators
		flash[:success] = "Awesome! Your project is all setup and this is going to be your home here on Snowball so you might want to bookmark it. 
		                   From here, you can launch a viral promotion or send an update below!"		
		redirect_to admin_project_path(@project)
		
		
	else 
		render 'new'
	end
  end
  def crop
  
  @project = Project.find(params[:id])
  
  
  end

  def backers
  #Check to see if user has authorized twitter or not - if not, let's do it here
  
  @project = Project.find(params[:id])
  @shares = @project.shares
  @creator = @project.user
  end
  
  def show
  if !current_user && params[:referral]        #if this is a new user and they have a referral code store this for later DB use
		session[:referral] = params[:referral]
  end
  
  @project = Project.find(params[:id])
  @creator = @project.user
  @shares = @project.shares
  @acts = @project.action_pages
  @user = current_user
  @title = @project.project_title
  @image = @project.file1_url(:medium)
  @description = @project.description.html_safe.gsub(/[\"]/, '"')
  
  if (@project.id == 9 || @project.id == 15 || @project.id == 23 )
	@callout = "Back " + @project.brand_name
	@callout_verb = "Back"
	@callout_name = "Backers"
  else
	@callout = "Become a Member"
	@callout_verb = "Join"
	@callout_name = "Members"
  end
  
  if @project.shares.present?
	if @project.shares.last.twittercode.nil?
		@project.updateShares
	end
  end
  end
  
  def actions
	@project = Project.find(params[:id])
	@acts = ActionPage.find_all_by_project_id(params[:id])
	@user = current_user
	@creator = @project.user
    
 end
 
 def admin
	@project = Project.find(params[:id])
	@user = current_user
	@shares = @project.shares
 end
 
 def twitter_authorized
 user = current_user
 if user
	if user .twitter_token .nil?
				session[:redirect] = request.fullpath.to_s 
				redirect_to '/auth/twitter' and return
  end
  end
  end
  def confirmation
  end

end
