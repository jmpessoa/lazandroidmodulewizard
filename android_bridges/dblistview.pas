unit dblistview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

  TOnClickDBListItem = procedure(Sender: TObject; itemIndex: integer; itemCaption: string) of object;
  {Draft Component code by "Lazarus Android Module Wizard" [01/02/2018 11:13:51]}
  {https://github.com/jmpessoa/lazandroidmodulewizard}

  {jVisualControl template}

  { jDBListView -  thanks to Martin Lowry  !!! }
  jDBListView = class(jVisualControl)      // Anachronism, it's actually an Extended ListView
  private
    FOnClickDBListItem: TOnClickDBListItem;
    FOnLongClickDBListItem: TOnClickDBListItem;

    //FOnDrawItemTextColor: TOnDrawItemTextColor;
    //FOnDrawItemBitmap: TOnDrawItemBitmap;
    //FItemsLayout: TListItemLayout;
    FjSqliteCursor: jSqliteCursor;

    FColWeights: TStrings;

    procedure SetColor(Value: TARGBColorBridge); //background
    procedure SetColumnWeights(Value: TStrings);
    procedure SetCursor(Value: jSqliteCursor);
    procedure SetFontColor(_color: TARGBColorBridge);
    procedure SetFontSize(_size: DWord);
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetVisible(Value: boolean);
    
  protected
    FjPRLayoutHome: jObject; //Save parent origin
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClickDBListItem(Obj: TObject; position: integer);
    procedure GenEvent_OnLongClickDBListItem(Obj: TObject; position: integer);
    function jCreate(): jObject;
    procedure jFree();
    function GetParent(): jObject;
    function GetView(): jObject; override;
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent(); override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure setLGravity(_g: integer);
    procedure setLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer;
      _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure UpdateView;
    //procedure SetItemsLayout(_value: integer);
    function GetItemIndex(): integer;
    function GetItemCaption(): string;
    procedure SetSelection(_index: integer);
    //procedure DispatchOnDrawItemTextColor(_value: boolean);
    //procedure DispatchOnDrawItemBitmap(_value: boolean);
    procedure ChangeCursor(NewCursor: jSqliteCursor);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ColumnWeights: TStrings read FColWeights write SetColumnWeights;
    property DataSource: jSqliteCursor read FjSqliteCursor write SetCursor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;

    property OnClickItem: TOnClickDBListItem read FOnClickDBListItem write FOnClickDBListItem;
    property OnLongClickItem: TOnClickDBListItem read FOnLongClickDBListItem write FOnLongClickDBListItem;
  end;

function jDBListView_jCreate(env: PJNIEnv; _Self: int64; this: JObject): jObject;
procedure jDBListView_jFree(env: PJNIEnv; _jdblistview: JObject);
function jDBListView_GetView(env: PJNIEnv; _jdblistview: JObject): jObject;
procedure jDBListView_SetViewParent(env: PJNIEnv; _jdblistview: JObject; _viewgroup: jObject);
procedure jDBListView_RemoveFromViewParent(env: PJNIEnv; _jdblistview: JObject);
function jDBListView_GetParent(env: PJNIEnv; _jdblistview: JObject): jObject;
procedure jDBListView_SetLParamWidth(env: PJNIEnv; _jdblistview: JObject; _w: integer);
procedure jDBListView_SetLParamHeight(env: PJNIEnv; _jdblistview: JObject; _h: integer);
procedure jDBListView_setLGravity(env: PJNIEnv; _jdblistview: JObject; _g: integer);
procedure jDBListView_setLWeight(env: PJNIEnv; _jdblistview: JObject; _w: single);
procedure jDBListView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv;
  _jdblistview: JObject; _left: integer; _top: integer; _right: integer;
  _bottom: integer; _w: integer; _h: integer);
procedure jDBListView_AddLParamsAnchorRule(env: PJNIEnv; _jdblistview: JObject;
  _rule: integer);
procedure jDBListView_AddLParamsParentRule(env: PJNIEnv; _jdblistview: JObject;
  _rule: integer);
procedure jDBListView_SetLayoutAll(env: PJNIEnv; _jdblistview: JObject; _idAnchor: integer);
procedure jDBListView_ClearLayoutAll(env: PJNIEnv; _jdblistview: JObject);
procedure jDBListView_SetId(env: PJNIEnv; _jdblistview: JObject; _id: integer);
procedure jDBListView_UpdateView(env: PJNIEnv; _jdblistview: JObject);
procedure jDBListView_SetItemsLayout(env: PJNIEnv; _jdblistview: JObject; _value: integer);
function jDBListView_GetItemIndex(env: PJNIEnv; _jdblistview: JObject): integer;
function jDBListView_GetItemCaption(env: PJNIEnv; _jdblistview: JObject): string;
procedure jDBListView_SetSelection(env: PJNIEnv; _jdblistview: JObject; _index: integer);
procedure jDBListView_DispatchOnDrawItemTextColor(env: PJNIEnv;
  _jdblistview: JObject; _value: boolean);
procedure jDBListView_DispatchOnDrawItemBitmap(env: PJNIEnv; _jdblistview: JObject;
  _value: boolean);
procedure jDBListView_SetFontSize(env: PJNIEnv; _jdblistview: JObject; _size: integer);
procedure jDBListView_SetFontColor(env: PJNIEnv; _jdblistview: JObject; _color: integer);
procedure jDBListView_SetFontSizeUnit(env: PJNIEnv; _jdblistview: JObject; _unit: integer);

procedure jDBListView_ChangeCursor(env: PJNIEnv; _jdblistview: JObject; Cursor: jObject);
procedure jDBListView_SetColumnWeights(env:PJNIEnv; _jdblistview: jObject; _value: TDynArrayOfSingle);
procedure DBListView_Log (msg: string);

implementation

//-----------------------------------------------------------------------------
//  For debug
//-----------------------------------------------------------------------------
procedure DBListView_Log (msg: string);
begin
  //__android_log_write(ANDROID_LOG_INFO, 'jDBListView', Pchar(msg));
end;

{---------  jDBListView  --------------}

constructor jDBListView.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft := 10;
  FMarginTop := 10;
  FMarginBottom := 10;
  FMarginRight := 10;
  FLParamWidth := lpMatchParent;
  FLParamHeight := lpMatchParent;
  FHeight := 160; //??
  FWidth := 96; //??
  FAcceptChildrenAtDesignTime := False;
  //your code here....
  FColWeights:= TStringList.Create;
  FjSqliteCursor := nil;
end;

destructor jDBListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jFree();
      FjObject := nil;
    end;
  end;
  //you others free code here...'
  if FjSqliteCursor <> nil then
    FjSqliteCursor.UnRegisterObserver(self);
  FColWeights.Free;
  inherited Destroy;
end;

procedure jDBListView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  i: integer;
  weights: TDynArrayOfSingle;
begin
  if not FInitialized then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate();  //jSelf !

   if FFontColor <> colbrDefault then
    jDBListView_setFontColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

   if FFontSizeUnit <> unitDefault then
    jDBListView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

   if FFontSize > 0 then
    jDBListView_setFontSize(FjEnv, FjObject , FFontSize);

   if FColWeights.Count > 0 then
   begin
    SetLength(weights, FColWeights.Count);
    for i := 0 to FColWeights.Count-1 do
      weights[i] := StrToFloat(FColWeights[i]);
    jDBListView_SetColumnWeights(FjEnv, FjObject, weights);
   end;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jDBListView_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jDBListView_SetId(FjEnv, FjObject, Self.Id);
  end;

  jDBListView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));


  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jDBListView_AddLParamsAnchorRule(FjEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jDBListView_AddLParamsParentRule(FjEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then
    Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1; //dummy

  jDBListView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   
   if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jDBListView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jDBListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FjSqliteCursor then
      begin
        FjSqliteCursor:= nil;
      end
  end;
end;

procedure jDBListView.SetColumnWeights(Value: TStrings);
var
  i: integer;
  weights: TDynArrayOfSingle;
begin
  FColWeights.Assign(Value);

  if FInitialized and (Value.Count <> 0) then
  begin
    SetLength(weights, Value.Count);
    for i := 0 to Value.Count-1 do
      weights[i] := StrToFloat(Value[i]);
    jDBListView_SetColumnWeights(FjEnv, FjObject, weights);
  end;
end;

procedure jDBListView.SetCursor(Value: jSqliteCursor);
begin
  //DBListView_Log ('Entering SetCursor ...');
  if Value <> FjSqliteCursor then
  begin
    if Assigned(FjSqliteCursor) then
    begin
      //DBListView_Log ('... phase 1 ...');
      FjSqliteCursor.UnRegisterObserver(Self);
      FjSqliteCursor.RemoveFreeNotification(Self); //remove free notification...
    end;
    //DBListView_Log ('... phase 2 ...');
    FjSqliteCursor:= Value;
    if Value <> nil then  //re- add free notification...
    begin
      //DBListView_Log ('... phase 3 ...');
      Value.RegisterObserver(self);
      Value.FreeNotification(self);
      ChangeCursor(Value);
    end;
  end;
  //DBListView_Log ('Exiting SetCursor');
end;

procedure jDBListView.SetVisible(Value: boolean);
begin
  FVisible := Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jDBListView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jDBListView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jDBListView.GenEvent_OnClickDBListItem(Obj: TObject; position: integer);
begin
  if Assigned(FOnClickDBListItem) then
    FOnClickDBListItem(Obj, position, '');
end;

procedure jDBListView.GenEvent_OnLongClickDBListItem(Obj: TObject; position: integer);
begin
  if Assigned(FOnLongClickDBListItem) then
    FOnLongClickDBListItem(Obj, position, '');
end;

function jDBListView.jCreate(): jObject;
begin
  //in designing component state: result value here...
  Result := jDBListView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jDBListView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_jFree(FjEnv, FjObject);
end;

function jDBListView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jDBListView_GetView(FjEnv, FjObject);
end;

procedure jDBListView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jDBListView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jDBListView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jDBListView_GetParent(FjEnv, FjObject);
end;

procedure jDBListView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jDBListView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jDBListView.setLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_setLGravity(FjEnv, FjObject, _g);
end;

procedure jDBListView.setLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_setLWeight(FjEnv, FjObject, _w);
end;

procedure jDBListView.SetLeftTopRightBottomWidthHeight(_left: integer;
  _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
      _left, _top, _right, _bottom, _w, _h);
end;

procedure jDBListView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jDBListView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jDBListView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jDBListView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jDBListView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jDBListView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jDBListView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jDBListView.UpdateView();
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_UpdateView(FjEnv, FjObject);
end;
(*
procedure jDBListView.SetItemsLayout(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetItemsLayout(FjEnv, FjObject, _value);
end;
*)
function jDBListView.GetItemIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jDBListView_GetItemIndex(FjEnv, FjObject);
end;

function jDBListView.GetItemCaption(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jDBListView_GetItemCaption(FjEnv, FjObject);
end;

procedure jDBListView.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetSelection(FjEnv, FjObject, _index);
end;
(*
procedure jDBListView.DispatchOnDrawItemTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_DispatchOnDrawItemTextColor(FjEnv, FjObject, _value);
end;

procedure jDBListView.DispatchOnDrawItemBitmap(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_DispatchOnDrawItemBitmap(FjEnv, FjObject, _value);
end;
*)
procedure jDBListView.SetFontSize(_size: DWord);
begin
  //in designing component state: set value here...
  FFontSize := _size;
  if FInitialized then
    jDBListView_SetFontSize(FjEnv, FjObject, _size);
end;

procedure jDBListView.SetFontColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontColor := _color;
  if FInitialized then
    jDBListView_SetFontColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jDBListView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FInitialized then
    jDBListView_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jDBListView.ChangeCursor(NewCursor: jSqliteCursor);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_ChangeCursor(FjEnv, FjObject, NewCursor.Cursor);
end;

{-------- jDBListView_JNI_Bridge ----------}

function jDBListView_jCreate(env: PJNIEnv; _Self: int64; this: JObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].j := _Self;
  jCls := Get_gjClass(env);
  jMethod := env^.GetMethodID(env, jCls, 'jDBListView_jCreate', '(J)Ljava/lang/Object;');
  Result := env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result := env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jDBListView_jCreate(long _Self) {
  return (java.lang.Object)(new class(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jDBListView_jFree(env: PJNIEnv; _jdblistview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDBListView_GetView(env: PJNIEnv; _jdblistview: JObject): jObject;
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result := env^.CallObjectMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetViewParent(env: PJNIEnv; _jdblistview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].l := _viewgroup;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_RemoveFromViewParent(env: PJNIEnv; _jdblistview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDBListView_GetParent(env: PJNIEnv; _jdblistview: JObject): jObject;
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result := env^.CallObjectMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetLParamWidth(env: PJNIEnv; _jdblistview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _w;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetLParamHeight(env: PJNIEnv; _jdblistview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _h;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_setLGravity(env: PJNIEnv; _jdblistview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _g;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'setLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_setLWeight(env: PJNIEnv; _jdblistview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].f := _w;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'setLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv;
  _jdblistview: JObject; _left: integer; _top: integer; _right: integer;
  _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _left;
  jParams[1].i := _top;
  jParams[2].i := _right;
  jParams[3].i := _bottom;
  jParams[4].i := _w;
  jParams[5].i := _h;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_AddLParamsAnchorRule(env: PJNIEnv; _jdblistview: JObject;
  _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _rule;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_AddLParamsParentRule(env: PJNIEnv; _jdblistview: JObject;
  _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _rule;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetLayoutAll(env: PJNIEnv; _jdblistview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _idAnchor;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_ClearLayoutAll(env: PJNIEnv; _jdblistview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetId(env: PJNIEnv; _jdblistview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _id;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_UpdateView(env: PJNIEnv; _jdblistview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'UpdateView', '()V');
  env^.CallVoidMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetNumColumns(env: PJNIEnv; _jdblistview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _value;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetNumColumns', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetColumnWidth(env: PJNIEnv; _jdblistview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _value;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetColumnWidth', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetItemsLayout(env: PJNIEnv; _jdblistview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _value;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetItemsLayout', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jDBListView_GetItemIndex(env: PJNIEnv; _jdblistview: JObject): integer;
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'GetItemIndex', '()I');
  Result := env^.CallIntMethod(env, _jdblistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDBListView_GetItemCaption(env: PJNIEnv; _jdblistview: JObject): string;
begin
  Result:= jni_func_out_t(env, _jdblistview, 'GetItemCaption');
end;


procedure jDBListView_SetSelection(env: PJNIEnv; _jdblistview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _index;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetSelection', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDBListView_DispatchOnDrawItemTextColor(env: PJNIEnv;
  _jdblistview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].z := JBool(_value);
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'DispatchOnDrawItemTextColor', '(Z)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_DispatchOnDrawItemBitmap(env: PJNIEnv; _jdblistview: JObject;
  _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].z := JBool(_value);
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'DispatchOnDrawItemBitmap', '(Z)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDBListView_SetFontSize(env: PJNIEnv; _jdblistview: JObject; _size: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _size;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetFontSize', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDBListView_SetFontSizeUnit(env: PJNIEnv; _jdblistview: JObject; _unit: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _unit;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDBListView_SetFontColor(env: PJNIEnv; _jdblistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _color;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetFontColor', '(I)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDBListView_ChangeCursor(env:PJNIEnv; _jdblistview: jObject; Cursor: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].l:= Cursor;
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetCursor', '(Landroid/database/Cursor;)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDBListView_SetColumnWeights(env:PJNIEnv; _jdblistview: jObject; _value: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_value);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0, newSize0, @_value[0] {source});
  jParams[0].l:= jNewArray0;
  //DBListView_Log('Calling SetColumnWeights ... (last=' + FloatToStr(_value[newSize0-1]) + ')');
  jCls := env^.GetObjectClass(env, _jdblistview);
  jMethod := env^.GetMethodID(env, jCls, 'SetColumnWeights', '([F)V');
  env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
