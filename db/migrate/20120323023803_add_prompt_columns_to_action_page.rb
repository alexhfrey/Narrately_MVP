class AddPromptColumnsToActionPage < ActiveRecord::Migration
  def self.up
    add_column :action_pages, :prompt, :text
  end

  def self.down
    remove_column :action_pages, :prompt
  end
end
