@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION(CONSUMPTION) VIEW FOR STUDENT'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.semanticKey: [ 'Firstname' ]
define root view entity ZC_STUDENT_PROJECTION1
  provider contract transactional_query  as projection on ZI_STUDENT_ROOT1
{
@EndUserText.label: 'Student Id'
    key Id,
  @EndUserText.label: 'First Name'  
    Firstname,
    @EndUserText.label: 'Last Name'
    Lastname,
    @EndUserText.label: 'Age'
    Age,
     @EndUserText.label: 'Course'
    Course,
     @EndUserText.label: 'Course Duration'
    Courseduration,
     @EndUserText.label: 'Status'
    Status,
     @EndUserText.label: 'Gender'
    Gender,
     @EndUserText.label: 'GenderDescription'
    Genderdesc,
     @EndUserText.label: 'DOB'
    Dob,
    _academicres : redirected to composition child ZC_ACADEMICS_PROJECTION1,
    _gender
}
