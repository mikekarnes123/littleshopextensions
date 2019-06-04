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

      within(".to-do-list") do
        within("#id-#{item_3.id}-needs-img") do
          expect(page).to have_link('here')
          click_link('here')
        end
      end
      expect(current_path).to eq(edit_merchant_item_path(item_3))
    end

    it 'should display info about unfulfilled orders' do
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)
      item_2 = create(:item, user: merchant)
      oi_1 = create(:order_item, item: item_1, quantity: 10, price_per_item: 10)
      oi_2 = create(:order_item, item: item_2, quantity: 5, price_per_item: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit merchant_dashboard_path

      within(".to-do-list") do
        expect(page).to have_content("You have 2 unfulfilled orders worth $150.00")
      end
    end

    it 'should display a notification if insuficiant stock' do
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant, inventory: 0)
      item_2 = create(:item, user: merchant)

      oi_1 = create(:order_item, item: item_1, quantity: 10, price_per_item: 10)
      oi_2 = create(:order_item, item: item_2, quantity: 5, price_per_item: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit merchant_dashboard_path

      within("#merchant-orders-#{oi_1.order.id}") do
        expect(page).to have_content("Not Enough Stock To Complete Order")
      end
    end
  end
end
