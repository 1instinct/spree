module Spree
  module Api
    module V2
      module Storefront
        class ProductsController < ::Spree::Api::V2::ResourceController
          private

          def sorted_collection
            collection_sorter.new(collection, current_currency, params, allowed_sort_attributes).call
          end

          def collection
            collection_finder.new(scope: scope, params: params, current_currency: current_currency).execute
          end

          def resource
            scope.find_by(slug: params[:id]) || scope.find(params[:id])
          end

          def collection_sorter
            if (!@spree_current_user.nil? && @spree_current_user.has_spree_role?('wholesale'))
              pr = Spree::Api::Dependencies.storefront_wholesale_sorter.constantize
            else
              pr = Spree::Api::Dependencies.storefront_products_sorter.constantize
            end
            pr
          end

          def collection_finder
            if (!@spree_current_user.nil? && @spree_current_user.has_spree_role?('wholesale'))
              pr = Spree::Api::Dependencies.storefront_wholesale_finder.constantize
            else
              pr = Spree::Api::Dependencies.storefront_products_finder.constantize
            end
            pr
          end

          def collection_serializer
            if (!@spree_current_user.nil? && @spree_current_user.has_spree_role?('wholesale'))
              pr = Spree::Api::Dependencies.storefront_wholesale_serializer.constantize
            else
              pr = Spree::Api::Dependencies.storefront_product_serializer.constantize
            end
            pr
          end

          def resource_serializer
            if (!@spree_current_user.nil? && @spree_current_user.has_spree_role?('wholesale'))
              pr = Spree::Api::Dependencies.storefront_wholesale_serializer.constantize
            else
              pr = Spree::Api::Dependencies.storefront_product_serializer.constantize
            end
            pr
          end

          def model_class
            Spree::Product
          end

          def scope_includes
            {
              master: :default_price,
              variants: [],
              variant_images: [],
              taxons: [],
              product_properties: :property,
              option_types: :option_values,
              variants_including_master: %i[default_price option_values]
            }
          end
        end
      end
    end
  end
end
