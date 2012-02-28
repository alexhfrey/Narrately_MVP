class AddVideoToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :video, :string
  end

  def self.down
    remove_column :projects, :video
  end
end
