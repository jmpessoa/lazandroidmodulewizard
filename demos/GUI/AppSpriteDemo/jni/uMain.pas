{Hint: save all files to location: J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo\jni }
unit uMain;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, drawingview, Laz_And_Controls, uData;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jDrawingView1: jDrawingView;
    jTimer1: jTimer;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jDrawingView1Draw(Sender: TObject; countXY: integer;
      X: array of single; Y: array of single; flingGesture: TFlingGesture;
      pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
    procedure jTimer1Timer(Sender: TObject);
  private
    Frame_G1: Integer;
    Frame_G2: Integer;
    procedure NextFrame(var id: Integer; const first, last: Integer);
    procedure DrawScene;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.NextFrame(var id: Integer; const first, last: Integer);
begin
  Inc(id);
  if id > last then id := first;
end;

procedure TAndroidModule1.DrawScene;
var
  dh: Integer;
begin
  dh := (jDrawingView1.Height - 285) div 3;  // 150 * 1.9
  jDrawingView1.DrawFrame(jBitmap1.GetImage(), (jDrawingView1.Width - 285) div 2, dh - 20, Frame_G1, 150, 1.9);
  jDrawingView1.DrawFrame(jBitmap1.GetImage(), (jDrawingView1.Width - 285) div 2, dh*2 + 20, Frame_G2, 150, 1.9);
  jDrawingView1.Refresh;

  NextFrame(Frame_G1, 0, 5);
  NextFrame(Frame_G2, 6, 13);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jBitmap1.LoadFromBuffer(@IMGDATA, IMGDATA_SIZE); // load image from uData.pas
  jTimer1.Enabled := True;  // enable timer
  // init first frames
  Frame_G1 := 0;
  Frame_G2 := 6;

  jDrawingView1.SetPaintStyle(psStroke);

 if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
 begin
   ShowMessage('RequestRuntimePermission....');
   // hint: if you  get "write" permission then you have "read", too!
   RequestRuntimePermission(['android.permission.WRITE_EXTERNAL_STORAGE'], 2001);  // some/any value...
 end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
    2001:
      if grantResult = PERMISSION_GRANTED  then
        ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
      else  //PERMISSION_DENIED
        ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
  end;
end;

procedure TAndroidModule1.jDrawingView1Draw(Sender: TObject; countXY: integer;
  X: array of single; Y: array of single; flingGesture: TFlingGesture;
  pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
begin
  //
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  jDrawingView1.Clear;
  if jDrawingView1.BufferedDraw then
    DrawScene;
end;

end.
