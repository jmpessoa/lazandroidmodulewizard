unit gridview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TOnClickGridItem = procedure(Sender: TObject; position: integer; caption: string) of Object;
TGridItemLayout = (ilImageText, ilTextImage);

{Draft Component code by "Lazarus Android Module Wizard" [1/9/2015 21:12:18]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

  jGridView = class(jVisualControl)
  private
    FOnClickGridItem: TOnClickGridItem;
    FColumns: integer;
    FItemsLayout: TGridItemLayout;

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

    procedure GenEvent_OnClickGridItem(Obj: TObject; position: integer; caption: string);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();
    function GetView(): jObject;                  //override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure Add(_item: string; _imgIdentifier: string);

    procedure SetNumColumns(_value: integer);
    procedure SetColumnWidth(_value: integer);
    procedure Clear();
    procedure Delete(_index: integer);
    procedure SetItemsLayout(_value: TGridItemLayout);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Columns: integer read FColumns write SetNumColumns;
    property ItemsLayout: TGridItemLayout read FItemsLayout write SetItemsLayout;
    property OnClick: TOnClickGridItem read FOnClickGridItem write FOnClickGridItem;

  end;

function jGridView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGridView_jFree(env: PJNIEnv; _jgridview: JObject);
procedure jGridView_SetViewParent(env: PJNIEnv; _jgridview: JObject; _viewgroup: jObject);
procedure jGridView_RemoveFromViewParent(env: PJNIEnv; _jgridview: JObject);
function jGridView_GetView(env: PJNIEnv; _jgridview: JObject): jObject;
procedure jGridView_SetLParamWidth(env: PJNIEnv; _jgridview: JObject; _w: integer);
procedure jGridView_SetLParamHeight(env: PJNIEnv; _jgridview: JObject; _h: integer);
procedure jGridView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jgridview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jGridView_AddLParamsAnchorRule(env: PJNIEnv; _jgridview: JObject; _rule: integer);
procedure jGridView_AddLParamsParentRule(env: PJNIEnv; _jgridview: JObject; _rule: integer);
procedure jGridView_SetLayoutAll(env: PJNIEnv; _jgridview: JObject; _idAnchor: integer);
procedure jGridView_ClearLayoutAll(env: PJNIEnv; _jgridview: JObject);
procedure jGridView_SetId(env: PJNIEnv; _jgridview: JObject; _id: integer);
procedure jGridView_Add(env: PJNIEnv; _jgridview: JObject; _item: string; _imgIdentifier: string);
procedure jGridView_SetNumColumns(env: PJNIEnv; _jgridview: JObject; _value: integer);
procedure jGridView_SetColumnWidth(env: PJNIEnv; _jgridview: JObject; _value: integer);
procedure jGridView_Clear(env: PJNIEnv; _jgridview: JObject);
procedure jGridView_Delete(env: PJNIEnv; _jgridview: JObject; _index: integer);
procedure jGridView_SetItemsLayout(env: PJNIEnv; _jgridview: JObject; _value: integer);


implementation

uses
   customdialog;

{---------  jGridView  --------------}

constructor jGridView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpMatchParent;
  FHeight       := 160; //??
  FWidth        := 96; //??
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FColumns:= -1; //AUTO_FIT
  FItemsLayout:= ilImageText;
end;

destructor jGridView.Destroy;
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

procedure jGridView.Init(refApp: jApp);
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
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);//FjPRLayout:= jScrollView(FParent).View;
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
  jGridView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jGridView_SetId(FjEnv, FjObject, Self.Id);
  jGridView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jGridView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jGridView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy
  jGridView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FItemsLayout <> ilImageText then
      jGridView_SetItemsLayout(FjEnv, FjObject, Ord(FItemsLayout));

  if FColumns <> -1 then
      jGridView_SetNumColumns(FjEnv, FjObject, FColumns);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jGridView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jGridView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jGridView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jGridView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jGridView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jGridView_SetLParamWidth(FjEnv, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
    end;
  end;
end;

procedure jGridView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jGridView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jGridView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jGridView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jGridView_SetLParamHeight(FjEnv, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jGridView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jGridView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jGridView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jGridView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jGridView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jGridView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jGridView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jGridView.GenEvent_OnClickGridItem(Obj: TObject; position: integer; caption: string);
begin
  if Assigned(FOnClickGridItem) then FOnClickGridItem(Obj, position, caption);
end;

function jGridView.jCreate(): jObject;
begin
   Result:= jGridView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGridView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_jFree(FjEnv, FjObject);
end;

procedure jGridView.SetViewParent(_viewgroup: jObject);
begin
  inherited SetViewParent(_viewgroup);
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jGridView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jGridView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGridView_GetView(FjEnv, FjObject);
end;

procedure jGridView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jGridView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jGridView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jGridView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jGridView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jGridView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jGridView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jGridView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetId(FjEnv, FjObject, _id);
end;

procedure jGridView.Add(_item: string; _imgIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_Add(FjEnv, FjObject, _item ,_imgIdentifier);
end;

procedure jGridView.SetNumColumns(_value: integer);
begin
  //in designing component state: set value here...
  FColumns:= _value;
  if FInitialized then
     jGridView_SetNumColumns(FjEnv, FjObject, _value);
end;

procedure jGridView.SetColumnWidth(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_SetColumnWidth(FjEnv, FjObject, _value);
end;

procedure jGridView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_Clear(FjEnv, FjObject);
end;

procedure jGridView.Delete(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGridView_Delete(FjEnv, FjObject, _index);
end;

procedure jGridView.SetItemsLayout(_value: TGridItemLayout);
begin
  //in designing component state: set value here...
  FItemsLayout:= _value;
  if FInitialized then
     jGridView_SetItemsLayout(FjEnv, FjObject, Ord(_value));
end;

{-------- jGridView_JNI_Bridge ----------}

function jGridView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGridView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jGridView_jCreate(long _Self) {
      return (java.lang.Object)(new jGridView(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jGridView_jFree(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
end;


procedure jGridView_SetViewParent(env: PJNIEnv; _jgridview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_RemoveFromViewParent(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
end;


function jGridView_GetView(env: PJNIEnv; _jgridview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jgridview, jMethod);
end;


procedure jGridView_SetLParamWidth(env: PJNIEnv; _jgridview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_SetLParamHeight(env: PJNIEnv; _jgridview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jgridview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_AddLParamsAnchorRule(env: PJNIEnv; _jgridview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_AddLParamsParentRule(env: PJNIEnv; _jgridview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_SetLayoutAll(env: PJNIEnv; _jgridview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_ClearLayoutAll(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
end;


procedure jGridView_SetId(env: PJNIEnv; _jgridview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;

procedure jGridView_Add(env: PJNIEnv; _jgridview: JObject; _item: string; _imgIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_item));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_imgIdentifier));
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

procedure jGridView_SetNumColumns(env: PJNIEnv; _jgridview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNumColumns', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_SetColumnWidth(env: PJNIEnv; _jgridview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetColumnWidth', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;


procedure jGridView_Clear(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
end;


procedure jGridView_Delete(env: PJNIEnv; _jgridview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'Delete', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;

procedure jGridView_SetItemsLayout(env: PJNIEnv; _jgridview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jgridview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemsLayout', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
end;

end.
