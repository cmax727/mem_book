class Parent < ActiveRecord::Base
  # attr_accessible :title, :body
  set_primary_key :parent_pk
  has_many :children, :foreign_key => "parent_pk"
end
