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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jDrawingView1.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads), 'drawing_image.png');
  ShowMessage('Imagem Saved to folder "...\Download"');
end;

procedure TAndroidModule1.jDrawingView1Draw(Sender: TObject; countXY: integer;
  X: array of single; Y: array of single; flingGesture: TFlingGesture;
  pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
var
  w1, h1: integer;
  //viewCanvas: jObject;
begin
  w1:= jDrawingView1.Width;
  h1:= jDrawingView1.Height;

  //jDrawingView1.PaintStrokeWidth:= 5 ;
  //jDrawingView1.PaintColor:= colbrMediumSpringGreen;

  //Frame
  jDrawingView1.DrawLine(0,0,0,h1-1);
  jDrawingView1.DrawLine(0,h1-1,w1-1,h1-1);
  jDrawingView1.DrawLine(w1-1,h1-1,w1-1,0);
  jDrawingView1.DrawLine(w1-1,0,0,0);

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

end.
