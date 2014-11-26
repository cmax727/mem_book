class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :group
      t.boolean    :auto_removed
      t.integer    :flag_count
      t.timestamps
    end
  end
end
