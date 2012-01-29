class RenameActionsToShares < ActiveRecord::Migration
  def self.up
	rename_table :actions, :shares
  end

  def self.down
	rename_table :shares, :actions
  end
end
