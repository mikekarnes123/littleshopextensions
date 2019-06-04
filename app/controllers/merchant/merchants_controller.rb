class Merchant::MerchantsController < Merchant::BaseController
  def show
    @merchant = current_user
    @merchant_orders = Order.pending_merchant_orders(@merchant)
    @no_image_items = @merchant.items.with_no_image
  end
end
