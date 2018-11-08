unit uformimportlamwstuff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormImportLAMWStuff }

  TFormImportLAMWStuff = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditSource: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ListBoxTarget: TListBox;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    //
  public

  end;

var
  FormImportLAMWStuff: TFormImportLAMWStuff;

implementation

{$R *.lfm}

{ TFormImportLAMWStuff }

procedure TFormImportLAMWStuff.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    EditSource.Text:= OpenDialog1.FileName;
  end;
end;


end.

