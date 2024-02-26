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

  validates_presence_of :name
  validates :roles, presence: true, on: [:create, :update]
  validate :can_change_role?, on: :update

  define_attribute_methods

  def role_ids=(new_role_ids)
    @can_change_roles = true
    unless roles.any?
      super new_role_ids
      return
    end

    member_role = roles.all? { |role| role.name == Rails.configuration.default_roles.find { |r| r[:is_member] }[:name] }

    if member_role && new_role_ids - role_ids != 0
      @can_change_roles = false
      return
    end

  end

  private

  sig { void }

  def send_message_on_create
    token = set_reset_password_token
    UserMailer.on_create(self, token).deliver_now
  end

  def can_change_role?
    return if @can_change_roles

    errors.add(:roles, :member_roles_cannot_be_changed)
  end
end
