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
	user.token = auth['credentials']['token'] #Store token info for later use
	
end
end

def update_from_facebook
	if token
		@graph = Koala::Facebook::API.new(token)
		fb = @graph.get_object("me")		
		profile_image = fb.picture
		self.save
			
	end 
end
end
