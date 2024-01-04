CLASS zeml_dynamic_modify DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zeml_dynamic_modify IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: ls_date TYPE sy-datum VALUE '19980320'.
    DATA:it_student_create TYPE TABLE FOR CREATE zi_student_root,
         it_student_update TYPE TABLE FOR UPDATE zi_student_root,
         it_student_delete TYPE TABLE FOR UPDATE zi_student_root,
         lt_failed         TYPE abp_behv_response_tab,
         lt_reported       TYPE abp_behv_response_tab,
         lt_mapped         TYPE abp_behv_response_tab,
*       =>OPERATION TABLE WITH SPECIFIC TYPE ABP_BEHV_CHANGES_TAB
         op_table          TYPE abp_behv_changes_tab.


    it_student_create = VALUE #( (  %cid = 'StudentHead'
                         Firstname = 'HANIF' Lastname = 'BHAI'
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

    it_student_update = VALUE #( ( %cid_ref = 'StudentHead' Status = 'X'
                                   %control = VALUE #(
                                    Status = if_abap_behv=>mk-on )  ) ).

    it_student_delete = VALUE #( ( %tky-id = '4EB4B9ED4A4F1EDEAAAAC9577F1B14E3' ) ). "sadham


    op_table = VALUE #(
    ( op = if_abap_behv=>op-m-create
      entity_name = 'ZI_STUDENT_ROOT'
      instances = REF #( it_student_create ) )
     ( op = if_abap_behv=>op-m-update
      entity_name = 'ZI_STUDENT_ROOT'
      instances = REF #( it_student_update ) )
     ( op = if_abap_behv=>op-m-delete
      entity_name = 'ZI_STUDENT_ROOT'
      instances = REF #( it_student_delete ) )
      ).

    MODIFY ENTITIES OPERATIONS op_table
    FAILED lt_failed
    REPORTED lt_reported
    MAPPED lt_mapped.

    COMMIT ENTITIES.



  ENDMETHOD.

ENDCLASS.
