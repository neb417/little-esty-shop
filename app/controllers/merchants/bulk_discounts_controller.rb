class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new(merchant_id: params[:merchant_id])
  end

  def create
    params[:bulk_discount][:merchant_id] = params[:merchant_id]
    @bulk_discount = BulkDiscount.new(bulk_params)
    @merchant = Merchant.find(params[:merchant_id])
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
      flash[:success] = "Your Bulk Discount has been Created."
    else
      flash[:error] = "Please Create Bulk Discount with valid information"
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private
  
  def bulk_params
    params.require(:bulk_discount).permit(
      :name,
      :threshold,
      :percentage,
      :merchant_id
    )
  end
end