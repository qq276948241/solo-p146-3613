class ApplicationController < ActionController::API
  include ErrorResponses
  include ResponseFormatter

  before_action :authenticate_request, except: [:root]

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound do
    render_error(:not_found, status: :not_found)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    if e.record.errors[:phone]&.include?('has already been taken')
      render_error(:phone_taken)
    else
      render_validation_error(e.record)
    end
  end

  rescue_from ActionController::ParameterMissing do |e|
    render_error(:validation_error, detail: e.message)
  end

  private

  def authenticate_request
    token = extract_token
    unless token
      render_error(:unauthorized, status: :unauthorized)
      return
    end

    decoded = JwtService.decode(token)
    unless decoded && decoded[:user_id]
      render_error(:invalid_token, status: :unauthorized)
      return
    end

    @current_user = User.find_by(id: decoded[:user_id])
    unless @current_user
      render_error(:unauthorized, status: :unauthorized)
    end
  end

  def extract_token
    header = request.headers['Authorization']
    return nil unless header

    header.split(' ').last
  end

  def current_user?(user)
    current_user&.id == user&.id
  end
end
