class FacebookPostController < ApplicationController

def new
	@user = current_user
	@project = Project.find(params[:project_id])
		if params[:post_id]
			@shr = Share.new(:user_id => @user.id, :project_id => @project.id, :medium => "facebook", :share_id => params[:post_id], :referral => "fb_" + params[:post_id])
			@shr.save	
		end
	redirect_to @user
end
end
