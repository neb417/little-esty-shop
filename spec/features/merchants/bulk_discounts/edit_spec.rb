require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit Page: ' do

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
    describe 'on my bulk discount edit page' do
      it 'I see that the discounts current attributes are pre-poluated in the form' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        expect(page).to have_field('Update Bulk Discount Name', with: @disc3.name)
        expect(page).to have_field('Update Bulk Discount Threshold', with: @disc3.threshold)
        expect(page).to have_field('Update Bulk Discount Percentage', with: @disc3.percentage)
        expect(page).to have_button('Update Bulk Discount')

        expect(page).to_not have_field('Update Bulk Discount Name', with: @disc1.name)
        expect(page).to_not have_field('Update Bulk Discount Name', with: @disc2.name)
      end

      it 'redirected to bulk discount show page when any/all attributes are updated' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Name', with: 'New discount'

        click_button 'Update Bulk Discount'

        expect(current_path).to eq(merchant_bulk_discount_path(@merch2.id, @disc3.id))
      end

      it 'show page reflects name change made' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Name', with: 'New Name'

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Successful Update of New Name")
        expect(page).to have_content("New Name")
      end

      it 'show page reflects threshold change made' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Threshold', with: 57

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Successful Update of #{@disc3.name}")
        within("#merchant_bulk_discount") do
          expect(page).to have_content(57)
        end
      end

      it 'show page reflects percentage change made' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Percentage', with: 25

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Successful Update of #{@disc3.name}")
        within("#merchant_bulk_discount") do
          expect(page).to have_content(25)
        end
      end

      it 'sad path reflects invalid Name entry' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Name', with: ''

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Please enter valid information to Update Bulk Discount")
      end

      it 'sad path reflects invalid Threshold entry' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Threshold', with: 'Number'

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Please enter valid information to Update Bulk Discount")
      end

      it 'sad path reflects invalid Percentage entry' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Percentage', with: 'Number'

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Please enter valid information to Update Bulk Discount")
      end

      it 'sad path reflects invalid Percentage entry exceeding 100' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Percentage', with: 101

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Please enter valid information to Update Bulk Discount")
      end

      it 'sad path reflects invalid Percentage entry less than 1' do
        visit edit_merchant_bulk_discount_path(@merch2.id, @disc3.id)

        fill_in 'Update Bulk Discount Percentage', with: 0

        click_button 'Update Bulk Discount'

        expect(page).to have_content("Please enter valid information to Update Bulk Discount")
      end
    end
  end
end