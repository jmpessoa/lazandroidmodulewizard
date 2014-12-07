unit customdialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/5/2014 1:49:10]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jCustomDialog = class(jVisualControl)
 private
    //FTitle: string;
    FIconIdentifier: string;    // -->>  ../res/drawable  ex: just 'ic_launcher' [not 'ic_launcher.png']
    FOnShow: TCustomDialogShow;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

    procedure SetText(_title: string); override;
    procedure SetIconIdentifier(_iconIdentifier: string);

 protected

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
    procedure RemoveFromViewParent();
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure Show(); overload;
    procedure Show(_title: string); overload;
    procedure Show(_title: string; _iconIdentifier: string); overload;
    procedure Close();
    procedure GenEvent_OnCustomDialogShow(Obj: TObject; dialog: jObject; title: string);
 published
    //property Visible: boolean read FVisible write SetVisible;
    //property Title: string read FTitle write SetTitle;
    property IconIdentifier: string read FIconIdentifier write SetIconIdentifier;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnShow: TCustomDialogShow read FOnShow write FOnShow;
end;

function jCustomDialog_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jCustomDialog_jFree(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
procedure jCustomDialog_SetViewParent(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _viewgroup: jObject);
procedure jCustomDialog_RemoveFromViewParent(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
function jCustomDialog_GetView(env: PJNIEnv; this: JObject; _jcustomdialog: JObject): jObject;
procedure jCustomDialog_SetLParamWidth(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _w: integer);
procedure jCustomDialog_SetLParamHeight(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _h: integer);
procedure jCustomDialog_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jCustomDialog_AddLParamsAnchorRule(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _rule: integer);
procedure jCustomDialog_AddLParamsParentRule(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _rule: integer);
procedure jCustomDialog_SetLayoutAll(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _idAnchor: integer);
procedure jCustomDialog_ClearLayoutAll(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
procedure jCustomDialog_SetId(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _id: integer);

procedure jCustomDialog_Show(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);overload;
procedure jCustomDialog_Show(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _title: string);overload;
procedure jCustomDialog_Show(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _title: string; _iconIdentifier: string);overload;

procedure jCustomDialog_SetTitle(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _title: string);
procedure jCustomDialog_SetIconIdentifier(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _iconIdentifier: string);
procedure jCustomDialog_Close(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);


implementation

{---------  jCustomDialog  --------------}

constructor jCustomDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
    //your code here....
  FVisible:= False;
end;

destructor jCustomDialog.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jCustomDialog.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....

  FjObject:= jCreate();   //jSelf
  FInitialized:= True;

  FjRLayout{View}:= jCustomDialog_GetView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ); // Java : Self Layout

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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;

  jCustomDialog_SetViewParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);

  jCustomDialog_SetId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jCustomDialog_SetLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
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
      jCustomDialog_AddLParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jCustomDialog_AddLParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jCustomDialog_SetLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{wiew!}, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

procedure jCustomDialog.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{view!}, GetARGB(FColor));
end;
procedure jCustomDialog.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;
procedure jCustomDialog.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jCustomDialog_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jCustomDialog_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jCustomDialog_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jCustomDialog_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
    end;
  end;
end;

procedure jCustomDialog.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jCustomDialog_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jCustomDialog_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jCustomDialog_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jCustomDialog_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jCustomDialog.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jCustomDialog_SetLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  end;
end;

procedure jCustomDialog.Refresh;
begin
  if FInitialized then
    jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jCustomDialog.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jCustomDialog_ClearLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jCustomDialog_AddLParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jCustomDialog_AddLParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jCustomDialog.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jCustomDialog.jCreate(): jObject;
begin
   Result:= jCustomDialog_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jCustomDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jCustomDialog.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  //inherited SetViewParent(_viewgroup);
  FjPRLayout:= _viewgroup;
  if FInitialized then
     jCustomDialog_SetViewParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _viewgroup);
end;

procedure jCustomDialog.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_RemoveFromViewParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jCustomDialog.GetView(): jObject;
begin
  //in designing component state: result value here...
  Result:=  FjRLayout; //inherited GetView();
  if FInitialized then
     Result:= jCustomDialog_GetView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jCustomDialog.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _w);
end;

procedure jCustomDialog.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _h);
end;

procedure jCustomDialog.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jCustomDialog.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_AddLParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _rule);
end;

procedure jCustomDialog.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_AddLParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _rule);
end;

procedure jCustomDialog.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _idAnchor);
end;

procedure jCustomDialog.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_ClearLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jCustomDialog.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _id);
end;

procedure jCustomDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
     if FText <> '' then
       jCustomDialog_Show(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText)
     else
       jCustomDialog_Show(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
  end;
end;

procedure jCustomDialog.Show(_title: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
     if FIconIdentifier <> '' then
        jCustomDialog_Show(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _title, FIconIdentifier)
     else
        jCustomDialog_Show(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _title)
  end;
end;

procedure jCustomDialog.Show(_title: string;  _iconIdentifier: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  FIconIdentifier:= _iconIdentifier;
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
     jCustomDialog_Show(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _title, _iconIdentifier);
  end;
end;

procedure jCustomDialog.SetText(_title: string);
begin
  //in designing component state: set value here...
  inherited SetText(_title);
  if FInitialized then
    jCustomDialog_SetTitle(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _title);
end;

procedure jCustomDialog.SetIconIdentifier(_iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCustomDialog_SetIconIdentifier(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _iconIdentifier);
end;

procedure jCustomDialog.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
    jCustomDialog_Close(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jCustomDialog.GenEvent_OnCustomDialogShow(Obj: TObject; dialog: jObject; title: string);
begin
   if Assigned(OnShow) then OnShow(Obj, dialog, title);
end;

{-------- jCustomDialog_JNI_Bridge ----------}

function jCustomDialog_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jCustomDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jCustomDialog_jCreate(long _Self) {
      return (java.lang.Object)(new jCustomDialog(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jCustomDialog_jFree(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
end;


procedure jCustomDialog_SetViewParent(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_RemoveFromViewParent(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
end;


function jCustomDialog_GetView(env: PJNIEnv; this: JObject; _jcustomdialog: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcustomdialog, jMethod);
end;


procedure jCustomDialog_SetLParamWidth(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_SetLParamHeight(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_AddLParamsAnchorRule(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_AddLParamsParentRule(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_SetLayoutAll(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;


procedure jCustomDialog_ClearLayoutAll(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
end;


procedure jCustomDialog_SetId(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
end;

procedure jCustomDialog_Show(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
end;

procedure jCustomDialog_Show(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jCustomDialog_Show(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _title: string; _iconIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

procedure jCustomDialog_SetTitle(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jCustomDialog_SetIconIdentifier(env: PJNIEnv; this: JObject; _jcustomdialog: JObject; _iconIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIconIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jCustomDialog_Close(env: PJNIEnv; this: JObject; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
end;

end.
