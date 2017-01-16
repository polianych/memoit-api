class UsersController < ApplicationController
  before_action :authtenticate_user!, except: [:create, :show]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.with_user_subscriptions(current_user).page(params.fetch(:page, 1)).per(5)
    @users = @users.search(params[:search_query]) if params[:search_query]
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if !@user
      head :not_found
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params.merge(provider: 'email'))
    if @user.save
      sign_in(@user)
      render_user(@user, :created)
    else
      render json: { errors_fields: @user.errors, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: { errors_fields: @user.errors, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = if params[:id] == 'me'
        authtenticate_user!
        current_user
      else
        User.find_by(nickname: params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
    end
end
