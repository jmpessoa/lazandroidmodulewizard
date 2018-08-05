{Hint: save all files to location: C:\lamw\workspace\AppCompatAdMobDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sadmob;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jsAdMob1: jsAdMob;
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
//hint: [must!] using  "AppCompat"  theme!!!
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
 ShowMessage('wait... AdMob is Running...');
 jsAdMob1.SetAdMobId('ca-app-pub-3940256099942544/6300978111');  //warning: just test key!!!!
 jsAdMob1.Run();
end;

end.
