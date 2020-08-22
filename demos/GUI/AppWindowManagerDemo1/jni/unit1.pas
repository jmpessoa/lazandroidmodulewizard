{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppWindowManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, windowmanager,
  preferences, radiogroup{, inifiles}, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jEditText1: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPreferences1: jPreferences;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jWindowManager1: jWindowManager;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
  private
    {private declarations}
    pX, pY: integer;
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
   if jWindowManager1.CanDrawOverlays() then
   begin
     if (pX <> -1) and (pY <> -1) then
       jWindowManager1.SetViewPosition(pX, pY);

     jWindowManager1.AddView(jPanel1.View);  //at the moment just one view per jWindowManager
     jWindowManager1.SetViewRoundCorner();
     Self.Minimize();
   end
   else ShowMessage('Sorry... DrawOverlay Permission denied...')
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if requestCode =  1123 then
  begin
    (*
     if resultCode = RESULT_OK then
     begin
       ShowMessage('Success! DrawOverlays PERMISSION_GRANTED');
       if (pX <> -1) and (pY <> -1) then jWindowManager1.SetViewPosition(pX, pY);
     end
     else
     begin
       FOverlayPermission:= False;
       ShowMessage('Sorry...DrawOverlays PERMISSION_DENIED... ' );
     end;
     *)
     if jWindowManager1.CanDrawOverlays() then
     begin
       ShowMessage('Success! DrawOverlays PERMISSION_GRANTED');
       if (pX <> -1) and (pY <> -1) then jWindowManager1.SetViewPosition(pX, pY);
     end
     else
     begin
        ShowMessage('Sorry...DrawOverlays PERMISSION_DENIED... ' );
     end;

  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
//var
  //inifiles: TInifile;
begin

  pX:= jPreferences1.GetIntData('X', -1);  //  -1 = dummy
  pY:= jPreferences1.GetIntData('Y', -1);

  (*
  //USING INI File
  inifiles:= TInifile.Create(Self.GetEnvironmentDirectoryPath(dirSdCard)+ '/' + 'AppConfig.txt');
  strX:= inifiles.ReadString('CONFIG', 'X', '');
  strY:= inifiles.ReadString('CONFIG', 'Y', '');
  inifiles.Free;
  *)

  jButton1.SetRoundCorner();
  jButton1.SetCompoundDrawables('ic_wizard', cdsLeft);   //  res\drawable-hdpi

  jTextView2.SetRoundCorner();
  jTextView2.SetCompoundDrawables('ic_info', cdsLeft);    // res\drawable-hdpi
  jEditText1.SetCompoundDrawables('ic_funny', cdsRight);   // res\drawable-hdpi

  jTextView3.SetCompoundDrawables('ic_happy', cdsRight);
  jTextView3.Text:= 'LAMW: floating and draggable View!';

  if jWindowManager1.IsDrawOverlaysRuntimePermissionNeed() then   // that is, target API >= 23
  begin
     ShowMessage('Wait... Requesting Permission....');
     jWindowManager1.RequestDrawOverlayRuntimePermission(gApp.PackageName, 1123);
  end;

end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
//var
  //inifiles: TInifile;
begin

  pX:= jWindowManager1.GetViewPositionX();
  pY:= jWindowManager1.GetViewPositionY();

  jPreferences1.SetIntData('X', pX);
  jPreferences1.SetIntData('Y', pY);

  (*
  //USING INI File
  inifiles:= TInifile.Create(Self.GetEnvironmentDirectoryPath(dirSdCard)+ '/' + 'AppConfig.txt');
  inifiles.WriteString('CONFIG', 'X', IntToStr(pX));
  inifiles.WriteString('CONFIG', 'Y', IntToStr(pY));
  inifiles.Free;
  *)

end;


procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  ShowMessage(jEditText1.Text);
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jWindowManager1.RemoveView();
  Self.Restart(0);
end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  ShowMessage('Hello Image!');
end;

end.
