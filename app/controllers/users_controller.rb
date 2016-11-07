class UsersController < ApplicationController
  before_action :authtenticate_user!, except: [:create]
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
    @users = User.all
    def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = params[:id] == 'me' ? current_user : User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
    end
end
