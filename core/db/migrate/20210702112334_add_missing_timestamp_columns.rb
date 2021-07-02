class AddMissingTimestampColumns < ActiveRecord::Migration[5.2]
  def change
    # Add missing created_at columns
    add_column :spree_promotion_actions, :created_at, :datetime
    add_column :spree_roles, :created_at, :datetime
    add_column :spree_promotion_rule_taxons, :created_at, :datetime
    add_column :spree_products_taxons, :created_at, :datetime
    add_column :spree_reimbursement_credits, :created_at, :datetime
    add_column :spree_promotion_rule_users, :created_at, :datetime
    add_column :spree_promotion_action_line_items, :created_at, :datetime
    add_column :spree_states, :created_at, :datetime
    add_column :spree_option_type_prototypes, :created_at, :datetime
    add_column :spree_order_promotions, :created_at, :datetime
    add_column :spree_product_promotion_rules, :created_at, :datetime
    add_column :spree_role_users, :created_at, :datetime
    add_column :spree_shipping_method_zones, :created_at, :datetime
    add_column :spree_option_value_variants, :created_at, :datetime
    add_column :spree_property_prototypes, :created_at, :datetime
    add_column :spree_countries, :created_at, :datetime
    add_column :spree_prototype_taxons, :created_at, :datetime
    # Add missing updated_at columns
    add_column :spree_promotion_actions, :updated_at, :datetime
    add_column :spree_roles, :updated_at, :datetime
    add_column :spree_promotion_rule_taxons, :updated_at, :datetime
    add_column :spree_products_taxons, :updated_at, :datetime
    add_column :spree_reimbursement_credits, :updated_at, :datetime
    add_column :spree_promotion_rule_users, :updated_at, :datetime
    add_column :spree_promotion_action_line_items, :updated_at, :datetime
    add_column :spree_option_type_prototypes, :updated_at, :datetime
    add_column :spree_order_promotions, :updated_at, :datetime
    add_column :spree_product_promotion_rules, :updated_at, :datetime
    add_column :spree_role_users, :updated_at, :datetime
    add_column :spree_shipping_method_zones, :updated_at, :datetime
    add_column :spree_option_value_variants, :updated_at, :datetime
    add_column :spree_property_prototypes, :updated_at, :datetime
    add_column :spree_prototype_taxons, :updated_at, :datetime  end
end
