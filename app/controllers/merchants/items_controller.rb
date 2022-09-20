class Merchants::ItemsController < ApplicationController

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
      @item.update(status: params[:status])
      redirect_to merchant_items_path(merchant.id)
    elsif @item.update(item_params)
      flash[:success] = "#{@item.name} has been successfully updated."
      redirect_to merchant_item_path(merchant.id, @item.id)
    else
      flash[:error] = "Entry is invalid. Please fill in all entries with valid information."
      render :edit
    end
  end

  def new
    @item = Item.new(merchant_id: params[:merchant_id])
  end

  def create
    params[:item][:merchant_id] = params[:merchant_id]
    @item = Item.new(item_params)

    if @item.save
      redirect_to merchant_items_path(params[:merchant_id])
      flash[:success] = "#{@item.name} has been successfully created."
    else
      flash[:error] = "Entry is invalid. Please fill in all entries with valid information."
      render :new
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
end