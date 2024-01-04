@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'STUDENT ACADEMIC RESULTS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ACADEMIC_RESULT
  as select from zrap_academic
  association        to parent ZI_STUDENT_ROOT as _student on $projection.Id = _student.Id
  association [1..*] to zgy_i_course_um        as _course  on $projection.Course = _course.Value
  association [1..*] to ZGY_RAP_DEMO_Sem       as _sem     on $projection.Semester = _sem.Value
  association [1..*] to ZGY_RAP_DEMO_SEMRES    as _semres  on $projection.Semresult = _semres.Value
{
  key cast(id as sysuuid_x16 preserving type ) as Id,
  key course                                   as Course,
  key semester                                 as Semester,
      _course[1:inner].Description             as CourseDesc,
      _sem[1:inner].Description                as SemesterDesc,
      semresult                                as Semresult,
      _semres[1:inner].Description             as Semresult_Desc,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                          as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                    as LocalLastChangedAt,
      _student,
      _course,
      _sem,
      _semres
}
