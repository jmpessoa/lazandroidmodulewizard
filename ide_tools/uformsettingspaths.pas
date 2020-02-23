unit uformsettingspaths;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, LazIDEIntf, PackageIntf {, process, math};

type

  { TFormSettingsPaths }

  TFormSettingsPaths  = class(TForm)
    BevelJDKAntAndSDKNDK: TBevel;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    ComboBoxPrebuild: TComboBox;
    EditPathToGradle: TEdit;
    EditPathToAndroidSDK: TEdit;
    EditPathToJavaJDK: TEdit;
    EditPathToAndroidNDK: TEdit;
    EditPathToAntBinary: TEdit;
    GroupBox1: TGroupBox;
    Image1: TImage;
    LabelPathToGradle: TLabel;
    LabelPathToAndroidSDK: TLabel;
    LabelPathToJavaJDK: TLabel;
    LabelPathToAndroidNDK: TLabel;
    LabelPathToAntBinary: TLabel;
    RGNDKVersion: TRadioGroup;
    SelDirDlgPathTo: TSelectDirectoryDialog;
    SpBPathToAndroidSDK: TSpeedButton;
    SpBPathToJavaJDK: TSpeedButton;
    SpBPathToAndroidNDK: TSpeedButton;
    SpBPathToAntBinary: TSpeedButton;
    SpBPathToGradle: TSpeedButton;
    SpeedButtonHelp: TSpeedButton;
    SpeedButtonInfo: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure ComboBoxPrebuildChange(Sender: TObject);
    procedure EditPathToAndroidNDKExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure LabelPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToGradleClick(Sender: TObject);
    procedure SpBPathToJavaJDKClick(Sender: TObject);
    procedure SpBPathToAndroidNDKClick(Sender: TObject);
    procedure SpBPathToAntBinaryClick(Sender: TObject);
    procedure SpeedButtonHelpClick(Sender: TObject);
    procedure SpeedButtonInfoClick(Sender: TObject);
    function GetGradleVersion(out tagVersion: integer): string;
    function GetMaxSdkPlatform(): integer;
    function HasBuildTools(platform: integer): boolean;
    function GetPathToSmartDesigner(): string;
  private
    { private declarations }
    FPathToJavaTemplates: string;
    FPathToSmartDesigner: string;
    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPrebuildOSYS: string;
    FPathToGradle: string;
    //FGradleVersion: string;
    procedure WriteIniString(Key, Value: string);

  public
    { public declarations }
    FOk: boolean;
    //FPathTemplatesEdited: boolean;
    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
    function GetPrebuiltDirectory: string;

  end;

var
   FormSettingsPaths: TFormSettingsPaths;

implementation

uses LamwSettings;

{$R *.lfm}

{ TFormSettingsPaths }

function TFormSettingsPaths.GetPrebuiltDirectory: string;
var
   pathToNdkToolchains49: string;  //FInstructionSet   [ARM or x86]
begin
    Result:= '';
    if FPathToAndroidNDK = '' then Exit;

    pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;
    {$ifdef windows}
     Result:=  'windows';
     if DirectoryExists(pathToNdkToolchains49+ 'windows-x86_64') then Result:= 'windows-x86_64';
   {$else}
     {$ifdef darwin}
        Result:=  '';
        if DirectoryExists(pathToNdkToolchains49+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       {$ifdef linux}
         Result:=  'linux-x86_32';
         if DirectoryExists(pathToNdkToolchains49+ 'linux-x86_64') then Result:= 'linux-x86_64';
       {$endif}
     {$endif}
   {$endif}

   if Result = '' then
   begin
       {$ifdef WINDOWS}
         Result:= 'windows-x86_64';
       {$endif}
       {$ifdef LINUX}
           Result:= 'linux-x86_64';
       {$endif}
       {$ifdef darwin}
           Result:= 'darwin-x86_64';
       {$endif}
   end;

end;

//C:\adt32\gradle-4.2.1
//C:\adt32\gradle-3.3
function TFormSettingsPaths.GetGradleVersion(out tagVersion: integer): string;
var
   p: integer;
   strAux: string;
   numberAsString: string;
   userString: string;
begin
  Result:='';
  strAux:= Trim(EditpathToGradle.Text);  // C:\adt32\gradle-3.3
  if strAux <> '' then
  begin
     p:= Pos('-', strAux);
     if p > 0 then
     begin
        Result:= Copy(strAux, p+1, MaxInt);  // 3.3
        numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 33
        if Length(numberAsString) < 3 then
        begin
           numberAsString:= numberAsString+ '0'  //330
        end;
        tagVersion:= StrToInt(Trim(numberAsString));
     end;
  end;

  if Result = '' then
  begin
    userString:= '3.3';
    if InputQuery('Gradle', 'Please, Enter Gradle Version', userString) then
    begin
      Result:= Trim(UserString);  // 3.3
      numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 33
      if Length(numberAsString) < 3 then
      begin
         numberAsString:= numberAsString+ '0'  //330
      end;
      tagVersion:= StrToInt(Trim(numberAsString));
    end;
  end;

end;

procedure TFormSettingsPaths.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   fName: string;
begin
  fName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
  if FOk then
  begin
    SaveSettings(fName);
    LamwGlobalSettings.ReloadPaths;
  end;
end;

procedure TFormSettingsPaths.LabelPathToAndroidSDKClick(Sender: TObject);
begin

end;


function TFormSettingsPaths.HasBuildTools(platform: integer): boolean;
var
  lisDir: TStringList;
  numberAsString, auxStr: string;
  i, builderNumber: integer;
begin
  Result:= False;
  lisDir:= TStringList.Create;   //C:\adt32\sdk\build-tools\19.1.0

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'build-tools', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       if  auxStr <> '' then
       begin
         if  Pos('rc2', auxStr) = 0  then   //escape some alien...
         begin
           numberAsString:= Copy(auxStr, 1 , 2);  //19
           builderNumber:=  StrToInt(numberAsString);
           if  platform <= builderNumber then Result:= True;
         end;
       end;
    end;
  end;
  lisDir.free;
end;

procedure TFormSettingsPaths.WriteIniString(Key, Value: string);
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
  if FIniFile <> nil then
  begin
    FIniFile.WriteString('NewProject', Key, Value);
    FIniFile.Free;
    LamwGlobalSettings.ReloadPaths;
  end;
end;

function TFormSettingsPaths.GetPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  Result:= '';
  Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
  if Pkg<>nil then
  begin
      Result:= ExtractFilePath(Pkg.Filename);
      Result:= Result + 'smartdesigner';
      //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
  end;
end;

procedure TFormSettingsPaths.FormActivate(Sender: TObject);
var
 flag: boolean;
begin

  //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
  FPathToSmartDesigner:= GetPathToSmartDesigner();

  //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java
  FPathToJavaTemplates:= FPathToSmartDesigner  + PathDelim + 'java';

  flag:= false;
  if not FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini') then
  begin
    if FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini') then
    begin
       CopyFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini',
                IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
       flag:= True;
       //DeleteFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
    end;
  end;

  if flag then  //exists  'LAMW.ini'
  begin
    WriteIniString('PathToJavaTemplates', FPathToJavaTemplates);
    WriteIniString('PathToSmartDesigner', FPathToSmartDesigner);
  end;

  LoadSettings(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');

  FOk:= False;

  {$ifdef windows}
  ComboBoxPrebuild.Items.Add('windows');
  ComboBoxPrebuild.Items.Add('windows-x86_64');
  if Self.FPrebuildOSYS <> '' then
      ComboBoxPrebuild.Text:= FPrebuildOSYS
  else
     ComboBoxPrebuild.Text:= 'windows';
  {$endif}

  {$ifdef linux}
  ComboBoxPrebuild.Items.Add('linux-x86_32');
  ComboBoxPrebuild.Items.Add('linux-x86_64');
  if Self.FPrebuildOSYS <> '' then
      ComboBoxPrebuild.Text:= FPrebuildOSYS
  else
     ComboBoxPrebuild.Text:= 'linux-x86_64';
  {$endif}

  {$ifdef darwin}
  ComboBoxPrebuild.Items.Add('darwin-x86_64');
  ComboBoxPrebuild.Text:= 'darwin-x86_64';
  {$endif}

  EditPathToJavaJDK.SetFocus;

  {$ifdef darwin}
    if EditPathToJavaJDK.Text = '' then
       EditPathToJavaJDK.Text:= '${/usr/libexec/java_home}';
  {$endif}

end;

procedure TFormSettingsPaths.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSettingsPaths.ComboBoxPrebuildChange(Sender: TObject);
var
 pathToNdkToolchains49: string;
 saveContent: string;
begin
  if EditPathToAndroidNDK.Text = '' then
  begin
    ShowMessage('Please, Enter "Path To Android NDK..."');
    Exit;
  end;

  saveContent:= FPrebuildOSYS;

  pathToNdkToolchains49:= EditPathToAndroidNDK.Text+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

  if not DirectoryExists(pathToNdkToolchains49 + ComboBoxPrebuild.Text) then
  begin
     ShowMessage('Sorry... Path To Ndk Toolchains "'+ ComboBoxPrebuild.Text + '" Not Found!');
     ComboBoxPrebuild.Text:= saveContent;
  end
  else
     Self.FPrebuildOSYS:= ComboBoxPrebuild.Text;

end;

procedure TFormSettingsPaths.EditPathToAndroidNDKExit(Sender: TObject);
begin
  if EditPathToAndroidNDK.Text <> '' then
  begin
     FPathToAndroidNDK:= EditPathToAndroidNDK.Text;
     ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory();
  end;
end;

procedure TFormSettingsPaths.BitBtnOKClick(Sender: TObject);
begin
   if RGNDKVersion.ItemIndex > -1 then
   begin
     FOk:= True;
     Close;
   end
   else ShowMessage('Please, Select [Radio] "NDK Version" number!!!');
end;

procedure TFormSettingsPaths.SpBPathToAndroidSDKClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToAndroidSDK.Text := SelDirDlgPathTo.FileName;
    FPathToAndroidSDK:= SelDirDlgPathTo.FileName;
  end;
end;

function TFormSettingsPaths.GetMaxSdkPlatform(): integer;
var
  lisDir: TStringList;
  auxStr: string;
  i, intAux: integer;
begin
  Result:= 0;

  lisDir:= TStringList.Create;

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       if auxStr <> '' then
       begin
         if Pos('P', auxStr) <= 0  then  //skip android-P
         begin
           auxStr:= Copy(auxStr, LastDelimiter('-', auxStr) + 1, MaxInt);
           intAux:= StrToInt(auxStr);
           if Result < intAux then
           begin
             if HasBuildTools(intAux) then
                Result:= intAux;
           end;
         end;
       end;
    end;
  end;

  lisDir.free;
end;


procedure TFormSettingsPaths.SpBPathToGradleClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToGradle.Text:= SelDirDlgPathTo.FileName;
    FPathToGradle:= SelDirDlgPathTo.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToJavaJDKClick(Sender: TObject);
begin
//  {$ifndef darwin}
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToJavaJDK.Text:= SelDirDlgPathTo.FileName;
    FPathToJavaJDK:= SelDirDlgPathTo.FileName;
  end;
//  {$endif}
end;

procedure TFormSettingsPaths.SpBPathToAndroidNDKClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToAndroidNDK.Text := SelDirDlgPathTo.FileName;
    FPathToAndroidNDK:= SelDirDlgPathTo.FileName;

    if FPrebuildOSYS = '' then
    begin
      if FPathToAndroidNDK <> '' then
      begin
         FPrebuildOSYS:= Self.GetPrebuiltDirectory();   //try guess
         if FPrebuildOSYS <> '' then
            ComboBoxPrebuild.Text:= FPrebuildOSYS;
      end;
    end;
  end;
end;

procedure TFormSettingsPaths.SpBPathToAntBinaryClick(Sender: TObject);
begin
    if SelDirDlgPathTo.Execute then
  begin
    EditPathToAntBinary.Text := SelDirDlgPathTo.FileName;
    FPathToAntBin:= SelDirDlgPathTo.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButtonHelpClick(Sender: TObject);
begin
  ShowMessage('Warning/Recomendation:'+
           sLineBreak+
           sLineBreak+'[LAMW 0.8.5] "AppCompat" [material] theme need:'+
           sLineBreak+' 1. Java JDK 1.8'+
           sLineBreak+' 2. Gradle 4.4.1 [or up] [https://gradle.org/next-steps/?version=4.1&format=bin]' +
           sLineBreak+' 3. Android SDK "plataforms" 28 + "build-tools" 28.0.3 [or up]'+
           sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
           sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
           sLineBreak+' 6. Android SDK/Extra  "Google Repository"'+
           sLineBreak+' 7. Android SDK/Extra  "Google Play Services"'+
           sLineBreak+' '+
           sLineBreak+' Hint: "Ctrl + C" to copy this content to Clipboard!');
end;

procedure TFormSettingsPaths.SpeedButtonInfoClick(Sender: TObject);
begin
  ShowMessage('All settings are stored in the file '+sLineBreak+'"LAMW.ini" '+ sLineBreak +
  'ex1. "laz4Android/config"' + sLineBreak +
  'ex2. "C:\Users\...\AppData\Local\lazarus"');
end;

procedure TFormSettingsPaths.LoadSettings(const fileName: string);
var
   indexNdk: integer;
   pathToNdkToolchains49: string;
begin

  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      FPathToAndroidNDK := ReadString('NewProject','PathToAndroidNDK', '');
      FPathToJavaJDK := ReadString('NewProject','PathToJavaJDK', '');
      FPathToAndroidSDK := ReadString('NewProject','PathToAndroidSDK', '');
      FPathToAntBin := ReadString('NewProject','PathToAntBin', '');
      FPathToGradle :=  ReadString('NewProject','PathToGradle', '');

      EditPathToAndroidNDK.Text := FPathToAndroidNDK;
      EditPathToJavaJDK.Text := FPathToJavaJDK;
      EditPathToAndroidSDK.Text := FPathToAndroidSDK;
      EditPathToAntBinary.Text := FPathToAntBin;
      EditpathToGradle.Text := FPathToGradle;

      if ReadString('NewProject','NDK', '') <> '' then
        indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
        indexNdk:= 3;  //ndk 10e

      RGNDKVersion.ItemIndex:= indexNdk;
      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if FPrebuildOSYS <> '' then
      begin
        pathToNdkToolchains49:= EditPathToAndroidNDK.Text+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                      'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                      'prebuilt'+DirectorySeparator;
        if DirectoryExists(pathToNdkToolchains49 + FPrebuildOSYS) then
        begin
            ComboBoxPrebuild.Text:= FPrebuildOSYS;
        end
        else
        begin
           FPrebuildOSYS:= Self.GetPrebuiltDirectory();
           ComboBoxPrebuild.Text:= FPrebuildOSYS;
           WriteIniString('PrebuildOSYS', FPrebuildOSYS);
        end;
      end
      else
      begin
          if FPathToAndroidSDK <> '' then
          begin
             FPrebuildOSYS:= Self.GetPrebuiltDirectory();   //try guess
             if FPrebuildOSYS <> '' then
             begin
                ComboBoxPrebuild.Text:= FPrebuildOSYS;
                WriteIniString('PrebuildOSYS', FPrebuildOSYS);
             end;
          end;
      end;
    finally
      Free;
    end;
  end;

end;

procedure TFormSettingsPaths.SaveSettings(const fileName: string);
var
   pathToNdkToolchains49: string;
begin

  with TInifile.Create(fileName) do
  try

    WriteString('NewProject', 'PathToSmartDesigner', FPathToSmartDesigner);
    WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates);

    if EditPathToJavaJDK.Text <> '' then
      WriteString('NewProject', 'PathToJavaJDK', EditPathToJavaJDK.Text);

    if EditPathToAndroidNDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidNDK', EditPathToAndroidNDK.Text);

    if EditPathToAndroidSDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidSDK', EditPathToAndroidSDK.Text);

    if EditPathToAntBinary.Text <> '' then
      WriteString('NewProject', 'PathToAntBin', EditPathToAntBinary.Text);

    if (EditPathToGradle.Text <> '') then
      WriteString('NewProject', 'PathToGradle', EditPathToGradle.Text);

    WriteString('NewProject', 'NDK', IntToStr(RGNDKVersion.ItemIndex));

    if ComboBoxPrebuild.Text = '' then
    begin
      if FPathToAndroidSDK <> '' then
      begin
         if ComboBoxPrebuild.Text = '' then
           ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory();   //try guess
      end;
    end
    else
    begin

      pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator + ComboBoxPrebuild.Text;

      if not DirectoryExists(pathToNdkToolchains49) then
         ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory();

    end;

    WriteString('NewProject', 'PrebuildOSYS', ComboBoxPrebuild.Text);
  finally
    Free;
  end;
end;

end.

