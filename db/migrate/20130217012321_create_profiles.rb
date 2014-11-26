class CreateProfiles < ActiveRecord::Migration
  def up
    create_table(:profiles) do |t|
      t.references    :user,    null: false
      t.references    :city

      t.boolean       :agrees,  null: false, default: true

      t.timestamps
    end

    add_index(:profiles, :user_id, unique: true)
    add_foreign_key(:profiles, :users, dependent: :delete)

    add_index(:profiles, :city_id, unique: true)
    # add_foreign_key(:profiles, :cities, dependent: :delete)

    add_index(:profiles, :agrees)

    add_index(:profiles, :created_at)
    add_index(:profiles, :updated_at)
  end

  def down
    drop_table(:profiles)
  end
end
