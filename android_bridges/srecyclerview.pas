unit srecyclerview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

Const
  ItemContentFormatArray: array  [0..6] of string =
    ('TEXT','IMAGE', 'CHECK', 'RATING', 'SWITCH', 'PANEL', 'PROGRESS');

type

  TItemContentFormat = (cfText, cfImage, cfCheck, cfRating, cfSwitch, cfPanel, cfProgress);

  TItemWidgetStatus = (wsNone, wsChecked);


  TRecyclerViewOnItemClick = procedure(Sender: TObject; itemPosition: integer) of object;

  TRecyclerViewOnItemWidgetClick = procedure(Sender: TObject; itemPosition: integer; widget: TItemContentFormat;
                                               widgetId: integer; status: TItemWidgetStatus) of object;

  TRecyclerViewOnItemWidgetTouch = procedure(Sender: TObject; itemPosition: integer; widget: TItemContentFormat;
                                               widgetId: integer) of object;

  TLayoutModel = (lmLinear, lmGrid, lmStaggeredGrid);
  TLayoutOrientation = (loVertical, loHorizontal);


{Draft Component code by "Lazarus Android Module Wizard" [12/21/2017 0:30:02]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

{ jsRecyclerView }

jsRecyclerView = class(jVisualControl)
 private
    FItemContentDelimiter: string;
    FItemContentFormat: TStringList; // IMAGE|TEXT|CHECK|TEXT|RATING|IMAGECHECK
    FLayoutModel: TLayoutModel;
    FLayoutOrientation: TLayoutOrientation;
    FColumns: integer;
    FFitsSystemWindows: boolean;

    FOnItemClick: TRecyclerViewOnItemClick;
    FOnItemLongClick: TRecyclerViewOnItemClick;

    FOnItemTouchUp: TRecyclerViewOnItemClick;
    FOnItemTouchDown: TRecyclerViewOnItemClick;

    FOnItemWidgetClick: TRecyclerViewOnItemWidgetClick;
    FOnItemWidgetLongClick: TRecyclerViewOnItemWidgetTouch;
    FOnItemWidgetTouchUp: TRecyclerViewOnItemWidgetTouch;
    FOnItemWidgetTouchDown: TRecyclerViewOnItemWidgetTouch;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh; overload;
    procedure Refresh( position : integer ); overload;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnRecyclerViewItemClick(Obj: TObject; itemIndex: integer);
    procedure GenEvent_OnRecyclerViewItemLongClick(Obj: TObject; itemIndex: integer);

    procedure GenEvent_OnRecyclerViewItemTouchUp(Obj: TObject; itemIndex: integer);
    procedure GenEvent_OnRecyclerViewItemTouchDown(Obj: TObject; itemIndex: integer);

    procedure GenEvent_OnRecyclerViewItemWidgetClick(Obj: TObject; itemIndex: integer;
                                                     widget: TItemContentFormat; widgetId: integer; status: TItemWidgetStatus);
    procedure GenEvent_OnRecyclerViewItemWidgetLongClick(Obj: TObject; itemIndex: integer;
                                                     widget: TItemContentFormat; widgetId: integer);
    procedure GenEvent_OnRecyclerViewItemWidgetTouchUp(Obj: TObject; itemIndex: integer;
                                                     widget: TItemContentFormat; widgetId: integer);
    procedure GenEvent_OnRecyclerViewItemWidgetTouchDown(Obj: TObject; itemIndex: integer;
                                                     widget: TItemContentFormat; widgetId: integer);

    function jCreate( _mode: integer; _direction: integer; _cols: integer): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;
    procedure SetLGravity(_gravity: TLayoutGravity);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetItemContentFormat(_delimitedContentFormat: string; _delimiter: string); overload;
    procedure SetItemContentFormat(_contentFormat: string); overload;
    procedure SetItemContentFormat(); overload;

    procedure Add(_delimitedContent: string);
    procedure Moved( fromPosition, toPosition : integer );
    procedure SetItemContentLayout(_itemViewLayout: jObject); overload;
    procedure SetItemContentLayout(_itemViewLayout: jObject; _forceCardStyle: boolean);  overload;
    procedure SetItemSeparatorColorHeight(_color: TARGBColorBridge; _height : single );
    procedure SetAppBarLayoutScrollingViewBehavior();
    procedure RemoveAll;
    procedure Remove(_position: integer);
    function  GetItemCount(): integer;
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetClipToPadding(_value: boolean);
    procedure AddItemContentFormat(cf: TItemContentFormat);
    procedure ClearItemContentFormat;

    procedure SetItemContentDelimiter(_delimiter: string);

    procedure SetWidgetText( position : integer; widget : TItemContentFormat; widgetId : integer; strText : string );
    function  GetWidgetText( position : integer; widget : TItemContentFormat; widgetId : integer ) : string;

    procedure SetWidgetPanelRound( position, widgetId, round : integer );
    procedure SetWidgetTextColor( position : integer; widget: TItemContentFormat; widgetId : integer; value: TARGBColorBridge );

    procedure SetItemsRound(round : integer);

    //cornerRadiusRound=0 not  Rounded!
    procedure SetItemBackgroundColor(position: integer; value: TARGBColorBridge;  cornerRadiusRound: integer);
    procedure SetCardBackgroundColor(value: TARGBColorBridge);

    procedure SetItemSelect( position :integer; select: integer);
    function  GetItemSelect( position :integer ) : integer;

    procedure SetItemTag( position :integer; tagString: string);
    function  GetItemTag( position :integer ) : string;
    function  GetItemsSelect() : integer;
    function  GetItemSelectFirst() : integer; overload;
    function  GetItemSelectFirst( _int : integer ) : integer; overload;
    procedure ClearItemsSelect;

    procedure ScrollToPosition( position :integer );
    procedure SmoothScrollToPosition( position :integer );

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property Model: TLayoutModel read FLayoutModel write FLayoutModel;
    property Orientation: TLayoutOrientation read FLayoutOrientation write FLayoutOrientation;
    property Columns: integer read FColumns write FColumns;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property OnItemClick: TRecyclerViewOnItemClick read FOnItemClick write FOnItemClick;
    property OnItemLongClick: TRecyclerViewOnItemClick read FOnItemLongClick write FOnItemLongClick; // By ADiV
    property OnItemTouchUp: TRecyclerViewOnItemClick read FOnItemTouchUp write FOnItemTouchUp;  // By ADiV
    property OnItemTouchDown: TRecyclerViewOnItemClick read FOnItemTouchDown write FOnItemTouchDown; // By ADiV
    property OnItemWidgetClick: TRecyclerViewOnItemWidgetClick read FOnItemWidgetClick write FOnItemWidgetClick;
    property OnItemWidgetLongClick: TRecyclerViewOnItemWidgetTouch read FOnItemWidgetLongClick write FOnItemWidgetLongClick; // By ADiV
    property OnItemWidgetTouchUp: TRecyclerViewOnItemWidgetTouch read FOnItemWidgetTouchUp write FOnItemWidgetTouchUp; // By ADiV
    property OnItemWidgetTouchDown: TRecyclerViewOnItemWidgetTouch read FOnItemWidgetTouchDown write FOnItemWidgetTouchDown; // By ADiV

end;

//function jsRecyclerView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
function jsRecyclerView_jCreate(env: PJNIEnv;_Self: int64; _mode: integer; _direction: integer; _cols: integer; this: jObject): jObject;
procedure jsRecyclerView_SetlayoutView(env: PJNIEnv; _jsrecyclerview: JObject; _itemViewLayout: jObject);
procedure jsRecyclerView_SetItemViewLayout(env: PJNIEnv; _jsrecyclerview: JObject; _itemViewLayout: jObject; _forceCardStyle: boolean);

implementation


{---------  jsRecyclerView  --------------}

constructor jsRecyclerView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
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
  FLayoutModel:= lmLinear;
  FLayoutOrientation:= loVertical;
  FColumns:= 1;
  FItemContentFormat:= TStringList.Create;
  FItemContentDelimiter:= '|';
  FItemContentFormat.Delimiter:='|';
  FItemContentFormat.StrictDelimiter:= True;
end;

destructor jsRecyclerView.Destroy;
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
  FItemContentFormat.Free;
  inherited Destroy;
end;

procedure jsRecyclerView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   //FjObject := jCreate(); if FjObject = nil then exit;
   FjObject:= jCreate(Ord(FLayoutModel), Ord(FLayoutOrientation), FColumns); //jSelf !

   if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;


   if FGravityInParent <> lgNone then
     SetLGravity(FGravityInParent);

   SetViewParent(FjPRLayout);
   jni_proc_i(FjEnv, FjObject, 'setId', Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jsRecyclerView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsRecyclerView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsRecyclerView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsRecyclerView.Refresh;
begin
  if FInitialized then
    jni_proc(FjEnv, FjObject, 'Refresh');
end;

procedure jsRecyclerView.Refresh( position : integer );
begin
  if FInitialized then
    jni_proc_i(FjEnv, FjObject, 'Refresh', position);
end;

//Event : Java -> Pascal

// Updated by ADiV
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemClick(Obj: TObject; itemIndex: integer);
begin
  if Assigned(FOnItemClick) then FOnItemClick(Obj, itemIndex);
end;

// By ADiV
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemLongClick(Obj: TObject; itemIndex: integer);
begin
  if Assigned(FOnItemLongClick) then FOnItemLongClick(Obj, itemIndex);
end;

// By ADiV
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemTouchUp(Obj: TObject; itemIndex: integer);
begin
  if Assigned(FOnItemTouchUp) then FOnItemTouchUp(Obj, itemIndex);
end;

// By ADiV
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemTouchDown(Obj: TObject; itemIndex: integer);
begin
  if Assigned(FOnItemTouchDown) then FOnItemTouchDown(Obj, itemIndex);
end;

// Updated by ADiV
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemWidgetClick(Obj: TObject; itemIndex: integer;
                                                 widget: TItemContentFormat; widgetId: integer; status: TItemWidgetStatus);
begin
  if Assigned(FOnItemWidgetClick) then FOnItemWidgetClick(Obj, itemIndex, widget, widgetId, status);
end;

// By [ADiV]
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemWidgetLongClick(Obj: TObject; itemIndex: integer;
                                                 widget: TItemContentFormat; widgetId: integer);
begin
  if Assigned(FOnItemWidgetLongClick) then FOnItemWidgetLongClick(Obj, itemIndex, widget, widgetId);
end;

// By [ADiV]
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemWidgetTouchUp(Obj: TObject; itemIndex: integer;
                                                 widget: TItemContentFormat; widgetId: integer);
begin
  if Assigned(FOnItemWidgetTouchUp) then FOnItemWidgetTouchUp(Obj, itemIndex, widget, widgetId);
end;

// By [ADiV]
procedure jsRecyclerView.GenEvent_OnRecyclerViewItemWidgetTouchDown(Obj: TObject; itemIndex: integer;
                                                 widget: TItemContentFormat; widgetId: integer);
begin
  if Assigned(FOnItemWidgetTouchDown) then FOnItemWidgetTouchDown(Obj, itemIndex, widget, widgetId);
end;

{
function jsRecyclerView.jCreate(): jObject;
begin
   Result:= jsRecyclerView_jCreate(FjEnv, int64(Self), FjThis);
end;
}
function jsRecyclerView.jCreate( _mode: integer; _direction: integer; _cols: integer): jObject;
begin
   Result:= jsRecyclerView_jCreate(FjEnv, int64(Self), _mode ,_direction ,_cols, FjThis);
end;

procedure jsRecyclerView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

procedure jsRecyclerView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_vig(FjEnv, FjObject, 'SetViewParent', _viewgroup);
end;

function jsRecyclerView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_vig(FjEnv, FjObject, 'GetParent');
end;

procedure jsRecyclerView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RemoveFromViewParent');
end;

function jsRecyclerView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_viw(FjEnv, FjObject, 'GetView');
end;

procedure jsRecyclerView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetLParamWidth', _w);
end;

procedure jsRecyclerView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetLParamHeight', _h);
end;

function jsRecyclerView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetLParamWidth');
end;

function jsRecyclerView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetLParamHeight');
end;

procedure jsRecyclerView.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'SetLGravity', Ord(FGravityInParent));
end;

procedure jsRecyclerView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_f(FjEnv, FjObject, 'SetLWeight', _w);
end;

procedure jsRecyclerView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsRecyclerView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'AddLParamsAnchorRule', _rule);
end;

procedure jsRecyclerView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'AddLParamsParentRule', _rule);
end;

procedure jsRecyclerView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'SetLayoutAll', _idAnchor);
end;

procedure jsRecyclerView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc(FjEnv, FjObject, 'ClearLayoutAll');

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          AddlParamsParentRule(GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsRecyclerView.SetItemContentFormat(_delimitedContentFormat: string; _delimiter: string);
begin
  //in designing component state: set value here...
  FItemContentDelimiter:= _delimiter;
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'SetItemContentDictionary', _delimitedContentFormat ,_delimiter);
end;

procedure jsRecyclerView.SetItemContentFormat(_contentFormat: string);
begin
   SetItemContentFormat(_contentFormat, FItemContentDelimiter);
end;

procedure jsRecyclerView.SetItemContentFormat();
begin
   if FItemContentFormat.Count > 0 then
     SetItemContentFormat(FItemContentFormat.DelimitedText, FItemContentFormat.Delimiter);
end;

procedure jsRecyclerView.Add(_delimitedContent: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'Add', _delimitedContent);
end;

procedure jsRecyclerView.SetItemContentLayout(_itemViewLayout: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsRecyclerView_SetlayoutView(FjEnv, FjObject, _itemViewLayout);
end;

procedure jsRecyclerView.SetItemContentLayout(_itemViewLayout: jObject; _forceCardStyle: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsRecyclerView_SetItemViewLayout(FjEnv, FjObject, _itemViewLayout ,_forceCardStyle);
end;

procedure jsRecyclerView.Moved( fromPosition, toPosition : integer );
begin
 //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(FjEnv, FjObject, 'Moved', fromPosition, toPosition );
end;

procedure jsRecyclerView.SetItemSeparatorColorHeight(_color: TARGBColorBridge; _height : single );
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_if(FjEnv, FjObject, 'SetItemSeparatorColorHeight', GetARGB(FCustomColor, _color), _height );
end;

procedure jsRecyclerView.SetAppBarLayoutScrollingViewBehavior();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'SetAppBarLayoutScrollingViewBehavior');
end;

procedure jsRecyclerView.RemoveAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RemoveAll');
end;

procedure jsRecyclerView.Remove(_position: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'Remove', _position);
end;

function jsRecyclerView.GetItemCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetItemCount');
end;

procedure jsRecyclerView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jni_proc_z(FjEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

procedure jsRecyclerView.SetClipToPadding(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(FjEnv, FjObject, 'SetClipToPadding', _value);
end;

procedure jsRecyclerView.SmoothScrollToPosition( position :integer );
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SmoothScrollToPosition', position );
end;

procedure jsRecyclerView.ScrollToPosition( position :integer );
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'ScrollToPosition', position );
end;

procedure jsRecyclerView.ClearItemsSelect;
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'ClearItemsSelect' );
end;

function jsRecyclerView.GetItemsSelect() : integer;
begin
 result := 0;
 //in designing component state: set value here...
 if FInitialized then
  result := jni_func_out_i(FjEnv, FjObject, 'GetItemsSelect');
end;

function jsRecyclerView.GetItemSelectFirst( _int : integer ) : integer;
begin
 result := -1;
 //in designing component state: set value here...
 if FInitialized then
  result := jni_func_i_out_i(FjEnv, FjObject, 'GetItemSelectFirst', _int);
end;

function jsRecyclerView.GetItemSelectFirst() : integer;
begin
 result := -1;
 //in designing component state: set value here...
 if FInitialized then
  result := jni_func_out_i(FjEnv, FjObject, 'GetItemSelectFirst');
end;

procedure jsRecyclerView.SetItemSelect( position :integer; select: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(FjEnv, FjObject, 'SetItemSelect', position, select);
end;

function jsRecyclerView.GetItemSelect( position :integer ) : integer;
begin
  result := 0;
  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_i_out_i(FjEnv, FjObject, 'GetItemSelect', position);
end;

procedure jsRecyclerView.SetItemTag( position :integer; tagString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_it(FjEnv, FjObject, 'SetItemTag', position, tagString);
end;

function jsRecyclerView.GetItemTag( position :integer ) : string;
begin
  Result := '';
  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_i_out_t(FjEnv, FjObject, 'GetItemTag', position);
end;

procedure jsRecyclerView.SetCardBackgroundColor(value: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetCardBackgroundColor', GetARGB(FCustomColor, value));
end;

procedure jsRecyclerView.SetItemsRound(round : integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetItemsRound', round);
end;

procedure jsRecyclerView.SetItemBackgroundColor(position: integer; value: TARGBColorBridge; cornerRadiusRound : integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_iii(FjEnv, FjObject, 'SetItemBackgroundColor', position, GetARGB(FCustomColor, value), cornerRadiusRound);
end;

function jsRecyclerView.GetWidgetText( position : integer; widget : TItemContentFormat; widgetId : integer ) : string;
begin
  result := '';

  if FInitialized then
   result := jni_func_iii_out_t(FjEnv, FjObject, 'GetWidgetText', position, ord(widget), widgetId);
end;

procedure jsRecyclerView.SetWidgetText( position : integer; widget : TItemContentFormat; widgetId : integer; strText : string );
begin
  if FInitialized then
     jni_proc_iiit(FjEnv, FjObject, 'SetWidgetText', position, ord(widget), widgetId, strText);
end;

procedure jsRecyclerView.SetWidgetPanelRound( position, widgetId, round : integer );
begin
  if FInitialized then
     jni_proc_iii(FjEnv, FjObject, 'SetWidgetPanelRound', position, widgetId, round);
end;

procedure jsRecyclerView.SetWidgetTextColor( position : integer; widget: TItemContentFormat; widgetId : integer; value: TARGBColorBridge );
begin
  if FInitialized then
     jni_proc_iiii(FjEnv, FjObject, 'SetWidgetTextColor', position, ord(widget), widgetId, GetARGB(FCustomColor, value));
end;

procedure jsRecyclerView.ClearItemContentFormat;
begin
  FItemContentFormat.Clear;
end;

procedure jsRecyclerView.AddItemContentFormat(cf: TItemContentFormat);
begin
  FItemContentFormat.Add(ItemContentFormatArray[Ord(cf)]);
end;

procedure jsRecyclerView.SetItemContentDelimiter(_delimiter: string);
begin
   FItemContentDelimiter:= _delimiter;
   FItemContentFormat.Delimiter:= _delimiter[1];
end;

{-------- jsRecyclerView_JNI_Bridge ----------}

function jsRecyclerView_jCreate(env: PJNIEnv;_Self: int64; _mode: integer; _direction: integer; _cols: integer; this: jObject): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].i:= _mode;
  jParams[2].i:= _direction;
  jParams[3].i:= _cols;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsRecyclerView_jCreate', '(JIII)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsRecyclerView_SetlayoutView(env: PJNIEnv; _jsrecyclerview: JObject; _itemViewLayout: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _itemViewLayout;
  jCls:= env^.GetObjectClass(env, _jsrecyclerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemViewLayout', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jsrecyclerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsRecyclerView_SetItemViewLayout(env: PJNIEnv; _jsrecyclerview: JObject; _itemViewLayout: jObject; _forceCardStyle: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _itemViewLayout;
  jParams[1].z:= JBool(_forceCardStyle);
  jCls:= env^.GetObjectClass(env, _jsrecyclerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemViewLayout', '(Landroid/view/View;Z)V');
  env^.CallVoidMethodA(env, _jsrecyclerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
