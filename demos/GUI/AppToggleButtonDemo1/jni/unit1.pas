{Hint: save all files to location: C:\adt32\eclipse\workspace\AppToggleButtonDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, togglebutton;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jTextView1: jTextView;
      jToggleButton1: jToggleButton;
      jToggleButton2: jToggleButton;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jToggleButton1Toggle(Sender: TObject; state: boolean);
      procedure jToggleButton2Toggle(Sender: TObject; state: boolean);
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

procedure TAndroidModule1.jToggleButton1Toggle(Sender: TObject; state: boolean);
begin
   if state = False then
    ShowMessage('ToggleButton1 Off')
   else
     ShowMessage('ToggleButton1 On');
end;

procedure TAndroidModule1.jToggleButton2Toggle(Sender: TObject; state: boolean);
begin
   if state = False then
     jToggleButton2.SetBackgroundDrawable('bullet_white')
   else
     jToggleButton2.SetBackgroundDrawable('bullet_blue')
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if jToggleButton2.State = tsOff then
     jToggleButton2.SetBackgroundDrawable('bullet_white')
   else
     jToggleButton2.SetBackgroundDrawable('bullet_blue')
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jToggleButton1.State:= tsOn;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jToggleButton1.State:= tsOff;
end;

end.
