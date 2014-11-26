class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :picture
      t.text       :body
      t.boolean    :like
      t.timestamps
    end
  end
end
