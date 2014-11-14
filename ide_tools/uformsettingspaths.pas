unit uformsettingspaths;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, LazIDEIntf;

type

  { TFormSettingsPaths }

  TFormSettingsPaths  = class(TForm)
    bbOK: TBitBtn;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    edProjectName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
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
    procedure bbOKClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);

    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { private declarations }
    FPathToJavaTemplates: string;
    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
  public
    { public declarations }
    FOk: boolean;
    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
  end;

var
   FormSettingsPaths: TFormSettingsPaths;

implementation

{$R *.lfm}

{ TFormSettingsPaths }

procedure TFormSettingsPaths.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FOk then
    Self.SaveSettings( AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini' );
end;


procedure TFormSettingsPaths.FormShow(Sender: TObject);
begin
   FOk:= False;
   Self.LoadSettings(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
end;

procedure TFormSettingsPaths.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    Edit1.Text := SelectDirectoryDialog1.FileName;
  end;
end;

procedure TFormSettingsPaths.FormActivate(Sender: TObject);
begin
  Edit5.SetFocus;
end;

procedure TFormSettingsPaths.BitBtn2Click(Sender: TObject);
begin
  FOk:= False;
  Close;
end;

procedure TFormSettingsPaths.bbOKClick(Sender: TObject);
begin
   FOk:= True;
   Close;
end;

procedure TFormSettingsPaths.SpeedButton2Click(Sender: TObject);
begin
  if SelectDirectoryDialog2.Execute then
  begin
    Edit2.Text := SelectDirectoryDialog2.FileName;
    FPathToAndroidNDK:= SelectDirectoryDialog2.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButton4Click(Sender: TObject);
begin
  if SelectDirectoryDialog4.Execute then
  begin
    Edit4.Text := SelectDirectoryDialog4.FileName;
    FPathToJavaTemplates:= SelectDirectoryDialog4.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButton5Click(Sender: TObject);
begin
  if SelectDirectoryDialog5.Execute then
  begin
    Edit5.Text := SelectDirectoryDialog5.FileName;
    FPathToJavaJDK:= SelectDirectoryDialog5.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButton6Click(Sender: TObject);
begin
  if SelectDirectoryDialog6.Execute then
  begin
    Edit6.Text := SelectDirectoryDialog6.FileName;
    FPathToAndroidSDK:= SelectDirectoryDialog6.FileName;
  end;
end;

procedure TFormSettingsPaths.SpeedButton7Click(Sender: TObject);
begin
    if SelectDirectoryDialog7.Execute then
  begin
    Edit7.Text := SelectDirectoryDialog7.FileName;
    FPathToAntBin:= SelectDirectoryDialog7.FileName;
  end;
end;

procedure TFormSettingsPaths.LoadSettings(const fileName: string);
var
   indexNdk: integer;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    begin
      Edit2.Text := ReadString('NewProject','PathToAndroidNDK', '');
      Edit4.Text := ReadString('NewProject','PathToJavaTemplates', '');
      Edit5.Text := ReadString('NewProject','PathToJavaJDK', '');
      Edit6.Text := ReadString('NewProject','PathToAndroidSDK', '');

      Edit7.Text := ReadString('NewProject','PathToAntBin', '');
      Edit1.Text:=  ReadString('NewProject','PathToLazbuild', '');

      if ReadString('NewProject','NDK', '') <> '' then
          indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
          indexNdk:= 2;  //ndk 10

      RadioGroup5.ItemIndex:= indexNdk;

      Free;
    end;
  end;
end;

procedure TFormSettingsPaths.SaveSettings(const fileName: string);
begin
  with TInifile.Create(fileName) do
  begin
      WriteString('NewProject', 'PathToNdkPlataforms', Edit2.Text);
      WriteString('NewProject', 'PathToJavaTemplates', Edit4.Text);
      WriteString('NewProject', 'PathToJavaJDK', Edit5.Text);
      WriteString('NewProject', 'PathToAndroidNDK', Edit2.Text);
      WriteString('NewProject', 'PathToAndroidSDK', Edit6.Text);
      WriteString('NewProject', 'PathToAntBin', Edit7.Text);
      WriteString('NewProject', 'NDK', IntToStr(RadioGroup5.ItemIndex));
      WriteString('NewProject', 'PathToLazbuild', Edit1.Text);
      Free;
  end;
end;


end.

