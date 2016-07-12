{Hint: save all files to location: C:\adt32\eclipse\workspace\AppPanelRotateDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, chronometer, downloadmanager,
  downloadservice, bluetooth;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jChronometer1: jChronometer;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jPanel4: jPanel;
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
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

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
begin

  case rotate of
     ssLandscape:
     begin

       jPanel3.LayoutParamWidth:= lpMatchParent;
       jPanel3.PosRelativeToParent:= [rpTop];

       jPanel4.LayoutParamWidth:= lpMatchParent;
       jPanel4.PosRelativeToAnchor:= [raBelow];

       jPanel1.LayoutParamHeight := lpMatchParent;
       jPanel1.LayoutParamWidth := lpThreeQuarterOfParent;
       jPanel1.PosRelativeToParent := [rpLeft];

       jPanel2.LayoutParamHeight := lpMatchParent;
       jPanel2.LayoutParamWidth := lpOneQuarterOfParent;
       jPanel2.PosRelativeToAnchor := [raToRightOf, raAlignBaseline];

     end;
     ssPortrait:
     begin

       jPanel3.LayoutParamWidth:= lpHalfOfParent;
       jPanel3.PosRelativeToParent:= [rpTop];

       jPanel4.LayoutParamWidth:= lpHalfOfParent;
       jPanel4.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];


       jPanel1.LayoutParamHeight := lpFourFifthOfParent;
       jPanel1.LayoutParamWidth := lpMatchParent;
       jPanel1.PosRelativeToParent := [rpTop];

       jPanel2.LayoutParamHeight := lpOneFifthOfParent;
       jPanel2.LayoutParamWidth := lpMatchParent;
       jPanel2.PosRelativeToAnchor := [raBelow];

     end;
  end;

  if rotate in [ssLandscape, ssPortrait] then
  begin

    jPanel1.ResetAllRules;
    jPanel2.ResetAllRules;
    jPanel3.ResetAllRules;
    jPanel4.ResetAllRules;

    Self.UpdateLayout;
  end;

end;

procedure TAndroidModule1.jPanel1FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin

end;

end.
