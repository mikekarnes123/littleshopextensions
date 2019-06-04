require 'rails_helper'

RSpec.describe "Users can have multiple addresses", type: :feature do
  context 'as a user when I visit my profile' do
    it 'should allow me to add additional addresses' do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit profile_path

        expect(page).to have_content(user.address)
        expect(page).to have_link("Add Another Address")

        click_link("Add Another Address")

        expect(current_path).to eq(new_user_address_path(user))

        fill_in "address[street_address]", with: "123 go to santa lane"
        fill_in "address[title]", with: "work"
        fill_in "address[city]", with: "aurora"
        fill_in "address[state]", with: "colorado"
        fill_in "address[zip]", with: "123311"
        click_on "Create Address"

        expect(current_path).to eq(profile_path)
        expect(page).to have_content(user.address)
        expect(page).to have_content("123 go to santa lane")


    end
  end
end
