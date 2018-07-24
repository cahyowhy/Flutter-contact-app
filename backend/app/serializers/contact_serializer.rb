class ContactSerializer < ActiveModel::Serializer
  attributes :id, :website, :email, :created_at
  has_many :phone_numbers
end