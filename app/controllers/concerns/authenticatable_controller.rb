module AuthenticatableController
  extend ActiveSupport::Concern

  def authtenticate_user!
    return(render json: { error: 'You have to be signed in to do this' }, status: :unauthorized) unless user_signed_in?
  end

  def current_user
    @current_user ||= User.authtenticate_by_token(request.headers["Client"], request.headers['Authorization'])
  end

  def user_signed_in?
    current_user.present?
  end

  def sign_in(user)
    UserToken.destroy_expired(user)
    user_token = UserToken.create(user_id: user.id)
    set_token_headers(user_token)
  end

  def render_user(user, status = :ok)
    @user = user
    render "users/show", status: status, location: @user
  end

  def set_token_headers(user_token)
    response.headers['Authorization'] = user_token.token
    response.headers['Client'] = user_token.client
  end

  def sign_out
    UserToken.where(client: request.headers["Client"]).destroy_all
    response.headers.delete('Authorization')
    response.headers.delete('Client')
  end

end
