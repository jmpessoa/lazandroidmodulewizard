{Hint: save all files to location: C:\adt32\eclipse\workspace\LamwConsoleAppDemo1}
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type

  { TAndroidConsoleDataForm1 }

  TAndroidConsoleDataForm1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidConsoleDataForm1: TAndroidConsoleDataForm1;

implementation

{$R *.lfm}
  

{ TAndroidConsoleDataForm1 }

procedure TAndroidConsoleDataForm1.DataModuleCreate(Sender: TObject);
begin
  writeln('Hello Lamw''s World!');
end;

procedure TAndroidConsoleDataForm1.DataModuleDestroy(Sender: TObject);
begin

end;

end.
