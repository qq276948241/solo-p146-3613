class PetBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :species, :breed, :size, :age_months, :gender, :source, :status, :description, :created_at, :updated_at

  association :pet_images, blueprint: PetImageBlueprint

  view :with_user do
    association :user, blueprint: UserBlueprint
  end

  view :list do
    excludes :description
  end
end
