{Hint: save all files to location: J:\!work\FPC\TestDrawingView\jni }
unit uMain;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, drawingview, paintshader, Laz_And_Controls, Math;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jDrawingView1: jDrawingView;
    jPaintShader1: jPaintShader;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jDrawingView1Draw(Sender: TObject; countXY: integer;
      X: array of single; Y: array of single; flingGesture: TFlingGesture;
      pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
    procedure jDrawingView1SizeChanged(Sender: TObject; width: integer;
      height: integer; oldWidth: integer; oldHeight: integer);
  private
    wh, ht: Integer;
    bg: Integer;
    procedure DrawRect(x, y, w, h: Single);
    procedure DrawStar(x, y, w, h: Integer);
  public

  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.DrawRect(x, y, w, h: Single);
begin
  jDrawingView1.DrawRect(x, y, x + w, y + h);
end;

procedure TAndroidModule1.DrawStar(x, y, w, h: Integer);
var
  mid : Single;
  min : Single;
  fat : Single;
  half: Single;
  rad : Single;
begin
  mid := w / 2;
  min := Math.Min(w, h);
  fat := min / 17;
  half := min / 2;
  rad := half - fat;
  mid := mid - half;

  jDrawingView1.SetPaintStrokeWidth(fat);
  jDrawingView1.SetPaintStyle(psSTROKE);

  jDrawingView1.PaintShader.SetZeroCoords(0);
  jDrawingView1.PaintShader.SetTranslate(x + mid + half, y + half, 0);
  //jDrawingView1.PaintShader.SetIdentity(0);
  jDrawingView1.PaintShader.Bind(0);
  jDrawingView1.DrawCircle(x + mid + half, y + half, rad);


  jDrawingView1.SetPaintStyle(psFILL);
  //jDrawingView1.PaintShader.Bind(2);
  jDrawingView1.DrawPath([x + mid + half * 0.5 , y + half * 0.84,   // top left
                          x + mid + half * 1.5 , y + half * 0.84,   // top right
                          x + mid + half * 0.68, y + half * 1.45,   // bottom left
                          x + mid + half * 1.0 , y + half * 0.5,    // top tip
                          x + mid + half * 1.32, y + half * 1.45,   // bottom right
                          x + mid + half * 0.5 , y + half * 0.84]); // top left
end;

procedure TAndroidModule1.jDrawingView1Draw(Sender: TObject; countXY: integer;
  X: array of single; Y: array of single; flingGesture: TFlingGesture;
  pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
var
  i: Integer;
begin
  jDrawingView1.Clear;
  jDrawingView1.SetPaintStyle(psDEFAULT);
// draw background
  jDrawingView1.PaintShader.Bind(bg);
  DrawRect(0, 0, wh, ht);

  jDrawingView1.DrawText(IntToStr(jDrawingView1.PaintShader.GetColor), 100, 100); // get paint color, debug function

// create dynamic shaders, need to set ID manually !! ATTENTION: ID parameter must be set > -1 !!
// sweep gradient
  jDrawingView1.PaintShader.NewSweepGradient(300, 300, [$FFFF0707, $FFFF6A07, $FFFFD507, $FFB8FF07, $FF51FF07, $FF07FF24, $FF07FF8F,
                                                        $FF07FFFF, $FF0797FF, $FF072CFF, $FF4907FF, $FFB007FF, $FFFF07DE, $FFFF0772], [], 0);
  jDrawingView1.PaintShader.Bind(0); // apply shader with id 0
  jDrawingView1.DrawCircle(300, 300, 175);

  jDrawingView1.PaintShader.NewRadialGradient(300, 300, 175, $CC000000, $FFFFFFFF, tmCLAMP, 1);
  // combine shaders 0 & 1 with OVERLAY mode, result shader 2
  jDrawingView1.PaintShader.Combine(0, 1, PorterDuff.OVERLAY, 2);  // https://developer.android.com/reference/android/graphics/PorterDuff.Mode.html
  jDrawingView1.PaintShader.SetZeroCoords(2); // identity, set zero coords, default scale & rotate
  //jDrawingView1.PaintShader.SetTranslate(450, 450, 2);
  jDrawingView1.PaintShader.SetTranslate(750, 750, 2);
  jDrawingView1.PaintShader.Bind(2);
  jDrawingView1.DrawCircle(750, 750, 175);
  //jDrawingView1.DrawCircle(300, 300, 175);

// radial gradient
  jDrawingView1.PaintShader.NewRadialGradient(750, 300, 175, [$FFFF0707, {$FFFF6A07, $FFFFD507,} $FFB8FF07, $FF51FF07, {$FF07FF24, $FF07FF8F,}
                                                              $FF07FFFF, $FF0797FF, {$FF072CFF, $FF4907FF,} $FFB007FF{, $FFFF07DE , $FFFF0772}], [], tmMIRROR, 1);
  jDrawingView1.PaintShader.Bind(1);
  jDrawingView1.DrawCircle(750, 300, 175);
// bitmap shader
  jDrawingView1.PaintShader.NewBitmapShader(jBitmap1.GetImage, tmREPEAT, tmREPEAT, 0.35, 0.35, 45, 5);
  jDrawingView1.PaintShader.Bind(5);
  jDrawingView1.DrawCircle(300, 750, 175);
// linear gradients
  // gradient with 5 colors                                            set array colors
  jDrawingView1.PaintShader.NewLinearGradient(40, 1000, 400, 50, 0, [$FFFF0707, $FFFFD507, $FF51FF07, $FF0797FF, $FFB007FF], [], tmCLAMP, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1000, 400, 50);
  // white to black
  //     params:                            left, top,  wh,  ht, deg, cololr 1, color 2  tile mode, ID
  jDrawingView1.PaintShader.NewLinearGradient(40, 1070, 400, 50, 0, $FFFFFFFF, $FF000000, tmCLAMP, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1070, 400, 50);
  // mirror mode
  jDrawingView1.PaintShader.NewLinearGradient(40, 1140, 200, 50, 0, $FFFFD507, $FF4907FF, tmMIRROR, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1140, 400, 50);
  // mirror mode & rotate shader on 45 deg
  jDrawingView1.PaintShader.NewLinearGradient(40, 1210, 200, 50, 45, $FFFFD507, $FF4907FF, tmMIRROR, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1210, 400, 50);
  // repeat mode
  jDrawingView1.PaintShader.NewLinearGradient(40, 1280, 200, 50, 0, $FF07FFFF, $FF4907FF, tmREPEAT, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1280, 400, 50);
  // set array colors & array positions
  jDrawingView1.PaintShader.NewLinearGradient(40, 1350, 350, 50, 0, [$FFFF6A07, $FFB8FF07, $FF4907FF], [0, 0.5, 1], tmREPEAT, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1350, 400, 50);
  // set array colors & array positions
  jDrawingView1.PaintShader.NewLinearGradient(40, 1420, 350, 50, 0, [$FFFF6A07, $FFB8FF07, $FF4907FF], [0, 0.7, 1], tmREPEAT, 5);
  jDrawingView1.PaintShader.Bind(5);
  DrawRect(40, 1420, 400, 50);
// disable shader
  jDrawingView1.PaintShader.Disable;
  DrawRect(40, 1490, 400, 50); // draw a rectangle with default color

  DrawStar(480, 1000, wh div 2, ht div 2);
end;

procedure TAndroidModule1.jDrawingView1SizeChanged(Sender: TObject;
  width: integer; height: integer; oldWidth: integer; oldHeight: integer);
begin
  wh := Width;
  ht := Height;
  jDrawingView1.Refresh;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  // disable hardware acceleration for the `JPaintShader.Combine` method to work correctly !
  // need VERSION.SDK_INT >= 11
  jDrawingView1.SetLayerType(ltSOFTWARE);

  //jDrawingView1.PaintShader.SetCount(..); // set shaders count, default 6, max = 50
  // NOTE: uses property

  jBitmap1.ImageIdentifier := 'list'; // select image, uses to set background

  jDrawingView1.PaintShader.SetIndex(3); // set the reference count to 3, first free ID = 3
  // create static shader, ID is assigned automatically! Params: ID = -1 (default)
  // NOTE: using a static method is preferable.
  bg := jDrawingView1.PaintShader.NewBitmapShader(jBitmap1.GetImage, tmREPEAT, tmREPEAT); // return current ID, = if SetIndex(..)

  // ... create new Shaders, ID + 1,2,3...N < 50
  // _ID4 := jDrawingView1.PaintShader.NewLinearGradient(0, 0, 300, 50, 0, $FFFFFFFF, $FF000000, tmREPEAT);
  // _ID5 := jDrawingView1.PaintShader.NewLinearGradient(0, 0, 300, 50, 0, $FF000000, $FFFFFFFF, tmCLAMP);
  // etc.

  jBitmap1.ImageIdentifier := 'cube_3d'; // select image  (..\res\drawable)
end;

end.
