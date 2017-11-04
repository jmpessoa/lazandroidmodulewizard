{Hint: save all files to location: /home/handoko/Projects/Project Software/Android Test/glTest1/jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, Laz_And_GLESv2_Canvas,
  Laz_And_GLESv2_Canvas_h;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jCanvasES2_1: jCanvasES2;
    jTimer1: jTimer;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jCanvasES2_1GLCreate(Sender: TObject);
    procedure jCanvasES2_1GLDown(Sender: TObject; Touch: TMouch);
    procedure jCanvasES2_1GLDraw(Sender: TObject);
    procedure jTimer1Timer(Sender: TObject);
  private
    ResHalfX, ResHalfY, ResHalfZ, ResScaleX, ResScaleY, ResScaleZ: Single;
    ColorFill, ColorBorder: TRGBA;
    procedure SetColorBorderRGBA(const R, G, B: single; const A: Single = 1);
    procedure SetColorFillRGBA(const R, G, B: single; const A: Single = 1);
    procedure DrawRectHV(const X, Y, sX, sY, W: Single; const Z: Single = 0);
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

const
  Total               = 100;
  ButtonClicked: Byte = 1;

var
  Xpos:   array[1..Total] of Single;
  Ypos:   array[1..Total] of Single;
  Xspeed: array[1..Total] of Single;
  Yspeed: array[1..Total] of Single;

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
const
  SizeX = 910;
  SizeY = 1358;
  SizeZ = 1000;
var
  i: Integer;
begin
  // Setup screen
  SetScreenOrientationStyle(ssPortrait);
  ResHalfX := SizeX * 0.5;
  ResHalfY := SizeY * 0.5;
  ResHalfZ := SizeZ * 0.5;
  ResScaleX := 1/ResHalfX;
  ResScaleY := 1/ResHalfY;
  ResScaleZ := 1/ResHalfZ;
  jCanvasES2_1.Screen_Setup(jCanvasES2_1.Width, jCanvasES2_1.Height, xp2D);
  SetColorBorderRGBA(0, 0, 0);
  // Setup rectangles
  for i := 1 to Total do begin
    Xpos[i] := Random(770)-385;
    Ypos[i] := Random(1000)-500;
    Xspeed[i] := Random(7)-3;
    Yspeed[i] := Random(7)-3;
    if (Xspeed[i] = 0) then Xspeed[i] := 1;
    if (Yspeed[i] = 0) then Yspeed[i] := 1;
    Xspeed[i] := 3;
  end;
  // Start timer
  jTimer1.Enabled := True;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ButtonClicked := 1;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  ButtonClicked := 2;
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  ButtonClicked := 3;
end;

procedure TAndroidModule1.jCanvasES2_1GLCreate(Sender: TObject);
begin
//  jCanvasES2_1.Texture_Load_All;
  jCanvasES2_1.Shader_Compile('simon_Vert', 'simon_Frag');
  jCanvasES2_1.Shader_Link;
end;

procedure TAndroidModule1.jCanvasES2_1GLDown(Sender: TObject; Touch: TMouch);
begin
  // Show touched X, Y
  ShowMessage(FormatFloat('0.00', Touch.Pt.X)+', '+FormatFloat('0.00', Touch.Pt.Y));
end;

procedure TAndroidModule1.jCanvasES2_1GLDraw(Sender: TObject);
const
  Z: Integer = -500;
var
  XYs: TXYs;
  i:   Integer;
begin
  glClear(GL_DEPTH_BUFFER_BIT);
  glEnable(GL_DEPTH_TEST);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  jCanvasES2_1.MVP:= cID4x4;
  jCanvasES2_1.SetMVP(jCanvasES2_1.MVP);

  XYs.Cnt := 4;
  XYs.Pt[0] := _XY(-1, -1);
  XYs.Pt[1] := _XY(-1,  1);
  XYs.Pt[2] := _XY( 1,  1);
  XYs.Pt[3] := _XY( 1, -1);
  jCanvasES2_1.DrawPolyFill(XYs, 0.9, _RGBA(0.5, 1, 0.8, 1), _RGBA(1, 0, 0, 1), 0.05);

  XYs.Pt[0] := _XY(-435*ResScaleX, -550*ResScaleY);
  XYs.Pt[1] := _XY(-435*ResScaleX,  550*ResScaleY);
  XYs.Pt[2] := _XY( 435*ResScaleX,  550*ResScaleY);
  XYs.Pt[3] := _XY( 435*ResScaleX, -550*ResScaleY);
  if (ButtonClicked = 2) then
    jCanvasES2_1.DrawPolyFill(XYs, 0.8, _RGBA(0.5, 0.2, 1, 1), _RGBA(1, 0, 0, 1), 0)
  else
    jCanvasES2_1.DrawPolyFill(XYs, 0.8, _RGBA(0, 0, 0, 1), _RGBA(1, 0, 0, 1), 0);

  Inc(Z);
  If (Z > 500) then Z := -500;
  SetColorFillRGBA(0, 1, 0);
  DrawRectHV(-100, Z, 200, 200, 30, Z);

  SetColorFillRGBA(1, 1, 0);
  for i := 1 to Total do begin
    Xpos[i] := Xpos[i] + Xspeed[i];
    Ypos[i] := Ypos[i] + Yspeed[i];
    if (Xpos[i] < -400) and (Xspeed[i] <= 0) then Xspeed[i] := 3;
    if (Xpos[i] >  370) and (Xspeed[i] >= 0) then Xspeed[i] := -3;
    if (Ypos[i] < -600) and (Yspeed[i] <= 0) then Yspeed[i] := Random(3)+1;
    if (Ypos[i] >  550) and (Yspeed[i] >= 0) then Yspeed[i] := Random(3)-4;
    case ButtonClicked of
      1: begin
           SetColorFillRGBA(1, 1, 0);
           DrawRectHV(Xpos[i], Ypos[i], 50, 50, 5, 50);
         end;
      2: begin
           SetColorFillRGBA(0, 0, 0);
           DrawRectHV(Xpos[i], Ypos[i], 50, 50, 5, 50);
         end;
      3: begin
          SetColorFillRGBA(0, 0, 1);
          DrawRectHV(Xpos[i], Ypos[i], 50, 50, 5, -100);
          end;
    end;
  end;
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  jCanvasES2_1.Refresh;
end;

procedure TAndroidModule1.SetColorBorderRGBA(const R, G, B: single;
  const A: Single);
begin
  ColorBorder.R := R;
  ColorBorder.G := G;
  ColorBorder.B := B;
  ColorBorder.A := A;
end;

procedure TAndroidModule1.SetColorFillRGBA(const R, G, B: single;
  const A: Single);
begin
  ColorFill.R := R;
  ColorFill.G := G;
  ColorFill.B := B;
  ColorFill.A := A;
end;

procedure TAndroidModule1.DrawRectHV(const X, Y, sX, sY, W: Single;
  const Z: Single);
var
  X1, Y1, X2, Y2, W2: Single;
  X1small, Y1small, X2small, Y2small, X1big, Y1big, X2big, Y2big: Single;
  XYs: TXYs;
begin
  // Make sure (X1, Y1) is the bottom leftmost, to produce clockwise winding
  if (sX >= 0) and (sY >= 0) then begin
    X1 := X;
    Y1 := Y;
    X2 := X+sX;
    Y2 := Y+sY;
  end else
    if (sX < 0) and (sY >= 0) then begin
      X1 := X+sX;
      Y1 := Y;
      X2 := X;
      Y2 := Y+sY;
    end else
      if (sX < 0) and (sY < 0) then begin
        X1 := X+sX;
        Y1 := Y+sY;
        X2 := X;
        Y2 := Y;
      end else
        if (sX >= 0) and (sY < 0) then begin
          X1 := X;
          Y1 := Y+sY;
          X2 := X+sX;
          Y2 := Y;
        end;
  // Map the points
  W2 := W * 0.5;
  X1small := (X1-W2) * ResScaleX;
  Y1small := (Y1-W2) * ResScaleY;
  X2small := (X2-W2) * ResScaleX;
  Y2small := (Y2-W2) * ResScaleY;
  X1big := (X1+W2) * ResScaleX;
  Y1big := (Y1+W2) * ResScaleY;
  X2big := (X2+W2) * ResScaleX;
  Y2big := (Y2+W2) * ResScaleY;
  XYs.Cnt := 10;
  XYs.Pt[0].X := X1big;   XYs.Pt[0].Y := Y1big;
  XYs.Pt[1].X := X2small; XYs.Pt[1].Y := Y1big;
  XYs.Pt[2].X := X2small; XYs.Pt[2].Y := Y2small;
  XYs.Pt[3].X := X2big;   XYs.Pt[3].Y := Y2big;
  XYs.Pt[4].X := X2big;   XYs.Pt[4].Y := Y1small;
  XYs.Pt[5].X := X1small; XYs.Pt[5].Y := Y1small;
  XYs.Pt[6].X := X1small; XYs.Pt[6].Y := Y2big;
  XYs.Pt[7].X := X2big;   XYs.Pt[7].Y := Y2big;
  XYs.Pt[8].X := X2small; XYs.Pt[8].Y := Y2small;
  XYs.Pt[9].X := X1big;   XYs.Pt[9].Y := Y2small;
  // Draw it
  jCanvasES2_1.DrawPolyFill(XYs, Z*ResScaleZ, ColorFill, ColorBorder, 0);
end;

end.
