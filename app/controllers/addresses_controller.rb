class AddressesController < ApplicationController
  def new
    @user = current_user
    @address = Address.new
  end

  def create
    current_user.addresses.create(address_params)
    redirect_to profile_path
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_path
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    address.update(address_params)
    redirect_to profile_path
  end

  private

  def address_params
    params.require(:address).permit(:title, :street_address, :city, :state, :zip)
  end
end
