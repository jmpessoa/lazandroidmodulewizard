unit uRegisterForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormRegister }

  TFormRegister = class(TForm)
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
  FormRegister: TFormRegister;

implementation

{$R *.lfm}

{ TFormRegister }

procedure TFormRegister.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text:= OpenDialog1.FileName;
  end;
end;

procedure TFormRegister.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog2.Execute then
  begin
    Edit2.Text:= OpenDialog2.FileName;
  end;
end;

procedure TFormRegister.SpeedButton3Click(Sender: TObject);
begin
   Edit1.Text:= '';
end;

procedure TFormRegister.SpeedButton4Click(Sender: TObject);
begin
  Edit2.Text:='';
end;

end.

