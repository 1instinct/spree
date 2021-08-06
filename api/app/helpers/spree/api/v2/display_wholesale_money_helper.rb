module Spree
  module Api
    module V2
      # This is identical to DisplayMoneyHelper except
      # for which price type is selected (amount or wholesale_price).
      module DisplayWholesaleMoneyHelper
        extend ActiveSupport::Concern

        class_methods do
          def find_price(product_or_variant, currency)
            product_or_variant.price_in(currency)
          end

          def price(product_or_variant, currency)
            price = find_price(product_or_variant, currency)
            amount = if price.wholesale_price.nil?
                       price.amount
                     else
                       price.wholesale_price
                     end
            format('%.2f', amount)
          end

          def display_price(product_or_variant, currency)
            price = find_price(product_or_variant, currency)
            return nil if price.new_record?
            amount = if price.wholesale_price.nil?
                       price.amount
                     else
                       price.wholesale_price
                     end
            Spree::Money.new(amount, currency: currency).to_s
          end

          def compare_at_price(product_or_variant, currency)
            price = find_price(product_or_variant, currency)
            return nil if price.new_record? || price.compare_at_amount.blank?

            format('%.2f', price.compare_at_amount)
          end

          def display_compare_at_price(product_or_variant, currency)
            price = find_price(product_or_variant, currency)
            return nil if price.new_record? || price.compare_at_amount.blank?

            Spree::Money.new(price.compare_at_amount, currency: currency).to_s
          end
        end
      end
    end
  end
end
