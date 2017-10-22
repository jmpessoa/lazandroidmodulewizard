unit expandablelistview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

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
    function GetView(): jObject;  override;
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


implementation

uses
   customdialog, toolbar;

{---------  jExpandableListView  --------------}

constructor jExpandableListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FHeight       := 96; //??
  FWidth        := 100; //??

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

procedure jExpandableListView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  i: integer;
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
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;
  jExpandableListView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jExpandableListView_SetId(FjEnv, FjObject, Self.Id);
  jExpandableListView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jExpandableListView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jExpandableListView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if FFontSizeUnit <> unitDefault then
    jExpandableListView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
    jExpandableListView_SetFontSize(FjEnv, FjObject , FFontSize);

  if FFontColor <> colbrDefault  then
    jExpandableListView_SetFontColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

  if FFontChildColor <> colbrDefault  then
    jExpandableListView_SetFontChildColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontChildColor));

  if FBackgroundChildColor <>  colbrDefault then
     jExpandableListView_SetBackgroundChild(FjEnv, FjObject, GetARGB(FCustomColor, FBackgroundChildColor));

  if FTextAlign <> alLeft then
    jExpandableListView_SetTextAlign(FjEnv, FjObject, Ord(FTextAlign));

  if FTextChildAlign <> alLeft then
    jExpandableListView_SetTextChildAlign(FjEnv, FjObject, Ord(FTextChildAlign));

  if FFontFace <> ffNormal then
    jExpandableListView_SetFontFace(FjEnv, FjObject, Ord(FFontFace));

  if FTextTypeFace <> tfNormal then
    jExpandableListView_SetTextTypeFace(FjEnv, FjObject, Ord(FTextTypeFace));

  if FImageItemIdentifier <> '' then
    jExpandableListView_SetImageItemIdentifier(FjEnv, FjObject, FImageItemIdentifier);

  if FImageChildItemIdentifier <> '' then
    jExpandableListView_SetImageChildItemIdentifier(FjEnv, FjObject, FImageChildItemIdentifier);

  if FHighLightSelectedChildItemColor <> colbrDefault then
      jExpandableListView_SetHighLightSelectedChildItemColor(FjEnv, FjObject, GetARGB(FCustomColor, FHighLightSelectedChildItemColor));

  for i:= 0 to FItems.Count - 1 do
  begin
    if FItems.Strings[i] <> '' then
         jExpandableListView_Add(FjEnv, FjObject , FItems.Strings[i], FGroupItemDelimiter, FChildItemDelimiter);
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jExpandableListView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jExpandableListView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jExpandableListView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jExpandableListView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jExpandableListView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jExpandableListView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jExpandableListView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jExpandableListView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jExpandableListView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jExpandableListView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jExpandableListView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jExpandableListView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jExpandableListView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jExpandableListView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jExpandableListView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jExpandableListView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jExpandableListView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jExpandableListView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jExpandableListView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jExpandableListView.jCreate(): jObject;
begin
   Result:= jExpandableListView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jExpandableListView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_jFree(FjEnv, FjObject);
end;

procedure jExpandableListView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jExpandableListView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetParent(FjEnv, FjObject);
end;

procedure jExpandableListView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jExpandableListView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetView(FjEnv, FjObject);
end;

procedure jExpandableListView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jExpandableListView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jExpandableListView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetLParamWidth(FjEnv, FjObject);
end;

function jExpandableListView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpandableListView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jExpandableListView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jExpandableListView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jExpandableListView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jExpandableListView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jExpandableListView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jExpandableListView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jExpandableListView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jExpandableListView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  Fid := _id;
  if FInitialized then
     jExpandableListView_SetId(FjEnv, FjObject, _id);
end;

Procedure jExpandableListView.SetFontColor(_color: TARGBColorBridge);
begin
  FFontColor:= _color;
  if (FInitialized = True) and (FFontColor <> colbrDefault ) then
      jExpandableListView_SetFontColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jExpandableListView.SetFontChildColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontChildColor := _color;
  if (FInitialized = True) and (FFontColor <> colbrDefault ) then
     jExpandableListView_SetFontChildColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontChildColor));
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
         jExpandableListView_Add(FjEnv, FjObject , FItems.Strings[i], FGroupItemDelimiter, FChildItemDelimiter);
    end;
  end;

end;

procedure jExpandableListView.Add(_header: string; _delimitedChildItems: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_Add(FjEnv, FjObject, _header , _delimitedChildItems);
end;

procedure jExpandableListView.Add(_delimitedItem: string; _headerDelimiter: string; _childInnerDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_Add(FjEnv, FjObject, _delimitedItem ,_headerDelimiter , _childInnerDelimiter);
end;

procedure jExpandableListView.SetGroupItemDelimiter(_itemGroupDelimiter: string);
begin
  //in designing component state: set value here...
  FGroupItemDelimiter:=  _itemGroupDelimiter;
  if FInitialized then
     jExpandableListView_SetItemHeaderDelimiter(FjEnv, FjObject, _itemGroupDelimiter);
end;

procedure jExpandableListView.SetChildItemDelimiter(_itemChildDelimiter: string);
begin
  //in designing component state: set value here...
  FChildItemDelimiter:= _itemChildDelimiter;
  if FInitialized then
     jExpandableListView_SetItemChildInnerDelimiter(FjEnv, FjObject, _itemChildDelimiter);
end;

procedure jExpandableListView.SetFontColorAll(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetFontColorAll(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jExpandableListView.SetFontChildColorAll(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpandableListView_SetFontChildColorAll(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jExpandableListView.SetBackgroundChild(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FBackgroundChildColor:= _color;
  if FInitialized then
     jExpandableListView_SetBackgroundChild(FjEnv, FjObject, GetARGB(FCustomColor, FBackgroundChildColor));
end;

procedure jExpandableListView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jExpandableListView_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit) );
end;

procedure jExpandableListView.SetFontSize(_fontSize: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= _fontSize;
  if FInitialized then
     jExpandableListView_SetFontSize(FjEnv, FjObject, _fontSize);
end;

procedure jExpandableListView.SetFontChildSize(_fontSize: DWord);
begin
  //in designing component state: set value here...
  FFontChildSize:= _fontSize;
  if FInitialized then
     jExpandableListView_SetFontChildSize(FjEnv, FjObject, _fontSize);
end;

procedure jExpandableListView.SetTextAlign(_align: TTextAlign);
begin
  //in designing component state: set value here...
  FTextAlign := _align;
  if FInitialized then
     jExpandableListView_SetTextAlign(FjEnv, FjObject, Ord(_align));
end;

procedure jExpandableListView.SetTextChildAlign(_align: TTextAlign);
begin
  //in designing component state: set value here...
  FTextChildAlign:= _align;
  if FInitialized then
     jExpandableListView_SetTextChildAlign(FjEnv, FjObject, Ord(_align) );
end;

procedure jExpandableListView.SetFontFace(_fontFace: TFontFace);
begin
  //in designing component state: set value here...
  FFontFace:=  _fontFace;
  if FInitialized then
     jExpandableListView_SetFontFace(FjEnv, FjObject, Ord(_fontFace));
end;

procedure jExpandableListView.SetTextChildTypeFace(_typeface: TTextTypeFace);
begin
  //in designing component state: set value here...
  FTextChildTypeFace:= _typeface;
  if FInitialized then
     jExpandableListView_SetTextChildTypeFace(FjEnv, FjObject, Ord(_typeface));
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
     jExpandableListView_SetTextTypeFace(FjEnv, FjObject, Ord(_typeface));
end;

procedure jExpandableListView.SetImageItemIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageItemIdentifier:= _imageResIdentifier;
  if FInitialized then
     jExpandableListView_SetImageItemIdentifier(FjEnv, FjObject, FImageItemIdentifier);
end;

procedure jExpandableListView.SetImageChildItemIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageChildItemIdentifier:= _imageResIdentifier;
  if FInitialized  then
     jExpandableListView_SetImageChildItemIdentifier(FjEnv, FjObject, ImageChildItemIdentifier);
end;

procedure jExpandableListView.SetHighLightSelectedChildItemColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHighLightSelectedChildItemColor:= _color;
  if FInitialized then
     jExpandableListView_SetHighLightSelectedChildItemColor(FjEnv, FjObject, GetARGB(FCustomColor, FHighLightSelectedChildItemColor));
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
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


end.
