{Hint: save all files to location: C:\adt32\eclipse\workspace\AppPinchZoomGestureDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jBitmap1: jBitmap;
      jImageView1: jImageView;
      jPanel1: jPanel;
      jTextView1: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jPanel1PinchZoomGesture(Sender: TObject; scaleFactor: single; scaleState: TPinchZoomScaleState);

    private
      {private declarations}
        FScaleFactorH: single;
        FScaleFactorW: single;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
                                  //lamw_logo1.png
{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jImageView1.SetImageBitmap(jBitmap1.LoadFromAssets('lamw_logo1.png')); //from  ../assets
end;


{
   TPinchZoomScaleState = (pzScaleBegin, pzScaling, pzScaleEnd);
   jPanel1.MaxPincZoomFactor = 4;   [delfault]
   jPanel1.MinPincZoomFactor = 1/4; [delfault]
 }

procedure TAndroidModule1.jPanel1PinchZoomGesture(Sender: TObject; scaleFactor: single; scaleState: TPinchZoomScaleState);
begin

  case scaleState of

     pzScaleBegin: begin
                     jTextView1.TextTypeFace:= tfBold;
                   end;

     pzScaling: begin
                  FScaleFactorW:= scaleFactor;
                  FScaleFactorH:= scaleFactor;
                end;

     pzScaleEnd: begin
                   jImageView1.SetImageBitmap(jBitmap1.GetResizedBitmap(FScaleFactorW, FScaleFactorH));
                   jTextView1.TextTypeFace:= tfNormal;
                 end;

  end;

end;

end.
