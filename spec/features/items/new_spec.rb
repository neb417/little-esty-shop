require 'rails_helper'

RSpec.describe 'Merchant New Item page' do
  before :each do
    @merch1 = create(:merchant)
    @item1 = create(:item, merchant: @merch1, unit_price: 5700)
    @item2 = create(:item, merchant: @merch1)

    @merch2 = create(:merchant)
    @item3 = create(:item, merchant: @merch2)
    @item4 = create(:item, merchant: @merch2)
    @item5 = create(:item, merchant: @merch2)
  end
  
  describe 'As a merchant visiting the index page' do
    describe 'there is a link to create a new item and link is clicked' do
      it 'directs merchant to create new item page' do
        visit merchant_items_path(@merch1.id)

        click_link "New Item"

        expect(current_path).to eq(new_merchant_item_path(@merch1.id))
        expect(page).to have_content('Create a New Item')
      end

      it 'there is a form to add an item' do
        visit (new_merchant_item_path(@merch2.id))

        expect(page).to have_content('Enter Item Name')
        expect(page).to have_content('Enter Item Description')
        expect(page).to have_content('Enter Item Price')
        expect(page).to have_button('Submit')
      end

      it "filling out form and clicking 'Submit' redirects to merchant index page" do
        visit (new_merchant_item_path(@merch2.id))

        fill_in 'Enter Item Name', with: 'Gadget'
        fill_in 'Enter Item Description', with: 'Does a thing'
        fill_in 'Enter Item Price', with: '42.95'

        click_button 'Submit'

        expect(current_path).to eq(merchant_items_path(@merch2.id))
      end

      it "new item is displayed on merchant index page and by default set to 'disabled'" do
        visit (new_merchant_item_path(@merch1.id))

        fill_in 'Enter Item Name', with: 'Gadget'
        fill_in 'Enter Item Description', with: 'Does a thing'
        fill_in 'Enter Item Price', with: '42.95'

        click_button 'Submit'

        expect(current_path).to eq(merchant_items_path(@merch1.id))

        within("#enabled") do
          expect(page).to have_link(@item2.name)
          expect(page).to_not have_link('Gadget')
        end

        within('#disabled') do
          expect(page).to have_link('Gadget')
        end
      end

      it 'has sad path for name' do
        visit (new_merchant_item_path(@merch1.id))

        fill_in 'Enter Item Description', with: 'Does a thing'
        fill_in 'Enter Item Price', with: '42.95'

        click_button 'Submit'

        expect(page).to have_content("Entry is invalid. Please fill in all entries with valid information.")
      end

      it 'has sad path for description' do
        visit (new_merchant_item_path(@merch1.id))

        fill_in 'Enter Item Name', with: 'Gadget'
        fill_in 'Enter Item Price', with: '42.95'

        click_button 'Submit'

        expect(page).to have_content("Entry is invalid. Please fill in all entries with valid information")
      end

      it 'has sad path for unit_price' do
        visit (new_merchant_item_path(@merch1.id))

        fill_in 'Enter Item Name', with: 'Gadget'
        fill_in 'Enter Item Description', with: 'Does a thing'
        fill_in 'Enter Item Price', with: 'forty dollars'

        click_button 'Submit'

        expect(page).to have_content("Entry is invalid. Please fill in all entries with valid information")
      end
    end
  end
end