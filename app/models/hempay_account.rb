class HempayAccount < ApplicationRecord
  belongs_to :user
  has_many :payments, as: :source
end
