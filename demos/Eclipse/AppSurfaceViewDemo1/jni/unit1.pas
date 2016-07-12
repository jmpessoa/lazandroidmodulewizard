{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSurfaceViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, surfaceview, imagefilemanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jImageFileManager1: jImageFileManager;
    jSurfaceView1: jSurfaceView;
    jTextView1: jTextView;
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jSurfaceView1DrawInBackground(Sender: TObject; progress: single; out running: boolean);
    procedure jSurfaceView1DrawOutBackground(Sender: TObject; progress: single);
    procedure jSurfaceView1SurfaceCreated(Sender: TObject);
    procedure jSurfaceView1SurfaceDraw(Sender: TObject; canvas: jObject);
    procedure jSurfaceView1TouchDown(Sender: TObject; Touch: TMouch);
    procedure jSurfaceView1TouchUp(Sender: TObject; Touch: TMouch);

  private
    {private declarations}
    FX1, FY1: single;
    FX2, FY2: single;
    FInBackground: boolean;

  public
    {public declarations}
  end;

  function GetLemurJourney(x: single): single;

var
  AndroidModule1: TAndroidModule1;
  GlobalImage: jObject;


implementation

{$R *.lfm}

{ TAndroidModule1 }

function GetLemurJourney(x: single): single;
begin
   Result:= x;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  GlobalImage:= jImageFileManager1.LoadFromAssets('lemur.jpg');
  GlobalImage:= Get_jObjGlobalRef(GlobalImage);
end;

//simple/trivial Ondraw event handle
procedure TAndroidModule1.jSurfaceView1SurfaceDraw(Sender: TObject; canvas: jObject);
begin
   if  GlobalImage <> nil  then
         jSurfaceView1.DrawBitmap(canvas, GlobalImage, FX2, FY2);
   jSurfaceView1.DrawLine(canvas, FX1, FY1 , FX2, FY2);
end;

//simple/trivial draw
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  FX1:= 100;
  FY1:= 100;
  FX2:= 250;
  FY2:= 500;
  jSurfaceView1.PaintColor:= colbrOrange;
  jSurfaceView1.BackgroundColor:= colbrLightCyan;
  jSurfaceView1.DispatchOnDraw(True); //true = Allows SurfaceView use Refresh()/Invalidate() to call onDraw() event!
  jSurfaceView1.Invalidate();         //must be called from a main UI thread
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  FX1:= 0;
  FY1:= 0;
  FInBackground:= True;
  jSurfaceView1.PaintColor:= colbrRed;
  jSurfaceView1.BackgroundColor:= colbrLightCyan;
  jSurfaceView1.SetDrawingInBackgroundSleeptime(20); //default/min = 20 miliseconds
  jSurfaceView1.DoDrawingInBackground(True);  //fires  OnDrawingInBackgroundRunning  !!
end;

procedure TAndroidModule1.jSurfaceView1DrawInBackground(Sender: TObject;
  progress: single; out running: boolean);
begin
  running:= True; //continue running ....

  FX2:= progress;
  FY2:= GetLemurJourney(progress);

  if (FX2 > 480) then
     running:= False;    //the game is over!
end;

procedure TAndroidModule1.jSurfaceView1SurfaceCreated(Sender: TObject);
var
   canv: jObject;
begin
   FInBackground:= False;
   ShowMessage('Surface Created ...');
   canv:= jSurfaceView1.GetLockedCanvas();
   jSurfaceView1.DrawBackground(canv, colbrLightCyan);
   jSurfaceView1.SetPaintTextSize(36);
   jSurfaceView1.DrawText(canv, 'Hello World!',300,300);
   jSurfaceView1.UnLockCanvas(canv);
end;

procedure TAndroidModule1.jSurfaceView1DrawOutBackground(Sender: TObject;
  progress: single);
begin
  ShowMessage('The Game is Over...!');
  FInBackground:= False;
end;

procedure TAndroidModule1.jSurfaceView1TouchDown(Sender: TObject; Touch: TMouch);
begin
  if not FInBackground then ShowMessage('Touch: X='+ FloatToStr(Touch.Pt.X) + ' Y='+FloatToStr(Touch.Pt.Y) );
end;

procedure TAndroidModule1.jSurfaceView1TouchUp(Sender: TObject; Touch: TMouch);
begin
  //
end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  Delete_jGlobalRef(GlobalImage);
end;

end.
