class AddBirthdayRelationshipStatusGoalAboutMePlaceInterestToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :birthday,            :date
    add_column :profiles, :relationship_status, :string
    add_column :profiles, :goal,                :string
    add_column :profiles, :about_me,            :text
    add_column :profiles, :place,               :string
    add_column :profiles, :interest,            :string
  end
end
