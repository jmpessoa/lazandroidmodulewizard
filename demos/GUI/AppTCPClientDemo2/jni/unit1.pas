{Hint: save all files to ...\AppTCPClientDemo2\jni }
unit unit1;   {by Guser979}
              {https://forum.lazarus.freepascal.org/index.php/topic,55201.0.html}

{$mode delphi}
// {$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Laz_And_Controls, AndroidWidget, tcpsocketclient,
  opendialog, blcksock, uTCPSockets,
  uTCPCryptoCompression, strutils, fileutil;

type
  { TAndroidModule1 }
  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jEditText4: jEditText;
    jOpenDialog1: jOpenDialog;
    jTCPSocketClient1: jTCPSocketClient;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jOpenDialog1FileSelected(Sender: TObject; path: string;
      fileName: string);
    procedure jTCPSocketClient1Connected(Sender: TObject);
    procedure jTCPSocketClient1MessagesReceived(Sender: TObject;
      messageReceived: string);

 private
    {private declarations}
	FConnection: TConnection;
 var
	Msg: String;
	MS: TMemoryStream;
	f: String;
	res,can:boolean;

 public
    {public declarations}
    property Connection: TConnection read FConnection;
    function SendFile(AFileName: String): Boolean;
  end;
var
   AndroidModule1: TAndroidModule1;
   afilename:string; FBlockSocket:TTCPBlockSocket;


implementation
{$R *.lfm}
{ TAndroidModule1 }

 function TAndroidModule1.SendFile(AFileName: String): Boolean;

var
  ReadCnt: LongInt;
  Cnt: Int64;
  Buffer: Pointer;
  MSComp: TMemoryStream;
  FS: TFileStream;
  Mi,fsize: String;

begin
  Result := False;
  fsize:= inttostr(fileutil.FileSize(afilename));
  mi:= '2FILE:FILE,'+fsize+','+extractfilename(afilename)+',';
  jEditText2.AppendLn(timetostr(now)+':'+' Sending File '+extractfilename(afilename) );
  mi:= Encrypt(jedittext4.Text, mi);
  FBlockSocket.SendString( mi );
  try
    FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
    try
      FS.Position := 0;
      GetMem(Buffer, FBlockSocket.SendMaxChunk);
      try
        Cnt := 0;
        MS := TMemoryStream.Create;
        try
          MSComp := TMemoryStream.Create;
          try
            repeat
              repeat
              Msg := FBlockSocket.RecvPacket(50000);
              until (Msg = 'DONE') or (Msg = 'NEXT');
              if (FBlockSocket.LastError > 0) or (Msg = 'DONE') or (Msg <> 'NEXT') then
               begin  jEditText2.AppendLn(timetostr(now)+':Sending Finished'); Break;  end;
              ReadCnt := FS.Read(Buffer^, FBlockSocket.SendMaxChunk);
              if (ReadCnt > 0) then
              begin
                MS.Clear;
                MS.Write(Buffer^, ReadCnt);
                MS.Position := 0;
                  FBlockSocket.SendStream(MS);
          if (FBlockSocket.LastError = 0)  then
               begin
                  Cnt := Cnt + MS.Size;
                end;
              end;
            until (ReadCnt = 0) or (Cnt > FS.Size);
            Result := FBlockSocket.LastError = 0;
           if Result then begin    FBlockSocket.CloseSocket; jButton1Click(self)     end
            else  showmessage('erro');
          finally
            MSComp.Free;
          end;
        finally
          MS.Free;
        end;
      finally
        FreeMem(Buffer);
      end;
    finally
      FS.Free;
    end;
  except
    on E: Exception do
    showmessage('erro');
  end
end;


procedure TAndroidModule1.jButton1Click(Sender: TObject);

begin

	jTCPSocketClient1.ConnectAsync(jedittext3.Text,strtoint(jedittext4.Text));
end;


procedure TAndroidModule1.jButton2Click(Sender: TObject);

begin
  if jTCPSocketClient1.IsConnected()  then jTCPSocketClient1.SendMessage(Encrypt(jedittext4.Text,'0TEXT:'+jEditText1.Text+',') ) else jEditText2.AppendLn(timetostr(now)+':'+' Connection Fail' );
end;


procedure TAndroidModule1.jButton3Click(Sender: TObject);

begin
      if jTCPSocketClient1.IsConnected()  then jTCPSocketClient1.CloseConnection() else begin jEditText2.AppendLn(timetostr(now)+':'+' Connection Fail' ); exit; end;
	FBlockSocket.Connect (jedittext3.Text, jedittext4.Text);
        FBlockSocket.SendString (encrypt(jedittext4.Text,'0LOGIN:,LAMW,0,') ); // LAMW  = YOUR USERNAME
	repeat
	until FBlockSocket.RecvPacket(5000) <> '';
        jOpenDialog1.Show();
end;


procedure TAndroidModule1.jOpenDialog1FileSelected(Sender: TObject;path: string; fileName: string);

begin

     SendFile(getEnvironmentDirectoryPath(TEnvDirectory.dirDownloads)+'/'+fileName);
end;


procedure TAndroidModule1.jTCPSocketClient1Connected(Sender: TObject);

begin

     jTCPSocketClient1.SendMessage(encrypt(jedittext4.Text,'0LOGIN:,LAMW,0,'));// LAMW  = YOUR USERNAME
end;


procedure TAndroidModule1.jTCPSocketClient1MessagesReceived(Sender: TObject; messageReceived: string);

begin
   if  messageReceived <> '#CONNECTION_FAIL#' then
   begin
   messageReceived:=decrypt(jedittext4.Text, messageReceived);
   jEditText2.AppendLn(timetostr(now)+':'+replacestr(extractword(2,messageReceived,[':']),',','') );
   end else jEditText2.AppendLn(timetostr(now)+':'+' Connection Fail' );

  end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);

var manifestPermissions: TDynArrayOfString;

begin
self.SetStatusColor(androidmodule1.BackgroundColor );
   if  IsRuntimePermissionNeed() then   // that is, target API >= 23
    begin
        SetLength(manifestPermissions, 3);
        manifestPermissions[0]:= 'android.permission.CAMERA';  //from AndroodManifest.´
        manifestPermissions[1]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml
        manifestPermissions[2]:='android.permission.RECORD_AUDIO';
        Self.RequestRuntimePermission(manifestPermissions, 1001);
        SetLength(manifestPermissions, 0);
    end;
can:=false; res:=false;  FBlockSocket := TTCPBlockSocket.Create;
end;


procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);

begin
     case requestCode of
     1001:begin
              if grantResult = PERMISSION_GRANTED  then
               ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
     end;
end;


end.
