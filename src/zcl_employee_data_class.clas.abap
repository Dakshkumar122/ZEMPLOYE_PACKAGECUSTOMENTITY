CLASS zcl_employee_data_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_employee_data_class IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Step 1: Purana test data delete karo (practice ke liye)
    DELETE FROM zemployee001.

    " Step 2: Sample data table banao
    DATA: lt_employee TYPE STANDARD TABLE OF zemployee001.

    lt_employee = VALUE #(
      ( client = sy-mandt employee_id = 'EMP000001' first_name = 'Rohit'   last_name = 'Sharma'
        department = 'IT'    job_title = 'ABAP Developer'     location = 'Kolkata'   email = 'rohit.sharma@test.com'
        joining_date = '20220110' status = 'A' )

      ( client = sy-mandt employee_id = 'EMP000002' first_name = 'Anjali'  last_name = 'Verma'
        department = 'HR'    job_title = 'HR Executive'       location = 'Delhi'     email = 'anjali.verma@test.com'
        joining_date = '20210305' status = 'A' )

      ( client = sy-mandt employee_id = 'EMP000003' first_name = 'Suresh'  last_name = 'Kumar'
        department = 'IT'    job_title = 'Basis Consultant'   location = 'Bangalore' email = 'suresh.kumar@test.com'
        joining_date = '20200712' status = 'I' )

      ( client = sy-mandt employee_id = 'EMP000004' first_name = 'Priya'   last_name = 'Singh'
        department = 'Finance' job_title = 'Financial Analyst' location = 'Mumbai'   email = 'priya.singh@test.com'
        joining_date = '20230115' status = 'A' )

      ( client = sy-mandt employee_id = 'EMP000005' first_name = 'Amit'    last_name = 'Yadav'
        department = 'IT'    job_title = 'RAP Developer'      location = 'Kolkata'   email = 'amit.yadav@test.com'
        joining_date = '20230601' status = 'A' )

      ( client = sy-mandt employee_id = 'EMP000006' first_name = 'Neha'    last_name = 'Gupta'
        department = 'Sales' job_title = 'Sales Manager'      location = 'Pune'      email = 'neha.gupta@test.com'
        joining_date = '20190822' status = 'I' )
    ).

    " Step 3: Insert karo
    INSERT zemployee001 FROM TABLE @lt_employee.

    IF sy-subrc = 0.
      COMMIT WORK.
      out->write( |{ lines( lt_employee ) } employee records inserted successfully into ZEMPLOYEE001.| ).
    ELSE.
      ROLLBACK WORK.
      out->write( 'Insert failed!' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
