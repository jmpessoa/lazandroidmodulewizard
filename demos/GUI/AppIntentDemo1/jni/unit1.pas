{Hint: save all files to location: C:\adt32\eclipse\workspace\AppIntentDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events,
  AndroidWidget, intentmanager, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jImageFileManager1: jImageFileManager;
      jImageView1: jImageView;
      jIntentManager1: jIntentManager;
      jTextView1: jTextView;
      procedure AndroidModule1ActivityResult(Sender: TObject;
        requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
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
  //ref http://developer.android.com/reference/android/content/Intent.html
  //android.intent.action.VIEW
  //android.intent.action.PICK
  //android.intent.action.SENDTO
  //android.intent.action.EDIT
  //android.intent.action.DIAL
  //android.intent.action.CALL_BUTTON

  jIntentManager1.SetAction('android.intent.action.PICK');
  //or jIntentManager1.IntentAction:= iaPick;

  jIntentManager1.SetMimeType('image/*');            //or 'image/png' etc..  mime here must be lowercase!
  jIntentManager1.StartActivityForResult(1001);      //user-defined requestCode=1001
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
  jUri: jObject;
begin
  if  requestCode =  1001 then  //user-defined requestCode=1001
  begin
    if resultCode = RESULT_OK then  //ok
    begin
      jUri:= jIntentManager1.GetDataUri(intentData);
      jImageView1.SetImageBitmap(jImageFileManager1.LoadFromUri(jUri));
      //curiosity: You can try this ....
      //jImageView1.SetImageBitmap(jImageFileManager1.AnticlockWise(jImageFileManager1.LoadFromUri(jUri),jImageView1.jSelf));
    end else ShowMessage('Fail/cancel to pick a image ....');
  end;
end;

end.
