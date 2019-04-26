unit register_jcenter;
  
{$mode objfpc}{$H+}
  
interface
  
uses
  Classes,
  clantern,
  cscreenshot,
  cmikrotikrouteros,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation
  
Procedure Register;
begin
  {$I jclantern_icon.lrs}
  {$I jcscreenshot_icon.lrs}
  {$I jcmikrotikrouteros_icon.lrs}
  RegisterComponents('Android Bridges jCenter',
    [
      jcLantern,
      jcScreenShot,
      jcMikrotikRouterOS
    ]
  );
end;
  
end.
