unit FormPathMissing;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ButtonPanel;

type

  { TFormPathMissing }

  TFormPathMissing = class(TForm)
    ButtonPanel1: TButtonPanel;
    EditPath: TEdit;
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
  PathMissing:= EditPath.Text;
end;

procedure TFormPathMissing.SpeedButton1Click(Sender: TObject);
begin
  SelectDirectoryDialog1.Title:= '[Android Wizard] Path Missing:';
  if SelectDirectoryDialog1.Execute then
  begin
    EditPath.Text := SelectDirectoryDialog1.FileName;
    PathMissing:= EditPath.Text;
  end;
end;

end.

