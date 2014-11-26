class AddLastActivityAtToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :last_activity_at, :datetime
  end
end
