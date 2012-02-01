class SharesController < ApplicationController
  def new
  ###Define stuff for facebook open graph
  @project = Project.find(params[:project_id])
  @title = @project.project_title
  @image = @project.project_image.url
  @type = @project.tag1
  
  if current_user.nil?
	session[:redirect] = params[:project_id]
	redirect_to signin_path 
  end
  
  @user = current_user
  share_page = "http://www.narrately.com/projects/" + params[:project_id]
  tweet_text = "Check out the great new project I found on @Narrately"
  via = "Narrately"
  @query = URI::escape(share_page) + "&text=" + URI::escape(tweet_text) + "&via=" + via
  end

  def create
  @user = current_user
  medium = params[:medium]
  @share = Share.new(:user_id => params[:user_id], :project_id => params[:project_id], :medium => medium)
 
  if @share.save 
	redirect_to current_user
   else
	render 'new'
   end
  end

end
