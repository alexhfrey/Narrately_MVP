class FacebookPostController < ApplicationController

def new
	@user = current_user
	@project = Project.find(params[:project_id])
		if params[:post_id]
			@shr = Share.new(:user_id => @user.id, :project_id => @project.id, :medium => "facebook", :share_id => params[:post_id], :referral => "fb_" + params[:post_id])
			@shr.save	
			 flash[:success] = "Success! You are now a fan club member. Show your support for" + @share.project.brand_name + "by taking an action below"
			redirect_to @share.project and return 
		end
	redirect_to @user and return 
end
end
