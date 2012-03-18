class ActionPagesController < ApplicationController
before_filter :is_page_admin
  def new
	 @user = current_user
	 @project = Project.find(params[:project_id])
     graph = Koala::Facebook::API.new(@user.token)
	 @posts = graph.get_connections("me", "posts") .select {|t| t["message"].present? } [0...5]
	 @newaction = @project.action_pages.build
  end

  def create
  @project = Project.find(params[:project_id])
  @action = @project.action_pages.build(params[:action_page])
  if @action.actionable_type == "tweet"  
	redirect_to new_project_tweet_path(@project) and return
  elsif @action.actionable_type == "like" 
	redirect_to new_project_like_path(@project) and return
  end
  
  end

  def show
  
  end

  def is_page_admin      #right now page admin is just the creator, but could add a field here later
  @project = Project.find(params[:project_id])
  if @project.user != current_user
	redirect_to @project
	flash[:error] = "You must be the project creator in order to create a new action." 
  end
  end
  
end
