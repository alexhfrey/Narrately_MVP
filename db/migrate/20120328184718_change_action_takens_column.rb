class ChangeActionTakensColumn < ActiveRecord::Migration
   change_table(:action_takens) do |t|
	t.remove :action_page_id
	t.integer :action_page_id
	end
end
