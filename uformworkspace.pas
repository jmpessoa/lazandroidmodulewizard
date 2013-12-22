unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    bbOK: TBitBtn;
    Bevel3: TBevel;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    edProjectName: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SelectDirectoryDialog2: TSelectDirectoryDialog;
    SelectDirectoryDialog3: TSelectDirectoryDialog;
    SelectDirectoryDialog4: TSelectDirectoryDialog;
    SelectDirectoryDialog5: TSelectDirectoryDialog;
    SelectDirectoryDialog6: TSelectDirectoryDialog;
    SelectDirectoryDialog7: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure RadioGroup4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}
    FPathToNdkPlataformsAndroidArcharmUsrLib: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
    FPathToNdkToolchains: string; {C:\adt32\ndk\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\... }
    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAntBin: string;
    FProjectModel: string;
    FGUIControls: string;
    FAntPackageName: string;
    FTargetApi: string;
    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;   //Simon "App"
  public
    { public declarations }
    procedure GetSubDirectories(const directory : string; list : TStrings) ;
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;
    property PathToNdkPlataformsAndroidArcharmUsrLib: string
                                                      read FPathToNdkPlataformsAndroidArcharmUsrLib
                                                      write FPathToNdkPlataformsAndroidArcharmUsrLib;
    property PathToNdkToolchains: string read FPathToNdkToolchains write FPathToNdkToolchains;
    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;

    property PathToJavaJDK: string read FPathToJavaJDK write FPathToJavaJDK;
    property PathToAndroidSDK: string read FPathToAndroidSDK write FPathToAndroidSDK;
    property PathToAntBin: string read FPathToAntBin write FPathToAntBin;
    property ProjectModel: string read FProjectModel write FProjectModel; {eclipse/any}
    property GUIControls: string read FGUIControls write FGUIControls;
    property AntPackageName: string read FAntPackageName write FAntPackageName;
    property TargetApi: string read FTargetApi write FTargetApi;
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
  end;

  function ReplaceChar(query: string; oldchar, newchar: char):string;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

procedure TFormWorkspace.FormShow(Sender: TObject);
begin
  //
end;

procedure TFormWorkspace.ListBox1Click(Sender: TObject);
begin
  FTargetApi:= ListBox1.Items.Strings[ListBox1.ItemIndex];
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

procedure TFormWorkspace.RadioGroup4Click(Sender: TObject);
begin
  FGUIControls:= RadioGroup4.Items[RadioGroup4.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  saveName, auxStr: string;
begin
  FMainActivity:= 'App'; {dummy for Simon template} //TODO: need name flexibility here...
  FAntPackageName:= LowerCase(Trim(Edit8.Text));
  FPathToWorkspace:= Edit1.Text;
  FAndroidProjectName:= Trim(ComboBox1.Text);
  if (Pos(DirectorySeparator, ComboBox1.Text) <= 0) or (RadioGroup3.ItemIndex = 1) then  //Ant Project
  begin
     FProjectModel:= 'Ant';
     if (Pos(DirectorySeparator, ComboBox1.Text) <= 0) then  //just "name", not path+name
     begin
         FAndroidProjectName:= FPathToWorkspace + DirectorySeparator + ComboBox1.Text;
         {$I-}
         ChDir(FPathToWorkspace+DirectorySeparator+ComboBox1.Text);
         if IOResult <> 0 then MkDir(FPathToWorkspace+DirectorySeparator+ComboBox1.Text);
     end;
  end;
  if ModalResult = mrOk then SaveSettings(FFileName);
end;

procedure TFormWorkspace.CheckBox1Click(Sender: TObject);
begin
   if CheckBox1.Checked then FTouchtestEnabled:= 'True'
   else  FTouchtestEnabled:= 'False';
end;

procedure TFormWorkspace.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then FAntBuildMode:= 'debug'
  else  FAntBuildMode:= 'release';
end;

procedure TFormWorkspace.ComboBox1Exit(Sender: TObject);
begin
  if Pos(DirectorySeparator, ComboBox1.Text) <= 0 then  //Ant Project
  begin
    RadioGroup3.ItemIndex:= 1;
    if Edit8.Text = '' then Edit8.Text:= 'org.xxxxxxx';
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
begin
  ComboBox1.SetFocus;
end;

procedure TFormWorkspace.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    Edit1.Text := SelectDirectoryDialog1.FileName;
    FPathToWorkspace:= SelectDirectoryDialog1.FileName;
    ComboBox1.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);
  end;
end;

procedure TFormWorkspace.SpeedButton2Click(Sender: TObject);
begin
  if SelectDirectoryDialog2.Execute then
  begin
    Edit2.Text := SelectDirectoryDialog2.FileName;
    FPathToNdkPlataformsAndroidArcharmUsrLib:= SelectDirectoryDialog2.FileName;
  end;
end;

procedure TFormWorkspace.SpeedButton3Click(Sender: TObject);
begin
  if SelectDirectoryDialog3.Execute then
  begin
    Edit3.Text := SelectDirectoryDialog3.FileName;
    FPathToNdkToolchains:= SelectDirectoryDialog3.FileName;
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

//http://delphi.about.com/od/delphitips2008/qt/subdirectories.htm
//fils the "list" TStrings with the subdirectories of the "directory" directory
procedure TFormWorkspace.GetSubDirectories(const directory : string; list : TStrings) ;
var
   sr : TSearchRec;
begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then
       Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..')) then
         List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name) ;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);
var
  i1, i2, i3, i4, i5: integer;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  begin
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FPathToNdkPlataformsAndroidArcharmUsrLib:= ReadString('NewProject','PathToNdkPlataformsAndroidArcharmUsrLib', '');
    FPathToNdkToolchains:= ReadString('NewProject','PathToNdkToolchains', '');

    FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');

    FPathToJavaJDK:= ReadString('NewProject','PathToJavaJDK', '');
    FPathToAndroidSDK:= ReadString('NewProject','PathToAndroidSDK', '');
    FPathToAntBin:= ReadString('NewProject','PathToAntBin', '');
    FAntPackageName:= ReadString('NewProject','AntPackageName', '');
    FTouchtestEnabled:= ReadString('NewProject','TouchtestEnabled', '');
    if  FTouchtestEnabled = '' then FTouchtestEnabled:= 'False';

    FAntBuildMode:= ReadString('NewProject','AntBuildMode', '');
    if FAntBuildMode = '' then FAntBuildMode:= 'debug'; //debug

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity ='' then FMainActivity:= 'App';

    if ReadString('NewProject','InstructionSet', '') <> '' then
       i1:= strToInt(ReadString('NewProject','InstructionSet', ''))
    else i1:= 0;

    if ReadString('NewProject','FPUSet', '') <> '' then
       i2:= strToInt(ReadString('NewProject','FPUSet', ''))
    else i2:= 0;

    if ReadString('NewProject','ProjectModel', '') <> '' then
       i3:= strToInt(ReadString('NewProject','ProjectModel', ''))
    else i3:= 0;

    if ReadString('NewProject','GUIControls', '') <> '' then
       i4:= strToInt(ReadString('NewProject','GUIControls', ''))
    else i4:= 0;

    if ReadString('NewProject','TargetApi', '') <> '' then
       i5:= strToInt(ReadString('NewProject','TargetApi', ''))
    else i5:= 7; // Api 17

    ComboBox1.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

    Free;
  end;

  RadioGroup1.ItemIndex:= i1;
  RadioGroup2.ItemIndex:= i2;
  RadioGroup3.ItemIndex:= i3;
  RadioGroup4.ItemIndex:= i4;
  ListBox1.ItemIndex:= i5;;

  if FTouchtestEnabled = 'True' then
     self.CheckBox1.Checked:= True
  else
     self.CheckBox1.Checked:= False;

 if FAntBuildMode = 'debug' then
    self.CheckBox2.Checked:= True
 else
    self.CheckBox2.Checked:= False;

  FInstructionSet:= RadioGroup1.Items[RadioGroup1.ItemIndex];
  FFPUSet:= RadioGroup2.Items[RadioGroup2.ItemIndex];
  FProjectModel:= RadioGroup3.Items[RadioGroup3.ItemIndex]; //"Eclipse Project"/"Ant Project"
  FGUIControls:=  RadioGroup4.Items[RadioGroup4.ItemIndex];
  FTargetApi:= ListBox1.Items[ListBox1.ItemIndex];

  Edit1.Text := FPathToWorkspace;
  Edit2.Text := FPathToNdkPlataformsAndroidArcharmUsrLib;
  Edit3.Text := FPathToNdkToolchains;
  Edit4.Text := FPathToJavaTemplates;

  Edit5.Text := FPathToJavaJDK;
  Edit6.Text := FPathToAndroidSDK;
  Edit7.Text := FPathToAntBin;
  Edit8.Text := FAntPackageName;
end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);
begin
   with TInifile.Create(pFilename) do
   begin
      WriteString('NewProject', 'PathToWorkspace', Edit1.Text);
      WriteString('NewProject', 'PathToNdkPlataformsAndroidArcharmUsrLib', Edit2.Text);
      WriteString('NewProject', 'PathToNdkToolchains', Edit3.Text);
      WriteString('NewProject', 'PathToJavaTemplates', Edit4.Text);
      WriteString('NewProject', 'InstructionSet', IntToStr(RadioGroup1.ItemIndex));
      WriteString('NewProject', 'FPUSet', IntToStr(RadioGroup2.ItemIndex));

      WriteString('NewProject', 'PathToJavaJDK', Edit5.Text);
      WriteString('NewProject', 'PathToAndroidSDK', Edit6.Text);
      WriteString('NewProject', 'PathToAntBin', Edit7.Text);

      WriteString('NewProject', 'ProjectModel',IntToStr(RadioGroup3.ItemIndex));
      WriteString('NewProject', 'GUIControls', IntToStr(RadioGroup4.ItemIndex));

      WriteString('NewProject', 'AntPackageName', LowerCase(Trim(Edit8.Text)));

      WriteString('NewProject', 'TargetApi', IntToStr(ListBox1.ItemIndex));

      if CheckBox1.Checked then
         WriteString('NewProject', 'TouchtestEnabled', 'True')
      else
         WriteString('NewProject', 'TouchtestEnabled', 'False');

      if CheckBox2.Checked then
         WriteString('NewProject', 'AntBuildMode', 'debug')
      else
         WriteString('NewProject', 'AntBuildMode', 'release');

      WriteString('NewProject', 'MainActivity', FMainActivity); //dummy

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

end.

