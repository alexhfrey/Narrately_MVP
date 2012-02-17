class SharesController < ApplicationController
  def new
  ###Define stuff for facebook open graph
  @project = Project.find(params[:project_id])
  @title = @project.project_title
  @image = @project.file1_url(:medium)
  @type = "book"
  
  #If there is not user logged in, store redirect parameter into sessions and then send to login
  if current_user.nil?
	session[:redirect] = params[:project_id]
	flash[:success] = "Great! Just connect below with your facebook or twitter account and you will be sharing in seconds!"
	redirect_to signin_path and return
  end
  
  @user = current_user
 
  
  @tweet_text = "I just backed " + @project.project_title.first(20) + " a great new " + @project.tag1 + " endeavor I found on Snowball"
  #twitter_share_page =  "http://#{request.host}:#{request.port}" + "/projects/" + params[:project_id] + "?referral=twitter_" + @user.id.to_s + '_' + @project.id.to_s 
  @twitter_share_page =  "http://www.getsnowball.com" + "/projects/" + params[:project_id] + "?referral=twitter_" + @user.id.to_s + '_' + @project.id.to_s 
  via = "SnowballChirps"
	
  @query = URI::escape(@twitter_share_page + '&text=' + @tweet_text + '&via=Narrately')
	
  fb_share_page = "http://#{request.host}:#{request.port}" + "/projects/" + params[:project_id] 
  referral_tag = "?referral=fb_" + @user.id.to_s + '_' + @project.id.to_s 
  @facebook_link = "https://www.facebook.com/dialog/feed?app_id=" + '173481316095568' + '&link=' + 
  CGI::escape(fb_share_page) + referral_tag + '&picture=' + URI::escape(CGI::escape(@project.file1_url(:medium)),'.') + '&name=' + URI::escape(CGI::escape(@project.project_title),'.') + '&caption=' +
  CGI::escape('Another Great Project on Narrately') +
  '&description=' + CGI::escape(@project.description) +
  '&message=' + CGI::escape("Check out the great new project I found on Narrately") + '&redirect_uri=' + CGI::escape(fb_share_page) + '/facebook_post/new'
  end

  def create
  @user = current_user
  medium = params[:medium]

  share_id = params[:share_id]
 

  @share = Share.new(:user_id => params[:user_id], :project_id => params[:project_id], :medium => medium, :share_id => share_id)
 
   if @share.save 
   flash[:success] = "Success, thanks for sharing! You can download your reward below."
	redirect_to current_user
   else
	render 'new'
   end
  end

end
