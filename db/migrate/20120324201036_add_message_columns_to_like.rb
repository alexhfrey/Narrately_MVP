class AddMessageColumnsToLike < ActiveRecord::Migration
  def self.up
    add_column :likes, :message, :text
  end

  def self.down
    remove_column :likes, :message
  end
end
