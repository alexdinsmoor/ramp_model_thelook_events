- dashboard: lookml_dashboard___test
  title: LookML Dashboard _ Test
  layout: newspaper
  elements:
  - title: Top Returned Brands
    name: Top Returned Brands
    model: alexdinsmoor_ramp
    explore: inventory_items
    type: looker_bar
    fields:
    - products.brand
    - order_items.selected_period_order_item_count
    filters:
      order_items.status: Returned
      order_items.date_filter: 1 weeks ago for 1 weeks
    sorts:
    - order_items.selected_period_order_item_count desc
    limit: 15
    column_limit: 50
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
    row: 0
    col: 0
    width: 24
    height: 8
