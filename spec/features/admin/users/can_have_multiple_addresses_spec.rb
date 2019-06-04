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

    xit 'should allow each address to be deleted' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      click_link("Add Another Address")

      fill_in "address[street_address]", with: "123 go to santa "
      fill_in "address[title]", with: "work"
      fill_in "address[city]", with: "frog"
      fill_in "address[state]", with: "frogland"
      fill_in "address[zip]", with: "123311"
      click_on "Create Address"

      within("#address-id-#{user.addresses.last.id}") do
        click_on "Delete This Address"
      end



      expect(current_path).to eq(profile_path)
      save_and_open_page
      expect(page).to_not have_content("123 go to santa")
      expect(page).to_not have_content("work")
      expect(page).to_not have_content("frog")

    end
  end

  xit 'allows a user to edit an existing address' do
    user = create(:user)
    address = user.addresses.create(title: 'work', street_address: 'road street', city: 'abcton', state: 'CO', zip: '818189')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path

    within("#address-id-#{address.id}") do
      click_link("Edit")
    end

    expect(current_path).to eq(edit_user_address_path(user, address))

    fill_in "address[title]", with: "lake house"
    click_on "Update Address"

    expect(current_path).to eq(profile_path)

    within("#address-id-#{user.addresses.last.id}") do
      expect(page).to have_content("lake house")
    end
  end

end
