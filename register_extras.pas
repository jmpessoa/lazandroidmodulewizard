unit register_extras;
  
{$mode objfpc}{$H+}
  
interface
  

//please, do not change this code format/layout!

uses 
  Classes,
  myhello,
  textfilemanager,
  dumpjavamethods,
  mediaplayer,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin
  {$I jmyhello_icon.lrs}
  {$I jtextfilemanager_icon.lrs}
  {$I jdumpjavamethods_icon.lrs}
  {$I jmediaplayer_icon.lrs}
  RegisterComponents('Android Bridges Extra',
    [
      jMyHello,
      jTextFileManager,
      jDumpJavaMethods,
      jMediaPlayer
    ]
  );
end;
  
end.
