unit toolbar;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [10/7/2017 0:41:37]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jToolbar = class(jVisualControl)
 private
    FTitle: string;
    FNavigationIcon: string;
    FLogoIcon:string;
    //FAsActionBar: boolean;
    //FSubtitle: string;
    //FHomeButtonEnabled:boolean;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;
    procedure SetLGravity(_g: integer);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);

    procedure SetTitle(_title: string);
    procedure SetNavigationIcon(_imageIdentifier: string);
    procedure SetLogoIcon(_imageIdentifier: string);
    procedure SetAsActionBar(_value: boolean);
    procedure SetSubtitle(_subtitle: string);
    procedure SetHomeButtonEnabled(_value: boolean);
    //procedure SetDisplayHomeAsUpEnabled(_value: boolean);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Title: string read FTitle write SetTitle;
    property NavigationIconIdentifier: string read FNavigationIcon write SetNavigationIcon;
    property LogoIconIdentifier:string read FLogoIcon write SetLogoIcon;
    //property AsActionBar: boolean read FAsActionBar write SetAsActionBar;
    //property Subtitle: string read FSubtitle write SetSubtitle;
    //property HomeButtonEnabled:boolean read FHomeButtonEnabled write SetHomeButtonEnabled;

    property OnClickNavigationIcon: TOnNotify read FOnClick write FOnClick;

end;

function jToolbar_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jToolbar_jFree(env: PJNIEnv; _jtoolbar: JObject);
procedure jToolbar_SetViewParent(env: PJNIEnv; _jtoolbar: JObject; _viewgroup: jObject);
function jToolbar_GetParent(env: PJNIEnv; _jtoolbar: JObject): jObject;
procedure jToolbar_RemoveFromViewParent(env: PJNIEnv; _jtoolbar: JObject);
function jToolbar_GetView(env: PJNIEnv; _jtoolbar: JObject): jObject;
procedure jToolbar_SetLParamWidth(env: PJNIEnv; _jtoolbar: JObject; _w: integer);
procedure jToolbar_SetLParamHeight(env: PJNIEnv; _jtoolbar: JObject; _h: integer);
function jToolbar_GetLParamWidth(env: PJNIEnv; _jtoolbar: JObject): integer;
function jToolbar_GetLParamHeight(env: PJNIEnv; _jtoolbar: JObject): integer;
procedure jToolbar_SetLGravity(env: PJNIEnv; _jtoolbar: JObject; _g: integer);
procedure jToolbar_SetLWeight(env: PJNIEnv; _jtoolbar: JObject; _w: single);
procedure jToolbar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtoolbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jToolbar_AddLParamsAnchorRule(env: PJNIEnv; _jtoolbar: JObject; _rule: integer);
procedure jToolbar_AddLParamsParentRule(env: PJNIEnv; _jtoolbar: JObject; _rule: integer);
procedure jToolbar_SetLayoutAll(env: PJNIEnv; _jtoolbar: JObject; _idAnchor: integer);
procedure jToolbar_ClearLayoutAll(env: PJNIEnv; _jtoolbar: JObject);
procedure jToolbar_SetId(env: PJNIEnv; _jtoolbar: JObject; _id: integer);

procedure jToolbar_SetTitle(env: PJNIEnv; _jtoolbar: JObject; _title: string);
procedure jToolbar_SetNavigationIcon(env: PJNIEnv; _jtoolbar: JObject; _imageIdentifier: string);
procedure jToolbar_SetLogo(env: PJNIEnv; _jtoolbar: JObject; _imageIdentifier: string);
procedure jToolbar_SetAsActionBar(env: PJNIEnv; _jtoolbar: JObject; _value: boolean);
procedure jToolbar_SetSubtitle(env: PJNIEnv; _jtoolbar: JObject; _subtitle: string);
procedure jToolbar_SetHomeButtonEnabled(env: PJNIEnv; _jtoolbar: JObject; _value: boolean);
//procedure jToolbar_SetDisplayHomeAsUpEnabled(env: PJNIEnv; _jtoolbar: JObject; _value: boolean);

implementation

uses
   customdialog;

{---------  jToolbar  --------------}

constructor jToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //96; //??

  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent

  FAcceptChildrenAtDesignTime:= True;

  FTitle:= '';
  FNavigationIcon:= '';
  FLogoIcon:= '';
  FColor:= colbrRoyalBlue;  //default background color compatible with "color.xml"
  //FAsActionBar:= False;
  //FSubtitle:= '';
  //FHomeButtonEnabled:= False;

end;

destructor jToolbar.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jToolbar.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
  end;

  jToolbar_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jToolbar_SetId(FjEnv, FjObject, Self.Id);
  jToolbar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        GetLayoutParams(gApp, FLParamWidth, sdW),
                        GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
    Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jToolbar_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jToolbar_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jToolbar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FNavigationIcon <> '' then
     jToolbar_SetNavigationIcon(FjEnv, FjObject, FNavigationIcon);

  if  FTitle <> '' then
    jToolbar_SetTitle(FjEnv, FjObject, FTitle);

  if FLogoIcon <> '' then
    jToolbar_SetLogo(FjEnv, FjObject, FLogoIcon);

  {
  if FAsActionBar then
    jToolbar_SetAsActionBar(FjEnv, FjObject, FAsActionBar);

  if (FAsActionBar) and (FSubtitle <> '') then
    jToolbar_SetSubtitle(FjEnv, FjObject, FSubtitle);

  if FAsActionBar then
    jToolbar_SetHomeButtonEnabled(FjEnv, FjObject, FHomeButtonEnabled);
  }

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jToolbar.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jToolbar.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jToolbar.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jToolbar_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jToolbar_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jToolbar_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jToolbar.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jToolbar_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jToolbar_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jToolbar_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jToolbar.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jToolbar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jToolbar.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jToolbar.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jToolbar_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jToolbar_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jToolbar_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jToolbar.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jToolbar.jCreate(): jObject;
begin
   Result:= jToolbar_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jToolbar.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_jFree(FjEnv, FjObject);
end;

procedure jToolbar.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout:= _viewgroup;
  if FInitialized then
     jToolbar_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jToolbar.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToolbar_GetParent(FjEnv, FjObject);
end;

procedure jToolbar.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_RemoveFromViewParent(FjEnv, FjObject);
end;

function jToolbar.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToolbar_GetView(FjEnv, FjObject);
end;

procedure jToolbar.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jToolbar.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jToolbar.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToolbar_GetLParamWidth(FjEnv, FjObject);
end;

function jToolbar.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToolbar_GetLParamHeight(FjEnv, FjObject);
end;

procedure jToolbar.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jToolbar.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jToolbar.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jToolbar.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jToolbar.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jToolbar.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jToolbar.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jToolbar.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetId(FjEnv, FjObject, _id);
end;

procedure jToolbar.SetTitle(_title: string);
begin
  //in designing component state: set value here...
  FTitle:= _title;
  if FInitialized then
  begin
     if FTitle <> '' then
       jToolbar_SetTitle(FjEnv, FjObject, FTitle);
  end;
end;

procedure jToolbar.SetNavigationIcon(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FNavigationIcon:= _imageIdentifier;
  if FInitialized then
  begin
     if FNavigationIcon <> '' then
        jToolbar_SetNavigationIcon(FjEnv, FjObject, FNavigationIcon);
  end;
end;

procedure jToolbar.SetLogoIcon(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FLogoIcon:= _imageIdentifier;
  if FInitialized then
  begin
     if FLogoIcon <> '' then
       jToolbar_SetLogo(FjEnv, FjObject, FLogoIcon);
  end;
end;

procedure jToolbar.SetAsActionBar(_value: boolean);
begin
  //FAsActionBar:= _value;
  if FInitialized then
     jToolbar_SetAsActionBar(FjEnv, FjObject, _value);
end;

procedure jToolbar.SetSubtitle(_subtitle: string);
begin
  //in designing component state: set value here...
  //FSubtitle:= _subtitle;
  if FInitialized then
  begin
     if _subtitle <> '' then
       jToolbar_SetSubtitle(FjEnv, FjObject, _subtitle);
  end;
end;

procedure jToolbar.SetHomeButtonEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  //FHomeButtonEnabled:= _value;
  if FInitialized then
    jToolbar_SetHomeButtonEnabled(FjEnv, FjObject, _value);
end;

{
procedure jToolbar.SetDisplayHomeAsUpEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToolbar_SetDisplayHomeAsUpEnabled(FjEnv, FjObject, _value);
end;
}
{-------- jToolbar_JNI_Bridge ----------}

function jToolbar_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jToolbar_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jToolbar_jCreate(long _Self) {
  return (java.lang.Object)(new jToolbar(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jToolbar_jFree(env: PJNIEnv; _jtoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetViewParent(env: PJNIEnv; _jtoolbar: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jToolbar_GetParent(env: PJNIEnv; _jtoolbar: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_RemoveFromViewParent(env: PJNIEnv; _jtoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jToolbar_GetView(env: PJNIEnv; _jtoolbar: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetLParamWidth(env: PJNIEnv; _jtoolbar: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetLParamHeight(env: PJNIEnv; _jtoolbar: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jToolbar_GetLParamWidth(env: PJNIEnv; _jtoolbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jToolbar_GetLParamHeight(env: PJNIEnv; _jtoolbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetLGravity(env: PJNIEnv; _jtoolbar: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetLWeight(env: PJNIEnv; _jtoolbar: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtoolbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _w;
  jParams[5].i:= _h;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_AddLParamsAnchorRule(env: PJNIEnv; _jtoolbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_AddLParamsParentRule(env: PJNIEnv; _jtoolbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetLayoutAll(env: PJNIEnv; _jtoolbar: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_ClearLayoutAll(env: PJNIEnv; _jtoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jtoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetId(env: PJNIEnv; _jtoolbar: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetTitle(env: PJNIEnv; _jtoolbar: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToolbar_SetNavigationIcon(env: PJNIEnv; _jtoolbar: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNavigationIcon', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToolbar_SetLogo(env: PJNIEnv; _jtoolbar: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLogo', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToolbar_SetSubtitle(env: PJNIEnv; _jtoolbar: JObject; _subtitle: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_subtitle));
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSubtitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToolbar_SetHomeButtonEnabled(env: PJNIEnv; _jtoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHomeButtonEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

{
procedure jToolbar_SetDisplayHomeAsUpEnabled(env: PJNIEnv; _jtoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDisplayHomeAsUpEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
}

procedure jToolbar_SetAsActionBar(env: PJNIEnv; _jtoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jtoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAsActionBar', '(Z)V');
  env^.CallVoidMethodA(env, _jtoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
