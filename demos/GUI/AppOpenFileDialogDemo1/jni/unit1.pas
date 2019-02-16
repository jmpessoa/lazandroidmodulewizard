{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppOpenFileDialogDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, opendialog,
  textfilemanager, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jButton2: jButton;
    jImageFileManager1: jImageFileManager;
    jImageView1: jImageView;
    jOpenDialog1: jOpenDialog;
    jTextFileManager1: jTextFileManager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jOpenDialog1FileSelected(Sender: TObject; path: string;
      fileName: string);

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
  listFile: TDynArrayOfString;
  i, count: integer;
  saveData: TStringList;
begin

     //hint: if you  get "write" permission then you have "read", too!
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
      saveData:= TStringList.Create;
      saveData.Add('Hello World!');
      saveData.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads) + '/' + 'myhello.txt');
      saveData.Free;

      jImageFileManager1.SaveToFile(jBitmap1.GetImage(), Self.GetEnvironmentDirectoryPath(dirDownloads), 'ic_launcher.png');

      listFile:= Self.GetFileList(Self.GetEnvironmentDirectoryPath(dirDownloads)); //  or dirSdCard or ...
      count:= Length(listFile);
      for i:= 0 to count-1 do
      begin
        ShowMessage(listFile[i]);
      end;

      SetLength(listFile, 0);

   end;

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
      Self.RequestRuntimePermission(manifestPermissions, 6001);  // some/any value...

      SetLength(manifestPermissions, 0);
   end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     6001:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
    end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jOpenDialog1.Show();
end;

procedure TAndroidModule1.jOpenDialog1FileSelected(Sender: TObject;
  path: string; fileName: string);
begin
  ShowMessage(path);
  ShowMessage(fileName);

   //hint: if you  get "write" permission then you have "read", too!
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
      if Pos('.txt', filename) > 0 then
         ShowMessage(jTextFileManager1.LoadFromFile(path, fileName));

      if Pos('.png', filename) > 0 then
       jImageView1.SetImage(jImageFileManager1.LoadFromFile(path, filename));

   end;

end;

end.
