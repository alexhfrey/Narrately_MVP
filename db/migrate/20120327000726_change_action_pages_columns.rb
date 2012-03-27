class ChangeActionPagesColumns < ActiveRecord::Migration
 
  change_table(:action_pages) do |t|
	t.remove :project_id
	t.integer :project_id
end
 
end
