unit FormPathMissing;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormPathMissing }

  TFormPathMissing = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    LabelPathTo: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }

  public
    PathMissing: string;
    { public declarations }
  end;

var
  FrmPathMissing: TFormPathMissing;

implementation

{$R *.lfm}

{ TFormPathMissing }

procedure TFormPathMissing.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  PathMissing:= Edit1.Text;
end;

procedure TFormPathMissing.SpeedButton1Click(Sender: TObject);
begin
  SelectDirectoryDialog1.Title:= 'WARNING! Missing Path!';
  if SelectDirectoryDialog1.Execute then
  begin
    Edit1.Text := SelectDirectoryDialog1.FileName;
    PathMissing:= Edit1.Text;
  end;
end;

end.

