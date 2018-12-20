unit unitformimportpicture;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls, ExtCtrls;

type

  { TFormImportPicture }

  TFormImportPicture = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckGroupTarget: TCheckGroup;
    Edit1: TEdit;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private

  public
    PictureFile: string;
  end;

var
  FormImportPicture: TFormImportPicture;

implementation

{$R *.lfm}

{ TFormImportPicture }

procedure TFormImportPicture.SpeedButton1Click(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
      PictureFile:=  OpenDialog1.FileName;
      Edit1.Text:= PictureFile;
    end;
end;

procedure TFormImportPicture.FormActivate(Sender: TObject);
begin
  Self.CheckGroupTarget.Checked[1]:= True;
end;

end.

