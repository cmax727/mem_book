class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string :event
      t.string :target
      t.string :target_id
      t.timestamps
    end
  end
end
