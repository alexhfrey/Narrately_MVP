require 'file_size_validator'
class Project < ActiveRecord::Base
belongs_to :user
has_many :shares
has_many :releases
has_many :action_pages
has_many :action_taken, :through => :action_pages

attr_accessor :x1, :y1, :x2, :y2, :width, :height


  def cropping?
    !x1.blank? && !y1.blank? && !width.blank? && !height.blank?
  end

  
mount_uploader :file1, CoverUploader  
mount_uploader :file2, RewardUploader






							
validates :promotion_description, :length => {:maximum => 100} 

def video_link						
if video.include? ".be"  #check and see if this is the shortened version
	"http://www.youtube.com/embed/" + video.split('.be/')[1]
else
"http://www.youtube.com/embed/" + CGI::parse(video.split('?')[1])["v"].first						
end
end
#validates_attachment_content_type :output_file, :content_type=>['application/pdf'], :message => "File must be in PDF format"
#validates_attachment_content_type :project_image, :content_type=>['image/jpeg', 'image/png'], :message => "Cover image must be in JPEG format"
#validates_attachment_size :project_image, :less_than=> 2.megabytes, :message => "Cover image must be less than 2 MB"


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
  shs.save
  end 
end

def reprocess_image
    file1.recreate_versions!
	
	
 end


end