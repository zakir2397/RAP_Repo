@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GENDER VIEW FOR STUDENT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_STUDENT_GENDER
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_GENDER' )
{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      value_low as value,
      @Semantics.text: true
      text as Description
}
