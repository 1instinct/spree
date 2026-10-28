require 'spec_helper'

describe Spree::Order, type: :model do
  describe 'nested address attributes with an id (guest IDOR hardening)' do
    %w[bill ship].each do |kind|
      describe "##{kind}_address_attributes=" do
        context 'with a guest order' do
          let(:own_address) { create(:address, user: nil) }
          let(:order) { create(:order, user: nil, email: 'guest@example.com', "#{kind}_address": own_address) }

          it 'does not attach another guest address by id' do
            other_guest_address = create(:address, user: nil)
            order.public_send("#{kind}_address_attributes=", { id: other_guest_address.id }.with_indifferent_access)
            expect(order.public_send("#{kind}_address")&.id).not_to eq(other_guest_address.id)
          end

          it 'updates its own address by id' do
            order.public_send("#{kind}_address_attributes=", { id: own_address.id, firstname: 'Jane' }.with_indifferent_access)
            expect(order.public_send("#{kind}_address").id).to eq(own_address.id)
            expect(own_address.reload.firstname).to eq('Jane')
          end
        end

        context 'with a registered user' do
          let(:user) { create(:user) }
          let(:order) { create(:order, user: user) }

          it 'does not resolve an unknown id to an arbitrary existing address' do
            create(:address, user: create(:user))
            order.public_send("#{kind}_address_attributes=", { id: 0 }.with_indifferent_access)
            expect(order.public_send("#{kind}_address")).to be_nil
          end
        end
      end
    end
  end
end
