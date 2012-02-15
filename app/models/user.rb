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
    fb = nil
	if token
		@graph = Koala::Facebook::API.new(token)
		uid = facebook_id || "me"
		fb = @graph.get_object("me")
	end
	if fb.present?
		name = fb.name
		facebook_id = fb.id
		email = fb.email
		profile_image = fb.picture
			
	end 
end
end
