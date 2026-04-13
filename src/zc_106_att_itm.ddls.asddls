@EndUserText.label: 'Projection View for Daily Attendance'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: { headerInfo: { typeName: 'Daily Entry', typeNamePlural: 'Daily Entries' } }
define view entity ZC_106_ATT_ITM
  as projection on ZI_106_ATT_ITM
{
      @UI.facet: [ { id: 'Entry', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Attendance Details', position: 10 } ]
      
      @UI.identification: [ { position: 10 } ]
      @EndUserText.label: 'Timesheet ID'
  key TimesheetID,

      @UI.lineItem: [ { position: 10 } ]
      @UI.identification: [ { position: 20 } ]
      @EndUserText.label: 'Date'
  key EntryDate,

      @UI.lineItem: [ { position: 20 } ]
      @UI.identification: [ { position: 30 } ]
      @EndUserText.label: 'Check-In Time'
      CheckInTime,

      @UI.lineItem: [ { position: 30 } ]
      @UI.identification: [ { position: 40 } ]
      @EndUserText.label: 'Check-Out Time'
      CheckOutTime,

      @UI.lineItem: [ { position: 40 } ]
      @UI.identification: [ { position: 50 } ]
      @EndUserText.label: 'Location (Office/Remote)'
      WorkLocation,

      @UI.lineItem: [ { position: 50 } ]
      @UI.identification: [ { position: 60 } ]
      @EndUserText.label: 'Total Hours'
      HoursWorked,

      /* Redirect back up to the parent */
      _Timesheet : redirected to parent ZC_106_ATT_HDR
}
