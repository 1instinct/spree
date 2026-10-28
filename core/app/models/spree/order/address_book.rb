# https://github.com/spree-contrib/spree_address_book/blob/master/app/models/spree/order_decorator.rb
module Spree
  class Order < Spree::Base
    module AddressBook
      extend ActiveSupport::Concern

      def clone_shipping_address
        if ship_address
          self.bill_address = ship_address
        end
        true
      end

      def clone_billing_address
        if bill_address
          self.ship_address = bill_address
        end
        true
      end

      def bill_address_id=(id)
        # Re-assigning the order's current address is a no-op (guest checkout re-submits it).
        return if id.present? && bill_address_id.to_s == id.to_s

        address = Spree::Address.find_by(id: id)
        # A guest order has no user_id; nil == nil must not match (GHSA-87fh-rc96-6fr6).
        if address && user_id.present? && address.user_id == user_id
          self['bill_address_id'] = address.id
          user.update_attribute(:bill_address_id, address.id)
          bill_address.reload
        else
          self['bill_address_id'] = nil
        end
      end

      def bill_address_attributes=(attributes)
        self.bill_address = update_or_create_address(attributes)
        user.bill_address = bill_address if user
      end

      def ship_address_id=(id)
        # Re-assigning the order's current address is a no-op (guest checkout re-submits it).
        return if id.present? && ship_address_id.to_s == id.to_s

        address = Spree::Address.find_by(id: id)
        # A guest order has no user_id; nil == nil must not match (GHSA-87fh-rc96-6fr6).
        if address && user_id.present? && address.user_id == user_id
          self['ship_address_id'] = address.id
          user.update_attribute(:ship_address_id, address.id)
          ship_address.reload
        else
          self['ship_address_id'] = nil
        end
      end

      def ship_address_attributes=(attributes)
        self.ship_address = update_or_create_address(attributes)
        user.ship_address = ship_address if user
      end

      private

      def update_or_create_address(attributes = {})
        return if attributes.blank?

        attributes.transform_values! { |v| v == '' ? nil : v }

        default_address = address_scope_for_update.find_by(id: attributes[:id])

        if default_address&.editable?
          default_address.update(attributes)

          return default_address
        end

        new_attributes = attributes.except(:id, :updated_at, :created_at)
        # find_or_create_by with no attributes returns an arbitrary existing address,
        # so an id-only payload resolves to an owned address or to nothing.
        return default_address if new_attributes.values.all?(&:blank?)

        ::Spree::Address.find_or_create_by(new_attributes)
      end

      # Addresses an `*_address_attributes[id]` may point at: the user's own, or for a
      # guest order only the addresses already on this order (never other guests').
      def address_scope_for_update
        return user.addresses if user

        ::Spree::Address.where(user_id: nil, id: [self['bill_address_id'], self['ship_address_id']].compact)
      end
    end
  end
end
