class PostsController < ApplicationController
  before_action :authtenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    #TODO validate publisher_type and publisher_id
    if params[:publisher_type] && params[:publisher_id]
      @posts = Post.where(publisher_type: params[:publisher_type], publisher_id: params[:publisher_id])
    elsif user_signed_in?
      @posts = params[:publisher_type] ? Post.for_user(current_user).where(publisher_type: params[:publisher_type]) : Post.for_user(current_user)
    else
      @posts = Post.all
    end
    @posts = @posts.with_meta_data
                   .page(params.fetch(:page, 1))
                   .per(params.fetch(:per_page, Settings.default_per_page))
  end

  def show
  end

  def create
    @user_post = UserPost.new(user_post_params.merge(post_attributes: post_params))
    @post = @user_post.post
    if @user_post.save
      render :show, status: :created
    else
      render json: { errors_fields: @post.errors, errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render :show, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private
    def set_post
      @post = Post.with_meta_data.find(params[:id])
    end

    def user_post_params
      params.require(:post).permit(:link, :image_url, :video_url)
    end

    def post_params
      params.require(:post).permit(:content).merge(publisher_type: 'User', publisher_id: current_user.id)
    end
end
