class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates_presence_of :email,
                        :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :role
  has_many :orders
  has_many :items

  enum role: ['user', 'merchant', 'admin']

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password_digest

  has_secure_password

  def self.active_merchants
    where(active: true, role: 'merchant')
  end

  def top_five_items
    items.select("items.* , sum(order_items.quantity) as total_sold")
         .joins(:orders)
         .group(:id)
         .where("orders.status = 2" )
         .order("total_sold desc")
         .limit(5)
  end

  def total_sold
    items.joins(:orders)
          .where(active: true)
          .where("orders.status = 2")
          .sum("order_items.quantity")
  end

  def total_inventory
    items.where(active: true).sum(:inventory)
  end

  def inventory_ratio
    (total_sold / total_inventory.to_f) * 100
  end

  def top_three_states
    # items.select("users.*, sum(order_items.quantity) as item_quantity").joins(:orders).group("users.state").order("item_quantity").limit(3)
    require "pry"; binding.pry
    # self.items.joins(:orders).joins(:users).select("sum(order_items.quantity) as total_quantity").select("users.state, users.city")
  end
end
