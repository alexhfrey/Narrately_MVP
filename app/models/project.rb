class Project < ActiveRecord::Base
belongs_to :user
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
validates_attachment_content_type :output_file, :content_type=>['application/pdf'], :message => "File must be in PDF format"
validates_attachment_content_type :project_image, :content_type=>['image/jpeg'], :message => "Cover image must be in JPEG format"
validates_attachment_size :project_image, :less_than=> 10.megabytes
end
