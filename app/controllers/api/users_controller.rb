class Api::UsersController < ApplicationController
  def me
    data = UserBlueprint.render_as_hash(current_user, view: :detail)
    render_success(data)
  end

  def update
    if current_user.update(user_params)
      data = UserBlueprint.render_as_hash(current_user, view: :detail)
      render_success(data, '更新成功')
    else
      render_validation_error(current_user)
    end
  end

  def my_pets
    pets = current_user.pets.order(created_at: :desc).page(pagination_params[:page]).per(pagination_params[:per_page])
    render_paginated(pets, PetBlueprint, view: :default)
  end

  private

  def user_params
    params.permit(:nickname, :avatar_url, :wechat, :real_name, :experience)
  end
end
