unit AndroidProjOptions;

{$mode objfpc}{$H+}

interface

uses

  Classes, SysUtils, Types, LazFileUtils, laz2_XMLRead, Laz2_DOM, LCLVersion,
  AvgLvlTree, LazIDEIntf, IDEOptionsIntf, ProjectIntf, SourceChanger, Forms, Controls,
  Dialogs, Grids, StdCtrls, LResources, ExtCtrls, Spin, ComCtrls, Buttons,
  Themes{, IDEOptEditorIntf};

const
  cMinAPI = 10;
  cMaxAPI = 35;

type

  { TLamwAndroidManifestOptions }

  TLamwAndroidManifestOptions = class
  private
    xml: TXMLDocument; // AndroidManifest.xml
    FFileName: string;
    FPermissions: TStringList;
    FPermNames: TStringToStringTree;
    FUsesSDKNode: TDOMElement;
    FApplicationNode: TDOMElement;
    FMinSdkVersion, FTargetSdkVersion: integer;
    FOldMinSdkVersion: integer;
    FVersionCode: integer;
    FVersionName: string;
    FLabelAvailable: boolean;
    FLabel, FRealLabel: string;
    FIconFileName: string;
    FSupport:boolean;
    //FTheme: string;

    function GetString(const XMLPath, Ref: string; out Res: string): boolean;
    //function GetThemeName: string;
    procedure SetString(const XMLPath, Ref, NewValue: string);
    procedure Clear;
    procedure UpdateBuildXML;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(AFileName: string);
    procedure Save(isGradle : boolean);

    //function GetThemeName(API: integer): string;

    property Permissions: TStringList read FPermissions;
    property PermNames: TStringToStringTree read FPermNames;
    property MinSDKVersion: integer read FMinSdkVersion write FMinSdkVersion;
    property TargetSDKVersion: integer read FTargetSdkVersion write FTargetSdkVersion;
    property VersionCode: integer read FVersionCode write FVersionCode;
    property VersionName: string read FVersionName write FVersionName;
    property AppLabel: string read FRealLabel write FRealLabel;
    property IconFileName: string read FIconFileName;
    property Support:boolean read FSupport write FSupport;
    //property ThemeName: string read GetThemeName;
  end;


implementation

uses

  {$if (lcl_fullversion > 1090000) }
  IDEOptEditorIntf,
  {$endif}
  laz2_XMLWrite, FileUtil, CodeToolManager, CodeTree, LinkScanner,
  CodeAtom, Graphics, ExtDlgs, AndroidWizard_intf, LamwDesigner, LamwSettings,
  FPCanvas, FPimage, FPReadPNG, FPWritePNG, strutils;

{$R *.lfm}

type

  { TLamwProjectOptions }

TLamwProjectOptions = class(TAbstractIDEOptionsEditor)
 cbChipset: TComboBox;
 cbTheme: TComboBox;
 cbLaunchIconSize: TComboBox;
 cbBuildSystem: TComboBox;
 edLabel: TEdit;
 edVersionName: TEdit;
 ErrorPanel: TPanel;
 gbVersion: TGroupBox;
 GroupBox1: TGroupBox;
 ImageList1: TImageList;
 imLauncherIcon: TImage;
 Label1: TLabel;
 LabelSupport: TLabel;
 CheckBoxSupport: TCheckBox; 
 lblGradleHint: TLabel;
 Label2: TLabel;
 Label3: TLabel;
 Label4: TLabel;
 Label5: TLabel;
 Label6: TLabel;
 Label7: TLabel;
 Label8: TLabel;
 Label9: TLabel;
 lblErrorMessage: TLabel;
 PageControl1: TPageControl;
 PermissonGrid: TStringGrid;
 rbOrientation: TRadioGroup;
 seMinSdkVersion: TSpinEdit;
 seTargetSdkVersion: TComboBox;
 seVersionCode: TSpinEdit;
 SpeedButton1: TSpeedButton;
 SpeedButtonHintTheme: TSpeedButton;
 tsMiscellaneous: TTabSheet;
 tsAppl: TTabSheet;
 tsManifest: TTabSheet;
 procedure cbBuildSystemChange(Sender: TObject);
 procedure cbBuildSystemSelect(Sender: TObject);
 procedure cbChipsetChange(Sender: TObject);
 procedure cbLaunchIconSizeSelect(Sender: TObject);
 procedure cbThemeChange(Sender: TObject);
 procedure PermissonGridCheckboxToggled({%H-}Sender: TObject; {%H-}aCol,
 {%H-}aRow: integer; {%H-}aState: TCheckboxState);
 procedure PermissonGridDrawCell(Sender: TObject; aCol, aRow: integer;
   aRect: TRect; {%H-}aState: TGridDrawState);
 procedure PermissonGridMouseDown(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: integer);
 procedure PermissonGridMouseMove(Sender: TObject; {%H-}Shift: TShiftState;
   X, Y: integer);
 procedure seTargetSdkVersionEditingDone(Sender: TObject);
 procedure SpeedButton1Click(Sender: TObject);
 procedure SpeedButton2Click(Sender: TObject);
 procedure SpeedButtonHintThemeClick(Sender: TObject);
private
 { private declarations }
const
 Drawable: array [0..5] of record
     Size: integer;
     Suffix: string;
   end
 = ((Size: 36; Suffix: 'ldpi'),
   (Size: 48; Suffix: 'mdpi'),
   (Size: 72; Suffix: 'hdpi'),
   (Size: 96; Suffix: 'xhdpi'),
   (Size: 144; Suffix: 'xxhdpi'),
   (Size: 192; Suffix: 'xxxhdpi'));
private
 IsLamwProject: boolean;
 FManifest: TLamwAndroidManifestOptions;
 FIconsPathDrawable: string; // ".../res/drawable-"
 FIconsPathMipmap  : string; // ".../res/mipmap-"
 FChkBoxDrawData: array [TCheckBoxState] of record
   Details, DetailsHot: TThemedElementDetails;
   CSize: TSize;
 end;

 FMinSdk : string;
 FTargetSdk : string;
 FAndroidTheme : string;
 FBuildSystem: string;
 FProjectPath: string;
 FDefaultTheme: string;
 FChipSetTarget: string;

 FAllPermissionsState: TCheckBoxState;
 FAllPermissionsHot: boolean;
 function GetAllPermissonsCheckBoxBounds(InRect: TRect): TRect;
 procedure ErrorMessage(const msg: string);
 procedure FillPermissionGrid(Permissions: TStringList;
   PermNames: TStringToStringTree);
 procedure SetControlsEnabled(ts: TTabSheet; en: boolean);
 procedure ShowLauncherIcon;
private
 // gApp.Screen.Style := <orientation> statements
 function GetCurrentAppScreenStyle: string;
 function FindAppScreenStyleStatement(
   out StartPos, ssConstStartPos, EndPos: integer): boolean;
 function GetAppScreenStyleStatement(ssConstStartPos: integer;
   out ssConstVal: string): boolean;
 function SetAppScreenStyleStatement(const ssNewConstVal: string): boolean;
 function RemoveAppScreenStyleStatement: boolean;
 procedure TryUpdateStyleXML();
 function GetChipSetTarget(var cbIndex: integer): string;
 function GetBuildMode(filename: string; index: integer): string;
 procedure TryChangeChipset();
public
 { public declarations }
 constructor Create(AOwner: TComponent); override;
 destructor Destroy; override;
 class function SupportedOptionsClass: TAbstractIDEOptionsClass; override;
 function GetTitle: string; override;
 procedure Setup({%H-}ADialog: TAbstractOptionsEditorDialog); override;
 procedure ReadSettings({%H-}AOptions: TAbstractIDEOptions); override;
 procedure WriteSettings({%H-}AOptions: TAbstractIDEOptions); override;
end;


  { TMyCanvas }

  TMyCanvas = class(TCanvas)
  private
    FImage: TFPMemoryImage;
  protected
    procedure SetColor(x, y: integer; const Value: TFPColor); override;
  public
    constructor Create;
    destructor Destroy; override;
    property Image: TFPMemoryImage read FImage;
  end;

procedure ResizePNG(p: TPortableNetworkGraphic; NeedSize: integer);
var
  ms: TMemoryStream;
  r: TFPReaderPNG;
  mi: TFPMemoryImage;
  c: TMyCanvas;
begin
  ms := TMemoryStream.Create;
  p.SaveToStream(ms);
  ms.Position := 0;
  mi := TFPMemoryImage.Create(0, 0);
  r := TFPReaderPNG.Create;
  mi.LoadFromStream(ms, r);
  r.Free;
  ms.Free;
  c := TMyCanvas.Create;
  c.Image.SetSize(NeedSize, NeedSize);
  TFPCustomCanvas(c).StretchDraw(0, 0, NeedSize, NeedSize, mi);
  mi.Free;
  p.Assign(c.Image);
  c.Free;
end;

function IsAllCharNumber(pcString: PChar): boolean;
begin
  Result := False;
  if StrLen(pcString)=0 then exit;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then
      Exit;
    Inc(pcString);
  end;
  Result := True;
end;

{ TMyCanvas }

procedure TMyCanvas.SetColor(x, y: integer; const Value: TFPColor);
begin
  FImage.Colors[x, y] := Value;
end;

constructor TMyCanvas.Create;
begin
  inherited;
  FImage := TFPMemoryImage.Create(0, 0);
end;

destructor TMyCanvas.Destroy;
begin
  FImage.Free;
  inherited;
end;

{ TLamwAndroidManifestOptions }

function TLamwAndroidManifestOptions.GetString(const XMLPath, Ref: string;
  out Res: string): boolean;
var
  x: TXMLDocument;
  tag, Name: string;
  n: TDOMNode;
begin
  Result := False;
  tag := Copy(Ref, 2, Pos('/', Ref) - 2);
  Name := Copy(Ref, Pos('/', Ref) + 1, MaxInt);
  if not FileExists(XMLPath) then
    Exit;
  ReadXMLFile(x, XMLPath);
  try
    n := x.DocumentElement.FirstChild;
    while n <> nil do
    begin
      if (n is TDOMElement) then
        with TDOMElement(n) do
          if (TagName = tag) and (AttribStrings['name'] = Name) then
          begin
            Res := TextContent;
            Result := True;
            Exit;
          end;
      n := n.NextSibling;
    end;
  finally
    x.Free
  end;
end;

(*
function TLamwAndroidManifestOptions.GetThemeName: string;
begin
  Result := GetThemeName(FTargetSdkVersion);
end;
*)

procedure TLamwAndroidManifestOptions.SetString(const XMLPath, Ref, NewValue: string);
var
  x: TXMLDocument;
  n: TDOMNode;
  tag, Name: string;
  Changed: boolean;
begin
  tag := Copy(Ref, 2, Pos('/', Ref) - 2);
  Name := Copy(Ref, Pos('/', Ref) + 1, MaxInt);
  ReadXMLFile(x, XMLPath);
  try
    n := x.DocumentElement.FirstChild;
    Changed := False;
    while n <> nil do
    begin
      if n is TDOMElement then
        with TDOMElement(n) do
          if (TagName = tag) and (AttribStrings['name'] = Name) then
          begin
            TextContent := NewValue;
            Changed := True;
            Break;
          end;
      n := n.NextSibling;
    end;
    if not Changed then
    begin
      n := x.CreateElement(tag);
      with TDOMElement(n) do
      begin
        AttribStrings['name'] := Name;
        TextContent := NewValue;
      end;
      x.DocumentElement.AppendChild(n);
    end;
    WriteXMLFile(x, XMLPath);
  finally
    x.Free
  end;
end;

procedure TLamwAndroidManifestOptions.Clear;
begin
  xml.Free;
  FUsesSDKNode := nil;
  FMinSdkVersion := 14;
  FTargetSdkVersion := 21;
  FSupport:=False;
  FPermissions.Clear;
end;

procedure TLamwAndroidManifestOptions.UpdateBuildXML;
var
  fn: string;
  build: TXMLDocument;
  n: TDOMNode;
  aSupportLib:TSupportLib;
  strList: TStringList;
  i: integer;
  smallProjName: string;
  pathToAndroidSDK: string;
  locationSrc: string;
  tempStr, findString, oldTargetStr, oldCompileSdkVersion: string;
  p, p2: integer;
  cpuTarget:string;
  includeList: TStringList;
  universalApk: boolean;
  pathToAndroidProject: string;
  TargetBuildFileName: string;
begin
  fn := ExtractFilePath(FFileName) + 'build.xml';
  if not FileExists(fn) then
    Exit;
  ReadXMLFile(build, fn);
  try
    smallProjName := build.DocumentElement.AttribStrings['name'];
    n := build.DocumentElement.FirstChild;
    while n <> nil do
    begin
      if n is TDOMElement then
        with TDOMElement(n) do
        begin

          if (TagName = 'property') and (AttribStrings['name'] = 'sdk.dir') then
          begin
            pathToAndroidSDK := AttribStrings['location'];
          end;

          if (TagName = 'property') and (AttribStrings['name'] = 'target') then
          begin
            oldTargetStr := Copy(AttribStrings['value'], 9, 2);
            {AttribStrings['value'] := 'android-' + IntToStr(FTargetSdkVersion);
             WriteXMLFile(build, fn);
             Break;}
          end;

          if (TagName = 'property') and (AttribStrings['name'] = 'src.dir') then
          begin
            locationSrc := AttribStrings['location'];
            Break;
          end;

        end;
      n := n.NextSibling;
    end;
  finally
    build.Free
  end;

  strList := TStringList.Create;
  strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
  strList.Add('<project name="' + smallProjName + '" default="help">');
  strList.Add('<property name="sdk.dir" location="' + pathToAndroidSDK + '"/>');
  strList.Add('<property name="target" value="android-' +
    IntToStr(FTargetSdkVersion) + '"/>');
  strList.Add('<property file="ant.properties"/>');
  strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');
  // tk Generate code to allow conditional compilation in our java sources
  strList.Add('');
  strList.Add('<!-- Tags required to enable conditional compilation in java sources -->');
  strList.Add('<property name="src.dir" location="' + locationSrc + '"/>');
  strList.Add('<property name="source.dir" value="${src.dir}/${target}" />');
  strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');

  strList.Add('');
  strList.Add('<!-- API version properties, modify according to your API level -->');
  for i := cMinAPI to cMaxAPI do
  begin
    if i <= FTargetSdkVersion then
      strList.Add('<property name="api' + IntToStr(i) + '" value="true"/>')
    else
      strList.Add('<property name="api' + IntToStr(i) + '" value="false"/>');
  end;

  strList.Add('');
  strList.Add('<!-- API conditions, do not modify -->');
  for i := cMinAPI to cMaxAPI do
  begin
    strList.Add('<condition property="ifdef_api' + IntToStr(i) + 'up" value="/*">');
    strList.Add('  <equals arg1="${api' + IntToStr(i) + '}" arg2="false"/>');
    strList.Add('</condition>');
    strList.Add('<condition property="endif_api' + IntToStr(i) + 'up" value="*/">');
    strList.Add('  <equals arg1="${api' + IntToStr(i) + '}" arg2="false"/>');
    strList.Add('</condition>');
    strList.Add('<property name="ifdef_api' + IntToStr(i) + 'up" value=""/>');
    strList.Add('<property name="endif_api' + IntToStr(i) + 'up" value=""/>');
  end;

  strList.Add('');
  strList.Add('<!-- Copy & filter java sources for defined Android target, do not modify -->');
  strList.Add('<copy todir="${src.dir}/${target}">');
  strList.Add('  <fileset dir="${src.dir}">');
  strList.Add('    <include name="*.java"/>');
  strList.Add('  </fileset>');
  strList.Add('  <filterset begintoken="//[" endtoken="]">');
  for i := cMinAPI to cMaxAPI do
  begin
    strList.Add('    <filter token="ifdef_api' + IntToStr(i) +
      'up" value="${ifdef_api' + IntToStr(i) + 'up}"/>');
    strList.Add('    <filter token="endif_api' + IntToStr(i) +
      'up" value="${endif_api' + IntToStr(i) + 'up}"/>');
  end;
  strList.Add('  </filterset>');
  strList.Add('</copy>');
  // end tk
  strList.Add('</project>');
  strList.SaveToFile(ExtractFilePath(FFileName) + 'build.xml');

  strList.Clear;
  strList.Add('# This file is automatically generated by Android Tools.');
  strList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
  strList.Add('#');
  strList.Add('# This file must be checked in Version Control Systems.');
  strList.Add('#');
  strList.Add('# To customize properties used by the Ant build system edit');
  strList.Add('# "ant.properties", and override values to adapt the script to your');
  strList.Add('# project structure.');
  strList.Add('#');
  strList.Add(
    '# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
  strList.Add(
    '#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
  strList.Add(' ');
  strList.Add('# Project target.');
  strList.Add('target=android-' + IntToStr(FTargetSdkVersion));
  strList.SaveToFile(ExtractFilePath(FFileName) + 'project.properties');


  cpuTarget := ExtractFileDir(LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
  cpuTarget := ExtractFileName(cpuTarget);

  includeList:= TStringList.Create;
  includeList.Delimiter:= ',';
  includeList.StrictDelimiter:= True;
  includeList.Sorted:= True;
  includeList.Duplicates:= dupIgnore;

  includeList.Add(''''+cpuTarget+''''); //initial  Instruction Set

  PathToAndroidProject:= ExtractFilePath(FFileName);
  TargetBuildFileName := ExtractFileName(LazarusIDE.ActiveProject.LazCompilerOptions.CreateTargetFilename);

  if FileExists(pathToAndroidProject + 'libs\armeabi\' + TargetBuildFileName ) then
  begin
    includeList.Add('''armeabi''');
  end;

  if FileExists(pathToAndroidProject + 'libs\armeabi-v7a\' + TargetBuildFileName ) then
  begin
    includeList.Add('''armeabi-v7a''');
  end;

  if FileExists(pathToAndroidProject + 'libs\arm64-v8a\' + TargetBuildFileName ) then
  begin
    includeList.Add('''arm64-v8a''');
  end;

  if FileExists(pathToAndroidProject + 'libs\x86_64\' + TargetBuildFileName ) then
  begin
    includeList.Add('''x86_64''');
  end;

  if FileExists(pathToAndroidProject + 'libs\x86\' + TargetBuildFileName ) then
  begin
    includeList.Add('''x86''');
  end;

  if FileExists(pathToAndroidProject + 'libs\mips\' + TargetBuildFileName ) then
  begin
    includeList.Add('''mips''');
  end;

  cpuTarget:= includeList.DelimitedText; //NEW! includeList based...

  universalApk:= False;
  if includeList.Count > 1 then
    universalApk:= True;

  includeList.Free;

  strList.Clear;
  if FileExists(ExtractFilePath(FFileName) + 'build.gradle') then
  begin
    strList.LoadFromFile(ExtractFilePath(FFileName) + 'build.gradle');
    tempStr := StringReplace(strList.Text, 'targetSdkVersion ' + oldTargetStr,
      'targetSdkVersion ' + IntToStr(FTargetSdkVersion), [rfIgnoreCase]);  //targetSdkVersion 23
    strList.Text := tempStr;

    for i := 0 to (strList.Count-1) do
    begin
      tempStr := strList.Strings[i];
      if Pos(' include ',tempStr)>0 then
      begin
        p:=Pos('include',tempStr);
        Delete(tempStr,p,MaxInt);
        tempStr:=tempStr+'include '+cpuTarget;  //NEW! includeList based...
        strList.Strings[i]:=tempStr;
        break;
      end;
    end;

    for i := 0 to (strList.Count-1) do
    begin
      tempStr := strList.Strings[i];
      if Pos(' universalApk ',tempStr)>0 then
      begin
        p:=Pos('universalApk',tempStr);

        Delete(tempStr,p,MaxInt);

        if universalApk then
          tempStr:=tempStr+'universalApk true'
        else
          tempStr:=tempStr+'universalApk false';

        strList.Strings[i]:=tempStr;
        break;
      end;
    end;

    if FOldMinSdkVersion <> FMinSdkVersion then
    begin
      tempStr := StringReplace(strList.Text, 'minSdkVersion ' + IntToStr(FOldMinSdkVersion),
        'minSdkVersion ' + IntToStr(FMinSdkVersion), [rfIgnoreCase]);  //minSdkVersion 14
      strList.Text := tempStr;
    end;

    p := Pos('compileSdkVersion ', strList.Text);  //0.8.6.2
    if p > 0 then
    begin
      tempStr := Trim(Copy(strList.Text, p, Length('compileSdkVersion ') + 2));
    //compileSdkVersion 25

      p2 := Pos(' ', tempStr);
      oldCompileSdkVersion:= Trim(Copy(tempStr, p2 + 1, 2));
      findString:='compileSdkVersion ';
    end
    else
    begin
       p := Pos('compileSdk ', strList.Text);  //0.8.6.3
     //compileSdk 25

      p2 := Pos(' ', tempStr);
      oldCompileSdkVersion:= Trim(Copy(tempStr, p2 + 1, 2));
      findString:='compileSdk ';
    end;

    if IsAllCharNumber(PChar(oldCompileSdkVersion)) then
    begin
      if FTargetSdkVersion <> StrToInt(oldCompileSdkVersion) then
      begin

        tempStr := strList.Text;

        if (Pos(findString,tempStr)>0) then
          tempStr := StringReplace(tempStr, findString+oldCompileSdkVersion, findString+IntToStr(FTargetSdkVersion), [rfIgnoreCase]);

        for aSupportLib in SupportLibs do
        begin
          if (Pos(aSupportLib.Name,tempStr)>0) then
            tempStr := StringReplace(tempStr, aSupportLib.Name+oldCompileSdkVersion, aSupportLib.Name(*+IntToStr(FTargetSdkVersion)*), [rfIgnoreCase]);
        end;

        strList.Text := tempStr;
      end;
    end;

    strList.SaveToFile(ExtractFilePath(FFileName) + 'build.gradle');
  end;

  strList.Free;

end;

constructor TLamwAndroidManifestOptions.Create;

  procedure AddPerm(PermVisibleName: string; android_name: string = '');
  begin
    if android_name = '' then
      android_name := 'android.permission.' +
        StringReplace(UpperCase(PermVisibleName), ' ', '_', [rfReplaceAll]);
    FPermNames[android_name] := PermVisibleName;
  end;

begin
  FIconFileName := 'ic_launcher'; // ".png"
  FPermissions := TStringList.Create;
  FPermNames := TStringToStringTree.Create(True);
  AddPerm('Bluetooth');
  AddPerm('Access bluetooth share');
  AddPerm('Access coarse location');
  AddPerm('Access fine location');
  AddPerm('Access network state');
  AddPerm('Access wifi state');
  AddPerm('Bluetooth admin');
  AddPerm('Call phone');
  AddPerm('Camera');
  AddPerm('Change network state');
  AddPerm('Change wifi state');
  AddPerm('Internet');
  AddPerm('NFC');
  AddPerm('Read contacts');
  AddPerm('Read external storage');
  AddPerm('Read owner data');
  AddPerm('Read phone state');
  AddPerm('Receive SMS');
  AddPerm('Restart packages');
  AddPerm('Send SMS');
  AddPerm('Vibrate');
  AddPerm('Write contacts');
  AddPerm('Write external storage');
  AddPerm('Write owner data');
  AddPerm('Write user dictionary');
  AddPerm('Wake lock');
  { todo:
  Access location extra commands
  Access mock location
  Add voicemail
  Authenticate accounts
  Battery stats
  Bind accessibility service
  Bind device admin
  Bind input method
  Bind remoteviews
  Bind text service
  Bind vpn service
  Bind wallpaper
  Broadcast sticky
  Change configuration
  Change wifi multicast state
  Clear app cache
  Disable keyguard
  Expand status bar
  Flashlight
  Get accounts
  Get package size
  Get tasks
  Global search
  Kill background processes
  Manage accounts
  Modify audio settings
  Process outgoing calls
  Read calendar
  Read call log
  Read history bookmarks
  Read profile
  Read SMS
  Read social stream
  Read sync settings
  Read sync stats
  Read user dictionary
  Receive boot completed
  Receive MMS
  Receive WAP push
  Record audio
  Reorder tasks
  Set alarm
  Set time zone
  Set wallpaper
  Subscribed feeds read
  Subscribed feeds write
  System alert window
  Use credentials
  Use SIP
  Vending billing (In-app Billing)
  Write calendar
  Write call log
  Write history bookmarks
  Write profile
  Write settings
  Write SMS
  Write social stream
  Write sync settings
  Write user dictionary
  + Advanced...
  }
  FPermissions.Sorted := True;
end;

destructor TLamwAndroidManifestOptions.Destroy;
begin
  FPermNames.Free;
  FPermissions.Free;
  xml.Free;
  inherited Destroy;
end;

procedure TLamwAndroidManifestOptions.Load(AFileName: string);
var
  i, j: integer;
  s, v: string;
  n: TDOMNode;
begin
  Clear;
  ReadXMLFile(xml, AFileName);
  FFileName := AFileName;
  if (xml = nil) or (xml.DocumentElement = nil) then
    Exit;
  with xml.DocumentElement do
  begin
    FVersionCode := StrToIntDef(AttribStrings['android:versionCode'], 1);
    FVersionName := AttribStrings['android:versionName'];
  end;
  with xml.DocumentElement.ChildNodes do
  begin
    FPermNames.GetNames(FPermissions);
    for i := Count - 1 downto 0 do
      if Item[i].NodeName = 'uses-permission' then
      begin
        s := Item[i].Attributes.GetNamedItem('android:name').TextContent;
        j := FPermissions.IndexOf(s);
        if j >= 0 then
          FPermissions.Objects[j] := TObject(PtrUInt(1))
        else
        begin
          v := Copy(s, RPos('.', s) + 1, MaxInt);
          FPermNames[s] := v;
          FPermissions.AddObject(s, TObject(PtrUInt(1)));
        end;
        xml.ChildNodes[0].DetachChild(Item[i]).Free;
      end
      else
      if Item[i].NodeName = 'uses-sdk' then
      begin
        FUsesSDKNode := Item[i] as TDOMElement;
        n := FUsesSDKNode.Attributes.GetNamedItem('android:minSdkVersion');
        if Assigned(n) then
        begin
          FMinSdkVersion := StrToIntDef(n.TextContent, FMinSdkVersion);
          FOldMinSdkVersion := FMinSdkVersion;
        end;
        n := FUsesSDKNode.Attributes.GetNamedItem('android:targetSdkVersion');
        if Assigned(n) then
          FTargetSdkVersion := StrToIntDef(n.TextContent, FTargetSdkVersion);
      end;
  end;
  n := xml.DocumentElement.FindNode('application');
  if n is TDOMElement then
  begin
    FApplicationNode := TDOMElement(n);
    FLabelAvailable := True;
    FLabel := TDOMElement(n).AttribStrings['android:label'];
    if (FLabel <> '') and (FLabel[1] = '@') then
    begin
      // @string/app_name
      // <string name="app_name">LamwGUIProject1</string>
      if not GetString(ExtractFilePath(FFileName) + PathDelim +
        'res' + PathDelim + 'values' + PathDelim + 'strings.xml', FLabel, FRealLabel) then
      begin
        FRealLabel := '<null>';
        FLabelAvailable := False;
      end;
    end
    else
      FRealLabel := FLabel;

    //FTheme := FApplicationNode.AttribStrings['android:theme'];  //@style/AppTheme
  end;
end;

procedure TLamwAndroidManifestOptions.Save(isGradle : boolean);
var
  i: integer;
  r: TDOMNode;
  n: TDOMElement;
  fn: string;
  strList: TStringList;
  fileGradle : string;
begin
  // writing manifest
  if not Assigned(xml) then
    Exit;

  xml.DocumentElement.AttribStrings['android:versionCode'] := IntToStr(FVersionCode);
  xml.DocumentElement.AttribStrings['android:versionName'] := FVersionName;

  strList    := nil;
  fileGradle := ExtractFilePath(FFileName) + PathDelim + 'build.gradle';

  if fileExists(fileGradle) then
  begin
   strList:= TStringList.Create;

   strList.LoadFromFile(fileGradle);

   for i := 0 to strList.Count - 1 do
   begin
     if pos('versionCode', strList.Strings[i]) > 1 then
      strList.Strings[i] := '            versionCode ' + intToStr(FVersionCode);

     if pos('versionName', strList.Strings[i]) > 1 then
     begin
      strList.Strings[i] := '            versionName "'+FVersionName+'"';
      break;
     end;
   end;

   strList.SaveToFile(fileGradle);

   strList.Free;
  end;

  if not Assigned(FUsesSDKNode) then
  begin
    FUsesSDKNode := xml.CreateElement('uses-sdk');
    with xml.DocumentElement do
      if ChildNodes.Count = 0 then
        AppendChild(FUsesSDKNode)
      else
        InsertBefore(FUsesSDKNode, ChildNodes[0]);
  end;
  with FUsesSDKNode do
  begin
    if not isGradle then // Gradle not need minSdkVersion
    begin
     AttribStrings['android:minSdkVersion'] := IntToStr(FMinSdkVersion);
     AttribStrings['android:targetSdkVersion'] := IntToStr(FTargetSdkVersion);
    end;
  end;

  // permissions
  r := FUsesSDKNode.NextSibling;
  for i := 0 to FPermissions.Count - 1 do
  begin
    n := xml.CreateElement('uses-permission');
    n.AttribStrings['android:name'] := FPermissions[i];
    if Assigned(r) then
      xml.ChildNodes[0].InsertBefore(n, r)
    else
      xml.ChildNodes[0].AppendChild(n);

    if FPermissions[i] = 'android.permission.WRITE_EXTERNAL_STORAGE' then
    begin
     n.AttribStrings['android:maxSdkVersion'] := '28';

     if Assigned(r) then
      xml.ChildNodes[0].InsertBefore(n, r)
     else
      xml.ChildNodes[0].AppendChild(n);
    end;
  end;

  UpdateBuildXML;

  if FLabelAvailable and (FLabel <> '') and (FLabel[1] <> '@') and
    (FApplicationNode <> nil) then
    FApplicationNode.AttribStrings['android:label'] := FLabel;
  WriteXMLFile(xml, FFileName);

  if FLabelAvailable and (FLabel <> '') and (FLabel[1] = '@') then
  begin
    fn := ExtractFilePath(FFileName) + PathDelim + 'res' + PathDelim;
    fn := fn + 'values' + PathDelim + 'strings.xml';
    if FileExists(fn) then
      SetString(fn, FLabel, FRealLabel);
  end;

  // refresh theme
  with LazarusIDE do
    if (ActiveProject.FileCount > 1) and (ActiveProject.CustomData['LAMW'] = 'GUI') then
      (TAndroidModule(GetDesignerWithProjectFile(ActiveProject.Files[1],
        True).LookupRoot).Designer as TAndroidWidgetMediator).UpdateTheme;
end;

(*
function TLamwAndroidManifestOptions.GetThemeName(API: integer): string;
var
  fn, base: string;
  x: TXMLDocument;
  n: TDOMNode;
begin
  Result := ''; //FTheme;   //"@style/AppTheme"
  if Copy(FTheme, 1, 7) <> '@style/' then
    Exit;
  Delete(Result, 1, 7);
  base := ExtractFilePath(FFileName) + 'res' + PathDelim + 'values';
  fn := base + PathDelim + 'styles.xml';
  repeat
    if not FileExists(fn) then
      Exit;
    ReadXMLFile(x, fn);
    try
      n := x.DocumentElement.FirstChild;
      while n <> nil do
      begin
        if n is TDOMElement then
          with TDOMElement(n) do
          begin
            if (TagName = 'style') and (AttribStrings['name'] = Result) then
              if AttribStrings['parent'] <> '' then
              begin
                Result := AttribStrings['parent'];
                n := x.DocumentElement.FirstChild;
                Continue;
              end
              else
                Exit;
          end;
        n := n.NextSibling;
      end;
      if API <= 0 then
        Exit;
      repeat
        fn := base + '-v' + IntToStr(API) + PathDelim + 'styles.xml';
        Dec(API);
      until FileExists(fn) or (API = 0);
    finally
      x.Free;
    end;
  until strlcomp('android:', PChar(Result), 8) = 0;
  Delete(Result, 1, 8);
end;
*)

{ TLamwProjectOptions }

procedure TLamwProjectOptions.SetControlsEnabled(ts: TTabSheet; en: boolean);
var
  i: integer;
begin
  with ts do
    for i := 0 to ControlCount - 1 do
      Controls[i].Enabled := en;
  ErrorPanel.Enabled := True;
end;

procedure TLamwProjectOptions.ShowLauncherIcon;
var
  p: TPortableNetworkGraphic;
  fn: string;
begin
  with cbLaunchIconSize do
    p := TPortableNetworkGraphic(Items.Objects[ItemIndex]);
  if p <> nil then
  begin
    imLauncherIcon.Picture.Assign(p);
    Exit;
  end;
  fn := FIconsPathDrawable + Drawable[cbLaunchIconSize.ItemIndex].Suffix +
    PathDelim + FManifest.IconFileName + '.png';

  if FileExists(fn) then
  begin
    imLauncherIcon.Picture.LoadFromFile(fn);
    exit;
  end
  else
    imLauncherIcon.Picture.Clear;

  fn := FIconsPathMipmap + Drawable[cbLaunchIconSize.ItemIndex].Suffix +
    PathDelim + FManifest.IconFileName + '.png';

  if FileExists(fn) then
  begin
    imLauncherIcon.Picture.LoadFromFile(fn);
    exit;
  end
  else
    imLauncherIcon.Picture.Clear;
end;

function TLamwProjectOptions.GetCurrentAppScreenStyle: string;
var
  StyleStartPos, StartPos, EndPos: integer;
begin
  if FindAppScreenStyleStatement(StartPos, StyleStartPos, EndPos) then
    GetAppScreenStyleStatement(StyleStartPos, Result)
  else
    Result := '';
end;

function TLamwProjectOptions.FindAppScreenStyleStatement(
  out StartPos, ssConstStartPos, EndPos: integer): boolean;
var
  MainBeginNode: TCodeTreeNode;
  Position: integer;
begin
  Result := False;
  StartPos := -1;
  ssConstStartPos := -1;
  EndPos := -1;
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(LazarusIDE.ActiveProject.MainFile.GetFullFilename));
    if CurCodeTool = nil then
      Exit;
    with CurCodeTool do
    begin
      BuildTree(lsrEnd);
      MainBeginNode := FindMainBeginEndNode;
      if MainBeginNode = nil then
        Exit;
      Position := MainBeginNode.StartPos;
      if Position < 1 then
        Exit;
      MoveCursorToCleanPos(Position);
      repeat
        ReadNextAtom;
        if UpAtomIs('GAPP') then
        begin
          StartPos := CurPos.StartPos;
          if ReadNextAtomIsChar('.') and ReadNextUpAtomIs('SCREEN') and
            ReadNextUpAtomIs('.') and ReadNextUpAtomIs('STYLE') and
            ReadNextUpAtomIs(':=') then
          begin
            // read till semicolon or end
            repeat
              ReadNextAtom;
              if ssConstStartPos < 1 then
                ssConstStartPos := CurPos.StartPos;
              EndPos := CurPos.EndPos;
              if CurPos.Flag in [cafEnd, cafSemicolon] then
              begin
                Result := True;
                Exit;
              end;
            until CurPos.StartPos > SrcLen;
          end;
        end;
      until CurPos.StartPos > SrcLen;
    end;
  end;
end;

function TLamwProjectOptions.GetAppScreenStyleStatement(ssConstStartPos: integer;
  out ssConstVal: string): boolean;
begin
  Result := False;
  ssConstVal := '';
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(LazarusIDE.ActiveProject.MainFile.GetFullFilename));
    if CurCodeTool = nil then
      Exit;
    with CurCodeTool do
    begin
      if (ssConstStartPos < 1) or (ssConstStartPos > SrcLen) then
        Exit;
      MoveCursorToCleanPos(ssConstStartPos);
      ReadNextAtom;
      if not AtomIsIdentifier then
        Exit;
      ssConstVal := GetAtom;
      Result := True;
    end;
  end;
end;

function TLamwProjectOptions.SetAppScreenStyleStatement(
  const ssNewConstVal: string): boolean;
var
  StartPos, ssConstStartPos, EndPos: integer;
  OldExists, Found: boolean;
  NewStatement: string;
  Indent: integer;
  MainBeginNode: TCodeTreeNode;
  Beauty: TBeautifyCodeOptions;
begin
  Result := False;
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(LazarusIDE.ActiveProject.MainFile.GetFullFilename));
    if CurCodeTool = nil then
      Exit;
    with CurCodeTool do
    begin
      // search old Application.Title:= statement
      Beauty := SourceChangeCache.BeautifyCodeOptions;
      OldExists := FindAppScreenStyleStatement(StartPos, ssConstStartPos, EndPos);
      if OldExists then
      begin
        // replace old statement
        Indent := 0;
        Indent := Beauty.GetLineIndent(Src, StartPos);
      end
      else
      begin
        // insert as first line after "gApp := ...;" in program begin..end block
        MainBeginNode := FindMainBeginEndNode;
        if MainBeginNode = nil then
          Exit;
        MoveCursorToNodeStart(MainBeginNode);
        Found := False;
        ReadNextAtom;
        repeat
          if UpAtomIs('GAPP') and ReadNextAtomIs(':=') then
          begin
            while CurPos.StartPos < SrcLen do
            begin
              ReadNextAtom;
              if AtomIs(';') then
              begin
                Found := True;
                Break;
              end;
            end;
            if not Found then
              Exit;
          end;
          if Found then
            Break;
          ReadNextAtom;
        until CurPos.StartPos > SrcLen;
        StartPos := CurPos.EndPos;
        EndPos := StartPos;
        Indent := Beauty.GetLineIndent(Src, StartPos);
      end;
      // create statement
      NewStatement := 'gApp.Screen.Style:=' + ssNewConstVal + ';';
      NewStatement := Beauty.BeautifyStatement(NewStatement, Indent);
      SourceChangeCache.MainScanner := Scanner;
      if not SourceChangeCache.Replace(gtNewLine, gtNewLine, StartPos,
        EndPos, NewStatement) then
        Exit;
      if not SourceChangeCache.Apply then
        Exit;
      Result := True;
    end;
  end;
end;

function TLamwProjectOptions.RemoveAppScreenStyleStatement: boolean;
var
  StartPos, StringConstStartPos, EndPos: integer;
  OldExists: boolean;
  FromPos: integer;
  ToPos: integer;
begin
  Result := False;
  // search old Application.Title:= statement
  OldExists := FindAppScreenStyleStatement(StartPos, StringConstStartPos, EndPos);
  if not OldExists then
  begin
    Result := True;
    Exit;
  end;
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(LazarusIDE.ActiveProject.MainFile.GetFullFilename));
    if CurCodeTool = nil then
      Exit;
    with CurCodeTool do
    begin
      // -> delete whole line
      FromPos := FindLineEndOrCodeInFrontOfPosition(StartPos);
      ToPos := FindLineEndOrCodeAfterPosition(EndPos);
      SourceChangeCache.MainScanner := Scanner;
      if not SourceChangeCache.Replace(gtNone, gtNone, FromPos, ToPos, '') then
        Exit;
      if not SourceChangeCache.Apply then
        Exit;
      Result := True;
    end;
  end;
end;

procedure TLamwProjectOptions.TryUpdateStyleXML();
var
  pathToFile, newTheme, strTemp: string;
  list: TStringList;
begin
  newTheme:= cbTheme.Text;
  if newTheme <> FDefaultTheme then;
  begin
     list:= TStringList.Create;

     if Pos('AppCompat', newTheme) > 0 then   //AppCompat.Light.DarkActionBar   or  AppCompat.Light.NoActionBar
       strTemp:= 'values'
     else  //DeviceDefault   or  Holo.Light.DarkActionBar or Holo.Light.NoActionBar
       strTemp:='values-v21';

     pathToFile:= ConcatPaths([FProjectPath,'res',strTemp])+ PathDelim + 'styles.xml';

     if FileExists(pathToFile) then
     begin
       list.LoadFromFile(pathToFile);
       strTemp:= StringReplace(list.Text, FDefaultTheme,newTheme,[]); //rfReplaceAll, rfIgnoreCase
       list.Text:= strTemp;
       list.SaveToFile(pathToFile);
       LazarusIDE.ActiveProject.CustomData['Theme']:= newTheme;
     end;
     list.Free;
  end;
end;

constructor TLamwProjectOptions.Create(AOwner: TComponent);
const
  chk_st: array [TCheckboxState] of TThemedButton = (
    tbCheckBoxUncheckedNormal,
    tbCheckBoxCheckedNormal,
    tbCheckBoxMixedNormal
    );
  chk_st_hot: array [TCheckboxState] of TThemedButton = (
    tbCheckBoxUncheckedHot,
    tbCheckBoxCheckedHot,
    tbCheckBoxMixedHot
    );
var
  s: TCheckBoxState;
  sl: TStringList;
  i: integer;
  strApi: string;
begin
  inherited Create(AOwner);
  FManifest := TLamwAndroidManifestOptions.Create;
  PageControl1.ActivePageIndex := 0;

  for s := Low(TCheckBoxState) to High(TCheckBoxState) do
    with FChkBoxDrawData[s] do
    begin
      Details := ThemeServices.GetElementDetails(chk_st[s]);
      DetailsHot := ThemeServices.GetElementDetails(chk_st_hot[s]);
      CSize := ThemeServices.GetDetailSize(Details);
    end;

  sl := FindAllDirectories(IncludeTrailingPathDelimiter(
    LamwGlobalSettings.PathToAndroidSDK) + 'platforms', False);
  try
    for i := 0 to sl.Count - 1 do
    begin
      strApi := ExtractFileName(sl[i]);
      if strApi <> '' then
      begin
        strApi := Copy(strApi, LastDelimiter('-', strApi) + 1, MaxInt);
        if IsAllCharNumber(PChar(strApi)) then  //skip android-P
        begin
          if StrToInt(strApi) >= 14 then
            seTargetSdkVersion.Items.Add(strApi);
        end;
      end;
    end;
  finally
    sl.Free;
  end;

  PermissonGrid.DoubleBuffered := True;
end;

destructor TLamwProjectOptions.Destroy;
var
  i: integer;
begin
  with cbLaunchIconSize.Items do
    for i := 0 to Count - 1 do
      TObject(Objects[i]).Free;
  FManifest.Free;
  inherited Destroy;
end;

procedure TLamwProjectOptions.cbLaunchIconSizeSelect(Sender: TObject);
begin
  ShowLauncherIcon;
end;

procedure TLamwProjectOptions.cbThemeChange(Sender: TObject);
begin
  if cbTheme.Text = '' then cbTheme.Text:= FDefaultTheme;
end;

procedure TLamwProjectOptions.cbBuildSystemSelect(Sender: TObject);
begin
  lblGradleHint.Visible := cbBuildSystem.Text = 'Gradle';
end;

{
<Libraries Value="C:\android\ndkr18b\platforms\android-22\arch-arm\usr\lib;C:\android\ndkr18b\toolchains\arm-linux-androideabi-4.9\prebuilt\windows-x86_64\lib\gcc\arm-linux-androideabi\4.9.x"/>
<TargetCPU Value="arm"/>
<CustomOptions Value="-Xd -CfSoft -CpARMV6 -XParm-linux-androideabi- -FDC:\android\ndkr18b\toolchains\arm-linux-androideabi-4.9\prebuilt\windows-x86_64\bin"/>
}

function TLamwProjectOptions.GetBuildMode(filename: string; index: integer): string;
var
  list: TStringList;
  p1, p2: integer;
  temp: string;
begin
  list:= TStringList.Create;
  list.LoadFromFile(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ filename);
  temp:= list.Strings[index];  //index 0 --> Libraries ; inedex 2 --> CustomOptions
  p1:= Pos('"', temp) +1;
  p2:= LastDelimiter('"',temp);
  Result:= Copy(temp, p1, p2 - p1);
  list.Free;
end;

//Update/fix to support [NoGUI] ... Thanks to @loaded!
procedure TLamwProjectOptions.TryChangeChipset();
var
  index: integer;
  cfname:TStringArray;
begin
  if cbChipset.Text <> '' then
  begin
    if cbChipset.Text <> FChipSetTarget then
    begin
       index:= cbChipset.ItemIndex;
       cfname:=LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename.Split(PathDelim);
       case index of
         0: begin  //ARMv6
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_armV6.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'armeabi'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_armV6.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'arm';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_armV6.txt', 0);
           end;
         end;
         1: begin  //ARMv7a+Soft
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_armV7a.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'armeabi-v7a'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_armV7a.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'arm';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_armV7a.txt', 0);
           end;
         end;
         2: begin //ARMv7a+VFPv3
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_armV7a_VFPv3.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'armeabi-v7a'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_armV7a_VFPv3.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'arm';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_armV7a_VFPv3.txt', 0);
           end;
         end;
         3: begin //x86
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_x86.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'x86'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_x86.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'i386';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_x86.txt', 0);
           end;
         end;
         4: begin //Mipsel
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_mipsel.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'mips'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_mipsel.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'mipsel';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_mipsel.txt', 0);
           end
         end;
         5: begin //Aarch64    //build_arm64.txt
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_arm64.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'arm64-v8a'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_arm64.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'aarch64';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_arm64.txt', 0);
           end;
         end;
         6: begin  //x86_64
           if FileExists(FProjectPath + 'jni' + PathDelim + 'build-modes' +PathDelim+ 'build_x86_64.txt') then
           begin
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:=  '..'+PathDelim+'libs'+PathDelim+'x86_64'+PathDelim+cfname[high(cfname)];
             LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= GetBuildMode('build_x86_64.txt', 2);
             LazarusIDE.ActiveProject.LazCompilerOptions.TargetCPU:= 'x86_64';
             LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= GetBuildMode('build_x86_64.txt', 0);
           end;
         end;
       end;
    end;
  end;
end;

procedure TLamwProjectOptions.cbChipsetChange(Sender: TObject);
begin
//
end;

procedure TLamwProjectOptions.cbBuildSystemChange(Sender: TObject);
begin
  if Pos('AppCompat', FDefaultTheme) > 0 then
  begin
    if Pos('Ant', cbBuildSystem.Text) > 0 then
    begin
       ShowMessage('Sorry... AppCompat theme need "Gradle" build system');
       cbBuildSystem.Text:= 'Gradle';
    end;
  end;
end;

procedure TLamwProjectOptions.PermissonGridCheckboxToggled(Sender: TObject;
  aCol, aRow: integer; aState: TCheckboxState);
var
  r: integer;
begin
  if PermissonGrid.Cells[1, 1] = '1' then
    FAllPermissionsState := cbChecked
  else
    FAllPermissionsState := cbUnchecked;
  for r := 2 to PermissonGrid.RowCount - 1 do
    if (PermissonGrid.Cells[1, r] = '1') and (FAllPermissionsState = cbUnchecked) or
      (PermissonGrid.Cells[1, r] = '0') and (FAllPermissionsState = cbChecked) then
    begin
      FAllPermissionsState := cbGrayed;
      Break;
    end;
  PermissonGrid.InvalidateCell(1, 0);
end;

procedure TLamwProjectOptions.PermissonGridDrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  d: TThemedElementDetails;
  r: TRect;
begin
  if (aCol = 1) and (aRow = 0) then
  begin
    r := GetAllPermissonsCheckBoxBounds(aRect);
    if FAllPermissionsHot then
      d := FChkBoxDrawData[FAllPermissionsState].DetailsHot
    else
      d := FChkBoxDrawData[FAllPermissionsState].Details;
    ThemeServices.DrawElement(PermissonGrid.Canvas.Handle, d, r, nil);
  end;
end;

procedure TLamwProjectOptions.PermissonGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  c, r: integer;
  NewVal: char;
begin
  if (Button = mbLeft) and ([ssShift, ssCtrl] * Shift = []) then
  begin
    with PermissonGrid.MouseCoord(X, Y) do
    begin
      c := X;
      r := Y;
    end;
    if (c = 1) and (r = 0) and
      PtInRect(GetAllPermissonsCheckBoxBounds(PermissonGrid.CellRect(c, r)), Point(X, Y)) then
    begin
      if FAllPermissionsState = cbChecked then
      begin
        FAllPermissionsState := cbUnchecked;
        NewVal := '0';
      end
      else
      begin
        FAllPermissionsState := cbChecked;
        NewVal := '1';
      end;
      PermissonGrid.BeginUpdate;
      try
        for r := 1 to PermissonGrid.RowCount - 1 do
          PermissonGrid.Cells[1, r] := NewVal;
      finally
        PermissonGrid.EndUpdate;
      end;
    end;
  end;
end;

procedure TLamwProjectOptions.PermissonGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
var
  c, r: longint;
  b: boolean;
begin
  with PermissonGrid.MouseCoord(X, Y) do
  begin
    c := X;
    r := Y;
  end;
  if (c = 1) and (r = 0) then
  begin
    b := PtInRect(GetAllPermissonsCheckBoxBounds(PermissonGrid.CellRect(c, r)),
      Point(X, Y));
    if FAllPermissionsHot <> b then
    begin
      FAllPermissionsHot := b;
      PermissonGrid.InvalidateCell(c, r);
    end;
  end;
end;

procedure TLamwProjectOptions.seTargetSdkVersionEditingDone(Sender: TObject);
var
  i: integer;
begin
  if not TryStrToInt(seTargetSdkVersion.Text, i) then
    seTargetSdkVersion.Color := RGBToColor(255, 205, 205)
  else
  begin
    seTargetSdkVersion.Color := clDefault;
    //cbTheme.Text := FManifest.GetThemeName(i);
  end;
end;

procedure TLamwProjectOptions.SpeedButton1Click(Sender: TObject);

  function CreateAllIcons(p: TPortableNetworkGraphic; fname: string): boolean;
  var
    i: integer;
    p1: TPortableNetworkGraphic;
  begin
    Result := MessageDlg(Format(
      'Do you want to prepare all other icons by resizing "%s"?',
      [ExtractFileName(fname)]), mtConfirmation, mbYesNo, 0) = mrYes;
    if Result then
      with cbLaunchIconSize.Items do
      begin
        for i := 0 to Count - 1 do
        begin
          p1 := TPortableNetworkGraphic.Create;
          p1.Assign(p);
          if p1.Width <> Drawable[i].Size then
            ResizePNG(p1, Drawable[i].Size);
          Objects[i] := p1;
        end;
        p.Free;
      end;
  end;

var
  p: TPortableNetworkGraphic;
begin
  with TOpenPictureDialog.Create(nil) do
    try
      Title := Format('%s (%s)', [GroupBox1.Caption, cbLaunchIconSize.Text]);
      Filter := 'PNG|*.png';
      if Execute then
      begin
        p := TPortableNetworkGraphic.Create;
        p.LoadFromFile(FileName);
        with Drawable[cbLaunchIconSize.ItemIndex] do
          if (p.Width <> Size) or (p.Height <> Size) then
            case MessageDlg(Format(
                'The size of "%s" is %dx%d but should be %dx%d. Do you want to resize?',
                [ExtractFileName(FileName), p.Width, p.Height, Size, Size]),
                mtConfirmation, mbYesNoCancel, 0) of
              mrYes:
              begin
                if (p.Width = p.Height) and (p.Height > 90) then
                  if CreateAllIcons(p, FileName) then
                    Exit;
                ResizePNG(p, Size);
              end
              else
                p.Free;
                Exit;
            end
          else
          if (Size > 90) then
            if CreateAllIcons(p, FileName) then
              Exit;
        with cbLaunchIconSize do
          Items.Objects[ItemIndex] := p;
      end;
    finally
      Free;
      ShowLauncherIcon;
    end;
end;

procedure TLamwProjectOptions.SpeedButton2Click(Sender: TObject);
var
  listInfo: TStringList;
begin
   listInfo:= TStringList.Create;
   listInfo.Add('How to get more ".so" chipset builds:');
   listInfo.Add(' ');
   listInfo.Add('Hint1: Lazarus needs to be prepared [cross-compile] for selected chipset!');
   listInfo.Add(' ');
   listInfo.Add('Hint2: Laz4Android 1.8/2.0.0 support only 32bits: "armV6", "armV7a+Soft", "x86"!');
   listInfo.Add('Hint3: Laz4Android 2.0.12 support "aarch64","x86_64","armV6","armV7a+Soft","x86"!');
   listInfo.Add(' ');
   listInfo.Add('1.  > Chipset [select!] -> [OK]');
   listInfo.Add(' ');
   listInfo.Add('2. From LazarusIDE  menu:');
   listInfo.Add(' ');
   listInfo.Add('   > Run -> Clean up and Build...');
   listInfo.Add(' ');
   listInfo.Add('3. From LazarusIDE menu:');
   listInfo.Add(' ');
   listInfo.Add('   > [LAMW] Build Android Apk and Run');
   listInfo.Add(' ');
   ShowMessage(listInfo.Text);
   listInfo.Free;
end;

procedure TLamwProjectOptions.SpeedButtonHintThemeClick(Sender: TObject);
begin
  ShowMessage('Hint 1:'+ sLineBreak +
               'You can "change" only to compatibles themes:' + sLineBreak +
               'DeviceDefault <--> Holo.Light.NoActionBar' + sLineBreak +
               'DeviceDefault <--> Holo.Light.DarkActionBar' + sLineBreak +
               'Holo.Light.DarkActionBar <--> Holo.Light.NoActionBar' + sLineBreak + sLineBreak +
               'AppCompat.Light.NoActionBar <--> AppCompat.Light.DarkActionBar'+ sLineBreak + sLineBreak+
               'Hint 2:'+ sLineBreak +
               'You can "convert" a project to  "AppCompat" [material] theme:'  + sLineBreak +
               'Menu "Tools" --> "[LAMW]..." --> "Convert the project to AppCompat..."'
               );
end;

function TLamwProjectOptions.GetAllPermissonsCheckBoxBounds(InRect: TRect): TRect;
begin
  Result := InRect;
  with FChkBoxDrawData[FAllPermissionsState], Result do
  begin
    Left := Left + 2;
    Top := (Top + Bottom - CSize.cy) div 2;
    Right := Left + CSize.cx;
    Bottom := Top + CSize.cy;
  end;
end;

procedure TLamwProjectOptions.ErrorMessage(const msg: string);
begin
  lblErrorMessage.Caption := msg;
  ErrorPanel.Visible := True;
  ErrorPanel.Enabled := True;
end;

procedure TLamwProjectOptions.FillPermissionGrid(Permissions: TStringList;
  PermNames: TStringToStringTree);
var
  i: integer;
  n: string;
begin
  PermissonGrid.BeginUpdate;
  try
    PermissonGrid.RowCount := Permissions.Count + 1;
    with PermissonGrid do
      for i := 0 to Permissions.Count - 1 do
      begin
        n := PermNames[Permissions[i]];
        if n = '' then
          n := Permissions[i];
        Cells[0, i + 1] := n;
        if Permissions.Objects[i] = nil then
        begin
          if i = 0 then
            FAllPermissionsState := cbUnchecked
          else
          if FAllPermissionsState = cbChecked then
            FAllPermissionsState := cbGrayed;
          Cells[1, i + 1] := '0';
        end
        else
        begin
          if i = 0 then
            FAllPermissionsState := cbChecked
          else
          if FAllPermissionsState = cbUnchecked then
            FAllPermissionsState := cbGrayed;
          Cells[1, i + 1] := '1';
        end;
      end;
  finally
    PermissonGrid.EndUpdate;
  end;
end;

class function TLamwProjectOptions.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
  Result := nil;
end;

function TLamwProjectOptions.GetTitle: string;
begin
  Result := '[LAMW] Android Project Options';
end;

procedure TLamwProjectOptions.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
  //localization
end;

{
ARMv6 0
ARMv7a+Soft 1
ARMv7a+VFPv3 2 (*)
x86 3
Mipsel 4
Aarch64 5 (*)
x86_64 6
}

function TLamwProjectOptions.GetChipSetTarget(var cbIndex: integer): string;
var
  projectTarget: string;
  projectCustom: string;
begin

  projectTarget:= LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename;  //..\libs\armeabi-v7a\libcontrols
  projectCustom:= UpperCase(LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions);

  if Pos('arm64-v8a', projectTarget) > 0 then     //arm64-v8a
  begin
     Result:= 'Aarch64';
     cbIndex:= 5;
  end
  else if Pos('armeabi-v7a', projectTarget) > 0 then
  begin
     Result:= 'ARMv7a+Soft';
     cbIndex:= 1;
     if Pos('VFPV3', projectCustom) > 0 then
     begin
       Result:= 'ARMv7a+VFPv3';
       cbIndex:= 2;
     end;
  end
  else if Pos('armeabi', projectTarget) > 0 then
  begin
     Result:= 'ARMv6';
     cbIndex:= 0;
  end
  else if Pos('x86_64', projectTarget) > 0 then
  begin
     Result:= 'x86_64';
     cbIndex:= 6;
  end
  else if Pos('x86', projectTarget) > 0 then
  begin
     Result:= 'x86';
     cbIndex:= 3;
  end
  else if Pos('mips', projectTarget) > 0 then    //droped for >= NDK r17
  begin
     Result:= 'Mipsel';
     cbIndex:= 4;
  end;

end;

procedure TLamwProjectOptions.ReadSettings(AOptions: TAbstractIDEOptions);
var
  proj: TLazProject;
  fn, s: string;
  i: integer;
  cbIndex: integer;
begin
  // reading manifest
  SetControlsEnabled(tsManifest, False);

  proj:= LazarusIDE.ActiveProject;
  if (proj = nil) or (proj.IsVirtual) then
    Exit;

  cbIndex:= -1;
  FChipSetTarget:= GetChipSetTarget(cbIndex);

  if cbIndex >= 0 then
    cbChipset.ItemIndex := cbIndex;

  CheckBoxSupport.Checked:=(LazarusIDE.ActiveProject.CustomData['Support']='TRUE');

  FMinSdk       := proj.CustomData['MinSdk'];
  FTargetSdk    := proj.CustomData['TargetSdk'];
  FAndroidTheme := proj.CustomData['Theme'];
  FBuildSystem  := proj.CustomData['BuildSystem'];

  if FMinSdk = '' then
   if Pos('AppCompat',  FAndroidTheme) > 0 then
     FMinSdk := '16'
   else
     FMinSdk := '14';

  if FTargetSdk = '' then
   FTargetSdk := intToStr(cMaxAPI);

  i := cbBuildSystem.Items.IndexOf(FBuildSystem);
  if i >= 0 then
    cbBuildSystem.ItemIndex := i;
  fn := proj.MainFile.Filename;
  fn := Copy(fn, 1, Pos(PathDelim + 'jni' + PathDelim, fn));
  FProjectPath:= fn;
  fn := fn + 'AndroidManifest.xml';
  IsLamwProject := False;
  if not FileExists(fn) then
    ErrorMessage('"' + fn + '" not found!');
  if not FileExists(fn) or not proj.CustomData.Contains('LAMW') then
  begin
    tsAppl.Enabled := False;
    tsMiscellaneous.Enabled := False;
    Exit;
  end;
  IsLamwProject := True;
  try
    FIconsPathDrawable := ExtractFilePath(fn) + 'res' + PathDelim + 'drawable-';
    FIconsPathMipmap   := ExtractFilePath(fn) + 'res' + PathDelim + 'mipmap-';
    ShowLauncherIcon;
    with FManifest do
    begin
      Load(fn);
      FillPermissionGrid(Permissions, PermNames);

      seMinSdkVersion.Value   := StrToInt(FMinSdk);
      seTargetSdkVersion.Text := FTargetSdk;

      (*if FMinSdk <> '' then
       seMinSdkVersion.Value := StrToInt(FMinSdk)
      else
       seMinSdkVersion.Value := MinSDKVersion;

      seTargetSdkVersion.Text := IntToStr(TargetSDKVersion);*)

      seVersionCode.Value := VersionCode;
      edVersionName.Text  := VersionName;
      edLabel.Text := AppLabel;
    end;
  except
    on e: Exception do
    begin
      ErrorMessage(e.Message);
      Exit;
    end
  end;

  FDefaultTheme := LazarusIDE.ActiveProject.CustomData['Theme'];  //FManifest.ThemeName;
  if Pos('AppCompat', FDefaultTheme) > 0 then
  begin
     cbTheme.Items.Add('AppCompat.Light.NoActionBar');
     cbTheme.Items.Add('AppCompat.Light.DarkActionBar');
  end
  else
  begin
    cbTheme.Items.Add('DeviceDefault');
    cbTheme.Items.Add('Holo.Light.NoActionBar');
    cbTheme.Items.Add('Holo.Light.DarkActionBar');
  end;
  cbTheme.Text:= FDefaultTheme;

  s := GetCurrentAppScreenStyle;
  if SameText(s, 'ssPortrait') then
    rbOrientation.ItemIndex := 1
  else
  if SameText(s, 'ssLandscape') then
    rbOrientation.ItemIndex := 2
  else
    rbOrientation.ItemIndex := 0;
  SetControlsEnabled(tsManifest, True);
end;

procedure TLamwProjectOptions.WriteSettings(AOptions: TAbstractIDEOptions);
const
  ScreenStyles: array [0..2] of string = (
    'ssSensor', 'ssPortrait', 'ssLandscape'
    );
var
  i: integer;
  s: string;
begin
  if not IsLamwProject then
    Exit;

  TryChangeChipset();

  if CheckBoxSupport.Checked then
    LazarusIDE.ActiveProject.CustomData['Support']:='TRUE'
  else
    LazarusIDE.ActiveProject.CustomData['Support']:='FALSE';

  LazarusIDE.ActiveProject.CustomData['MinSdk']    := intToStr(seMinSdkVersion.Value);
  LazarusIDE.ActiveProject.CustomData['TargetSdk'] := seTargetSdkVersion.Text;

  with FManifest do
  begin
    for i := PermissonGrid.RowCount - 1 downto 1 do
      if PermissonGrid.Cells[1, i] <> '1' then
        Permissions.Delete(i - 1);
    MinSDKVersion := seMinSdkVersion.Value;
    if TryStrToInt(seTargetSdkVersion.Text, i) then
      TargetSDKVersion := i;
    VersionCode := seVersionCode.Value;
    VersionName := edVersionName.Text;
    AppLabel := edLabel.Text;
    Save(cbBuildSystem.Text = 'Gradle');
  end;

  s := GetCurrentAppScreenStyle;
  if s = '' then
    s := ScreenStyles[0];
  if s <> ScreenStyles[rbOrientation.ItemIndex] then
  begin
    if rbOrientation.ItemIndex = 0 then
      RemoveAppScreenStyleStatement
    else
      SetAppScreenStyleStatement(ScreenStyles[rbOrientation.ItemIndex]);
  end;

  with cbLaunchIconSize.Items do
    for i := 0 to Count - 1 do
      if Assigned(Objects[i]) then
      begin
        if directoryExists(FIconsPathDrawable + Drawable[i].Suffix) then
         TPortableNetworkGraphic(Objects[i]).SaveToFile(FIconsPathDrawable +
           Drawable[i].Suffix + PathDelim + FManifest.IconFileName + '.png');

        if directoryExists(FIconsPathMipmap + Drawable[i].Suffix) then
         TPortableNetworkGraphic(Objects[i]).SaveToFile(FIconsPathMipmap +
           Drawable[i].Suffix + PathDelim + FManifest.IconFileName + '.png');
      end;

  if cbBuildSystem.Text <> '' then
    LazarusIDE.ActiveProject.CustomData['BuildSystem'] := cbBuildSystem.Text;

  if LazarusIDE.ActiveProject.CustomData['Support'] ='TRUE' then
  begin
     if LazarusIDE.ActiveProject.CustomData['BuildSystem'] <> 'Gradle' then
       ShowMessage('Warning: Support Library need "Gradle" builder ...');
  end;

  TryUpdateStyleXML();
end;

initialization
  RegisterIDEOptionsEditor(GroupProject, TLamwProjectOptions, 1000);

end.
