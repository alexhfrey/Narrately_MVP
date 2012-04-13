class CreateReleaseShares < ActiveRecord::Migration
  def self.up
    create_table :release_shares do |t|
      t.integer :user_id
      t.integer :release_id

      t.timestamps
    end
  end

  def self.down
    drop_table :release_shares
  end
end
