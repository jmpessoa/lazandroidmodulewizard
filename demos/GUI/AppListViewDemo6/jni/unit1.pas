{Hint: save all files to location: C:\android\workspace\AppListViewDemo6\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,  unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
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
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if AndroidModule2 = nil then
  begin
     gApp.CreateForm(TAndroidModule2, AndroidModule2);
     AndroidModule2.InitShowing(gApp);
  end
  else
  begin
     AndroidModule2.Show(False);   // Assim, o evento nao será executado!
  end;
end;

end.
