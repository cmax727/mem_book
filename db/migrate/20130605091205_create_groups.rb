class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text   :description
      t.string :tag
      t.attachment :avatar
      t.timestamps
    end
  end
end
