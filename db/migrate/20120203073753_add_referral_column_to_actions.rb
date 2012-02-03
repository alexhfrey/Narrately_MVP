class AddReferralColumnToActions < ActiveRecord::Migration
 def self.up
    add_column :shares, :referral, :string
  end

  def self.down
    remove_column :shares, :referral
  end
end
