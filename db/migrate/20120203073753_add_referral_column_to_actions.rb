class AddIdColumnToShares < ActiveRecord::Migration
 def self.up
    add_column :share, :referral, :string
  end

  def self.down
    remove_column :shares, :referral
  end
end
