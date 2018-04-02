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
    EditPathToJavaTemplates: TEdit;
    EditPathToAndroidNDK: TEdit;
    EditPathToJavaJDK: TEdit;
    EditPathToAndroidSDK: TEdit;
    EditPathToAntBinary: TEdit;
    GroupBoxPrebuild: TGroupBox;
    Image1: TImage;
    LabelPathToGradle: TLabel;
    LBPathToJavaTemplates: TLabel;
    LabelPathToAndroidNDK: TLabel;
    LabelPathToJavaJDK: TLabel;
    LabelPathToAndroidSDK: TLabel;
    LabelPathToAntBinary: TLabel;
    RGNDKVersion: TRadioGroup;
    SelDirDlgPathToAndroidNDK: TSelectDirectoryDialog;
    SelDirDlgPathToJavaTemplates: TSelectDirectoryDialog;
    SelDirDlgPathToJavaJDK: TSelectDirectoryDialog;
    SelDirDlgPathToAndroidSDK: TSelectDirectoryDialog;
    SelDirDlgPathToAntBinary: TSelectDirectoryDialog;
    SelDirDlgPathToGradle: TSelectDirectoryDialog;
    SpBPathToAndroidNDK: TSpeedButton;
    SpBPathToJavaTemplates: TSpeedButton;
    SpBPathToJavaJDK: TSpeedButton;
    SpBPathToAndroidSDK: TSpeedButton;
    SpBPathToAntBinary: TSpeedButton;
    SpBPathToGradle: TSpeedButton;
    SpeedButtonHelp: TSpeedButton;
    SpeedButtonInfo: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure ComboBoxPrebuildChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpBPathToAndroidNDKClick(Sender: TObject);
    procedure SpBPathToGradleClick(Sender: TObject);
    procedure SpBPathToJavaJDKClick(Sender: TObject);
    procedure SpBPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToAntBinaryClick(Sender: TObject);
    procedure SpBPathToJavaTemplatesClick(Sender: TObject);
    procedure SpeedButtonHelpClick(Sender: TObject);
    procedure SpeedButtonInfoClick(Sender: TObject);
    function GetGradleVersion(out tagVersion: integer): string;
    function GetMaxSdkPlatform(): integer;
    function HasBuildTools(platform: integer): boolean;

  private
    { private declarations }
    FPathToJavaTemplates: string;
    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPrebuildOSYS: string;
    FPathToTemplatePresumed: string;
    FPathToGradle: string;
    //FGradleVersion: string;
  public
    { public declarations }
    FOk: boolean;
    FPathTemplatesEdited: boolean;
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
     Result:=  'windows';
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
     if DirectoryExists(pathToNdkToolchains49 + 'windows-x86_64') then Result:= 'windows-x86_64';

   {$else}
     {$ifdef darwin}
        Result:=  'darwin-x86_64';
        if DirectoryExists(pathToNdkToolchains49+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       Result:=  'linux-x86_64';
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

   if Result = '' then
   begin
       {$ifdef LINUX}
           Result:= 'linux-x86_64';
       {$endif}
       {$ifdef WINDOWS}
           Result:= 'windows';
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
  fName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FOk then
  begin
    SaveSettings(fName);
    LamwGlobalSettings.ReloadPaths;
  end
  else if FPathTemplatesEdited = True then
       begin
         with TInifile.Create(fName) do
         try
           if EditPathToJavaTemplates.Text <> '' then
               WriteString('NewProject', 'PathToJavaTemplates', EditPathToJavaTemplates.Text);
         finally
           Free;
         end;
       end;
end;

procedure TFormSettingsPaths.FormCreate(Sender: TObject);
begin

end;


function TFormSettingsPaths.HasBuildTools(platform: integer): boolean;
var
  lisDir: TStringList;
  numberAsString, builderTool, auxStr: string;
  i, p, builderNumber: integer;
begin
  Result:= False;
  lisDir:= TStringList.Create;   //C:\adt32\sdk\build-tools\19.1.0
  FindAllDirectories(lisDir, FPathToAndroidSDK+PathDelim+'build-tools', False);
  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= lisDir.Strings[i];
       if  auxStr <> '' then
       begin
         if  Pos('rc2', auxStr) = 0  then   //escape some alien...
         begin
           p:= LastDelimiter(PathDelim, auxStr) + 1;
           builderTool:= Copy(lisDir.Strings[i], p, Length(auxStr));
           numberAsString:= Copy(builderTool, 1 , 2);  //19
           builderNumber:=  StrToInt(numberAsString);
           if  platform = builderNumber then Result:= True;
         end;
       end;
    end;
  end;
  lisDir.free;
end;

procedure TFormSettingsPaths.FormActivate(Sender: TObject);
var
  p: integer;
  Pkg: TIDEPackage;
begin

  FOk:= False;
  FPathTemplatesEdited:= False;
  LoadSettings(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
  Pkg:=PackageEditingInterface.FindPackageWithName('amw_ide_tools');

  if Pkg<>nil then
  begin // C:\laz4android\components\androidmodulewizard\ide_tools\  + amw_ide_tools.lpk
    FPathToTemplatePresumed:= ExtractFilePath(Pkg.Filename);
    p:= Pos('ide_tools', FPathToTemplatePresumed);
    FPathToTemplatePresumed:= Copy(FPathToTemplatePresumed, 1, p-1) + 'java';
    if EditPathToJavaTemplates.Text = '' then
    begin
      FPathToJavaTemplates:= FPathToTemplatePresumed;
      EditPathToJavaTemplates.Text:= FPathToTemplatePresumed;
      FPathTemplatesEdited:= True;
    end;
  end;

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

  if  EditPathToGradle.Text =  '' then
  begin
    ShowMessage('Warning/Recomendation:'+
             sLineBreak+
             sLineBreak+'[LAMW 0.8] "AppCompat" [material] theme need:'+
             sLineBreak+' 1. Java JDK 1.8'+
             sLineBreak+' 2. Gradle 4.1 [https://gradle.org/next-steps/?version=4.1&format=bin]' +
             sLineBreak+' 3. Android SDK "plataforms" 25 + "build-tools" 25.0.3 [or]'+
             sLineBreak+' 3. Android SDK "plataforms" 26 + "build-tools" 26.0.3 [or]'+
             sLineBreak+' 3. Android SDK "plataforms" 27 + "build-tools" 27.0.3'+
             sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
             sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
             sLineBreak+' '+
             sLineBreak+' Hint: "Ctrl + C" to copy this content to Clipboard!');

       EditPathToGradle.SetFocus;
  end
  else
    EditPathToJavaJDK.SetFocus;

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

  saveContent:= ComboBoxPrebuild.Text;

  pathToNdkToolchains49:= EditPathToAndroidNDK.Text+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

  if not DirectoryExists(pathToNdkToolchains49+ ComboBoxPrebuild.Text) then
  begin
     ShowMessage('Sorry... Path To Ndk Toolchains "'+ ComboBoxPrebuild.Text + '" Not Found!');
     ComboBoxPrebuild.Text:= saveContent;
  end
  else
     Self.FPrebuildOSYS:= ComboBoxPrebuild.Text;

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

function TFormSettingsPaths.GetMaxSdkPlatform(): integer;
var
  lisDir: TStringList;
  auxStr: string;
  i, intAux: integer;
begin

  Result:= 0;
  lisDir:= TStringList.Create;

  FindAllDirectories(lisDir, FPathToAndroidSDK+PathDelim+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       if lisDir.Strings[i] <> '' then
       begin
         if Pos('P', lisDir.Strings[i]) <= 0  then  //skip android-P
         begin
           auxStr:= lisDir.Strings[i];
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
  if SelDirDlgPathToGradle.Execute then
  begin
    EditPathToGradle.Text:= SelDirDlgPathToGradle.FileName;
    FPathToGradle:= SelDirDlgPathToGradle.FileName;
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
    if SelDirDlgPathToAntBinary.Execute then
  begin
    EditPathToAntBinary.Text := SelDirDlgPathToAntBinary.FileName;
    FPathToAntBin:= SelDirDlgPathToAntBinary.FileName;
  end;
end;

procedure TFormSettingsPaths.SpBPathToJavaTemplatesClick(Sender: TObject);
begin
  if SelDirDlgPathToJavaTemplates.Execute then
  begin
    EditPathToJavaTemplates.Text := SelDirDlgPathToJavaTemplates.FileName;
    FPathToJavaTemplates:= SelDirDlgPathToJavaTemplates.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButtonHelpClick(Sender: TObject);
begin
  ShowMessage('Warning/Recomendation:'+
           sLineBreak+
           sLineBreak+'[LAMW 0.8] "AppCompat" [material] theme need:'+
           sLineBreak+' 1. Java JDK 1.8'+
           sLineBreak+' 2. Gradle 4.1 [https://gradle.org/next-steps/?version=4.1&format=bin]' +
           sLineBreak+' 3. Android SDK "plataforms" 25 + "build-tools" 25.0.3 [or]'+
           sLineBreak+' 3. Android SDK "plataforms" 26 + "build-tools" 26.0.3 [or]'+
           sLineBreak+' 3. Android SDK "plataforms" 27 + "build-tools" 27.0.3'+
           sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
           sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
           sLineBreak+' '+
           sLineBreak+' Hint: "Ctrl + C" to copy this content to Clipboard!');
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
      EditPathToJavaTemplates.Text := FPathToJavaTemplates;

      EditPathToJavaJDK.Text := ReadString('NewProject','PathToJavaJDK', '');
      EditPathToAndroidSDK.Text := ReadString('NewProject','PathToAndroidSDK', '');
      EditPathToAntBinary.Text := ReadString('NewProject','PathToAntBin', '');
      EditpathToGradle.Text :=  ReadString('NewProject','PathToGradle', '');

      if ReadString('NewProject','NDK', '') <> '' then
          indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
          indexNdk:= 3;  //ndk 10e

      RGNDKVersion.ItemIndex:= indexNdk;

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');

      if FPrebuildOSYS <> '' then
      begin
         ComboBoxPrebuild.Text:= FPrebuildOSYS
      end
      else
      begin
          if FPathToAndroidSDK <> '' then
          begin
             FPrebuildOSYS:= Self.GetPrebuiltDirectory();   //try guess
             if FPrebuildOSYS <> '' then
                ComboBoxPrebuild.Text:= FPrebuildOSYS;
          end;
      end;

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

    if EditPathToJavaTemplates.Text <> '' then
      WriteString('NewProject', 'PathToJavaTemplates', EditPathToJavaTemplates.Text);

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
         if ComboBoxPrebuild.Text =  '' then
             ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory();   //try guess
      end;
    end;

    WriteString('NewProject', 'PrebuildOSYS', ComboBoxPrebuild.Text);

  finally
    Free;
  end;
end;

end.

