class User < ActiveRecord::Base
has_many :projects
has_many :shares
validates :biography, :length =>  {:maximum => 140}
						
						

def self.create_with_omniauth(auth)
create! do |user|
	user.provider = auth["provider"]
	user.uid = auth["uid"]
	user.name = auth["info"]["name"]
	user.email = auth["info"]["email"]
	if user.provider == "facebook"
		user.token = auth['credentials']['token'] #Store token info for later use
	end
end
end

def update_from_facebook
	if token
		@graph = Koala::Facebook::API.new(token)
		fb = @graph.get_object(fb_uid)
	else #If we don't have a token then see if user happens to be logged in elsewhere
		@oauth = Koala::Facebook::OAuth.new('242735669136491', 'ea405d01fda59ee513e230cf3a779d0f')
		
		@graph = Koala::Facebook::API.new(@oauth)
	
	end	
	if fb.present?
		name = fb.name
		fb_uid = fb.id
		email = fb.email
		profile_image = fb.picture
			
	end 
end
end
