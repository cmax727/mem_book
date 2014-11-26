class CreateUpdateStatuses < ActiveRecord::Migration
  def change
    create_table :update_statuses do |t|
      t.references :user
      t.text :context
      t.timestamps
    end
  end
end
