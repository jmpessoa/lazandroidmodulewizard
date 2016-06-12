unit uFormOSystem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
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
   if Pos('windows-x86_64', prebuildSys) > 0 then     //windows-x86_64
   begin
       Result:= 1;
       Exit;
   end;
   if Pos('windows', prebuildSys) > 0 then
   begin
      Result:= 0;
      Exit;
   end;
   if Pos('linux-x86_64', prebuildSys) > 0 then
   begin
      Result:= 3;
      Exit;
   end;
   if Pos('linux-x86', prebuildSys) > 0 then
   begin
      Result:= 2;
      Exit;
   end;
   if Pos('osx', prebuildSys) > 0 then
   begin
      Result:= 4;
      Exit;
   end;
end;

procedure TFormOSystem.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   case RadioGroup1.ItemIndex of
     0: PrebuildOSYS:= 'windows';
     1: PrebuildOSYS:= 'windows-x86_64';
     2: PrebuildOSYS:= 'linux-x86';
     3: PrebuildOSYS:= 'linux-x86_64';
     4: PrebuildOSYS:= 'osx';
   end;
end;

procedure TFormOSystem.FormCreate(Sender: TObject);
var
  fileName: string;
begin
  { workaround for underline bug in GTK+ }
  {$ifdef LCLGTK2}
  RadioGroup1.Items[1] := StringReplace(RadioGroup1.Items[1], '_', '__', []);
  RadioGroup1.Items[3] := StringReplace(RadioGroup1.Items[3], '_', '__', []);
  {$endif}
  fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      PrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      if PrebuildOSYS <> '' then
        RadioGroup1.ItemIndex:= GetIndex(PrebuildOSYS)
      else
      {$ifdef windows}
        {$ifdef win32}
        RadioGroup1.ItemIndex:= 0;
        {$endif}
        {$ifdef win64}
        RadioGroup1.ItemIndex:= 1;
        {$endif}
      {$else}
        {$ifdef darvin}
        RadioGroup1.ItemIndex:= 4;
        {$else}
          {$ifdef cpu64}
        RadioGroup1.ItemIndex:= 3;
          {$else}
        RadioGroup1.ItemIndex:= 2;
          {$endif}
        {$endif}
      {$endif}
    finally
      Free;
    end;
  end;
end;

end.

