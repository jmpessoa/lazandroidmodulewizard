unit expandablelistview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

  TOnGroupItemExpand = procedure(Sender: TObject;  groupItemPosition: integer; groupItemHeader: string) of object;
  TOnGroupItemCollapse = procedure(Sender: TObject;  groupItemPosition: integer; groupItemHeader: string) of object;
  TOnOnChildItemClick = procedure(Sender: TObject;  groupItemPosition: integer; groupItemHeader: string; childItemPosition: integer; childItemCaption: string) of object;

{Draft Component code by "Lazarus Android Module Wizard" [10/16/2017 23:51:06]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jExpandableListView = class(jVisualControl)
 private
    FItems: TStrings;

    FGroupItemDelimiter: string;
    FChildItemDelimiter: string;

    FOnGroupItemExpand: TOnGroupItemExpand;
    FOnGroupItemCollapse: TOnGroupItemCollapse;
    FOnOnChildItemClick: TOnOnChildItemClick;

    FFontChildColor: TARGBColorBridge;
    FFontChildSize: DWord;
    FTextAlign: TTextAlign;
    FTextChildAlign: TTextAlign;
    FTextChildTypeFace: TTextTypeFace;
    FBackgroundChildColor: TARGBColorBridge;
    FImageItemIdentifier: string;
    FImageChildItemIdentifier: string;
    FHighLightSelectedChildItemColor: TARGBColorBridge;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
    Procedure SetFontColor(_color: TARGBColorBridge);
    procedure SetFontChildColor(_color: TARGBColorBridge);
    procedure SetTextAlign(_align: TTextAlign);
    procedure SetTextChildAlign(_align: TTextAlign);
    procedure SetFontFace(_fontFace: TFontFace);
    procedure SetTextTypeFace(_typeface: TTextTypeFace);
    procedure SetTextChildTypeFace(_typeface: TTextTypeFace);
    procedure SetBackgroundChild(_color: TARGBColorBridge);
    procedure SetHighLightSelectedChildItemColor(_color: TARGBColorBridge);
    procedure SetItems(Value: TStrings);
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject;  override;
    procedure RemoveFromViewParent();  override;
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
    
    procedure Add(_header: string; _delimitedChildItems: string); overload;
    procedure Add(_delimitedItem: string; _headerDelimiter: string; _childInnerDelimiter: string); overload;

    procedure SetGroupItemDelimiter(_itemGroupDelimiter: string);
    procedure SetChildItemDelimiter(_itemChildDelimiter: string);

    procedure SetFontColorAll(_color: TARGBColorBridge);
    procedure SetFontChildColorAll(_color: TARGBColorBridge);

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetFontSize(_fontSize: DWord);
    procedure SetFontChildSize(_fontSize: DWord);
    procedure SetImageItemIdentifier(_imageResIdentifier: string);
    procedure SetImageChildItemIdentifier(_imageResIdentifier: string);
    procedure Clear();
    procedure ClearChildren(_groupPosition: integer);
    procedure ClearGroup(_groupPosition: integer);


    procedure GenEvent_OnGroupExpand(Obj: TObject;  groupPosition: integer; groupHeader: string);
    procedure GenEvent_OnGroupCollapse(Obj: TObject;  groupPosition: integer; groupHeader: string);
    procedure GenEvent_OnChildClick(Obj: TObject;  groupPosition: integer; groupHeader: string; childItemPosition: integer; childItemCaption: string);

 published
    property Items: TStrings read FItems write SetItems;

    property GroupItemDelimiter: string read FGroupItemDelimiter write SetGroupItemDelimiter;
    property ChildItemDelimiter: string read FChildItemDelimiter write SetChildItemDelimiter;

    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property BackgroundChildColor: TARGBColorBridge  read FBackgroundChildColor write SetBackgroundChild default colbrDefault;

    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontChildColor: TARGBColorBridge read FFontChildColor write SetFontChildColor;
    property FontSize: DWord read FFontSize  write SetFontSize;
    property FontChildSize: DWord read FFontChildSize  write SetFontChildSize;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property TextChildAlign: TTextAlign read FTextChildAlign write SetTextChildAlign;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace default tfNormal;
    property TextChildTypeFace: TTextTypeFace read FTextChildTypeFace write SetTextChildTypeFace default tfNormal;

    property ImageItemIdentifier: string read FImageItemIdentifier write SetImageItemIdentifier;
    property ImageChildItemIdentifier: string read FImageChildItemIdentifier write SetImageChildItemIdentifier;

    property HighLightSelectedChildItemColor: TARGBColorBridge  read FHighLightSelectedChildItemColor write SetHighLightSelectedChildItemColor;

    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnGroupItemExpand: TOnGroupItemExpand read FOnGroupItemExpand write FOnGroupItemExpand;
    property OnGroupItemCollapse: TOnGroupItemCollapse read FOnGroupItemCollapse write FOnGroupItemCollapse;
    property OnOnChildItemClick: TOnOnChildItemClick read FOnOnChildItemClick write FOnOnChildItemClick;

end;

function jExpandableListView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jExpandableListView_jFree(env: PJNIEnv; _jexpandablelistview: JObject);
procedure jExpandableListView_SetViewParent(env: PJNIEnv; _jexpandablelistview: JObject; _viewgroup: jObject);
function jExpandableListView_GetParent(env: PJNIEnv; _jexpandablelistview: JObject): jObject;
procedure jExpandableListView_RemoveFromViewParent(env: PJNIEnv; _jexpandablelistview: JObject);
function jExpandableListView_GetView(env: PJNIEnv; _jexpandablelistview: JObject): jObject;
procedure jExpandableListView_SetLParamWidth(env: PJNIEnv; _jexpandablelistview: JObject; _w: integer);
procedure jExpandableListView_SetLParamHeight(env: PJNIEnv; _jexpandablelistview: JObject; _h: integer);
function jExpandableListView_GetLParamWidth(env: PJNIEnv; _jexpandablelistview: JObject): integer;
function jExpandableListView_GetLParamHeight(env: PJNIEnv; _jexpandablelistview: JObject): integer;
procedure jExpandableListView_SetLGravity(env: PJNIEnv; _jexpandablelistview: JObject; _g: integer);
procedure jExpandableListView_SetLWeight(env: PJNIEnv; _jexpandablelistview: JObject; _w: single);
procedure jExpandableListView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jexpandablelistview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jExpandableListView_AddLParamsAnchorRule(env: PJNIEnv; _jexpandablelistview: JObject; _rule: integer);
procedure jExpandableListView_AddLParamsParentRule(env: PJNIEnv; _jexpandablelistview: JObject; _rule: integer);
procedure jExpandableListView_SetLayoutAll(env: PJNIEnv; _jexpandablelistview: JObject; _idAnchor: integer);
procedure jExpandableListView_ClearLayoutAll(env: PJNIEnv; _jexpandablelistview: JObject);
procedure jExpandableListView_SetId(env: PJNIEnv; _jexpandablelistview: JObject; _id: integer);

procedure jExpandableListView_Add(env: PJNIEnv; _jexpandablelistview: JObject; _header: string; _delimitedItems: string); overload;
procedure jExpandableListView_Add(env: PJNIEnv; _jexpandablelistview: JObject; _delimitedItem: string; _headerDelimiter: string; _childInnerDelimiter: string); overload;

procedure jExpandableListView_SetItemHeaderDelimiter(env: PJNIEnv; _jexpandablelistview: JObject; _itemHeaderDelimiter: string);
procedure jExpandableListView_SetItemChildInnerDelimiter(env: PJNIEnv; _jexpandablelistview: JObject; _itemChildInnerDelimiter: string);
procedure jExpandableListView_SetFontColor(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
procedure jExpandableListView_SetFontChildColor(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
procedure jExpandableListView_SetFontColorAll(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
procedure jExpandableListView_SetFontChildColorAll(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
procedure jExpandableListView_SetFontSizeUnit(env: PJNIEnv; _jexpandablelistview: JObject; _unit: integer);
procedure jExpandableListView_SetFontSize(env: PJNIEnv; _jexpandablelistview: JObject; _fontSize: integer);
procedure jExpandableListView_SetFontChildSize(env: PJNIEnv; _jexpandablelistview: JObject; _fontSize: integer);
procedure jExpandableListView_SetTextAlign(env: PJNIEnv; _jexpandablelistview: JObject; _align: integer);
procedure jExpandableListView_SetTextChildAlign(env: PJNIEnv; _jexpandablelistview: JObject; _align: integer);
procedure jExpandableListView_SetFontFace(env: PJNIEnv; _jexpandablelistview: JObject; _fontFace: integer);
procedure jExpandableListView_SetTextTypeFace(env: PJNIEnv; _jexpandablelistview: JObject; _typeface: integer);
procedure jExpandableListView_SetTextChildTypeFace(env: PJNIEnv; _jexpandablelistview: JObject; _typeface: integer);
procedure jExpandableListView_SetBackgroundChild(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
procedure jExpandableListView_SetImageItemIdentifier(env: PJNIEnv; _jexpandablelistview: JObject; _imageResIdentifier: string);
procedure jExpandableListView_SetImageChildItemIdentifier(env: PJNIEnv; _jexpandablelistview: JObject; _imageResIdentifier: string);
procedure jExpandableListView_SetHighLightSelectedChildItemColor(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
procedure jExpandableListView_Clear(env: PJNIEnv; _jexpandablelistview: JObject);
procedure jExpandableListView_ClearChildren(env: PJNIEnv; _jexpandablelistview: JObject; _groupPosition: integer);
procedure jExpandableListView_ClearGroup(env: PJNIEnv; _jexpandablelistview: JObject; _groupPosition: integer);


implementation

{---------  jExpandableListView  --------------}

constructor jExpandableListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FHeight       := 96; //??
  FWidth        := 200; //??

  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;

  FItems:= TStringList.Create();

  FGroupItemDelimiter:= '$';
  FChildItemDelimiter:= ';';

  FTextAlign:= alLeft;
  FTextChildAlign:= alLeft;

  FFontChildColor:= colbrDefault;
  FBackgroundChildColor:= colbrDefault;
  FHighLightSelectedChildItemColor:= colbrDefault;

end;

destructor jExpandableListView.Destroy;
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
  FItems.Free;
  inherited Destroy;
end;

procedure jExpandableListView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  i: integer;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate(); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   FjPRLayoutHome:= FjPRLayout;

   jExpandableListView_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jExpandableListView_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  jExpandableListView_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jExpandableListView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jExpandableListView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if not FInitialized then
  begin
   if FFontSizeUnit <> unitDefault then
    jExpandableListView_SetFontSizeUnit(gApp.jni.jEnv, FjObject, Ord(FFontSizeUnit));

   if FFontSize > 0 then
    jExpandableListView_SetFontSize(gApp.jni.jEnv, FjObject , FFontSize);

   if FFontColor <> colbrDefault  then
    jExpandableListView_SetFontColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FFontColor));

   if FFontChildColor <> colbrDefault  then
    jExpandableListView_SetFontChildColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FFontChildColor));

   if FBackgroundChildColor <>  colbrDefault then
     jExpandableListView_SetBackgroundChild(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FBackgroundChildColor));

   if FTextAlign <> alLeft then
    jExpandableListView_SetTextAlign(gApp.jni.jEnv, FjObject, Ord(FTextAlign));

   if FTextChildAlign <> alLeft then
    jExpandableListView_SetTextChildAlign(gApp.jni.jEnv, FjObject, Ord(FTextChildAlign));

   if FFontFace <> ffNormal then
    jExpandableListView_SetFontFace(gApp.jni.jEnv, FjObject, Ord(FFontFace));

   if FTextTypeFace <> tfNormal then
    jExpandableListView_SetTextTypeFace(gApp.jni.jEnv, FjObject, Ord(FTextTypeFace));

   if FImageItemIdentifier <> '' then
    jExpandableListView_SetImageItemIdentifier(gApp.jni.jEnv, FjObject, FImageItemIdentifier);

   if FImageChildItemIdentifier <> '' then
    jExpandableListView_SetImageChildItemIdentifier(gApp.jni.jEnv, FjObject, FImageChildItemIdentifier);

   if FHighLightSelectedChildItemColor <> colbrDefault then
      jExpandableListView_SetHighLightSelectedChildItemColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FHighLightSelectedChildItemColor));

   for i:= 0 to FItems.Count - 1 do
   begin
    if FItems.Strings[i] <> '' then
         jExpandableListView_Add(gApp.jni.jEnv, FjObject , FItems.Strings[i], FGroupItemDelimiter, FChildItemDelimiter);
   end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jExpandableListView_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jExpandableListView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jExpandableListView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jExpandableListView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jExpandableListView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jExpandableListView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jExpandableListView.jCreate(): jObject;
begin
   Result:= jExpandableListView_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jExpandableListView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jExpandableListView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jExpandableListView.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jExpandableListView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jExpandableListView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jExpandableListView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jExpandableListView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jExpandableListView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jExpandableListView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jExpandableListView.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jExpandableListView_SetLGravity(gApp.jni.jEnv, FjObject, Ord(_gravity));
end;

procedure jExpandableListView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jExpandableListView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jExpandableListView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jExpandableListView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jExpandableListView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jExpandableListView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jExpandableListView_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jExpandableListView_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jExpandableListView_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

Procedure jExpandableListView.SetFontColor(_color: TARGBColorBridge);
begin
  FFontColor:= _color;
  if (FInitialized = True) and (FFontColor <> colbrDefault ) then
      jExpandableListView_SetFontColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jExpandableListView.SetFontChildColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontChildColor := _color;
  if (FInitialized = True) and (FFontColor <> colbrDefault ) then
     jExpandableListView_SetFontChildColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FFontChildColor));
end;

procedure jExpandableListView.SetItems(Value: TStrings);
var
  i: integer;
begin
  FItems.Assign(Value);

  if FInitialized then
  begin
    for i:= 0 to FItems.Count - 1 do
    begin
       if FItems.Strings[i] <> '' then
         jExpandableListView_Add(gApp.jni.jEnv, FjObject , FItems.Strings[i], FGroupItemDelimiter, FChildItemDelimiter);
    end;
  end;

end;

procedure jExpandableListView.Add(_header: string; _delimitedChildItems: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_Add(gApp.jni.jEnv, FjObject, _header , _delimitedChildItems);
end;

procedure jExpandableListView.Add(_delimitedItem: string; _headerDelimiter: string; _childInnerDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_Add(gApp.jni.jEnv, FjObject, _delimitedItem ,_headerDelimiter , _childInnerDelimiter);
end;

procedure jExpandableListView.SetGroupItemDelimiter(_itemGroupDelimiter: string);
begin
  //in designing component state: set value here...
  FGroupItemDelimiter:=  _itemGroupDelimiter;
  if FInitialized then
     jExpandableListView_SetItemHeaderDelimiter(gApp.jni.jEnv, FjObject, _itemGroupDelimiter);
end;

procedure jExpandableListView.SetChildItemDelimiter(_itemChildDelimiter: string);
begin
  //in designing component state: set value here...
  FChildItemDelimiter:= _itemChildDelimiter;
  if FInitialized then
     jExpandableListView_SetItemChildInnerDelimiter(gApp.jni.jEnv, FjObject, _itemChildDelimiter);
end;

procedure jExpandableListView.SetFontColorAll(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetFontColorAll(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jExpandableListView.SetFontChildColorAll(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetFontChildColorAll(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jExpandableListView.SetBackgroundChild(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FBackgroundChildColor:= _color;
  if FInitialized then
     jExpandableListView_SetBackgroundChild(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FBackgroundChildColor));
end;

procedure jExpandableListView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jExpandableListView_SetFontSizeUnit(gApp.jni.jEnv, FjObject, Ord(_unit) );
end;

procedure jExpandableListView.SetFontSize(_fontSize: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= _fontSize;
  if FInitialized then
     jExpandableListView_SetFontSize(gApp.jni.jEnv, FjObject, _fontSize);
end;

procedure jExpandableListView.SetFontChildSize(_fontSize: DWord);
begin
  //in designing component state: set value here...
  FFontChildSize:= _fontSize;
  if FInitialized then
     jExpandableListView_SetFontChildSize(gApp.jni.jEnv, FjObject, _fontSize);
end;

procedure jExpandableListView.SetTextAlign(_align: TTextAlign);
begin
  //in designing component state: set value here...
  FTextAlign := _align;
  if FInitialized then
     jExpandableListView_SetTextAlign(gApp.jni.jEnv, FjObject, Ord(_align));
end;

procedure jExpandableListView.SetTextChildAlign(_align: TTextAlign);
begin
  //in designing component state: set value here...
  FTextChildAlign:= _align;
  if FInitialized then
     jExpandableListView_SetTextChildAlign(gApp.jni.jEnv, FjObject, Ord(_align) );
end;

procedure jExpandableListView.SetFontFace(_fontFace: TFontFace);
begin
  //in designing component state: set value here...
  FFontFace:=  _fontFace;
  if FInitialized then
     jExpandableListView_SetFontFace(gApp.jni.jEnv, FjObject, Ord(_fontFace));
end;

procedure jExpandableListView.SetTextChildTypeFace(_typeface: TTextTypeFace);
begin
  //in designing component state: set value here...
  FTextChildTypeFace:= _typeface;
  if FInitialized then
     jExpandableListView_SetTextChildTypeFace(gApp.jni.jEnv, FjObject, Ord(_typeface));
end;

procedure jExpandableListView.GenEvent_OnGroupExpand(Obj: TObject;  groupPosition: integer; groupHeader: string);
begin
  if Assigned(FOnGroupItemExpand) then FOnGroupItemExpand(Obj, groupPosition, groupHeader);
end;

procedure jExpandableListView.SetTextTypeFace(_typeface: TTextTypeFace);
begin
  //in designing component state: set value here...
  FTextTypeFace:= _typeface;
  if FInitialized then
     jExpandableListView_SetTextTypeFace(gApp.jni.jEnv, FjObject, Ord(_typeface));
end;

procedure jExpandableListView.SetImageItemIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageItemIdentifier:= _imageResIdentifier;
  if FInitialized then
     jExpandableListView_SetImageItemIdentifier(gApp.jni.jEnv, FjObject, FImageItemIdentifier);
end;

procedure jExpandableListView.SetImageChildItemIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageChildItemIdentifier:= _imageResIdentifier;
  if FInitialized  then
     jExpandableListView_SetImageChildItemIdentifier(gApp.jni.jEnv, FjObject, ImageChildItemIdentifier);
end;

procedure jExpandableListView.SetHighLightSelectedChildItemColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHighLightSelectedChildItemColor:= _color;
  if FInitialized then
     jExpandableListView_SetHighLightSelectedChildItemColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FHighLightSelectedChildItemColor));
end;

procedure jExpandableListView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_Clear(gApp.jni.jEnv, FjObject);
end;

procedure jExpandableListView.ClearChildren(_groupPosition: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_ClearChildren(gApp.jni.jEnv, FjObject, _groupPosition);
end;

procedure jExpandableListView.ClearGroup(_groupPosition: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_ClearGroup(gApp.jni.jEnv, FjObject, _groupPosition);
end;


procedure jExpandableListView.GenEvent_OnGroupCollapse(Obj: TObject;  groupPosition: integer; groupHeader: string);
begin
   if Assigned(FOnGroupItemCollapse) then FOnGroupItemCollapse(Obj, groupPosition, groupHeader);
end;

procedure jExpandableListView.GenEvent_OnChildClick(Obj: TObject;  groupPosition: integer; groupHeader: string; childItemPosition: integer; childItemCaption: string);
begin
   if Assigned(FOnOnChildItemClick) then FOnOnChildItemClick(Obj, groupPosition, groupHeader, childItemPosition, childItemCaption);
end;

{-------- jExpandableListView_JNI_Bridge ----------}

function jExpandableListView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jExpandableListView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jExpandableListView_jCreate(long _Self) {
  return (java.lang.Object)(new jExpandableListView(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jExpandableListView_jFree(env: PJNIEnv; _jexpandablelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetViewParent(env: PJNIEnv; _jexpandablelistview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jExpandableListView_GetParent(env: PJNIEnv; _jexpandablelistview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_RemoveFromViewParent(env: PJNIEnv; _jexpandablelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jExpandableListView_GetView(env: PJNIEnv; _jexpandablelistview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetLParamWidth(env: PJNIEnv; _jexpandablelistview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetLParamHeight(env: PJNIEnv; _jexpandablelistview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jExpandableListView_GetLParamWidth(env: PJNIEnv; _jexpandablelistview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jExpandableListView_GetLParamHeight(env: PJNIEnv; _jexpandablelistview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetLGravity(env: PJNIEnv; _jexpandablelistview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetLWeight(env: PJNIEnv; _jexpandablelistview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jexpandablelistview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_AddLParamsAnchorRule(env: PJNIEnv; _jexpandablelistview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_AddLParamsParentRule(env: PJNIEnv; _jexpandablelistview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetLayoutAll(env: PJNIEnv; _jexpandablelistview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_ClearLayoutAll(env: PJNIEnv; _jexpandablelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetId(env: PJNIEnv; _jexpandablelistview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_Add(env: PJNIEnv; _jexpandablelistview: JObject; _header: string; _delimitedItems: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_header));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimitedItems));
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_Add(env: PJNIEnv; _jexpandablelistview: JObject; _delimitedItem: string; _headerDelimiter: string; _childInnerDelimiter: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimitedItem));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_headerDelimiter));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_childInnerDelimiter));
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetItemHeaderDelimiter(env: PJNIEnv; _jexpandablelistview: JObject; _itemHeaderDelimiter: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_itemHeaderDelimiter));
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemHeaderDelimiter', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetItemChildInnerDelimiter(env: PJNIEnv; _jexpandablelistview: JObject; _itemChildInnerDelimiter: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_itemChildInnerDelimiter));
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemChildInnerDelimiter', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetFontColor(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontColor', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetFontChildColor(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontChildColor', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetFontColorAll(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontColorAll', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetFontChildColorAll(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontChildColorAll', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetFontSizeUnit(env: PJNIEnv; _jexpandablelistview: JObject; _unit: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _unit;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetFontSize(env: PJNIEnv; _jexpandablelistview: JObject; _fontSize: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontSize;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontSize', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetFontChildSize(env: PJNIEnv; _jexpandablelistview: JObject; _fontSize: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontSize;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontChildSize', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetTextAlign(env: PJNIEnv; _jexpandablelistview: JObject; _align: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _align;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextAlign', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetTextChildAlign(env: PJNIEnv; _jexpandablelistview: JObject; _align: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _align;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextChildAlign', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetFontFace(env: PJNIEnv; _jexpandablelistview: JObject; _fontFace: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontFace;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontFace', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetTextTypeFace(env: PJNIEnv; _jexpandablelistview: JObject; _typeface: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _typeface;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextTypeFace', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetTextChildTypeFace(env: PJNIEnv; _jexpandablelistview: JObject; _typeface: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _typeface;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextChildTypeFace', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetBackgroundChild(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundChild', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetImageItemIdentifier(env: PJNIEnv; _jexpandablelistview: JObject; _imageResIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageResIdentifier));
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageItemIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jExpandableListView_SetImageChildItemIdentifier(env: PJNIEnv; _jexpandablelistview: JObject; _imageResIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageResIdentifier));
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageChildItemIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_SetHighLightSelectedChildItemColor(env: PJNIEnv; _jexpandablelistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHighLightSelectedChildItemColor', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_Clear(env: PJNIEnv; _jexpandablelistview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jexpandablelistview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_ClearChildren(env: PJNIEnv; _jexpandablelistview: JObject; _groupPosition: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _groupPosition;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearChildren', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpandableListView_ClearGroup(env: PJNIEnv; _jexpandablelistview: JObject; _groupPosition: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _groupPosition;
  jCls:= env^.GetObjectClass(env, _jexpandablelistview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearGroup', '(I)V');
  env^.CallVoidMethodA(env, _jexpandablelistview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
