class PhoneNumberSerializer < ActiveModel::Serializer
  attributes :phone_number, :created_at, :id
end