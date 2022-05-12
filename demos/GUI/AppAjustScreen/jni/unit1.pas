{Hint: save all files to location: C:\Temp\AppAjustScreen\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jPanel4: jPanel;
    jPanel5: jPanel;
    jTextView1: jTextView;
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
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

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
  showmessage('Form1, rotate o change size!' + #13#10 +
              'Screen size: ' + intToStr(self.GetWidth) + 'x' + intTostr(self.GetHeight));
  updateLayout;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if AndroidModule2 = nil then
  begin
    gapp.CreateForm(TAndroidModule2, AndroidModule2);
    AndroidModule2.Init;
  end;

  AndroidModule2.Show;
end;

end.
