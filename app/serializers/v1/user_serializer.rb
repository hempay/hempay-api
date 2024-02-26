class V1::UserSerializer
  include JSONAPI::Serializer

  attributes :id, :username, :email, :avatar_thumb_url, :avatar_medium_url, :avatar_large_url,
             :first_name, :last_name, :middle_name, :date_of_birth, :employment_status,
             :bvn, :kyc_status, :home_address, :office_address, :phone_number,
             :can_transact

  def avatar_thumb_url
    object.avatar.url(:thumb)
  end

  def avatar_medium_url
    object.avatar.url(:medium)
  end

  def avatar_large_url
    object.avatar.url(:large)
  end
end
