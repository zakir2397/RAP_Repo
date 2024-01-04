CLASS zcl_feeclass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_feeclass IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
  Data: lt_student type STANDARD TABLE OF zc_student_projection WITH DEFAULT KEY.
        lt_student = CORRESPONDING #(  it_original_data   ).

        loop at lt_student ASSIGNING FIELD-SYMBOL(<ls_stf>).
        if ( <ls_stf>-Course = 'Arts and Science' ).
                <ls_stf>-Fees = '25000'.
         elseif
               ( <ls_stf>-Course = 'Engineering' ) .
               <ls_stf>-Fees = '150000'.
               endif.
        ENDLOOP.

 ct_calculated_data  = CORRESPONDING #( lt_student ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
