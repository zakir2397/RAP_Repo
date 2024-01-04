CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Student RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.

    METHODS setAdmitted FOR MODIFY
      IMPORTING keys FOR ACTION Student~setAdmitted RESULT result.
    METHODS ValidateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR Student~ValidateAge.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_student_root1 IN LOCAL MODE
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

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setAdmitted.
    MODIFY ENTITIES OF zi_student_root1 IN LOCAL MODE
           ENTITY Student
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky Status = abap_true ) )
           FAILED failed
           REPORTED reported.

    "Read the response from Updated fields
    READ ENTITIES OF zi_student_root1 IN LOCAL MODE
        ENTITY Student
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_results).

    result = VALUE #( FOR studentrec IN lt_results
            ( %tky  = studentrec-%tky %param = studentrec ) ).
  ENDMETHOD.

  METHOD ValidateAge.
    READ ENTITIES OF zi_student_root1 IN LOCAL MODE
    ENTITY Student
    FIELDS ( Age )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP  AT lt_result INTO DATA(ls_result).
      IF ls_result-Age < 21.
        APPEND VALUE #( %tky = ls_result-%tky ) TO failed-student.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Age cannot be less than 21'
                               ) ) TO reported-student.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
