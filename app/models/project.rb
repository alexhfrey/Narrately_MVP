class Project < ActiveRecord::Base
belongs_to :user

validates :description, :length => { :minimum => 50, :maximum => 500, 
						:message => "Project description must be between 50 and 500 characters"}

validates :promotion_limit, :presence => true

validates :project_title, :length => { :minimum => 10, :maximum => 80, 
							:message => "Project title must be between 10 and 80 characters"}
						
						
has_attached_file :output_file, :storage => :s3, :bucket => 'narrately.com',
					:s3_credentials => {
						:access_key_id => 'AKIAJ7LLMIQJP57FAP3Q',
						:secret_access_key => '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'
						
						}
					
has_attached_file :project_image, #:styles => { :medium => "300x300>"  } 
					 :storage => :s3, :bucket => 'narrately.com',
					:s3_credentials => {
						:access_key_id => 'AKIAJ7LLMIQJP57FAP3Q',
						:secret_access_key => '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'
						}

validates :project_image, :presence => true
validates_attachment_content_type :output_file, :content_type=>['application/pdf'], :message => "File must be in PDF format"
validates_attachment_content_type :project_image, :content_type=>['image/jpeg'], :message => "Cover image must be in JPEG format"
validates_attachment_size :project_image, :less_than=> 2.megabytes, :message =>"Cover image must be less than 2 MB"

end
