require 'rails_helper'

RSpec.describe 'Admin Invoices' do
  it 'shows list of invoinces ids and have links to their shows pages ' do
    customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

    invoice_1 = Invoice.create!(status: 1, customer_id: customer_1.id)
    invoice_2 = Invoice.create!(status: 2, customer_id: customer_1.id)
    invoice_3 = Invoice.create!(status: 0, customer_id: customer_1.id)

    visit 'admin/invoices'

    within "#inv-#{invoice_1.id}" do
      expect(page).to have_content("Invoice # #{invoice_1.id}")
      expect(page).to_not have_content("Invoice # #{invoice_2.id}")
      expect(page).to_not have_content("Invoice # #{invoice_3.id}")
    end

    within "#inv-#{invoice_2.id}" do
      expect(page).to have_content("Invoice # #{invoice_2.id}")
      expect(page).to_not have_content("Invoice # #{invoice_3.id}")
      expect(page).to_not have_content("Invoice # #{invoice_1.id}")
    end

    within "#inv-#{invoice_3.id}" do
      expect(page).to have_content("Invoice # #{invoice_3.id}")
      expect(page).to_not have_content("Invoice # #{invoice_2.id}")
      expect(page).to_not have_content("Invoice # #{invoice_1.id}")

      click_link "#{invoice_3.id}"

      expect(current_path).to eq(admin_invoice_path(invoice_3))
    end
  end
end
