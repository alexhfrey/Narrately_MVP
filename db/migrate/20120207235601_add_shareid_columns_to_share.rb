class AddShareidColumnsToShare < ActiveRecord::Migration
  def self.up
    add_column :shares, :share_id, :integer, :limit => 8
  end

  def self.down
    remove_column :shares, :share_id
  end
end
