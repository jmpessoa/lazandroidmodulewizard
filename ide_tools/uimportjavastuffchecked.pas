unit uimportjavastuffchecked;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type

  { TFormImportJavaStuffChecked }

  TFormImportJavaStuffChecked = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckGroupImport: TCheckGroup;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormImportJavaStuffChecked: TFormImportJavaStuffChecked;

implementation

{$R *.lfm}

{ TFormImportJavaStuffChecked }


procedure TFormImportJavaStuffChecked.FormCreate(Sender: TObject);
begin
   //
end;


end.

