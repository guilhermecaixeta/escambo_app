# typed: strict
class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  has_and_belongs_to_many :permissions, :join_table => "permissions_roles"
end
