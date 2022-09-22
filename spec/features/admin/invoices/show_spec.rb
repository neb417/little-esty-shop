require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page' do
  describe 'Admin Invoices Index Page' do
    before :each do
      @m1 = Merchant.create!(name: 'Merchant 1')
  
      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')
  
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
      @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: '2012-03-25 09:30:09')
  
      @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m1.id)
  
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 200, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 100, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 1200, status: 2)
  
      visit admin_invoice_path(@i1)
    end
  
    it 'should display the id, status and created_at' do
      expect(page).to have_content("Invoice ##{@i1.id}")
      expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")
  
      expect(page).to_not have_content("Invoice ##{@i2.id}")
    end
  
    it 'should display all the items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
  
      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)
  
      expect(page).to have_content("#{price_convert(@ii_1.unit_price)}")
      expect(page).to have_content("#{price_convert(@ii_2.unit_price)}")
  
      expect(page).to have_content(@ii_1.status.titleize)
      expect(page).to have_content(@ii_2.status.titleize)

    end
  
    it 'should display the total revenue the invoice will generate' do
      expect(page).to have_content("Total Revenue: #{price_convert(@i1.total_revenue)}")
  
      expect(page).to_not have_content(@i2.total_revenue)
    end
  
    it 'should have status as a select field that updates the invoices status' do
      within("#status-update-#{@i1.id}") do
        select('Cancelled', :from => 'invoice[status]')
        expect(page).to have_button('Update Invoice')
        click_button 'Update Invoice'
  
        expect(current_path).to eq(admin_invoice_path(@i1))
        expect(@i1.status).to eq('cancelled')
      end
    end
  end
end