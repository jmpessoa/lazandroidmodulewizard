{Hint: save all files to location: C:\lamw\workspace\AppXLSWriterDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, xlswriter;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    jXLSWriter1: jXLSWriter;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
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
var
   mySheets: array of string;
begin
       //hint: if you  get "write" permission then you have "read", too!
   if not IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
     Exit;
   end;

   SetLength(mySheets, 2);
   mySheets[0]:= 'Sheet0';
   mySheets[1]:= 'Sheet1';

   if jXLSWriter1.CreateWorkbook(mySheets, Self.GetEnvironmentDirectoryPath(dirDownloads), 'myPlan.xls') then
   begin

      jXLSWriter1.AddCell(0, 0,0,'Hello');     //coluna=0, linha=0
      jXLSWriter1.AddCell(0, 0,1,'XLS');     //coluna=0, linha=1
      jXLSWriter1.AddCell(0, 0,2,'World!');    //coluna=0, linha=2

      jXLSWriter1.AddCell(1,0,0,'Powered');
      jXLSWriter1.AddCell(1,0,1,'by');
      jXLSWriter1.AddCell(1,0,2,'LAMW!');

      ShowMessage('Success!!  "myPlan.xls" created! ');
   end
   else ShowMessage('Sorry... fail to create Workbook...');

   SetLength(mySheets, 0);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: array of string;
begin
  if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
  begin
     ShowMessage('RequestRuntimePermission....');

     SetLength(manifestPermissions, 1);

     //hint: if you  get "write" permission then you have "read", too!
     manifestPermissions[0]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml
     Self.RequestRuntimePermission(manifestPermissions, 3461);

     SetLength(manifestPermissions, 0);
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     3461:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
  end;
end;

end.
