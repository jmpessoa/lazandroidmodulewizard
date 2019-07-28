{Hint: save all files to location: D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\jni }
{Demo project for using the unzip function}
{by Johan Hofman / 2019-07-20}
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, Zipper;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    Function StartUnzipFile:boolean;
    procedure DoCreateOutZipStream(Sender: TObject; var AStream: TStream;
    AItem: TFullZipFileEntry);
    procedure DoDoneOutZipStream(Sender: TObject; var AStream: TStream;
    AItem: TFullZipFileEntry);
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


procedure TAndroidModule1.DoCreateOutZipStream(Sender: TObject; var AStream: TStream; AItem: TFullZipFileEntry);
begin
  AStream:= TMemorystream.Create;
end;

procedure TAndroidModule1.DoDoneOutZipStream(Sender: TObject; var AStream: TStream; AItem: TFullZipFileEntry);
begin
  AStream.Position:=0;
  TMemoryStream(astream).SaveToFile(Self.GetEnvironmentDirectoryPath(dirdownloads)+'/'+aitem.DiskFileName);

  Astream.Free;
end;

Function TAndroidModule1.StartUnzipfile:boolean;
var
  zipfile: TUnZipper;
  flist: TStringlist;
  installpath: string;
begin
   try
     installpath:= Self.GetEnvironmentDirectoryPath(dirDownloads)+'/';
     zipfile:= TUnZipper.Create;
     zipfile.FileName:= installpath+'Demo.zip';

     flist:= TStringlist.create;
     flist.add('Demo.txt');

     // Normally the zipfile can be extracted via zipfile.UnzipAllFiles but this will result in an application crash
     // The workaround is to use a memorystream for the extraction:
     ZipFile.OnCreateStream := DoCreateOutZipStream;
     ZipFile.OnDoneStream:= DoDoneOutZipStream;
     ZipFile.UnZipFiles(flist);

     ZipFile.Free;
     flist.Free;

     Showmessage('Success! Unpacking done !!');
     Result:=true;

   except
     on e:exception do showmessage('Error occured during unzip process: '+e.message);
   end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
  begin
    Self.CopyFromAssetsToEnvironmentDir('Demo.zip',Self.GetEnvironmentDirectoryPath(dirDownloads));
    StartUnzipFile;
  end
  else  Showmessage('Sorry.. "WRITE_EXTERNAL_STORAGE"  DENIED ...');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
 if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') = False then
    Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE',1001);
end;

end.
