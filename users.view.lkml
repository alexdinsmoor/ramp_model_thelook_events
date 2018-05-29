view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [0,10,20,30,40,50,60,70,80,90]
    style: integer
    sql: ${age} ;;
    drill_fields: [age]
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state,city,zip]
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: approx_location {
    type: location
    sql_latitude: round(${latitude},1) ;;
    sql_longitude: round(${longitude},1) ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city,zip]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [user_details*]
  }

  measure: male_count {
    type: count
    filters: {
      field: gender
      value: "Male"
    }
    drill_fields: [user_details*]
  }

  measure: female_count {
    type: count
    filters: {
      field: gender
      value: "Female"
    }
    drill_fields: [user_details*]
  }

  measure: male_percentage {
    type: number
    sql: 100.00 * ${male_count}/NULLIF(${count},0);;
    value_format: "#.00\%"
    drill_fields: [user_details*]

  }

  measure: female_percentage {
    type: number
    sql: 100.00 * ${female_count}/NULLIF(${count},0);;
    value_format: "#.00\%"
    drill_fields: [user_details*]
  }

  measure: is_male {
    type: yesno
    sql: ${gender} = 'Male';;
    drill_fields: [user_details*]
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
    drill_fields: [user_details*]
  }

  #drill fields
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
