class Project < ActiveRecord::Base
belongs_to :user
has_attached_file :output_file

end
