@EndUserText.label: 'Projection View for Timesheet Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: { headerInfo: { typeName: 'Timesheet', typeNamePlural: 'Timesheets' } }
@Search.searchable: true
define root view entity ZC_106_ATT_HDR
  provider contract transactional_query
  as projection on ZI_106_ATT_HDR
{
      @UI.facet: [ 
        { id: 'Header',  purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Employee Details', position: 10 },
        { id: 'Entries', purpose: #STANDARD, type: #LINEITEM_REFERENCE,       label: 'Daily Attendance', position: 20, targetElement: '_Entries' } 
      ]
      
      @UI.lineItem: [ { position: 10 } ]
      @UI.identification: [ { position: 10 } ]
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Timesheet ID (e.g. TS-001)'
  key TimesheetID,

      @UI.lineItem: [ { position: 20 } ]
      @UI.identification: [ { position: 20 } ]
      @EndUserText.label: 'Employee ID'
      EmployeeID,

      @UI.lineItem: [ { position: 30 } ]
      @UI.identification: [ { position: 30 } ]
      @EndUserText.label: 'Employee Name'
      EmployeeName,

      @UI.lineItem: [ { position: 40 } ]
      @UI.identification: [ { position: 40 } ]
      @EndUserText.label: 'Month & Year (MM-YYYY)'
      MonthYear,

      @UI.lineItem: [ { position: 50 } ]
      @UI.identification: [ { position: 50 } ]
      @EndUserText.label: 'Status (P=Pending, A=Approved)'
      Status,

      /* Redirect down to the child */
      _Entries : redirected to composition child ZC_106_ATT_ITM
}
