target = Share.find_all_by_medium("Twitter")
target .each do |tar|
	Twitter.search("narrately.com/projects/" + tar.project_id.to_s, :type => "recent") .each do |tweets|
		if ((tar.created_at - tweets.created_at).abs < 10)
			tar.share_id = tweets.id
			tar.save
			puts("one saved")
		end
		end
	end