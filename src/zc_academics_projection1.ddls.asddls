@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'STUDENT ACADEMIC PROJECTION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZC_ACADEMICS_PROJECTION1
  as projection on ZI_ACADEMIC_RESULT1
{
 key Id,
      @EndUserText.label: 'Course'
  key Course,
      @EndUserText.label: 'Semester'
  key Semester,
      @EndUserText.label: 'Course Description'
      CourseDesc,
      @EndUserText.label: 'Semester Description'
      SemesterDesc,
      @EndUserText.label: 'Semester Result'
      Semresult,
      @EndUserText.label: 'Semester Result Description'
      Semresult_Desc,
   _student : redirected to parent ZC_STUDENT_PROJECTION1
}
