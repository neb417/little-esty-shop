class ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    @top_five = @merchant.top_five_revenue
  end

  def show
    @item = Item.find(params[:id])
    @merchant = Merchant.find(@item.merchant_id)
  end

  def edit
    @item = Item.find(params[:id])
    @merchant = Merchant.find(@item.merchant_id)
  end

  def update
    @item = Item.find(params[:id])
    merchant = Merchant.find(@item.merchant_id)
    if params.has_key?(:status)
      @item.update(strong_params)
      redirect_to merchant_items_path(merchant.id)
    elsif @item.update(item_params)
      flash[:success] = "#{@item.name} has been successfully updated."
      redirect_to item_path(@item.id)
    else
      flash[:error] = "Entry is invalid. Please fill in all entries with valid information."
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :description,
      :unit_price,
      :merchant_id,
      :status
    )
  end

  def strong_params
    params.permit(
      :name,
      :description,
      :unit_price,
      :merchant_id,
      :status
    )
  end
end