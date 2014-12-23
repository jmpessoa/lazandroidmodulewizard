unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LazIDEIntf,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, FormPathMissing;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    BitBtnCancel: TBitBtn;
    BitBtnOK: TBitBtn;
    CheckBox1: TCheckBox;
    ComboSelectProjectName: TComboBox;
    EditPackagePrefaceName: TEdit;
    EditPathToWorkspace: TEdit;
    edProjectName: TEdit;
    GroupBox1: TGroupBox;
    LabelTargetAPI: TLabel;
    LabelPathToWorkspace: TLabel;
    LabelPlatform: TLabel;
    LabelSelectProjectName: TLabel;
    LabelSdkMin: TLabel;
    ListBoxMinSDK: TListBox;
    ListBoxPlatform: TListBox;
    ListBoxTargetAPI: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelListBox: TPanel;
    PanelButtons: TPanel;
    PanelRadioGroup: TPanel;
    RGInstruction: TRadioGroup;
    RGFPU: TRadioGroup;
    RGProjectType: TRadioGroup;
    SelDirDlgPathToWorkspace: TSelectDirectoryDialog;
    SpdBtnPathToWorkspace: TSpeedButton;
    SpdBtnRefreshProjectName: TSpeedButton;
    StatusBarInfo: TStatusBar;

    procedure CheckBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure ListBoxMinSDKClick(Sender: TObject);
    procedure ListBoxMinSDKSelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxTargetAPIClick(Sender: TObject);
    procedure ListBoxTargetAPISelectionChange(Sender: TObject; User: boolean);
    procedure ListBoxPlatformClick(Sender: TObject);

    procedure RGInstructionClick(Sender: TObject);
    procedure RGFPUClick(Sender: TObject);
    procedure RGProjectTypeClick(Sender: TObject);
    procedure SpdBtnPathToWorkspaceClick(Sender: TObject);
    procedure SpdBtnRefreshProjectNameClick(Sender: TObject);

  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}

    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPathToLazbuild: string;

    FProjectModel: string;
    FAntPackageName: string;

    FMinApi: string;
    FTargetApi: string;

    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;   //Simon "App"
    FNDK: string;
    FAndroidPlatform: string;
    FSupportV4: string;

  public
    { public declarations }
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    function GetTextByListIndex(index:integer): string;
    function GetTextByList2Index(index:integer): string;
    function GetNDKPlatform(identName: string): string;

    procedure LoadPathsSettings(const fileName: string);

    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;

    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;

    property PathToJavaJDK: string read FPathToJavaJDK write FPathToJavaJDK;
    property PathToAndroidSDK: string read FPathToAndroidSDK write FPathToAndroidSDK;
    property PathToAndroidNDK: string read FPathToAndroidNDK write FPathToAndroidNDK;
    property PathToAntBin: string read FPathToAntBin write FPathToAntBin;
    property ProjectModel: string read FProjectModel write FProjectModel; {eclipse/ant/jbridge}
    property AntPackageName: string read FAntPackageName write FAntPackageName;
    property MinApi: string read FMinApi write FMinApi;
    property TargetApi: string read FTargetApi write FTargetApi;
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
    property NDK: string read FNDK write FNDK;
    property AndroidPlatform: string read FAndroidPlatform write FAndroidPlatform;
    property SupportV4: string read FSupportV4 write FSupportV4;
  end;

  procedure GetSubDirectories(const directory : string; list : TStrings);
  function ReplaceChar(query: string; oldchar, newchar: char):string;
  function TrimChar(query: string; delimiter: char): string;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

procedure TFormWorkspace.ListBoxMinSDKClick(Sender: TObject);
begin
    FMinApi:= ListBoxMinSDK.Items.Strings[ListBoxMinSDK.ItemIndex]
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByListIndex(index:integer): string;
begin
   Result:= '';
   case index of
     0: Result:= '100% market sharing'; // Api(8)    -Froyo 2.2
     1: Result:= '99.3% market sharing'; // Api(10)  -Gingerbread 2.3
     2: Result:= '87.9% market sharing'; // Api(15)  -Ice Cream 4.0x
     3: Result:= '78.3% market sharing'; // Api(16)  -Jelly Bean 4.1
     4: Result:= '53.2% market sharing'; // Api(17)  -Jelly Bean 4.2
     5: Result:= '32.5% market sharing'; // Api(18)  -Jelly Bean 4.3
     6: Result:= '24.5% market sharing'; // Api(19)  -KitKat 4.4
   end;
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByList2Index(index:integer): string;
begin
   Result:= 'KitKat 4.4';
   case index of
     0: Result:= 'Froyo 2.2';        //0.7%  -  Api:8     100-0   =  100.0
     1: Result:= 'Gingerbread 2.3';  //11.4% -  Api:10    100-0.7 =   99.3
     2: Result:= 'Ice Cream 4.0x';   //9.6%  -  Api:15    99.3-11.4 = 87.9
     3: Result:= 'Jelly Bean 4.1';   //25.1% -  Api:16    87.9-9.6  = 78.3
     4: Result:= 'Jelly Bean 4.2';   //20.7% -  Api:17    78.3-25.1 = 53.2
     5: Result:= 'Jelly Bean 4.3';   //8.0%  -  Api:18    53.2-20.7 = 32.5
     6: Result:= 'KitKat 4.4';       //24.5% -  Api:19    32.5-8.0  = 24.5
   end;
end;


procedure TFormWorkspace.ListBoxMinSDKSelectionChange(Sender: TObject; User: boolean);
begin
    //StatusBarInfo.SimpleText:= GetTextByListIndex(ListBoxMinSDK.ItemIndex);
    StatusBarInfo.Panels.Items[0].Text:= 'MinSdk Api: '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);
end;

procedure TFormWorkspace.ListBoxTargetAPIClick(Sender: TObject);
begin
  case ListBoxTargetAPI.ItemIndex of
      0: FTargetApi:= '8';
      1: FTargetApi:= '11';
      2: FTargetApi:= '14';
      3: FTargetApi:= '15';
      4: FTargetApi:= '16';
      5: FTargetApi:= '17';
      6: FTargetApi:= '18';
      7: FTargetApi:= '19';
      8: FTargetApi:= '20';
      9: FTargetApi:= '21';
  end
end;

procedure TFormWorkspace.ListBoxTargetAPISelectionChange(Sender: TObject; User: boolean);
begin
  StatusBarInfo.Panels.Items[1].Text:='Target Api: '+GetTextByList2Index(ListBoxTargetAPI.ItemIndex);
end;

procedure TFormWorkspace.ListBoxPlatformClick(Sender: TObject);
var
   saveIndex: integer;
begin
   saveIndex:=ListBoxMinSDK.ItemIndex;
   ListBoxMinSDK.Clear;
   if ListBoxPlatform.ItemIndex = 0 then
   begin
     ListBoxMinSDK.Items.Add('8');
     //ListBoxMinSDK.Items.Add('10');
     //ListBoxMinSDK.Items.Add('14');
   end
   else if ListBoxPlatform.ItemIndex = 1 then
   begin
     ListBoxMinSDK.Items.Add('8');
     ListBoxMinSDK.Items.Add('11');
     //ListBoxMinSDK.Items.Add('14');
   end
   else
   begin
     ListBoxMinSDK.Items.Add('8');
     ListBoxMinSDK.Items.Add('11');
     //ListBoxMinSDK.Items.Add('14');
     ListBoxMinSDK.Items.Add('15');
     ListBoxMinSDK.Items.Add('16');
     ListBoxMinSDK.Items.Add('17');
     ListBoxMinSDK.Items.Add('18');
     ListBoxMinSDK.Items.Add('19');
   end;

   if saveIndex < ListBoxMinSDK.Count then
      ListBoxMinSDK.ItemIndex:= saveIndex
   else
      ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Count-1;

   ListBoxMinSDKClick(nil);
end;


procedure TFormWorkspace.RGInstructionClick(Sender: TObject);
begin
  FInstructionSet:= RGInstruction.Items[RGInstruction.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RGFPUClick(Sender: TObject);
begin
  FFPUSet:= RGFPU.Items[RGFPU.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RGProjectTypeClick(Sender: TObject);
begin
  FProjectModel:= RGProjectType.Items[RGProjectType.ItemIndex];  //fix 15-december-2013

  if RGProjectType.ItemIndex = 1 then
     if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';
end;

function TFormWorkspace.GetNDKPlatform(identName: string): string;
begin
    Result:= 'android-14'; //default
         if identName = 'Froyo'          then Result:= 'android-8'
    else if identName = 'Gingerbread'    then Result:= 'android-13'
    else if identName = 'Ice Cream 4.0x' then Result:= 'android-15'
    else if identName = 'Jelly Bean 4.1' then Result:= 'android-16'
    else if identName = 'Jelly Bean 4.2' then Result:= 'android-17'
    else if identName = 'Jelly Bean 4.3' then Result:= 'android-18'
    else if identName = 'KitKat 4.4'     then Result:= 'android-19'
    else if identName = 'Lollipop 5.0'   then Result:= 'android-21';
end;

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   strList: TStringList;
   count, i, j: integer;
   path: string;
begin
  SaveSettings(FFileName);
  if ModalResult = mrCancel  then Exit;

  if EditPathToWorkspace.Text = '' then
  begin
    ShowMessage('Error! Workplace Path was missing....[Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if ComboSelectProjectName.Text = '' then
  begin
    ShowMessage('Error! Projec Name was missing.... [Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';

  FMainActivity:= 'App'; {dummy for Simon template} //TODO: need name flexibility here...

  FAntPackageName:= LowerCase(Trim(EditPackagePrefaceName.Text));

  FPathToWorkspace:= EditPathToWorkspace.Text;
  FAndroidProjectName:= Trim(ComboSelectProjectName.Text);
  FAndroidPlatform:= GetNDKPlatform(ListBoxPlatform.Items.Strings[ListBoxPlatform.ItemIndex]);

  if FProjectModel <> 'Ant' then
  begin
      strList:= TStringList.Create;
      path:= FAndroidProjectName+DirectorySeparator+'src';
      GetSubDirectories(path, strList);
      count:= strList.Count;
      while count > 0 do
      begin
         path:= strList.Strings[0];
         strList.Clear;
         GetSubDirectories(path, strList);
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
      FAntPackageName:= TrimChar(path, '.');
      strList.Free;
  end;

  if RGProjectType.ItemIndex = 1 then  //Ant Project
  begin
     FProjectModel:= 'Ant';
     if (Pos(DirectorySeparator, ComboSelectProjectName.Text) = 0) then  //i.e just "name", not path+name
     begin
         FAndroidProjectName:= FPathToWorkspace + DirectorySeparator + ComboSelectProjectName.Text; //get full name: path+name
         {$I-}
         ChDir(FPathToWorkspace+DirectorySeparator+ComboSelectProjectName.Text);
         if IOResult <> 0 then MkDir(FPathToWorkspace+DirectorySeparator+ComboSelectProjectName.Text);
     end;
  end;

end;

procedure TFormWorkspace.FormCreate(Sender: TObject);
var
  fileName: string;
begin
  fileName:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if not FileExists(fileName) then
  begin
    if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';
    SaveSettings(fileName);  //force to create empty/initial file!
  end;
end;

procedure TFormWorkspace.LoadPathsSettings(const fileName: string);
var
  indexNdk: integer;
  frm: TFormPathMissing;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    begin
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

      if ReadString('NewProject','NDK', '') <> '' then
          indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
          indexNdk:= 2;  //ndk 10   ... default

      case indexNdk of
         0: FNDK:= '7';
         1: FNDK:= '9';
         2: FNDK:= '10';
      end;

      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if  FPathToJavaTemplates = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java templates: [ex. ..\LazAndroidWizard\java]';
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

      FPathToLazbuild:= ReadString('NewProject','PathToLazbuild', '');
      if  FPathToLazbuild = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to "lazbuild": [ex. C:\lazarus {or C:\Laz4Android}]';
          if frm.ShowModal = mrOK then
          begin
             FPathToLazbuild:= frm.PathMissing;
             frm.Free;
          end
          else
          begin
             frm.Free;
             Exit;
          end;
      end;

      CheckBox1.Checked:= False;
      FSupportV4:= ReadString('NewProject','SupportV4', '');
      if FSupportV4 = 'yes' then CheckBox1.Checked:= True
      else FSupportV4 := 'no';

      Free;
    end;
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
begin

  if EditPathToWorkspace.Text <> '' then
     ComboSelectProjectName.SetFocus
  else EditPathToWorkspace.SetFocus;

  if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';

  StatusBarInfo.Panels.Items[0].Text:= 'MinSdk Api: '+GetTextByListIndex(ListBoxMinSDK.ItemIndex);
  StatusBarInfo.Panels.Items[1].Text:= 'Target Api: '+GetTextByList2Index(ListBoxTargetAPI.ItemIndex);

end;

procedure TFormWorkspace.CheckBox1Click(Sender: TObject);
begin
    if  CheckBox1.Checked then FSupportV4:= 'yes'
    else FSupportV4:= 'no';
end;

procedure TFormWorkspace.SpdBtnPathToWorkspaceClick(Sender: TObject);
begin
  if SelDirDlgPathToWorkspace.Execute then
  begin
    EditPathToWorkspace.Text := SelDirDlgPathToWorkspace.FileName;
    FPathToWorkspace:= SelDirDlgPathToWorkspace.FileName;
    ComboSelectProjectName.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboSelectProjectName.Items);

    //try some guesswork:
    if Pos('eclipse', LowerCase(FPathToWorkspace) ) > 0 then RGProjectType.ItemIndex:= 0;

    if Pos('ant', LowerCase(FPathToWorkspace) ) > 0 then
    begin
       RGProjectType.ItemIndex:= 1;
       if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';
    end;
  end;
end;

procedure TFormWorkspace.SpdBtnRefreshProjectNameClick(Sender: TObject);
begin
  FPathToWorkspace:= EditPathToWorkspace.Text;
  ComboSelectProjectName.Items.Clear;
  GetSubDirectories(FPathToWorkspace, ComboSelectProjectName.Items);

  //try some guesswork:
  if Pos('eclipse', LowerCase(FPathToWorkspace) ) > 0 then
  begin
    RGProjectType.ItemIndex:= 0;
  end;

  if Pos('ant', LowerCase(FPathToWorkspace) ) > 0 then
  begin
     RGProjectType.ItemIndex:= 1;
     if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';
  end;
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);  //called by
var
  i1, i2, i3, i5, j1, j2, j3: integer;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  begin
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FAntPackageName:= ReadString('NewProject','AntPackageName', '');

    FAntBuildMode:= 'debug'; //default...
    FTouchtestEnabled:= 'True'; //default

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity = '' then FMainActivity:= 'App';

    if ReadString('NewProject','NDK', '') <> '' then
      i5:= strToInt(ReadString('NewProject','NDK', ''))
    else i5:= 2;  //ndk 10

    ListBoxPlatform.Clear;
    if i5 > 0 then //not ndk7
    begin
      ListBoxPlatform.Items.Add('Froyo');
      ListBoxPlatform.Items.Add('Gingerbread');
      ListBoxPlatform.Items.Add('Ice Cream 4.0x');
      ListBoxPlatform.Items.Add('Jelly Bean 4.1');
      ListBoxPlatform.Items.Add('Jelly Bean 4.2');
      ListBoxPlatform.Items.Add('Jelly Bean 4.3');
      ListBoxPlatform.Items.Add('KitKat 4.4');
      ListBoxPlatform.Items.Add('Lollipop 5.0');
    end
    else
    begin  //just ndk7
      ListBoxPlatform.Items.Add('Froyo');
      ListBoxPlatform.Items.Add('Gingerbread');
      ListBoxPlatform.Items.Add('Ice Cream 4.0');  //Android-14
    end;

    if ReadString('NewProject','InstructionSet', '') <> '' then
       i1:= strToInt(ReadString('NewProject','InstructionSet', ''))
    else i1:= 0;

    if ReadString('NewProject','FPUSet', '') <> '' then
       i2:= strToInt(ReadString('NewProject','FPUSet', ''))
    else i2:= 0;

    if ReadString('NewProject','ProjectModel', '') <> '' then
       i3:= strToInt(ReadString('NewProject','ProjectModel', ''))
    else i3:= 0;

    if ReadString('NewProject','MinApi', '') <> '' then
       j1:= strToInt(ReadString('NewProject','MinApi', ''))
    else j1:= 2; // Api 14

    if  j1 < ListBoxMinSDK.Items.Count then
        ListBoxMinSDK.ItemIndex:= j1
    else
       ListBoxMinSDK.ItemIndex:= ListBoxMinSDK.Items.Count-1;

    if ReadString('NewProject','AndroidPlatform', '') <> '' then
       j2:= strToInt(ReadString('NewProject','AndroidPlatform', ''))
    else j2:= 2; // Android-14

    ListBoxPlatform.ItemIndex:= j2;
    ListBoxMinSDKClick(nil); //update ListBoxMinSDK


    FAndroidPlatform:=  GetNDKPlatform(ListBoxPlatform.Items.Strings[ListBoxPlatform.ItemIndex]);

    if ReadString('NewProject','TargetApi', '') <> '' then
       j3:= strToInt(ReadString('NewProject','TargetApi', ''))
    else j3:= 2; // Api 14

    if  j3 < ListBoxTargetAPI.Items.Count then
        ListBoxTargetAPI.ItemIndex:= j3
    else
       ListBoxTargetAPI.ItemIndex:= ListBoxTargetAPI.Items.Count-1;

    ComboSelectProjectName.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboSelectProjectName.Items);

    Free;
  end;

  RGInstruction.ItemIndex:= i1;
  RGFPU.ItemIndex:= i2;

  if i3 > 1 then i3:= 0;
  RGProjectType.ItemIndex:= i3;

  FInstructionSet:= RGInstruction.Items[RGInstruction.ItemIndex];
  FFPUSet:= RGFPU.Items[RGFPU.ItemIndex];
  FProjectModel:= RGProjectType.Items[RGProjectType.ItemIndex]; //Eclipse Project or Ant Project

  FMinApi:= ListBoxMinSDK.Items[ListBoxMinSDK.ItemIndex];
  FTargetApi:= ListBoxTargetAPI.Items[ListBoxTargetAPI.ItemIndex];

  EditPathToWorkspace.Text := FPathToWorkspace;

  EditPackagePrefaceName.Text := FAntPackageName;

  //verify if some was not load!
  Self.LoadPathsSettings(FFileName);

end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);
begin
   with TInifile.Create(pFilename) do
   begin
      WriteString('NewProject', 'PathToWorkspace', EditPathToWorkspace.Text);

      WriteString('NewProject', 'FullProjectName', FAndroidProjectName);
      WriteString('NewProject', 'InstructionSet', IntToStr(RGInstruction.ItemIndex));
      WriteString('NewProject', 'FPUSet', IntToStr(RGFPU.ItemIndex));

      WriteString('NewProject', 'ProjectModel',IntToStr(RGProjectType.ItemIndex));  //Eclipse or Ant


      if EditPackagePrefaceName.Text = '' then EditPackagePrefaceName.Text:= 'org.lazarus';
      WriteString('NewProject', 'AntPackageName', LowerCase(Trim(EditPackagePrefaceName.Text)));

      WriteString('NewProject', 'AndroidPlatform', IntToStr(ListBoxPlatform.ItemIndex));
      WriteString('NewProject', 'MinApi', IntToStr(ListBoxMinSDK.ItemIndex));
      WriteString('NewProject', 'TargetApi', IntToStr(ListBoxTargetAPI.ItemIndex));

      WriteString('NewProject', 'AntBuildMode', 'debug'); //default...

      if FMainActivity = '' then FMainActivity:= 'App';
      WriteString('NewProject', 'MainActivity', FMainActivity); //dummy

      WriteString('NewProject', 'SupportV4', FSupportV4); //dummy

      WriteString('NewProject', 'PathToJavaTemplates', FPathToJavaTemplates);
      WriteString('NewProject', 'PathToJavaJDK', FPathToJavaJDK);
      WriteString('NewProject', 'PathToAndroidNDK', FPathToAndroidNDK);
      WriteString('NewProject', 'PathToAndroidSDK', FPathToAndroidSDK);
      WriteString('NewProject', 'PathToAntBin', FPathToAntBin);
      WriteString('NewProject', 'PathToLazbuild', FPathToLazbuild);

      Free;
   end;
end;

//helper...
function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
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

