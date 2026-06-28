class Api::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:register, :login]

  def register
    user = User.new(user_params)
    if user.save
      token = JwtService.encode(user_id: user.id)
      data = UserBlueprint.render_as_hash(user, view: :login, token: token)
      render_success(data, '注册成功')
    else
      render_validation_error(user)
    end
  end

  def login
    user = User.find_by(phone: params[:phone])
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      data = UserBlueprint.render_as_hash(user, view: :login, token: token)
      render_success(data, '登录成功')
    else
      render_error(:login_failed, status: :unauthorized)
    end
  end

  private

  def user_params
    params.permit(:phone, :password, :password_confirmation, :nickname, :avatar_url, :wechat, :real_name, :experience)
  end
end
