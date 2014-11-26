class ChangeStartDateAndEndDateInEvent < ActiveRecord::Migration
  def up
    remove_column :events, :start_date
    add_column    :events, :started_at, :datetime
    remove_column :events, :end_date
    add_column    :events, :ended_at, :datetime
  end

  def down
  end
end
