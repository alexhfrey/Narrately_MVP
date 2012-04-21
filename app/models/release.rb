require 'file_size_validator'

class Release < ActiveRecord::Base
belongs_to :project
has_many :release_shares
mount_uploader :content, RewardUploader
mount_uploader :image, RewardUploader

validates :image,
          :presence => true, 
		  :file_size => {
			:maximum => 2.megabytes.to_i
		}
validates :content, 
		  :presence => true, 
		  :file_size => {
			:maximum => 10.megabytes.to_i
		}


validates :description, :length => { :minimum => 50, :maximum => 1000, 
						:message => "must be between 50 and 1000 characters"}
						
validates :name, :length => { :minimum => 5, :maximum => 100, 
							:message => "must be between 5 and 100 characters"}
							
def page
"www.mysnowball.com/projects/" + self.project_id.to_s + "/releases/" + self.id.to_s
	
end
end
