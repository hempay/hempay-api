class V1::UserSerializer
  include JSONAPI::Serializer

  attributes :id, :username, :email, :first_name, :last_name, :middle_name, :date_of_birth,
             :employment_status, :bvn, :kyc_status, :home_address, :office_address, :phone_number,
             :can_transact, :avatar

  attribute :avatar do |object|
    {
      thumb: object.avatar&.url(:thumb),
      medium: object.avatar&.url(:medium),
      large: object.avatar&.url(:large)
    }
  end
end
