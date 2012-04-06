class ChangeActionTakensColumn < ActiveRecord::Migration
   change_table(:action_takens) do |t|
	t.remove :user_id
	t.integer :user_id
	end
end
