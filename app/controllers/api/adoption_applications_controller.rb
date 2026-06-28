class Api::AdoptionApplicationsController < ApplicationController
  def create
    pet = Pet.find(params[:pet_id])

    unless pet.listed?
      render_error(:pet_not_listed)
      return
    end

    if pet.user_id == current_user.id
      render_error(:cannot_apply_own_pet)
      return
    end

    existing = AdoptionApplication.find_by(pet_id: pet.id, applicant_id: current_user.id)
    if existing
      render_error(:duplicate_application)
      return
    end

    application = AdoptionApplication.new(application_params)
    application.pet = pet
    application.applicant = current_user

    if application.save
      data = AdoptionApplicationBlueprint.render_as_hash(application)
      render_success(data, '申请提交成功')
    else
      render_validation_error(application)
    end
  end

  def index
    applications = current_user.adoption_applications.by_status(params[:status])
    applications = applications.order(created_at: :desc).page(pagination_params[:page]).per(pagination_params[:per_page])
    render_paginated(applications, AdoptionApplicationBlueprint)
  end

  def received
    pet_ids = current_user.pets.pluck(:id)
    applications = AdoptionApplication.where(pet_id: pet_ids).by_status(params[:status])
    applications = applications.order(created_at: :desc).page(pagination_params[:page]).per(pagination_params[:per_page])
    render_paginated(applications, AdoptionApplicationBlueprint, view: :rescuer_view)
  end

  def show
    application = AdoptionApplication.find(params[:id])

    unless can_view_application?(application)
      render_error(:forbidden, status: :forbidden)
      return
    end

    view = application.pet.user_id == current_user.id ? :rescuer_view : :default
    data = AdoptionApplicationBlueprint.render_as_hash(application, view: view)
    render_success(data)
  end

  def approve
    application = AdoptionApplication.find(params[:id])

    unless application.pet.user_id == current_user.id
      render_error(:forbidden, status: :forbidden)
      return
    end

    unless application.pending?
      render_error(:application_not_pending)
      return
    end

    if application.approve!
      data = AdoptionApplicationBlueprint.render_as_hash(application, view: :rescuer_view)
      render_success(data, '审核通过，已发送通知')
    else
      render_validation_error(application)
    end
  end

  def reject
    application = AdoptionApplication.find(params[:id])

    unless application.pet.user_id == current_user.id
      render_error(:forbidden, status: :forbidden)
      return
    end

    unless application.pending?
      render_error(:application_not_pending)
      return
    end

    if application.reject!
      data = AdoptionApplicationBlueprint.render_as_hash(application, view: :rescuer_view)
      render_success(data, '已拒绝申请')
    else
      render_validation_error(application)
    end
  end

  private

  def application_params
    params.permit(:applicant_name, :applicant_phone, :applicant_wechat, :experience, :reason)
  end

  def can_view_application?(application)
    application.applicant_id == current_user.id || application.pet.user_id == current_user.id
  end
end
