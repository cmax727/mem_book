class Child < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :parent, :foreign_key => "parent_pk"
end
