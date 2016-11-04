class OauthController < ApplicationController

  def create
    provider_class = "Oauth::#{params[:provider].try(:capitalize)}".safe_constantize
    return render json: { errors: ["Invalid oauth provider"] }, status: :unprocessable_entity if !provider_class || params[:provider].blank?

    provider_client = provider_class.new
    result = provider_client.get_user_data(params[:access_token])
    return render json: { errors: ["Invalid access_token"] }, status: :unprocessable_entity unless result

    user = User.find_by(provider: params[:provider], uid: result["id"])
    sign_in(user) && render_user(user) and return if user

    result['uid'] = result.delete('id')
    user = User.new(result.merge(provider: params[:provider], nickname: params[:nickname]))
    if user.save
      sign_in(user) && render_user(user)
    else
      render json: { errors_fields: user.errors, errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
