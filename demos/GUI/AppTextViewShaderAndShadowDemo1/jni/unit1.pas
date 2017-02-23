{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppTextViewShaderAndShadowDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jTextView1Layouting(Obj: TObject; changed: boolean);
    procedure jTextView2Layouting(Obj: TObject; changed: boolean);
    procedure jTextView3Layouting(Obj: TObject; changed: boolean);
    procedure jTextView4Layouting(Obj: TObject; changed: boolean);
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

(*//https://blog.stylingandroid.com/text-shadows/

SetShadowLayer(_radius: single; _dx: single; _dy: single; _color: TARGBColorBridge);

radius –
  specifies how much the shadow should be blurred at the edges.
  Provide a small value if shadow needs to be prominent.

dx –
  specifies the X-axis offset of shadow. You can give -/+ values,
  where -dx draws a shadow on the left of text and +Dx on the right

dy –
  it specifies the Y-axis offset of shadow.
  -dy specifies a shadow above the text and +Dy specifies below the text.

color –
  specifies the shadow color
*)

//https://blog.stylingandroid.com/text-shadows/
(*
Glowing Text
SetShadowLayer(3, 0, 0, colbrLightGrey);

Outline Glow Text
SetShadowLayer(2, 0, 0, colbrYellow);

Soft Shadow Text
SetShadowLayer(1.5, 3, 3, colbrLightGrey);

Soft Shadow Text (below)
SetShadowLayer(1.5, 3, -3, colbrLightGrey);

Engraved Shadow Text
SetShadowLayer(0.6, 1, 1, colbrYellow);  //
*)

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jTextView1.SetCompoundDrawables('ic_info', cdsRight);
end;

procedure TAndroidModule1.jTextView1Layouting(Obj: TObject; changed: boolean);
begin
    if changed then
       jTextView1.SetShadowLayer(1.5, 3, 3, colbrLimeGreen);
end;

procedure TAndroidModule1.jTextView2Layouting(Obj: TObject; changed: boolean);
begin
    if changed then
      jTextView2.SetShaderLinearGradient(colbrRed, colbrGreen);
end;

procedure TAndroidModule1.jTextView3Layouting(Obj: TObject; changed: boolean);
begin
    if changed then
       jTextView3.SetShaderRadialGradient(colbrBlue, colbrGreen);
end;

procedure TAndroidModule1.jTextView4Layouting(Obj: TObject; changed: boolean);
begin
    if changed then
      jTextView4.SetShaderSweepGradient(colbrBlue, colbrGreen);
end;

end.
