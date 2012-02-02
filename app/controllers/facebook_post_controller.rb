class FacebookPostController < ApplicationController

def new
	@user = current_user
	@project = Project.find(params[:project_id])
	if @user.token 
			@graph = Koala::Facebook::API.new(@user.token)
			@graph.put_object("me", "feed", :message => "Testing Narrately Wall Posts", 
				:picture => @project.project_image.url, :link => "http://www.narrately.com/projects/" + @project.id.to_s,
							:caption => "This is the caption", :name => "This is the name", 
							:description => "This is the description. This is the description. THis is the description." )
			@shr = Share.new(:user_id => @user.id, :project_id => @project.id, :medium => "facebook")
			@shr.save
			redirect_path = @user
	else 
		session[:redirect] = request.fullpath
		redirect_path = '/auth/facebook'

	end 
	redirect_to redirect_path
end
end
