{Hint: save all files to location: C:\lamw\workspace\AppIntentDemoPrinting1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, textfilemanager,
  intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jCheckBox1: jCheckBox;
    jIntentManager1: jIntentManager;
    jTextFileManager1: jTextFileManager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
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

(*
datatype/mimetype, examples:

"application/pdf"
"text/html"
"text/plain"
"image/png"
"image/jpeg"
"image/*"

"application/msword"  for ".doc"
"application/vnd.openxmlformats-officedocument.wordprocessingml.document"  for  ".docx"
"application/vnd.ms-excel" - .xls
"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"  for  ".xlsx"
"application/vnd.ms-powerpoint"  for ".ppt"
"application/vnd.openxmlformats-officedocument.presentationml.presentation"  for  ".pptx"
*)

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if not Self.isConnectedWifi() then
     ShowMessage('Please, connect to Wifi !!')
  else
    jCheckBox1.Checked:= True;

  if Self.IsRuntimePermissionNeed()  then  //need when targeting Api >= 23
  begin
     Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1122);
  end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  if requestCode = 1122 then
  begin

     if  grantResult =  PERMISSION_GRANTED then
       ShowMessage('Success !! "' +manifestPermission + '" ' + 'PERMISSION_GRANTED!!!')
     else
       ShowMessage('Sorry... "' + manifestPermission + '" ' + 'PERMISSION_DENIED...');

  end;
end;


procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
   environmentDirectoryPath: string;
   fileToPrint: string;
begin
  //http://www.printershare.com/help-android-regular.sdf   <<-- important: abut printershare license
  //http://www.printershare.com/help-android-integration.sdf

  //Please, [must] read here:
  //https://play.google.com/store/apps/details?id=com.dynamixsoftware.printershare  <<---- Android 4.4 or up !!!
    {
      "be sure to enable the PrinterShare Print Service plug-in in the Android system settings"
    }

  if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
  begin
        environmentDirectoryPath:= Self.GetEnvironmentDirectoryPath(dirDownloads); //you need a public folder directory

        //some image or pdf in device download folder and test it!
        //fileToPrint:= 'pwbg.jpg';  //try some default view for images!
        //fileToPrint:= 'dmarcos.pdf'; //try  some default view for pdf
        //warning: try other format and get some app to support view it!

        fileToPrint:= 'data1.html';  //there is some default view  for html
        //just demo ...
        jTextFileManager1.SaveToFile('<html>My "Printershare" Demo text file content <br> to be printed!</hmtl>', environmentDirectoryPath, fileToPrint);

        if jIntentManager1.IsPackageInstalled('com.dynamixsoftware.printershare') then
        begin
          jIntentManager1.IntentAction:= iaView;
          //or jIntentManager1.SetAction('android.intent.action.VIEW');

          jIntentManager1.SetPackage('com.dynamixsoftware.printershare');

          //jIntentManager1.SetDataAndType('file://' + environmentDirectoryPath + '/' + fileToPrint, 'image/*');
          jIntentManager1.SetDataAndType('file://' + environmentDirectoryPath + '/' + fileToPrint, 'text/html');
          //jIntentManager1.SetDataAndType('file://' + environmentDirectoryPath + '/' + fileToPrint, 'application/pdf');
          jIntentManager1.StartActivity(); //StartActivityForResult(1);
        end
        else
        begin
          ShowMessage('Try downloading PrinterShare  App ...');

          jIntentManager1.SetAction(jIntentManager1.GetActionViewAsString());
          //or jIntentManager1.SetAction('android.intent.action.VIEW');
          jIntentManager1.SetDataUri( jIntentManager1.ParseUri('market://details?id=com.dynamixsoftware.printershare') );
          jIntentManager1.StartActivity();
        end;

  end;

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
   environmentDirectoryPath: string;
   fileToPrint: string;

begin

  if Self.IsRuntimePermissionGranted('') then
  begin

       environmentDirectoryPath:= Self.GetEnvironmentDirectoryPath(dirDownloads); //you need a public directory!!
       //put some image and pdf in device download folder and test....!
       //fileToPrint:= 'pwbg.jpg';  //try some default view for images!
       //fileToPrint:= 'dmarcos.pdf'; //try some default view for pdf!
       //warning: try other format and get some app to support view it!

       fileToPrint:= 'data2.html';
       //just demo...
       jTextFileManager1.SaveToFile('<html>My Zenofx LocalPrint Demo text file content <br> to be printed!</html>', environmentDirectoryPath, fileToPrint);

        //Please, [must] read some settings detail here:
        //https://play.google.com/store/apps/details?id=com.zenofx.localprint&hl=en

        {
           "be sure to enable the LocalPrint Print Service plug-in in the Android system settings"
        }

        if jIntentManager1.IsPackageInstalled('com.zenofx.localprint') then
        begin
          jIntentManager1.IntentAction:= iaView;
          //or jIntentManager1.SetAction('android.intent.action.VIEW');

          jIntentManager1.SetPackage('com.zenofx.localprint');

          //jIntentManager1.SetDataAndType('file://' + environmentDirectoryPath + '/' + fileToPrint, 'image/*');
          jIntentManager1.SetDataAndType('file://' + environmentDirectoryPath + '/' + fileToPrint, 'text/html');
          //jIntentManager1.SetDataAndType('file://' + environmentDirectoryPath + '/' + fileToPrint, 'application/pdf');

          jIntentManager1.StartActivity(); //StartActivityForResult(1100);
        end
        else
        begin
          ShowMessage('Try downloading Zenofx LocalPrint  App ...');
          jIntentManager1.SetAction(jIntentManager1.GetActionViewAsString());
          //or jIntentManager1.SetAction('android.intent.action.VIEW');
          jIntentManager1.SetDataUri( jIntentManager1.ParseUri('market://details?id=com.zenofx.localprint') );
          jIntentManager1.StartActivity();
        end;

  end;
end;

end.
