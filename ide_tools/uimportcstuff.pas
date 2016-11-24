unit uimportcstuff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls;

type

  { TFormImportCStuff }

  TFormImportCStuff = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBoxAllC: TCheckBox;
    CheckBoxAllH: TCheckBox;
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

procedure TFormImportCStuff.SpeedButton3Click(Sender: TObject);
begin
   if SelectDirectoryDialog2.Execute then
  begin
    EditImportH.Text:= SelectDirectoryDialog2.FileName;
  end;
end;


end.

