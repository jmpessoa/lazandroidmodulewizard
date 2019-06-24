unit unit4;
//

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule4 }

  TAndroidModule4 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jEditText4: jEditText;
    jEditText5: jEditText;
    jEditText6: jEditText;
    jEditText7: jEditText;
    jListView1: jListView;
    jPanel1: jPanel;
    jScrollView1: jScrollView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    jTextView6: jTextView;
    jTextView7: jTextView;
    procedure AndroidModule4JNIPrompt(Sender: TObject);
    procedure AndroidModule4Rotate(Sender: TObject; rotate: TScreenStyle);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule4: TAndroidModule4;

implementation
  
{$R *.lfm}
  

{ TAndroidModule4 }

procedure TAndroidModule4.AndroidModule4JNIPrompt(Sender: TObject);
begin
   if Self.GetScreenOrientationStyle =  ssLandscape then
   begin
     Self.jScrollView1.LayoutParamHeight:= lpTwoFifthOfParent;
     Self.jListView1.LayoutParamHeight:= lpOneFifthOfParent;
     Self.UpdateLayout;
   end
end;

procedure TAndroidModule4.AndroidModule4Rotate(Sender: TObject; rotate: TScreenStyle);
begin
   if rotate =  ssLandscape then
   begin
     Self.jScrollView1.LayoutParamHeight:= lpTwoFifthOfParent;
     Self.jListView1.LayoutParamHeight:= lpOneFifthOfParent;
   end
   else
   begin
     Self.jScrollView1.LayoutParamHeight:= lpHalfOfParent;
     Self.jListView1.LayoutParamHeight:= lpOneQuarterOfParent
   end;
   Self.UpdateLayout;
end;


end.
