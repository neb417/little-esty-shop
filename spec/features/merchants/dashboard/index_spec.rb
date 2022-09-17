require 'rails_helper'

RSpec.describe 'Merchant Dashboard Index' do
  before :each do
    @merchant = create(:merchant)
    visit merchant_dashboard_index_path(@merchant.id)
  end

  it 'lists the merchant name' do
    expect(page).to have_content(@merchant.name)
  end

  it 'has a link to merchant items index' do
    expect(page).to have_link("My Items")

    click_link("My Items")

    expect(current_path).to eq(merchant_items_path(@merchant.id))
  end

  it 'has a link to merchant invoices index' do
    expect(page).to have_link("My Invoices")

    click_link("My Invoices")
    
    expect(current_path).to eq(merchant_invoices_path(@merchant.id))
  end

  it 'lists the merchants top 5 customers' do
    item = create(:item, merchant: @merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    customer_4 = create(:customer)
    customer_5 = create(:customer)

    invoice_1 = create(:invoice, customer: customer_1)
    invoice_2 = create(:invoice, customer: customer_2)
    invoice_3 = create(:invoice, customer: customer_3)
    invoice_4 = create(:invoice, customer: customer_4)
    invoice_5 = create(:invoice, customer: customer_5)

    invoice_1.items << item
    invoice_2.items << item
    invoice_3.items << item
    invoice_4.items << item
    invoice_5.items << item

    transaction_1 = create(:transaction, invoice: invoice_1, result: :success)
    transaction_2 = create(:transaction, invoice: invoice_2, result: :success)
    transaction_3 = create(:transaction, invoice: invoice_3, result: :success)
    transaction_4 = create(:transaction, invoice: invoice_4, result: :success)
    transaction_5 = create(:transaction, invoice: invoice_5, result: :success)

    visit merchant_dashboard_index_path(@merchant.id)
    
    within("div#favorite_customers") do
      expect(page).to have_content("#{@merchant.top_five_customers[0].first_name} #{@merchant.top_five_customers[0].last_name}")
      expect(page).to have_content("#{@merchant.top_five_customers[1].first_name} #{@merchant.top_five_customers[1].last_name}")
      expect(page).to have_content("#{@merchant.top_five_customers[2].first_name} #{@merchant.top_five_customers[2].last_name}")
      expect(page).to have_content("#{@merchant.top_five_customers[3].first_name} #{@merchant.top_five_customers[3].last_name}")
      expect(page).to have_content("#{@merchant.top_five_customers[4].first_name} #{@merchant.top_five_customers[4].last_name}")
    end
  end
end