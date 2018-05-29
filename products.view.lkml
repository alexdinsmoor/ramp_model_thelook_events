view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }

  measure: total_retail_price {
    type: sum
    sql: ${retail_price} ;;
    value_format_name: usd
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }

  measure: total_retail_markup {
    description: "Total retail price minus total cost"
    type: number
    sql: ${total_retail_price} - ${total_cost}cost} ;;
    value_format_name: usd
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }

  measure: total_retail_percentage_markup {
    type: number
    description: "Retail markup as a percentage of cost"
    sql: (${total_retail_price} - ${total_cost}cost})/${total_cost} ;;
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }

}
