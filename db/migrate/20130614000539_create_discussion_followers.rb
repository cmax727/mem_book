class CreateDiscussionFollowers < ActiveRecord::Migration
  def change
    create_table :discussion_followers do |t|
      t.references :user
      t.references :discussion
      t.timestamps
    end
  end
end
