class Contact < ApplicationRecord
  belongs_to :user
  has_many :phone_numbers, :dependent => :destroy
end
