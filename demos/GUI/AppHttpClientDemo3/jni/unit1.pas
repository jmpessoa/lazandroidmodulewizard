{Hint: save all files to location: C:\lamw\workspace\AppHttpClientDemo3\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, opendialog;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jHttpClient1: jHttpClient;
    jOpenDialog1: jOpenDialog;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jEditText1LostFocus(Sender: TObject; textContent: string);
    procedure jHttpClient1UploadFinished(Sender: TObject;
      connectionStatusCode: integer; responseMessage: string; fileName: string);
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

(*  SERVER SIDE TEST !!!!  
<?php
    $file_path = "/var/www/html/uploads";
    $file_path =  $file_path . '/' . $_FILES['lamwFormUpload']['name'];
	echo "Saving in $file_path...";
    if(move_uploaded_file($_FILES['lamwFormUpload']['tmp_name'], $file_path) ){
        echo "LAMW upload success!";
    } else{
        echo "Sorry.. LAMW upload fail!";
    }
 ?>
*)

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   //jHttpClient1.UploadFormName:= 'lamwFormUpload';  //default!!!!
   Self.jHttpClient1.UploadFile(Self.jEditText1.Text, Self.jEditText2.Text);
end;

procedure TAndroidModule1.jEditText1LostFocus(Sender: TObject;
  textContent: string);
begin
  if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then   //READ_EXTERNAL_STORAGE
  begin
    jOpenDialog1.Show();
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText2.Clear;
  jEditText1.SetFocus;

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

  //https://www.captechconsulting.com/blogs/runtime-permissions-best-practices-and-how-to-gracefully-handle-permission-removal
  if IsRuntimePermissionNeed() then   // that is, target API >= 23
  begin
     ShowMessage('Requesting Runtime Permission....');
     Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 5001);  //from AndroodManifest.xml
  end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     5001:begin   //STORAGE
              if grantResult = PERMISSION_GRANTED  then
                  ShowMessage(manifestPermission + ' :: Success! Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage(manifestPermission + '   :: Sorry... permission not grant... ' )
          end;
  end;
end;

procedure TAndroidModule1.jHttpClient1UploadFinished(Sender: TObject;
  connectionStatusCode: integer; responseMessage: string; fileName: string);
begin
  ShowMessage(responseMessage);
end;

procedure TAndroidModule1.jOpenDialog1FileSelected(Sender: TObject;
  path: string; fileName: string);
begin
  jEditText2.Text:= path +'/'+ fileName;
end;

end.
