unit uFormOSystem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, inifiles, LazIDEIntf;

type

  { TFormOSystem }

  TFormOSystem = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    PrebuildOSYS: string;
    function GetIndex(PrebuildOSYS: string): integer;
  end;

var
  FormOSystem: TFormOSystem;

implementation

{$R *.lfm}

{ TFormOSystem }

function TFormOSystem.GetIndex(PrebuildOSYS: string): integer;
begin
   if Pos('windows', PrebuildOSYS) > 0 then Result:= 0
   else if Pos('_64', PrebuildOSYS) > 0 then Result:= 3
   else if Pos('linux-x86', PrebuildOSYS) > 0 then Result:= 1
   else if Pos('osx', PrebuildOSYS) > 0 then Result:= 2;
end;

procedure TFormOSystem.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   case RadioGroup1.ItemIndex of
     0: PrebuildOSYS:= 'windows';
     1: PrebuildOSYS:= 'linux-x86';
     2: PrebuildOSYS:= 'osx';   //TODO: fix here!
     3: PrebuildOSYS:= 'linux-x86_64';
   end;
end;

procedure TFormOSystem.FormCreate(Sender: TObject);
var
  fileName: string;
begin
  fileName:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      PrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if  PrebuildOSYS = '' then
         RadioGroup1.ItemIndex:= GetIndex(PrebuildOSYS)
      else RadioGroup1.ItemIndex:= 0;
    finally
      Free;
    end;
end;

end.

