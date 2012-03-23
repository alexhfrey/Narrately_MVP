class AddTwitterColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_secret, :string
    add_column :users, :twitter_token, :string
  end

  def self.down
    remove_column :users, :twitter_token
    remove_column :users, :twitter_secret
  end
end
