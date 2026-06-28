class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :phone, :nickname, :avatar_url, :real_name, :experience, :created_at, :updated_at

  field :masked_wechat, name: :wechat do |user|
    user.masked_wechat
  end

  view :detail do
    field :wechat do |user|
      user.wechat
    end
  end

  view :login do
    field :token do |user, options|
      options[:token]
    end
  end
end
