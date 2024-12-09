CLASS lhc_ZPoItems DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZPoItems.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZPoItems.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZPoItems.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZPoItems RESULT result.

    METHODS rba_Po_header FOR READ
      IMPORTING keys_rba FOR READ ZPoItems\_Po_header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZPoItems IMPLEMENTATION.

  METHOD create.
    DATA : ls_po_items TYPE zns_a_po_items.

    READ TABLE entities ASSIGNING FIELD-SYMBOL(<lfs_po_items>) INDEX 1.
    IF sy-subrc EQ 0.
      ls_po_items = CORRESPONDING #( <lfs_po_items> MAPPING FROM ENTITY USING CONTROL
      ).
    ENDIF.
    INSERT zns_a_po_items FROM @ls_po_items.
    IF sy-subrc IS NOT INITIAL.

      mapped-zpoItems = VALUE #( BASE mapped-zpoItems
                                 ( %cid   = <lfs_po_items>-%cid
                                   PoNum  = ls_po_items-po_num
                                   PoItem = ls_po_items-po_item
                                  )
                                ).
    ELSE.
      APPEND VALUE #( %cid   = <lfs_po_items>-%cid
                      PoNum  = <lfs_po_items>-PoNum
                      PoItem = <lfs_po_items>-PoItem
                    ) TO failed-zpoItems.

      APPEND VALUE #( %msg = new_message( id = '00'
                                          number = '001'
                                          v1 = 'Invalid Details'
                                          severity = if_abap_behv_message=>severity-error
                                          )
                      %key-PoNum  = <lfs_po_items>-PoNum
                      %key-PoItem = <lfs_po_items>-PoItem
                      %cid        = <lfs_po_items>-%cid
                      %create     = 'X'
                      PoNum       = <lfs_po_items>-PoNum
                      PoItem      = <lfs_po_items>-PoItem ) TO reported-zpoItems.
    ENDIF.
  ENDMETHOD.

  METHOD update.
    DATA : ls_po_items TYPE zns_a_po_items,
           lt_po_items TYPE TABLE OF zns_a_po_items.

    SELECT *
           FROM zns_a_po_items
           FOR ALL ENTRIES IN @entities
           WHERE po_num = @entities-PoNum
           INTO TABLE @lt_po_items.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_po_it>).

      READ TABLE lt_po_items ASSIGNING FIELD-SYMBOL(<lfs_items>) WITH KEY po_num = <lfs_po_it>-PoNum
                                                                          po_item = <lfs_po_it>-PoItem
                                                                          BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF <lfs_po_it>-Material IS NOT INITIAL.
          <lfs_items>-material = <lfs_po_it>-Material.
        ENDIF.
        IF <lfs_po_it>-ItemText IS NOT INITIAL.
          <lfs_items>-item_text = <lfs_po_it>-ItemText.
        ENDIF.
        IF <lfs_po_it>-Plant IS NOT INITIAL.
          <lfs_items>-plant = <lfs_po_it>-Plant.
        ENDIF.
        IF <lfs_po_it>-ProductPrice IS NOT INITIAL.
          <lfs_items>-product_price = <lfs_po_it>-ProductPrice.
        ENDIF.
        IF <lfs_po_it>-PriceUnit IS NOT INITIAL.
          <lfs_items>-price_unit = <lfs_po_it>-PriceUnit.
        ENDIF.
        IF <lfs_po_it>-Qty IS NOT INITIAL.
          <lfs_items>-qty = <lfs_po_it>-Qty.
        ENDIF.
        IF <lfs_po_it>-Uom IS NOT INITIAL.
          <lfs_items>-uom = <lfs_po_it>-Uom.
        ENDIF.
        IF <lfs_po_it>-StorLoc IS NOT INITIAL.
          <lfs_items>-stor_loc = <lfs_po_it>-StorLoc.
        ENDIF.
      ENDIF.
    ENDLOOP.
    UPDATE zns_a_po_items FROM TABLE @lt_po_items.
    IF sy-subrc IS INITIAL.
      INSERT VALUE #( %cid   = <lfs_po_it>-%cid_ref
                      PoNum  = <lfs_po_it>-PoNum
                      PoItem = <lfs_po_it>-PoItem
                    ) INTO TABLE mapped-zpoItems.
    ELSE.

      APPEND VALUE #( %cid  = <lfs_po_it>-%cid_ref
                      PoNum = <lfs_po_it>-PoNum
                      PoItem = <lfs_po_it>-PoItem
                    ) TO failed-zpoItems.

      APPEND VALUE #( %msg = new_message( id = '00'
                                          number = '001'
                                          v1 = 'Invalid Details'
                                          severity = if_abap_behv_message=>severity-error
                                         )
                      %key-PoNum  = <lfs_po_it>-PoNum
                      %key-PoItem = <lfs_po_it>-PoItem
                      %cid        = <lfs_po_it>-%cid_ref
                      %update     = 'X'
                      PoNum       = <lfs_po_it>-PoNum
                      PoItem = <lfs_po_it>-PoItem
                     ) TO reported-zpoItems.
    ENDIF.

  ENDMETHOD.

  METHOD delete.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<lfs_keys>) INDEX 1.
    IF sy-subrc EQ 0.
      DELETE FROM zns_a_po_items WHERE po_num EQ @<lfs_keys>-PoNum AND
                                       po_item EQ @<lfs_keys>-PoItem.
      IF sy-subrc NE 0.
        APPEND VALUE #( %cid = <lfs_keys>-%cid_ref
                        PoNum = <lfs_keys>-PoNum
                        PoItem = <lfs_keys>-PoItem
                      ) TO failed-zpoItems.

        APPEND VALUE #( %msg = new_message( id = '00'
                                            number = '001'
                                            v1 = 'Invalid Details'
                                            severity = if_abap_behv_message=>severity-error
                                          )
                        %key-PoNum  = <lfs_keys>-PoNum
                        %key-PoItem = <lfs_keys>-PoItem
                        %cid        = <lfs_keys>-%cid_ref
                        %delete     = 'X'
                        PoNum       = <lfs_keys>-PoNum
                        PoItem = <lfs_keys>-PoItem
                      ) TO reported-zpoItems.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Po_header.
  ENDMETHOD.

ENDCLASS.
