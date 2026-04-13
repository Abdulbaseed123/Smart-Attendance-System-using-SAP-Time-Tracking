" 1. THE TRANSACTIONAL BUFFER
CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: mt_hdr_create TYPE STANDARD TABLE OF zz106_att_hdr,
                mt_hdr_delete TYPE STANDARD TABLE OF zz106_att_hdr-timesheet_id,
                mt_itm_create TYPE STANDARD TABLE OF zz106_att_itm,
                mt_itm_delete TYPE STANDARD TABLE OF zz106_att_itm.
ENDCLASS.

" 2. THE HEADER HANDLER
CLASS lhc_TimesheetHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR TimesheetHeader RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE TimesheetHeader.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE TimesheetHeader.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE TimesheetHeader.
    METHODS read FOR READ
      IMPORTING keys FOR READ TimesheetHeader RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK TimesheetHeader.

    " Create By Association: This links the daily attendance entries!
    METHODS cba_Entries FOR MODIFY
      IMPORTING entities_cba FOR CREATE TimesheetHeader\_Entries.
ENDCLASS.

CLASS lhc_TimesheetHeader IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    LOOP AT entities INTO DATA(ls_entity).
      APPEND VALUE #(
        timesheet_id = ls_entity-TimesheetID
        emp_id       = ls_entity-EmployeeID
        emp_name     = ls_entity-EmployeeName
        month_year   = ls_entity-MonthYear
        status       = ls_entity-Status
      ) TO lcl_buffer=>mt_hdr_create.

      INSERT VALUE #( %cid = ls_entity-%cid  TimesheetID = ls_entity-TimesheetID ) INTO TABLE mapped-timesheetheader.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Entries.
    LOOP AT entities_cba INTO DATA(ls_cba).
      LOOP AT ls_cba-%target INTO DATA(ls_target).
        APPEND VALUE #(
          timesheet_id  = ls_cba-TimesheetID  " The Parent ID!
          entry_date    = ls_target-EntryDate
          check_in      = ls_target-CheckInTime
          check_out     = ls_target-CheckOutTime
          work_location = ls_target-WorkLocation
          hours_worked  = ls_target-HoursWorked
        ) TO lcl_buffer=>mt_itm_create.

        INSERT VALUE #( %cid = ls_target-%cid TimesheetID = ls_cba-TimesheetID EntryDate = ls_target-EntryDate ) INTO TABLE mapped-attendanceentry.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      APPEND ls_key-TimesheetID TO lcl_buffer=>mt_hdr_delete.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.
ENDCLASS.

" 3. THE ITEM HANDLER
CLASS lhc_AttendanceEntry DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE AttendanceEntry.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE AttendanceEntry.
    METHODS read FOR READ
      IMPORTING keys FOR READ AttendanceEntry RESULT result.
ENDCLASS.

CLASS lhc_AttendanceEntry IMPLEMENTATION.
  METHOD update.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( timesheet_id = ls_key-TimesheetID entry_date = ls_key-EntryDate ) TO lcl_buffer=>mt_itm_delete.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.
ENDCLASS.

" 4. THE SAVER CLASS (Executes SQL Statements)
CLASS lsc_ZI_106_ATT_HDR DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
ENDCLASS.

CLASS lsc_ZI_106_ATT_HDR IMPLEMENTATION.
  METHOD save.
    IF lcl_buffer=>mt_hdr_create IS NOT INITIAL.
      INSERT zz106_att_hdr FROM TABLE @lcl_buffer=>mt_hdr_create.
    ENDIF.

    IF lcl_buffer=>mt_itm_create IS NOT INITIAL.
      INSERT zz106_att_itm FROM TABLE @lcl_buffer=>mt_itm_create.
    ENDIF.

    IF lcl_buffer=>mt_itm_delete IS NOT INITIAL.
      LOOP AT lcl_buffer=>mt_itm_delete INTO DATA(ls_del_itm).
        DELETE FROM zz106_att_itm WHERE timesheet_id = @ls_del_itm-timesheet_id AND entry_date = @ls_del_itm-entry_date.
      ENDLOOP.
    ENDIF.

    IF lcl_buffer=>mt_hdr_delete IS NOT INITIAL.
      LOOP AT lcl_buffer=>mt_hdr_delete INTO DATA(lv_del_hdr).
        DELETE FROM zz106_att_hdr WHERE timesheet_id = @lv_del_hdr.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    CLEAR: lcl_buffer=>mt_hdr_create, lcl_buffer=>mt_hdr_delete,
           lcl_buffer=>mt_itm_create, lcl_buffer=>mt_itm_delete.
  ENDMETHOD.
ENDCLASS.
