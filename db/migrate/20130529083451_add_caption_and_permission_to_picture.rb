class AddCaptionAndPermissionToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :caption, :string
    add_column :pictures, :permission, :string, :null => false, :default => 'everyone'
  end
end
