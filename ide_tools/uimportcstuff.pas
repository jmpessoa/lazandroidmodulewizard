unit uimportcstuff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls,
  IniFiles, LazIDEIntf, ProjectIntf;

type

  { TFormImportCStuff }

  TFormImportCStuff = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBoxAllC: TCheckBox;
    CheckBoxAllH: TCheckBox;
    AndroidmkComboBox: TComboBox;
    h2pasComboBox: TComboBox;
    EditLibName: TEdit;
    EditImportC: TEdit;
    EditImportH: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelWarnig: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SelectDirectoryDialog2: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    LibrariesPath: string;
  end;

var
  FormImportCStuff: TFormImportCStuff;

implementation

{$R *.lfm}

{ TFormImportCStuff }

procedure TFormImportCStuff.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    EditImportC.Text:= SelectDirectoryDialog1.FileName;
  end;
end;

procedure TFormImportCStuff.FormShow(Sender: TObject);

var
  Project: TLazProject;
  pathToProject: string;
  p: integer;


begin

   Left := (Screen.Width - Width) div 2;
   Top := (Screen.Height - Height) div 2;

   Project:= LazarusIDE.ActiveProject;

  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '' ) then
  begin

   p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
   pathToProject:= Copy(Project.ProjectInfoFile, 1, p);

   with TIniFile.Create(pathToProject+'jni'+DirectorySeparator + 'ImportCStuff.ini') do
   try
     FormImportCStuff.EditImportC.Text := ReadString('ImportCStuff','EditImportC', '');
     FormImportCStuff.CheckBoxAllC.Checked := ReadBool('ImportCStuff','CheckBoxAllC', False);
     FormImportCStuff.EditImportH.Text := ReadString('ImportCStuff','EditImportH', '');
     FormImportCStuff.CheckBoxAllH.Checked := ReadBool('ImportCStuff','CheckBoxAllH', False);
     FormImportCStuff.EditLibName.Text := ReadString('ImportCStuff','EditLibName', '');
     FormImportCStuff.AndroidmkComboBox.ItemIndex := ReadInteger('ImportCStuff','AndroidmkComboBox', 0);
     FormImportCStuff.h2pasComboBox.ItemIndex := ReadInteger('ImportCStuff','h2pasComboBox', 0);
   finally
     Free;
   end;

  end;

end;

procedure TFormImportCStuff.SpeedButton3Click(Sender: TObject);
begin
   if SelectDirectoryDialog2.Execute then
  begin
    EditImportH.Text:= SelectDirectoryDialog2.FileName;
  end;
end;


end.

