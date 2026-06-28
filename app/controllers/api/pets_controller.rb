class Api::PetsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    pets = Pet.listed.by_species(params[:species]).by_size(params[:size])
    pets = pets.order(created_at: :desc).page(pagination_params[:page]).per(pagination_params[:per_page])
    render_paginated(pets, PetBlueprint, view: :with_user)
  end

  def show
    pet = Pet.find(params[:id])
    data = PetBlueprint.render_as_hash(pet, view: :with_user)
    render_success(data)
  end

  def create
    pet = current_user.pets.build(pet_params)
    if pet.save
      if params[:images].present?
        params[:images].each do |url|
          pet.pet_images.create!(url: url)
        end
      end
      data = PetBlueprint.render_as_hash(pet)
      render_success(data, '创建成功')
    else
      render_validation_error(pet)
    end
  end

  def update
    pet = current_user.pets.find(params[:id])
    if pet.update(pet_params)
      if params[:images].present?
        pet.pet_images.destroy_all
        params[:images].each do |url|
          pet.pet_images.create!(url: url)
        end
      end
      data = PetBlueprint.render_as_hash(pet)
      render_success(data, '更新成功')
    else
      render_validation_error(pet)
    end
  end

  def destroy
    pet = current_user.pets.find(params[:id])
    pet.destroy!
    render_success(nil, '删除成功')
  end

  def publish
    pet = current_user.pets.find(params[:id])
    pet.list!
    data = PetBlueprint.render_as_hash(pet)
    render_success(data, '已上架')
  end

  def unpublish
    pet = current_user.pets.find(params[:id])
    pet.unlist!
    data = PetBlueprint.render_as_hash(pet)
    render_success(data, '已下架')
  end

  private

  def pet_params
    params.permit(:name, :species, :breed, :size, :age_months, :gender, :source, :status, :description)
  end
end
