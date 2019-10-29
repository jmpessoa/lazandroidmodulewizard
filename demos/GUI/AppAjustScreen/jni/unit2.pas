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
    procedure jButton1Click(Sender: TObject);
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
  showmessage('Form2, rotate o change size!' + #13#10 +
              'Screen size: ' + intToStr(self.GetWidth) + 'x' + intTostr(self.GetHeight));
  updateLayout;
end;

procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
  close;
end;

end.
