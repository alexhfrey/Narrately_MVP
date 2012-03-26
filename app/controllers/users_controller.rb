class UsersController < ApplicationController
	
  def new
	if current_user 
		redirect_to current_user
	end
	@identity = env['omniauth.identity']
  end
 
  def show
	@user = User.find(params[:id])
	@current_user = current_user
	
	
	if @user.provider == "twitter"
		begin
		tw = Twitter.user(@user.uid.to_i)
		@user.twitter_handle = tw.screen_name
		@user.profile_image = Twitter.profile_image(@user.twitter_handle, :size => 'bigger')
		@user.save
		rescue
		end
	end
	
	@projects = @user.projects
	@shares = @user.shares
  end
  
  def edit
  @user = current_user
  end
  
  def update
  @user = current_user
  if params[:user][:email] != @user.email #Add email to general list if email has been changed
	@user.email = params[:user][:email]
	@user.add_to_mailchimp
  end
  if @user.update_attributes(params[:user])
    flash[:notice] = "Success! Your profile has been updated."
	
	redirect_to @user
  end

end
end
