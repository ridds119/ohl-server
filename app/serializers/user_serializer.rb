class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role, :password, :avatar
end
