{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppVideoViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, videoview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jCheckBox1: jCheckBox;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jVideoView1: jVideoView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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
  //jVideoView1.SetProgressDialog(...);
  jVideoView1.PlayFromRawResource('bigbunny');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if not Self.isConnected() then
  begin //try wifi
    if Self.SetWifiEnabled(True) then
      jCheckBox1.Checked:= True
    else
      ShowMessage('Please,  try enable some connection...');
    end
  else
  begin
    if Self.isConnectedWifi() then jCheckBox1.Checked:= True
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if Self.isConnected() then
  begin
     //jVideoView1.SetProgressDialog(...);
     jVideoView1.PlayFromURL('http://bffmedia.com/bigbunny.mp4');
  end
  else
  begin
    ShowMessage('Please,  try enable some connection...');
  end;
end;

end.
