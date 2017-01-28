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

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jOpenDialog1.Show();
end;

procedure TAndroidModule1.jOpenDialog1FileSelected(Sender: TObject;
  path: string; fileName: string);
begin
  ShowMessage(path);
  ShowMessage(fileName);

  if Pos('.txt', filename) > 0 then
     ShowMessage(jTextFileManager1.LoadFromFile(path, fileName));

  if Pos('.png', filename) > 0 then
   jImageView1.SetImage(jImageFileManager1.LoadFromFile(path, filename));

end;

end.
