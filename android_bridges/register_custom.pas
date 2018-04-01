unit register_custom;
  
{$mode objfpc}{$H+}
  
interface
  
//please, do not change this code format/layout!

uses
  Classes,
  captionpanel,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin                 
  {$I jcaptionpanel_icon.lrs}
  RegisterComponents('Android Bridges Custom',
    [
      jCaptionPanel
    ]
  );
end;
  
end.
