unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LazIDEIntf,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, FormPathMissing, PackageIntf;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    BitBtnCancel: TBitBtn;
    BitBtnOK: TBitBtn;
    CheckBoxLibrary: TCheckBox;
    CheckBoxSupport: TCheckBox;
    CheckBoxPIE: TCheckBox;
    cbBuildSystem: TComboBox;
    Label1: TLabel;
    ListBoxNdkPlatform: TComboBox;
    ListBoxMinSDK: TComboBox;
    ListBoxTargetAPI: TComboBox;
    ComboBoxTheme: TComboBox;
    ComboSelectProjectName: TComboBox;
    EditPackagePrefaceName: TEdit;
    EditPathToWorkspace: TEdit;
    edProjectName: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    LabelTheme: TLabel;
    LabelPathToWorkspace: TLabel;
    LabelSelectProjectName: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelPlatform: TPanel;
    PanelButtons: TPanel;
    PanelRadioGroup: TPanel;
    RGInstruction: TRadioGroup;
    SelDirDlgPathToWorkspace: TSelectDirectoryDialog;
    SpdBtnPathToWorkspace: TSpeedButton;
    SpdBtnRefreshProjectName: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButtonHintTheme: TSpeedButton;
    StatusBarInfo: TStatusBar;

    procedure cbBuildSystemCloseUp(Sender: TObject);
    procedure CheckBoxLibraryClick(Sender: TObject);  // raw library
    procedure CheckBoxPIEClick(Sender: TObject);
    procedure CheckBoxSupportChange(Sender: TObject);
    procedure CheckBoxSupportClick(Sender: TObject);
    procedure ComboBoxThemeChange(Sender: TObject);
    procedure ComboSelectProjectNameKeyPress(Sender: TObject; var Key: char);
    procedure EditPathToWorkspaceExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure ListBoxMinSDKChange(Sender: TObject);
    procedure ListBoxNdkPlatformChange(Sender: TObject);
    procedure ListBoxTargetAPIChange(Sender: TObject);
    procedure ListBoxTargetAPICloseUp(Sender: TObject);
    procedure RGInstructionClick(Sender: TObject);

    procedure SpdBtnPathToWorkspaceClick(Sender: TObject);
    procedure SpdBtnRefreshProjectNameClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButtonSDKPlusClick(Sender: TObject);
    procedure SpeedButtonHintThemeClick(Sender: TObject);
    function IsLaz4Android(): boolean;
  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}
    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;
    FPathToSmartDesigner: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPathToGradle: string;

    FProjectModel: string;
    FModuleType: integer;  //-1:gdx 0: GUI project   1: NoGui project   2: NoGUI Exe
    FSmallProjName: string;
    FPackagePrefaceName: string;

    FMinApi: string;
    FTargetApi: string;

    FSupport: boolean;

    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;  //Simon "App"
    FNDK: string;
    FNDKIndex: integer;
    FAndroidNdkPlatform: string;   //android-15

    FPrebuildOSYS: string;
    FFullJavaSrcPath: string;
    FJavaClassName: string;
    FAndroidTheme: string;
    FPieChecked: boolean;
    FLibraryChecked: boolean;  //raw .so
    FGradleVersion: string;

    FMaxSdkPlatform: integer;
    FMaxNdkPlatform: integer;
    FCandidateSdkPlatform: integer;
    FHasSdkToolsAnt: boolean;
    FIniFileSection: string;
    FIniFileName: string;
    FInstructionSetIndex: integer;

    function GetBuildSystem: string;
    function HasBuildTools(platform: integer; out outBuildTool: string): boolean;
    function GetGradleVersion(out tagVersion: integer): string;
    function IsSdkToolsAntEnable: boolean;
    procedure WriteIniString(Key, Value: string);
    function DoPathToSmartDesigner(): string;
    function DoNewPathToJavaTemplate(): string;

  public
    { public declarations }
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    function GetTextByListIndex(index:integer): string;

    function GetCodeNameByApi(api: string):string;
    function GetNDKPlatformByApi(api: string): string;

    function GetFullJavaSrcPath(fullProjectName: string): string;
    function GetPrebuiltDirectory: string;
    procedure LoadPathsSettings(const fileName: string);
    function GetEventSignature(nativeMethod: string): string;

    function GetMaxSdkPlatform(): integer;
    function GetBuildTool(sdkApi: integer): string;

    function GetMaxNdkPlatform(var index: integer): integer;

    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;
    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property PathToSmartDesigner: string  read FPathToSmartDesigner write FPathToSmartDesigner;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;

    property PathToJavaJDK: string read FPathToJavaJDK write FPathToJavaJDK;
    property PathToAndroidSDK: string read FPathToAndroidSDK write FPathToAndroidSDK;
    property PathToAndroidNDK: string read FPathToAndroidNDK write FPathToAndroidNDK;
    property PathToAntBin: string read FPathToAntBin write FPathToAntBin;
    property PathToGradle: string read FPathToGradle write FPathToGradle;
    property ProjectModel: string read FProjectModel write FProjectModel; {eclipse or ant}
    property PackagePrefaceName: string read FPackagePrefaceName write FPackagePrefaceName;
    property MinApi: string read FMinApi write FMinApi;
    property TargetApi: string read FTargetApi write FTargetApi;
    property Support: boolean read FSupport write FSupport;
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
    property NDK: string read FNDK write FNDK;
    property NDKIndex: integer read FNDKIndex write FNDKIndex;
    property AndroidPlatform: string read FAndroidNdkPlatform write FAndroidNdkPlatform;

    property PrebuildOSYS: string read FPrebuildOSYS write FPrebuildOSYS;
    property FullJavaSrcPath: string read FFullJavaSrcPath write FFullJavaSrcPath;
    property JavaClassName: string read   FJavaClassName write FJavaClassName;
    property ModuleType: integer read FModuleType write FModuleType;  //-1: gdx 0: GUI project   1: NoGui project
    property SmallProjName: string read FSmallProjName write FSmallProjName;
    property AndroidTheme: string read FAndroidTheme write FAndroidTheme;
    property PieChecked: boolean read FPieChecked write FPieChecked;
    property LibraryChecked: boolean read FLibraryChecked write FLibraryChecked; //raw .so
    property BuildSystem: string read GetBuildSystem;
    property MaxSdkPlatform: integer read FMaxSdkPlatform write FMaxSdkPlatform;
    property GradleVersion: string read FGradleVersion write FGradleVersion;
  //  property LAMWHintChecked: boolean read FLAMWHintChecked write FLAMWHintChecked;

  end;

  function TrimChar(query: string; delimiter: char): string;
  function SplitStr(var theString: string; delimiter: string): string;
  function GetFiles(const StartDir: String; const List: TStrings): Boolean;
  function ReplaceChar(const query: string; oldchar, newchar: char): string;
  function IsAllCharNumber(pcString: PChar): Boolean;

var
   FormWorkspace: TFormWorkspace;

implementation

uses LamwSettings;

{$R *.lfm}

{ TFormWorkspace }

//C:\adt32\ndk10e\platforms\
function TFormWorkspace.GetMaxNdkPlatform(var index: integer): integer;
var
  lisDir: TStringList;
  auxStr: string;
  i, intAux,  count: integer;
begin
  Result:= 0;
  index:= -1;
  count:= 0;

  lisDir:= TStringList.Create;

  ListBoxNdkPlatform.Clear;

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidNdk)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       if auxStr <> '' then
       begin
         auxStr:= Copy(auxStr, LastDelimiter('-', auxStr) + 1, MaxInt);
         if IsAllCharNumber(PChar(auxStr))  then  //skip android-P
         begin
           intAux:= StrToInt(auxStr);
           if (intAux > 13) and (intAux < 27)  then
           begin
              ListBoxNdkPlatform.Items.Add(auxStr);
              count:= count + 1;
           end;
           if Result < intAux then
           begin
             if intAux < 23 then
             begin
                Result:= intAux;   //Max=22 for old 4.x, 5.x devices compatibility!!!!
                index:= count - 1;
             end;
           end;
         end;
       end;
    end;
    if ListBoxNdkPlatform.Items.Count > 0 then
       ListBoxNdkPlatform.ItemIndex:= ListBoxNdkPlatform.Items.Count-1;
  end else ShowMessage('Fail! Folder ' + IncludeTrailingPathDelimiter(FPathToAndroidNdk)+'platforms is empty!');
  lisDir.free;

end;

function TFormWorkspace.GetMaxSdkPlatform(): integer;
var
  lisDir: TStringList;
  strApi: string;
  i, intApi: integer;
  outBuildTool: string;
begin
  Result:= 0;
  FCandidateSdkPlatform:= 0;

  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       strApi:= ExtractFileName(lisDir.Strings[i]);
       if strApi <> '' then
       begin
         strApi:= Copy(strApi, LastDelimiter('-', strApi) + 1, MaxInt);
         if IsAllCharNumber(PChar(strApi))   then  //skip android-P
         begin
             intApi:= StrToInt(strApi);
             if FCandidateSdkPlatform < intApi then FCandidateSdkPlatform:= intApi;
             if Result < intApi then
             begin
               FCandidateSdkPlatform:= intApi;
               if HasBuildTools(intApi, outBuildTool) then Result:= intApi;
             end;
         end;
       end;
    end;
  end;

  lisDir.free;
end;


function TFormWorkspace.GetCodeNameByApi(api: string):string;
begin
  Result:= 'Unknown';
  if api='13' then Result:= 'Honeycomb 3.2'
  else if api='14' then Result:= 'IceCream 4.0'
  else if api='15' then Result:= 'IceCream 4.0x'
  else if api='16' then Result:= 'JellyBean 4.1'
  else if api='17' then Result:= 'JellyBean 4.2'
  else if api='18' then Result:= 'JellyBean 4.3'
  else if api='19' then Result:= 'KitKat 4.4'
  else if api='20' then Result:= 'KitKat 4.4x'
  else if api='21' then Result:= 'Lollipop 5.0'
  else if api='22' then Result:= 'Lollipop 5.1'
  else if api='23' then Result:= 'Marshmallow 6.0'
  else if api='24' then Result:= 'Nougat 7.0'
  else if api='25' then Result:= 'Nougat 7.1'
  else if api='26' then Result:= 'Oreo 8.0'
  else if api='27' then Result:= 'Oreo 8.1'
  else if api='28' then Result:= 'Pie 9.0'
  else if api='29' then Result:= 'Android 10';
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByListIndex(index:integer): string;
begin
   Result:= '';
   case index of
     // tk
     //0: Result:= 'Honeycomb 3.0x'; // Api(11)
     //1: Result:= 'Honeycomb 3.1x'; // Api(12)
     0: Result:= 'Honeycomb 3.2'; // Api(13)
     1: Result:= 'IceCream 4.0'; // Api(14)
     // end tk
     2: Result:= 'IceCream 4.0x'; // Api(15)
     3: Result:= 'JellyBean 4.1'; // Api(16)
     4: Result:= 'JellyBean 4.2'; // Api(17)
     5: Result:= 'JellyBean 4.3'; // Api(18)
     6: Result:= 'KitKat 4.4'; // Api(19)
     7: Result:= 'KitKat 4.4W'; // Api(20)
     8: Result:= 'Lollipop 5.0'; // Api(21)
     9: Result:= 'Lollipop 5.1'; // Api(22)
     10: Result:= 'Marshmallow 6.0'; // Api(23)
     11: Result:= 'Nougat 7.0'; // Api(24)
     12: Result:= 'Nougat 7.1'; // Api(25)
     13: Result:= 'Oreo 8.0'; // Api(26)
     14: Result:= 'Oreo 8.1'; // Api(27)
     15: Result:= 'Pie 9.0'; // Api(28)
     16: Result:= 'Android 10'; // Api(29)
   end;
end;


procedure TFormWorkspace.ListBoxNdkPlatformChange(Sender: TObject);
var
  ndkApi: string;
  intNdkApi: integer;
begin

 if ListBoxNdkPlatform.ItemIndex >=  0 then
 begin

   ndkApi:= ListBoxNdkPlatform.Items[ListBoxNdkPlatform.ItemIndex];
   if ndkApi = '' then Exit;

   FAndroidNdkPlatform:= 'android-'+ ndkApi;
   StatusBarInfo.Panels.Items[0].Text:='[Ndk] '+ GetCodeNameByApi(ListBoxNdkPlatform.Items[ListBoxNdkPlatform.ItemIndex]);

   if IsAllCharNumber(PChar(ndkApi))  then  //skip android-P
        intNdkApi:=StrToInt(ndkApi)
   else
       intNdkApi:= 22;

   if intNdkApi  > 22 then
      ShowMessage('Warning: for compatibility with old devices [4.x, 5.x]'+sLIneBreak+
                  'is strongly recommended NDK API < 23!');

   if (intNdkApi  < 21) and (Self.RGInstruction.ItemIndex = 5) then
      ShowMessage('Warning: ARMv8 [aarch64] nedd  NDK Api >= 21');

   if (intNdkApi  < 21) and (Self.RGInstruction.ItemIndex = 6) then
      ShowMessage('Warning: x86_64 nedd  NDK Api >= 21');
 end;
 //else ShowMessage('Fail! Folder ' + IncludeTrailingPathDelimiter(FPathToAndroidNdk)+'platforms is empty!');

end;

procedure TFormWorkspace.ListBoxTargetAPIChange(Sender: TObject);
var
  intTarqetApi: integer;
begin
  if ListBoxTargetAPI.ItemIndex >=0 then
  begin
    if ListBoxTargetAPI.Text <> '' then
       FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];

    if not IsAllCharNumber(PChar(FTargetApi))  then
      FTargetApi:= '29';

    intTarqetApi:= StrToInt(FTargetApi);
    if intTarqetApi  < 29 then
       ShowMessage('Warning: remember that "google play" store NOW equires Target Api >= 29 !');

  end;
end;

procedure TFormWorkspace.ListBoxTargetAPICloseUp(Sender: TObject);
var
  intApi: integer;
begin
  if (Pos('AppCompat', ComboBoxTheme.Text) > 0) then
  begin
   intApi:= StrToInt(ListBoxTargetAPI.Text);

   if intApi < 29  then
   begin
     ShowMessage('AppCompat theme need Target Api >= 29'+ sLineBreak + '[android-sdk/platforms/android-29]');
   end;

  end;
end;

procedure TFormWorkspace.RGInstructionClick(Sender: TObject);
var
  minNdkApi: integer;
begin
  Self.FInstructionSetIndex:= RGInstruction.ItemIndex;
  FInstructionSet:= 'ARMV7A';
  FFPUSet:= ''; //x86  or mipsel
  case FInstructionSetIndex of
   0:  begin
        FFPUSet:= 'Soft';
        FInstructionSet:='ARMV6';
       end;
   1:  begin
         FFPUSet:= 'Soft';
         FInstructionSet:='ARMV7A';
       end;
   2:  begin
         FFPUSet:= 'VFPV3';
         FInstructionSet:='ARMV7A';
       end;
   3:  FInstructionSet:='x86';
   4:  FInstructionSet:='Mipsel';
   5:  begin //need Api tarqet >= 21
         FInstructionSet:='ARMV8';    //aarch64
       end;
   6:  begin //need Api tarqet >= 21
         FInstructionSet:='x86_64';    //x86_64
       end;
  end;

  if (FInstructionSetIndex = 2) and (IsLaz4Android) then
  begin
     ShowMessage('WARNING: "laz4Android 1.8.0/2.0.0" [out-of-box]'+ sLineBreak + 'don''t support "ARMV7a + VFPv3"' + sLineBreak +
     sLineBreak +'Hint: Select "ARMv7a + Soft"');
  end;

  if (FInstructionSetIndex = 5) and (IsLaz4Android) then
  begin
    ShowMessage('WARNING: "laz4Android 1.8.0/2.0.0" [out-of-box]' + sLineBreak + 'don''t support "aarch64"' + sLineBreak +
    sLineBreak +'Hint: Select "ARMv7a + Soft"');
  end;

  if (FInstructionSetIndex = 6) and (IsLaz4Android) then
  begin
    ShowMessage('WARNING: "laz4Android 1.8.0/2.0.0" [out-of-box]' + sLineBreak + 'don''t support "x86_64"' + sLineBreak +
    sLineBreak +'Hint: Select "x86"');
  end;

  if FInstructionSetIndex = 5 then
  begin
     minNdkApi:=StrToInt(ListBoxNdkPlatform.Items.Strings[ListBoxNdkPlatform.ItemIndex]);
     if minNdkApi < 21 then ShowMessage('Warning: "aarch64" need NDK Api >= 21 ...');
  end;

  if FInstructionSetIndex = 6 then
  begin
     minNdkApi:=StrToInt(ListBoxNdkPlatform.Items.Strings[ListBoxNdkPlatform.ItemIndex]);
     if minNdkApi < 21 then ShowMessage('Warning: "x86_64" need NDK Api >= 21 ...');
  end;

end;

function TFormWorkspace.IsLaz4Android(): boolean;
var
  pathToConfig, pathToLaz: string;
  p: integer;
begin
 Result:= False;
 {$ifdef windows}
 pathToConfig:= LazarusIDE.GetPrimaryConfigPath();
 p:= Pos('config',pathToConfig);
 if p > 0 then
 begin
   pathToLaz:= Copy(pathToConfig,1,p-1);
   if FileExists(pathToLaz+'laz4android_readme.txt') then
     Result:= True;
 end;
 {$endif}
end;

function TFormWorkspace.GetNDKPlatformByApi(api: string): string;
begin
  Result:= 'android-'+api;
end;


function TFormWorkspace.GetFullJavaSrcPath(fullProjectName: string): string;
var
  strList: TStringList;
  count: integer;
  path: string;

begin
    strList:= TStringList.Create;
    path:= fullProjectName+DirectorySeparator+'src';
    FindAllDirectories(strList, path, False);
    count:= strList.Count;
    while count > 0 do
    begin
       path:= strList.Strings[0];
       strList.Clear;
       FindAllDirectories(strList, path, False);
       count:= strList.Count;
    end;
    Result:= path;
    strList.Free;
end;

function TFormWorkspace.GetPrebuiltDirectory: string;
var
   pathToNdkToolchains49: string;  //   [ARM or x86]
begin
    Result:= '';
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


procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  strList: TStringList;
  count, i, j, apiTarg: integer;
  path, tempStr: string;
  aList: TStringList;
begin

  if ModalResult = mrCancel  then Exit;

  FMainActivity:= 'App'; //TODO: flexibility here...

  FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];

  apiTarg:= StrToInt(FTargetApi);

  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

  if not IsAllCharNumber(PChar(FMinApi))  then FMinApi:= '14';
  if not IsAllCharNumber(PChar(FTargetApi)) then FTargetApi:= '29';

  if StrToInt(FMinApi) > apiTarg then FMinApi:= IntToStr(apiTarg);

  if Pos('AppCompat', ComboBoxTheme.Text) > 0 then
  begin
     if StrToInt(FMinApi) < 14 then FMinApi:= '14'
  end;

  //SaveWorkSpaceSettings(FFileName);

  if apiTarg < 14 then
    FAndroidTheme:= 'Holo.Light'
  else
    FAndroidTheme:= 'DeviceDefault';

  if ComboBoxTheme.Text <> 'DeviceDefault' then
    FAndroidTheme:= ComboBoxTheme.Text;

  if EditPathToWorkspace.Text = '' then
  begin
    ShowMessage('Error! Workspace Path was missing....[Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if Pos(' ', EditPathToWorkspace.Text) > 0 then
  begin
    ShowMessage('Error! Path to Workspace contains space character....[Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if ComboSelectProjectName.Text = '' then
  begin
    ShowMessage('Error! Projec Name was missing.... [Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  FJavaClassName:= 'Controls'; //GUI  [try guess]

  if Pos(DirectorySeparator, ComboSelectProjectName.Text) <= 0 then
  begin
     FProjectModel:= 'Ant';   //please, read as "project not exists or new project"!
     FSmallProjName:= StringReplace(ComboSelectProjectName.Text,' ','',[rfReplaceAll]);
     FAndroidProjectName:= FPathToWorkspace + DirectorySeparator+ FSmallProjName;
       FPackagePrefaceName:= LowerCase(Trim(EditPackagePrefaceName.Text));
       if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';
       if FModuleType > 0 then //NoGUI
          FJavaClassName:=  FSmallProjName;
  end
  else
  begin
     FProjectModel:= 'Eclipse';  //please, read as "project exists!"
     FAndroidProjectName:= Trim(ComboSelectProjectName.Text); //full
     aList:= TStringList.Create;
     aList.StrictDelimiter:= True;
     aList.Delimiter:= DirectorySeparator;
     aList.DelimitedText:= TrimChar(FAndroidProjectName, DirectorySeparator);
     FSmallProjName:=  aList.Strings[aList.Count-1];; //ex. "AppTest1"
     FPackagePrefaceName:= '';
     aList.Free;
     if FModuleType > 0 then  //NoGUI
       FJavaClassName:=  FSmallProjName //ex. "AppTest1"
  end;

  FAndroidNdkPlatform:= GetNDKPlatformByApi(ListBoxNdkPlatform.Items.Strings[ListBoxNdkPlatform.ItemIndex]); //(ListBoxNdkPlatform.Items.Strings[ListBoxNdkPlatform.ItemIndex]);

  if FProjectModel = 'Eclipse' then ////please, read as "project exists!"
  begin

     strList:= TStringList.Create;
     if not DirectoryExists(FAndroidProjectName+DirectorySeparator+'.settings') then
     begin
       CreateDir(FAndroidProjectName+DirectorySeparator+'.settings');
       strList.Add('eclipse.preferences.version=1');
       strList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.7');
       strList.Add('org.eclipse.jdt.core.compiler.compliance=1.7');
       strList.Add('org.eclipse.jdt.core.compiler.source=1.7');
       strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');
     end;

     strList.Clear;
     path:= FAndroidProjectName+DirectorySeparator+'src';
     FindAllDirectories(strList, path, False);

     count:= strList.Count;
     while count > 0 do
     begin
         path:= strList.Strings[0];
         strList.Clear;
         FindAllDirectories(strList, path, False);
         count:= strList.Count;
     end;

     strList.Clear;
     strList.Delimiter:= DirectorySeparator;
     strList.DelimitedText:= path;

     i:= 0;
     path:=strList.Strings[i];
     while path <> 'src' do
     begin
         i:= i+1;
         path:= strList.Strings[i];
     end;

     path:='';
     for j:= (i+1) to strList.Count-2 do
     begin
         path:= path + '.' + strList.Strings[j];
     end;

     FPackagePrefaceName:= TrimChar(path, '.');
     strList.Free;

     FFullJavaSrcPath:=GetFullJavaSrcPath(FAndroidProjectName);

     CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
                 FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');

     if Pos('AppCompat', ComboBoxTheme.Text) > 0 then
     begin
      { CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');}
       tempStr:= ComboBoxTheme.Text;      // AppCompat.Light.DarkActionBar  or AppCompat.Light.DarkActionBar
       CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+tempStr+'.xml',
                  FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');
     end;

     if Pos('GDXGame', ComboBoxTheme.Text) > 0 then
     begin
      { CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');}
       tempStr:= ComboBoxTheme.Text;      // AppCompat.Light.DarkActionBar  or AppCompat.Light.DarkActionBar
       CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+tempStr+'.xml',
                  FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');
     end;

  end;

  if FProjectModel = 'Ant' then
  begin
    if DirectoryExists(FAndroidProjectName) then   //if project exits
    begin
       if MessageDlg('Projec/Directory already Exists!',
         'Re-Create "'+FAndroidProjectName+'" ?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
       begin
         ModalResult:= mrCancel;
       end;
    end
    else
    begin
      CreateDir(FAndroidProjectName);
      if FModuleType <> 2 then  //0: GUI project   1: NoGui project   2: NoGUI Exe
      begin
        CreateDir(FAndroidProjectName+ DirectorySeparator + 'jni');
        CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      end
      else  //console executable app
      begin
        CreateDir(FAndroidProjectName+DirectorySeparator+'build-modes');
      end;

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs');
      CreateDir(FAndroidProjectName+ DirectorySeparator + 'obj');

      if FModuleType <> 2 then
      begin
        CreateDir(FAndroidProjectName+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));
      end;

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'x86');
      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi');
      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi-v7a');

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'arm64-v8a');
      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'x86_64');

    end;

  end;

end;

function TFormWorkspace.DoPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  Result:= '';
  if FPathToSmartDesigner = '' then
  begin
    Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
    if Pkg<>nil then
    begin
        FPathToSmartDesigner:= ExtractFilePath(Pkg.Filename);
        FPathToSmartDesigner:= FPathToSmartDesigner + 'smartdesigner';
        Result:=FPathToSmartDesigner;
        //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
    end;
  end
  else Result:= FPathToSmartDesigner;
end;

function TFormWorkspace.DoNewPathToJavaTemplate(): string;
begin
   FPathToJavaTemplates:= DoPathToSmartDesigner() + pathDelim +'java';
   Result:=FPathToJavaTemplates;
    //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java
end;

procedure TFormWorkspace.WriteIniString(Key, Value: string);
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + FIniFileName);
  if FIniFile <> nil then
  begin
    FIniFile.WriteString(FIniFileSection, Key, Value);
    FIniFile.Free;
  end;
end;

procedure TFormWorkspace.FormCreate(Sender: TObject);
var
  flag: boolean;
  fileName: string;
begin
  flag:= false;
  if not FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini') then
  begin
    if FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini') then
    begin
       FIniFileName:= 'LAMW.ini';
       FIniFileSection:= 'NewProject';
       CopyFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini',
                IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
       //DeleteFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
       Self.DoNewPathToJavaTemplate();
       flag:= True;
    end;
  end;
end;

procedure TFormWorkspace.ListBoxMinSDKChange(Sender: TObject);
var
 tApi, mApi: integer;
 strTApi, strMApi: string;
begin

  strTApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];
  if not IsAllCharNumber(PChar(strTApi))  then tApi:= 29
  else tApi:= StrToInt(strTApi);

  strMApi:= ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex];
  if not IsAllCharNumber(PChar(strMApi))  then mApi:= 14
  else mApi:= StrToInt(strMApi);

  if mApi > tApi then
    ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.IndexOf(FTargetApi);

  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 1;
  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

  StatusBarInfo.Panels.Items[1].Text:= '[MinSdk] '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);
end;

function TFormWorkspace.GetEventSignature(nativeMethod: string): string;
var
  method: string;
  signature: string;
  params, paramName: string;
  i, d, p, p1, p2: integer;
  listParam: TStringList;
begin

  listParam:= TStringList.Create;
  method:= nativeMethod;

  p:= Pos('native', method);
  method:= Copy(method, p+Length('native'), Length(method));
  p1:= Pos('(', method);
  p2:= Pos(')', method);
  d:=(p2-p1);

  params:= Copy(method, p1+1, d-1); //long pasobj, long elapsedTimeMillis
  method:= Copy(method, 1, p1-1);
  method:= Trim(method); //void pOnChronometerTick
  SplitStr(method,' ');
  method:=  Trim(method); //pOnChronometerTick


  signature:= '(PEnv,this';  //no param...

  if  Length(params) > 3 then
  begin
    listParam.Delimiter:= ',';
    listParam.StrictDelimiter:= True;
    listParam.DelimitedText:= params;

    for i:= 0 to listParam.Count-1 do
    begin
       paramName:= Trim(listParam.Strings[i]); //long pasobj
       SplitStr(paramName,' ');
       listParam.Strings[i]:= Trim(paramName);
    end;

    for i:= 0 to listParam.Count-1 do
    begin
      if Pos('pasobj', listParam.Strings[i]) > 0 then
         signature:= signature + ',TObject(' + listParam.Strings[i]+')'
      else
        signature:= signature + ',' + listParam.Strings[i];
    end;
  end;
  Result:= method+'=Java_Event_'+method+signature+');';
  if Pos('pAppOnCreate=', Result) > 0 then
  begin
    if FModuleType = 0 then  //GUI
      Result:= Result +  'AndroidModule1.Init(gApp);';

    if FModuleType = -1 then //Gdx
      Result:= Result +  'GdxModule1.Init(gApp);';
  end;

  listParam.Free;
end;

procedure TFormWorkspace.LoadPathsSettings(const fileName: string);
var
  indexNdk: integer;
  frm: TFormPathMissing;
  nativeMethodList, tempList, gdxList: TStringList;
  i, k: integer;
  strIndexNdk: string;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      FPathToJavaJDK:= ReadString('NewProject','PathToJavaJDK', '');
      if  FPathToJavaJDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java JDK: [ex. C:\Program Files (x86)\Java\jdk1.7.0_21]';
          if frm.ShowModal = mrOK then
          begin
             FPathToJavaJDK:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPathToAntBin:= ReadString('NewProject','PathToAntBin', '');
      if  FPathToAntBin = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Ant bin: [ex. C:\adt32\ant\bin]';
          if frm.ShowModal = mrOK then
          begin
             FPathToAntBin:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPathToAndroidSDK:= ReadString('NewProject','PathToAndroidSDK', '');
      if  FPathToAndroidSDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android SDK: [ex. C:\adt32\sdk]';
          if frm.ShowModal = mrOK then
          begin
             FPathToAndroidSDK:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPathToAndroidNDK:= ReadString('NewProject','PathToAndroidNDK', '');
      if  FPathToAndroidNDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android NDK:  [ex. C:\lamw\ndk10e]';
          if frm.ShowModal = mrOK then
          begin
             FPathToAndroidNDK:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');

      if FPrebuildOSYS = '' then
        if FPathToAndroidNDK <> '' then
           FPrebuildOSYS:= GetPrebuiltDirectory();

      strIndexNdk:= ReadString('NewProject','NDK', ''); //ndk 10e   ... default

      if strIndexNdk = '' then strIndexNdk:= '5';

      indexNdk:= StrToInt(strIndexNdk);

      case indexNdk of
         0: FNDK:= '7';
         1: FNDK:= '9';
         2: FNDK:= '10c';
         3: FNDK:= '10e';
         4: FNDK:= '11c';
         5: FNDK:= '>11';
      end;

      FNDKIndex:= indexNdk;

      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if FPathToJavaTemplates = '' then
      begin
        DoNewPathToJavaTemplate();   //0.8.3 new path!  ...\android_wizard\smartdesigner\java
      end;

      FPathToSmartDesigner:= ReadString('NewProject','PathToSmartDesigner', '');
      if FPathToSmartDesigner = '' then
      begin
        Self.DoPathToSmartDesigner();   //0.8.3 new path!  ...\android_wizard\smartdesigner
      end;

      nativeMethodList:= TStringList.Create;
      tempList:= TStringList.Create;

      if FileExists(FPathToJavaTemplates+DirectorySeparator+'Controls.java') then
      begin
        tempList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'Controls.java');
        for i:= 0 to tempList.Count - 1 do
        begin
           if Pos(' native ', tempList.Strings[i]) > 0 then
              nativeMethodList.Add(Trim(tempList.Strings[i]));
        end;

        tempList.Clear;
        for i:= 0 to nativeMethodList.Count-1 do
        begin
          tempList.Add(GetEventSignature(nativeMethodList.Strings[i]));
        end;

        //if Pos('GDXGame', Self.ComboBoxTheme.Text) > 0 then
        if FModuleType = -1 then //GDXGame;
        begin
          gdxList:= TStringList.Create;
          if FileExists(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'jGdxForm.native') then
          begin
            gdxList.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'jGdxForm.native');
            for k:= 0 to gdxList.Count-1 do
            begin
              tempList.Add(GetEventSignature(gdxList.Strings[k]));
              nativeMethodList.Add(gdxList.Strings[k]);
            end;
          end;
          gdxList.Free;
        end;

        tempList.SaveToFile(FPathToJavaTemplates+DirectorySeparator+'Controls.events');  //old "ControlsEvents.txt"
        nativeMethodList.SaveToFile(FPathToJavaTemplates+DirectorySeparator+'Controls.native');

      end;

      nativeMethodList.Free;
      tempList.Free;

      cbBuildSystem.Items.Clear;
      if FPathToAndroidSDK <> '' then
      begin
        if IsSdkToolsAntEnable then
        begin
          cbBuildSystem.Items.Add('Ant');
          cbBuildSystem.ItemIndex:= 0;
          cbBuildSystem.Text:='Ant';
        end;
      end;

    finally
      Free;
    end;

  end;
end;

function TFormWorkspace.HasBuildTools(platform: integer;  out outBuildTool: string): boolean;
var
  lisDir: TStringList;
  numberAsString, auxStr: string;
  i, builderNumber: integer;
  savedBuilder: integer;
begin
  Result:= False;
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
    for i:= 0 to lisDir.Count-1 do
    begin
       auxStr:= lisDir.Strings[i];
       if auxStr <> '' then    //19.1.0
       begin
           numberAsString:= Copy(auxStr, 1 , 2);  //19
           if IsAllCharNumber(PChar(numberAsString)) then
           begin
             builderNumber:=  StrToInt(numberAsString);
             if  platform <= builderNumber then
             begin
               outBuildTool:= auxStr; //25.0.3
               Result:= True;
               break;
             end;
           end;
       end;
    end;
  end;
  lisDir.free;
end;

function TFormWorkspace.IsSdkToolsAntEnable: boolean;
begin          //C:\adt32\sdk\tools\ant
  Result:= False;
  if DirectoryExists(FPathToAndroidSDK + PathDelim + 'tools' + PathDelim + 'ant') then
  begin
     Result:= True;
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
begin

  EditPathToWorkspace.Left:= 8; // try fix hidpi bug
  ComboSelectProjectName.Left:= 8;  // try fix hidpi bug

  ListBoxTargetAPI.Clear;  //SDK
  ListBoxTargetAPI.Items.Add(IntToStr(FMaxSdkPlatform));
  ListBoxTargetAPI.ItemIndex:= 0;
  StatusBarInfo.Panels.Items[2].Text:='[Target] '+ GetCodeNameByApi(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);

  ListBoxMinSDK.ItemIndex:= 1;
  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];
  StatusBarInfo.Panels.Items[1].Text:= '[MinSdk] '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);

  if EditPathToWorkspace.Text <> '' then
     ComboSelectProjectName.SetFocus
  else
    EditPathToWorkspace.SetFocus;

  if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';

  if FPrebuildOSYS =  '' then
  begin
    if  FPathToAndroidNDK <> '' then
         FPrebuildOSYS:= GetPrebuiltDirectory();
  end;

  FHasSdkToolsAnt:= False;
  if FPathToAndroidSDK <> '' then
     FHasSdkToolsAnt:= IsSdkToolsAntEnable();

  SpeedButtonSDKPlusClick(Self);

  Self.RGInstruction.ItemIndex:= FInstructionSetIndex;


end;

procedure TFormWorkspace.ComboBoxThemeChange(Sender: TObject);
var
  index, intTargetApi: integer;
begin

  if Pos('GDXGame', ComboBoxTheme.Text) > 0 then
  begin
    if Pos('Gradle',cbBuildSystem.Items.Text) > 0 then
    begin
      index:= cbBuildSystem.Items.IndexOf('Gradle');
      cbBuildSystem.ItemIndex:= index;
      cbBuildSystem.Text:= 'Gradle';
      cbBuildSystemCloseUp(Self);
    end;
  end;

  if Pos('AppCompat', ComboBoxTheme.Text) > 0 then
  begin

    CheckBoxSupport.Checked:= True; //inner Supported!!!

    if (FMaxSdkPlatform < 29) or (FPathToGradle = '')   then
    begin
      ShowMessage('Warning/Recomendation:'+
               sLineBreak+
               sLineBreak+'[LAMW 0.8.6.1] "AppCompat" [material] theme need:'+
               sLineBreak+' 1. Java JDK 1.8'+
               sLineBreak+' 2. Gradle 6.6.1 [https://gradle.org/next-steps/?version=6.6.1&format=bin]' +
               sLineBreak+' 3. Android SDK "plataforms" 29 + "build-tools" 29.0.3'+
               sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
               sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
               sLineBreak+' 6. Android SDK/Extra  "Google Repository"'+
               sLineBreak+' 7. Android SDK/Extra  "Google Play Services"'+
               sLineBreak+' '+
               sLineBreak+' Hint: "Ctrl + C" to copy this content to Clipboard!');

      ComboBoxTheme.ItemIndex:= 0;
      ComboBoxTheme.Text:= 'DeviceDefault';

      Exit;

    end;

    if Pos('Gradle',cbBuildSystem.Items.Text) > 0 then //Apk system builder...
    begin
      index:= cbBuildSystem.Items.IndexOf('Gradle');
      cbBuildSystem.ItemIndex:= index;
      cbBuildSystem.Text:= 'Gradle';
      cbBuildSystemCloseUp(Self);
    end;

    intTargetApi:= StrToInt(ListBoxTargetAPI.Text);

    if intTargetApi < 29 then
    begin
       if Pos('29',ListBoxTargetAPI.Items.Text) > 0 then
       begin
          index:= ListBoxTargetAPI.Items.IndexOf('29');
          ListBoxTargetAPI.ItemIndex:= index;
          ListBoxTargetAPI.Text:= '29';
          ListBoxTargetAPICloseUp(Self);
       end;
    end;

    if Pos('Gradle',cbBuildSystem.Items.Text) > 0 then //Apk system builder...
    begin
      index:= cbBuildSystem.Items.IndexOf('Gradle');
      cbBuildSystem.ItemIndex:= index;
      cbBuildSystem.Text:= 'Gradle';
      cbBuildSystemCloseUp(Self);
    end;

    if ListBoxMinSDK.ItemIndex < 1 then ListBoxMinSDK.ItemIndex:= 1;   //Api 14

  end;

end;

procedure TFormWorkspace.CheckBoxPIEClick(Sender: TObject);
begin
  FPieChecked:= CheckBoxPIE.Checked;
end;

procedure TFormWorkspace.CheckBoxSupportChange(Sender: TObject);
var
  apiMin: integer;
begin
   if TCheckBox(Sender).Checked then
   begin
      apiMin:= StrToInt(ListBoxMinSDK.Text);
      if apiMin < 18 then
      begin
          ListBoxMinSDK.Text:= '18';
          ShowMessage('warning: Support Library need "Min. Device Api" >= 18');
          StatusBarInfo.Panels.Items[1].Text:= '[MinSdk] JellyBean 4.3';
      end;
   end;
end;

procedure TFormWorkspace.CheckBoxSupportClick(Sender: TObject);
var
  intApi, index: integer;
  flag: boolean;
begin
  FSupport:=TCheckBox(Sender).Checked;
  if FSupport then
  begin
     intApi:= StrToInt(ListBoxTargetAPI.Text);

     if intApi < 29 then
     begin
       flag:= False;
       if Pos('29',ListBoxTargetAPI.Items.Text) > 0 then
       begin
          flag:= True;
          index:= ListBoxTargetAPI.Items.IndexOf('29');
          ListBoxTargetAPI.ItemIndex:= index;
          ListBoxTargetAPI.Text:= '29';
          ListBoxTargetAPICloseUp(Self);
       end;

       if (not flag) then
       begin
          if (Pos('29',ListBoxTargetAPI.Items.Text) > 0) then
          begin
            flag:= True;
            index:= ListBoxTargetAPI.Items.IndexOf('29');
            ListBoxTargetAPI.ItemIndex:= index;
            ListBoxTargetAPI.Text:= '29';
            ListBoxTargetAPICloseUp(Self);
          end;
       end;

       if not flag then
          ShowMessage('warning: Support Library need TargetApi >= 29');

     end;

     if (cbBuildSystem.Text <> 'Gradle') then
     begin
       cbBuildSystem.Text:= 'Gradle';
       ShowMessage('Warning: Support Library need Gradle 6.6.1 and Target API >= 29');
     end
  end
end;

procedure TFormWorkspace.CheckBoxLibraryClick(Sender: TObject);
begin
  FLibraryChecked:=TCheckBox(Sender).Checked;
end;

procedure TFormWorkspace.cbBuildSystemCloseUp(Sender: TObject);
var
  s: string;
begin

  if (cbBuildSystem.Text = 'Gradle') then
     CheckBoxSupport.Checked:= True //inner Supported!!!
  else
     CheckBoxSupport.Checked:= False; //Ant don't support extern libraries...

  if (cbBuildSystem.Text = 'Gradle') and ( Pos('AppCompat', ComboBoxTheme.Text) > 0) then
  begin
    s := LowerCase(ExtractFileName(ExcludeTrailingPathDelimiter(LamwGlobalSettings.PathToJavaJDK)));
    if Pos('1.7.', s) > 0 then
      MessageDlg('[LAMW 0.8.6.1] "AppCompat" [material] theme need JDK 1.8 + Gradle 6.6.1 [or up]!', mtWarning, [mbOk], 0);
  end;

end;


procedure TFormWorkspace.ComboSelectProjectNameKeyPress(Sender: TObject;
  var Key: char);
begin
  if (ComboSelectProjectName.Text <> '') and (Key = #13) then
  begin
    Key := #0;
    BitBtnOK.SetFocus;
  end;
end;

procedure TFormWorkspace.EditPathToWorkspaceExit(Sender: TObject);
begin
  FPathToWorkspace:= EditPathToWorkspace.Text;
  if EditPathToWorkspace.Text = '' then
  begin
     ShowMessage('Please,  enter path to projects [workspace] folder...');
  end;

  if Pos(' ', EditPathToWorkspace.Text) > 0 then
  begin
    ShowMessage('Warning: path to projects [workspace] contains space characters inside [not advised!]...');
  end;

end;

procedure TFormWorkspace.SpdBtnPathToWorkspaceClick(Sender: TObject);
begin
  if SelDirDlgPathToWorkspace.Execute then
  begin
    EditPathToWorkspace.Text := SelDirDlgPathToWorkspace.FileName;
    FPathToWorkspace:= SelDirDlgPathToWorkspace.FileName;
    ComboSelectProjectName.Items.Clear;
    FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);
  end;
end;

procedure TFormWorkspace.SpdBtnRefreshProjectNameClick(Sender: TObject);
begin
  FPathToWorkspace:= EditPathToWorkspace.Text;
  ComboSelectProjectName.Items.Clear;
  FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);
end;

procedure TFormWorkspace.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('Warning/Recomendation:'+
           sLineBreak+
           sLineBreak+'[LAMW 0.8.6.1] "AppCompat" [material] theme need:'+
           sLineBreak+' 1. Java JDK 1.8'+
           sLineBreak+' 2. Gradle 6.6.1 [https://gradle.org/next-steps/?version=6.6.1&format=bin] or up' +
           sLineBreak+' 3. Android SDK "plataforms" 29 + "build-tools" 29.0.3'+
           sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
           sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
           sLineBreak+' 6. Android SDK/Extra  "Google Repository"'+
           sLineBreak+' 7. Android SDK/Extra  "Google Play Services"'+
           sLineBreak+' '+
           sLineBreak+' Hint: "Ctrl + C" to copy this content to Clipboard!');
end;

procedure TFormWorkspace.SpeedButtonSDKPlusClick(Sender: TObject);
var
  lisDir: TStringList;
  strApi, outBuildTool: string;
  i, intApi: integer;
begin
  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    ListBoxTargetAPI.Clear;
    for i:=0 to lisDir.Count-1 do
    begin
       strApi:= ExtractFileName(lisDir.Strings[i]);
       if strApi <> '' then
       begin
         strApi:= Copy(strApi, LastDelimiter('-', strApi) + 1, MaxInt);
         if IsAllCharNumber(PChar(strApi))  then  //skip android-P
         begin
             intApi:= StrToInt(strApi);
             if intApi > 0 then
             begin
               if HasBuildTools(intApi, outBuildTool) then
               begin
                    ListBoxTargetAPI.Items.Add(strApi);
               end;
             end;
         end;
       end;
    end;

    if ListBoxTargetAPI.Items.Count > 0 then
    begin
      ListBoxTargetAPI.ItemIndex:= ListBoxTargetAPI.Items.Count - 1;
      FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];
    end
      else ShowMessage('Fail! Folder '+ IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms is empty!');

  end else ShowMessage('Fail! Folder '+ IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms is empty!');
  lisDir.free;

end;

procedure TFormWorkspace.SpeedButtonHintThemeClick(Sender: TObject);
begin
  ShowMessage('Warning/Recomendation:'+
           sLineBreak+
           sLineBreak+'[LAMW 0.8.6.1] "AppCompat" [material] theme need:'+
           sLineBreak+' 1. Java JDK 1.8'+
           sLineBreak+' 2. Gradle 6.6.1 [https://gradle.org/next-steps/?version=6.6.1&format=bin]' +
           sLineBreak+' 3. Android SDK "plataforms" 29 + "build-tools" 29.0.3'+
           sLineBreak+' 4. Android SDK/Extra  "Support Repository"'+
           sLineBreak+' 5. Android SDK/Extra  "Support Library"'+
           sLineBreak+' 6. Android SDK/Extra  "Google Repository"'+
           sLineBreak+' 7. Android SDK/Extra  "Google Play Services"');
end;

function TFormWorkspace.GetBuildSystem: string;
begin
  Result:= cbBuildSystem.Text;
end;

function TFormWorkspace.GetGradleVersion(out tagVersion: integer): string;
var
   p, posLastDelim: integer;
   strAux: string;
   numberAsString: string;
   userString: string;
begin
  Result:='';
  if FPathToGradle <> '' then
  begin
    strAux:=ExcludeTrailingPathDelimiter(FPathToGradle);
    posLastDelim:= LastDelimiter(PathDelim, strAux);
    strAux:= Copy(strAux, posLastDelim+1, MaxInt);  //gradle-3.3

    p:=1;
    //skip characters that do not represent a version number
    while (p<=Length(strAux)) AND (NOT (strAux[p] in ['0'..'9','.'])) do Inc(p);
    if (p<=Length(strAux)) then
    begin
        Result:= Copy(strAux, p, MaxInt);  // 3.3

        if Result = '4.10'   then Result:= '4.9.1'
        else if Result = '4.10.1' then Result:= '4.9.2'
        else if Result = '4.10.2' then Result:= '4.9.3'
        else if Result = '4.10.3' then Result:= '4.9.4';

        numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 33
        if Length(numberAsString) < 3 then
        begin
           numberAsString:= numberAsString+ '0'  //330
        end;
        tagVersion:= StrToInt(Trim(numberAsString));
    end;

    if Result = '' then  //gradle-6.6.1
    begin
      userString:= '6.6.1';
      if InputQuery('Gradle', 'Please, Enter Gradle Version ', userString) then
      begin
        if UserString <> '' then
        begin
           Result:= Trim(UserString);  // 4.1
           numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 41
           if Length(numberAsString) < 3 then
           begin
               numberAsString:= numberAsString+ '0'  //410
           end;
           tagVersion:= StrToInt(Trim(numberAsString));
        end
        else
        begin
          Result:= '6.6.1';
          numberAsString:= StringReplace(Result,'.', '', [rfReplaceAll]); // 41
          if Length(numberAsString) < 3 then
          begin
             numberAsString:= numberAsString+ '0'  //410
          end;
          tagVersion:= StrToInt(Trim(numberAsString));
        end;

      end;

    end;

  end;

end;

function TFormWorkspace.GetBuildTool(sdkApi: integer): string;
var
  tempOutBuildTool: string;
begin
  Result:= '';
  if HasBuildTools(sdkApi, tempOutBuildTool) then
  begin
     Result:= tempOutBuildTool;  //28.0.3
  end;
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);  //called by "AndroidWizard_inf.pas"
var
  auxInstSet: string;
  tagVersion: integer;
  ndk_index: integer;
begin
   //run before "OnFormActive"

  //verify if some was not load!
  FFileName:= pFilename; //full filename

  Self.LoadPathsSettings(FFileName);

  with TIniFile.Create(pFilename) do
  try

    DoNewPathToJavaTemplate();
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');

    FPackagePrefaceName:= ReadString('NewProject','PackagePrefaceName', '');
    if FPackagePrefaceName = '' then FPackagePrefaceName:=  'org.lamw';

    FAntBuildMode:= 'debug';    //default...
    FTouchtestEnabled:= 'True'; //default

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity = '' then FMainActivity:= 'App';

    auxInstSet:= ReadString('NewProject','InstructionSet', '');

    if not IsAllCharNumber(PChar(auxInstSet)) then
      auxInstSet:= '1';

    if auxInstSet = '' then auxInstSet:= '1';
    if auxInstSet = '0' then auxInstSet:='1';

    FInstructionSetIndex:= StrToInt(auxInstSet);

    ComboSelectProjectName.Items.Clear;
    FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);

    FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
    FPathToGradle:= ReadString('NewProject','PathToGradle', '');

    if FPathToGradle <> '' then
    begin
       FGradleVersion:= GetGradleVersion({out}tagVersion);
       cbBuildSystem.Items.Add('Gradle');
       if cbBuildSystem.Items.Count = 1 then
       begin
         cbBuildSystem.Text:= 'Gradle';
         cbBuildSystem.ItemIndex:= 0;
       end;
    end;

  finally
    Free;
  end;

  if FInstructionSetIndex < 0 then  FInstructionSetIndex:= 1;
  FFPUSet:= '';
  case  FInstructionSetIndex of
     0: begin FFPUSet:= 'Soft';  FInstructionSet:='ARMV6'; end;
     1: begin FFPUSet:= 'Soft';  FInstructionSet:='ARMV7A';end;
     2: begin FFPUSet:= 'VFPV3'; FInstructionSet:='ARMV7A';end;
     3: FInstructionSet:='x86';
     4: FInstructionSet:='Mipsel';
     5: FInstructionSet:='ARMV8'; //aarch64
     6: FInstructionSet:='x86_64';
  end;

  EditPathToWorkspace.Text := FPathToWorkspace;
  EditPackagePrefaceName.Text := FPackagePrefaceName;

  FMaxSdkPlatform:= Self.GetMaxSdkPlatform();
  if FMaxSdkPlatform = 0 then    //  try fix "android-0"
      FMaxSdkPlatform:= FCandidateSdkPlatform;

  ndk_Index:= 22;

  FMaxNdkPlatform:= Self.GetMaxNdkPlatform(ndk_Index);    //ndkIndex Max =  22 for old 4.x, 5.x devices compatibility!!!!

  if ListBoxNdkPlatform.Items.Count > 0 then
  begin
    ListBoxNdkPlatform.ItemIndex:= ndk_Index;
    StatusBarInfo.Panels.Items[0].Text:='[Ndk] '+ GetCodeNameByApi(ListBoxNdkPlatform.Items[ListBoxNdkPlatform.ItemIndex]);
  end;

end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);  //called by ... "AndroidWizard_intf.pas"
begin
   with TInifile.Create(pFilename) do
   try
      if EditPathToWorkspace.Text <> '' then
        WriteString('NewProject', 'PathToWorkspace', EditPathToWorkspace.Text)
      else
        ShowMessage('Warning: EditPathToWorkspace is Empty...');

      if FInstructionSetIndex >= 0 then
         WriteString('NewProject', 'InstructionSet', IntToStr(Self.FInstructionSetIndex));

      if EditPackagePrefaceName.Text <> '' then
         WriteString('NewProject', 'PackagePrefaceName', EditPackagePrefaceName.Text)
      else
        WriteString('NewProject', 'PackagePrefaceName', 'org.lamw');

      if FPathToJavaTemplates <> '' then
         WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates)
      else
        WriteString('NewProject', 'PathToJavaTemplates', Self.DoNewPathToJavaTemplate());

      if FPathToSmartDesigner <> '' then
        WriteString('NewProject', 'PathToSmartDesigner', FPathToSmartDesigner)
      else
        WriteString('NewProject', 'PathToSmartDesigner', Self.DoPathToSmartDesigner());

      if FPathToJavaJDK <> '' then
        WriteString('NewProject', 'PathToJavaJDK', FPathToJavaJDK);

      if FPathToAndroidNDK <> '' then
         WriteString('NewProject', 'PathToAndroidNDK', FPathToAndroidNDK);

      if FPathToAndroidSDK <> '' then
        WriteString('NewProject', 'PathToAndroidSDK', FPathToAndroidSDK);

      if FPathToAntBin <> '' then
        WriteString('NewProject', 'PathToAntBin', FPathToAntBin);

      if FPathToGradle <> '' then
        WriteString('NewProject', 'PathToGradle', FPathToGradle);

      if Self.RGInstruction.ItemIndex >= 0 then
         WriteString('NewProject', 'InstructionSet', IntToStr(RGInstruction.ItemIndex))
      else
         WriteString('NewProject', 'InstructionSet', '1');

      if FPrebuildOSYS = '' then
      begin
         FPrebuildOSYS:= GetPrebuiltDirectory();
         WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);
      end;

   finally
      Free;
   end;
end;

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

//http://stackoverflow.com/questions/11489680/list-all-files-from-a-directory-in-a-string-grid-with-delphi
function  GetFiles(const StartDir: String; const List: TStrings): Boolean;
var
  SRec: TSearchRec;
  Res: Integer;
begin
  if not Assigned(List) then
  begin
    Result := False;
    Exit;
  end;
  Res := FindFirst(StartDir + '*.create', faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      if (SRec.Attr and faDirectory <> faDirectory) then
        // If you want filename only, remove "StartDir +"
        // from next line
        List.Add( StartDir + SRec.Name );
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
  Result := (List.Count > 0);
end;

function ReplaceChar(const query: string; oldchar, newchar: char): string;
var
  i: Integer;
begin
  Result := query;
  for i := 1 to Length(Result) do
    if Result[i] = oldchar then Result[i] := newchar;
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

end.

