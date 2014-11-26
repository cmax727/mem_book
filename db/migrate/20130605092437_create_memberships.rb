class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :group
      t.string     :member_type, :default => "member"
      t.string     :status,      :default => ""
      t.timestamps
    end
  end
end
