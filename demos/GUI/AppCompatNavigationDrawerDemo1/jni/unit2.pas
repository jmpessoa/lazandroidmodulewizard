{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jEditText1: jEditText;
    jEditText2: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule2JNIPrompt(Sender: TObject);
    procedure AndroidModule2Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure jImageView1Click(Sender: TObject);

  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

{ TAndroidModule2 }

procedure TAndroidModule2.jImageView1Click(Sender: TObject);
begin
  ShowMessage('Scene 2');
end;

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
  if Self.GetScreenOrientationStyle =  ssLandscape then
  begin
     Self.jEditText1.LayoutParamWidth:= lpOneThirdOfParent;
     Self.jEditText2.LayoutParamWidth:= lpTwoThirdOfParent;
     Self.UpdateLayout;
  end
end;

procedure TAndroidModule2.AndroidModule2Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
     if rotate =  ssLandscape then
     begin
        Self.jEditText1.LayoutParamWidth:= lpOneThirdOfParent;
        Self.jEditText2.LayoutParamWidth:= lpTwoThirdOfParent;
     end
     else
     begin
       Self.jEditText1.LayoutParamWidth:= lpHalfOfParent;
       Self.jEditText2.LayoutParamWidth:= lpHalfOfParent;
     end;
     Self.UpdateLayout;
end;

end.
