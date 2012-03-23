class ActionTaken < ActiveRecord::Base
belongs_to :action_page
belongs_to :user
end
