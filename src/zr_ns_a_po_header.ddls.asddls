@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Purchase Order Header Data'
define root view entity ZR_NS_A_PO_HEADER
  as select from zns_a_po_header
  composition [0..*] of ZR_NS_A_PO_ITEMS as _po_item
{
  key po_num                as PoNum,
      doc_cat               as DocCat,
      type                  as Type,
      comp_code             as CompCode,
      org                   as Org,
      status                as Status,
      vendor                as Vendor,
      plant                 as Plant,
      @Semantics.user.createdBy: true
      create_by             as CreateBy,
      @Semantics.systemDateTime.createdAt: true
      created_date_time     as CreatedDateTime,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      changed_date_time     as ChangedDateTime,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      _po_item

}
