class CreateRetweets < ActiveRecord::Migration
  def self.up
    create_table :retweets do |t|
      t.string :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :retweets
  end
end
