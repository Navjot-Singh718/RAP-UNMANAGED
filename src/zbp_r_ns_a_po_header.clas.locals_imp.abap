CLASS lhc_zr_ns_a_po_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZPoHeader
        RESULT result,

      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR ZPoHeader RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZPoHeader.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZPoHeader.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZPoHeader.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZPoHeader RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZPoHeader.

    METHODS rba_Po_item FOR READ
      IMPORTING keys_rba FOR READ ZPoHeader\_Po_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Po_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE ZPoHeader\_Po_item.

    METHODS Change_status FOR MODIFY
      IMPORTING keys FOR ACTION ZPoHeader~Change_status RESULT result.
ENDCLASS.

CLASS lhc_zr_ns_a_po_header IMPLEMENTATION.
  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zr_ns_a_po_header IN LOCAL MODE
    ENTITY ZPoHeader
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_po_header_result)
    FAILED failed.

    result = VALUE #( FOR ls_po IN lt_po_header_result
     LET statusval = COND #(  WHEN ls_po-status = 'B'
                                       THEN if_abap_behv=>fc-o-disabled
                                       ELSE if_abap_behv=>fc-o-enabled )
                                   IN ( %tky = ls_po-%tky
                                   %action-Change_status = statusval )
                                    ).
  ENDMETHOD.

  METHOD create.
    DATA ls_po_header TYPE zns_a_po_header.

    READ TABLE entities ASSIGNING FIELD-SYMBOL(<fs_po_header>) INDEX 1.
    IF sy-subrc = 0.
      ls_po_header = CORRESPONDING #( <fs_po_header> MAPPING FROM ENTITY USING CONTROL ).
      INSERT zns_a_po_header FROM @ls_po_header.
      IF sy-subrc = 0.
        mapped-zpoheader = VALUE #( BASE mapped-zpoHeader ( %cid  = <fs_po_header>-%cid
                                                            poNum = ls_po_header-po_num ) ).
      ELSE.
        APPEND VALUE #( %cid  = <fs_po_header>-%cid
                        poNum = <fs_po_header>-poNum
                        ) TO failed-zpoHeader.

        APPEND VALUE #( %msg = new_message(
                                 id       = '00'
                                 number   = '01'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'Invalid Details'
                               )

                               %key-poNum = <fs_po_header>-poNum
                               %cid       = <fs_po_header>-%cid
                               %create    = 'X'
                               PoNum      = <Fs_po_header>-PoNum
                               ) TO reported-zpoHeader.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD update.
    DATA :  ls_po_hd TYPE zns_a_po_header.

    READ TABLE entities ASSIGNING FIELD-SYMBOL(<lfs_po_hd>) INDEX 1.
    IF sy-subrc EQ 0.
      SELECT SINGLE *
                    FROM zns_a_po_header
                    WHERE po_num EQ @<lfs_po_hd>-PoNum
                    INTO @ls_po_hd.

      IF <lfs_po_hd>-CompCode IS NOT INITIAL.
        ls_po_hd-comp_code = <lfs_po_hd>-CompCode.
      ENDIF.
      IF <lfs_po_hd>-DocCat IS NOT INITIAL.
        ls_po_hd-doc_cat = <lfs_po_hd>-DocCat.
      ENDIF.

      IF <lfs_po_hd>-Org IS NOT INITIAL.
        ls_po_hd-org = <lfs_po_hd>-Org.
      ENDIF.

      IF <lfs_po_hd>-Plant IS NOT INITIAL.
        ls_po_hd-plant = <lfs_po_hd>-Plant.
      ENDIF.

      IF <lfs_po_hd>-PoNum IS NOT INITIAL.
        ls_po_hd-po_num = <lfs_po_hd>-PoNum.
      ENDIF.

      IF <lfs_po_hd>-Status IS NOT INITIAL.
        ls_po_hd-status = <lfs_po_hd>-Status.
      ENDIF.

      IF <lfs_po_hd>-Type IS NOT INITIAL.
        ls_po_hd-type = <lfs_po_hd>-Type.
      ENDIF.

      IF <lfs_po_hd>-Vendor IS NOT INITIAL.
        ls_po_hd-vendor = <lfs_po_hd>-Vendor.
      ENDIF.

    ENDIF.

    UPDATE zns_a_po_header FROM @ls_po_hd .
    IF sy-subrc IS INITIAL.
      mapped-zpoHeader = VALUE #( BASE mapped-zpoHeader
      ( %cid = <lfs_po_hd>-%cid_ref
        PoNum = ls_po_hd-po_num
      ) ).
    ELSE.
      APPEND VALUE #( %cid = <lfs_po_hd>-%cid_ref
                      PoNum = <lfs_po_hd>-PoNum
                    ) TO failed-zpoHeader.

      APPEND VALUE #( %msg = new_message( id       = '00'
                                          number   = '001'
                                          v1       = 'Invalid Details'
                                          severity = if_abap_behv_message=>severity-error
                                        )
                      %key-PoNum = <lfs_po_hd>-PoNum
                      %cid       = <lfs_po_hd>-%cid_ref
                      %update    = 'X'
                      PoNum      = <lfs_po_hd>-PoNum
                    ) TO reported-zpoHeader.
    ENDIF.
  ENDMETHOD.

  METHOD delete.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<lfs_keys>) INDEX 1.
    IF sy-subrc EQ 0.
      DELETE FROM zns_a_po_header WHERE po_num EQ @<lfs_keys>-PoNum.
      IF sy-subrc NE 0.
        APPEND VALUE #( %cid = <lfs_keys>-%cid_ref
                        PoNum = <lfs_keys>-PoNum
                      ) TO failed-zpoHeader.

        APPEND VALUE #( %msg = new_message( id       = '00'
                                            number   = '001'
                                            v1       = 'Invalid Details'
                                            severity =  if_abap_behv_message=>severity-error )
                        %key-PoNum = <lfs_keys>-PoNum
                        %cid       = <lfs_keys>-%cid_ref
                        %delete    = 'X'
                        PoNum      = <lfs_keys>-PoNum ) TO reported-zpoHeader.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read.
    SELECT *
           FROM zns_a_po_header
           FOR ALL ENTRIES IN @keys
           WHERE po_num   = @keys-PoNum
           INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Po_item.
  ENDMETHOD.

  METHOD cba_Po_item.
    DATA : ls_po_items TYPE zns_a_po_items.

    READ TABLE entities_cba ASSIGNING FIELD-SYMBOL(<lfs_po_items>) INDEX 1.
    IF sy-subrc EQ 0.
      DATA(lv_po) = <lfs_po_items>-PoNum.
    ENDIF.

    READ TABLE <lfs_po_items>-%target ASSIGNING FIELD-SYMBOL(<lfs_items>) INDEX 1.
    IF sy-subrc EQ 0.
      DATA(ls_items) = CORRESPONDING zns_a_po_items( <lfs_items> MAPPING FROM ENTITY USING CONTROL ).
    ENDIF.

    INSERT zns_a_po_items FROM @ls_items.
    IF sy-subrc IS INITIAL.
      INSERT VALUE #( %cid   = <lfs_po_items>-%cid_ref
                      PoNum  = lv_po
                      PoItem = ls_items-po_item
                    ) INTO TABLE mapped-zpoitems.
    ELSE.
      APPEND VALUE #( %cid    = <lfs_po_items>-%cid_ref
                       PoNum  = lv_po
                       PoItem = ls_items-po_item
                    ) TO failed-zpoitems.

      APPEND VALUE #( %msg = new_message( id       = '00'
                                          number   = '001'
                                          v1       = 'Invalid Details'
                                          severity = if_abap_behv_message=>severity-error
                                        )
                      %key-PoNum  = lv_po
                      %key-PoItem = ls_items-po_item
                      %cid        = <lfs_po_items>-%cid_ref
                      PoNum       = lv_po
                      PoItem      = ls_items-po_item
                      ) TO reported-zpoitems.
    ENDIF.
  ENDMETHOD.

  METHOD Change_status.
    DATA : ls_po_hd TYPE zns_a_po_header.

    MODIFY ENTITIES OF zr_ns_a_po_header IN LOCAL MODE
    ENTITY zpoHeader
    UPDATE FROM VALUE #( FOR key IN keys
                         ( PoNum = key-PoNum
                           Status = 'B'
                           %control-Status = if_abap_behv=>mk-on
                         )
                       )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zr_ns_a_po_header IN LOCAL MODE
    ENTITY zpoHeader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(pos).


    result = VALUE #( FOR po IN pos ( %tky   = po-%tky
                                      %param = po
                                    )
                    ).
  ENDMETHOD.

ENDCLASS.
