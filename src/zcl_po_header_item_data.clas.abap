CLASS zcl_po_header_item_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_po_header_item_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_header_data TYPE STANDARD TABLE OF zns_a_po_header,
          lt_item_data   TYPE STANDARD TABLE OF zns_a_po_items.

    lt_header_data = VALUE #( create_by             = sy-uname
                              created_date_time     = '20241202105654.4296640'
                              changed_date_time     = '20241202105654.4296640'
                              local_last_changed_by = sy-uname
                                ( po_num    = '1000000001'
                                  doc_cat   = ''
                                  type      = 'NB'
                                  comp_code = 'COMP'
                                  org       = 'ORG2'
                                  status    = 'B'
                                  vendor    = 'BAN'
                                  plant     = 'HYD'
                                )

                                 ( po_num    = '1000000002'
                                  doc_cat   = ''
                                  type      = 'NB'
                                  comp_code = 'COMP'
                                  org       = 'ORG2'
                                  status    = 'A'
                                  vendor    = 'BANG'
                                  plant     = 'PUN'
                                )

                                 ( po_num    = '1000000003'
                                  doc_cat   = 'B'
                                  type      = 'NB'
                                  comp_code = '1003'
                                  org       = 'ORG1'
                                  status    = 'A'
                                  vendor    = 'COMP1'
                                  plant     = 'BANG'
                                )
                             ).

    DELETE FROM zns_a_po_header .
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.

    IF lt_header_data IS NOT INITIAL.
      INSERT zns_a_po_header FROM TABLE @lt_header_data.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.
    ENDIF.

    lt_item_data = VALUE #(   create_by             = sy-uname
                              local_last_changed_by   = sy-uname
                              local_last_changed_at = '20241202105654.4296640'
                              (
                              po_num        = '1000000001'
                              po_item       = '01001'
                              item_text     = 'Laptop'
                              material      = 'lt/12'
                              plant         = 'HYD'
                              stor_loc      = 'HCL'
                              qty           = '10000'
                              uom           = 'KG'
                              product_price = '500'
                              price_unit    = 'USD'
                              )

                               (
                               po_num        = '1000000002'
                              po_item       = '01002'
                              item_text     = 'Mobile'
                              material      = 'lt/13'
                              plant         = 'PUN'
                              stor_loc      = 'Apple'
                              qty           = '1000'
                              uom           = 'KG'
                              product_price = '999'
                              price_unit    = 'USD'
                              )

                               (
                                po_num        = '1000000003'
                              po_item       = '01003'
                              item_text     = 'Headphones'
                              material      = 'lt/14'
                              plant         = 'BANG'
                              stor_loc      = 'HP'
                              qty           = '10000'
                              uom           = 'KG'
                              product_price = '200'
                              price_unit    = 'USD'

                              )
                           ).

    DELETE FROM zns_a_po_items .
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.

    IF lt_item_data IS NOT INITIAL.
      INSERT zns_a_po_items FROM TABLE @lt_item_data.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
