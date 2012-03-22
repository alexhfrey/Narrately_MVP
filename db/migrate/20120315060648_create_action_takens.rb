class CreateActionTakens < ActiveRecord::Migration
  def self.up
    create_table :action_takens do |t|
      t.string :action_page_id
      t.string :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :action_takens
  end
end
