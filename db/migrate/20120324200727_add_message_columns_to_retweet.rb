class AddMessageColumnsToRetweet < ActiveRecord::Migration
  def self.up
    add_column :retweets, :message, :text
  end

  def self.down
    remove_column :retweets, :message
  end
end
