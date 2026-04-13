@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Attendance Entry View'
define view entity ZI_106_ATT_ITM
  as select from zz106_att_itm
  
  
  association to parent ZI_106_ATT_HDR as _Timesheet 
    on $projection.TimesheetID = _Timesheet.TimesheetID
{
  key timesheet_id  as TimesheetID,
  key entry_date    as EntryDate,
      check_in      as CheckInTime,
      check_out     as CheckOutTime,
      work_location as WorkLocation,
      hours_worked  as HoursWorked,
      
      /* Expose the parent connection (No comma here!) */
      _Timesheet
}
