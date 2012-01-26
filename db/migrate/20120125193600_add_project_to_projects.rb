class AddProjectToProjects < ActiveRecord::Migration
    def self.up
	change_table :projects do |t|
      t.has_attached_file :project_image
    end
  end

  def self.down
	drop_attached_file :projects, :project_image
  end
end
