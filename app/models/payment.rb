class Payment < ApplicationRecord
  belongs_to :source, polymorphic: true

  belongs_to :currency
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :amount, presence: true
  validates :payment_date, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :currency_code, presence: true
  validates :currency, presence: true
  validates :sender, presence: true
  validates :receiver, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending completed failed] }
  validates :currency_code, inclusion: { in: proc { Currency.pluck(:code) } }
  validate :sender_can_transact
  validate :receiver_can_transact
  validate :sender_has_enough_balance

  before_validation :set_currency

  def set_currency
    self.currency = Currency.find_by(code: currency_code)
  end

  def process_payment
    raise StandardError, errors.full_messages.join(', ') unless valid?

    Payment.transaction do
      case status
      when 'pending'
        process_pending_payment
      when 'failed'
        process_failed_payment
      when 'completed'
        raise StandardError, 'Payment has already been completed'
      else
        raise StandardError, 'Invalid status'
      end
    end
  end

  def sender_can_transact
    errors
      .add(:sender, 'cannot transact')
      .unless(sender&.can_transact)

    errors
      .add(:sender, 'has not been KYC verified')
      .unless(sender&.kyc_status)
  end

  def receiver_can_transact
    errors
      .add(:receiver, 'cannot transact')
      .unless(receiver&.can_transact)

    errors
      .add(:receiver, 'has not been KYC verified')
      .unless(receiver&.kyc_status)
  end

  def sender_has_enough_balance
    errors
      .add(:sender, 'does not have enough balance')
      .unless(sender&.balance&.>= amount)
  end

  def self.pending
    where(status: 'pending')
  end

  def self.completed
    where(status: 'completed')
  end

  def self.failed
    where(status: 'failed')
  end

  def self.total_amount
    sum(:amount)
  end

  def self.total_amount_in_currency(currency_code)
    where(currency_code:).sum(:amount)
  end

  def self.total_amount_in_ngn
    total_amount_in_currency('NGN')
  end

  def self.total_amount_in_usd
    total_amount_in_currency('USD')
  end

  def self.total_amount_in_eur
    total_amount_in_currency('EUR')
  end

  private

  def process_pending_payment
    sender.decrement!(:balance, amount)
    receiver.increment!(:balance, amount)
    update_columns(status: 'completed')
  end

  def process_failed_payment
    update_columns(status: 'failed')
  end
end
