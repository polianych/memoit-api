class UsersController < ApplicationController
  before_action :authtenticate_user!, except: [:index, :create, :show]
  before_action :set_user, only: [:show]

  def index
    @users = params[:search_query] ? User.search(params[:search_query]) : User.all
    @users = @users.page(params.fetch(:page, 1))
                   .per(params.fetch(:per_page, Settings.default_per_page))
                   .order(created_at: :asc)
                   .with_user_subscriptions(current_user)
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
    @user = current_user
    @user.validate_password = true if user_edit_params.keys.include? "password"
    if @user.update(user_edit_params)
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

    def user_edit_params
      params.require(:user).permit(:nickname, :name, :current_password, :password, :password_confirmation)
    end
end
