class RemoveInterestFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :interest
  end
end
