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
    StatusBar1: TStatusBar;
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
    function GetPrebuiltDirectory: string;

  end;

var
   FormSettingsPaths: TFormSettingsPaths;

implementation

{$R *.lfm}

{ TFormSettingsPaths }

function TFormSettingsPaths.GetPrebuiltDirectory: string;
var
   pathToNdkToolchainsArm46,
   pathToNdkToolchainsArm49,
   pathToNdkToolchainsArm443: string;
begin
   Result:= '';

   pathToNdkToolchainsArm443:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator;

   pathToNdkToolchainsArm46:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                              'arm-linux-androideabi-4.6'+DirectorySeparator+
                                              'prebuilt'+DirectorySeparator;

   pathToNdkToolchainsArm49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

   {$ifdef windows}
     if DirectoryExists(pathToNdkToolchainsArm49+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchainsArm46+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchainsArm443+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     {$ifdef win64}
       if DirectoryExists(pathToNdkToolchainsArm49 + 'windows-x86_64') then Result:= 'windows-x86_64';
     {$endif}
   {$else}
     {$ifdef darvin}
        if DirectoryExists(pathToNdkToolchainsArm49+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       {$ifdef cpu64}
         if DirectoryExists(pathToNdkToolchainsArm49+ 'linux-x86_64') then Result:= 'linux-x86_64';
       {$else}
         if DirectoryExists(pathToNdkToolchainsArm49+ 'linux-x86_32') then
         begin
            Result:= 'linux-x86_32';
            Exit;
         end;
         if DirectoryExists(pathToNdkToolchainsArm46+ 'linux-x86_32') then
         begin
           Result:= 'linux-x86_32';
           Exit;
         end;
         if DirectoryExists(pathToNdkToolchainsArm443+ 'linux-x86_32') then
         begin
           Result:= 'linux-x86_32';
           Exit;
         end;
       {$endif}
     {$endif}
   {$endif}

end;
procedure TFormSettingsPaths.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FOk then
    Self.SaveSettings(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini' );
end;


procedure TFormSettingsPaths.FormShow(Sender: TObject);
begin
   FOk:= False;
   Self.LoadSettings(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
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

procedure TFormSettingsPaths.LoadSettings(const fileName: string);
var
   indexNdk: integer;
begin
  if FileExists(fileName) then
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
          indexNdk:= 3;  //ndk 10e

      RGNDKVersion.ItemIndex:= indexNdk;

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');

    finally
      Free;
    end;
  end;
end;

procedure TFormSettingsPaths.SaveSettings(const fileName: string);
begin
  with TInifile.Create(fileName) do
  try
    if EditPathToAndroidNDK.Text <> '' then
      WriteString('NewProject', 'PathToNdkPlataforms', EditPathToAndroidNDK.Text);

    if EditPathToSimonsayzTemplate.Text <> '' then
      WriteString('NewProject', 'PathToJavaTemplates', EditPathToSimonsayzTemplate.Text);

    if EditPathToJavaJDK.Text <> '' then
      WriteString('NewProject', 'PathToJavaJDK', EditPathToJavaJDK.Text);

    if EditPathToAndroidNDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidNDK', EditPathToAndroidNDK.Text);

    if EditPathToAndroidSDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidSDK', EditPathToAndroidSDK.Text);

    if EditPathToAntBinary.Text <> '' then
      WriteString('NewProject', 'PathToAntBin', EditPathToAntBinary.Text);

    WriteString('NewProject', 'NDK', IntToStr(RGNDKVersion.ItemIndex));

    FPathToAndroidNDK:= EditPathToAndroidSDK.Text;

    if FPathToAndroidNDK <> '' then
        FPrebuildOSYS:= GetPrebuiltDirectory();

    if FPrebuildOSYS <> '' then
      WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);

  finally
    Free;
  end;
end;

end.

