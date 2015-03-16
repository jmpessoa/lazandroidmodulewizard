unit uformsettingspaths;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, LazIDEIntf;

type

  { TFormSettingsPaths }

  TFormSettingsPaths  = class(TForm)
    BitBtnOK: TBitBtn;
    BevelSimonsayzTemplateLazBuildAndButtons: TBevel;
    BevelSDKNDKAndSimonsayzTemplateLazBuild: TBevel;
    BevelJDKAntAndSDKNDK: TBevel;
    BitBtnCancel: TBitBtn;
    EditPathToAndroidNDK: TEdit;
    EditPathToSimonsayzTemplate: TEdit;
    EditPathToJavaJDK: TEdit;
    EditPathToAndroidSDK: TEdit;
    EditPathToAntBinary: TEdit;
    LabelPathToAndroidNDK: TLabel;
    LabelPathToSimonsayzTemplate: TLabel;
    LabelPathToJavaJDK: TLabel;
    LabelPathToAndroidSDK: TLabel;
    LabelPathToAntBinary: TLabel;
    RadioGroupPrebuildOSys: TRadioGroup;
    RGNDKVersion: TRadioGroup;
    SelDirDlgPathToAndroidNDK: TSelectDirectoryDialog;
    SelDirDlgPathToSimonsayzTemplate: TSelectDirectoryDialog;
    SelDirDlgPathToJavaJDK: TSelectDirectoryDialog;
    SelDirDlgPathToAndroidSDK: TSelectDirectoryDialog;
    SelDirDlgPathToAntBinary: TSelectDirectoryDialog;
    SpBPathToAndroidNDK: TSpeedButton;
    SpBPathToSimonsayzTemplate: TSpeedButton;
    SpBPathToJavaJDK: TSpeedButton;
    SpBPathToAndroidSDK: TSpeedButton;
    SpBPathToAntBinary: TSpeedButton;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpBPathToAndroidNDKClick(Sender: TObject);
    procedure SpBPathToSimonsayzTemplateClick(Sender: TObject);
    procedure SpBPathToJavaJDKClick(Sender: TObject);
    procedure SpBPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToAntBinaryClick(Sender: TObject);
    function GetRadioGroupPrebuildOSysIndex(prebuildSys: string): integer;
  private
    { private declarations }
    FPathToJavaTemplates: string;
    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPrebuildOSYS: string;
  public
    { public declarations }
    FOk: boolean;
    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
  end;

var
   FormSettingsPaths: TFormSettingsPaths;

implementation

{$R *.lfm}

{ TFormSettingsPaths }

procedure TFormSettingsPaths.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FOk then
    Self.SaveSettings( AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini' );
end;


procedure TFormSettingsPaths.FormShow(Sender: TObject);
begin
   FOk:= False;
   Self.LoadSettings(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
end;

procedure TFormSettingsPaths.FormActivate(Sender: TObject);
begin
  EditPathToJavaJDK.SetFocus;
end;

procedure TFormSettingsPaths.BitBtnCancelClick(Sender: TObject);
begin
  FOk:= False;
  Close;
end;

procedure TFormSettingsPaths.BitBtnOKClick(Sender: TObject);
begin
   FOk:= True;
   Close;
end;

procedure TFormSettingsPaths.SpBPathToAndroidNDKClick(Sender: TObject);
begin
  if SelDirDlgPathToAndroidNDK.Execute then
  begin
    EditPathToAndroidNDK.Text := SelDirDlgPathToAndroidNDK.FileName;
    FPathToAndroidNDK:= SelDirDlgPathToAndroidNDK.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToSimonsayzTemplateClick(Sender: TObject);
begin
  if SelDirDlgPathToSimonsayzTemplate.Execute then
  begin
    EditPathToSimonsayzTemplate.Text := SelDirDlgPathToSimonsayzTemplate.FileName;
    FPathToJavaTemplates:= SelDirDlgPathToSimonsayzTemplate.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToJavaJDKClick(Sender: TObject);
begin
  if SelDirDlgPathToJavaJDK.Execute then
  begin
    EditPathToJavaJDK.Text := SelDirDlgPathToJavaJDK.FileName;
    FPathToJavaJDK:= SelDirDlgPathToJavaJDK.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToAndroidSDKClick(Sender: TObject);
begin
  if SelDirDlgPathToAndroidSDK.Execute then
  begin
    EditPathToAndroidSDK.Text := SelDirDlgPathToAndroidSDK.FileName;
    FPathToAndroidSDK:= SelDirDlgPathToAndroidSDK.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToAntBinaryClick(Sender: TObject);
begin
    if SelDirDlgPathToAntBinary.Execute then
  begin
    EditPathToAntBinary.Text := SelDirDlgPathToAntBinary.FileName;
    FPathToAntBin:= SelDirDlgPathToAntBinary.FileName;
  end;
end;

function TFormSettingsPaths.GetRadioGroupPrebuildOSysIndex(prebuildSys: string): integer;
begin
   if Pos('windows', prebuildSys) > 0 then Result:= 0
   else if Pos('_64', prebuildSys) > 0 then Result:= 3
   else if Pos('linux-x86', prebuildSys) > 0 then Result:= 1
   else if Pos('osx', prebuildSys) > 0 then Result:= 2;
end;

procedure TFormSettingsPaths.LoadSettings(const fileName: string);
var
   indexNdk: integer;
begin
  if FileExistsUTF8(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      EditPathToAndroidNDK.Text := ReadString('NewProject','PathToAndroidNDK', '');
      EditPathToSimonsayzTemplate.Text := ReadString('NewProject','PathToJavaTemplates', '');
      EditPathToJavaJDK.Text := ReadString('NewProject','PathToJavaJDK', '');
      EditPathToAndroidSDK.Text := ReadString('NewProject','PathToAndroidSDK', '');

      EditPathToAntBinary.Text := ReadString('NewProject','PathToAntBin', '');

      if ReadString('NewProject','NDK', '') <> '' then
          indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
          indexNdk:= 2;  //ndk 10

      RGNDKVersion.ItemIndex:= indexNdk;

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if  FPrebuildOSYS <> '' then
         RadioGroupPrebuildOSys.ItemIndex:= GetRadioGroupPrebuildOSysIndex(FPrebuildOSYS)
      else RadioGroupPrebuildOSys.ItemIndex:= 0;
    finally
      Free;
    end;
  end;
end;

procedure TFormSettingsPaths.SaveSettings(const fileName: string);
begin
  with TInifile.Create(fileName) do
  try
      WriteString('NewProject', 'PathToNdkPlataforms', EditPathToAndroidNDK.Text);
      WriteString('NewProject', 'PathToJavaTemplates', EditPathToSimonsayzTemplate.Text);
      WriteString('NewProject', 'PathToJavaJDK', EditPathToJavaJDK.Text);
      WriteString('NewProject', 'PathToAndroidNDK', EditPathToAndroidNDK.Text);
      WriteString('NewProject', 'PathToAndroidSDK', EditPathToAndroidSDK.Text);
      WriteString('NewProject', 'PathToAntBin', EditPathToAntBinary.Text);
      WriteString('NewProject', 'NDK', IntToStr(RGNDKVersion.ItemIndex));

     case RadioGroupPrebuildOSys.ItemIndex of
       0: FPrebuildOSYS:= 'windows';
       1: FPrebuildOSYS:= 'linux-x86';
       2: FPrebuildOSYS:= 'osx';   //TODO: fix here!
       3: FPrebuildOSYS:= 'linux-x86_64';
     end;

     WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);
  finally
     Free;
  end;
end;

end.

