class MessageBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :content, :is_read, :created_at, :updated_at

  association :sender, blueprint: UserBlueprint
  association :receiver, blueprint: UserBlueprint
  association :pet, blueprint: PetBlueprint
  association :application, blueprint: AdoptionApplicationBlueprint
end
