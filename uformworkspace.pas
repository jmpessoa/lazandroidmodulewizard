unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    bbOK: TBitBtn;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    edProjectName: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup5: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SelectDirectoryDialog2: TSelectDirectoryDialog;
    SelectDirectoryDialog4: TSelectDirectoryDialog;
    SelectDirectoryDialog5: TSelectDirectoryDialog;
    SelectDirectoryDialog6: TSelectDirectoryDialog;
    SelectDirectoryDialog7: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure ComboBox1DblClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure RadioGroup5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}
    FPathToNdkPlataforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}

    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FProjectModel: string;

    FUseControls: string;

    FAntPackageName: string;
    FMinApi: string;
    FTargetApi: string;
    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;   //Simon "App"
    FNDK: string;
    FAndroidPlatform: string;

  public
    { public declarations }
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    function GetTextByListIndex(index:integer): string;
    function GetTextByList2Index(index:integer): string;
    function GetNDKPlatform(identName: string): string;

    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;
    property PathToNdkPlataforms: string
                                                      read FPathToNdkPlataforms
                                                      write FPathToNdkPlataforms;
    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;

    property PathToJavaJDK: string read FPathToJavaJDK write FPathToJavaJDK;
    property PathToAndroidSDK: string read FPathToAndroidSDK write FPathToAndroidSDK;
    property PathToAndroidNDK: string read FPathToAndroidNDK write FPathToAndroidNDK;
    property PathToAntBin: string read FPathToAntBin write FPathToAntBin;
    property ProjectModel: string read FProjectModel write FProjectModel; {eclipse/ant/jbridge}
    property UseControls: string read FUseControls write FUseControls;
    property AntPackageName: string read FAntPackageName write FAntPackageName;
    property MinApi: string read FMinApi write FMinApi;
    property TargetApi: string read FTargetApi write FTargetApi;
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
    property NDK: string read FNDK write FNDK;
    property AndroidPlatform: string read FAndroidPlatform write FAndroidPlatform;
  end;

  procedure GetSubDirectories(const directory : string; list : TStrings);
  function ReplaceChar(query: string; oldchar, newchar: char):string;
  function TrimChar(query: string; delimiter: char): string;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

procedure TFormWorkspace.ListBox1Click(Sender: TObject);
begin
    FMinApi:= ListBox1.Items.Strings[ListBox1.ItemIndex]
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByListIndex(index:integer): string;
begin
   Result:= '';
   case index of
     0: Result:= '100% market sharing'; // Api(8)
     1: Result:= '99.2% market sharing'; // Api(10)
     2: Result:= '84.3% market sharing'; // Api(14)
     3: Result:= '84.3% market sharing'; // Api(15)
     4: Result:= '72% market sharing'; // Api(16)
     5: Result:= '43% market sharing'; // Api(17)
     6: Result:= '23.9% market sharing'; // Api(18)
     7: Result:= '13.6% market sharing'; // Api(19)
   end;
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByList2Index(index:integer): string;
begin
   Result:= '';
   case index of
     0: Result:= 'Froyo 2.2';        //0.8%  -  Api:8
     1: Result:= 'Gingerbread 2.3';  //14.9% -  Api:10
     2: Result:= 'Ice Cream 4.0';    //15.7% -  Api:14
     3: Result:= 'Ice Cream 4.0x';   //12.3% -  Api:15
     4: Result:= 'Jelly Bean 4.1';   //29.0% -  Api:16
     5: Result:= 'Jelly Bean 4.2';   //19.1% -  Api:17
     6: Result:= 'Jelly Bean 4.3';   //10.3% -  Api:18
     7: Result:= 'KitKat 4.4';       //13.6% -  Api:19
   end;
end;


procedure TFormWorkspace.ListBox1SelectionChange(Sender: TObject; User: boolean);
begin
    //StatusBar1.SimpleText:= GetTextByListIndex(ListBox1.ItemIndex);
    StatusBar1.Panels.Items[0].Text:= 'MinSdk Api: '+GetTextByListIndex(ListBox1.ItemIndex);
end;

procedure TFormWorkspace.ListBox2Click(Sender: TObject);
begin
  case ListBox2.ItemIndex of
      0: FTargetApi:= '8';
      1: FTargetApi:= '10';
      2: FTargetApi:= '14';
      3: FTargetApi:= '15';
      4: FTargetApi:= '16';
      5: FTargetApi:= '17';
      6: FTargetApi:= '18';
      7: FTargetApi:= '19';
  end
end;

procedure TFormWorkspace.ListBox2SelectionChange(Sender: TObject; User: boolean);
begin
  StatusBar1.Panels.Items[1].Text:='Target Api: '+GetTextByList2Index(ListBox2.ItemIndex);
end;

procedure TFormWorkspace.RadioGroup1Click(Sender: TObject);
begin
  FInstructionSet:= RadioGroup1.Items[RadioGroup1.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RadioGroup2Click(Sender: TObject);
begin
  FFPUSet:= RadioGroup2.Items[RadioGroup2.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RadioGroup3Click(Sender: TObject);
begin
  FProjectModel:= RadioGroup3.Items[RadioGroup3.ItemIndex];  //fix 15-december-2013
end;

function TFormWorkspace.GetNDKPlatform(identName: string): string;
begin
         if identName = 'Froyo' then Result:= 'android-8'
    else if identName = 'Gingerbread' then Result:= 'android-13'
    else if identName = 'Ice Cream 4.0' then Result:= 'android-14'
    else if identName = 'Ice Cream 4.0x' then Result:= 'android-15'
    else if identName = 'Jelly Bean 4.1' then Result:= 'android-16'
    else if identName = 'Jelly Bean 4.2' then Result:= 'android-17'
    else if identName = 'Jelly Bean 4.3' then Result:= 'android-18'
    else if identName = 'KitKat 4.4' then Result:= 'android-19'
    else Result:= 'android-14';
end;

//Ref. http://forum.xda-developers.com/wiki/Android/Build_Numbers
procedure TFormWorkspace.RadioGroup5Click(Sender: TObject);
begin

  if RadioGroup5.ItemIndex = 0 then FNDK:= '7'
  else if RadioGroup5.ItemIndex = 1 then FNDK:= '9'
  else FNDK:= '10';

  ComboBox2.Items.Clear;
  ListBox1.Items.Clear;

  case  RadioGroup5.ItemIndex of
     0: begin //7

            {
              ComboBox2.Items.Add('android-8');  //platform
              ComboBox2.Items.Add('android-10');  //platform
              ComboBox2.Items.Add('android-14'); //platform
            }

            ComboBox2.Items.Add('Froyo');
            ComboBox2.Items.Add('Gingerbread');
            ComboBox2.Items.Add('Ice Cream 4.0');

            ComboBox2.ItemIndex:= 2; ////platform android-14

            ListBox1.Items.Add('8');   //Api(8)Froyo (2.2)
            ListBox1.Items.Add('10');  //Api(10)Gingerbread (2.3)
            ListBox1.Items.Add('14');  //Api(14)Ice Cream Sandwich (4.0 - 4.0.1 - 4.0.2)

            ListBox1.ItemIndex:= 2;
        end;
     1: begin  //9
            {
          ComboBox2.Items.Add('android-8 [Froyo]');
          ComboBox2.Items.Add('android-10 [Gingerbread]');
          ComboBox2.Items.Add('android-14 [Ice Cream 4.0]');
          ComboBox2.Items.Add('android-15 [Ice Cream 4.0x]');
          ComboBox2.Items.Add('android-16 [Jelly Bean 4.1]');
          ComboBox2.Items.Add('android-17 [Jelly Bean 4.2]');
          ComboBox2.Items.Add('android-18 [Jelly Bean 4.3]');
          ComboBox2.Items.Add('android-19 [KitKat 4.4]');
             }

          ComboBox2.Items.Add('Froyo');
          ComboBox2.Items.Add('Gingerbread');
          ComboBox2.Items.Add('Ice Cream 4.0');
          ComboBox2.Items.Add('Ice Cream 4.0x');
          ComboBox2.Items.Add('Jelly Bean 4.1');
          ComboBox2.Items.Add('Jelly Bean 4.2');
          ComboBox2.Items.Add('Jelly Bean 4.3');
          ComboBox2.Items.Add('KitKat 4.4');

          ComboBox2.ItemIndex:= 2; ////platform android-14

          ListBox1.Items.Add('8');   //Api(8)Froyo (2.2)
          ListBox1.Items.Add('10');  //Api(10)Gingerbread (2.3)
          ListBox1.Items.Add('14');  //Api(14)Ice Cream Sandwich (4.0 - 4.0.1 - 4.0.2)

          ListBox1.ItemIndex:= 2;
        end;
     2: begin  //10
            {
          ComboBox2.Items.Add('android-8 [Froyo]');
          ComboBox2.Items.Add('android-10 [Gingerbread]');
          ComboBox2.Items.Add('android-14 [Ice Cream 4.0]');
          ComboBox2.Items.Add('android-15 [Ice Cream 4.0x]');
          ComboBox2.Items.Add('android-16 [Jelly Bean 4.1]');
          ComboBox2.Items.Add('android-17 [Jelly Bean 4.2]');
          ComboBox2.Items.Add('android-18 [Jelly Bean 4.3]');
          ComboBox2.Items.Add('android-19 [KitKat 4.4]');
             }

          ComboBox2.Items.Add('Froyo');
          ComboBox2.Items.Add('Gingerbread');
          ComboBox2.Items.Add('Ice Cream 4.0');
          ComboBox2.Items.Add('Ice Cream 4.0x');
          ComboBox2.Items.Add('Jelly Bean 4.1');
          ComboBox2.Items.Add('Jelly Bean 4.2');
          ComboBox2.Items.Add('Jelly Bean 4.3');
          ComboBox2.Items.Add('KitKat 4.4');

          ComboBox2.ItemIndex:= 2; ////platform android-14

          ListBox1.Items.Add('8');   //Api(8)Froyo (2.2)
          ListBox1.Items.Add('10');  //Api(10)Gingerbread (2.3)
          ListBox1.Items.Add('14');  //Api(14)Ice Cream Sandwich (4.0 - 4.0.1 - 4.0.2)

          ListBox1.ItemIndex:= 2;
        end;
  end;
end;

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   strList: TStringList;
   count, i, j: integer;
   path, savePath: string;
begin
  if ModalResult = mrCancel  then Exit;

  if Edit1.Text = '' then
  begin
    ShowMessage('Error! Workplace Path was missing....[Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if ComboBox1.Text = '' then
  begin
    ShowMessage('Error! Projec Name was missing.... [Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if Edit8.Text = '' then Edit8.Text:= 'org.lazarus';

  FMainActivity:= 'App'; {dummy for Simon template} //TODO: need name flexibility here...

  FAntPackageName:= LowerCase(Trim(Edit8.Text));

  FPathToWorkspace:= Edit1.Text;
  FPathToAndroidNDK:= Edit2.Text;
  FPathToAndroidSDK:=   Edit6.Text;

  FPathToJavaTemplates:= Edit4.Text;

  FAndroidProjectName:= Trim(ComboBox1.Text);
  FAndroidPlatform:= GetNDKPlatform(ComboBox2.Text);

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

  if RadioGroup3.ItemIndex = 1 then  //Ant Project
  begin
     FProjectModel:= 'Ant';
     if (Pos(DirectorySeparator, ComboBox1.Text) = 0) then  //i.e just "name", not path+name
     begin
         FAndroidProjectName:= FPathToWorkspace + DirectorySeparator + ComboBox1.Text; //get full name: path+name
         {$I-}
         ChDir(FPathToWorkspace+DirectorySeparator+ComboBox1.Text);
         if IOResult <> 0 then MkDir(FPathToWorkspace+DirectorySeparator+ComboBox1.Text);
     end;
  end;


  SaveSettings(FFileName);

end;

procedure TFormWorkspace.ComboBox1DblClick(Sender: TObject);
begin

  FPathToWorkspace:= Edit1.Text;
  ComboBox1.Items.Clear;
  GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

  //try some guesswork:
  if Pos('eclipse', LowerCase(FPathToWorkspace) ) > 0 then
  begin
    RadioGroup3.ItemIndex:= 0;
    Edit8.Text:='';
  end;

  if Pos('ant', LowerCase(FPathToWorkspace) ) > 0 then
     RadioGroup3.ItemIndex:= 1;

end;

procedure TFormWorkspace.ComboBox2Change(Sender: TObject);
begin
  ListBox1.Items.Clear;
  case ComboBox2.ItemIndex of
     0: begin   //platform 8
          ListBox1.Items.Add('8'); //Froyo (2.2)
          ListBox1.ItemIndex:= 0;
        end;
     1: begin  //platform 10
          ListBox1.Items.Add('8');  //Froyo (2.2)
          ListBox1.Items.Add('10'); //Gingerbread (2.3)
          ListBox1.ItemIndex:= 1;
        end;
     2: begin  //platform 14
          ListBox1.Items.Add('8');
          ListBox1.Items.Add('10');
          ListBox1.Items.Add('14'); //Ice Cream Sandwich (4.01 - 4.02)
          ListBox1.ItemIndex:= 2;
        end;
     3: begin  //platform  15
          ListBox1.Items.Add('8');
          ListBox1.Items.Add('10');
          ListBox1.Items.Add('14'); //Ice Cream Sandwich (4.01 - 4.02)
          ListBox1.Items.Add('15'); //Ice Cream Sandwich (4.03 - 4.04)
          ListBox1.ItemIndex:= 2;
        end;
     4: begin  //platform  16
          ListBox1.Items.Add('8');
          ListBox1.Items.Add('10');
          ListBox1.Items.Add('14'); //Ice Cream Sandwich (4.01 - 4.02)
          ListBox1.Items.Add('15'); //Ice Cream Sandwich (4.03 - 4.04)
          ListBox1.Items.Add('16'); //Jelly Bean (4.1.x)
          ListBox1.ItemIndex:= 2;
        end;

     5: begin  //platform  17
          ListBox1.Items.Add('8');
          ListBox1.Items.Add('10');
          ListBox1.Items.Add('14'); //Ice Cream Sandwich (4.01 - 4.02)
          ListBox1.Items.Add('15'); //Ice Cream Sandwich (4.03 - 4.04)
          ListBox1.Items.Add('16'); //Jelly Bean (4.1.x)
          ListBox1.Items.Add('17'); //Jelly Bean (4.2.x)
          ListBox1.ItemIndex:= 2;
        end;

     6: begin  //platform  18
          ListBox1.Items.Add('8');
          ListBox1.Items.Add('10');
          ListBox1.Items.Add('14'); //Ice Cream Sandwich (4.01 - 4.02)
          ListBox1.Items.Add('15'); //Ice Cream Sandwich (4.03 - 4.04)
          ListBox1.Items.Add('16'); //Jelly Bean (4.1.x)
          ListBox1.Items.Add('17'); //Jelly Bean (4.2.x)
          ListBox1.Items.Add('18'); //Jelly Bean (4.3)
          ListBox1.ItemIndex:= 2;
        end;

     7: begin  //platform 19
          ListBox1.Items.Add('8');  //Froyo (2.2)
          ListBox1.Items.Add('10'); //Gingerbread (2.3)
          ListBox1.Items.Add('14'); //Ice Cream Sandwich (4.0 - 4.01 - 4.02)
          ListBox1.Items.Add('15'); //Ice Cream Sandwich (4.03 - 4.04)
          ListBox1.Items.Add('16'); //Jelly Bean (4.1)
          ListBox1.Items.Add('17'); //Jelly Bean (4.2)
          ListBox1.Items.Add('18'); //Jelly Bean (4.3)
          ListBox1.Items.Add('19'); //KitKat (4.4)
          ListBox1.ItemIndex:= 2;
        end;
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
begin
  ComboBox1.SetFocus;
  StatusBar1.Panels.Items[0].Text:= 'MinSdk Api: '+GetTextByListIndex(ListBox1.ItemIndex);
  StatusBar1.Panels.Items[1].Text:= 'Target Api: '+GetTextByList2Index(ListBox2.ItemIndex);
end;

procedure TFormWorkspace.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    Edit1.Text := SelectDirectoryDialog1.FileName;
    FPathToWorkspace:= SelectDirectoryDialog1.FileName;
    ComboBox1.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

    //try some guesswork:
    if Pos('eclipse', LowerCase(FPathToWorkspace) ) > 0 then
    begin
      RadioGroup3.ItemIndex:= 0;
      Edit8.Text:='';
    end;

    if Pos('ant', LowerCase(FPathToWorkspace) ) > 0 then
       RadioGroup3.ItemIndex:= 1;

  end;
end;

procedure TFormWorkspace.SpeedButton2Click(Sender: TObject);
begin
  if SelectDirectoryDialog2.Execute then
  begin
    Edit2.Text := SelectDirectoryDialog2.FileName;
    FPathToAndroidNDK:= SelectDirectoryDialog2.FileName;
  end;
end;

procedure TFormWorkspace.SpeedButton4Click(Sender: TObject);
begin
  if SelectDirectoryDialog4.Execute then
  begin
    Edit4.Text := SelectDirectoryDialog4.FileName;
    FPathToJavaTemplates:= SelectDirectoryDialog4.FileName;
  end;
end;

procedure TFormWorkspace.SpeedButton5Click(Sender: TObject);
begin
  if SelectDirectoryDialog5.Execute then
  begin
    Edit5.Text := SelectDirectoryDialog5.FileName;
    FPathToJavaJDK:= SelectDirectoryDialog5.FileName;
  end;
end;

procedure TFormWorkspace.SpeedButton6Click(Sender: TObject);
begin
  if SelectDirectoryDialog6.Execute then
  begin
    Edit6.Text := SelectDirectoryDialog6.FileName;
    FPathToAndroidSDK:= SelectDirectoryDialog6.FileName;
  end;
end;

procedure TFormWorkspace.SpeedButton7Click(Sender: TObject);
begin
    if SelectDirectoryDialog7.Execute then
  begin
    Edit7.Text := SelectDirectoryDialog7.FileName;
    FPathToAntBin:= SelectDirectoryDialog7.FileName;
  end;
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);
var
  i1, i2, i3, i5, j1, j2, j3: integer;
  strYesNo: string;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  begin
    strYesNo:= ReadString('NewProject','SetFileSuffixSo', '');

    strYesNo:= ReadString('NewProject','AbsolutOutputFilePath', '');

    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FPathToNdkPlataforms:= ReadString('NewProject','PathToNdkPlataforms', '');

    FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');

    FPathToJavaJDK:= ReadString('NewProject','PathToJavaJDK', '');
    FPathToAndroidSDK:= ReadString('NewProject','PathToAndroidSDK', '');
    FPathToAndroidNDK:= ReadString('NewProject','PathToAndroidNDK', '');
    FPathToAntBin:= ReadString('NewProject','PathToAntBin', '');
    FAntPackageName:= ReadString('NewProject','AntPackageName', '');

    FAntBuildMode:= 'debug'; //default...
    FTouchtestEnabled:= 'True'; //default

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity = '' then FMainActivity:= 'App';

    FUseControls:= ReadString('NewProject','UseControls', '');

    if ReadString('NewProject','NDK', '') <> '' then
      i5:= strToInt(ReadString('NewProject','NDK', ''))
    else i5:= 1;  //ndk 9

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

    if  j1 < ListBox1.Items.Count then
        ListBox1.ItemIndex:= j1
    else
       ListBox1.ItemIndex:= ListBox1.Items.Count-1;

    if ReadString('NewProject','AndroidPlatform', '') <> '' then
       j2:= strToInt(ReadString('NewProject','AndroidPlatform', ''))
    else j2:= 2; // Android-14

    if j2 < ComboBox2.Items.Count then
        ComboBox2.ItemIndex:= j2
    else
        ComboBox2.ItemIndex:= ComboBox2.Items.Count-1;

    if ReadString('NewProject','TargetApi', '') <> '' then
       j3:= strToInt(ReadString('NewProject','TargetApi', ''))
    else j3:= 2; // Api 14

    if  j3 < ListBox2.Items.Count then
        ListBox2.ItemIndex:= j3
    else
       ListBox2.ItemIndex:= ListBox2.Items.Count-1;

    ComboBox1.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

    Free;
  end;

  RadioGroup1.ItemIndex:= i1;
  RadioGroup2.ItemIndex:= i2;

  if i3 > 1 then i3:= 0;
  RadioGroup3.ItemIndex:= i3;

  RadioGroup5.ItemIndex:= i5;

  FInstructionSet:= RadioGroup1.Items[RadioGroup1.ItemIndex];
  FFPUSet:= RadioGroup2.Items[RadioGroup2.ItemIndex];
  FProjectModel:= RadioGroup3.Items[RadioGroup3.ItemIndex]; //"Eclipse Project"/"Ant Project"

  FMinApi:= ListBox1.Items[ListBox1.ItemIndex];
  FTargetApi:= ListBox2.Items[ListBox2.ItemIndex];

  FNDK:= RadioGroup5.Items[RadioGroup5.ItemIndex];

  Edit1.Text := FPathToWorkspace;
  Edit2.Text := FPathToAndroidNDK;
  Edit4.Text := FPathToJavaTemplates;

  Edit5.Text := FPathToJavaJDK;
  Edit6.Text := FPathToAndroidSDK;
  Edit7.Text := FPathToAntBin;
  Edit8.Text := FAntPackageName;
end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);
var
  strFlag: string;
begin
   with TInifile.Create(pFilename) do
   begin
      WriteString('NewProject', 'PathToWorkspace', Edit1.Text);
      WriteString('NewProject', 'PathToNdkPlataforms', Edit2.Text);

      WriteString('NewProject', 'NDK', IntToStr(RadioGroup5.ItemIndex));

      WriteString('NewProject', 'PathToJavaTemplates', Edit4.Text);
      WriteString('NewProject', 'InstructionSet', IntToStr(RadioGroup1.ItemIndex));
      WriteString('NewProject', 'FPUSet', IntToStr(RadioGroup2.ItemIndex));

      WriteString('NewProject', 'PathToJavaJDK', Edit5.Text);
      WriteString('NewProject', 'PathToAndroidNDK', Edit2.Text);
      WriteString('NewProject', 'PathToAndroidSDK', Edit6.Text);
      WriteString('NewProject', 'PathToAntBin', Edit7.Text);

      WriteString('NewProject', 'ProjectModel',IntToStr(RadioGroup3.ItemIndex));  //Eclipse/Ant
      WriteString('NewProject', 'UseControls', FUseControls); //yes/no

      WriteString('NewProject', 'AntPackageName', LowerCase(Trim(Edit8.Text)));

      WriteString('NewProject', 'MinApi', IntToStr(ListBox1.ItemIndex));
      WriteString('NewProject', 'TargetApi', IntToStr(ListBox2.ItemIndex));

      WriteString('NewProject', 'AntBuildMode', 'debug'); //default...

      WriteString('NewProject', 'MainActivity', FMainActivity); //dummy

      WriteString('NewProject', 'AndroidPlatform', IntToStr(ComboBox2.ItemIndex));

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

