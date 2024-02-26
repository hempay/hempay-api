class V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    render json: V1::UserSerializer.new(user).serializable_hash
  end

  private

  def authenticate_user!
    head :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end
end
