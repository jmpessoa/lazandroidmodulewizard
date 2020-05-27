{Hint: save all files to location: C:\lamw\workspace\AppCompatAdMobDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sadmob, And_jni,
  scardview, stoolbar, snavigationview, sdrawerlayout, snestedscrollview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jsAdMob1: jsAdMob;
    jsAdMob2: jsAdMob;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject
      );
    procedure AndroidModule1ActivityPause(Sender: TObject);
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1ActivityResume(Sender: TObject);
    procedure AndroidModule1BackButton(Sender: TObject);
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1Destroy(Sender: TObject);
    procedure AndroidModule1PrepareOptionsMenu(Sender: TObject;
      jObjMenu: jObject; menuSize: integer; out prepareItems: boolean);
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure AndroidModule1Show(Sender: TObject);
    procedure AndroidModule1SpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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

 jsAdMob1.AdMobRun();
 jsAdMob2.AdMobRun();
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jsAdMob2.AdMobStop();
end;

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
 // AdMobInit should only be called once for the same id
 // This is the most time consuming when initializing AdMob
 // It is usually placed in the OnCreate event
 jsAdMob1.AdMobSetId('ca-app-pub-3940256099942544/6300978111');  //warning: just test key!!!!
 jsAdMob2.AdMobSetId('ca-app-pub-3940256099942544/6300978111');

 jsAdMob1.AdMobInit();
end;

procedure TAndroidModule1.AndroidModule1ActivityPause(Sender: TObject);
begin
  showmessage('pause');
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  showmessage('result');
end;

procedure TAndroidModule1.AndroidModule1ActivityResume(Sender: TObject);
begin

  showmessage('resume ' + intToStr(gapp.Screen.WH.width) + 'x' + intToStr(gapp.Screen.WH.height));

end;

procedure TAndroidModule1.AndroidModule1BackButton(Sender: TObject);
begin
  showmessage('back');
end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  showmessage('close');
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin

end;

procedure TAndroidModule1.AndroidModule1Destroy(Sender: TObject);
begin
  showmessage('destroy');
end;

procedure TAndroidModule1.AndroidModule1PrepareOptionsMenu(Sender: TObject;
  jObjMenu: jObject; menuSize: integer; out prepareItems: boolean);
begin
  showmessage('prepare');
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
  showmessage('rotate');
  updateLayout;
  jsAdMob1.AdMobUpdate();
  jsAdMob2.AdMobUpdate();
end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  showmessage('show');
end;

procedure TAndroidModule1.AndroidModule1SpecialKeyDown(Sender: TObject;
  keyChar: char; keyCode: integer; keyCodeString: string; var mute: boolean);
begin
  showmessage('keydown');
end;

end.
