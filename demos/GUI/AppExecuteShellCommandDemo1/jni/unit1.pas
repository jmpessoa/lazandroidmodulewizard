{Hint: save all files to location: C:\adt32\eclipse\workspace\AppExecuteShellCommandDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, shellcommand;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jShellCommand1: jShellCommand;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jShellCommand1Executed(Sender: TObject; cmdResult: string);

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
   jEditText2.Clear;
   if  jEditText1.Text <> '' then
       jShellCommand1.ExecuteAsync(jEditText1.Text);
end;

procedure TAndroidModule1.jShellCommand1Executed(Sender: TObject; cmdResult: string);
begin
   jEditText2.Append(cmdResult)
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jEditText1.SetFocus;
   //jEditText1.Clear;
   //jEditText1.Text:= '/system/bin/ping -c 1 -w 1 8.8.8.8';     //need: self.SetWifiEnabled(True);
end;

end.
