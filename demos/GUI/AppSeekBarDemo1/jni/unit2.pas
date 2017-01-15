{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation

uses Unit4;


{$R *.lfm}

{ TAndroidModule2 }

procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
   if AndroidModule4 = nil then begin
     gApp.CreateForm(TAndroidModule4, AndroidModule4);
     AndroidModule4.Init(gApp);
   end
   else
   begin
     AndroidModule4.Show;
   end;
end;

end.

