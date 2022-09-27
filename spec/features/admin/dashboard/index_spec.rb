require 'rails_helper'

RSpec.describe 'admin dashboard' do
  before :each do
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

    visit '/admin'
  end

  it "has a header letting you know it's the admin dash" do

    expect(page).to have_content("Admin Dashboard")
  end

  it "has links to the merchant and invoice index pages" do
    expect(page).to have_link("Merchants")
    expect(page).to have_link("Invoices")
  end

  it "has a working merchants index link" do
    click_link "Merchants"
    expect(current_path).to eq("/admin/merchants")
  end

  it "has a working invoices index link" do
    click_link "Invoices"
    expect(current_path).to eq("/admin/invoices")
  end

  it "lists the top 5 customers by transaction" do
    expect(page).to have_content('Top 5 Customers')

    expect(page).to have_content(@customer1.first_name)
    expect(page).to have_content(@customer1.last_name)

    expect(page).to have_content(@customer2.first_name)
    expect(page).to have_content(@customer2.last_name)

    expect(page).to have_content(@customer3.first_name)
    expect(page).to have_content(@customer3.last_name)

    expect(page).to have_content(@customer4.first_name)
    expect(page).to have_content(@customer4.last_name)

    expect(page).to have_content(@customer5.first_name)
    expect(page).to have_content(@customer5.last_name)

    expect(page).to_not have_content(@customer6.first_name)
    expect(page).to_not have_content(@customer6.last_name)
  end

  it 'gives the number of transactions for each customer' do
    expect(page).to have_content(Customer.top_customers[0].transaction_count)
    expect(page).to have_content(Customer.top_customers[1].transaction_count)
    expect(page).to have_content(Customer.top_customers[2].transaction_count)
    expect(page).to have_content(Customer.top_customers[3].transaction_count)
    expect(page).to have_content(Customer.top_customers[4].transaction_count)
  end


  it 'has a section for incomplete invoices' do
    expect(page).to have_content("Incomplete Invoices")
    expect(page).to have_link("#{@invoice2.id}")
    expect(page).to have_link("#{@invoice3.id}")
  end

  it 'has working routes for the links' do
    click_link "#{@invoice2.id}"
  end

  it 'has the creation date for the invoices' do
    expect(page).to have_content("Created: #{@invoice2.created_at.strftime("%A, %B %-d, %Y")}")
  end

  it 'is ordered with the oldest first' do
    expect("#{@invoice3.id}").to appear_before("#{@invoice2.id}")
  end


end
