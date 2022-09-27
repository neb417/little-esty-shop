require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it {should belong_to(:merchant)}
  end

  describe 'validations' do
    it 'validates name' do
      should { validate_presence_of(:name) }
    end

    it 'validates threshold' do
      should { validate_presence_of(:threshold) }
    end

    it 'validates percentage' do
      should { validate_presence_of(:percentage) }
    end
  end
end