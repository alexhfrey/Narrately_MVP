class Project < ActiveRecord::Base
belongs_to :user
has_many :shares

attr_accessor :x1, :y1, :x2, :y2, :width, :height

after_update :reprocess_image, :if => :cropping?

  def cropping?
    !x1.blank? && !y1.blank? && !width.blank? && !height.blank?
  end

  
  

validates :description, :length => { :minimum => 100, :maximum => 1000, 
						:message => "must be between 50 and 500 characters"}

validates :promotion_limit, :presence => true

validates :project_title, :length => { :minimum => 10, :maximum => 100, 
							:message => "must be between 10 and 100 characters"}
						
						
has_attached_file :output_file, :storage => :s3, :bucket => 'narrately.com',
					:s3_credentials => {
						:access_key_id => 'AKIAJ7LLMIQJP57FAP3Q',
						:secret_access_key => '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'
						
						}
					
has_attached_file :project_image, 
	 :styles =>  {  :medium => "248x146#",
					:large => "610x360"
					}, 
	:processors => [:cropper],
					 :storage => :s3, :bucket => 'narrately.com',
					:s3_credentials => {
						:access_key_id => 'AKIAJ7LLMIQJP57FAP3Q',
						:secret_access_key => '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'
						}

validates :project_image, :presence => true
validates_attachment_content_type :output_file, :content_type=>['application/pdf'], :message => "File must be in PDF format"
validates_attachment_content_type :project_image, :content_type=>['image/jpeg', 'image/png'], :message => "Cover image must be in JPEG format"
validates_attachment_size :project_image, :less_than=> 2.megabytes, :message => "Cover image must be less than 2 MB"

private
def reprocess_image
    project_image.reprocess!
  end


end
