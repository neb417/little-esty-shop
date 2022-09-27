require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it {should belong_to(:item)}
    it {should belong_to(:invoice)}
    it {should have_one(:merchant).through (:item)}
    it {should have_many(:bulk_discounts).through (:merchant)}
  end

  describe 'enums' do
    it 'response to status methods' do
      customer = Customer.create!(first_name: "Gunther", last_name: "Guyman")
      invoice = Invoice.create!(customer_id: customer.id, status: 0)
      merchant = Merchant.create!(name: "Phrank")
      item = Item.create!(name: "Cool Pencil", description: "See name", unit_price: 5000, merchant_id: merchant.id)
      invoice_item = InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 2, unit_price: item.unit_price, status: 0)

      expect(invoice_item.pending?).to eq(true)

      invoice_item.shipped!
      expect(invoice_item.pending?).to eq(false)
    end
  end

  describe 'instance methods' do
    describe '.item_name' do
      it 'returns the name of the associated item' do
        invoice_item = create(:invoice_item)

        expect(invoice_item.item_name).to eq(invoice_item.item.name)
      end

      it 'returns the date thats its invoice was created' do
        invoice_item = create(:invoice_item)

        expect(invoice_item.invoice_date).to eq(invoice_item.invoice.created_at)
      end
    end

    describe '.applied_discount' do
      it '.applied_discount (ex. 1 & 2)' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
  
        merchant_2 = create(:merchant)
        item_3 = create(:item, merchant: merchant_2)
  
        invoice_1 = create(:invoice, status: :in_progress)
        inv_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 17, unit_price: 500, status: :packaged)
        inv_item_2 = create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 25, unit_price: 1000, status: :packaged)
        inv_item_3 = create(:invoice_item, invoice: invoice_1, item: item_3, quantity: 14, unit_price: 100)

        disc1 = create(:bulk_discount, percentage: 10, threshold: 15, merchant_id: merchant_1.id)
        disc2 = create(:bulk_discount, percentage: 20, threshold: 25, merchant_id: merchant_1.id)
        disc3 = create(:bulk_discount, percentage: 15, threshold: 30, merchant_id: merchant_2.id)

        expect(inv_item_1.applied_discount).to eq(disc1)
        expect(inv_item_2.applied_discount).to eq(disc2)
        expect(inv_item_3.applied_discount).to eq(nil)
      end

      it '.applied_discount (ex. 3)' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
  
        invoice_1 = create(:invoice, status: :in_progress)
        inv_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 12, unit_price: 500, status: :packaged)
        inv_item_2 = create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 15, unit_price: 1000, status: :packaged)

        disc1 = create(:bulk_discount, percentage: 20, threshold: 10, merchant_id: merchant_1.id)
        disc2 = create(:bulk_discount, percentage: 30, threshold: 15, merchant_id: merchant_1.id)

        expect(inv_item_1.applied_discount).to eq(disc1)
        expect(inv_item_2.applied_discount).to eq(disc2)
      end

      it '.applied_discount (ex. 4)' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
  
        invoice_1 = create(:invoice, status: :in_progress)
        inv_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 12, unit_price: 500, status: :packaged)
        inv_item_2 = create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 15, unit_price: 1000, status: :packaged)

        disc1 = create(:bulk_discount, percentage: 20, threshold: 10, merchant_id: merchant_1.id)
        disc2 = create(:bulk_discount, percentage: 15, threshold: 15, merchant_id: merchant_1.id)

        expect(inv_item_1.applied_discount).to eq(disc1)
        expect(inv_item_2.applied_discount).to eq(disc1)
      end

      it '.applied_discount (ex. 5)' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
  
        merchant_2 = create(:merchant)
        item_3 = create(:item, merchant: merchant_2)
  
        invoice_1 = create(:invoice, status: :in_progress)
        inv_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 12, unit_price: 500, status: :packaged)
        inv_item_2 = create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 15, unit_price: 1000, status: :packaged)
        inv_item_3 = create(:invoice_item, invoice: invoice_1, item: item_3, quantity: 15, unit_price: 100)

        disc1 = create(:bulk_discount, percentage: 20, threshold: 10, merchant_id: merchant_1.id)
        disc2 = create(:bulk_discount, percentage: 30, threshold: 15, merchant_id: merchant_1.id)

        expect(inv_item_1.applied_discount).to eq(disc1)
        expect(inv_item_2.applied_discount).to eq(disc2)
        expect(inv_item_3.applied_discount).to eq(nil)
      end
    end
  end

  describe 'class methods' do
    before :each do
      @invoice = create(:invoice)
      @invoice_item_1 = create(:invoice_item, quantity: 15, unit_price: 15000, invoice: @invoice)
      @invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 6000)
      @invoice_item_3 = create(:invoice_item, quantity: 7, unit_price: 1375, invoice: @invoice)
      @invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1825)
    end

    describe '#total_revenue' do
      it 'returns the total revenue generated by all or a subset of invoice_items' do
        expect(InvoiceItem.total_revenue).to eq(289925)
        expect(@invoice.invoice_items.total_revenue).to eq(234625)
        expect(price_convert(@invoice.invoice_items.total_revenue)).to eq("$2,346.25")
      end
    end
  end
end
