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
		user.token = auth['credentials']['token']
	end
end
end

def self.update_image(old_user)
	if old_user.provider.include?("facebook")
		old_user.profile_image = 'http://graph.facebook.com/' + old_user.uid + '/picture?type=large'
		old_user.save
	end unless old_user.provider.nil?
end
end
