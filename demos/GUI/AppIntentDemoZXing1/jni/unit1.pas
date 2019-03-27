{Hint: save all files to location: C:\adt32\eclipse\workspace\AppIntentDemoZXing1\jni }
unit unit1;

{$mode delphi}

interface

uses
    Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
    Laz_And_Controls_Events, AndroidWidget, intentmanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jCheckBox1: jCheckBox;
    jCheckBox2: jCheckBox;
    jIntentManager1: jIntentManager;
    jListView1: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
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

//ref. http://androidcookbook.com/Recipe.seam?recipeId=3324

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  if IsRuntimePermissionGranted('android.permission.CAMERA') then
  begin
     if jIntentManager1.IsCallable('com.google.zxing.client.android.SCAN') then
     begin

         //ShowMessage('ZXing App is Installed!! ');

         jIntentManager1.SetAction('com.google.zxing.client.android.SCAN');
         case itemIndex of
            0: jIntentManager1.PutExtraString('SCAN_MODE', 'PRODUCT_MODE');   //Prod
            1: jIntentManager1.PutExtraString('SCAN_MODE', 'QR_CODE_MODE');   //QR
            2: jIntentManager1.PutExtraString('SCAN_FORMATS', 'CODE_39,CODE_93,CODE_128,DATA_MATRIX,ITF'); //others
         end;

         //ZXing Barcode Scanner to scan for us
         jIntentManager1.StartActivityForResult(0);      //user-defined requestCode= 0

     end
     else  //download ZXing App
     begin
        if Self.IsWifiEnabled() then
        begin
          ShowMessage('Wait... try downloading ZXing App fro Google Play Store ...');
          jIntentManager1.SetAction(jIntentManager1.GetActionViewAsString());
          //or jIntentManager1.SetAction('android.intent.action.VIEW');

          jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.google.zxing.client.android'));
          jIntentManager1.StartActivity();
        end
        else ShowMessage('Please, enable wifi and try again....');
     end;
  end
  else ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if  requestCode =  0 then  //user-defined requestCode= 0
  begin
    if resultCode = RESULT_OK then  //ok
    begin
        ShowMessage('FORMAT: '+jIntentManager1.GetExtraString(intentData, 'SCAN_RESULT_FORMAT'));
        ShowMessage('CONTENT: '+jIntentManager1.GetExtraString(intentData, 'SCAN_RESULT'));
    end else ShowMessage('Fail/cancel to scan....');
  end;
end;

//https://developer.android.com/guide/topics/security/permissions#normal-dangerous
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   Self.SetWifiEnabled(True);  //try internet connection... need to get ZXing App from Google Play Stores)

   if Self.IsWifiEnabled() then
   begin
      jCheckBox2.Checked:= True;
   end;

   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('Requesting Runtime Permission....');
     Self.RequestRuntimePermission('android.permission.CAMERA', 1111);   //handled by OnRequestPermissionResult
   end
   else
   begin
     jCheckBox1.Checked:= True;
   end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of
    1111:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
              if manifestPermission = 'android.permission.CAMERA' then jCheckBox1.Checked:= True;
           end
          else//PERMISSION_DENIED
          begin
              jCheckBox1.Checked:= False;
              ShowMessage('Sorry... "android.permission.CAMERA" permission not granted... ' );
          end;
       end;
  end;
end;

end.
