include: "order_items.view*"

view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      day_of_month,
      week,
      week_of_year,
      month,
      month_num,
      month_name,
      quarter,
      quarter_of_year,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: is_current_inventory {
    type: yesno
    sql: (sold_at is null or order_items.status = 'cancelled') ;;
    drill_fields: [product_details*]
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      day_of_month,
      week,
      week_of_year,
      month,
      month_num,
      month_name,
      quarter,
      quarter_of_year,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [product_details*]
  }

  measure: current_inventory_count {
    type: count
    filters: {
      field: is_current_inventory
      value: "yes"
    }
    drill_fields: [product_details*]
  }

  measure: periods_to_zero_inventory {
    type: number
    sql: 1.0* ${current_inventory_count} / nullif(${order_items.selected_period_order_item_count},0);;
    drill_fields: [product_details*]
    value_format_name: decimal_1
  }

  measure: total_cost {
    type: sum
    value_format_name: usd
    drill_fields: [product_details*]
    sql: ${cost} ;;
  }

  measure: average_cost {
    type: average
    value_format_name: usd
    drill_fields: [product_details*]
    sql:${cost} ;;
  }

# ----- Sets of fields for drilling ------
  set: product_details {
    fields: [
      inventory_items.id,
      inventory_items.product_id,
      inventory_items.product_name,
      inventory_items.product_retail_price,
      inventory_items.product_cost
    ]
  }
}
