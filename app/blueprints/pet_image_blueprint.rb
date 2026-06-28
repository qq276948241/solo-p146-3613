class PetImageBlueprint < Blueprinter::Base
  identifier :id

  fields :url, :created_at
end
