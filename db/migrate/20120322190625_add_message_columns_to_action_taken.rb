class AddMessageColumnsToActionTaken < ActiveRecord::Migration
  def self.up
    add_column :action_takens, :message, :text
  end

  def self.down
    remove_column :action_takens, :message
  end
end
