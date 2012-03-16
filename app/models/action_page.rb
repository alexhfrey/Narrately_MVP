class ActionPage < ActiveRecord::Base
	belongs_to :actionable, :polymorphic => true
	has_many :action_taken
	belongs_to :project
end
