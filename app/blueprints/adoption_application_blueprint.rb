class AdoptionApplicationBlueprint < Blueprinter::Base
  identifier :id

  fields :status, :applicant_name, :applicant_phone, :applicant_wechat, :experience, :reason, :created_at, :updated_at

  association :pet, blueprint: PetBlueprint

  view :with_applicant do
    association :applicant, blueprint: UserBlueprint
  end

  view :rescuer_view do
    fields :applicant_name, :applicant_phone, :applicant_wechat, :experience, :reason
    association :pet, blueprint: PetBlueprint
    association :applicant, blueprint: UserBlueprint
  end
end
