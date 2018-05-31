- dashboard: operational_insights
  title: Operational Insights
  layout: newspaper
  elements:
  - title: Top 15 Returned Brands This Period
    name: Top 15 Returned Brands This Period
    model: alexdinsmoor_ramp
    explore: inventory_items
    type: table
    fields:
    - products.brand
    - order_items.selected_period_order_item_count
    filters:
      order_items.status: Returned
    sorts:
    - order_items.selected_period_order_item_count desc
    limit: 15
    query_timezone: America/Los_Angeles
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_range:
    - "#dd3333"
    - "#80ce5d"
    - "#f78131"
    - "#369dc1"
    - "#c572d3"
    - "#36c1b3"
    - "#b57052"
    - "#ed69af"
    yAxisMinValue:
    yAxisMaxValue:
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: circle
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    yAxisName: Number of Returned Items This Period
    xAxisName: Product Brand
    chartName: ''
    conditional_formatting:
    - type: high to low
      value:
      background_color:
      font_color:
      palette:
        name: Red to White
        colors:
        - "#F36254"
        - "#FFFFFF"
      bold: false
      italic: false
      strikethrough: false
      fields:
    series_labels:
      order_items.selected_period_order_item_count: Number of Returned Items
    listen:
      Date Period: order_items.date_filter
    row: 24
    col: 0
    width: 8
    height: 8
  - title: Frequently Ordered Products (> 5 Sold Last Month) Requiring Reorder
    name: Frequently Ordered Products (> 5 Sold Last Month) Requiring Reorder
    model: alexdinsmoor_ramp
    explore: inventory_items
    type: table
    fields:
    - distribution_centers.name
    - products.name
    - inventory_items.current_inventory_count
    - order_items.selected_period_order_item_count
    - inventory_items.periods_to_zero_inventory
    filters:
      order_items.date_filter: 1 months
      inventory_items.periods_to_zero_inventory: "<1.0"
      order_items.selected_period_order_item_count: ">5"
    sorts:
    - inventory_items.periods_to_zero_inventory
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      order_items.selected_period_order_item_count: Order Count in Last Month
      inventory_items.periods_to_zero_inventory: Months Until Inventory Reaches Zero
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: Red to White
        colors:
        - "#F36254"
        - "#FFFFFF"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - inventory_items.periods_to_zero_inventory
    listen:
      Distribution Center Name: distribution_centers.name
    row: 2
    col: 0
    width: 24
    height: 6
  - title: Average Delivery Time by User Location
    name: Average Delivery Time by User Location
    model: alexdinsmoor_ramp
    explore: order_items
    type: looker_map
    fields:
    - users.approx_location
    - order_items.average_days_to_deliver
    filters: {}
    sorts:
    - order_items.average_days_to_deliver desc
    limit: 5000
    column_limit: 50
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: value
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    map_latitude: 45.948285182663
    map_longitude: -84.33380126953125
    map_zoom: 3
    listen:
      Date Period: order_items.date_filter
    row: 16
    col: 12
    width: 12
    height: 8
  - title: Total Sales Trend Year-Over-Year
    name: Total Sales Trend Year-Over-Year
    model: alexdinsmoor_ramp
    explore: order_items
    type: looker_line
    fields:
    - order_items.created_month_num
    - order_items.created_year
    - order_items.created_month_name
    - order_items.total_sale_price
    pivots:
    - order_items.created_year
    fill_fields:
    - order_items.created_year
    sorts:
    - order_items.created_month_num
    - order_items.created_year
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: false
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    colors:
    - 'palette: Looker Classic'
    series_colors: {}
    hidden_fields:
    - order_items.created_month_num
    row: 16
    col: 0
    width: 12
    height: 8
  - title: Top 15 Product Categories by All-Time Gross Margin
    name: Top 15 Product Categories by All-Time Gross Margin
    model: alexdinsmoor_ramp
    explore: product_facts
    type: looker_pie
    fields:
    - product_facts.modified_category_name_by_revenue
    - product_facts.total_gross_margin
    sorts:
    - product_facts.total_gross_margin desc
    limit: 500
    query_timezone: America/Los_Angeles
    value_labels: labels
    label_type: labPer
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    colors:
    - 'palette: Santa Cruz'
    series_colors: {}
    row: 24
    col: 8
    width: 16
    height: 8
  - name: 'Actionable Insights: Require Immediate Attention'
    type: text
    title_text: 'Actionable Insights: Require Immediate Attention'
    row: 0
    col: 0
    width: 24
    height: 2
  - name: Longer-Term Observations
    type: text
    title_text: Longer-Term Observations
    row: 14
    col: 0
    width: 24
    height: 2
  - title: Orders Processing for More Than 10 Days
    name: Orders Processing for More Than 10 Days
    model: alexdinsmoor_ramp
    explore: order_items
    type: table
    fields:
    - order_items.order_id
    - distribution_centers.name
    - order_items.status
    - order_items.created_date
    - users.first_name
    - users.last_name
    - users.email
    - products.name
    filters:
      order_items.created_date: before 10 days ago
      order_items.status: Processing,Shipped
    sorts:
    - order_items.created_date
    limit: 500
    dynamic_fields:
    - table_calculation: days_since_creation
      label: Days Since Creation
      expression: diff_days(${order_items.created_date},now())
      value_format:
      value_format_name:
      _kind_hint: dimension
      _type_hint: number
    query_timezone: America/Los_Angeles
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: high to low
      value:
      background_color:
      font_color:
      palette:
        name: Red to White
        colors:
        - "#F36254"
        - "#FFFFFF"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - days_since_creation
    row: 8
    col: 0
    width: 24
    height: 6
  filters:
  - name: Date Period
    title: Date Period
    type: field_filter
    default_value: 1 weeks ago for 1 weeks
    allow_multiple_values: true
    required: false
    model: alexdinsmoor_ramp
    explore: order_items
    listens_to_filters: []
    field: order_items.date_filter
  - name: Distribution Center Name
    title: Distribution Center Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: alexdinsmoor_ramp
    explore: inventory_items
    listens_to_filters: []
    field: distribution_centers.name
