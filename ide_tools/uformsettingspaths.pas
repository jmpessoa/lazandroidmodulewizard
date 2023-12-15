unit uformsettingspaths;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, LazIDEIntf, PackageIntf , Process{, math};

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
    LabelNDKRelease: TLabel;
    LabelPathToGradle: TLabel;
    LabelPathToAndroidSDK: TLabel;
    LabelPathToJavaJDK: TLabel;
    LabelPathToAndroidNDK: TLabel;
    LabelPathToAntBinary: TLabel;
    SelDirDlgPathTo: TSelectDirectoryDialog;
    SpBPathToAndroidSDK: TSpeedButton;
    SpBPathToJavaJDK: TSpeedButton;
    SpBPathToAndroidNDK: TSpeedButton;
    SpBPathToAntBinary: TSpeedButton;
    SpBPathToGradle: TSpeedButton;
    SpeedButtonAnt: TSpeedButton;
    SpeedButtonHelp: TSpeedButton;
    SpeedButtonInfo: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure ComboBoxPrebuildChange(Sender: TObject);
    procedure EditPathToAndroidNDKExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpBPathToAndroidSDKClick(Sender: TObject);
    procedure SpBPathToGradleClick(Sender: TObject);
    procedure SpBPathToJavaJDKClick(Sender: TObject);
    procedure SpBPathToAndroidNDKClick(Sender: TObject);
    procedure SpBPathToAntBinaryClick(Sender: TObject);
    procedure SpeedButtonAntClick(Sender: TObject);
    procedure SpeedButtonHelpClick(Sender: TObject);
    procedure SpeedButtonInfoClick(Sender: TObject);
   // function GetGradleVersion(out tagVersion: integer): string;

    function GetMaxSdkPlatform(out outBuildTool: string): integer;
    function HasBuildTools(platform: integer;  out outBuildTool: string): boolean;
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
    FNDKIndex: integer; {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
    FNDKRelease: string; // 18.1.506304
    FGradleVersion: string;

    procedure WriteIniString(Key, Value: string);

  public
    { public declarations }
    FOk: boolean;
    //FPathTemplatesEdited: boolean;
    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
    function GetPrebuiltDirectory: string;
    function TryGetNDKRelease(pathNDK: string): string;
    function GetNDKVersionItemIndex(ndkRelease: string): integer;
    procedure TryProduceGradleVersion(pathToGradle: string);

  end;

var
   FormSettingsPaths: TFormSettingsPaths;

implementation

uses LamwSettings;

{$R *.lfm}

{ TFormSettingsPaths }

function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;

function IsAllCharNumber(pcString: PChar): Boolean;
begin
  Result := False;
  if StrLen(pcString)=0 then exit;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then Exit;
    Inc(pcString);
  end;
  Result := True;
end;

function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result:= theString;
       theString:= '';
    end;
  end;
end;


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

function TFormSettingsPaths.TryGetNDKRelease(pathNDK: string): string;
var
   list: TStringList;
   strNdkVersion: string;
begin
    list:= TStringList.Create;
    if FileExists(pathNDK+DirectorySeparator+'source.properties') then
    begin
        list.LoadFromFile(pathNDK+DirectorySeparator+'source.properties');
        {
           Pkg.Desc = Android NDK
           Pkg.Revision = 18.1.5063045
        }
        strNdkVersion:= list.Strings[1]; //Pkg.Revision = 18.1.5063045
        SplitStr(strNdkVersion, '='); //aux:= 'Pkg.Revision '   ...strNdkVersion:=' 18.1.506304'
        Result:= Trim(strNdkVersion); //18.1.506304

    end
    else
    begin
       if FileExists(pathNDK+DirectorySeparator+'RELEASE.TXT') then //r10e
       begin
         list.LoadFromFile(pathNDK+DirectorySeparator+'RELEASE.TXT');
         if Trim(list.Strings[0]) = 'r10e' then
            Result:= 'r10e'
         else
         begin
            Result:= 'unknown';
         end;
       end;
    end;
    list.Free;
end;

function TFormSettingsPaths.GetNDKVersionItemIndex(ndkRelease: string): integer;
var
   strNdkVersion: string;
   intNdkVersion: integer;
begin

    if Pos('.',ndkRelease) > 0 then  //18.1.506304
    begin
      strNdkVersion:= SplitStr(ndkRelease, '.'); //strNdkVersion:='18'
      if strNdkVersion <> '' then
      begin
        intNdkVersion:= StrToInt(Trim(strNdkVersion));

        {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
        if intNdkVersion = 11 then Result:= 4
        else if (intNdkVersion > 11) and (intNdkVersion < 22) then Result:= 5
        else if intNdkVersion >= 22 then Result:= 6;

      end;
    end
    else if ndkRelease = 'r10e' then Result:= 3
    else Result := 2; //unknown
end;

procedure TFormSettingsPaths.TryProduceGradleVersion(pathToGradle: string);
var
   AProcess: TProcess;
   AStringList: TStringList;
   gradle, ext, version, aux: string;
   i, p, len, posFinal, count: integer;
begin
  ext:='';
  {$IFDEF windows}
    ext:='.bat';
  {$Endif}
  gradle:= 'gradle'  + ext;

  AStringList:= TStringList.Create;

  AProcess := TProcess.Create(nil);
  AProcess.Executable := pathToGradle + PathDelim + 'bin' + PathDelim + gradle;  //C:\android\gradle-6.8.3\bin\gradle.bat
  AProcess.Options:=AProcess.Options + [poWaitOnExit, poUsePipes, poNoConsole];
  AProcess.Parameters.Add('-version');
  AProcess.Execute;

  AStringList.LoadFromStream(AProcess.Output);
  AProcess.Free;

  if AStringList.Count > 0 then
  begin
    version:= '';
    i:= 0;
    while i < AStringList.Count do
    begin
       p:= Pos('Gradle', AStringList.Strings[i] );
       if p > 0 then
       begin
          version:=  AStringList.Strings[i];
          i:= AStringList.Count; //exit while
       end;
       i:= i +1;
    end;
    posFinal:= LastDelimiter('.', version) + 1; //posFinal
    len:= Length('Gradle');
    count:= posFinal - len;
    aux:= Copy(version, p+len, count);

    FGradleVersion:= Trim(StringReplace(aux,'!', '', [rfReplaceAll])); //mess ??
  end;
  AStringList.Free;
end;


procedure TFormSettingsPaths.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   fName: string;
   outBuildTool: string;
   list: TStringList;
begin

  if FGradleVersion <> '' then
  begin
    list:= TStringList.Create;
    list.Text:= FGradleVersion;
    if not FileExists(FPathToGradle+PathDelim+'version.txt') then
        list.SaveToFile(FPathToGradle + PathDelim + 'version.txt'); //so you don't miss the opportunity
    list.Free;
  end;

  if Self.ModalResult = mrCancel then Exit;

  list:=TStringList.Create;

  if EditPathToGradle.Text <> '' then
  begin
     if FGradleVersion = '' then
         TryProduceGradleVersion(EditPathToGradle.Text);

    if FGradleVersion = '' then
    begin
        list.Text:= Trim(InputBox('warning: Missing Gradle Version', 'Enter Gradle version [ex. 7.6.3]',''));
        if Pos('.', list.Text)  > 0 then
             list.SaveToFile(EditPathToGradle.Text+PathDelim+'version.txt');
    end;
  end;

  fName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
  if FOk then
  begin
    {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
    if FNDKIndex < 3 then
    begin
      ShowMessage('WARNING... Please, update NDK.... ');
    end;
    SaveSettings(fName);
    LamwGlobalSettings.ReloadPaths;
  end;

  if GetMaxSdkPlatform(outBuildTool) < 33 then
  begin
    ShowMessage('Warning. Minimum Target API required by "Google Play Store" = 33'+ sLineBreak +
                 'Please, update your android sdk/platforms folder!' + sLineBreak +
                 'How to:'+ sLineBreak +
                 '.open a command line terminal and go to folder "sdk/tools/bin"'+ sLineBreak +
                 '.run the command> sdkmanager --update'+ sLineBreak +
                 '.run the command> sdkmanager "build-tools;33.0.2" "platforms;android-33"');
  end;
  list.Free;

  CloseAction := caFree;
end;

procedure TFormSettingsPaths.FormShow(Sender: TObject);
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
     ComboBoxPrebuild.Text:= 'windows-x86_64';
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

function TFormSettingsPaths.HasBuildTools(platform: integer;  out outBuildTool: string): boolean;
var
  lisDir: TStringList;
  numberAsString, auxStr: string;
  i, builderNumber,  savedBuilder: integer;
  candidateSdkBuild: string;
begin
  Result:= False;
  savedBuilder:= 0;
  lisDir:= TStringList.Create;   //C:\adt32\sdk\build-tools\19.1.0

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'build-tools', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       lisDir.Strings[i]:=auxStr;
    end;
    lisDir.Sorted:=True;
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= lisDir.Strings[i];
       if  auxStr <> '' then
       begin
         if Pos('rc2', auxStr) = 0 then   //escape some alien...
         begin
           numberAsString:= Copy(auxStr, 1 , 2);  //19
           if IsAllCharNumber(PChar(numberAsString))  then
           begin
               builderNumber:=  StrToInt(numberAsString);

               if savedBuilder < builderNumber then
               begin
                 savedBuilder:= builderNumber;
                 if builderNumber > platform then candidateSdkBuild:= auxStr;
               end;

               if platform <= builderNumber then
               begin
                 candidateSdkBuild:= auxStr;
                 Result:= True;
               end;

               outBuildTool:= candidateSdkBuild; //19.1.0

               if Result then break;
           end;
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

procedure TFormSettingsPaths.BitBtnCancelClick(Sender: TObject);
begin
  FOK:=False;
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
     FNDKRelease:= TryGetNDKRelease(FPathToAndroidNDK);
     FNDKIndex:= GetNDKVersionItemIndex(FNDKRelease);
     LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease;
  end;
end;

procedure TFormSettingsPaths.BitBtnOKClick(Sender: TObject);
begin
   FOk:= True;
   Close;
end;

procedure TFormSettingsPaths.SpBPathToAndroidSDKClick(Sender: TObject);
begin
  if SelDirDlgPathTo.Execute then
  begin
    EditPathToAndroidSDK.Text := SelDirDlgPathTo.FileName;
    FPathToAndroidSDK:= SelDirDlgPathTo.FileName;
  end;
end;

function TFormSettingsPaths.GetMaxSdkPlatform(out outBuildTool: string): integer;
var
  lisDir: TStringList;
  strApi: string;
  i, intApi: integer;
  tempOutBuildTool: string;
begin

  Result:= 0;

  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       strApi:= ExtractFileName(lisDir.Strings[i]);   //android-21
       if strApi <> '' then
       begin
         strApi:= Copy(strApi, LastDelimiter('-', strApi) + 1, MaxInt);
         if IsAllCharNumber(PChar(strApi))  then  //skip android-P
         begin
              intApi:= StrToInt(strApi);
              if Result < intApi then
              begin
                if HasBuildTools(intApi, tempOutBuildTool) then
                begin
                   Result:= intApi;
                   outBuildTool:= tempOutBuildTool;  //26.0.2
                end;
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

    if EditPathToGradle.Text <> '' then
      if FGradleVersion = '' then
         TryProduceGradleVersion(EditPathToGradle.Text);
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

    if FPathToAndroidNDK <> '' then
    begin
      FNDKRelease:= TryGetNDKRelease(FPathToAndroidNDK);
      LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease;
      FNDKIndex:= GetNDKVersionItemIndex(FNDKRelease);
    end;

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

procedure TFormSettingsPaths.SpeedButtonAntClick(Sender: TObject);
begin
     MessageDlg('About Java and Gradle:' +  sLineBreak +
                     '  Java JDK 1.8 need Gradle version <=  6.7' + sLineBreak +
                     '  Java 11 need Gradle version >=  6.7.1' + sLineBreak + sLineBreak +
                'About Java and Ant:' +  sLineBreak +
                     '  Ant need java JDK 1.8 and Android SDK r25.2.5'
                  , mtInformation, [mbOk], 0);
end;

procedure TFormSettingsPaths.SpeedButtonHelpClick(Sender: TObject);
begin
  ShowMessage('Warning/Recomendation:'+
           sLineBreak+
           sLineBreak+'[LAMW 0.8.6.3] recomentations:'+
           sLineBreak+' 1. Java JDK 11 + Gradle version >= 6.7.1' +
           sLineBreak+' 2. Android SDK "plataforms" 33 + "build-tools" 33.0.2'+
           sLineBreak+' 3. Android SDK/Extra  "Support Repository"'+
           sLineBreak+' 4. Android SDK/Extra  "Support Library"'+
           sLineBreak+' 5. Android SDK/Extra  "Google Repository"'+
           sLineBreak+' 6. Android SDK/Extra  "Google Play Services"'+
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
      FNDKRelease:=  ReadString('NewProject','NDKRelease', '');

      if FNDKRelease <> '' then
      begin
         LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease
      end
      else
      begin
         FNDKRelease:= TryGetNDKRelease(FPathToAndroidNDK);
         LabelNDKRelease.Caption:= 'NDK Release: '+FNDKRelease;
         WriteString('NewProject','NDKRelease', FNDKRelease);
      end;

      EditPathToAndroidNDK.Text := FPathToAndroidNDK;
      EditPathToJavaJDK.Text := FPathToJavaJDK;
      EditPathToAndroidSDK.Text := FPathToAndroidSDK;
      EditPathToAntBinary.Text := FPathToAntBin;
      EditpathToGradle.Text := FPathToGradle;

      {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}


      if ReadString('NewProject','NDK', '') <> '' then
      begin
        FNDKIndex:= StrToInt(ReadString('NewProject','NDK', ''));
        if (FNDKIndex < 3)  then
        begin
          ShowMessage('WARNING... Please, update NDK ... ');
        end;
      end;


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

    if (LabelNDKRelease.Caption <> '') then
      WriteString('NewProject', 'NDKRelease', FNDKRelease);

    WriteString('NewProject', 'NDK', IntToStr(FNDKIndex));

    if ComboBoxPrebuild.Text = '' then
    begin
      if FPathToAndroidSDK <> '' then
      begin
         if ComboBoxPrebuild.Text = '' then
           ComboBoxPrebuild.Text:= Self.GetPrebuiltDirectory(); //try guess
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

