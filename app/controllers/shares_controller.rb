class SharesController < ApplicationController
  def new
  ###Define stuff for facebook open graph
  @project = Project.find(params[:project_id])
  @title = @project.project_title
  @image = @project.project_image.url
  @type = "book"
  
  
  if current_user.nil?
	session[:redirect] = params[:project_id]
	redirect_to signin_path 
  end
  
  @user = current_user
  share_page = "http://#{request.host}:#{request.port}" + "/projects/" + params[:project_id] + "?referral=" 
  @url = share_page
  tweet_text = "Check out the great new project I found on @Narrately"
	via = "Narrately"
  @query = URI::escape(share_page + "t_" + ) + "&text=" + URI::escape(tweet_text) + "&via=" + via
  
  @facebook_link = "https://www.facebook.com/dialog/feed?app_id=" + '242735669136491' + '&link=' + 
  CGI::escape(share_page) + '&picture=' + CGI::escape(@project.project_image.url) + '&name=' + CGI::escape(@project.project_title) + '&caption=' +
  CGI::escape('Another Great Project on Narrately') +
  '&description=' + CGI::escape(@project.description) +
  '&user_message=' + CGI::escape("Check out the great new project I found on Narrately") + '&redirect_uri=' + CGI::escape(share_page) + '/facebook_post/new'
  
  
  

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
