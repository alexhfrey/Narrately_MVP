class Share < ActiveRecord::Base
belongs_to :user
belongs_to :project
validates :user_id, :presence => true
validates :project_id, :presence => true

def self.updateDbWithTwitterIds
target = self.find_all_by_medium_and_share_id("Twitter", nil)
target .each do |tar|
	Twitter.search("snowball.com/projects/" + tar.project_id.to_s, :type => "recent") .each do |tweets|
		if ((tar.created_at - tweets.created_at).abs < 10)
			tar.share_id = tweets.id
			tar.save
			
		end
	end
end
end

end