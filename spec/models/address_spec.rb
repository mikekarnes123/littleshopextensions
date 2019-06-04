require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validates' do
    it {should validate_presence_of :title}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'relationships' do
    it {should belong_to :user}
  end
end
