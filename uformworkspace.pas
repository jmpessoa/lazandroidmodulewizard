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
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    edProjectName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SelectDirectoryDialog2: TSelectDirectoryDialog;
    SelectDirectoryDialog3: TSelectDirectoryDialog;
    SelectDirectoryDialog4: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
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
  end;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

procedure TFormWorkspace.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if ModalResult = mrOk then SaveSettings(FFileName);
end;

procedure TFormWorkspace.ComboBox1Change(Sender: TObject);
begin
  FPathToWorkspace:= ComboBox1.Text; //SelectDirectoryDialog1.FileName;
  FAndroidProjectName:= ComboBox1.Text;
end;

procedure TFormWorkspace.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    Edit1.Text := SelectDirectoryDialog1.FileName;
    FPathToWorkspace:= SelectDirectoryDialog1.FileName;
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
       if ((sr.Attr and faDirectory <> 0) AND (sr.Name <> '.') AND (sr.Name <> '..')) then
         List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name) ;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);
var
   i1, i2: integer;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  begin
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FPathToNdkPlataformsAndroidArcharmUsrLib:= ReadString('NewProject','PathToNdkPlataformsAndroidArcharmUsrLib', '');
    FPathToNdkToolchains:= ReadString('NewProject','PathToNdkToolchains', '');

    FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');

    if ReadString('NewProject','InstructionSet', '') <> '' then
       i1:= strToInt(ReadString('NewProject','InstructionSet', ''))
    else i1:= 0;

    if ReadString('NewProject','FPUSet', '') <> '' then
       i2:= strToInt(ReadString('NewProject','FPUSet', ''))
    else i2:= 0;

    FInstructionSet:= RadioGroup1.Items[i1] ;
    FFPUSet:= RadioGroup2.Items[i2] ;

    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);
    Free;
  end;
  Edit1.Text := FPathToWorkspace;
  Edit2.Text := FPathToNdkPlataformsAndroidArcharmUsrLib;
  Edit3.Text := FPathToNdkToolchains;
  Edit4.Text := FPathToJavaTemplates;
  RadioGroup1.ItemIndex:= i1;
  RadioGroup2.ItemIndex:= i2;
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
      Free;
   end;
end;

end.

