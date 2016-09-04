{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppActivityLauncherDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, activitylauncher, Laz_And_Controls, And_jni,
  intentmanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jActivityLauncher1: jActivityLauncher;
    jButton1: jButton;
    jButton2: jButton;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
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
   jIntentManager1.SetClass('com.example.appactivitylauncherdemo1.MyActivity1');
   jIntentManager1.PutExtraInt('DATA_NUMBER', 111);
   jActivityLauncher1.StartActivityForResult(jIntentManager1.GetIntent(), 1);
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jActivityLauncher1.StartActivityForResult('com.example.appactivitylauncherdemo1', 'MyActivity2', 2);
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin

  if resultCode = RESULT_OK then
  begin
     if requestCode = 1 then  // MyActivity1
     begin
        ShowMessage('Double Number: '  + IntToStr(jIntentManager1.GetExtraInt(intentData, 'DOUBLE_DATA_NUMBER') ));
        ShowMessage('Message: '+ jIntentManager1.GetExtraString(intentData, 'DATA_MESSAGE'));
     end;

     if  requestCode = 2 then  //MyActivity2
     begin
        ShowMessage('Item Caption: '+ jIntentManager1.GetExtraString(intentData, 'CAPTION'));
        ShowMessage('Item Index: '  + IntToStr(jIntentManager1.GetExtraInt(intentData, 'INDEX') ));
     end;

  end;

  if   resultCode = RESULT_CANCELED then
  begin
     ShowMessage('RESULT_CANCELED');
  end;

end;

end.
