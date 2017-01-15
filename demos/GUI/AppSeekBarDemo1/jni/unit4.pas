{Hint: save all files to location: \jni }
unit unit4;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule4 }

  TAndroidModule4 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule4: TAndroidModule4;

implementation

uses Unit5;

{$R *.lfm}

{ TAndroidModule4 }

procedure TAndroidModule4.jButton1Click(Sender: TObject);
begin
   if AndroidModule5 = nil then begin
     gApp.CreateForm(TAndroidModule5, AndroidModule5);
     AndroidModule5.Init(gApp);
   end
   else
   begin
     AndroidModule5.Show;
   end;
end;

end.

