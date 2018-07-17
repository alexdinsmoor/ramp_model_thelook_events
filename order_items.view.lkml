include: "orders_facts.view*"
include: "inventory_items.view*"

view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    html:
    {% if value == 'Complete' %}
    <div style="background-color:#D5EFEE">{{ value }}</div>
    {% elsif value == 'Processing' or value == 'Shipped' %}
    <div style="background-color:#FCECCC">{{ value }}</div>
    {% elsif value == 'Cancelled' or value == 'Returned' %}
    <div style="background-color:#EFD5D6">{{ value }}</div>
    {% endif %}
    ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  #logistical shipping measures

  measure: days_to_ship {
    description: "Days between order creation date and order shipped date"
    type: number
    sql:  1.0*datediff(days,${created_date},${shipped_date}) ;;
    drill_fields: [order_details*]
    value_format: "0.00"
  }

  measure: days_to_deliver{
    description: "Days between order creation date and order delivered date"
    type: number
    sql:  1.0*datediff(days, ${created_date},${delivered_date}) ;;
    drill_fields: [order_details*]
    value_format: "0.00"
  }

  measure: average_days_to_ship {
    description: "Average number of days between order creation date and order shipped date"
    type: average
    sql:  1.0*(datediff(days,${created_date},${shipped_date})) ;;
    drill_fields: [order_details*]
    value_format: "0.00"
  }

  measure: average_days_to_deliver{
    description: "Average number of days between order creation date and order delivered date"
    type: average
    sql:  1.0*(datediff(days, ${created_date},${delivered_date})) ;;
    drill_fields: [order_details*]
    value_format: "0.00"
  }

  #financial measures
  measure: total_sale_price {
    type: sum
    sql:${sale_price};;
    value_format_name: usd_0
    drill_fields: [order_details*]
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [order_details*]
  }

  measure:  gross_margin {
    description: "Sale price minus item cost"
    type: number
    sql:  ${sale_price} - ${inventory_items.cost} ;;
    value_format_name: usd_0
    drill_fields: [order_details*]
  }

  measure:  total_gross_margin {
    description: "Total sale price minus total cost"
    type: number
    sql:  ${total_sale_price} - ${inventory_items.total_cost} ;;
    value_format_name: usd_0
    drill_fields: [order_details*]
  }

  #period comparison logic

  filter: date_filter {
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date
  }

  dimension_group: filter_start_date {
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN '2014-01-01' ELSE CAST({% date_start date_filter %} AS DATE) END;;
  }

  dimension_group: filter_end_date {
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_end date_filter %} AS DATE) END;;
  }

  dimension: interval {
    type: number
    sql: datediff(day, ${filter_start_date_raw}, ${filter_end_date_raw});;
  }

  dimension: previous_start_date {
    type: string
    sql: DATEADD(day, - (${interval}+1), ${filter_start_date_raw});;
  }

  dimension: is_current_period {
    type: yesno
    sql: ${created_date} >= ${filter_start_date_date} AND ${created_date} < ${filter_end_date_date} ;;
  }

  dimension: is_previous_period {
    type: yesno
    sql: ${created_date} >= ${previous_start_date} AND ${created_date} < ${filter_start_date_date} ;;
  }

  dimension: timeframes {
    description: "Use this field in combination with the date filter field for dynamic date filtering"
    suggestions: ["this period","previous period"]
    type: string
    case: {
      when: {
        sql: ${is_current_period} = true;;
        label: "This Period"
      }
      when: {
        sql: ${is_previous_period} = true;;
        label: "Previous Period"
      }
      else: "Not in time period"
    }
  }

  measure: selected_period_order_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: is_current_period
      value: "yes"
    }
    value_format_name: usd_0
    drill_fields: [order_details*]
  }

  measure: previous_period_order_revenue {
    type: sum
    sql: ${sale_price};;
    filters: {
      field: is_previous_period
      value: "yes"
    }
    value_format_name: usd_0
    drill_fields: [order_details*]
  }

  measure: percentage_change_in_revenue {
    description: "Compares selected period's total sales vs. previous period's total sales"
    type: number
    sql: cast(${selected_period_order_revenue} as float) /
    nullif(cast(${previous_period_order_revenue} as float),0) - 1.00 ;;
    value_format_name: percent_1
    drill_fields: [order_details*]
  }

  measure: selected_period_order_item_count {
    type: count
    filters: {
      field: is_current_period
      value: "yes"
    }
    drill_fields: [order_details*]
  }

  measure: previous_period_order_item_count {
    type: count
    filters: {
      field: is_previous_period
      value: "yes"
    }
    drill_fields: [order_details*]

  }

  measure: percentage_change_in_order_count {
    description: "Compares selected period's total order item count vs. previous period's total order item count"
    type: number
    sql: cast(${selected_period_order_item_count} as float) /
    nullif(cast(${previous_period_order_item_count} as float),0) - 1.00 ;;
    value_format_name: percent_1
    drill_fields: [order_details*]
  }

  #other measures
  measure: count {
    type: count
    drill_fields: [order_details*]
  }

  measure: order_total_amount {
    description: "Sums at the order level (instead of the order item level)"
    type: sum_distinct
    sql_distinct_key: ${order_id} ;;
    sql: ${orders_facts.order_amount} ;;
    value_format_name: usd
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

  set: user_details {
    fields: [
      users.first_name,
      users.last_name,
      users.gender,
      users.traffic_source,
      users.country,
      users.state,
      users.zip,
      users.city
    ]
  }

}
