RSpec.describe OrderItem, type: :model do
  describe "Validations" do
    it { should validate_presence_of :price_per_item}
    it { should validate_presence_of :quantity}
  end

  describe "relationships" do
    it { should belong_to :item}
    it { should belong_to :order}
  end

  describe "instance methods" do
    it "#cancel changes fulfilled to false and returns inventory to the merchant's item" do
      pending_order = create(:order) # pending by default

      item_1_initial_inventory = 30
      item_2_initial_inventory = 40
      item_1 = create(:item, inventory: item_1_initial_inventory)
      item_2 = create(:item, inventory: item_2_initial_inventory)

      oi_1 = create(:order_item, order: pending_order, item: item_1, quantity: 10)
      oi_2 = create(:fulfilled_order_item, order: pending_order, item: item_2, quantity: 5)

      oi_1.cancel

      expect(oi_1.reload.fulfilled).to eq(false)
      expect(item_1.reload.inventory).to eq(item_1_initial_inventory)

      oi_2.cancel

      expect(oi_2.reload.fulfilled).to eq(false)
      expect(item_2.reload.inventory).to eq(item_2_initial_inventory + oi_2.quantity)
    end

    it "#update_item_inventory" do
      user = create(:user)
      order_1 = create(:order, user: user)

      user_2 = create(:user)
      order_2 = create(:order, user: user_2)

      merchant = create(:merchant)
      item_1 = create(:item, user: merchant, inventory: 10)

      oi_1 = create(:order_item, item: item_1, order: order_1, quantity: 3, price_per_item: item_1.price)
      oi_2 = create(:order_item, item: item_1, order: order_2, quantity: 5, price_per_item: item_1.price)

      oi_1.update_item_inventory
      expect(item_1.inventory).to eq(7)

      oi_2.update_item_inventory
      expect(item_1.inventory).to eq(2)
    end
  end
end
