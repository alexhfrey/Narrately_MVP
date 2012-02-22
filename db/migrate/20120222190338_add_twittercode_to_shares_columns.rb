class AddTwittercodeToSharesColumns < ActiveRecord::Migration
  def self.up
    add_column :shares, :twittercode, :text
  end

  def self.down
    remove_column :shares, :twittercode
  end
end
