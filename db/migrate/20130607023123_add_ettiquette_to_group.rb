class AddEttiquetteToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :ettiquette, :string
  end
end
