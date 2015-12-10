{Hint: save all files to location: C:\adt32\eclipse\workspace\AppPascalLibExceptionHandlerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  i: integer;
begin
  try
    // some erroneous code
    i:= StrToInt('p');
  except
    on E: Exception do ShowMessage(Self.DumpExceptionCallStack(E));  //Thanks to Euller and Oswaldo!
  end;
end;


end.
