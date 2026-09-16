CLASS zcl_employee_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
*    SAP ko pata chalta hai ki yeh class data provider hai.

ENDCLASS.

CLASS zcl_employee_query IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    "--------------------------------------------------------
    " 1) FILTER  ->  Range variables (DB pe apply karne ke liye)
    "--------------------------------------------------------
    DATA: lr_empid      TYPE RANGE OF zemployee001-employee_id,
          lr_department TYPE RANGE OF zemployee001-department,
          lr_location   TYPE RANGE OF zemployee001-location,
          lr_status     TYPE RANGE OF zemployee001-status,
          lr_joining    TYPE RANGE OF zemployee001-joining_date.

    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).

        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'EMPLOYEEID'.
              lr_empid = CORRESPONDING #( ls_filter-range ).
            WHEN 'DEPARTMENT'.
              lr_department = CORRESPONDING #( ls_filter-range ).
            WHEN 'LOCATION'.
              lr_location = CORRESPONDING #( ls_filter-range ).
            WHEN 'STATUS'.
              lr_status = CORRESPONDING #( ls_filter-range ).
            WHEN 'JOININGDATE'.
              lr_joining = CORRESPONDING #( ls_filter-range ).
          ENDCASE.
        ENDLOOP.

      CATCH cx_rap_query_filter_no_range.
        " ignore
    ENDTRY.

    "--------------------------------------------------------
    " 2) SORT  ->  Dynamic ORDER BY string
    "--------------------------------------------------------
    DATA lv_order TYPE string.
    DATA(lt_sort) = io_request->get_sort_elements( ).

    LOOP AT lt_sort INTO DATA(ls_sort).
      DATA(lv_field) = to_upper( ls_sort-element_name ).
      CASE lv_field.
        WHEN 'EMPLOYEEID'.  lv_field = 'EMPLOYEE_ID'.
        WHEN 'FIRSTNAME'.   lv_field = 'FIRST_NAME'.
        WHEN 'LASTNAME'.    lv_field = 'LAST_NAME'.
        WHEN 'DEPARTMENT'.  lv_field = 'DEPARTMENT'.
        WHEN 'JOBTITLE'.    lv_field = 'JOB_TITLE'.
        WHEN 'LOCATION'.    lv_field = 'LOCATION'.
        WHEN 'EMAIL'.       lv_field = 'EMAIL'.
        WHEN 'JOININGDATE'. lv_field = 'JOINING_DATE'.
        WHEN 'STATUS'.      lv_field = 'STATUS'.
      ENDCASE.

      DATA(lv_dir) = COND string( WHEN ls_sort-descending = abap_true
                                  THEN 'DESCENDING' ELSE 'ASCENDING' ).

      IF lv_order IS INITIAL.
        lv_order = |{ lv_field } { lv_dir }|.
      ELSE.
        lv_order = |{ lv_order }, { lv_field } { lv_dir }|.
      ENDIF.
    ENDLOOP.

    IF lv_order IS INITIAL.
      lv_order = 'EMPLOYEE_ID ASCENDING'.
    ENDIF.

    "--------------------------------------------------------
    " 3) PAGING  ->  $top / $skip
    "--------------------------------------------------------
    DATA(lv_offset) = 0.
    DATA(lv_top)    = 0.

    DATA(lo_paging) = io_request->get_paging( ).
    IF lo_paging IS BOUND.
      lv_offset = lo_paging->get_offset( ).
      lv_top    = lo_paging->get_page_size( ).
    ENDIF.

    IF lv_top = 0 OR lv_top = if_rap_query_paging=>page_size_unlimited.
      lv_top = 1000000.   " practically all
    ENDIF.

    "--------------------------------------------------------
    " 4) SELECT  ->  DB pe filter + sort + paging
    "--------------------------------------------------------
    DATA lt_result TYPE STANDARD TABLE OF zemployee001.

    SELECT *
      FROM zemployee001
      WHERE employee_id IN @lr_empid
        AND department  IN @lr_department
        AND location    IN @lr_location
        AND status      IN @lr_status
        AND joining_date IN @lr_joining
      ORDER BY (lv_order)
      INTO TABLE @lt_result
      OFFSET @lv_offset
      UP TO @lv_top ROWS.

    "--------------------------------------------------------
    " 5) TOTAL COUNT  ->  same filter ke saath
    "--------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested( ).
      SELECT COUNT( * )
        FROM zemployee001
        WHERE employee_id IN @lr_empid
          AND department  IN @lr_department
          AND location    IN @lr_location
          AND status      IN @lr_status
          AND joining_date IN @lr_joining
        INTO @DATA(lv_count).
      io_response->set_total_number_of_records( lv_count ).
    ENDIF.

    "--------------------------------------------------------
    " 6) MAP  ->  Custom Entity fields
    "--------------------------------------------------------
    TYPES: BEGIN OF ty_final,
             EmployeeId  TYPE zemployee001-employee_id,
             FirstName   TYPE zemployee001-first_name,
             LastName    TYPE zemployee001-last_name,
             Department  TYPE zemployee001-department,
             JobTitle    TYPE zemployee001-job_title,
             Location    TYPE zemployee001-location,
             Email       TYPE zemployee001-email,
             JoiningDate TYPE zemployee001-joining_date,
             Status      TYPE zemployee001-status,
           END OF ty_final.

    DATA lt_final TYPE STANDARD TABLE OF ty_final WITH DEFAULT KEY.

    lt_final = VALUE #( FOR ls IN lt_result (
        EmployeeId  = ls-employee_id
        FirstName   = ls-first_name
        LastName    = ls-last_name
        Department  = ls-department
        JobTitle    = ls-job_title
        Location    = ls-location
        Email       = ls-email
        JoiningDate = ls-joining_date
        Status      = ls-status
    ) ).

    io_response->set_data( lt_final ).

  ENDMETHOD.

ENDCLASS.
