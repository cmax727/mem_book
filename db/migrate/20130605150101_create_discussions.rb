class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :user
      t.references :group
      t.string     :title
      t.text       :description
      t.timestamps
    end
  end
end
