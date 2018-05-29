view: distribution_centers {
  sql_table_name: public.distribution_centers ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: approx_location {
    type: location
    sql_latitude: round(${latitude},1) ;;
    sql_longitude: round(${longitude},1) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }
}
