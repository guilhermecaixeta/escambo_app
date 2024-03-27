# typed: false
class User < ApplicationRecord
  extend T::Sig
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :trackable, :confirmable

  has_many :permissions, through: :roles
  has_and_belongs_to_many :roles, :join_table => :users_roles
  has_many :visits, class_name: "Ahoy::Visit"

  validates_presence_of :name
  validates :roles, presence: true, on: [:create, :update]

  private

  sig { void }

  def send_message_on_create
    token = set_reset_password_token
    UserMailer.on_create(self, token).deliver_now
  end
end
