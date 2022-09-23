require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it {should belong_to(:merchant)}
  end

  describe 'instance variables' do

    describe '.invoices' do
      it 'returns a list of invoices which contain an item from the merchant' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)

        merchant_2 = create(:merchant)
        item_3 = create(:item, merchant: merchant_2)
        item_4 = create(:item, merchant: merchant_2)

        invoice_1 = create(:invoice)
        invoice_2 = create(:invoice)
        invoice_3 = create(:invoice)
        invoice_4 = create(:invoice)

        invoice_1.items << [item_1, item_2, item_3]
        invoice_2.items << [item_3, item_4]
        invoice_3.items << [item_1, item_4]
        invoice_4.items << item_2
        expect(merchant_1.distinct_invoices).to match_array([invoice_1, invoice_3, invoice_4])
        expect(merchant_2.distinct_invoices).to match_array([invoice_1, invoice_2, invoice_3])
      end
    end
  end
end