# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user_from_token!

  # POST /v1/login
  def create
    @user = User.find_for_database_authentication(email: params[:email])
    return invalid_email unless @user

    if @user.valid_password?(params[:password])
      sign_in :user, @user
      render json: @user, serializer: SessionSerializer, root: nil
    else
      invalid_password
    end
  end
  ##
  # Health check endpoint
  # Check connection to DB and returns 200
  def health
    render json: { health: "DB Connection OK"}, status: 200 if ActiveRecord::Base.connected? 
  end

  private

  def invalid_email
    warden.custom_failure!
    render json: { error: t('invalid_email') }
  end

  def invalid_password
    warden.custom_failure!
    render json: { error: t('invalid_password') }
  end
end
