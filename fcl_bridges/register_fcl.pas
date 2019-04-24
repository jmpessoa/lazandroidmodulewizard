unit register_fcl;
  
{$mode objfpc}{$H+}
  
interface
  
uses
  Classes,
  SysUtils,
  LResources,
  //oracleconnectionbridge,
  mysql57connectionbridge;
  
Procedure Register;
  
implementation
  
Procedure Register;
begin
  {$I tmysql57connectionbridge_icon.lrs}
  //{$I toracleconnectionbridge_icon.lrs}
  RegisterComponents('FCL Bridges',[TMySQL57ConnectionBridge{, TOracleConnectionBridge}]);
end;
  
end.
