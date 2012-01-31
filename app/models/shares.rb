class Shares < ActiveRecord::Base
validates :user_id, :presence => true
validates :project_id, :presence => true
end
