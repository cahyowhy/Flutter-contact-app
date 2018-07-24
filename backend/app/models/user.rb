class User < ApplicationRecord
  has_many :contacts, :dependent => :destroy, inverse_of: :user
  has_many :user_groups, :dependent => :destroy
  accepts_nested_attributes_for :contacts
  scope :start_with, -> (column_name, value) {where(["#{column_name} like ?", "#{value.capitalize}%"])}
end
