@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT ENTITY FOR STUDENT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_STUDENT_ROOT1
  as select from zrap_student
  association to ZI_STUDENT_GENDER         as _gender on $projection.Gender = _gender.value
  composition [0..*] of ZI_ACADEMIC_RESULT1 as _academicres
{
  key id                    as Id,
      firstname             as Firstname,
      lastname              as Lastname,
      age                   as Age,
      course                as Course,
      courseduration        as Courseduration,
      status                as Status,
      gender                as Gender,
      dob                   as Dob,
      _gender.Description   as Genderdesc,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _gender,
      _academicres

}
