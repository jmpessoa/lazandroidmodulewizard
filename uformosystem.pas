unit uFormOSystem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ButtonPanel, inifiles, LazIDEIntf;

type

  { TFormOSystem }

  TFormOSystem = class(TForm)
    ButtonPanel1: TButtonPanel;
    RadioGroup1: TRadioGroup;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    PrebuildOSYS: string;
    function GetIndex(prebuildSys: string): integer;
  end;

var
  FormOSystem: TFormOSystem;

implementation

{$R *.lfm}

{ TFormOSystem }

function TFormOSystem.GetIndex(prebuildSys: string): integer;
begin
   if Pos('windows', prebuildSys) > 0 then Result:= 0
   else if Pos('_64', prebuildSys) > 0 then Result:= 3
   else if Pos('linux-x86', prebuildSys) > 0 then Result:= 1
   else if Pos('osx', prebuildSys) > 0 then Result:= 2;
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
  { workaround for underline bug in GTK+ }
  {$ifdef LCLGTK2}
  RadioGroup1.Items[3] := StringReplace(RadioGroup1.Items[3], '_', '__', []);
  {$endif}
  fileName:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExistsUTF8(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      PrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if PrebuildOSYS <> '' then
        RadioGroup1.ItemIndex:= GetIndex(PrebuildOSYS)
      else
      {$ifdef windows}
        RadioGroup1.ItemIndex:= 0;
      {$else}
        {$ifdef darvin}
        RadioGroup1.ItemIndex:= 2;
        {$else}
          {$ifdef cpu64}
        RadioGroup1.ItemIndex:= 3;
          {$else}
        RadioGroup1.ItemIndex:= 1;
          {$endif}
        {$endif}
      {$endif}
    finally
      Free;
    end;
  end;
end;

end.

