class Project < ActiveRecord::Base
belongs_to :user
has_attached_file :output_file, :path => ":rails_root/public/User_Uploads"
has_attached_file :project_image, :path => ":rails_root/public/images" , :styles => { :medium => "300x300>"  }
validates_attachment_content_type :output_file, :content_type=>['application/pdf'], :message => "File must be in PDF format"
validates_attachment_content_type :project_image, :content_type=>['image/jpeg'], :message => "Cover image must be in JPEG format"
validates_attachment_size :project_image, :less_than=> 10.megabytes
end
