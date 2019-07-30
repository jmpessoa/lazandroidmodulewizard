unit register_jcenter;
  
{$mode objfpc}{$H+}
  
interface
  
uses
  Classes,
  csignaturepad,
  copenmapview,
  clantern,
  cscreenshot,
  cmikrotikrouteros,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation
  
Procedure Register;
begin
  {$I jcsignaturepad_icon.lrs}
  {$I jcopenmapview_icon.lrs}
  {$I jclantern_icon.lrs}
  {$I jcscreenshot_icon.lrs}
  {$I jcmikrotikrouteros_icon.lrs}
  RegisterComponents('Android Bridges jCenter',
    [
      jcSignaturePad,
      jcOpenMapView,
      jcLantern,
      jcScreenShot,
      jcMikrotikRouterOS
    ]
  );
end;
  
end.
