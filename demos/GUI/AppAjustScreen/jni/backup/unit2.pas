{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jButton1: jButton;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jPanel4: jPanel;
    jPanel5: jPanel;
    procedure AndroidModule2Rotate(Sender: TObject; rotate: TScreenStyle);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

{ TAndroidModule2 }

procedure TAndroidModule2.AndroidModule2Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
  updateLayout;
end;

end.
