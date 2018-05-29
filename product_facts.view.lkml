view: product_facts {
  derived_table: {
    sql: select ii.product_category, sum(oi.sale_price) as total_revenue, sum(ii.cost) as total_cost,
      sum(oi.sale_price) - sum(ii.cost) as total_gross_margin,
      rank() over (order by total_revenue desc) as product_category_rank_by_revenue,
      case when rank() over (order by total_revenue desc)  < 10 then ii.product_category else 'Other' end as modified_category_name_by_revenue,
      rank() over (order by total_gross_margin desc) as product_category_rank_by_margin,
      case when rank() over (order by total_gross_margin desc) < 10 then ii.product_category else 'Other' end as modified_category_name_by_margin
      from order_items as oi
      left join inventory_items as ii on oi.inventory_item_id = ii.id
      group by 1
      order by 2 desc;
       ;;
  }

  measure: count {
    type: count
    drill_fields: [product_details*]
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
    drill_fields: [product_details*]
  }

  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
    drill_fields: [product_details*]
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
    drill_fields: [product_details*]
  }

  dimension: total_gross_margin {
    type: number
    sql: ${TABLE}.total_gross_margin ;;
    drill_fields: [product_details*]
  }

  dimension: product_category_rank_by_revenue {
    description: "Ranked from highest total sales to lowest total sales"
    type: number
    sql: ${TABLE}.product_category_rank_by_revenue ;;
    drill_fields: [product_details*]
  }

  dimension: modified_category_name_by_revenue {
    description: "Top 9 categories by total revenue retain name and the rest are bundled into 'Other'"
    type: string
    sql: ${TABLE}.modified_category_name_by_revenue ;;
    drill_fields: [product_details*]
  }

  dimension: product_category_rank_by_margin {
    description: "Ranked from highest total margin to lowest total margin"
    type: number
    sql: ${TABLE}.product_category_rank_by_margin ;;
    drill_fields: [product_details*]
  }

  dimension: modified_category_name_by_margin {
    description: "Top 9 categories by total margin retain name and the rest are bundled into 'Other'"
    type: string
    sql: ${TABLE}.modified_category_name_by_margin ;;
    drill_fields: [product_details*]
  }

  set: product_details {
    fields: [
      product_category,
      total_revenue,
      total_cost,
      total_gross_margin,
      product_category_rank_by_revenue,
      modified_category_name_by_revenue,
      product_category_rank_by_margin,
      modified_category_name_by_margin
    ]
  }
}
