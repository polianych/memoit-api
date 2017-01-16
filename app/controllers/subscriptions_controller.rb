class SubscriptionsController < ApplicationController
  before_action :authtenticate_user!, except: [:index]

  def index
    user_id = params[:user_id] ? params[:user_id] : current_user.try(:id)
    @subscriptions = Subscription.with_user_subscriptions( current_user, { user_id: user_id.to_i } ).page(params.fetch(:page, 1)).per(10)
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      @subscription = Subscription.with_user_subscriptions( current_user, { id: @subscription.id } ).first
      render :show, status: :created
    else
      render json: { errors_fields: @subscription.errors, errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription = Subscription.find_by(id: params[:id], user_id: current_user.id)
    if @subscription
      @subscription.destroy
      head :ok
    else
      head :not_found
    end
  end

  private

    def subscription_params
      params.require(:subscription).permit(:publisher_type, :publisher_id).merge(user_id: current_user.id)
    end

end
