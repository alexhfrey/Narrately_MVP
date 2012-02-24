class Share < ActiveRecord::Base

after_create :add_user_to_mailchimp
belongs_to :user
belongs_to :project
validates :user_id, :presence => true
validates :project_id, :presence => true

def add_user_to_mailchimp
#Add logic here checking if it is their first share, eventually
user.add_to_chimp_backers
end

def updateDbWithTwitterIds
Twitter.search("mysnowball.com/projects/" + project_id.to_s) .each do |tweets|
		if ((created_at - tweets.created_at).abs < 10)
			self.share_id = tweets.id
			self.twittercode = Twitter.oembed(tweets.id).html.html_safe
			
			
		   end
	    end
	rescue 
end

end