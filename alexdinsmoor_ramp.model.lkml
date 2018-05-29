connection: "thelook_events"

# include all views except for bsandell and company_list, which contain extraneous data
include: "distribution_centers.view"
include: "events.view"
include: "inventory_items.view"
include: "order_items.view"
include: "products.view"
include: "users.view"

# add derived views
include: "users_facts.view"
include: "orders_facts.view"

# include all the dashboards
include: "*.dashboard"

datagroup: alexdinsmoor_ramp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hours"
}

persist_with: alexdinsmoor_ramp_default_datagroup

explore: users {
  persist_with: alexdinsmoor_ramp_default_datagroup
  hidden: no
  label: "Event & User Details"
  description: "Event and user information"
  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: one_to_many
  }

  join: users_facts {
      view_label: "Users"
      type:  left_outer
      sql_on:  ${users.id} = ${users_facts.user_id} ;;
      relationship: one_to_one
  }
}

explore: inventory_items {
  fields: [
    ALL_FIELDS*,
    -inventory_items.product_category,
    -inventory_items.product_department,
    -inventory_items.product_name,
    -inventory_items.product_brand,
    -inventory_items.product_sku,
    -inventory_items.product_distribution_center_id,
    -inventory_items.product_retail_price,
    -inventory_items.product_id
  ]
  persist_with: alexdinsmoor_ramp_default_datagroup
  hidden: no
  label: "Inventory Details"
  description: "Inventory information with accompanying product, distribution, and order details"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_items {
    type: left_outer
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
    relationship: one_to_one
  }

  join: orders_facts {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders_facts.order_id} ;;
    relationship: many_to_one
  }

}

#we can perform inner join between order_items and users here because all users in the order_items table will exist in the users table

explore: order_items {
  fields: [
    ALL_FIELDS*,
    -inventory_items.product_category,
    -inventory_items.product_department,
    -inventory_items.product_name,
    -inventory_items.product_brand,
    -inventory_items.product_sku,
    -inventory_items.product_distribution_center_id,
    -inventory_items.product_retail_price,
    -inventory_items.product_id
  ]
  persist_with: alexdinsmoor_ramp_default_datagroup
  hidden: no
  label: "Order Details"
  description: "Order items information accompanied by inventory, product, and distribution details"
  join: orders_facts {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders_facts.order_id} ;;
    relationship:  many_to_one
  }

  join: users {
    type: inner
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: many_to_many
  }
}

explore: products {
  hidden: yes
  label: "Product Info"
  description: "Product information accompanied by distribution center details"
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

# included here to test self-join mechanics, extend, etc.
explore: distribution_centers {
  hidden: yes
  label: "Distribution Info"
  description: "Distribution and inventory information"
  fields: [ALL_FIELDS*,-distribution_centers_2.id]
  join: distribution_centers_2 {
    from: distribution_centers
    type: left_outer
    sql_on: ${distribution_centers.id} = ${distribution_centers_2.id};;
    relationship: one_to_one
  }
}
