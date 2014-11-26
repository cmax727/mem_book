class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :user,    null: false
      t.string     :title
      t.attachment :avatar1
      t.timestamps
    end
  end
end
