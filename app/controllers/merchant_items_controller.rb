class MerchantItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    @top_five = @merchant.top_five_revenue
  end

  def show
    binding.pry

    # @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])

    if params.has_key?(:status)
      item.update(item_params)
      redirect_to merchant_items_path(merchant.id)
    elsif item.update(item_params)
      flash[:success] = "#{item.name} has been successfully updated."
      redirect_to merchant_item_path(merchant.id, item.id)
    else
      flash[:error] = "Entry is invalid. Please fill in all entries with valid information."
      redirect_to edit_merchant_item_path(merchant.id, item.id)
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    item = Item.new(item_params)
    if item.save
      redirect_to merchant_items_path(params[:merchant_id])
      flash[:success] = "#{item.name} has been successfully created."
    else
      flash[:error] = "Entry is invalid. Please fill in all entries with valid information."
      redirect_to new_merchant_item_path(params[:merchant_id])
    end
  end

  private

  def item_params
    params.permit(
      :name,
      :description,
      :unit_price,
      :merchant_id,
      :status
    )
  end
end