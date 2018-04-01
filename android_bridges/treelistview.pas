unit treelistview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

 TOnClickTreeListItem = procedure(Sender: TObject; itemIndex: integer; itemCaption: string) of object;

{Draft Component code by "Lazarus Android Module Wizard" [19/02/2018 09:45:17]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

 jTreeListView = class(jVisualControl)
 private
    FOnClickTreeViewItem: TOnClickTreeListItem;
    FOnLongClickTreeViewItem: TOnClickTreeListItem;

    FLevels: integer;
    FFocusedNode: integer;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
    procedure SetFocusedNode(id: integer);
    procedure SetLevels(count: integer);
    function GetNodeHasChildren(id: integer): boolean;
    function GetRootNode: integer;
    function GetParentNode(id: integer): integer;
    function GetNodeData(id: integer): string;
    procedure SetNodeCaption(id: integer; caption: string);
    procedure TryNewParent(refApp: jApp);
 protected
     FjPRLayoutHome: jObject; //Save parent origin
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClickTreeViewItem(Obj: TObject; position: integer; caption: string);
    procedure GenEvent_OnLongClickTreeViewItem(Obj: TObject; position: integer; caption: string);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
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

    function AddChild(AParent: integer): integer;
    procedure Clear;
    function GetFirstChild(parent_id: integer): integer;
    function GetNextSibling(id :integer): integer;
    procedure ToggleNode(id: integer);

    property FocusedNode: integer read FFocusedNode write SetFocusedNode;
    property HasChildren[node: integer]: boolean read GetNodeHasChildren;
    property Levels: integer read FLevels write SetLevels;
    property NodeData[node: integer]: string read GetNodeData write SetNodeCaption;
    property ParentNode[node: integer]: integer read GetParentNode;
    property RootNode: integer read GetRootNode;
 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClickItem: TOnClickTreeListItem read FOnClickTreeViewItem write FOnClickTreeViewItem;
    property OnLongClickItem: TOnClickTreeListItem read FOnLongClickTreeViewItem write FOnLongClickTreeViewItem;
end;

procedure TreeViewList_Log (msg: string);

function jTreeListView_jCreate(env: PJNIEnv; _Self: int64; this: JObject): jObject;
procedure jTreeListView_jFree(env: PJNIEnv; _jtreelistview: JObject);
procedure jTreeListView_SetViewParent(env: PJNIEnv; _jtreelistview: JObject; _viewgroup: jObject);
function jTreeListView_GetParent(env: PJNIEnv; _jtreelistview: JObject): jObject;
procedure jTreeListView_RemoveFromViewParent(env: PJNIEnv; _jtreelistview: JObject);
function jTreeListView_GetView(env: PJNIEnv; _jtreelistview: JObject): jObject;
procedure jTreeListView_SetLParamWidth(env: PJNIEnv; _jtreelistview: JObject; _w: integer);
procedure jTreeListView_SetLParamHeight(env: PJNIEnv; _jtreelistview: JObject; _h: integer);
function jTreeListView_GetLParamWidth(env: PJNIEnv; _jtreelistview: JObject): integer;
function jTreeListView_GetLParamHeight(env: PJNIEnv; _jtreelistview: JObject): integer;
procedure jTreeListView_SetLGravity(env: PJNIEnv; _jtreelistview: JObject; _g: integer);
procedure jTreeListView_SetLWeight(env: PJNIEnv; _jtreelistview: JObject; _w: single);
procedure jTreeListView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtreelistview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jTreeListView_AddLParamsAnchorRule(env: PJNIEnv; _jtreelistview: JObject; _rule: integer);
procedure jTreeListView_AddLParamsParentRule(env: PJNIEnv; _jtreelistview: JObject; _rule: integer);
procedure jTreeListView_SetLayoutAll(env: PJNIEnv; _jtreelistview: JObject; _idAnchor: integer);
procedure jTreeListView_ClearLayoutAll(env: PJNIEnv; _jtreelistview: JObject);
procedure jTreeListView_SetId(env: PJNIEnv; _jtreelistview: JObject; _id: integer);

procedure jTreeListView_SetLevels(env: PJNIEnv; _jtreelistview: JObject; _count: integer);
procedure jTreeListView_Clear(env: PJNIEnv; _jtreelistview: JObject);
function jTreeListView_AddChild(env: PJNIEnv; _jtreelistview: JObject; _id: integer): integer;
procedure jTreeListView_SetNodeCaption(env: PJNIEnv; _jtreelistview: JObject; _id: integer; _caption: string);
function jTreeListView_GetNodeData(env: PJNIEnv; _jtreelistview: JObject; id: integer): string;
function jTreeListView_GetFirstChild(env: PJNIEnv; _jtreelistview: JObject; parent_id: integer): integer;
function jTreeListView_GetNextSibling(env: PJNIEnv; _jtreelistview: JObject; id :integer): integer;
function jTreeListView_GetNodeHasChildren(env: PJNIEnv; _jtreelistview: JObject; id :integer): boolean;
procedure jTreeListView_ToggleNode(env: PJNIEnv; _jtreelistview: JObject; id :integer);
procedure jTreeListView_SetFocusedNode(env: PJNIEnv; _jtreelistview: JObject; id :integer);
function jTreeListView_GetRootNode(env: PJNIEnv; _jtreelistview: JObject): integer;
function jTreeListView_GetParentNode(env: PJNIEnv; _jtreelistview: JObject; _id: integer): integer;

implementation

uses

   customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
   sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
   stoolbar, stablayout, snestedscrollview, sviewpager, framelayout{,And_log_h}  {for test};
//-----------------------------------------------------------------------------
//  For debug
//-----------------------------------------------------------------------------


procedure TreeViewList_Log (msg: string);
begin
  // __android_log_write(ANDROID_LOG_INFO, 'jTreeListView', PChar(msg));  //from  And_log_h
end;


{---------  jTreeListView  --------------}

constructor jTreeListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 96; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FLevels := 0;
  FFocusedNode:=0;
end;

destructor jTreeListView.Destroy;
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

procedure jTreeListView.TryNewParent(refApp: jApp);
begin
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end else
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end else
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end  else
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end else
  if FParent is jViewFlipper then
  begin
    jViewFlipper(FParent).Init(refApp);
    FjPRLayout:= jViewFlipper(FParent).View;
  end else
  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end  else
  if FParent is jsToolbar then
  begin
    jsToolbar(FParent).Init(refApp);
    FjPRLayout:= jsToolbar(FParent).View;
  end  else
  if FParent is jsCoordinatorLayout then
  begin
    jsCoordinatorLayout(FParent).Init(refApp);
    FjPRLayout:= jsCoordinatorLayout(FParent).View;
  end else
  if FParent is jFrameLayout then
  begin
    jFrameLayout(FParent).Init(refApp);
    FjPRLayout:= jFrameLayout(FParent).View;
  end else
  if FParent is jLinearLayout then
  begin
    jLinearLayout(FParent).Init(refApp);
    FjPRLayout:= jLinearLayout(FParent).View;
  end else
  if FParent is jsDrawerLayout then
  begin
    jsDrawerLayout(FParent).Init(refApp);
    FjPRLayout:= jsDrawerLayout(FParent).View;
  end  else
  if FParent is jsCardView then
  begin
      jsCardView(FParent).Init(refApp);
      FjPRLayout:= jsCardView(FParent).View;
  end else
  if FParent is jsAppBarLayout then
  begin
      jsAppBarLayout(FParent).Init(refApp);
      FjPRLayout:= jsAppBarLayout(FParent).View;
  end else
  if FParent is jsTabLayout then
  begin
      jsTabLayout(FParent).Init(refApp);
      FjPRLayout:= jsTabLayout(FParent).View;
  end else
  if FParent is jsCollapsingToolbarLayout then
  begin
      jsCollapsingToolbarLayout(FParent).Init(refApp);
      FjPRLayout:= jsCollapsingToolbarLayout(FParent).View;
  end else
  if FParent is jsNestedScrollView then
  begin
      jsNestedScrollView(FParent).Init(refApp);
      FjPRLayout:= jsNestedScrollView(FParent).View;
  end else
  if FParent is jsViewPager then
  begin
      jsViewPager(FParent).Init(refApp);
      FjPRLayout:= jsViewPager(FParent).View;
  end;
end;

procedure jTreeListView.Init(refApp: jApp);
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
    TryNewParent(refApp);
  end;

  FjPRLayoutHome:= FjPRLayout;
  jTreeListView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jTreeListView_SetId(FjEnv, FjObject, Self.Id);
  jTreeListView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jTreeListView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jTreeListView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jTreeListView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jTreeListView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jTreeListView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jTreeListView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jTreeListView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jTreeListView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jTreeListView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jTreeListView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jTreeListView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jTreeListView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jTreeListView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jTreeListView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jTreeListView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jTreeListView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jTreeListView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jTreeListView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jTreeListView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jTreeListView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jTreeListView.GenEvent_OnClickTreeViewItem(Obj: TObject; position: integer; caption: string);
begin
  if Assigned(FOnClickTreeViewItem) then
    FOnClickTreeViewItem(Obj, position, caption);
end;

procedure jTreeListView.GenEvent_OnLongClickTreeViewItem(Obj: TObject; position: integer; caption: string);
begin
  if Assigned(FOnLongClickTreeViewItem) then
    FOnLongClickTreeViewItem(Obj, position, caption);
end;

function jTreeListView.jCreate(): jObject;
begin
  //in designing component state: result value here...
   Result:= jTreeListView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jTreeListView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_jFree(FjEnv, FjObject);
end;

procedure jTreeListView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jTreeListView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTreeListView_GetParent(FjEnv, FjObject);
end;

procedure jTreeListView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jTreeListView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTreeListView_GetView(FjEnv, FjObject);
end;

procedure jTreeListView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jTreeListView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jTreeListView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTreeListView_GetLParamWidth(FjEnv, FjObject);
end;

function jTreeListView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTreeListView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jTreeListView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jTreeListView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jTreeListView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jTreeListView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jTreeListView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jTreeListView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jTreeListView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jTreeListView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_SetId(FjEnv, FjObject, _id);
end;

procedure jTreeListView.SetLevels(count: integer);
begin
  //in designing component state: set value here...
  FLevels := count;
  if FInitialized then
     jTreeListView_SetLevels(FjEnv, FjObject, FLevels);
end;

procedure jTreeListView.Clear;
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_Clear(FjEnv, FjObject);
end;

function jTreeListView.AddChild(AParent: integer): integer;
begin
  Result := -1;
  if FInitialized then
     Result:= jTreeListView_AddChild(FjEnv, FjObject, AParent);
end;

procedure jTreeListView.SetNodeCaption(id: integer; caption: string);
begin
  if FInitialized then
     jTreeListView_SetNodeCaption(FjEnv, FjObject, id, caption);
end;

function jTreeListView.GetNodeData(id: integer): string;
begin
  if FInitialized then
    Result := jTreeListView_GetNodeData(FjEnv, FjObject, id);
end;

function jTreeListView.GetFirstChild(parent_id: integer): integer;
begin
  if FInitialized then
    Result := jTreeListView_GetFirstChild(FjEnv, FjObject, parent_id);
end;

function jTreeListView.GetNextSibling(id :integer): integer;
begin
  if FInitialized then
    Result := jTreeListView_GetNextSibling(FjEnv, FjObject, id);
end;

function jTreeListView.GetNodeHasChildren(id: integer): boolean;
begin
  if FInitialized then
    Result := jTreeListView_GetNodeHasChildren(FjEnv, FjObject, id);
end;

procedure jTreeListView.ToggleNode(id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTreeListView_ToggleNode(FjEnv, FjObject, id);
end;

procedure jTreeListView.SetFocusedNode(id: integer);
begin
  //in designing component state: set value here...
  FFocusedNode := id;
  if FInitialized then
     jTreeListView_SetFocusedNode(FjEnv, FjObject, FFocusedNode);
end;

function jTreeListView.GetRootNode: integer;
begin
  if FInitialized then
    Result := jTreeListView_GetRootNode(FjEnv, FjObject);
end;

function jTreeListView.GetParentNode(id: integer): integer;
begin
  if FInitialized then
    Result := jTreeListView_GetParentNode(FjEnv, FjObject, id);
end;

{-------- jTreeListView_JNI_Bridge ----------}

function jTreeListView_jCreate(env: PJNIEnv; _Self: int64; this: JObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTreeListView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jTreeListView_jFree(env: PJNIEnv; _jtreelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetViewParent(env: PJNIEnv; _jtreelistview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jTreeListView_GetParent(env: PJNIEnv; _jtreelistview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_RemoveFromViewParent(env: PJNIEnv; _jtreelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jTreeListView_GetView(env: PJNIEnv; _jtreelistview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetLParamWidth(env: PJNIEnv; _jtreelistview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetLParamHeight(env: PJNIEnv; _jtreelistview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jTreeListView_GetLParamWidth(env: PJNIEnv; _jtreelistview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jTreeListView_GetLParamHeight(env: PJNIEnv; _jtreelistview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetLGravity(env: PJNIEnv; _jtreelistview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetLWeight(env: PJNIEnv; _jtreelistview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtreelistview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_AddLParamsAnchorRule(env: PJNIEnv; _jtreelistview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_AddLParamsParentRule(env: PJNIEnv; _jtreelistview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetLayoutAll(env: PJNIEnv; _jtreelistview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_ClearLayoutAll(env: PJNIEnv; _jtreelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTreeListView_SetId(env: PJNIEnv; _jtreelistview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTreeListView_SetLevels(env: PJNIEnv; _jtreelistview: JObject; _count: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _count;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLevels', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTreeListView_Clear(env: PJNIEnv; _jtreelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jTreeListView_AddChild(env: PJNIEnv; _jtreelistview: JObject; _id: integer): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddChild', '(I)I');
  Result := env^.CallIntMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTreeListView_SetNodeCaption(env: PJNIEnv; _jtreelistview: JObject; _id: integer; _caption: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //TreeViewList_Log('Creating caption "'+_caption+'" for node '+IntToStr(_id));
  jParams[0].i:= _id;
  jParams[1].l:= env^.NewStringUTF(env, pchar(_caption) );
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNodeCaption', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
  env^.DeleteLocalRef(env, jParams[1].l);
end;

function jTreeListView_GetNodeData(env: PJNIEnv; _jtreelistview: JObject; id: integer): string;
var
  jParams: array[0..0] of jValue;
  _jString : jString;
  //_jBoolean: jBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  tmp: PChar;
begin
  jParams[0].i:= id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNodeData', '(I)Ljava/lang/String;');
  _jString := env^.CallObjectMethodA(env, _jtreelistview, jMethod, @jParams);
  case _jString = nil of
   True : Result    := '';
   False: begin
           //_jBoolean := JNI_False;
           tmp    := env^.GetStringUTFChars(env, _jString, nil);
           Result := AnsiString( tmp );                       // Hopefully this creates a copy!
           env^.ReleaseStringUTFChars(env, _jString, tmp);    // So now we can discard tmp   (see dalvik/vm/Jni.c)
           env^.DeleteLocalRef(env, _jString);                // and then the java.lang.String
          end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jTreeListView_GetFirstChild(env: PJNIEnv; _jtreelistview: JObject; parent_id: integer): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= parent_id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFirstChild', '(I)I');
  Result := env^.CallIntMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jTreeListView_GetNextSibling(env: PJNIEnv; _jtreelistview: JObject; id :integer): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNextSibling', '(I)I');
  Result := env^.CallIntMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jTreeListView_GetNodeHasChildren(env: PJNIEnv; _jtreelistview: JObject; id :integer): boolean;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  _jBoolean: jBoolean;
begin
  jParams[0].i:= id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNodeHasChildren', '(I)Z');
  _jBoolean := env^.CallBooleanMethodA(env, _jtreelistview, jMethod, @jParams);
  Result := Boolean(_jBoolean);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTreeListView_ToggleNode(env: PJNIEnv; _jtreelistview: JObject; id :integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'ToggleNode', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTreeListView_SetFocusedNode(env: PJNIEnv; _jtreelistview: JObject; id :integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFocusedNode', '(I)V');
  env^.CallVoidMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jTreeListView_GetRootNode(env: PJNIEnv; _jtreelistview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'RootNode', '()I');
  Result:= env^.CallIntMethod(env, _jtreelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jTreeListView_GetParentNode(env: PJNIEnv; _jtreelistview: JObject; _id: integer): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jtreelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParentNode', '(I)I');
  Result := env^.CallIntMethodA(env, _jtreelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.

