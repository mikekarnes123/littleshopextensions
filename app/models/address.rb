class Address < ApplicationRecord
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
end
