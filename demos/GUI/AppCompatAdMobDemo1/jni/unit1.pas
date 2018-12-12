{Hint: save all files to location: C:\lamw\workspace\AppCompatAdMobDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sadmob, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jsAdMob1: jsAdMob;
    jsAdMob2: jsAdMob;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject
      );
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

 jsAdMob1.AdMobSetId('ca-app-pub-3940256099942544/6300978111');  //warning: just test key!!!!
 jsAdMob1.AdMobRun();

 jsAdMob2.AdMobSetId('ca-app-pub-3940256099942544/6300978111');  //warning: just test key!!!!
 jsAdMob2.AdMobRun();
end;

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
 // AdMobInit should only be called once for the same id
 // This is the most time consuming when initializing AdMob
 // It is usually placed in the OnCreate event
 jsAdMob1.AdMobSetId('ca-app-pub-3940256099942544/6300978111');  //warning: just test key!!!!
 jsAdMob1.AdMobInit();
end;

end.
