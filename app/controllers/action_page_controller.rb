class ActionPageController < ApplicationController
before_filter :is_page_admin
  def new
	 @user = current_user
	 @project = Project.find(params[:id])
     graph = Koala::Facebook::API.new(@user.token)
	 @posts = graph.get_connections("me", "posts") .select {|t| t["message"].present? } [0...5]
	 @action = @project.action_pages.build
  end

  def create
  end

  def show
  
  end

  def is_page_admin      #right now page admin is just the creator, but could add a field here later
  @project = Project.find(params[:id])
  if @project.user != current_user
	redirect_to @project
	flash[:error] = "You must be the project creator in order to create a new action." 
  end
  end
  
end
