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
 
  
  tweet_text = "Check out the great new project I found on @Narrately"
  #twitter_share_page =  "http://#{request.host}:#{request.port}" + "/projects/" + params[:project_id] + "?referral=twitter_" + @user.id.to_s + '_' + @project.id.to_s 
	twitter_share_page =  "http://www.narrately.com" + "/projects/" + params[:project_id] + "?referral=twitter_" + @user.id.to_s + '_' + @project.id.to_s 
  via = "Narrately"
	@url = twitter_share_page
  @query = twitter_share_page + "&text=" + URI::escape(tweet_text) + "&via=" + via
  fb_share_page = "http://#{request.host}:#{request.port}" + "/projects/" + params[:project_id] + "?referral=fb_" + @user.id.to_s + '_' + @project.id.to_s 
  @facebook_link = "https://www.facebook.com/dialog/feed?app_id=" + '242735669136491' + '&link=' + 
  CGI::escape(fb_share_page) + '&picture=' + CGI::escape(@project.project_image.url) + '&name=' + CGI::escape(@project.project_title) + '&caption=' +
  CGI::escape('Another Great Project on Narrately') +
  '&description=' + CGI::escape(@project.description) +
  'message=' + CGI::escape("Check out the great new project I found on Narrately") + '&redirect_uri=' + CGI::escape(fb_share_page) + '/facebook_post/new'
  
  
  

  end

  def create
  @user = current_user
  medium = params[:medium]
  @share = Share.new(:user_id => params[:user_id], :project_id => params[:project_id], :medium => medium, :share_id => params[:share_id])
 
  if @share.save 
	redirect_to current_user
   else
	render 'new'
   end
  end

end
