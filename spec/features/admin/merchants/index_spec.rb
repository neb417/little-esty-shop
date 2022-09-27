require 'rails_helper'

RSpec.describe 'Admin Merchants Index' do
  it 'shows the name of each merchant' do

    merchant1 = Merchant.create!(name: "Bobbis Bees")
    merchant2 = Merchant.create!(name: "Darnelles Daysies")
    merchant3 = Merchant.create!(name: "Alans Art")

    visit '/admin/merchants'

    within "#merchant-#{merchant1.id}" do
      expect(page).to have_content(merchant1.name)
      expect(page).to_not have_content(merchant2.name)
    end

    within "#merchant-#{merchant2.id}" do
      expect(page).to have_content(merchant2.name)
      expect(page).to_not have_content(merchant3.name)
    end

    within "#merchant-#{merchant3.id}" do
      expect(page).to have_content(merchant3.name)
      expect(page).to_not have_content(merchant1.name)
    end
  end

  it 'takes you to merchant show page when you click on the name of a merchant' do
    merchant1 = Merchant.create!(name: "Bobbis Bees")
    merchant2 = Merchant.create!(name: "Darnelles Daysies")
    merchant3 = Merchant.create!(name: "Alans Art")

    visit '/admin/merchants'

    click_link "Bobbis Bees"

    expect(current_path).to eq(admin_merchant_path(merchant1.id))
  end

  it 'has a button to disable or enable next to each merchant, when I click it I am stay on the index page but the merchant status has changed' do
    merchant1 = Merchant.create!(name: "Bobbis Bees")
    merchant2 = Merchant.create!(name: "Darnelles Daysies")
    merchant3 = Merchant.create!(name: "Alans Art")

    visit '/admin/merchants'

    within "#merchant-#{merchant1.id}" do
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enabled")
    end

    within "#merchant-#{merchant2.id}" do
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enabled")
    end

    within "#merchant-#{merchant3.id}" do
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enabled")

      click_button 'Disable'

      expect(page).to have_button('Enable')
      expect(page).to_not have_button('Disable')
    end
  end

  it 'has a link to create a new merchant' do
    merchant1 = Merchant.create!(name: "Bobbis Bees")
    merchant2 = Merchant.create!(name: "Darnelles Daysies")
    merchant3 = Merchant.create!(name: "Alans Art")

    visit '/admin/merchants'

    expect(page).to have_content("Create a new merchant")

    click_link 'Create a new merchant'

    expect(current_path).to eq('/admin/merchants/new')
  end

  it 'shows the names of the top 5 merchants by total revenue generated' do
    merchant_1 = Merchant.create!(name: 'Spongebob The Merchant')
    merchant_3 = Merchant.create!(name: 'Patrick The Starfish')
    merchant_2 = Merchant.create!(name: 'Sandy The Squirrel Merchant')
    merchant_4 = Merchant.create!(name: 'Mr. Krabs The Boss')
    merchant_5 = Merchant.create!(name: 'Barnacle Boy The Sidekick')
    merchant_6 = Merchant.create!(name: 'Mermaid Man The Hero')

    customer_1 = Customer.create!(first_name: 'Somany', last_name: 'Damntests')
    customer_2 = Customer.create!(first_name: 'Keeling', last_name: 'Mesoftly')
    customer_3 = Customer.create!(first_name: 'Withis', last_name: 'Words')

    item_1 = Item.create!(name: 'Spatula', description: 'It is for cooking', unit_price: 3, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: 'Spoon', description: 'It is for eating ice cream', unit_price: 1, merchant_id: merchant_1.id)
    item_3 = Item.create!(name: 'Knife', description: 'It is for slicing bread', unit_price: 5, merchant_id: merchant_1.id)
    item_4 = Item.create!(name: 'Computer', description: 'It is for playing games', unit_price: 50, merchant_id: merchant_1.id)
    item_5 = Item.create!(name: 'Table', description: 'It is for eating at', unit_price: 70, merchant_id: merchant_1.id)
    item_5 = Item.create!(name: 'Bag of Money', description: 'It is for whatever you want', unit_price: 999, merchant_id: merchant_1.id)
    item_6 = Item.create!(name: 'Decorative Wood 7', description: 'It is a piece of wood shaped like a 7', unit_price: 400, merchant_id: merchant_1.id)
    item_7 = Item.create!(name: 'Bag of Jacks', description: 'It is for playing Jacks', unit_price: 3, merchant_id: merchant_2.id)
    item_8 = Item.create!(name: 'Spatula2', description: 'It is for cooking', unit_price: 3, merchant_id: merchant_2.id)
    item_9 = Item.create!(name: 'Spoon2', description: 'It is for eating ice cream', unit_price: 1, merchant_id: merchant_3.id)
    item_10 = Item.create!(name: 'Knife2', description: 'It is for slicing bread', unit_price: 5, merchant_id: merchant_4.id)
    item_11 = Item.create!(name: 'Computer2', description: 'It is for playing games', unit_price: 50, merchant_id: merchant_5.id)
    item_12 = Item.create!(name: 'Table2', description: 'It is for eating at', unit_price: 70, merchant_id: merchant_6.id)
    item_13 = Item.create!(name: 'Bag of Money2', description: 'It is for whatever you want', unit_price: 999, merchant_id: merchant_6.id)
    item_14 = Item.create!(name: 'Decorative Wood 72', description: 'It is a piece of wood shaped like a 7', unit_price: 400, merchant_id: merchant_6.id)

    invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_3 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_4 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_5 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_6 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_7 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_8 = Invoice.create!(customer_id: customer_1.id, status: 1)

    transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: '983475', result: 'success')
    transaction_2 = Transaction.create!(invoice_id: invoice_2.id, credit_card_number: '345', result: 'success')
    transaction_3 = Transaction.create!(invoice_id: invoice_3.id, credit_card_number: '34657865', result: 'success')
    transaction_4 = Transaction.create!(invoice_id: invoice_4.id, credit_card_number: '3456546', result: 'success')
    transaction_5 = Transaction.create!(invoice_id: invoice_5.id, credit_card_number: '234234', result: 'success')
    transaction_6 = Transaction.create!(invoice_id: invoice_6.id, credit_card_number: '6578', result: 'success')
    transaction_7 = Transaction.create!(invoice_id: invoice_7.id, credit_card_number: '9789', result: 'success')
    transaction_8 = Transaction.create!(invoice_id: invoice_8.id, credit_card_number: '3456', result: 'failed')

    invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 2, status: 2)
    invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 3, status: 2)
    invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 1, status: 2)
    invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_2.id, quantity: 4, unit_price: 2, status: 2)
    invoice_item_5 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_3.id, quantity: 3, unit_price: 3, status: 2)
    invoice_item_7 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_3.id, quantity: 4, unit_price: 1, status: 2)
    invoice_item_8 = InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_4.id, quantity: 4, unit_price: 1, status: 2)
    invoice_item_9 = InvoiceItem.create!(item_id: item_8.id, invoice_id: invoice_4.id, quantity: 4, unit_price: 1, status: 2)
    invoice_item_10 = InvoiceItem.create!(item_id: item_9.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 4, status: 2)
    invoice_item_11 = InvoiceItem.create!(item_id: item_10.id, invoice_id: invoice_6.id, quantity: 4, unit_price: 1, status: 2)
    invoice_item_12 = InvoiceItem.create!(item_id: item_11.id, invoice_id: invoice_7.id, quantity: 2, unit_price: 3, status: 2)
    invoice_item_13 = InvoiceItem.create!(item_id: item_12.id, invoice_id: invoice_8.id, quantity: 4, unit_price: 1, status: 2)
    invoice_item_13 = InvoiceItem.create!(item_id: item_13.id, invoice_id: invoice_8.id, quantity: 4, unit_price: 1, status: 2)
    invoice_item_13 = InvoiceItem.create!(item_id: item_14.id, invoice_id: invoice_8.id, quantity: 4, unit_price: 1, status: 2)

    visit '/admin/merchants'

    within "#Top-Five-Merchants-by-Revenue" do
    expect(merchant_1.name).to appear_before(merchant_2.name)
    expect(merchant_2.name).to appear_before(merchant_3.name)
    expect(merchant_3.name).to appear_before(merchant_5.name)
    expect(merchant_5.name).to appear_before(merchant_4.name)
    expect(page).to_not have_content(merchant_6.name)
    expect(page).to have_content("#{merchant_1.name} - $0.84")

    click_link "#{merchant_3.name}"

    expect(current_path).to eq("/admin/merchants/#{merchant_3.id}")
    expect(current_path).to_not eq("/admin/merchants/#{merchant_1.id}")
    end
  end

  it 'has a top selling date for each merchant' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")
      merchant_2 = Merchant.create!(name: "Spongebob The Merchant")

      item_1 = Item.create!(name: 'Spatula', description: 'It is for cooking', unit_price: 3, merchant_id: merchant_1.id)
      item_2 = Item.create!(name: 'Spoon', description: 'It is for eating ice cream', unit_price: 1, merchant_id: merchant_1.id)
      item_3 = Item.create!(name: 'Knife', description: 'It is for slicing bread', unit_price: 5, merchant_id: merchant_1.id)
      item_4 = Item.create!(name: 'Computer', description: 'It is for playing games', unit_price: 50, merchant_id: merchant_1.id)
      item_5 = Item.create!(name: 'Table', description: 'It is for eating at', unit_price: 70, merchant_id: merchant_1.id)
      item_6 = Item.create!(name: 'Bag of Money', description: 'It is for whatever you want', unit_price: 999, merchant_id: merchant_1.id)

      item_7 = Item.create!(name: 'Seaweed', description: 'It is big ball of seaweed', unit_price: 450, merchant_id: merchant_2.id)
      item_8 = Item.create!(name: 'Boxing Gloves', description: 'It is for kara-tay', unit_price: 2000, merchant_id: merchant_2.id)
      item_9 = Item.create!(name: 'Jelly', description: 'It is yummy', unit_price: 300, merchant_id: merchant_2.id)

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Trill", last_name: "Pickles")

      invoice_1 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_2 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_3 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_10 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")

      invoice_4 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")
      invoice_5 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")
      invoice_11 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")

      invoice_6 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_12 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_13 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")

      invoice_7 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_14 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")
      invoice_15 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")

      invoice_8 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_16 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_17 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")

      invoice_9 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Sat, 30 Jul 2022 16:04:49 UTC +00:00")
      invoice_18 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")
      invoice_19 = Invoice.create!(status: 2, customer_id: customer_1.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")

      invoice_20 = Invoice.create!(status: 2, customer_id: customer_2.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")
      invoice_21 = Invoice.create!(status: 2, customer_id: customer_2.id, created_at: "Fri, 29 Jul 2022 16:04:49 UTC +00:00")
      invoice_22 = Invoice.create!(status: 2, customer_id: customer_2.id, created_at: "Sun, 31 Jul 2022 16:04:49 UTC +00:00")
      invoice_23 = Invoice.create!(status: 2, customer_id: customer_2.id, created_at: "Sun, 31 Jul 2022 16:04:49 UTC +00:00")
      invoice_24 = Invoice.create!(status: 2, customer_id: customer_2.id, created_at: "Sun, 31 Jul 2022 16:04:49 UTC +00:00")
      invoice_25 = Invoice.create!(status: 2, customer_id: customer_2.id, created_at: "Sun, 31 Jul 2022 16:04:49 UTC +00:00")


      transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 234, result: 0)
      transaction_2 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 3456, result: 0)
      transaction_3 = Transaction.create!(invoice_id: invoice_2.id, credit_card_number: 876, result: 0)
      transaction_4 = Transaction.create!(invoice_id: invoice_3.id, credit_card_number: 5678, result: 0)
      transaction_5 = Transaction.create!(invoice_id: invoice_4.id, credit_card_number: 2345, result: 0)
      transaction_6 = Transaction.create!(invoice_id: invoice_5.id, credit_card_number: 567, result: 0)
      transaction_7 = Transaction.create!(invoice_id: invoice_6.id, credit_card_number: 234444, result: 0)
      transaction_8 = Transaction.create!(invoice_id: invoice_7.id, credit_card_number: 23675744, result: 0)
      transaction_9 = Transaction.create!(invoice_id: invoice_8.id, credit_card_number: 67, result: 0)
      transaction_10 = Transaction.create!(invoice_id: invoice_9.id, credit_card_number: 233444, result: 0)
      transaction_11 = Transaction.create!(invoice_id: invoice_10.id, credit_card_number: 5324, result: 0)
      transaction_12 = Transaction.create!(invoice_id: invoice_11.id, credit_card_number: 242244, result: 0)
      transaction_13 = Transaction.create!(invoice_id: invoice_12.id, credit_card_number: 445, result: 0)
      transaction_14 = Transaction.create!(invoice_id: invoice_13.id, credit_card_number: 234234, result: 0)
      transaction_15 = Transaction.create!(invoice_id: invoice_14.id, credit_card_number: 657, result: 0)
      transaction_16 = Transaction.create!(invoice_id: invoice_15.id, credit_card_number: 6787890, result: 0)
      transaction_17 = Transaction.create!(invoice_id: invoice_16.id, credit_card_number: 345435, result: 0)
      transaction_18 = Transaction.create!(invoice_id: invoice_17.id, credit_card_number: 2342356, result: 0)
      transaction_19 = Transaction.create!(invoice_id: invoice_18.id, credit_card_number: 54364567, result: 0)
      transaction_20 = Transaction.create!(invoice_id: invoice_19.id, credit_card_number: 435345, result: 1)

      transaction_21 = Transaction.create!(invoice_id: invoice_20.id, credit_card_number: 4967577, result: 0)
      transaction_22 = Transaction.create!(invoice_id: invoice_21.id, credit_card_number: 4967577, result: 0)
      transaction_23 = Transaction.create!(invoice_id: invoice_22.id, credit_card_number: 4967577, result: 0)
      transaction_24 = Transaction.create!(invoice_id: invoice_23.id, credit_card_number: 4967577, result: 0)
      transaction_25 = Transaction.create!(invoice_id: invoice_24.id, credit_card_number: 4967577, result: 0)
      transaction_26 = Transaction.create!(invoice_id: invoice_25.id, credit_card_number: 4967577, result: 0)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 800, status: 2, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_1.id, invoice_id: invoice_2.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_1.id, invoice_id: invoice_3.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_1.id, invoice_id: invoice_10.id)

      invoice_item_5 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_2.id, invoice_id: invoice_4.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_2.id, invoice_id: invoice_5.id)
      invoice_item_7 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_2.id, invoice_id: invoice_11.id)

      invoice_item_8 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_3.id, invoice_id: invoice_6.id)
      invoice_item_8 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_3.id, invoice_id: invoice_12.id)
      invoice_item_8 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_3.id, invoice_id: invoice_13.id)

      invoice_item_9 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_4.id, invoice_id: invoice_7.id)
      invoice_item_9 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_4.id, invoice_id: invoice_14.id)
      invoice_item_9 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_4.id, invoice_id: invoice_15.id)

      invoice_item_10 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_5.id, invoice_id: invoice_8.id)
      invoice_item_10 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_5.id, invoice_id: invoice_16.id)
      invoice_item_10 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_5.id, invoice_id: invoice_17.id)

      invoice_item_11 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_6.id, invoice_id: invoice_9.id)
      invoice_item_11 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_6.id, invoice_id: invoice_18.id)
      invoice_item_11 = InvoiceItem.create!(quantity: 5, unit_price: 900, status: 2, item_id: item_6.id, invoice_id: invoice_19.id)

      invoice_item_12 = InvoiceItem.create!(quantity: 3, unit_price: 450, status: 2, item_id: item_7.id, invoice_id: invoice_20.id)
      invoice_item_12 = InvoiceItem.create!(quantity: 3, unit_price: 450, status: 2, item_id: item_7.id, invoice_id: invoice_21.id)

      invoice_item_13 = InvoiceItem.create!(quantity: 2, unit_price: 2000, status: 2, item_id: item_8.id, invoice_id: invoice_22.id)
      invoice_item_13 = InvoiceItem.create!(quantity: 2, unit_price: 2000, status: 2, item_id: item_8.id, invoice_id: invoice_23.id)

      invoice_item_14 = InvoiceItem.create!(quantity: 5, unit_price: 300, status: 2, item_id: item_9.id, invoice_id: invoice_24.id)
      invoice_item_14 = InvoiceItem.create!(quantity: 5, unit_price: 300, status: 2, item_id: item_9.id, invoice_id: invoice_25.id)

      visit "/admin/merchants"

      within "#TF-#{merchant_1.id}" do
        expect(page).to have_content("Top Sale Date: 7/30/22")
      end
    end
end
