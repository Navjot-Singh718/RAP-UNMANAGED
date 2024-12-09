@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false
@EndUserText.label: 'Data Definition for PO Items Table'
define view entity ZR_NS_A_PO_ITEMS
  as select from zns_a_po_items as po_items
  association to parent ZR_NS_A_PO_HEADER as _po_header on $projection.PoNum = _po_header.PoNum
{
  key po_items.po_num                as PoNum,
  key po_item               as PoItem,
      item_text             as ItemText,
      material              as Material,
      plant                 as Plant,
      stor_loc              as StorLoc,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qty                   as Qty,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_UnitOfMeasureStdVH',
        entity.element: 'UnitOfMeasure',
        useForValidation: true
      } ]
      uom                   as Uom,
      @Semantics.amount.currencyCode: 'PriceUnit'
      product_price         as ProductPrice,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_CurrencyStdVH',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      price_unit            as PriceUnit,
      @Semantics.user.createdBy: true
      create_by             as CreateBy,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _po_header
}
