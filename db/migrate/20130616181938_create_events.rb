class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :place
      t.text   :address
      t.date   :start_date
      t.date   :end_date
      t.text   :contact
      t.string :cost 
      t.timestamps
    end
  end
end
