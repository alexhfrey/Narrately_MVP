class ActionTakensController < ApplicationController
  def new
	@action = ActionPage.find(params[:id])
	@action_takes = @action.action_takens.build
	@user = current_user
	if @action.actionable.class.name.downcase == "tweet"
		if current_user.twitter_token.empty?
				session[:redirect] = request.fullpath.to_s 
				redirect_to '/auth/twitter'
			end
		@title = "Enter a message to tweet"
		@post = nil
		@length = 120
		@include = @action.actionable.link
		@button = "Tweet!"
	elsif @action.actionable.class.name.downcase == "retweet"
		@title = "Retweet"
		@post = Twitter.status(@action.actionable.post_id).text
		@length = nil
		@include = nil
		@button = "Retweet!"
	elsif @action.actionable.class.name.downcase == "fbcomment"
		graph = Koala::Facebook::API.new(@action.project.user.token)
		@title = "Enter a comment - the link will be attached for you!"
		@length = 120
		@post = graph.get_object(@action.actionable.post_id)["message"]
		@include = nil
		@button = "Post!"
	elsif @action.actionable.class.name.downcase == "post"
		@title = "Enter a comment - the link will be attached for you!"
		@length = 200
		@post = nil
		@include = @action.actionable.link
		@button = "Post!"
	elsif @action.actionable.class.name.downcase == "like"
		graph = Koala::Facebook::API.new(@action.project.user.token)
		@title = "Just click the big green button below to like!"
		@length = nil
		@post = graph.get_object(@action.actionable.post_id)["message"]
		@include = nil
		@button = "Like!"
	end
	
  end

  def create
  @user = current_user
	@action = ActionPage.find(params[:action_id])
	@action_takes = @action.action_takens.build
    @action_takes.message = params[:message]
	
	if @action.actionable.class.name.downcase == "tweet"	
		
		@client = Twitter::Client.new(
			:consumer_key => 'QQIFzq0TTcktuanOGLrgfg',
			:consumer_secret => '4k136e8TtQptnoKMCL8VZeTjwZZXwCkXQLrBkpFi8',
			:oauth_token => @user.twitter_token,
			:oauth_token_secret => @user.twitter_secret
			
			)
		link = @action.actionable.link + '?referral=' + @user.id.to_s
		@client.update(@action_takes.message + " " + (@action.actionable.link + '?referral=' + link))
	
	elsif @action.actionable.class.name.downcase == "retweet"
@client = Twitter::Client.new(
			:consumer_key => 'QQIFzq0TTcktuanOGLrgfg',
			:consumer_secret => '4k136e8TtQptnoKMCL8VZeTjwZZXwCkXQLrBkpFi8',
			:oauth_token => @user.twitter_token,
			:oauth_token_secret => @user.twitter_secret
			
			)	
		@client.retweet(@action.actionable.post_id)
	elsif @action.actionable.class.name.downcase == "fbcomment"
		graph = Koala::Facebook::API.new(@user.token)
		graph.put_comment(@action.actionable.post_id, @action_takes.message)
	elsif @action.actionable.class.name.downcase == "post"
		graph = Koala::Facebook::API.new(@user.token)
		graph.put_wall_post(@action_takes.message, {:link => @action.actionable.link })
	elsif @action.actionable.class.name.downcase == "like"
		graph = Koala::Facebook::API.new(@user.token)
		graph.put_like(@action.actionable.post_id)
	end
	if @action_takes.save
	flash[:success] = "Thanks! Your message has been posted!"
	redirect_to actions_project_path(@action.project)
	end
  end

end
