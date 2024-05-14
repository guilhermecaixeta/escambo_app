# typed: strict
class Comment < ApplicationRecord
  belongs_to :member, class_name: "User", foreign_key: "user_id"
  belongs_to :advertisement

  validates :title, :body, presence: true
  validates :title, length: { minimum: 3, maximum: 100 }
  validates :body, length: { minimum: 3, maximum: 1000 }
end
