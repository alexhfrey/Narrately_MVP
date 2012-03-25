class AddMessageColumnsToFbcomment < ActiveRecord::Migration
  def self.up
    add_column :fbcomments, :message, :text
  end

  def self.down
    remove_column :fbcomments, :message
  end
end
