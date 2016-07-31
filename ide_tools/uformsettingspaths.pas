unit uformsettingspaths;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, LazIDEIntf, PackageIntf;

type

  { TFormSettingsPaths }

  TFormSettingsPaths  = class(TForm)
    BitBtnOK: TBitBtn;
    BevelJDKAntAndSDKNDK: TBevel;
    BitBtnCancel: TBitBtn;
    ComboBoxPrebuild: TComboBox;
    EditPathToAndroidNDK: TEdit;
    EditPathToJavaJDK: TEdit;
    EditPathToAndroidSDK: TEdit;
    EditPathToAntBinary: TEdit;
    GroupBoxPrebuild: TGroupBox;
    Image1: TImage;
    LabelPathToAndroidNDK: TLabel;
    LabelPathToJavaJDK: TLabel;
    LabelPathToAndroidSDK: TLabel;
    LabelPathToAntBinary: TLabel;
    RGNDKVersion: TRadioGroup;
    SelDirDlgPathToAndroidNDK: TSelectDirectoryDialog;
    SelDirDlgPathToJavaJDK: TSelectDirectoryDialog;
    SelDirDlgPathToAndroidSDK: TSelectDirectoryDialog;
    SelDirDlgPathToAntBinary: TSelectDirectoryDialog;
    SpBPathToAndroidNDK: TSpeedButton;
    SpBPathToJavaJDK: TSpeedButton;
    SpBPathToAndroidSDK: TSpeedButton;
    SpBPathToAntBinary: TSpeedButton;
    SpeedButtonInfo: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SpBPathToAndroidNDKClick(Sender: TObject);
    procedure SpBPathToJavaJDKClick(Sender: TObject);
    procedure SpBPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToAntBinaryClick(Sender: TObject);
    procedure SpeedButtonInfoClick(Sender: TObject);

  private
    { private declarations }
    FPathToJavaTemplates: string;
    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPrebuildOSYS: string;
    FPathToTemplatePresumed: string;
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
   pathToNdkToolchains46,
   pathToNdkToolchains49,
   pathToNdkToolchains443: string;  //FInstructionSet   [ARM or x86]
begin
    Result:= '';

    pathToNdkToolchains443:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator;

    pathToNdkToolchains46:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                              'arm-linux-androideabi-4.6'+DirectorySeparator+
                                              'prebuilt'+DirectorySeparator;

    pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

   {$ifdef windows}
     if DirectoryExists(pathToNdkToolchains49+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchains46+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchains443+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     {$ifdef win64}
        if DirectoryExists(pathToNdkToolchains49 + 'windows-x86_64') then Result:= 'windows-x86_64';
     {$endif}
   {$else}
     {$ifdef darwin}
        if DirectoryExists(pathToNdkToolchains49+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       {$ifdef cpu64}
         if DirectoryExists(pathToNdkToolchains49+ 'linux-x86_64') then Result:= 'linux-x86_64';
       {$else}
         if DirectoryExists(pathToNdkToolchains49+ 'linux-x86_32') then
         begin
            Result:= 'linux-x86_32';
            Exit;
         end;
         if DirectoryExists(pathToNdkToolchains46+ 'linux-x86_32') then
         begin
           Result:= 'linux-x86_32';
           Exit;
         end;
         if DirectoryExists(pathToNdkToolchains443+ 'linux-x86_32') then
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

procedure TFormSettingsPaths.FormActivate(Sender: TObject);
var
  p: integer;
  Pkg: TIDEPackage;
begin
  Pkg:=PackageEditingInterface.FindPackageWithName('amw_ide_tools');
  if Pkg<>nil then
  begin
    p:= Pos('ide_tools', ExtractFilePath(Pkg.Filename));
    FPathToTemplatePresumed:= Copy(ExtractFilePath(Pkg.Filename), 1, p-1) + 'java';
  end;
  FOk:= False;
  Self.LoadSettings(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');

  {$ifdef windows}
  ComboBoxPrebuild.Items.Add('windows');
  ComboBoxPrebuild.Items.Add('windows-x86_64');
  ComboBoxPrebuild.Text:= 'windows';
  {$endif}

  {$ifdef linux}
  ComboBoxPrebuild.Items.Add('linux-x86_32');
  ComboBoxPrebuild.Items.Add('linux-x86_64');
  ComboBoxPrebuild.Text:= 'linux-x86_64';
  {$endif}

  {$ifdef darwin}
  ComboBoxPrebuild.Items.Add('darwin-x86_64');
  ComboBoxPrebuild.Text:= 'darwin-x86_64';
  {$endif}

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

procedure TFormSettingsPaths.SpBPathToJavaJDKClick(Sender: TObject);
begin
  if SelDirDlgPathToJavaJDK.Execute then
  begin
    EditPathToJavaJDK.Text:= SelDirDlgPathToJavaJDK.FileName;
    FPathToJavaJDK:= SelDirDlgPathToJavaJDK.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToAndroidSDKClick(Sender: TObject);
begin
  if SelDirDlgPathToAndroidSDK.Execute then
  begin
    EditPathToAndroidSDK.Text := SelDirDlgPathToAndroidSDK.FileName;
    FPathToAndroidSDK:= SelDirDlgPathToAndroidSDK.FileName;

    if FPrebuildOSYS = '' then
    begin
      if FPathToAndroidSDK <> '' then
        ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory()  //try guess
    end;
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

procedure TFormSettingsPaths.SpeedButtonInfoClick(Sender: TObject);
begin
  ShowMessage('All settings are stored in the file '+sLineBreak+'"JNIAndroidProject.ini" [lazarus/config]');
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

      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');

      if FPathToJavaTemplates = '' then
      begin
        FPathToJavaTemplates:= FPathToTemplatePresumed;
      end;

      EditPathToJavaJDK.Text := ReadString('NewProject','PathToJavaJDK', '');
      EditPathToAndroidSDK.Text := ReadString('NewProject','PathToAndroidSDK', '');
      EditPathToAntBinary.Text := ReadString('NewProject','PathToAntBin', '');

      if ReadString('NewProject','NDK', '') <> '' then
          indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
          indexNdk:= 3;  //ndk 10e

      RGNDKVersion.ItemIndex:= indexNdk;

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');

      if FPrebuildOSYS <> '' then
       ComboBoxPrebuild.Text:= FPrebuildOSYS;

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

    WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates);

    if EditPathToJavaJDK.Text <> '' then
      WriteString('NewProject', 'PathToJavaJDK', EditPathToJavaJDK.Text);

    if EditPathToAndroidNDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidNDK', EditPathToAndroidNDK.Text);

    if EditPathToAndroidSDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidSDK', EditPathToAndroidSDK.Text);

    if EditPathToAntBinary.Text <> '' then
      WriteString('NewProject', 'PathToAntBin', EditPathToAntBinary.Text);

    WriteString('NewProject', 'NDK', IntToStr(RGNDKVersion.ItemIndex));

    WriteString('NewProject', 'PrebuildOSYS', ComboBoxPrebuild.Text);

  finally
    Free;
  end;
end;

end.

