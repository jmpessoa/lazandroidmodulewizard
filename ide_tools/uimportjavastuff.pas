unit uimportjavastuff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls;

type

  { TFormImportJavaStuff }

  TFormImportJavaStuff = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditImportJarLibs: TEdit;
    EditImportAssets: TEdit;
    EditImportLayout: TEdit;
    EditImportCode: TEdit;
    EditImportResource: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SelectDirectoryDialog2: TSelectDirectoryDialog;
    SelectDirectoryDialog3: TSelectDirectoryDialog;
    SelectDirectoryDialog4: TSelectDirectoryDialog;
    SelectDirectoryDialog5: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormImportJavaStuff: TFormImportJavaStuff;

implementation

{$R *.lfm}

{ TFormImportJavaStuff }

procedure TFormImportJavaStuff.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    EditImportCode.Text:= SelectDirectoryDialog1.FileName;
  end;
end;

procedure TFormImportJavaStuff.FormCreate(Sender: TObject);
begin
   //
end;

procedure TFormImportJavaStuff.SpeedButton2Click(Sender: TObject);
begin
  if SelectDirectoryDialog2.Execute then
  begin
    EditImportResource.Text:= SelectDirectoryDialog2.FileName;
  end;
end;

procedure TFormImportJavaStuff.SpeedButton3Click(Sender: TObject);
begin
   EditImportCode.Text:= '';
end;

procedure TFormImportJavaStuff.SpeedButton4Click(Sender: TObject);
begin
  EditImportResource.Text:='';
end;

procedure TFormImportJavaStuff.SpeedButton5Click(Sender: TObject);
begin
    if SelectDirectoryDialog3.Execute then
  begin
    EditImportLayout.Text:= SelectDirectoryDialog3.FileName;
  end;
end;

procedure TFormImportJavaStuff.SpeedButton6Click(Sender: TObject);
begin
  EditImportLayout.Text:='';
end;

procedure TFormImportJavaStuff.SpeedButton7Click(Sender: TObject);
begin
  if SelectDirectoryDialog4.Execute then
  begin
    EditImportAssets.Text:= SelectDirectoryDialog4.FileName;
  end;
end;

procedure TFormImportJavaStuff.SpeedButton8Click(Sender: TObject);
begin
    EditImportAssets.Text:= '';
end;

procedure TFormImportJavaStuff.SpeedButton9Click(Sender: TObject);
begin
    if SelectDirectoryDialog5.Execute then
  begin
    EditImportJarLibs.Text:= SelectDirectoryDialog5.FileName;
  end;
end;

end.

