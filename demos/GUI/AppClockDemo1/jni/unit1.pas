{Hint: save all files to location: C:\adt32\eclipse\workspace\AppClockDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, analogclock, digitalclock;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jAnalogClock1: jAnalogClock;
    jDigitalClock1: jDigitalClock;
    jTextView1: jTextView;

  private
    {private declarations}
  public
    {public declarations}
    //procedure CustomExceptionHandler(Sender: TObject; E: Exception);
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }

end.
