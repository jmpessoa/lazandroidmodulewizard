{hint: Pascal files location: ...\AppLinearLayoutDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, linearlayout;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jButton5: jButton;
    jButton6: jButton;
    jLinearLayout1: jLinearLayout;
    jLinearLayout2: jLinearLayout;
    jTextView1: jTextView;
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

//http://sandipchitale.blogspot.com/2010/05/linearlayout-gravity-and-layoutgravity.html

//https://medium.com/@nuwan.c.fernando/understanding-the-behavior-of-android-linear-layout-and-its-major-attributes-e785e757c7ad

end.
