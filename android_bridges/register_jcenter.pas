unit register_jcenter;
  
{$mode objfpc}{$H+}
  
interface
  
uses
  Classes,
  cqrgen,
  cbluetoothspp,
  cmail,
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
  {$I jcqrgen_icon.lrs}
  {$I jcbluetoothspp_icon.lrs}
  {$I jcmail_icon.lrs}
  {$I jcsignaturepad_icon.lrs}
  {$I jcopenmapview_icon.lrs}
  {$I jclantern_icon.lrs}
  {$I jcscreenshot_icon.lrs}
  {$I jcmikrotikrouteros_icon.lrs}
  RegisterComponents('Android Bridges jCenter',
    [
      jcQRGen,
      jcBluetoothSPP,
      jcMail,
      jcSignaturePad,
      jcOpenMapView,
      jcLantern,
      jcScreenShot,
      jcMikrotikRouterOS
    ]
  );
end;
  
end.
