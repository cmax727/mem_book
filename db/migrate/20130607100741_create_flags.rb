class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.references :user
      t.references :comment
      t.boolean    :innapropriate
      t.boolean    :off_topic
      t.boolean    :offensive
      t.timestamps
    end
  end
end
