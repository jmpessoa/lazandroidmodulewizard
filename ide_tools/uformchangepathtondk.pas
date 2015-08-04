unit uformchangepathtondk;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, IniFiles, IDEIntf, ProjectIntf, LazIDEIntf, LCLIntf, ComCtrls;

type

  { TFormChangeDemoPathToNDK }

  TFormChangeDemoPathToNDK = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBoxSelectProject: TComboBox;
    EditPathToAndroidSDK: TEdit;
    EditPathToAndroidNDK: TEdit;
    EditPathToWorkspace: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SelectDirectoryDialog2: TSelectDirectoryDialog;
    SelectDirectoryDialog3: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBoxSelectProjectChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    PathToDemosWorkspace: string;
    PathToDemoAndroidNDK: string;
    PathToAndroidNDK: string;
    PathToDemoAndroidSDK: string;
    PathToAndroidSDK: string;
    LastFullProjectName: string;
  end;

  procedure GetSubDirectories(const directory : string; list : TStrings);

var
  FormChangeDemoPathToNDK: TFormChangeDemoPathToNDK;

implementation

{$R *.lfm}

{ TFormChangeDemoPathToNDK }

procedure TFormChangeDemoPathToNDK.SpeedButton2Click(Sender: TObject);
begin
  SelectDirectoryDialog2.Title:= 'Select Demos Projects Path:';
  if Trim(EditPathToWorkspace.Text) <> '' then
    if DirPathExists(EditPathToWorkspace.Text) then
      SelectDirectoryDialog2.InitialDir:= EditPathToWorkspace.Text;
  if SelectDirectoryDialog2.Execute then
  begin
     PathToDemosWorkspace:= SelectDirectoryDialog2.FileName;
     EditPathToWorkspace.Text:= PathToDemosWorkspace;
     ComboBoxSelectProject.Items.Clear;
     GetSubDirectories(PathToDemosWorkspace, ComboBoxSelectProject.Items);
  end;
end;

procedure TFormChangeDemoPathToNDK.SpeedButton3Click(Sender: TObject);
begin
  PathToDemosWorkspace:= EditPathToWorkspace.Text;   //change Workspace...
  ComboBoxSelectProject.Items.Clear;
  GetSubDirectories(PathToDemosWorkspace, ComboBoxSelectProject.Items);
  ComboBoxSelectProject.ItemIndex:= -1;
  ComboBoxSelectProject.Text:='';
end;

procedure TFormChangeDemoPathToNDK.SpeedButton4Click(Sender: TObject);
begin
  SelectDirectoryDialog3.Title:= 'Select Android Sdk Path:';
  if Trim(EditPathToAndroidSDK.Text) <> '' then
    if DirPathExists(EditPathToAndroidSDK.Text) then
      SelectDirectoryDialog3.InitialDir:= EditPathToAndroidSDK.Text;
  if SelectDirectoryDialog3.Execute then
  begin
     PathToAndroidSDK:= SelectDirectoryDialog3.FileName;
     EditPathToAndroidSDK.Text:= PathToAndroidSDK;
  end;
end;

procedure TFormChangeDemoPathToNDK.SpeedButton1Click(Sender: TObject);
begin
  SelectDirectoryDialog1.Title:= 'Select Android Ndk Path:';
  if Trim(EditPathToAndroidNDK.Text) <> '' then
    if DirPathExists(EditPathToAndroidNDK.Text) then
      SelectDirectoryDialog1.InitialDir:= EditPathToAndroidNDK.Text;
  if SelectDirectoryDialog1.Execute then
  begin
     PathToAndroidNDK:= SelectDirectoryDialog1.FileName;
     EditPathToAndroidNDK.Text:= PathToAndroidNDK;
  end;
end;

procedure TFormChangeDemoPathToNDK.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  AmwFile: string;
begin
  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExistsUTF8(AmwFile) then
  begin
     with TInifile.Create(AmwFile) do
     try
       WriteString('NewProject', 'PathToDemosWorkspace', PathToDemosWorkspace);
       WriteString('NewProject', 'PathToAndroidNDK', PathToAndroidNDK);
     finally
        Free;
     end;
  end;
end;

procedure TFormChangeDemoPathToNDK.ComboBoxSelectProjectChange(Sender: TObject);
var
  strList: TStringList;
  pathLineIndex: integer;
  pathLine: string;
begin
  strList:= TStringList.Create;
  PathToDemoAndroidNDK:= '';
  PathToDemoAndroidSDK:= '';
  strList.LoadFromFile(ComboBoxSelectProject.Text+ DirectorySeparator+'readme.txt');
  pathLineIndex:= strList.Count;
  pathLine := '';
  while (pathLine = '') and  (pathLineIndex > 0) do
  begin
     pathLineIndex:= pathLineIndex - 1;
     pathLine:= strList.Strings[pathLineIndex]
  end;
  if Pos('System Path to Android NDK=', strList.Strings[pathLineIndex]) > 0 then
  begin
     PathToDemoAndroidNDK:= strList.ValueFromIndex[pathLineIndex];
  end;
  if Pos('System Path to Android SDK=', strList.Strings[pathLineIndex-1]) > 0 then
  begin
     PathToDemoAndroidSDK:= strList.ValueFromIndex[pathLineIndex-1];
  end;
  strList.Free;
end;

procedure TFormChangeDemoPathToNDK.BitBtn1Click(Sender: TObject);
var
  strList: TStringList;
  strResult: string;
  lpiFileName: string;
begin
  lpiFileName:= 'controls.lpi';

  if not FileExists(ComboBoxSelectProject.Text+ DirectorySeparator+'jni'+ DirectorySeparator + 'controls.lpi') then
     lpiFileName:= InputBox('Project File Name', 'Enter *.lpi project file name:', lpiFileName);

  if not FileExists(ComboBoxSelectProject.Text+ DirectorySeparator+'jni'+ DirectorySeparator + lpiFileName) then
  begin
     ShowMessage('Error. "'+lpiFileName+'" file Not Found!');
     Exit;
  end;

  strList:= TStringList.Create;

  if PathToDemoAndroidNDK <> '' then
  begin
    strList.LoadFromFile(ComboBoxSelectProject.Text+ DirectorySeparator+'jni'+ DirectorySeparator + lpiFileName);
    strList.SaveToFile(ComboBoxSelectProject.Text+ DirectorySeparator+'jni'+ DirectorySeparator + lpiFileName+'.bak');
    strResult:=  StringReplace(strList.Text, PathToDemoAndroidNDK, PathToAndroidNDK, [rfReplaceAll,rfIgnoreCase]);
    strList.Text:= strResult;
    strList.SaveToFile(ComboBoxSelectProject.Text+ DirectorySeparator+'jni'+ DirectorySeparator + lpiFileName);
    ShowMessage('"'+PathToDemoAndroidNDK+'"'+ 'change to: '+ '"'+PathToAndroidNDK+'"');
  end else ShowMessage('Error. Path to Project [Demo] Android NDK Not Found!');

  if PathToDemoAndroidSDK <> '' then
  begin
  strList.Clear;
  strList.LoadFromFile(ComboBoxSelectProject.Text+ DirectorySeparator+'build.xml');
  strList.SaveToFile(ComboBoxSelectProject.Text+ DirectorySeparator+'build.xml.bak');
  strResult:=  StringReplace(strList.Text, PathToDemoAndroidSDK, PathToAndroidSDK, [rfReplaceAll,rfIgnoreCase]);
  strList.Text:= strResult;
  strList.SaveToFile(ComboBoxSelectProject.Text+ DirectorySeparator+'build.xml');
  end else ShowMessage('Error. Path to Project [Demo] Android SDK Not Found!');

  strList.Free;
end;

procedure TFormChangeDemoPathToNDK.FormCreate(Sender: TObject);
var
  AmwFile: string;
  IDEProjectName: string;
  p: integer;
begin
  ComboBoxSelectProject.Text:= '';
  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExistsUTF8(AmwFile) then
  begin
      with TIniFile.Create(AmwFile) do  // Try to use settings from Android module wizard
      try
        PathToDemosWorkspace:=  ReadString('NewProject', 'PathToDemosWorkspace', '');
        PathToAndroidNDK:= ReadString('NewProject', 'PathToAndroidNDK', '');
        PathToAndroidSDK:= ReadString('NewProject', 'PathToAndroidSDK', '');
        EditPathToWorkspace.Text:= PathToDemosWorkspace;
        LastFullProjectName:= ReadString('NewProject', 'FullProjectName', '');
        if  PathToDemosWorkspace <> '' then
        begin
           IDEProjectName:='';
           p:= Pos(DirectorySeparator+'jni', LazarusIDE.ActiveProject.MainFile.Filename);
           if p > 0 then
             IDEProjectName:= Copy(LazarusIDE.ActiveProject.MainFile.Filename,1,p-1);
           ComboBoxSelectProject.Items.Clear;
           GetSubDirectories(PathToDemosWorkspace, ComboBoxSelectProject.Items);
           if IDEProjectName <> '' then
               ComboBoxSelectProject.Text:= IDEProjectName
           else if LastFullProjectName <> '' then
               ComboBoxSelectProject.Text:= LastFullProjectName;
        end;
        EditPathToAndroidNDK.Text:= PathToAndroidNDK;
        EditPathToAndroidSDK.Text:= PathToAndroidSDK;
      finally
        Free
      end;
  end;
end;

//helper... by jmpessoa

//http://delphi.about.com/od/delphitips2008/qt/subdirectories.htm
//fils the "list" TStrings with the subdirectories of the "directory" directory
//Warning: if not  subdirectories was found return empty list [list.count = 0]!
procedure GetSubDirectories(const directory : string; list : TStrings);
var
   sr : TSearchRec;
begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..')) then
       begin
           List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name);
       end;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;


end.

