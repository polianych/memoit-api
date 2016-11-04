class ApplicationController < ActionController::API
  include AuthenticatableController

  rescue_from 'ActionController::ParameterMissing' do |e|
    render json: { errors: [e.message]}, status: 400
  end
end
