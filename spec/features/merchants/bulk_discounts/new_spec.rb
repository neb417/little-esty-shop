require 'rails_helper'

RSpec.describe 'Merchant Bulk Dicount New Page: ' do

  before(:each) do
    @merch1 = create(:merchant)
    @item1 = create(:item, merchant: @merch1, unit_price: 5700)
    @item2 = create(:item, merchant: @merch1)

    @merch2 = create(:merchant)
    @item3 = create(:item, merchant: @merch2, unit_price: 500)
    @item4 = create(:item, merchant: @merch2, unit_price: 500)
    @item5 = create(:item, merchant: @merch2, unit_price: 500)
    @item6 = create(:item, merchant: @merch2, unit_price: 500)
    @item7 = create(:item, merchant: @merch2, unit_price: 500)
    @item8 = create(:item, merchant: @merch2, unit_price: 500)
    @item9 = create(:item, merchant: @merch2, unit_price: 500)

    @invoice1 = create(:invoice, status: :completed, created_at: "Sun, 28 Aug 2022")
    @invoice2 = create(:invoice, status: :completed, created_at: "Mon, 29 Aug 2022")
    @invoice3 = create(:invoice, status: :completed, created_at: "Tues, 30 Aug 2022")
    @invoice4 = create(:invoice, status: :completed)
    @invoice5 = create(:invoice, status: :completed)

    @inv_item1 = create(:invoice_item, invoice: @invoice1, item: @item3, quantity: 10, unit_price: 100, status: :packaged)
    @inv_item2 = create(:invoice_item, invoice: @invoice2, item: @item4, quantity: 11, unit_price: 100, status: :packaged)
    @inv_item3 = create(:invoice_item, invoice: @invoice3, item: @item5, quantity: 12, unit_price: 100, status: :packaged)
    @inv_item4 = create(:invoice_item, invoice: @invoice4, item: @item6, quantity: 13, unit_price: 100, status: :packaged)
    @inv_item5 = create(:invoice_item, invoice: @invoice5, item: @item7, quantity: 14, unit_price: 100, status: :packaged)
    @inv_item6 = create(:invoice_item, invoice: @invoice1, item: @item8, quantity: 15, unit_price: 100, status: :packaged)
    @inv_item7 = create(:invoice_item, invoice: @invoice2, item: @item9, quantity: 16, unit_price: 100, status: :packaged)
    @inv_item8 = create(:invoice_item, invoice: @invoice3, item: @item3, quantity: 10, unit_price: 100, status: :packaged)
    @inv_item9 = create(:invoice_item, invoice: @invoice4, item: @item4, quantity: 11, unit_price: 100, status: :packaged)
    @inv_item10 = create(:invoice_item, invoice: @invoice5, item: @item5, quantity: 12, unit_price: 100, status: :packaged)

    @tranaction1 = create(:transaction, invoice_id: @invoice1.id, result: :success)
    @tranaction2 = create(:transaction, invoice_id: @invoice2.id, result: :failed)
    @tranaction3 = create(:transaction, invoice_id: @invoice3.id, result: :success)
    @tranaction4 = create(:transaction, invoice_id: @invoice4.id, result: :success)
    @tranaction5 = create(:transaction, invoice_id: @invoice5.id, result: :success)
    @tranaction6 = create(:transaction, invoice_id: @invoice1.id, result: :success)
    @tranaction7 = create(:transaction, invoice_id: @invoice2.id, result: :failed)
    @tranaction8 = create(:transaction, invoice_id: @invoice3.id, result: :failed)
    @tranaction9 = create(:transaction, invoice_id: @invoice4.id, result: :failed)

    @disc1 = create(:bulk_discount, percentage: 10, threshold: 15, merchant_id: @merch1.id)
    @disc2 = create(:bulk_discount, percentage: 20, threshold: 25, merchant_id: @merch1.id)
    @disc3 = create(:bulk_discount, percentage: 15, threshold: 30, merchant_id: @merch2.id)
  end
  describe 'As a Merchant' do
    describe 'when visiting bulk discount index page' do
      it 'directs to new bulk discount page' do
        visit merchant_bulk_discounts_path(@merch1.id)

        expect(page).to have_link("New Bulk Discount")

        click_link "New Bulk Discount"

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merch1.id))
      end

      it 'I see a form to add a new bulk discount' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        expect(page).to have_content "Enter Bulk Discount Name"
        expect(page).to have_content "Enter Bulk Discount Threshold"
        expect(page).to have_content "Enter Bulk Discount Percentage"
        expect(page).to have_button "Create Bulk Discount"
      end

      it 'fill in form and redirect to bulk discount index' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Name", with: "New Discount"
        fill_in "Enter Bulk Discount Threshold", with: 50
        fill_in "Enter Bulk Discount Percentage", with: 35

        click_button "Create Bulk Discount"

        expect(current_path).to eq(merchant_bulk_discounts_path(@merch1.id))
      end

      it 'new discount is listed on index page' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Name", with: "New Discount"
        fill_in "Enter Bulk Discount Threshold", with: 50
        fill_in "Enter Bulk Discount Percentage", with: 35

        click_button "Create Bulk Discount"

        expect(page).to have_content("Your Bulk Discount has been Created")
        expect(page).to have_link("New Discount")
      end

      it 'sad path for invalid Name filled in' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Threshold", with: 50
        fill_in "Enter Bulk Discount Percentage", with: 35

        click_button "Create Bulk Discount"

        expect(page).to have_content("Please Create Bulk Discount with valid information")
        expect(page).to have_content("Enter Bulk Discount Name")
        expect(page).to have_content("Enter Bulk Discount Threshold")
        expect(page).to have_content("Enter Bulk Discount Percentage")
      end

      it 'sad path for invalid Threshold filled in' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Name", with: "New Discount"
        fill_in "Enter Bulk Discount Threshold", with: "Some Numbers"
        fill_in "Enter Bulk Discount Percentage", with: 35

        click_button "Create Bulk Discount"

        expect(page).to have_content("Please Create Bulk Discount with valid information")
        expect(page).to have_content("Enter Bulk Discount Name")
        expect(page).to have_content("Enter Bulk Discount Threshold")
        expect(page).to have_content("Enter Bulk Discount Percentage")
      end

      it 'sad path for invalid Threshold filled in' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Name", with: "New Discount"
        fill_in "Enter Bulk Discount Threshold", with: 35
        fill_in "Enter Bulk Discount Percentage", with: "Some Numbers"

        click_button "Create Bulk Discount"

        expect(page).to have_content("Please Create Bulk Discount with valid information")
        expect(page).to have_content("Enter Bulk Discount Name")
        expect(page).to have_content("Enter Bulk Discount Threshold")
        expect(page).to have_content("Enter Bulk Discount Percentage")
      end

      it 'sad path for invalid percentage exceeding 100% filled in' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Name", with: "New Discount"
        fill_in "Enter Bulk Discount Threshold", with: 50
        fill_in "Enter Bulk Discount Percentage", with: 101

        click_button "Create Bulk Discount"

        expect(page).to have_content("Please Create Bulk Discount with valid information")
        expect(page).to have_content("Enter Bulk Discount Name")
        expect(page).to have_content("Enter Bulk Discount Threshold")
        expect(page).to have_content("Enter Bulk Discount Percentage")
      end

      it 'sad path for invalid percentage less than 1% filled in' do
        visit new_merchant_bulk_discount_path(@merch1.id)

        fill_in "Enter Bulk Discount Name", with: "New Discount"
        fill_in "Enter Bulk Discount Threshold", with: 50
        fill_in "Enter Bulk Discount Percentage", with: 0

        click_button "Create Bulk Discount"

        expect(page).to have_content("Please Create Bulk Discount with valid information")
        expect(page).to have_content("Enter Bulk Discount Name")
        expect(page).to have_content("Enter Bulk Discount Threshold")
        expect(page).to have_content("Enter Bulk Discount Percentage")
      end
    end
  end
end