{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSwitchButtonDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, switchbutton;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jSwitchButton1: jSwitchButton;
      jSwitchButton2: jSwitchButton;
      jTextView1: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jSwitchButton1Toggle(Sender: TObject; state: boolean);
      procedure jSwitchButton2Toggle(Sender: TObject; state: boolean);
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

procedure TAndroidModule1.jSwitchButton1Toggle(Sender: TObject; state: boolean);
begin
  if state = True then
    ShowMessage('Switch On')
  else
    ShowMessage('Switch Off');
end;

procedure TAndroidModule1.jSwitchButton2Toggle(Sender: TObject; state: boolean);
begin
  if  state = True then
    jSwitchButton2.SetThumbIcon('bullet_blue')
  else
    jSwitchButton2.SetThumbIcon('bullet_white');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if  jSwitchButton2.State = tsOn then
    jSwitchButton2.SetThumbIcon('bullet_blue')
  else
    jSwitchButton2.SetThumbIcon('bullet_white');

end;

end.
