unit uFormComplements;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons;

type

  { TFormAddComplements }

  TFormAddComplements = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBoxMinSdkApi: TComboBox;
    EditManifestPermission: TEdit;
    EditGradleDep: TEdit;
    EditPath: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBoxPermission: TListBox;
    ListBoxGradleDep: TListBox;
    ListBoxPath: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButtonPermission: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButtonAddPath: TSpeedButton;
    SpeedButtonAddGradleDep: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButtonOpen: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButtonPermissionClick(Sender: TObject);
    procedure SpeedButtonAddPathClick(Sender: TObject);
    procedure SpeedButtonAddGradleDepClick(Sender: TObject);
    procedure SpeedButtonOpenClick(Sender: TObject);
  private

  public

  end;

var
  FormAddComplements: TFormAddComplements;

implementation

{$R *.lfm}

{ TFormAddComplements }

procedure TFormAddComplements.SpeedButtonOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    EditPath.Text:= OpenDialog1.FileName;
end;

procedure TFormAddComplements.SpeedButtonAddPathClick(Sender: TObject);
begin
  if EditPath.Text <> '' then
  begin
    ListBoxPath.Items.Add(Self.EditPath.Text);
    EditPath.Text:= '';
  end;
end;

procedure TFormAddComplements.SpeedButtonPermissionClick(Sender: TObject);
begin
  if EditManifestPermission.Text <> '' then
  begin
    ListBoxPermission.Items.Add(EditManifestPermission.Text);
    EditManifestPermission.Text:= '';
  end;
end;

procedure TFormAddComplements.SpeedButton1Click(Sender: TObject);
var
  s1, s2, s3: string;
begin
  s1:= 'implementation ''com.sun.mail:android-mail:1.6.2''';
  s2:= 'classpath ''com.google.gms:google-services:4.3.8''';
  s3:= 'apply plugin: ''com.google.gms.google-services''';
  ShowMessage('Gradle Add Examples:' + sLineBreak +
               sLineBreak + s1 + sLineBreak + sLineBreak + s2 +
               sLineBreak + sLineBreak + s3);
end;

procedure TFormAddComplements.SpeedButton5Click(Sender: TObject);
var
  s1, s2, s3: string;
begin
  s1:= 'android.permission.INTERNET';
  s2:= 'android.permission.BLUETOOTH';
  s3:= 'android.permission.VIBRATE';
  ShowMessage('Android Manifest Permission Examples:' + sLineBreak +
               sLineBreak + s1 + sLineBreak + s2 + sLineBreak + s3 + sLineBreak + sLineBreak +
               'warning: dangerous permission need be handled by code, too');
end;

procedure TFormAddComplements.SpeedButtonAddGradleDepClick(Sender: TObject);
begin
  if EditGradleDep.Text <> '' then
  begin
    ListBoxGradleDep.Items.Add(Self.EditGradleDep.Text);
    EditGradleDep.Text:= '';
  end;
end;

end.

