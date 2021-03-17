{hint: Pascal files location: ...\AppJNIException\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    lbInfo: jTextView;
    procedure AndroidModule1Show(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jni_proc( fjenv, fjthis, 'TestE');

  if exceptionCount > 0 then
  begin
   lbInfo.Text:= intToStr(exceptionCount) + ' Exceptions' + #13#10 + exceptionInfo;

   showmessage('See in ADB Logcat for more details!');
  end;
end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  if exceptionCount > 0 then
   lbInfo.Text:= exceptionInfo
  else
   lbInfo.Text:= 'Not found exceptions';
end;

end.
