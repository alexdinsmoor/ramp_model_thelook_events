view: users_facts {
  derived_table: {
    sql:
    select u.id as user_id, u.gender,
    count(distinct (case when event_type = 'Cart' then u.id end)) as item_added_to_cart_ind,
    sum(oi.sale_price) as lifetime_revenue,
    count(distinct oi.order_id) as order_count,
    sum(sale_price)/count(distinct oi.order_id) as average_order_price,
    min(oi.created_at) as first_order_date, max(oi.created_at) as last_order_date,
    NTILE(4) OVER(ORDER BY lifetime_revenue DESC) as lifetime_value_quartile
    from users as u
    left join order_items as oi on u.id = oi.user_id
    left join events as e on u.id = e.user_id
    group by 1,2 order by 1,2
    ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
    drill_fields: [user_facts_details*]
  }

  dimension: lifetime_revenue {
    description: "Total sales attributed to user"
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
    drill_fields: [user_facts_details*]
  }

  dimension: item_added_to_cart_ind {
    type: yesno
    sql: ${TABLE}.item_added_to_cart_ind = '1' ;;
  }

  dimension: order_count {
    description: "Total orders attributed to user"
    type: number
    sql: ${TABLE}.order_count ;;
    drill_fields: [user_facts_details*]
  }

  dimension: order_count_tier {
    type: tier
    sql: ${TABLE}.order_count ;;
    tiers: [0,1,5,10,25]
    style:integer
    drill_fields: [user_facts_details*]
  }

  dimension: average_order_price {
    type: number
    sql: ${TABLE}.average_order_price ;;
    drill_fields: [user_facts_details*]
  }

  dimension: lifetime_value_quartile {
    description: "Highest spenders are classified as quartile 1, lowest spenders are classified as quartile 4"
    type: number
    sql: ${TABLE}.lifetime_value_quartile ;;
    drill_fields: [user_facts_details*]
  }

  measure: item_added_to_cart_user_count {
    description: "User has one or more web events"
    type: count
    filters: {
      field:item_added_to_cart_ind
      value: "Yes"
    }
    drill_fields: [user_facts_details*]
  }
  measure: user_count_with_order {
    description: "User has placed one or more order"
    type: count
    filters: {
      field: order_count
      value: ">0"
    }
    drill_fields: [user_facts_details*]
  }
  measure: user_count_with_multiple_orders {
    description: "User has placed more than one order"
    type: count
    filters: {
      field: order_count
      value: ">1"
    }
    drill_fields: [user_facts_details*]
  }

  measure: average_web_action_taken_count {
    type: average
    sql: ${item_added_to_cart_ind} ;;
    drill_fields: [user_facts_details*]
  }

  dimension_group: first_order {
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
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order {
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
    sql: ${TABLE}.last_order_date ;;
  }

  #drill fields
  set: user_facts_details {
    fields: [
      user_id,
      lifetime_revenue,
      average_order_price,
      order_count,
      first_order_raw,
      last_order_raw
    ]
  }
}
