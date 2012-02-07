
module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        crop_command + super.sub(/ -crop \S+/, '')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop #{target.width}x#{target.height}+#{target.x1}+#{target.y1}"
      end
    end
  end
end

