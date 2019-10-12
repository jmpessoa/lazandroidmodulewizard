{Hint: save all files to location: C:\android\workspace\AppFTPClientDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, ftpclient;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jButton5: jButton;
    jFTPClient1: jFTPClient;
    jListView1: jListView;
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

    procedure jFTPClient1Connect(Sender: TObject; success: boolean);

    procedure jFTPClient1Download(Sender: TObject; localPath: string;
      success: boolean);

    procedure jFTPClient1Listed(Sender: TObject; count: integer);
    procedure jFTPClient1Listing(Sender: TObject; remotePath: string;
      fileName: string; fileSize: integer);
    procedure jFTPClient1Upload(Sender: TObject; remotePath: string;
      success: boolean);

  private
    {private declarations}
    IsConnected: boolean;
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
    if not Self.IsConnectedWifi() then
  begin
     ShowMessage('Please,  connect to [wifi] Internet....');
     Exit;
  end;

  ShowMessage('Try connect to FTP "test.rebex.net..."');       //test.rebex.ne

  jFTPClient1.Host:= 'test.rebex.net';   //free online test....  //https://www.rebex.net/sftp.net/
  jFTPClient1.Port:= 21;  //default

  jFTPClient1.Username:='demo';
  jFTPClient1.Password:='password';

  jFTPClient1.Connect(); //handle by "OnConnect"
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
  begin

    ShowMessage('Try download from "test.rebex.net/pub/example/winceclient.png" ...');

    if IsConnected then
       jFTPClient1.Download('/pub/example/winceclient.png', Self.GetEnvironmentDirectoryPath(DirDownloads)+ '/' + 'winceclient-rebex-net.png')
    else
      ShowMessage('Please, connect....');

  end
  else ShowMessage('Sorry... [PERMISSION_DENIED] download file will not be possible....');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   //TODO TEST!
  (*
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin

      ShowMessage('Try upload to "test.rebex.net/pub/example..."');

       if IsConnected then
         jFTPClient1.Upload(Self.GetEnvironmentDirectoryPath(DirDownloads)+ '/' + 'winceclient-rebex-net.png', '/pub/example/readme-lamw-test.txt')
       else
         ShowMessage('Please, connect....');

   end
   else ShowMessage('Sorry... [PERMISSION_DENIED] upload file will not be possible....');
   *)
   ShowMessage('Sorry... Upload test denied by  "test.rebex.net" ');
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
     ShowMessage('Try list files  from  "test.rebex.net/pub/example..."');

   if IsConnected then
     jFTPClient1.ListFiles('/pub/example') //
   else
     ShowMessage('Please, connect...');

end;

procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
 if IsConnected then jFTPClient1.Disconnect();

 ShowMessage('Disconnected....');
end;

procedure TAndroidModule1.jFTPClient1Download(Sender: TObject;
  localPath: string; success: boolean);
begin
    if success then
    ShowMessage('Download save to: ' + localPath)
  else
    ShowMessage('Sorry... fail to download...');
end;

procedure TAndroidModule1.jFTPClient1Listed(Sender: TObject; count: integer);
begin
  ShowMessage('Listed Files [count]: '+ IntToStr(count));
end;

procedure TAndroidModule1.jFTPClient1Listing(Sender: TObject;
  remotePath: string; fileName: string; fileSize: integer);
begin
  jListView1.Add(fileName + '|' + IntToStr(fileSize)+' bytes' + '|' + remotePath);
end;

procedure TAndroidModule1.jFTPClient1Upload(Sender: TObject;
  remotePath: string; success: boolean);
begin
  if success then ShowMessage('Upload success!!')
  else ShowMessage('Upload fail....')
end;

procedure TAndroidModule1.jFTPClient1Connect(Sender: TObject; success: boolean);
begin
  if success then
  begin
   IsConnected:= True;
   ShowMessage('success');
   ShowMessage('Server WorkingDirectory: ' +jFTPClient1.WorkingDirectory);
  end
  else
  begin
    IsConnected:= False;
    ShowMessage('Sorry.... not connect...');
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of
   1198:begin
          if manifestPermission = 'android.permission.WRITE_EXTERNAL_STORAGE' then
          begin
              if grantResult = PERMISSION_GRANTED  then
                 ShowMessage('Sucess... PERMISSION_GRANTED !!!')
              else
                 ShowMessage('Sorry... [PERMISSION_DENIED] download/upload Files will not be saved/load....');
          end;
        end;
   end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
     if IsRuntimePermissionNeed() then   // that is, device/target API >= 23
        Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1198);
   //else not need run time permission... [old devices...]
end;

end.
