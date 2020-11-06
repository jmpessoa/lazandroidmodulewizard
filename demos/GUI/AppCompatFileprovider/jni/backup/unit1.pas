{Hint: save all files to location: C:\Temp\AppCompactFileprovider\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, intentmanager, And_jni,
  imagefilemanager, fileprovider;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    imgFile: jImageFileManager;
    iShareImage: jIntentManager;
    bmp: jBitmap;
    jButton1: jButton;
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
var
    uri : jObject;
    strFile : string;
    strDir : string;
begin

    strFile := 'lamw.png';
    strDir  := GetEnvironmentDirectoryPath(dirInternalAppStorage) + '/sh_images';

    if not imgFile.SaveToFile(bmp.GetImage(), strDir, strFile) then
    begin
     showmessage('Not save');
     exit;
    end;

    if not FileExists(strDir +'/' + strFile) then
    begin
     showmessage('Not exists');
     exit;
    end;

    uri := ParseUri('content://org.lamw.appcompactfileprovider.fileprovider/external_files/' + strFile);

    if uri = nil then exit;

    iShareImage.NewIntent();
    iShareImage.SetAction(iaSend);

    iShareImage.PutExtraMailSubject('LAMW Subject');
    iShareImage.PutExtraText('LAMW Info');

    iShareImage.SetFlag(ifGrantReadUriPermission);
    iShareImage.AddFlag(ifGrantWriteUriPermission);
    iShareImage.AddFlag(ifActivityClearWhenTaskReset);
    iShareImage.AddFlag(ifActivityClearTop);

    iShareImage.SetMimeType('image/*');
    iShareImage.PutExtraFile(uri);

    iShareImage.StartActivityForResult(1010, 'Share image');
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if requestCode = 1010 then
   if resultCode = RESULT_OK then
    SetTitleActionBar('Result 1010');
end;

end.
