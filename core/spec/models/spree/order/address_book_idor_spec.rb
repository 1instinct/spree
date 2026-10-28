require 'spec_helper'

describe Spree::Order, type: :model do
  describe 'address id assignment ownership (GHSA-87fh-rc96-6fr6)' do
    %w[bill ship].each do |kind|
      describe "##{kind}_address_id=" do
        context 'with a registered user' do
          let(:user) { create(:user) }
          let(:order) { create(:order, user: user) }

          it 'assigns an address owned by the user' do
            address = create(:address, user: user)
            order.public_send("#{kind}_address_id=", address.id)
            expect(order.public_send("#{kind}_address_id")).to eq(address.id)
          end

          it 'does not assign an address of another user' do
            address = create(:address, user: create(:user))
            order.public_send("#{kind}_address_id=", address.id)
            expect(order.public_send("#{kind}_address_id")).to be_nil
          end
        end

        context 'with a guest order' do
          let(:own_address) { create(:address, user: nil) }
          let(:order) { create(:order, user: nil, email: 'guest@example.com', "#{kind}_address": own_address) }

          it 'does not assign another guest address' do
            other_guest_address = create(:address, user: nil)
            order.public_send("#{kind}_address_id=", other_guest_address.id)
            expect(order.public_send("#{kind}_address_id")).to be_nil
          end

          it 'does not assign an address of a registered user' do
            address = create(:address, user: create(:user))
            order.public_send("#{kind}_address_id=", address.id)
            expect(order.public_send("#{kind}_address_id")).to be_nil
          end

          it 'keeps its own current address when it is re-submitted' do
            order.public_send("#{kind}_address_id=", own_address.id.to_s)
            expect(order.public_send("#{kind}_address_id")).to eq(own_address.id)
          end
        end
      end
    end
  end
end
