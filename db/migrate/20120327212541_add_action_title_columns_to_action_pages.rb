class AddActionTitleColumnsToActionPages < ActiveRecord::Migration
  def self.up
    add_column :action_pages, :title, :string
  end

  def self.down
    remove_column :action_pages, :title
  end
end
