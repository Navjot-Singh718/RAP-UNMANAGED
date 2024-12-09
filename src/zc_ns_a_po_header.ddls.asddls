@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View for PO Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true

@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI.headerInfo: {
    typeName: 'Purchase Order',
    typeNamePlural: 'Purchase Orders',
    title: {
        type: #STANDARD,
        value: 'PoNum'
           }
                }

define root view entity ZC_NS_A_PO_HEADER
  provider contract transactional_query
  as projection on ZR_NS_A_PO_HEADER
{
@Search.defaultSearchElement: true
  key PoNum,
      DocCat,
      Type,
      CompCode,
      Org,
      Status,
      Vendor,
      Plant,
      CreateBy,
      CreatedDateTime,
      ChangedDateTime,
      LocalLastChangedBy,
     _po_item : redirected to composition child ZC_NS_A_PO_ITEMS
}
