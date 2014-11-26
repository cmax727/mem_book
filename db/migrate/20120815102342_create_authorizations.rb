class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table(:authorizations) do |t|
      t.references :user,       null: false

      t.integer     :provider_id, null: false
      t.string      :uid,         null: false

      t.timestamps
    end

    add_index(:authorizations, :user_id)
    add_foreign_key(:authorizations, :users, dependent: :delete)

    add_index(:authorizations, :provider_id)
    add_index(:authorizations, :uid)

    add_index(:authorizations, [:user_id, :provider_id], unique: true)
  end
end
