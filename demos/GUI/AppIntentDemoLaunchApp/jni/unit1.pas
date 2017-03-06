{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppIntentDemoLaunchApp\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jButton5: jButton;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);
    procedure jButton5Click(Sender: TObject);
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


procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
   if jIntentManager1.IsPackageInstalled('com.google.android.camera') then
   begin
     jIntentManager1.IntentAction:= iaMain;   //android.intent.action.MAIN
     jIntentManager1.SetPackage('com.google.android.camera');
     jIntentManager1.StartActivity();
   end
   else
   begin

     ShowMessage('Try downloading Google Camera App ...');

     if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);

     jIntentManager1.TryDownloadPackage('com.google.android.camera');

     (*    //OR
     jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
     jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.google.android.camera'));
     jIntentManager1.StartActivity();
     *)

   end;
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
   if jIntentManager1.IsPackageInstalled('com.google.android.calculator') then
   begin
     jIntentManager1.IntentAction:= iaMain;
     jIntentManager1.SetPackage('com.google.android.calculator');
     jIntentManager1.StartActivity();
   end
   else
   begin
     ShowMessage('Try downloading Google Calculator App ...');

     if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);

     jIntentManager1.TryDownloadPackage('com.google.android.calculator');

     (*    //OR
     jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
     jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.google.android.calculator'));
     jIntentManager1.StartActivity();
     *)

   end;
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin

   if jIntentManager1.IsPackageInstalled('com.android.chrome') then
   begin
     jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
     jIntentManager1.SetPackage('com.android.chrome');
     jIntentManager1.SetDataUriAsString('http://www.lazarus-ide.org');
     jIntentManager1.StartActivity();
   end
   else
   begin
     ShowMessage('Try downloading Google Chrome App ...');

     if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);

     jIntentManager1.TryDownloadPackage('com.android.chrome');

     (*    //OR
     jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
     jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.android.chrome'));
     jIntentManager1.StartActivity();
     *)
   end;
end;

//.setClassName("com.google.android.youtube", "com.google.android.youtube.WatchActivity");
procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if jIntentManager1.IsPackageInstalled('com.google.android.youtube') then
  begin
    jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
    jIntentManager1.SetPackage('com.google.android.youtube');
    jIntentManager1.SetDataUriAsString('http://www.youtube.com/watch?v=8ADwPLSFeY8');
    jIntentManager1.StartActivity();
  end
  else
  begin
    ShowMessage('Try downloading Google YouTube App ...');
    if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);

    jIntentManager1.TryDownloadPackage('com.google.android.youtube');

    (*   //OR
    jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
    jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.google.android.youtube'));
    jIntentManager1.StartActivity();
    *)

  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if jIntentManager1.IsPackageInstalled('com.google.android.deskclock') then
   begin
     jIntentManager1.IntentAction:= iaMain;
     jIntentManager1.SetPackage('com.google.android.deskclock');
     jIntentManager1.StartActivity();
   end
   else
   begin
     ShowMessage('Try downloading Google DeskClock App ...');

     if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);

     jIntentManager1.TryDownloadPackage('com.google.android.deskclock');

     (*  //OR
     jIntentManager1.SetAction(iaView);  //or 'android.intent.action.VIEW'
     jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.google.android.deskclock'));
     jIntentManager1.StartActivity();
     *)
   end;
end;

end.
