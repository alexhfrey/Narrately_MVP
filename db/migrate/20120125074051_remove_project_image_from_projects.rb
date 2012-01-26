class RemoveProjectImageFromProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
	       t.remove :project_image
    end
  end

  def self.down
	
    change_table :projects do |t|
	       t.string :project_image
    end
  end
end
