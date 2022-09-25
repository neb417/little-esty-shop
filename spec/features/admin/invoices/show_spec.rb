require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page' do
  describe 'Admin Invoices Index Page' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Merchant 1')
  
      @customer_1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      @customer_2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')
  
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-25 09:54:09')
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 1, created_at: '2012-03-25 09:30:09')
  
      @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @merchant_1.id)
      @item_2 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @merchant_1.id)
  
      @invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 200, status: 0)
      @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 6, unit_price: 100, status: 1)
      @invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 87, unit_price: 1200, status: 2)
  
      visit admin_invoice_path(@invoice_1.id)
    end
  
    it 'should display the id, status and created_at' do
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_content("Created on: #{@invoice_1.created_at.strftime("%A, %B %d, %Y")}")
  
      expect(page).to_not have_content("Invoice ##{@invoice_2.id}")
    end
  
    it 'should display all the items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
  
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_2.quantity)
  
      expect(page).to have_content("#{price_convert(@invoice_item_1.unit_price)}")
      expect(page).to have_content("#{price_convert(@invoice_item_2.unit_price)}")
  
      expect(page).to have_content(@invoice_item_1.status.titleize)
      expect(page).to have_content(@invoice_item_2.status.titleize)

    end
  
    it 'should display the total revenue the invoice will generate' do
      expect(page).to have_content("Total Revenue: #{price_convert(@invoice_1.total_revenue)}")
  
      expect(page).to_not have_content(@invoice_2.total_revenue)
    end
  
    it 'should have status as a select field that updates the invoices status' do
      within("#status-update-#{@invoice_1.id}") do
        select('Cancelled', :from => 'invoice[status]')
        expect(page).to have_button('Update Invoice')
        click_button 'Update Invoice'
  
        expect(current_path).to eq(admin_invoice_path(@invoice_1))
        expect(@invoice_1.status).to eq('cancelled')
      end
    end
  end

  describe 'Bulk Discount Revenue' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)
      @item_4 = create(:item, merchant: @merchant_1)

      @merchant_2 = create(:merchant)
      @item_3 = create(:item, merchant: @merchant_2)

      @invoice_1 = create(:invoice, status: :in_progress)
      @inv_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 17, unit_price: 500, status: :packaged)
      @inv_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 25, unit_price: 1000, status: :packaged)
      @inv_item_3 = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 8, unit_price: 100)
      @inv_item_4 = create(:invoice_item, invoice: @invoice_1, item: @item_4, quantity: 10, unit_price: 100)

      @disc1 = create(:bulk_discount, percentage: 10, threshold: 15, merchant_id: @merchant_1.id)
      @disc2 = create(:bulk_discount, percentage: 20, threshold: 25, merchant_id: @merchant_1.id)
      @disc3 = create(:bulk_discount, percentage: 15, threshold: 30, merchant_id: @merchant_2.id)

      visit admin_invoice_path(@invoice_1.id)
    end

    it 'displays total discounted revenue invoice' do
      expect(page).to have_content("Total Revenue with Bulk Discounts: $294.50")
    end
  end
end