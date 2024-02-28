class V1::Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :authorize_bank_staff, only: %i[update_kyc_status update_can_transact]

  respond_to :json

  def update_kyc_status
    # Authorization logic goes here
    if current_user.bank_staff?
      # Update KYC status logic goes here
      render json: { message: 'KYC status updated successfully' }, status: :ok
    else
      render json: { error: 'Unauthorized', message: 'You are not authorized to perform this action' },
             status: :unauthorized
    end
  end

  def update_can_transact
    # Authorization logic goes here
    if current_user.bank_staff?
      # Update can_transact status logic goes here
      render json: { message: 'Can transact status updated successfully' }, status: :ok
    else
      render json: { error: 'Unauthorized', message: 'You are not authorized to perform this action' },
             status: :unauthorized
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username first_name last_name date_of_birth employment_status bvn
                                               home_address office_address phone_number email avatar])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[first_name last_name date_of_birth employment_status bvn
                                               kyc_status home_address
                                               office_address phone_number can_transact email avatar])
  end

  def respond_with(resource, _opts = {})
    if request.method == 'POST' && resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: V1::UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == 'DELETE'
      render json: {
        status: { code: 200, message: 'Account deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end
end
