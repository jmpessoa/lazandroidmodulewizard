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
    FIsDrawingScene: boolean;
    procedure DrawMyScene();
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

   if jDrawingView1.BufferedDraw then
   begin
     DrawMyScene();
   end;
   FIsDrawingScene:= True;
   jDrawingView1.Refresh();   //fire OnDraw...

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
begin

  if not FIsDrawingScene then
  begin
    jDrawingView1.DrawBitmap(jBitmap1.GetImage(), P.X, P.Y, -45); // draw only the cube..
    //jDrawingView1.DrawText('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10, 300);
    Exit;
  end;
  if not jDrawingView1.BufferedDraw then Self.DrawMyScene();

end;

procedure TAndroidModule1.jDrawingView1TouchMove(Sender: TObject;
  countXY: integer; X: array of single; Y: array of single;
  flingGesture: TFlingGesture; pinchZoomScaleState: TPinchZoomScaleState;
  zoomScale: single);
begin
  if countXY > 0 then
  begin
    if jDrawingView1.BufferedDraw then
    begin
      jDrawingView1.Clear(); //
      DrawMyScene();
    end;
    P:= Point(Round(X[0]), Round(Y[0]));
    jDrawingView1.Refresh;   //call OnDraw ....
  end;
end;

procedure TAndroidModule1.jDrawingView1TouchUp(Sender: TObject; countXY: integer;
  X: array of single; Y: array of single; flingGesture: TFlingGesture;
  pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
begin
  //DrawMyScene();
  //jDrawingView1.Refresh;
  jImageView1.SetImage(jDrawingView1.GetImage());  //getimage and show....
end;

procedure TAndroidModule1.DrawMyScene();
var
   w1, h1: integer;
   points: TDynArrayOfSingle;
   path: jObjectRef;
   i, j: integer;
   px, py: single;
   boxArray4: TDynArrayOfSingle;
   boxArray8: TDynArrayOfSingle;
begin

   w1:= jDrawingView1.Width;
   h1:= jDrawingView1.Height;

   //or Frame
   path:= jDrawingView1.GetPath([
                                0,0,       //p1
                                0,h1-1,    //p2
                                w1-1,h1-1, //p3
                                w1-1,0,    //p4
                                0,0        //p1
                                ]);
   jDrawingView1.DrawPath(path);
   jDrawingView1.DrawTextOnPath(path, 'FRAME', 0, 0);

   //draw function MyFunc
   jDrawingView1.SetViewportScaleXY(-4 {MinX},4{MaxX}, -5{MinY},5{MaxY});
   SetLength(points, 2*9); //-4,-3,-2,-1, 0, 1,2,3,4   (x,y)
   i:=0;
   for j:= -4  to 4 do
   begin
      px:= j;
      py:= MyFunc(px);
      points[i]:= jDrawingView1.GetViewportX(px);
      points[i+1]:= jDrawingView1.GetViewportY(py);
      i:= i + 2;
   end;
   path:=  jDrawingView1.GetPath(points);

   jDrawingView1.AddPointsToPath(path,  [  //axis x
                                          jDrawingView1.GetViewportX(-4), jDrawingView1.GetViewportY(0), //p1
                                          jDrawingView1.GetViewportX( 4), jDrawingView1.GetViewportY(0)  //p2
                                        ]);

   jDrawingView1.AddPointsToPath(path,  [  //axis y
                                          jDrawingView1.GetViewportX(0), jDrawingView1.GetViewportY(-5), //p1
                                          jDrawingView1.GetViewportX(0), jDrawingView1.GetViewportY( 5)   //p2
                                        ]);

   jDrawingView1.DrawPath(path);
   SetLength(points, 0);

   //NEW!
   boxArray8:= jDrawingView1.DrawTextEx('F(X) = X * X - 4', jDrawingView1.GetViewportX(0), jDrawingView1.GetViewportY(0), -45, True);
   //jDrawingView1.DrawPath(boxArray8); //just to be noted...
   jDrawingView1.DrawRect(boxArray8);
   SetLength(boxArray8, 0);

   jDrawingView1.DrawTextMultiLine('All theory is gray... But forever green is the tree of life. Johann Wolfgang von Goethe',
                                   jDrawingView1.GetViewportX(-2), jDrawingView1.GetViewportY(2),  //p1
                                   jDrawingView1.GetViewportX(0), jDrawingView1.GetViewportY(0)   //p2
                                   );


   //Drawing by Absolute Coordinates example

   //https://fontzone.net/font-details/ar-bonnie
  jDrawingView1.DrawTextFromAssetsFont('Hello World!', 400, 50, 'ARBONNIE.TTF', 16, colbrGreen);  //font from folder assets

  //https://fontawesome.com/cheatsheet?from=io
  //&#xf17b;       android
  //&#xf1b0;       paw  / lazarus
  //&#xf118;       smile
  jDrawingView1.DrawTextFromAssetsFont(Self.ParseHtmlFontAwesome('&#xf1b0'), P.X-100, P.Y+200,
                                        'fontawesome-webfont.ttf', 20, colbrGreen); //font from folder assets

  jDrawingView1.DrawBitmap(jBitmap1.GetImage(), P.X, P.Y, -45);

  //jDrawingView1.DrawTextEx('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,h1-30);
  //boxArray4:= jDrawingView1.GetTextBox('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,h1-30);

  //NEW!
  boxArray4:= jDrawingView1.DrawTextEx('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,h1-30);
  jDrawingView1.DrawRect(boxArray4[0] {left}, boxArray4[1]{top}, boxArray4[2]{right}, boxArray4[3]{bottom});

  SetLength(boxArray4, 0);

end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  P.X:= 135;
  P.Y:= 135;
  FIsDrawingScene:= False;
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
