@EndUserText.label: 'Employee Management'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_EMPLOYEE_QUERY'

@UI.headerInfo: {
  typeName: 'Employee',
  typeNamePlural: 'Employees',
  title: { type: #STANDARD, value: 'EmployeeId' }
}
@UI.presentationVariant: [{
  sortOrder: [ { by: 'EmployeeId', direction: #ASC } ],
  visualizations: [ { type: #AS_LINEITEM } ]
}]




define custom entity ZCE_EMPLOYEE
{
      @UI.lineItem: [{ value   : 'EmployeeId',  label: 'Employee ID',  position: 10 }]
  key EmployeeId  : abap.char(10);
      @UI.lineItem: [{ value   : 'FirstName',  label: 'FirstName',  position: 20 }]
      FirstName   : abap.char(30);
      @UI.lineItem: [{ value   : 'LastName',  label: 'LastName',  position: 30 }]
      LastName    : abap.char(30);
      @UI.lineItem: [{ value   : 'Department',  label: 'Department',  position: 40 }]
      Department  : abap.char(30);
      @UI.lineItem: [{ value   : 'JobTitle',  label: 'JobTitle',  position: 50 }]
      JobTitle    : abap.char(40);
      @UI.lineItem: [{ value   : 'Location',  label: 'Location',  position: 60 }]
      Location    : abap.char(30);
      @UI.lineItem: [{ value   : 'Email',  label: 'Email',  position: 70 }]
      Email       : abap.char(60);
      @UI.lineItem: [{ value   : 'JoiningDate',  label: 'JoiningDate',  position: 80 }]
      JoiningDate : abap.dats;
      @UI.lineItem: [{ value   : 'Status',  label: 'Status',  position: 90 }]
      Status      : abap.char(1);
}
