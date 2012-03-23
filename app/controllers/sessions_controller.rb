class SessionsController < ApplicationController
def create
auth = request.env["omniauth.auth"]
if auth["provider"] == "twitter" #User must be authorizing tweets
	@user = current_user
	@user.twitter_token = auth['credentials']['token']
	@user.twitter_secret = auth['credentials']['secret']
	@user.save
	a = session[:redirect]
	session[:redirect] = nil
	redirect_to a and return
end

if current_user #logged-in already: just need to update some tokens
	if auth["provider"] == "facebook"
		
		@user = current_user
		@user.token = auth['credentials']['token']
		@user.save
		a = session[:redirect]
		if session[:redirect]
			session[:redirect] = nil
			redirect_path = a
		else
			redirect_path = @user
		end
	end
	
	
	user = current_user

else
	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
	
	

	if user #Direct to Dashboard if an existing user
		session[:user_id] = user.id
		redirect_path = user
	else #Direct to New Project signup if this is a new user
		user = User.create_with_omniauth(auth)
		if session[:referral]
			user.referral_source = session[:referral]
			user.save
			session[:referral] = nil
		end
		session[:user_id] = user.id
		redirect_path = new_project_path
		flash[:success] = "Thanks for signing up for Snowball. We're anxious to hear more about you're doing!"
	end
	if auth["provider"] == "facebook"
		user.token = auth["credentials"]["token"]
		user.save
	end
	if session[:redirect].present?
		@project = Project.find(session[:redirect])
		session[:redirect] = nil
		redirect_path = new_project_share_path(@project) 
	end
end
	redirect_to redirect_path
end

def new
end	

def destroy
	session[:user_id] = nil
	redirect_to root_url, :notice => "You have signed out successfully!"
end
end
