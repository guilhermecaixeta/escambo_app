# typed: strict
class MessagePolicy < ApplicationPolicy
  extend T::Sig

  sig { returns(T::Array[Symbol]) }

  def permitted_attributes
    [:authenticity_token, :commit, :recipient, :message]
  end
end
