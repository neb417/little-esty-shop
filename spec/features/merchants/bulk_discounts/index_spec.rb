require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Index Page: ' do

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
      it 'all of my bulk discounts are displayed' do
        visit merchant_bulk_discounts_path(@merch1.id)

        expect(page).to have_content(@disc1.name)
        expect(page).to have_content(@disc2.name)
        expect(page).to_not have_content(@disc3.name)
      end

      it 'percentage discount and quantity thresholds' do
        visit merchant_bulk_discounts_path(@merch1.id)

        within("#bulk_discount_list") do
          @merch1.bulk_discounts.each do |discount|
            within("#bulk_discount_#{discount.id}") do
              expect(page).to have_content(discount.name)
              expect(page).to have_content(discount.percentage)
              expect(page).to have_content(discount.threshold)
            end
          end
        end
      end

      it 'each bulk discount listed includes a link to its show page' do
        visit merchant_bulk_discounts_path(@merch1.id)

        expect(page).to have_link(@disc1.name)
        expect(page).to have_link(@disc2.name)
        expect(page).to_not have_link(@disc3.name)
      end

      it 'there is a link to create a new bulk discount' do
        visit merchant_bulk_discounts_path(@merch1.id)

        expect(page).to have_link("New Bulk Discount")

        click_link "New Bulk Discount"

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merch1.id))
      end

      describe 'destroy bulk discount' do
        it 'next to each bulk discount I see a link to delete it' do
          visit merchant_bulk_discounts_path(@merch1.id)

          within("#bulk_discount_list") do
            expect(page).to have_link("Delete #{@disc1.name}")
            expect(page).to have_link("Delete #{@disc2.name}")
            expect(page).to_not have_link("Delete #{@disc3.name}")
          end
        end

        it 'I click this link, redirected back to the bulk discounts index page' do
          visit merchant_bulk_discounts_path(@merch1.id)

          click_link "Delete #{@disc1.name}"

          expect(current_path).to eq(merchant_bulk_discounts_path(@merch1.id))
        end

        it 'no longer see the discount listed' do
          visit merchant_bulk_discounts_path(@merch1.id)

          click_link "Delete #{@disc1.name}"

          within("#bulk_discount_list") do
            expect(page).to_not have_content(@disc1.name)
            expect(page).to have_content(@disc2.name)
          end
        end
      end

      describe 'section with a header of "Upcoming Holidays"' do
        it 'has a section for the upcoming holidays' do
          visit merchant_bulk_discounts_path(@merch1.id)

          within("#upcoming_holidays") do
            expect(page).to have_content("Upcoming Holidays")
          end
        end
      end
    end
  end
end