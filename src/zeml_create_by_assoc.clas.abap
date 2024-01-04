CLASS zeml_create_by_assoc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zeml_create_by_assoc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: ls_date TYPE sy-datum VALUE '19980320'.
    DATA: lt_student TYPE TABLE FOR CREATE zi_student_root.
    DATA: lt_academics TYPE TABLE FOR CREATE zi_student_root\_academicres,
          ls_academics LIKE LINE OF lt_academics.

    DATA:lt_target LIKE ls_academics-%target.

    DATA:lv_operation TYPE char3 VALUE 'RES'.

    CASE lv_operation.
    when 'C'.
    lt_student = VALUE #( ( %cid = 'StudentHeader'  Firstname = 'Suhail' Lastname = 'Malik'
                      Dob = ls_date
                      Course = 'Engineering' Courseduration = '4' Status = 'X'
                     %control = VALUE #(
                      Firstname = if_abap_behv=>mk-on
                      Lastname = if_abap_behv=>mk-on
                      Dob = if_abap_behv=>mk-on
                      course = if_abap_behv=>mk-on
                      Courseduration = if_abap_behv=>mk-on
                      Status = if_abap_behv=>mk-on
                       ) ) ).

    lt_target = VALUE #( ( %cid = 'StudentAcademics' " Id = 'A000781289829'
                             Course = 'E'
                           "CourseDesc = 'Engineering'
                            Semester = 'I' "SemesterDesc = 'Semester One'
                           Semresult = 'P' "Semresult_Desc = 'Pass'
                           %control = VALUE #( "Id = if_abap_behv=>mk-on
                                               Course = if_abap_behv=>mk-on
                                               Semester = if_abap_behv=>mk-on
                                               Semresult = if_abap_behv=>mk-on )
                                                  ) ).

    lt_academics = VALUE #( ( %cid_ref = 'StudentHeader' %target = lt_target  ) )  .


    MODIFY ENTITIES OF zi_student_root
    ENTITY Student
    CREATE FROM lt_student
    CREATE BY \_academicres FROM lt_academics
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    IF lt_failed IS INITIAL.
      COMMIT ENTITIES.
      out->write(
        EXPORTING
          data   = 'Record Created'
*            name   = 'Record Created'
*          RECEIVING
*            output =
      ).
    ELSE.
    ENDIF.
   WHEN 'RE'.
*=> Read Entity (single entity)
    READ ENTITY  zi_student_root
    FROM VALUE #( ( %tky-Id = 'AA20822246AE1EEEA3BA43B289557F82'
                    %control = VALUE #( Firstname = if_abap_behv=>mk-on
                                        Lastname = if_abap_behv=>mk-on
                                        Course = if_abap_behv=>mk-on
                                        Courseduration = if_abap_behv=>mk-on
                                        ) ) )
      RESULT data(lt_result)
      FAILED DATA(it_failed)
      REPORTED data(it_reported).
          IF lt_failed IS INITIAL.
      out->write(
        EXPORTING
          data   = lt_result
            name   = 'Record Read'
*          RECEIVING
*            output =
      ).
    ELSE.
    ENDIF.
*=> Read Entities( Multiple ) header and items associated
   WHEN 'RES'.
    READ ENTITIES OF zi_student_root
    ENTITY Student
    ALL FIELDS WITH VALUE #( ( %tky-Id = 'AA20822246AE1EEEA3BA43B289557F82' ) )
    RESULT data(tt_result1)

    ENTITY Student
    BY \_academicres
    ALL FIELDS WITH VALUE #( ( %tky-Id = 'AA20822246AE1EEEA3BA43B289557F82' ) )
    RESULT data(tt_result2)

    FAILED data(tt_failed)
    REPORTED data(tt_reported).

  READ ENTITIES OF zi_student_root
  ENTITY Student by \_academicres
  ALL FIELDS WITH VALUE #( ( %tky-Id = '92E713C27CC41EDEAAC0AA092F2E98F4' ) )
  RESULT data(res)
  LINK DATA(link).

    IF lt_failed IS INITIAL.
      out->write(
        EXPORTING
          data   = tt_result1
*          name   =
*        RECEIVING
*          output =
      ).
      out->write(
        EXPORTING
          data   = tt_result2
            name   = 'Record Read'
*          RECEIVING
*            output =
      ).
       out->write(
        EXPORTING
          data   = res
          name   = 'Only Academics'
*        RECEIVING
*          output =
      ).

    ELSE.
    ENDIF.
   ENDCASE.
  ENDMETHOD.

ENDCLASS.
