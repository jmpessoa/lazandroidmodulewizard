{Hint: save all files to location: C:\adt32\eclipse\workspace\AppIntentDemo3\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
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
     jIntentManager1.SetAction(jIntentManager1.GetActionDialAsString());
     //or jIntentManager1.IntentAction:= idDial;

    //Please, change de fone number!
    ShowMessage('Please, Edit de fone number .... ');
    jIntentManager1.SetDataUri(jIntentManager1.GetTelUri('06099181188'));
    //or: jIntentManager1.SetDataUri(jIntentManager1.ParseUri('tel:06699186188'));
    if jIntentManager1.ResolveActivity() then
       jIntentManager1.StartActivity('Dial ...')
    else
       ShowMessage('Unable to find an App to perform this action...');
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
   jContactUri: jObject;
   strContactNumber: string;
begin
   strContactNumber:= '';
   jContactUri:= jIntentManager1.GetDataUri(intentData);
   strContactNumber:= jIntentManager1.GetContactNumber(jContactUri);
   if strContactNumber <> '' then
   begin
     //ShowMessage('result .... Contact Number: '+ contactNumber);
     jIntentManager1.SetAction(jIntentManager1.GetActionDialAsString());
     jIntentManager1.SetDataUri(jIntentManager1.GetTelUri(strContactNumber));

     if jIntentManager1.ResolveActivity() then
       jIntentManager1.StartActivity('Dial ...')
     else
       ShowMessage('Unable to find an App to perform this action...');

   end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jIntentManager1.SetAction(jIntentManager1.GetActionGetContentUri());
   jIntentManager1.SetMimeType('vnd.android.cursor.item/phone_v2');

   if jIntentManager1.ResolveActivity() then
       jIntentManager1.StartActivityForResult(1003, 'Dial ...')
   else
       ShowMessage('Unable to find an App to perform this action...');

end;

end.
