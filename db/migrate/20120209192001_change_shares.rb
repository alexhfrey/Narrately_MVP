class ChangeShares < ActiveRecord::Migration
  change_table :shares do |t|
	t.remove :share_id
	t.string :share_id
end

end
