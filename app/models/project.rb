require 'file_size_validator'
class Project < ActiveRecord::Base
belongs_to :user
has_many :shares

attr_accessor :x1, :y1, :x2, :y2, :width, :height

after_update :reprocess_image, :if => :cropping?

  def cropping?
    !x1.blank? && !y1.blank? && !width.blank? && !height.blank?
  end

  
mount_uploader :file1, CoverUploader  
mount_uploader :file2, RewardUploader


validates :file1,
          :presence => true, 
		  :file_size => {
			:maximum => 2.megabytes.to_i
		}
validates :file2, 
		  :presence => true,
		  :file_size => {
			:maximum => 10.megabytes.to_i
		}

validates :description, :length => { :minimum => 50, :maximum => 1000, 
						:message => "must be between 50 and 1000 characters"}

validates :promotion_limit, :presence => true

validates :project_title, :length => { :minimum => 5, :maximum => 100, 
							:message => "must be between 5 and 100 characters"}
							
validates :promotion_description, :length => {:maximum => 100} 
						
						

#validates_attachment_content_type :output_file, :content_type=>['application/pdf'], :message => "File must be in PDF format"
#validates_attachment_content_type :project_image, :content_type=>['image/jpeg', 'image/png'], :message => "Cover image must be in JPEG format"
#validates_attachment_size :project_image, :less_than=> 2.megabytes, :message => "Cover image must be less than 2 MB"

def left
	promotion_limit - shares.length
end

def crop_ratio
    img = Magick::Image::read(self.file1_url).first
    @geometry = {:width => img.columns, :height => img.rows }
	if @geometry[:height] > @geometry[:width]
		@geometry[:height].to_f / 600
	else
		@geometry[:width].to_f / 600
	end
  end

def state_for(id_var)
#goal met, active, shared, pending, or running

if left == 0
	if shares.find{ |u| u.user_id == id_var }.empty? #Has not shared
	'goal met'
	else
	'shared'
	end
else
	if user.id == id_var #This means current user is the creator
		if active.nil?
			'pending'
		else
			'running' #User is the creator, promotion is running
		end
	else
		if shares.find{ |u| u.user_id == id_var }.empty? #Has not shared
			'active' #User is not the creator, promotion is active
		else 
			'shared'
		end
	end		
end
end

def updateShares
shares.select{ |s| s.medium == "Twitter" && s.twittercode.nil? } .each do |shs|
  shs.updateDbWithTwitterIds
  end 
end
private
def reprocess_image
    file1.recreate_versions!
	
	
 end


end