unit register_template;
  
{$mode objfpc}{$H+}
  
interface
  
uses
  Classes,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation
  
Procedure Register;
begin
  RegisterComponents('#TAB',
    [
    ]
  );
end;
  
end.