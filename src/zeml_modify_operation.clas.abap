CLASS zeml_modify_operation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zeml_modify_operation IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_student TYPE TABLE FOR CREATE zi_student_root.
    data: ls_date type sy-datum value '19990320'.
    lt_student = VALUE #( ( Firstname = 'Zayn' Lastname = 'Malik'
                             Dob = ls_date
                             Course = 'Engineering' Courseduration = '4' Status = ' '
                            %control = VALUE #(
                             Firstname = if_abap_behv=>mk-on
                             Lastname = if_abap_behv=>mk-on
                             Dob = if_abap_behv=>mk-on
                             course = if_abap_behv=>mk-on
                             Courseduration = if_abap_behv=>mk-on
                             Status = if_abap_behv=>mk-on
                              ) ) ).

    MODIFY ENTITIES OF zi_student_root
    ENTITY Student
    CREATE FROM lt_student
    MAPPED DATA(it_mapped)
    FAILED DATA(it_failed)
    REPORTED DATA(it_reported).

    IF it_failed IS NOT INITIAL.
      out->write(
        EXPORTING
          data   = it_failed
          name   = 'Failed'
*         RECEIVING
*           output =
      ).
    ELSE.
      COMMIT ENTITIES.
      SELECT FROM zrap_student
      FIELDS Firstname,
             Lastname,Dob,age,course,courseduration,status
      ORDER BY id
      INTO TABLE @DATA(lt_data).
      IF syst-subrc = 0.
        out->write(
        EXPORTING
           data   = lt_data
           name   = 'Result'
*         RECEIVING
*           output =
       ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
