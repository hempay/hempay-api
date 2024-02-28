class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :payments
  has_many :sent_payments, class_name: 'Payment', foreign_key: 'sender_id'
  has_many :received_payments, class_name: 'Payment', foreign_key: 'receiver_id'

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true
  validate :valid_date_of_birth_format

  private

  def valid_date_of_birth_format
    return unless date_of_birth.present?

    return if date_of_birth =~ /\A\d{2}-\d{2}-\d{4}\z/

    errors.add(:date_of_birth, 'must be in the format mm-dd-yyyy')
  end
end
