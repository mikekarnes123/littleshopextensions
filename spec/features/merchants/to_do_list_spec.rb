require 'rails_helper'

RSpec.describe "Merchant To-Do", type: :feature do
  context "as a merchant" do
    it "should display items with default image" do
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)
      item_2 = create(:item, user: merchant)
      item_3 = merchant.items.create(name: 'Item 1', active: true, price: 1.00, description: 'Stuff 1', inventory: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit merchant_dashboard_path
      save_and_open_page
      within(".to-do-list") do
        within("#id-#{item_3.id}-needs-img") do
          expect(page).to have_link('here')
          click_link('here')
        end
      end
      expect(current_path).to eq(edit_merchant_item_path(item_3))
    end
  end
end
