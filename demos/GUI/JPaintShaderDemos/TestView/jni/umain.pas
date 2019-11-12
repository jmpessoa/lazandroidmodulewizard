{Hint: save all files to location: J:\!work\FPC\TestView\jni }
unit uMain;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, paintshader, And_jni,
  sensormanager;
  
type

  { TAndroidModule1 }
  TVec3f = record
    X: Single;
    Y: Single;
    Z: Single;
  public
    constructor Create(aX, aY, aZ: Single);
  end;

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jCanvas1: jCanvas;
    jPaintShader1: jPaintShader;
    jSensorManager1: jSensorManager;
    jView1: jView;
    procedure AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1Show(Sender: TObject);
    procedure jSensorManager1Changed(Sender: TObject; sensor: jObject;
      sensorType: TSensorType; values: array of single; timestamp: int64);
    procedure jView1Draw(Sender: TObject);
  private
    Screen: TWH;
    axes: TVec3f;
    half: TPoint;
    rad: Integer;
    bg, surf, sh1, sh2, sh3, planet: SmallInt;
    pulsar: Single;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

function Clamp(x, Min, Max: Single): Single;
begin
  if x < min then
    Result := min
  else
    if x > max then
      Result := max
    else
      Result := x;
end;

function RandF(Min, Max: Single): Single;
var
  Float: Single;
begin
  Float := Random;
  Result := Min + float * (Max - Min);
end;

constructor TVec3f.Create(aX, aY, aZ: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
end;

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  // disable hardware acceleration for the `JPaintShader.Combine` method to work correctly !
  jView1.SetLayerType(ltSOFTWARE); // need VERSION.SDK_INT >= 11

  // the default number of shaders is 6, if this is not enough, set property `CountShader` or use method `JPaintShader.SetCount`
  // jView1.Canvas.PaintShader.SetCount(..)

  // set manually ID
  sh3 := 3;
  surf := 4;
  planet := 5;

  jBitmap1.ImageIdentifier := 'sky2';
  // background
  bg := jView1.Canvas.PaintShader.NewBitmapShader(jBitmap1.GetImage, tmREPEAT, tmREPEAT, 1.2, 1.2, 45);
  // planet surface
  sh1 := jView1.Canvas.PaintShader.NewSweepGradient(120, 50, [$FFFF0707, $FFFF6A07, {$FFFFD507, $FFB8FF07, $FF51FF07,} $FF07FF24, $FF07FF8F,
                                                             $FF07FFFF, $FF0797FF, $FF072CFF, $FF4907FF, $FFB007FF, $FFFF07DE{, $FFFF0772}], []);
  jBitmap1.ImageIdentifier := 'surf';
  sh2 := jView1.Canvas.PaintShader.NewBitmapShader(jBitmap1.GetImage, tmREPEAT, tmREPEAT);
  jView1.Canvas.PaintShader.Combine(sh2, sh1, PorterDuff.OVERLAY, surf);

  if jSensorManager1.SensorExists(stAccelerometer) then
    jSensorManager1.RegisterListeningSensor(stAccelerometer);
end;

procedure TAndroidModule1.AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean);
begin
  jSensorManager1.StopListeningAll(); //finalize jni process here ....
  CanClose := True;
end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  Screen := Self.ScreenWH;
  half.X := Screen.Width div 2;
  half.Y := Screen.Height div 2;
  rad := half.X div 2;
end;

procedure TAndroidModule1.jSensorManager1Changed(Sender: TObject;
  sensor: jObject; sensorType: TSensorType; values: array of single;
  timestamp: int64);
begin
  case sensorType of
    stAccelerometer: begin
      axes.X := values[0] * -20;
      axes.Y := values[1] * 5.5;
      axes.Z := values[0] * 2.3; // ufo angle
      pulsar := RandF(0, 2.5);

      jView1.Refresh(); // repaint scene
    end;
  end;
end;

procedure TAndroidModule1.jView1Draw(Sender: TObject);
begin
  jView1.Canvas.Clear($FFFFFFFF);
  jView1.Canvas.PaintStyle := psDEFAULT;
  jView1.Canvas.PaintStrokeWidth := 22;
  // draw space
  jView1.Canvas.PaintShader.Bind(bg);
  jView1.Canvas.DrawRect(0, 0, Screen.Width, Screen.Height);
  jView1.Canvas.DrawText('Star Space!', 100, 100);
  // axes
  jView1.Canvas.DrawText('Axes: ' + Format('x: %f, y: %f, ang: %f', [axes.X, axes.Y, axes.Z]), 100, 150);
  //jView1.Canvas.DrawText('Pulsar: ' + FloatToStr(Pulsar), 100, 200);

  jView1.Canvas.PaintShader.SetIdentity(surf);
  // big planet
  // atmosphere & fog
  jView1.Canvas.PaintShader.NewRadialGradient(half.X + 80, half.Y div 2, rad + 100, $CC000000, $FFFFFFFF, tmCLAMP, sh3);
  jView1.Canvas.PaintShader.Combine(surf, sh3, PorterDuff.ADD, planet);
  // draw planet
  jView1.Canvas.PaintShader.Bind(planet);
  jView1.Canvas.DrawCircle(half.X + 100, half.Y div 2, rad + Clamp(pulsar, 0, 0.55));

  // small planet
  // blur
  jView1.Canvas.PaintStyle := psSTROKE;
  jView1.Canvas.PaintShader.NewRadialGradient(half.X - 95, Screen.Height - (half.Y div 2) - 5, rad, $CC0000CC, $30FFCFCF, tmCLAMP, sh3);
  jView1.Canvas.PaintShader.Bind(sh3);
  jView1.Canvas.DrawCircle(half.X - 95, Screen.Height - (half.Y div 2) - 5, rad - 47 - pulsar);
  jView1.Canvas.PaintStyle := psDEFAULT;
  // atmosphere
  jView1.Canvas.PaintShader.SetScale(0.5, 0.45, surf);
  jView1.Canvas.PaintShader.SetRotate(-37, half.X - 100, Screen.Height - (half.Y div 2), surf);
  jView1.Canvas.PaintShader.NewRadialGradient(half.X - 120 - pulsar, Screen.Height - (half.Y div 2) - pulsar, rad + 30, $CC0000CC, $FFCCFFCF, tmCLAMP, sh3);
  jView1.Canvas.PaintShader.Combine(surf, sh3, PorterDuff.MULTIPLY, planet);
  // draw planet
  jView1.Canvas.PaintShader.Bind(planet);
  jView1.Canvas.DrawCircle(half.X - 100, Screen.Height - (half.Y div 2), rad - 50 - Clamp(pulsar, 0, 0.55));

  // draw ufo
  jBitmap1.ImageIdentifier := 'ufo';
  jView1.Canvas.DrawFrame(jBitmap1.GetImage, 0, 0, jBitmap1.Width, jBitmap1.Height, half.X - (jBitmap1.Width div 2) - axes.X, half.Y - 70 - axes.Y, jBitmap1.Width, jBitmap1.Height, axes.Z);
end;


end.
