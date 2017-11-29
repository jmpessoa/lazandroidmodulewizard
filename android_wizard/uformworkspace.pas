unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LazIDEIntf,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, FormPathMissing, uFormOSystem, PackageIntf, Types;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    BitBtnCancel: TBitBtn;
    BitBtnOK: TBitBtn;
    CheckBoxLibrary: TCheckBox;
    CheckBoxPIE: TCheckBox;
    ComboBoxTheme: TComboBox;
    ComboSelectProjectName: TComboBox;
    EditPackagePrefaceName: TEdit;
    EditPathToWorkspace: TEdit;
    edProjectName: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Image1: TImage;
    LabelTheme: TLabel;
    LabelPathToWorkspace: TLabel;
    LabelSelectProjectName: TLabel;
    ListBoxMinSDK: TListBox;
    ListBoxPlatform: TListBox;
    ListBoxTargetAPI: TListBox;
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

    procedure CheckBoxLibraryClick(Sender: TObject);
    procedure CheckBoxPIEClick(Sender: TObject);
    procedure ComboBoxThemeChange(Sender: TObject);
    procedure ComboSelectProjectNameKeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxMinSDKClick(Sender: TObject);
    procedure ListBoxMinSDKSelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxPlatformSelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxTargetAPIClick(Sender: TObject);
    procedure ListBoxTargetAPISelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxPlatformClick(Sender: TObject);
    //procedure RGDeviceTypeClick(Sender: TObject);

    procedure RGInstructionClick(Sender: TObject);

    procedure SpdBtnPathToWorkspaceClick(Sender: TObject);
    procedure SpdBtnRefreshProjectNameClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButtonHintThemeClick(Sender: TObject);

  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}
    //FDeviceType: string;      {phone or watch ... }
    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPathToGradle: string;

    FProjectModel: string;

    FModuleType: integer;  //0: GUI project   1: NoGui project   2: NoGUI Exe
    FSmallProjName: string;

    FPackagePrefaceName: string;

    FMinApi: string;
    FTargetApi: string;

    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;   //Simon "App"
    FNDK: string;
    FAndroidNdkPlatform: string;
    FSupportV4: string;

    FPrebuildOSYS: string;

    FFullJavaSrcPath: string;
    FJavaClassName: string;
    FIndexTargetApi: integer;
    FIndexNdkPlatformApi: integer;
    FAndroidTheme: string;
    FPieChecked: boolean;
    FLibraryChecked: boolean;

  public
    { public declarations }
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    function GetTextByListIndex(index:integer): string;

    function GetNDKPlatform(identName: string): string;

    function GetCodeNameByApi(api: string):string;
    function GetNDKPlatformByApi(api: string): string;

    function GetFullJavaSrcPath(fullProjectName: string): string;
    function GetPrebuiltDirectory: string;
    procedure LoadPathsSettings(const fileName: string);
    function GetEventSignature(nativeMethod: string): string;
    function GetPathToTemplatePresumed(): string;

    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;
    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
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
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
    property NDK: string read FNDK write FNDK;
    property AndroidPlatform: string read FAndroidNdkPlatform write FAndroidNdkPlatform;
    property SupportV4: string read FSupportV4 write FSupportV4;
    property PrebuildOSYS: string read FPrebuildOSYS write FPrebuildOSYS;
    property FullJavaSrcPath: string read FFullJavaSrcPath write FFullJavaSrcPath;
    property JavaClassName: string read   FJavaClassName write FJavaClassName;
    property ModuleType: integer read FModuleType write FModuleType;  //0: GUI project   1: NoGui project
    property SmallProjName: string read FSmallProjName write FSmallProjName;
    property AndroidTheme: string read FAndroidTheme write FAndroidTheme;
    property PieChecked: boolean read FPieChecked write FPieChecked;
    property LibraryChecked: boolean read FLibraryChecked write FLibraryChecked;
    //property DeviceType: string read FDeviceType write FDeviceType;

  end;


  function TrimChar(query: string; delimiter: char): string;
  function SplitStr(var theString: string; delimiter: string): string;
  function GetFiles(const StartDir: String; const List: TStrings): Boolean;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

function TFormWorkspace.GetCodeNameByApi(api: string):string;
begin
  Result:= 'Unknown';
  if api='8' then Result:= 'Froyo 2.2'
  else if api='10' then Result:= 'Gingerbread 2.3'
  // tk
  else if api='11' then Result:= 'Honeycomb 3.0x'
  else if api='12' then Result:= 'Honeycomb 3.1x'
  else if api='13' then Result:= 'Honeycomb 3.2'
  // end tk
  else if api='14' then Result:= 'IceCream 4.0'
  else if api='15' then Result:= 'IceCream 4.0x'
  else if api='16' then Result:= 'JellyBean 4.1'
  else if api='17' then Result:= 'JellyBean 4.2'
  else if api='18' then Result:= 'JellyBean 4.3'
  else if api='19' then Result:= 'KitKat 4.4'
  else if api='20' then Result:= 'KitKat 4.4x'
  else if api='21' then Result:= 'Lollipop 5.0'
  else if api='22' then Result:= 'Lollipop 5.1'
  else if api='23' then Result:= 'Marshmallow 6.0';
end;

procedure TFormWorkspace.ListBoxMinSDKClick(Sender: TObject);
var
 tApi, mApi: integer;
 begin

  if ListBoxTargetAPI.ItemIndex < 0then ListBoxTargetAPI.ItemIndex:= 0;
  tApi:= StrToInt(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);

  mApi:= StrToInt(ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex]);
  if  mApi > tApi then
      ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.IndexOf(FTargetApi);

  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByListIndex(index:integer): string;
begin
   Result:= '';
   case index of
     0: Result:= 'Froyo 2.2'; // Api(8)    -Froyo 2.2
     1: Result:= 'Gingerbread 2.3'; // Api(10)   -Gingerbread 2.3
     // tk
     2: Result:= 'Honeycomb 3.0x'; // Api(11) -Honeycomb 3.0x
     3: Result:= 'Honeycomb 3.1x'; // Api(12) -Honeycomb 3.1x
     4: Result:= 'Honeycomb 3.2'; // Api(13) -Honeycomb 3.2
     // end tk
     5: Result:= 'IceCream 4.0'; // Api(15)  -Ice Cream 4.0x
     6: Result:= 'JellyBean 4.1'; // Api(16)  -Jelly Bean 4.1
     7: Result:= 'JellyBean 4.2'; // Api(17)  -Jelly Bean 4.2
     8: Result:= 'JellyBean 4.3'; // Api(18)  -Jelly Bean 4.3
     9: Result:= 'KitKat 4.4'; // Api(19)  -KitKat 4.4
     10: Result:= 'KitKat 4.4W'; // Api(20)  -KitKat 4.4
     11: Result:= 'Lollipop 5.0'; // Api(21)  -Lollipop [5.0]
     12: Result:= 'Lollipop 5.1'; // Api(22)  -Lollipop [5.1]
   end;
end;

procedure TFormWorkspace.ListBoxMinSDKSelectionChange(Sender: TObject; User: boolean);
begin
  StatusBarInfo.Panels.Items[1].Text:= 'MinSdk: '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);
end;

procedure TFormWorkspace.ListBoxPlatformSelectionChange(Sender: TObject;
  User: boolean);
begin
  StatusBarInfo.Panels.Items[0].Text:='Ndk: '+ GetCodeNameByApi(ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]);
end;

procedure TFormWorkspace.ListBoxTargetAPIClick(Sender: TObject);
var
 tApi, mApi: integer;
begin

  FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];

  tApi:= StrToInt(FTargetApi);

  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
  mApi:= StrToInt(ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex]);

  if  mApi > tApi then
      ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.IndexOf(FTargetApi);

  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

end;

procedure TFormWorkspace.ListBoxTargetAPISelectionChange(Sender: TObject; User: boolean);
begin
  StatusBarInfo.Panels.Items[2].Text:='Target: '+ GetCodeNameByApi(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);
end;

procedure TFormWorkspace.ListBoxPlatformClick(Sender: TObject);
begin
  FAndroidNdkPlatform:= 'android-'+ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]
end;

{
procedure TFormWorkspace.RGDeviceTypeClick(Sender: TObject);
begin
  case RGDeviceType.ItemIndex of
    0: FDeviceType:= 'phone';
    1: FDeviceType:= 'watch';
  end;
end;
}

procedure TFormWorkspace.RGInstructionClick(Sender: TObject);
begin
  FInstructionSet:= 'x86';
  FFPUSet:= ''; //x86  or mipsel

  if RGInstruction.ItemIndex = 0  then begin FFPUSet:= 'Soft';  FInstructionSet:='ARMv6'; end;
  if RGInstruction.ItemIndex = 1  then begin FFPUSet:= 'Soft';  FInstructionSet:='ARMv7a';end;
  if RGInstruction.ItemIndex = 2  then begin FFPUSet:= 'VFPv3'; FInstructionSet:='ARMv7a';end;
  if RGInstruction.ItemIndex = 3  then FInstructionSet:='x86';
  if RGInstruction.ItemIndex = 4  then FInstructionSet:='Mipsel';

  if FPathToAndroidNDK <> '' then
     FPrebuildOSYS:= GetPrebuiltDirectory();

end;

function TFormWorkspace.GetNDKPlatform(identName: string): string;
begin
    Result:= 'android-14'; //default
         if identName = 'Froyo'          then Result:= 'android-8'
    else if identName = 'Gingerbread'    then Result:= 'android-10'
    else if identName = 'Honeycomb'      then Result:= 'android-13'
    else if identName = 'Ice Cream 4.0x' then Result:= 'android-15'
    else if identName = 'Jelly Bean 4.1' then Result:= 'android-16'
    else if identName = 'Jelly Bean 4.2' then Result:= 'android-17'
    else if identName = 'Jelly Bean 4.3' then Result:= 'android-18'
    else if identName = 'KitKat 4.4'     then Result:= 'android-19'
    else if identName = 'Lollipop 5.0'   then Result:= 'android-21';
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
   pathToNdkToolchains46,
   pathToNdkToolchains49,
   pathToNdkToolchains443: string;
begin
    Result:= '';

    if Pos('Mipsel', FInstructionSet) > 0 then
    begin
        {
        pathToNdkToolchains443:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                      'x86-4.4.3'+DirectorySeparator+
                                                      'prebuilt'+DirectorySeparator;

        pathToNdkToolchains46:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                   'x86-4.6'+DirectorySeparator+
                                                   'prebuilt'+DirectorySeparator;
        }
        pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                     'mipsel-linux-android-4.9'+DirectorySeparator+
                                                     'prebuilt'+DirectorySeparator;
    end
    else if Pos('x86', FInstructionSet) > 0 then
    begin
       pathToNdkToolchains443:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                     'x86-4.4.3'+DirectorySeparator+
                                                     'prebuilt'+DirectorySeparator;

       pathToNdkToolchains46:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                  'x86-4.6'+DirectorySeparator+
                                                  'prebuilt'+DirectorySeparator;

       pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                    'x86-4.9'+DirectorySeparator+
                                                    'prebuilt'+DirectorySeparator;
    end
    else  //ARM
    begin
     pathToNdkToolchains443:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator;

     pathToNdkToolchains46:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                              'arm-linux-androideabi-4.6'+DirectorySeparator+
                                              'prebuilt'+DirectorySeparator;

     pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;
    end;

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

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  strList: TStringList;
  count, i, j, apiTarg: integer;
  path: string;
  aList: TStringList;
  tApi, mApi: integer;
begin

  if ListBoxTargetAPI.ItemIndex < 0 then ListBoxTargetAPI.ItemIndex:= 0;
  tApi:= StrToInt(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);
  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
  mApi:= StrToInt(ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex]);
  if  mApi > tApi then
      ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.IndexOf(FTargetApi);

  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

  SaveSettings(FFileName);
  if ModalResult = mrCancel  then Exit;

  apiTarg:=  StrToInt(FTargetApi);

  if apiTarg < 11 then
    FAndroidTheme:= 'Light'
  else if (apiTarg >= 11) and  (apiTarg < 14) then
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

  if ComboSelectProjectName.Text = '' then
  begin
    ShowMessage('Error! Projec Name was missing.... [Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  FPathToWorkspace:= Trim(EditPathToWorkspace.Text);
  FJavaClassName:= 'Controls'; //GUI  [try guess]

  if Pos(DirectorySeparator, ComboSelectProjectName.Text) <= 0 then
  begin
     FProjectModel:= 'Ant';   //please, read as "project not exists"!
     FSmallProjName:= Trim(ComboSelectProjectName.Text);
     FAndroidProjectName:= FPathToWorkspace + DirectorySeparator+ FSmallProjName;
       FPackagePrefaceName:= LowerCase(Trim(EditPackagePrefaceName.Text));
       if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';
       if FModuleType <> 0 then //NoGUI
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
     if FModuleType <> 0 then  //NoGUI
       FJavaClassName:=  FSmallProjName //ex. "AppTest1"
  end;

  FMainActivity:= 'App'; {dummy for Simon template} //TODO: need name flexibility here...

  FAndroidNdkPlatform:= GetNDKPlatformByApi(ListBoxPlatform.Items.Strings[ListBoxPlatform.ItemIndex]); //(ListBoxPlatform.Items.Strings[ListBoxPlatform.ItemIndex]);

  if FProjectModel = 'Eclipse' then
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

      if FModuleType <> 2 then
      begin
        CreateDir(FAndroidProjectName+ DirectorySeparator + 'jni');

        CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      end
      else  //console executable app
      begin
        CreateDir(FAndroidProjectName+DirectorySeparator+'build-modes');
      end;

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs');

      if FSupportV4 = 'yes' then  //add "android 4.0" support to olds devices ...
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
                 FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'obj');

      if FModuleType <> 2 then
      begin
        CreateDir(FAndroidProjectName+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));
      end;

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'x86');

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi');

      CreateDir(FAndroidProjectName+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi-v7a');
    end;
  end;
end;

procedure TFormWorkspace.FormCreate(Sender: TObject);
var
  fileName: string;
begin

  //FDeviceType:= 'phone';
  //Self.RGDeviceType.ItemIndex:= 0;

  //here ModuleType already know!
  fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if not FileExists(fileName) then
  begin
    SaveSettings(fileName);  //force to create empty/initial file!
  end;
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
  if Pos('pAppOnCreate=', Result) > 0 then  Result:= Result +  'AndroidModule1.Init(gApp);';

  listParam.Free;
end;

function TFormWorkspace.GetPathToTemplatePresumed(): string;
var
  p: integer;
  Pkg: TIDEPackage;
begin
  Pkg:=PackageEditingInterface.FindPackageWithName('amw_ide_tools');
  if Pkg<>nil then
  begin
    p:= Pos('ide_tools', ExtractFilePath(Pkg.Filename));
    Result:= Copy(ExtractFilePath(Pkg.Filename), 1, p-1) + 'java';
  end;
end;

procedure TFormWorkspace.LoadPathsSettings(const fileName: string);
var
  indexNdk: integer;
  frm: TFormPathMissing;
  frmSys: TFormOSystem;
  nativeMethodList, tempList,  fileList: TStringList;
  i, j: integer;
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

      FPathToGradle:= ReadString('NewProject','PathToGradle', '');  //optional ...

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
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android NDK:  [ex. C:\adt32\ndk10]';
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

      indexNdk:= StrToIntDef(ReadString('NewProject','NDK', ''), 3); //ndk 10e   ... default

      case indexNdk of
         0: FNDK:= '7';
         1: FNDK:= '9';
         2: FNDK:= '10c'; //old Laz4Android
         3: FNDK:= '10e';
         4: FNDK:= '11c';
      end;

      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if FPathToJavaTemplates = '' then
      begin
        frm:= TFormPathMissing.Create(nil);
        frm.LabelPathTo.Caption:= 'WARNING! Path [missing] to Java templates:';
        frm.EditPath.Text:= GetPathToTemplatePresumed();
        if frm.ShowModal = mrOK then
        begin
           FPathToJavaTemplates:= frm.PathMissing;
           frm.Free;
        end
        else
        begin
           frm.Free;
           Exit;
        end;
      end
      else
      begin
        if FPathToJavaTemplates <> GetPathToTemplatePresumed() then
        begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java templates was changed to:';
          frm.EditPath.Text:= GetPathToTemplatePresumed();
          if frm.ShowModal = mrOK then
          begin
            FPathToJavaTemplates:= frm.PathMissing;
            frm.Free;
          end
          else
          begin
            frm.Free;
            Exit;
          end;
        end;
      end;

      fileList:= TStringList.Create;
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

        fileList.Clear;
        GetFiles(FPathToJavaTemplates+DirectorySeparator+'lamwdesigner'+DirectorySeparator, fileList);

        tempList.Clear;
        for i:= 0 to fileList.Count - 1 do
        begin
          tempList.LoadFromFile(fileList.Strings[i]);
          for j:= 0 to tempList.Count-1 do
          begin
            if Pos(' native ', tempList.Strings[j]) > 0 then
                nativeMethodList.Add(Trim(tempList.Strings[j]));
          end;
        end;

        tempList.Clear;
        for i:= 0 to nativeMethodList.Count-1 do
        begin
          tempList.Add(GetEventSignature(nativeMethodList.Strings[i]));
        end;

        tempList.SaveToFile(FPathToJavaTemplates+DirectorySeparator+'ControlsEvents.txt');
        nativeMethodList.SaveToFile(FPathToJavaTemplates+DirectorySeparator+'methods.native');

      end;
      nativeMethodList.Free;
      tempList.Free;
      fileList.Free;

    finally
      Free;
    end;
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
var
  lisDir: TStringList;
  auxStr1: string;
  i, tApi, mApi: integer;
begin
        //C:\adt32\sdk\platforms
  lisDir:= TStringList.Create;

  ListBoxTargetAPI.Clear;
  FindAllDirectories(lisDir, FPathToAndroidSDK+PathDelim+'platforms', False);
  if lisDir.Count > 0 then
  begin
    for i:=0 to  lisDir.Count-1 do
    begin
       auxStr1:= lisDir.Strings[i];
       auxStr1 := Copy(auxStr1, LastDelimiter('-', auxStr1) + 1, MaxInt);
       ListBoxTargetAPI.Items.Add(auxStr1);
    end;
    if FIndexTargetApi < 0  then FIndexTargetApi:= 0;

    if FIndexTargetApi > (ListBoxTargetAPI.Count-1) then
       FIndexTargetApi:= ListBoxTargetAPI.Count-1;

    ListBoxTargetAPI.ItemIndex:= FIndexTargetApi;

    FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];
    tApi:= StrToInt(FTargetApi);

    if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
    mApi:= StrToInt(ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex]);
    if  mApi > tApi then
        ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.IndexOf(FTargetApi);

    if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;

    FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

  end
  else
  begin
    ShowMessage('Fail! '+'Folder "'+FPathToAndroidSDK+DirectorySeparator+'platforms" is Empty!!');
    lisDir.Free;
    Exit;
  end;

  lisDir.Clear;
  ListBoxPlatform.Clear;
  FindAllDirectories(lisDir, FPathToAndroidNDK+PathDelim+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to  lisDir.Count-1 do
    begin
       auxStr1:= lisDir.Strings[i];
       auxStr1 := Copy(auxStr1, LastDelimiter('-', auxStr1) + 1, MaxInt);

       if auxStr1 <> '' then
         if StrToInt(auxStr1) > 13 then
            ListBoxPlatform.Items.Add(auxStr1);
    end;

    if FIndexNdkPlatformApi < 0  then FIndexNdkPlatformApi:= 0;

    if FIndexNdkPlatformApi > (ListBoxPlatform.Count-1) then
       FIndexNdkPlatformApi:= ListBoxPlatform.Count-1;

    ListBoxPlatform.ItemIndex:= FIndexNdkPlatformApi;
    FAndroidNdkPlatform:= 'android-'+ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]

  end
  else
  begin
    ShowMessage('Fail! '+'Folder "'+FPathToAndroidNDK+DirectorySeparator+'platforms" is Empty!!');
    lisDir.Free;
    Exit;
  end;

  lisDir.Free;

  if EditPathToWorkspace.Text <> '' then
     ComboSelectProjectName.SetFocus
  else EditPathToWorkspace.SetFocus;

  if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';

  if ListBoxPlatform.ItemIndex < 0 then ListBoxPlatform.ItemIndex:= 0;
  StatusBarInfo.Panels.Items[0].Text:='Ndk: '+ GetCodeNameByApi(ListBoxPlatform.Items[ListBoxPlatform.ItemIndex]);

  if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
  StatusBarInfo.Panels.Items[1].Text:= 'MinSdk: '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);

  if ListBoxTargetAPI.ItemIndex < 0 then ListBoxTargetAPI.ItemIndex:= 0;
  StatusBarInfo.Panels.Items[2].Text:='Target: '+ GetCodeNameByApi(ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex]);

  ListBoxPlatform.MakeCurrentVisible;
  ListBoxMinSDK.MakeCurrentVisible;
  ListBoxTargetAPI.MakeCurrentVisible;

  if FPathToAndroidNDK <> '' then
    FPrebuildOSYS:= GetPrebuiltDirectory();

end;

procedure TFormWorkspace.ComboBoxThemeChange(Sender: TObject);
var
  api21Index, api, apiTarget, i: integer;
begin
  apiTarget:= StrToInt(ListBoxTargetAPI.GetSelectedText);

  if apiTarget < 11 then
  begin
    ShowMessage('Warning:'+
                 #10#13+'"Holo Theme" need TargetSdkApi >= 11'+ //TODO: Theme.Holo.NoActionBar.Fullscreen
                 #10#13+'"Holo Theme + ActionBar" need TargetSdkApi >= 14'+
                 #10#13+'"Material Theme" need TargetSdkApi >= 21');
    ComboBoxTheme.ItemIndex:= 0; //default
    Exit;
  end;

  if (apiTarget < 14) and (Pos('ActionBar', ComboBoxTheme.Text) > 0) then
  begin
    ShowMessage('Warning:'+
                 #10#13+'"Holo Theme + ActionBar" need TargetSdkApi >= 14');
    ComboBoxTheme.ItemIndex:= 0; //default
    Exit;
  end;

  if (apiTarget < 21) and
     (Pos('Material', ComboBoxTheme.Text) > 0) then
  begin
        api21Index:= -1;
        for i:=0 to ListBoxTargetAPI.Count-1 do
        begin
            api:= StrToInt(ListBoxTargetAPI.Items.Strings[i]);
            if   api >= 21 then
            begin
              api21Index:= i;
              if api = 21 then
              begin
                 break;
               end;
            end
        end;
        if api21Index <> -1 then
        begin
          ListBoxTargetAPI.ItemIndex:= api21Index;
          ShowMessage('Warning: TargetSdkApi changed to ['+ListBoxTargetAPI.GetSelectedText+']');
        end
        else
        begin
          ShowMessage('Warning: "Material Theme" need TargetSdkApi >= 21!');
          ComboBoxTheme.ItemIndex:= 0; //default
        end;
  end;
end;

procedure TFormWorkspace.CheckBoxPIEClick(Sender: TObject);
begin
  FPieChecked:= CheckBoxPIE.Checked;
end;

procedure TFormWorkspace.CheckBoxLibraryClick(Sender: TObject);
begin
  FLibraryChecked:=  CheckBoxLibrary.Checked;
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
  ShowMessage('Lamw: Lazarus Android Module Wizard' +sLineBreak+ '[Version 0.7 - 11 July - 2016]');
end;

procedure TFormWorkspace.SpeedButtonHintThemeClick(Sender: TObject);
begin
  ShowMessage('Warning:'+
               sLineBreak+'"Holo Theme" need TargetSdkApi >= 11'+
               sLineBreak+'"Holo Theme + ActionBar" need TargetSdkApi >= 14'+
               sLineBreak+'"Material Theme" need TargetSdkApi >= 21'+
               sLineBreak+' ' +
               sLineBreak+'Old Projects [target >= 11]:'+
               sLineBreak+'Go to ..\res\values-vXX'+
               sLineBreak+'and modifier "styles.xml" [parent attribute]'+
               sLineBreak+'Example:'+
               sLineBreak+'<style name="AppBaseTheme" parent="android:Theme.Holo.Light">');
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);  //called by ...
var
  i1,  i3,  j1: integer;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  try
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FPackagePrefaceName:= ReadString('NewProject','AntPackageName', '');

    FAntBuildMode:= 'debug'; //default...
    FTouchtestEnabled:= 'True'; //default

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity = '' then FMainActivity:= 'App';

    ListBoxPlatform.Clear;

    i1:= StrToIntDef(ReadString('NewProject','InstructionSet', ''), 0);

    i3:= StrToIntDef(ReadString('NewProject','ProjectModel', ''), 0);

    j1:= StrToIntDef(ReadString('NewProject','MinApi', ''), 2); // default Api 14

    if (j1 >= 0) and (j1 < ListBoxMinSDK.Items.Count) then
       ListBoxMinSDK.ItemIndex:= j1
    else
       ListBoxMinSDK.ItemIndex:= 2; //default!

    FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];

    FIndexNdkPlatformApi:= StrToIntDef(ReadString('NewProject','AndroidPlatform', ''), 0);

    FIndexTargetApi:= StrToIntDef(ReadString('NewProject','TargetApi', ''), 0); //default index 0

    ComboSelectProjectName.Items.Clear;
    FindAllDirectories(ComboSelectProjectName.Items, FPathToWorkspace, False);

    FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');

  finally
    Free;
  end;

  RGInstruction.ItemIndex:= i1;

  if i3 = 0 then FProjectModel:= 'Eclipse'
  else FProjectModel:= 'Ant';

  FInstructionSet:= 'x86'; //RGInstruction.Items[RGInstruction.ItemIndex];
  FFPUSet:= ''; //x86

  if RGInstruction.ItemIndex = 0 then begin FFPUSet:= 'Soft';  FInstructionSet:='ARMv6'; end;
  if RGInstruction.ItemIndex = 1 then begin FFPUSet:= 'Soft';  FInstructionSet:='ARMv7a';end;
  if RGInstruction.ItemIndex = 2 then begin FFPUSet:= 'VFPv3'; FInstructionSet:='ARMv7a';end;
  if RGInstruction.ItemIndex = 3 then FInstructionSet:='x86';
  if RGInstruction.ItemIndex = 4 then FInstructionSet:='Mipsel';

  EditPathToWorkspace.Text := FPathToWorkspace;
  EditPackagePrefaceName.Text := FPackagePrefaceName;
  //verify if some was not load!
  Self.LoadPathsSettings(FFileName);

end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);
begin
   with TInifile.Create(pFilename) do
   try
      WriteString('NewProject', 'PathToWorkspace', EditPathToWorkspace.Text);

      WriteString('NewProject', 'FullProjectName', FAndroidProjectName);
      WriteString('NewProject', 'InstructionSet', IntToStr(RGInstruction.ItemIndex));

      if  FProjectModel = 'Ant' then            //IntToStr(RGProjectType.ItemIndex)
        WriteString('NewProject', 'ProjectModel', '1')  //Ant
      else
        WriteString('NewProject', 'ProjectModel', '0'); //Eclipse


      if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lamw';
        WriteString('NewProject', 'AntPackageName', LowerCase(Trim(EditPackagePrefaceName.Text)));

      if ListBoxPlatform.ItemIndex < 0 then
        WriteString('NewProject', 'AndroidPlatform', '1')    //ndk plataform
      else
        WriteString('NewProject', 'AndroidPlatform', IntToStr(ListBoxPlatform.ItemIndex));

      if ListBoxMinSDK.ItemIndex < 0 then ListBoxMinSDK.ItemIndex:= 2;
      WriteString('NewProject', 'MinApi', IntToStr(ListBoxMinSDK.ItemIndex));

      with ListBoxTargetAPI do begin
        if (ItemIndex < 0) and (Count > 0) then ItemIndex:= 0;
        if ItemIndex >= 0 then
          WriteString('NewProject', 'TargetApi', IntToStr(ItemIndex));
      end;

      WriteString('NewProject', 'AntBuildMode', 'debug'); //default...

      if FMainActivity = '' then FMainActivity:= 'App';
      WriteString('NewProject', 'MainActivity', FMainActivity); //dummy

      WriteString('NewProject', 'SupportV4', FSupportV4); //dummy

      WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates);
      WriteString('NewProject', 'PathToJavaJDK', FPathToJavaJDK);
      WriteString('NewProject', 'PathToAndroidNDK', FPathToAndroidNDK);
      WriteString('NewProject', 'PathToAndroidSDK', FPathToAndroidSDK);
      WriteString('NewProject', 'PathToAntBin', FPathToAntBin);
      WriteString('NewProject', 'PathToGradle', FPathToGradle);  //optional ...

      FPrebuildOSYS:= GetPrebuiltDirectory();
      WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);
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

end.

