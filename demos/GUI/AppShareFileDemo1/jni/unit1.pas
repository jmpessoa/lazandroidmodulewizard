{Hint: save all files to location: C:\adt32\eclipse\workspace\AppShareFileDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, textfilemanager, sharefile,
  imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jButton5: jButton;
      jButton6: jButton;
      jButton7: jButton;
      jCheckBox1: jCheckBox;
      jImageFileManager1: jImageFileManager;
      jImageView1: jImageView;
      jImageView2: jImageView;
      jShareFile1: jShareFile;
      jTextFileManager1: jTextFileManager;
      jTextView1: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure AndroidModule1RequestPermissionResult(Sender: TObject;
        requestCode: integer; manifestPermission: string;
        grantResult: TManifestPermissionResult);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jButton5Click(Sender: TObject);
      procedure jButton6Click(Sender: TObject);
      procedure jButton7Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
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


//_mimetype [lowercase!]:  "image/jpeg" or "text/plain" or "image/*" or "*/*" etc...

//GetAbsoluteDirectoryPath --> /data/data/com.example.appbuttondemo1/files
//GetEnvironmentDirectoryPath(dirDownloads); --> /storage/emulated/0/Download

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if Self.IsSdCardMounted then ShowMessage('Yes, SdCard is Mounted!!!')
   else ShowMessage('Sorry, SdCard not Mounted!');

   (*
   if  Self.IsExternalStorageEmulated ...
   if  Self.IsExternalStorageRemovable ...
   if Self.IsWifiEnabled ...
   *)

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: array of string;
begin
   if not Self.isConnected() then
   begin //try wifi
     if Self.SetWifiEnabled(True) then
       jCheckBox1.Checked:= True
     else
       ShowMessage('Please,  try enable some connection...');
   end
   else
   begin
      if Self.isConnectedWifi() then jCheckBox1.Checked:= True
   end;


   if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
   begin
      ShowMessage('RequestRuntimePermission....');

      SetLength(manifestPermissions, 1);

      //hint: if you  get "write" permission then you have "read", too!
      manifestPermissions[0]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml
      Self.RequestRuntimePermission(manifestPermissions, 5001);

      SetLength(manifestPermissions, 0);
   end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     5001:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
    end;
end;

//Load 'hello.txt' from Assets -> Add "new" content to 'hello.txt' and save to App.../files
procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  txtContent: string;
begin

   //hint: if you  get "write" permission then you have "read", too!
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     txtContent:= jTextFileManager1.LoadFromAssets('hello.txt');
     ShowMessage('Content -> ' +txtContent);
     jTextFileManager1.SaveToFile('Yes,'+txtContent, 'hello.txt');  //save to Internal App Storage   [../files]
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');

end;

// copy from  Internal App Storage [../files] to [public] ../downloads
procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  cpyOk:  boolean;
begin
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin

     //try it!
     //txtContent:=  jTextFileManager1.LoadFromFile('hello.txt');  //load from Internal App Storage  [../files]
     //ShowMessage(txtContent);

     //GetEnvironmentDirectoryPath(dirInternalAppStorage) <--> Self.GetAbsoluteDirectoryPath
     cpyOk:= Self.CopyFile(Self.GetEnvironmentDirectoryPath(dirInternalAppStorage)+'/hello.txt',
                             Self.GetEnvironmentDirectoryPath(dirDownloads)+'/hello.txt');

     if cpyOk then ShowMessage('Copy Ok!') else ShowMessage('Copy Fail!');

     (* try it!
     Self.CreateDir ...
     Self.DeleteFile ...
     Self.LoadFromAssets  .... result: path to new storage [Internal App Storage]
     *)
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');

end;

//TODO: read it! http://www.grokkingandroid.com/how-to-correctly-store-app-specific-files-in-android/

//Share from [public] .../downloads
procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     ShowMessage('Warning: I just test it using bluetooth!');
     jShareFile1.ShareFrom(GetEnvironmentDirectoryPath(dirDownloads)+'/hello.txt', 'text/plain');
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

//Share from Assets ... well, there is a pit stop!
procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     ShowMessage('Warning: I just test it using bluetooth!');
     jShareFile1.TransitoryEnvironmentDirectory:= dirDownloads; //some public directory for pit stop!
     jShareFile1.ShareFromAssets('lazarus.png','image/png'); //we need a public  "transitory" environment Directory!
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

procedure TAndroidModule1.jButton6Click(Sender: TObject);
var
  jimage: jObject;
begin
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     jimage:= jImageFileManager1.LoadFromAssets('gallery.png');
     jImageView1.SetImageBitmap(jimage);
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

procedure TAndroidModule1.jButton7Click(Sender: TObject);
var
  jimage, jimage3: jObject;            //palette.png
  cpyOk: boolean;
begin
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     jimage:= jImageFileManager1.LoadFromAssets('palette.png');

     jImageFileManager1.SaveToFile(jimage, 'palette2.png'); //save as "palette2.png" to internal app storage...

     //copy "palette2.png"  from internal storage  to /downloads [public] as  "palette3.png.png"
     cpyOk:= Self.CopyFile(Self.GetEnvironmentDirectoryPath(dirInternalAppStorage)+'/palette2.png',
                           Self.GetEnvironmentDirectoryPath(dirDownloads)+'/palette3.png');

     //load "palette3.png" from /downloads
     if  cpyOk then
     begin
       jimage3:= jImageFileManager1.LoadFromFile(Self.GetEnvironmentDirectoryPath(dirDownloads), 'palette3.png');
       jImageView2.SetImageBitmap(jimage3);
     end;

   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

procedure TAndroidModule1.jCheckBox1Click(Sender: TObject);
begin
   if jCheckBox1.Checked then
      Self.SetWifiEnabled(True)
   else
     Self.SetWifiEnabled(False);
end;



end.
