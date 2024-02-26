class Currency < ApplicationRecord
    has_many :payments
    
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :symbol, presence: true, uniqueness: true
    validates :exchange_rate, presence: true, numericality: { greater_than: 0 }
    
    def self.default
        find_by(code: 'NGN')
    end

    def to_s
        "#{name} (#{code})"
    end

    def to_param
        code
    end

    def convert_to(amount, currency)
        (amount / exchange_rate) * currency.exchange_rate
    end

    def convert_from(amount, currency)
        (amount / currency.exchange_rate) * exchange_rate
    end

    def convert(amount, from_currency, to_currency)
        amount = convert_to(amount, from_currency)
        convert_from(amount, to_currency)
    end

    def convert_to_default(amount)
        convert_to(amount, Currency.default)
    end

    def convert_from_default(amount)
        convert_from(amount, Currency.default)
    end
end
