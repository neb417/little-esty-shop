class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = NagerFacade.generate_holidays
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

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(@bulk_discount.merchant_id)

    if @bulk_discount.update(bulk_params)
      flash[:success] = "Successful Update of #{@bulk_discount.name}"
      redirect_to merchant_bulk_discount_path(@merchant.id, @bulk_discount.id)
    else
      flash[:error] = "Please enter valid information to Update Bulk Discount"
      render :edit
    end
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