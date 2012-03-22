class ActionTakensController < ApplicationController
  def new
	@action = ActionPage.find(params[:id])
	@action_takes = @action.action_takes.build
	if @action.actionable.class.name.downcase == "tweet"
		@title = "Enter a message to tweet"
		@post = nil
		@length = 140
		@include = @action.actionable.link
		@button = "Tweet!"
	elsif @action.actionable.class.name.downcase == "retweet"
		@title = "Retweet"
		@post = Twitter.status(@action.actionable.post_id).text
		@length = nil
		@include = nil
		@button = "Retweet!"
	elsif @action.actionable.class.name == "fb_comment"
	elsif @action.actionable.class.name == "post"
	elsif @action.actionable.class.name == "like"
	end
	
  end

  def create
	@action = ActionPage.find(params[:id])
	@action_takes = @action.action_takes.build(params[:action_take])
	if @action.actionable.class.name.downcase == "tweet"		
	elsif @action.actionable.class.name.downcase == "retweet"		
	elsif @action.actionable.class.name == "fb_comment"
	elsif @action.actionable.class.name == "post"
	elsif @action.actionable.class.name == "like"
	end
	
  end

end
