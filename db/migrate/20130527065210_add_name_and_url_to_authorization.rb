class AddNameAndUrlToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :name, :string
    add_column :authorizations, :url, :string
  end
end
