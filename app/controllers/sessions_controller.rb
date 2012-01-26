class SessionsController < ApplicationController
def create
	auth = request.env["omniauth.auth"]
	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) 
	if user #Direct to Dashboard if an existing user
		session[:user_id] = user.id
		redirect_to user
	else #Direct to New Project signup if this is a new user
		user = User.create_with_omniauth(auth)
		session[:user_id] = user.id
		redirect_to "Projects#new"
	end
end

def destroy
	session[:user_id] = nil
	redirect_to root_url, :notice => "Signed out!"
end
end