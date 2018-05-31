include: "order_items.view*"

view: orders_facts {
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: items_in_order { field: order_items.count }
        column: order_amount { field: order_items.total_sale_price }
        column: order_cost { field: inventory_items.total_cost }
        column: user_id {field: order_items.user_id }
        column: created_at {field: order_items.created_raw}
        column: order_gross_margin {field: order_items.total_gross_margin}
        derived_column: order_number_by_user {
          sql: RANK() OVER (PARTITION BY user_id ORDER BY created_at) ;;
        }
      }
      persist_for: "4 hours"
      sortkeys: ["order_id"]
      distribution: "order_id"
    }

dimension: order_id {
  type: number
  hidden: yes
  primary_key: yes
  sql: ${TABLE}.order_id ;;
  drill_fields: [order_details*]
}

dimension: items_in_order {
  type: number
  sql: ${TABLE}.items_in_order ;;
  drill_fields: [order_details*]
}

dimension: order_amount {
  type: number
  value_format_name: usd
  sql: ${TABLE}.order_amount ;;
  drill_fields: [order_details*]
}

dimension: order_cost {
  type: number
  value_format_name: usd
  sql: ${TABLE}.order_cost ;;
  drill_fields: [order_details*]
}

dimension: order_gross_margin {
  type: number
  value_format_name: usd
  drill_fields: [order_details*]
}

dimension: order_number_by_user {
  type: number
  sql: ${TABLE}.order_number_by_user ;;
  drill_fields: [order_details*]
}

dimension: first_purchase_indicator {
  type: yesno
  sql: ${order_number_by_user} = 1 ;;
  drill_fields: [order_details*]
}

# ----- Sets of fields for drilling ------
  set: order_details {
    fields: [
      order_items.created_at_date,
      order_items.delivered_at_date,
      order_items.shipped_at_date,
      order_items.status,
      order_items.sale_price,
      inventory_items.cost,
      inventory_items.product_brand,
      inventory_items.product_category,
      inventory_items.product_department,
      inventory_items.product_name
    ]
  }
}
