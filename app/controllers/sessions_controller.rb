class SessionsController < ApplicationController
  before_filter :authtenticate_user!, only: [:destroy]
  def create
    @user = User.find_by(email: params[:user][:email], provider: 'email')
    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      render_user(@user)
    else
      render json: { errors: {}, errors_full: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  def destroy
    sign_out
    render json: {}, status: :ok
  end
end
