# encoding: utf-8

class CoverUploader < CarrierWave::Uploader::Base
  
 
   def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  include CarrierWave::RMagick
  # Include RMagick or MiniMagick support:
 attr_accessor :x1, :y1, :x2, :y2, :width, :height
   
   version :uploaded do
		process :resize_to_fit => [600, 600]
	end
   
   version :medium do
		process :cropit
		process :resize_to_fill => [248, 162]
	end
   
   
   
   version :large do
		process :cropit
		process :resize_to_fit => [600, 391]
		
	end
   
  
  def cropit
	return unless model.cropping?
    manipulate! do |img|
       
		img = img.crop(model.x1.to_i, model.y1.to_i, model.width.to_i, model.height.to_i)
        
    end
	
end
  
   def cache_dir
  "#{RAILS_ROOT}/tmp/uploads"
	end

   
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
    storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "project_images"
	# {model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
