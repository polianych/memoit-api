class OauthController < ApplicationController
  before_action :check_provider

  def login
    @user = User.find_by(provider: params[:provider], uid: @user_data["id"])
    if @user
      sign_in(@user) && render_user(@user)
    else
      return(render json: { errors: ['User not registred'] }, status: :unauthorized)
    end
  end

  def sign_up
    @user_data['uid'] = @user_data.delete('id')
    @user = User.new(@user_data.merge(provider: params[:provider]).merge(user_params))
    if @user.save
      sign_in(@user) && render_user(@user, :created)
    else
      render json: { errors_fields: @user.errors, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:nickname, :email, :name)
    end

    def check_provider
      provider_class = "Oauth::#{params[:provider].try(:capitalize)}".safe_constantize
      return render json: { errors: ["Invalid oauth provider"] }, status: :unprocessable_entity if !provider_class || params[:provider].blank?

      provider_client = provider_class.new
      @user_data = provider_client.get_user_data(params[:access_token])
      return render json: { errors: ["Invalid access_token"] }, status: :unprocessable_entity unless @user_data
    end
end
