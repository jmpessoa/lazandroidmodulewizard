unit uregistercompform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormRegisterComp }

  TFormRegisterComp = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormRegisterComp: TFormRegisterComp;

implementation

{$R *.lfm}

{ TFormRegisterComp }

procedure TFormRegisterComp.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text:= OpenDialog1.FileName;
  end;
end;

procedure TFormRegisterComp.FormCreate(Sender: TObject);
begin
   //
end;

procedure TFormRegisterComp.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog2.Execute then
  begin
    Edit2.Text:= OpenDialog2.FileName;
  end;
end;

procedure TFormRegisterComp.SpeedButton3Click(Sender: TObject);
begin
   Edit1.Text:= '';
end;

procedure TFormRegisterComp.SpeedButton4Click(Sender: TObject);
begin
  Edit2.Text:='';
end;

end.

