# typed: strict
class User < ApplicationRecord
  extend T::Sig
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :permissions, through: :roles
  has_and_belongs_to_many :roles, :join_table => :users_roles

  validates_presence_of :name
  validates :role_ids, presence: true, on: :create

  private

  sig { void }

  def send_message_on_create
    token = set_reset_password_token
    UserMailer.on_create(self, token).deliver_now
  end
end