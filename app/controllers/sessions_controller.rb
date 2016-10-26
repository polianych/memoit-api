class SessionsController < ApplicationController
  before_filter :authtenticate_user!, only: [:destroy]
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      render "users/show", status: :created, location: @user
    else
      render json: { error: 'Wrong email/password'}, status: :unauthorized
    end
  end

  def destroy
    sign_out
    render json: {}, status: :ok
  end
end
