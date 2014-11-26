class RemoveAgreeFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :agrees
  end
end
