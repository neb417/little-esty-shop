require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do

    it {should belong_to(:customer)}
    it {should have_many(:transactions)}
    it {should have_many(:invoice_items)}
    it {should have_many(:transactions)}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
    it {should have_many(:bulk_discounts).through(:merchants)}

  end

  describe 'status enum' do
    it 'should respond to enum methods' do
      customer = Customer.create!(first_name: "Gunther", last_name: "Guyman")
      invoice = Invoice.create!(customer_id: customer.id, status: 0)

      expect(invoice.in_progress?).to be(true)
      expect(invoice.status).to eq("in_progress")

      invoice.completed!
      expect(invoice.in_progress?).to be(false)
    end
  end

  describe 'class methods' do
    before(:each) do
      @merchant = create(:merchant)

      @customer1 = Customer.create!(first_name: 'Gunther', last_name: 'Guyman')
      @customer2 = Customer.create!(first_name: 'Miles', last_name: 'Prower')
      @customer3 = Customer.create!(first_name: 'Mario', last_name: 'Mario')
      @customer4 = Customer.create!(first_name: 'Marneus', last_name: 'Calgar')
      @customer5 = Customer.create!(first_name: 'Sol', last_name: 'Badguy')
      @customer6 = Customer.create!(first_name: 'Wyatt', last_name: 'Kribs')

      @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2)
      @invoice2 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: 10.seconds.ago)
      @invoice3 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: 100.seconds.ago)
      @invoice4 = Invoice.create!(customer_id: @customer1.id, status: 2)
      @invoice5 = Invoice.create!(customer_id: @customer1.id, status: 2)
      @invoice6 = Invoice.create!(customer_id: @customer2.id, status: 2)
      @invoice7 = Invoice.create!(customer_id: @customer2.id, status: 2)
      @invoice8 = Invoice.create!(customer_id: @customer2.id, status: 2)
      @invoice9 = Invoice.create!(customer_id: @customer2.id, status: 2)
      @invoice10 = Invoice.create!(customer_id: @customer3.id, status: 2)
      @invoice11 = Invoice.create!(customer_id: @customer3.id, status: 2)
      @invoice12 = Invoice.create!(customer_id: @customer3.id, status: 2)
      @invoice13 = Invoice.create!(customer_id: @customer4.id, status: 2)
      @invoice14 = Invoice.create!(customer_id: @customer4.id, status: 2)
      @invoice15 = Invoice.create!(customer_id: @customer5.id, status: 2)

      @item1 = create(:item, merchant: @merchant)
      @item2 = create(:item, merchant: @merchant)
      @item3 = create(:item, merchant: @merchant)

      @inv_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 5, status: 2)
      @inv_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 5, unit_price: 5, status: 0)
      @inv_item3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice3.id, quantity: 5, unit_price: 5, status: 0)


      @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: 12345, result: 1)
      @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: 12345, result: 1)
      @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: 12345, result: 1)
      @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: 12345, result: 1)
      @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: 12345, result: 1)
      @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: 12345, result: 1)
      @transaction7 = Transaction.create!(invoice_id: @invoice7.id, credit_card_number: 12345, result: 1)
      @transaction8 = Transaction.create!(invoice_id: @invoice8.id, credit_card_number: 12345, result: 1)
      @transaction9 = Transaction.create!(invoice_id: @invoice9.id, credit_card_number: 12345, result: 1)
      @transaction10 = Transaction.create!(invoice_id: @invoice10.id, credit_card_number: 12345, result: 1)
      @transaction11 = Transaction.create!(invoice_id: @invoice11.id, credit_card_number: 12345, result: 1)
      @transaction12 = Transaction.create!(invoice_id: @invoice12.id, credit_card_number: 12345, result: 1)
      @transaction13 = Transaction.create!(invoice_id: @invoice13.id, credit_card_number: 12345, result: 1)
      @transaction14 = Transaction.create!(invoice_id: @invoice14.id, credit_card_number: 12345, result: 1)
      @transaction15 = Transaction.create!(invoice_id: @invoice15.id, credit_card_number: 12345, result: 1)
    end

    describe 'self.incomplete_invoices' do
      it 'returns invoices with unshipped items ordered by the oldest created' do
        expect(Invoice.all.incomplete_invoices).to eq([@invoice3, @invoice2])
      end
    end
  end

  describe 'instance methods' do

    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, merchant: @merchant_1, unit_price: 1500, name: 'Pencil')
      @item_2 = create(:item, merchant: @merchant_1)

      @merchant_2 = create(:merchant)
      @item_3 = create(:item, merchant: @merchant_2, name: 'Art', unit_price: 10000)
      @item_4 = create(:item, merchant: @merchant_2)
      @item_5 = create(:item, merchant: @merchant_2, name: 'Coaster', unit_price: 500)

      @invoice_1 = create(:invoice)

      @inv_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 375, unit_price: 1450)
      @inv_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 5, unit_price: 9950)
      @inv_item_3 = create(:invoice_item, invoice: @invoice_1, item: @item_5, quantity: 10, unit_price: 450)
    end

    describe '.merchant_items' do
      it 'returns a list of items on an invoice belonging to a merchant. includes item name and information from invoice_item' do
        merchant_1_items = @invoice_1.merchant_items(@merchant_1)

        expect(merchant_1_items.length).to eq(1)
        expect(merchant_1_items.pluck(:name)).to eq(["Pencil"])
        expect(merchant_1_items.pluck(:quantity)).to eq([375])
        expect(merchant_1_items.pluck(:unit_price)).to eq([1450])

        merchant_2_items = @invoice_1.merchant_items(@merchant_2)

        expect(merchant_2_items.length).to eq(2)
        expect(merchant_2_items.pluck(:name)).to eq(["Art", "Coaster"])
        expect(merchant_2_items.pluck(:quantity)).to eq([5, 10])
        expect(merchant_2_items.pluck(:unit_price)).to eq([9950, 450])
      end
    end
  end

  describe '.total_revenue'
    it "returs the total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

  describe '#discount_revenue' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)

      @merchant_2 = create(:merchant)
      @item_3 = create(:item, merchant: @merchant_2)

      @invoice_1 = create(:invoice, status: :in_progress)
      @inv_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 17, unit_price: 500, status: :packaged)
      @inv_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 25, unit_price: 1000, status: :packaged)
      @inv_item_3 = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 8, unit_price: 100)

      @disc1 = create(:bulk_discount, percentage: 10, threshold: 15, merchant_id: @merchant_1.id)
      @disc2 = create(:bulk_discount, percentage: 20, threshold: 25, merchant_id: @merchant_1.id)
      @disc3 = create(:bulk_discount, percentage: 15, threshold: 30, merchant_id: @merchant_2.id)
    end

    it '#discount_revenue' do
      expect(@invoice_1.discount_revenue(@merchant_1)).to eq(27650.0)
    end

    it '#discount' do
      expect(@invoice_1.discount(@merchant_1)).to eq(5850.0)
    end

    it 'does not apply a discount if not qualified' do
      expect(@invoice_1.discount_revenue(@merchant_2)).to eq(800.0)
      expect(@invoice_1.discount(@merchant_2)).to eq(0.0)
      expect(@invoice_1.discount_revenue(@merchant_2)).to eq(@inv_item_3.quantity * @inv_item_3.unit_price)
    end

    # it 'applies correct discount' do
    #   expect(@invoice_1.discount(@merchant_1)).to eq(5850.0)
    # end
  end
end
