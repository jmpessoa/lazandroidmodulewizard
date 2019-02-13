{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDrawingViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, drawingview;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jDrawingView1: jDrawingView;
    jImageView1: jImageView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jDrawingView1Draw(Sender: TObject; countXY: integer;
      X: array of single; Y: array of single; flingGesture: TFlingGesture;
      pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);

    procedure jDrawingView1TouchMove(Sender: TObject; countXY: integer;
      X: array of single; Y: array of single; flingGesture: TFlingGesture;
      pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
    procedure jDrawingView1TouchUp(Sender: TObject; countXY: integer;
      X: array of single; Y: array of single; flingGesture: TFlingGesture;
      pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);

  private
    {private declarations}
    P: TPoint;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}
  

{ TAndroidModule1 }

//minX = -4, maxX=4, minY = -5, maxY = 5
function MyFunc(x: single): single;
begin
  Result:= x*x - 4;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
     //hint: if you  get "write" permission then you have "read", too!
   if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
      jDrawingView1.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads), 'drawing_image.png');
      ShowMessage('Imagem Saved to folder "...\Download"');
   end
   else  ShowMessage('Sorry... [android.permission.WRITE_EXTERNAL_STORAGE] denied... ' );
end;

procedure TAndroidModule1.jDrawingView1Draw(Sender: TObject; countXY: integer;
  X: array of single; Y: array of single; flingGesture: TFlingGesture;
  pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
var
   w1, h1: integer;
   //viewCanvas: jObject;
   points: TDynArrayOfSingle;
   path: jObjectRef;
   i, j: integer;
   px, py: single;
begin
   w1:= jDrawingView1.Width;
   h1:= jDrawingView1.Height;

  //Frame
  {
  jDrawingView1.DrawLine(0,0, 0,h1-1);
  jDrawingView1.DrawLine(0,h1-1,    w1-1,h1-1);
  jDrawingView1.DrawLine(w1-1,h1-1, w1-1,0);
  jDrawingView1.DrawLine(w1-1,0,    0,0);
  }
   //or Frame
   path:= jDrawingView1.GetPath([
                                0,0, //p1
                                0,h1-1, //p2
                                w1-1,h1-1, //p3
                                w1-1,0, //p4
                                0,0 //p1
                                ]);
   jDrawingView1.DrawPath(path);
   jDrawingView1.DrawTextOnPath(path, 'FRAME', 0, 0);

   //draw function testF
   SetLength(points, 18); //-4,-3,-2,-1, 0, 1,2,3,4
   i:=0;
   for j:= -4  to 4 do
   begin
      px:= j;
      py:= MyFunc(px);
      points[i]:=   jDrawingView1.GetViewPortX(px, -4, 4, w1); //_minWorldX = -4, maxWorldX = 4
      points[i+1]:= jDrawingView1.GetViewPortY(py, -5, 5, h1); //minWorldY = -5,  maxWorldY = 5
      i:= i + 2;
   end;
   path:=  jDrawingView1.GetPath(points);

   jDrawingView1.AddPointsToPath(path,  [  //axis x
                                          jDrawingView1.GetViewPortX(-4, -4, 4, w1), jDrawingView1.GetViewPortY(0, -5, 5, h1),
                                          jDrawingView1.GetViewPortX( 4, -4, 4, w1), jDrawingView1.GetViewPortY(0, -5, 5, h1)
                                        ]);

   jDrawingView1.AddPointsToPath(path,  [  //axis y
                                          jDrawingView1.GetViewPortX(0, -4, 4, w1), jDrawingView1.GetViewPortY(-5, -5, 5, h1),
                                          jDrawingView1.GetViewPortX(0, -4, 4, w1), jDrawingView1.GetViewPortY(5, -5, 5, h1)
                                        ]);

   jDrawingView1.DrawPath(path);
   SetLength(points, 0);

   jDrawingView1.DrawText('F(X) = X * X - 4',
                           jDrawingView1.GetViewPortX(0, -4, 4, w1), jDrawingView1.GetViewPortY(0, -5, 5, h1)
                           );

  //jView1.Canvas.PaintStyle:= psFillAndStroke;
  //jDrawingView1.PaintColor:= colbrRed;
  //jView1.Canvas.PaintTextSize:= 20;
  //jView1.Canvas.drawText('Drawing View Test: Drag the cube!', 10,30);

  jDrawingView1.DrawText('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,h1-30);

  jDrawingView1.DrawBitmap(jBitmap1.GetImage(), P.X-100,P.Y-100,P.X+100,P.Y+100);

  //we can get the canvas here:
  //viewCanvas:= jDrawingView1.Canvas;

end;

procedure TAndroidModule1.jDrawingView1TouchMove(Sender: TObject;
  countXY: integer; X: array of single; Y: array of single;
  flingGesture: TFlingGesture; pinchZoomScaleState: TPinchZoomScaleState;
  zoomScale: single);
begin
  if countXY > 0 then
  begin
    P:= Point(Round(X[0]), Round(Y[0]));
    jDrawingView1.Refresh;   //call OnDraw ....
  end;
end;

procedure TAndroidModule1.jDrawingView1TouchUp(Sender: TObject; countXY: integer;
  X: array of single; Y: array of single; flingGesture: TFlingGesture;
  pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
begin
  jImageView1.SetImage(jDrawingView1.GetImage());  //getimage and show....
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  P.X:= 135;
  P.Y:= 135;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  //jDrawingView1.PaintStrokeWidth:= 5 ;
  //jDrawingView1.PaintColor:= colbrMediumSpringGreen;
  jDrawingView1.SetPaintStyle(psStroke);
  //jDrawingView1.SetPaintStrokeJoin(sjRound);
  //jDrawingView1.SetPaintStrokeCap(scRound);

  if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
  begin
      ShowMessage('RequestRuntimePermission....');
      //hint: if you  get "write" permission then you have "read", too!
      Self.RequestRuntimePermission(['android.permission.WRITE_EXTERNAL_STORAGE'], 2001);  // some/any value...
  end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
     2001:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
   end;
end;

end.
