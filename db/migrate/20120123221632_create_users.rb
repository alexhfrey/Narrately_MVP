class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :facebook_id
      t.string :twitter_handle
      t.string :sex
      t.integer :age
      t.string :referral_campaign
      t.string :referral_source
      t.string :profile_image
	  t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
