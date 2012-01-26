class User < ActiveRecord::Base
has_many :projects
create! do |user|
	user.provider = auth["provider"]
	user.uid = auth["uid"]
	user.name = auth["info"]["name"]
end
end
