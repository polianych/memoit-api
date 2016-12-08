class SubscriptionsController < ApplicationController
  before_action :authtenticate_user!

  def index
    @subscriptions = Subscription.with_meta_data.where(user: current_user).page(params.fetch(:page, 1)).per(10)
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
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
