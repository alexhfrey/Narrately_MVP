class ActionsController < ApplicationController
  def new
  share_page = "http://www.narrately.com/projects/" + params[:project_id]
  tweet_text = "Check out the great new project I found on @Narrately"
  via = "Narrately"
  @query = URI::escape(share_page) + "&text=" + URI::escape(tweet_text) + "&via=" + via
  end

  def create
  end

end
