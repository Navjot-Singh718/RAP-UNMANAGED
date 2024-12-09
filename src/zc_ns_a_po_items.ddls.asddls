@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View for PO Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZC_NS_A_PO_ITEMS
  as projection on ZR_NS_A_PO_ITEMS
{
 @Search.defaultSearchElement: true
  key PoNum,
  key PoItem,
  ItemText,
  Material,
  Plant,
  StorLoc,
  Qty,
  @Semantics.unitOfMeasure: true
  Uom,
  ProductPrice,
  @Semantics.currencyCode: true
  PriceUnit,
  CreateBy,
  LocalLastChangedBy,
  LocalLastChangedAt,
  _po_header: redirected to parent ZC_NS_A_PO_HEADER
}
