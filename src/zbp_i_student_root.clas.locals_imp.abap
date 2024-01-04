CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Student RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.

    METHODS setAdmitted FOR MODIFY
      IMPORTING keys FOR ACTION Student~setAdmitted RESULT result.
    METHODS validateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR Student~validateAge.
    METHODS updateCourseDuration FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Student~updateCourseDuration.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Student.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Student RESULT result.
    METHODS is_update_allowed
            RETURNING VALUE(update_allowed) TYPE abap_boolean.
ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_student_root IN LOCAL MODE
         ENTITY Student
         FIELDS ( Status ) WITH CORRESPONDING #( keys )
         RESULT DATA(i_Result)
         FAILED failed
         REPORTED reported.

    result = VALUE #( FOR stud IN i_result
                      LET statusval = COND #( WHEN stud-Status = abap_true
                                              THEN if_abap_behv=>fc-o-disabled
                                              ELSE if_abap_behv=>fc-o-enabled )
                              IN ( %tky = stud-%tky
                                   %action-setAdmitted = statusval )
                                              ).
  ENDMETHOD.


  METHOD setAdmitted.
    MODIFY ENTITIES OF zi_student_root IN LOCAL MODE
           ENTITY Student
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky Status = abap_true ) )
           FAILED failed
           REPORTED reported.

    "Read the response from Updated fields
    READ ENTITIES OF zi_student_root IN LOCAL MODE
        ENTITY Student
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_results).

    result = VALUE #( FOR studentrec IN lt_results
            ( %tky  = studentrec-%tky %param = studentrec ) ).
  ENDMETHOD.

  METHOD validateAge.

    READ ENTITIES OF zi_student_root IN LOCAL MODE
    ENTITY Student
    FIELDS ( Age ) WITH CORRESPONDING #( keys )
    RESULT DATA(studentage).

    LOOP AT studentage INTO DATA(ls_age).
    if ls_age-Age < 21.
       APPEND VALUE #( %tky = ls_age-%tky  ) to failed-student.

       APPEND VALUE #( %tky = keys[ 1 ]-%tky
                       %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = 'Age cannot be less than 21'
                              )  )
                              TO reported-student.
       ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD updateCourseDuration.
  data: ls_age type int4.
        DATA: l_day(2)   TYPE c, " Day
      l_month1(2) TYPE c, " Month
      l_month(2)  TYPE c. " Year
  READ ENTITIES OF zi_student_root in LOCAL MODE
  ENTITY Student
  FIELDS ( Course Dob )
  with CORRESPONDING #( keys )
  RESULT data(resultdata).


  loop at resultdata into data(ls_result).
        l_month1 = ls_result-Dob+4(2).
        l_month = sy-datum+4(2).
     ls_age = sy-datum+0(4) - ls_result-Dob+0(4).
      if l_month1 < l_month.
        add 1 to ls_age.
      endif.
       modify ENTITIES OF zi_student_root in LOCAL MODE
       ENTITY STUDENT
       update FIELDS ( Age )
       with VALUE #( ( %tky = ls_result-%tky Age = ls_age ) ).
    if ls_result-Course = 'Arts and Science'.
        MODIFY ENTITIES OF zi_student_root in LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = ls_result-%tky Courseduration = 3 ) ).
    ENDIF.

    if ls_result-Course = 'Law'.
     MODIFY ENTITIES OF zi_student_root in LOCAL MODE
        ENTITY Student
        UPDATE FIELDS ( Courseduration )
        WITH VALUE #( ( %tky = ls_result-%tky Courseduration = 5 ) ).
    endif.
  endloop.
  ENDMETHOD.

  METHOD precheck_update.


  loop at entities ASSIGNING FIELD-SYMBOL(<fs_entities>).
*  01 = updated/changed , 00 = value not changed
    CHECK <fs_entities>-%control-Course eq '01' or <fs_entities>-%control-Courseduration eq '01'.

    READ ENTITIES OF zi_student_root in LOCAL MODE
        ENTITY Student
        FIELDS ( Course Courseduration ) WITH VALUE #( ( %key = <fs_entities>-%key ) )
        RESULT DATA(lt_student).

        if sy-subrc is INITIAL.
        READ TABLE lt_student ASSIGNING FIELD-SYMBOL(<lfs_db_data>) INDEX 1.
        if sy-subrc is INITIAL.
        <lfs_db_data>-Course = COND #( WHEN <fs_entities>-%control-Course eq '01' then
                                        <fs_entities>-Course ELSE <lfs_db_data>-Course ).
         <lfs_db_data>-Courseduration = COND #( WHEN <fs_entities>-%control-Courseduration eq '01'
                                         then
                                        <fs_entities>-Courseduration
                                        ELSE <lfs_db_data>-Courseduration ).
        if <lfs_db_data>-Courseduration < 4.
            if <lfs_db_data>-Course = 'Engineering'.
            APPEND VALUE #( %tky = <fs_entities>-%tky ) to failed-student.

            APPEND VALUE #( %tky = <fs_entities>-%tky
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'Invalid Course duration...'
                                   ) ) TO reported-student.

            endif.
        endif.
        endif.

        endif.
  ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
      if requested_authorizations-%update = if_abap_behv=>mk-on or
         requested_authorizations-%action-Edit = if_abap_behv=>mk-on.

         if is_update_allowed( ) = abap_true.
         result-%update = if_abap_behv=>auth-allowed.
         result-%action-Edit = if_abap_behv=>auth-allowed.


         ELSE.
         result-%update = if_abap_behv=>auth-unauthorized.
         result-%action-Edit = if_abap_behv=>auth-unauthorized.
                result-%delete = if_abap_behv=>auth-unauthorized.
         endif.
         endif.
  ENDMETHOD.

  METHOD get_instance_authorizations.

  DATA: update_request type abap_bool,
        update_granted type abap_bool.
    read ENTITIES OF zi_student_root IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT data(studentadmitted).

    check studentadmitted is not INITIAL.
    update_request = cond #( when requested_authorizations-%update = if_abap_behv=>mk-on OR
                                  requested_authorizations-%action-Edit = if_abap_behv=>mk-on
                                  then abap_true else abap_false  ).

      loop at studentadmitted ASSIGNING FIELD-SYMBOL(<fs_student>).

    if <fs_student>-Status = abap_false.
        if update_request = abap_true.
        update_granted = is_update_allowed( ).
        if update_granted = abap_false.
        APPEND VALUE #( %tky = <fs_student>-%tky ) to failed-student.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'No Authorization to Update Status!!....'
                               ) ) to reported-student.
        endif.
        endif.
    endif.
      endloop.

  ENDMETHOD.

  METHOD is_update_allowed.
     update_allowed = abap_true.
  ENDMETHOD.

ENDCLASS.
