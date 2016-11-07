class PasswordResetsController < ApplicationController

  def create
    @user = User.find_by(email: params.require(:email))
    return render json: { errors: ['User not found with this email.']}, status: 422 unless @user
    return render json: { errors: ["User with this email registred via #{@user.provider.capitalize}."]}, status: 422 if @user.provider != 'email'
    PasswordReset.where(user_id: @user.id).destroy_all
    @password_reset = PasswordReset.create(user: @user)
    @password_reset.send_password_reset_instructions(params.require(:password_reset_url)) if @password_reset.persisted?
    render json: {}, status: :created
  end


  def update
    @password_reset = PasswordReset.find_by(uri: params[:id])
    if !@password_reset || !@password_reset.valid_token?(params.require(:password_reset_token))
      return render json: { errors: ['Token expired or invalid.'] }, status: 422
    end
    if @password_reset.user.update_attributes(user_params)
      @password_reset.destroy
      render json: {}, status: :ok
    else
      render json: { errors_fields: @password_reset.user.errors, errors: @password_reset.user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
