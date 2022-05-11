unit seekbar;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TOnSeekBarProgressChanged = procedure(Sender: TObject;  progress: integer; fromUser: boolean) of Object;
TOnSeekBarStartTrackingTouch= procedure(Sender: TObject;  progress: integer) of Object;
TOnSeekBarStopTrackingTouch= procedure(Sender: TObject;  progress: integer) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [7/8/2015 23:40:47]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jSeekBar = class(jVisualControl)
 private
    FMax: integer;
    FProgress: integer;
    FOnSeekBarProgressChanged:    TOnSeekBarProgressChanged;
    FOnSeekBarStartTrackingTouch: TOnSeekBarStartTrackingTouch;
    FOnSeekBarStopTrackingTouch:  TOnSeekBarStopTrackingTouch;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    //procedure GenEvent_OnClick(Obj: TObject);
    procedure SetViewParent(_viewgroup: jObject);  override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetMax(_maxProgress: integer);
    procedure SetProgress(_progress: integer);
    function GetProgress(): integer;
    procedure SetRotation(_rotation: single);
    procedure SetLGravity(_value: TLayoutGravity);

    procedure SetScale( _scaleX, _scaleY : single ); // by ADiV
    procedure SetThumbDrawable( _strDrawable : String ); // by ADiV
    procedure SetThumbBitmap( _bitmap : jObject; _width, _height : integer ); overload; // by ADiV
    procedure SetThumbBitmap( _bitmap : jObject ); overload; // by ADiV
    procedure SetThumbBitmapByRes( _strBitmap : String; _width, _height : integer ); overload; // by ADiV
    procedure SetThumbBitmapByRes( _strBitmap : String ); overload; // by ADiV
    procedure SetColors( colorBar, colorFinger : TARGBColorBridge ); // by ADiV

    procedure GenEvent_OnSeekBarProgressChanged(Obj: TObject; progress: integer; fromUser: boolean);
    procedure GenEvent_OnSeekBarStartTrackingTouch(Obj: TObject; progress: integer);
    procedure GenEvent_OnSeekBarStopTrackingTouch(Obj: TObject; progress: integer);
    property Progress:integer read GetProgress write SetProgress;

 published

    property Max: integer read FMax write SetMax;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

    property OnProgressChanged:    TOnSeekBarProgressChanged read FOnSeekBarProgressChanged write FOnSeekBarProgressChanged;
    property OnStartTrackingTouch: TOnSeekBarStartTrackingTouch read FOnSeekBarStartTrackingTouch write FOnSeekBarStartTrackingTouch;
    property OnStopTrackingTouch:  TOnSeekBarStopTrackingTouch read FOnSeekBarStopTrackingTouch write FOnSeekBarStopTrackingTouch;

end;

function jSeekBar_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

implementation


{---------  jSeekBar  --------------}

constructor jSeekBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 30; //??
  FWidth        := 100; //??
  FLParamWidth  := lpOneThirdOfParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FMax:= 100;
  FProgress:= 50;
end;

destructor jSeekBar.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_free(gApp.jni.jEnv, FjObject);
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jSeekBar.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jSeekBar_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);

   if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
    SetLGravity(FGravityInParent);

   View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                  FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                  sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, FMarginLeft + FMarginRight ),
                  sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, FMarginTop + FMarginBottom ));

  for rToA := raAbove to raAlignRight do
    if rToA in FPositionRelativeToAnchor then
      AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));

  for rToP := rpBottom to rpCenterVertical do
    if rToP in FPositionRelativeToParent then
      AddLParamsParentRule(GetPositionRelativeToParent(rToP));


  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  SetLayoutAll(Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FMax <> 100  then
     SetMax(FMax);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jSeekBar.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jSeekBar.SetColors( colorBar, colorFinger : TARGBColorBridge );
begin

  if (FInitialized = True) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetColor', GetARGB(FCustomColor, colorBar), GetARGB(FCustomColor, colorFinger));

end;

procedure jSeekBar.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jSeekBar.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jSeekBar.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
{
procedure jSeekBar.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
}

procedure jSeekBar.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

procedure jSeekBar.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jSeekBar.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jSeekBar.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jSeekBar.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

procedure jSeekBar.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSeekBar.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jSeekBar.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jSeekBar.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jSeekBar.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          AddLParamsParentRule(GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jSeekBar.SetMax(_maxProgress: integer);
begin
  //in designing component state: set value here...
  FMax:= _maxProgress;
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetMax', _maxProgress);
end;

procedure jSeekBar.SetProgress(_progress: integer);
begin
  //in designing component state: set value here...
  FProgress:=  _progress;
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetProgress', _progress);
end;

function jSeekBar.GetProgress(): integer;
begin
  //in designing component state: result value here...
  Result:= FProgress;
  if FInitialized then
    Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetProgress');
end;

procedure jSeekBar.SetRotation(_rotation: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_f(gApp.jni.jEnv, FjObject, 'SetRotation', _rotation);
end;

procedure jSeekBar.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
   View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(_value));
end;

procedure jSeekBar.SetScale( _scaleX, _scaleY : single ); // by ADiV
begin
  if FInitialized then
   jni_proc_ff( gApp.jni.jEnv, FjObject, 'SetScale', _scaleX, _scaleY);
end;

procedure jSeekBar.SetThumbDrawable( _strDrawable : String ); // by ADiV
begin
  if FInitialized then
   jni_proc_t( gApp.jni.jEnv, FjObject, 'SetThumbDrawable', _strDrawable);
end;

procedure jSeekBar.SetThumbBitmap( _bitmap : jObject; _width, _height : integer ); // by ADiV
begin
  if FInitialized then
   jni_proc_bmp_ii( gApp.jni.jEnv, FjObject, 'SetThumbBitmap', _bitmap, _width, _height);
end;

procedure jSeekBar.SetThumbBitmap( _bitmap : jObject ); // by ADiV
begin
  if FInitialized then
   jni_proc_bmp( gApp.jni.jEnv, FjObject, 'SetThumbBitmap', _bitmap);
end;

procedure jSeekBar.SetThumbBitmapByRes( _strBitmap : String; _width, _height : integer ); // by ADiV
begin
 if FInitialized then
   jni_proc_tii( gApp.jni.jEnv, FjObject, 'SetThumbBitmapByRes', _strBitmap, _width, _height);
end;

procedure jSeekBar.SetThumbBitmapByRes( _strBitmap : String ); // by ADiV
begin
  if FInitialized then
   jni_proc_t( gApp.jni.jEnv, FjObject, 'SetThumbBitmapByRes', _strBitmap);
end;

procedure jSeekBar.GenEvent_OnSeekBarProgressChanged(Obj: TObject; progress: integer; fromUser: boolean);
begin
  if Assigned(FOnSeekBarProgressChanged) then FOnSeekBarProgressChanged(Obj, progress, fromUser);
end;

procedure jSeekBar.GenEvent_OnSeekBarStartTrackingTouch(Obj: TObject; progress: integer);
begin
  if Assigned(FOnSeekBarStartTrackingTouch) then FOnSeekBarStartTrackingTouch(Obj, progress);
end;

procedure jSeekBar.GenEvent_OnSeekBarStopTrackingTouch(Obj: TObject; progress: integer);
begin
  if Assigned(FOnSeekBarStopTrackingTouch) then FOnSeekBarStopTrackingTouch(Obj, progress);
end;

{-------- jSeekBar_JNI_Bridge ----------}

function jSeekBar_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jSeekBar_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

(*
//Please, you need insert:

   public java.lang.Object jSeekBar_jCreate(long _Self) {
      return (java.lang.Object)(new jSeekBar(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

end.
