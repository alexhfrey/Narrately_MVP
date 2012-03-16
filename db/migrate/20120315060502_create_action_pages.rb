class CreateActionPages < ActiveRecord::Migration
  def self.up
    create_table :action_pages do |t|
      t.string :project_id
	  t.references :actionable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :action_pages
  end
end
