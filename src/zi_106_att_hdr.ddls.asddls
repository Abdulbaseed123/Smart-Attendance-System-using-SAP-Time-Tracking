@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Timesheet Header Root View'
define root view entity ZI_106_ATT_HDR
  as select from zz106_att_hdr
  
  
  composition [0..*] of ZI_106_ATT_ITM as _Entries 
{
  key timesheet_id as TimesheetID,
      emp_id       as EmployeeID,
      emp_name     as EmployeeName,
      month_year   as MonthYear,
      status       as Status,
      
      /* Expose the child connection (No comma here!) */
      _Entries
}
