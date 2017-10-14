unit comboedittext;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [06/12/2017 02:04:16]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jComboEditText = class(jVisualControl)
 private
    FFontFace: TFontFace;
    FTextAlignment: TTextAlignment;
    FTextTypeFace: TTextTypeFace;
    FFontSize     : DWord;
    FItems        : TStrings;
    FItemPaddingTop: integer;
    FItemPaddingBottom: integer;
    FCloseSoftInputOnEnter: boolean;
    FHint: string;

    FOnClickDropDownItem: TOnClickCaptionItem;
    FOnLostFocus: TOnEditLostFocus;
    FOnEnter  : TOnNotify;

    FDropListTextColor: TARGBColorBridge;
    FDropListBackgroundColor: TARGBColorBridge;

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
    function GetPasObj(): int64;
    procedure SetViewParent(_viewgroup: jObject);  override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();
    procedure SetLeftTopRightBottomWidthHeight(left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
    procedure SetLParamWidth(w: integer);
    procedure SetLParamHeight(h: integer);
    function GetLParamHeight(): integer;
    function GetLParamWidth(): integer;
    procedure SetLGravity(_g: integer);
    procedure SetLWeight(_w: single);
    procedure AddLParamsAnchorRule(rule: integer);
    procedure AddLParamsParentRule(rule: integer);
    procedure SetLayoutAll(idAnchor: integer);
    procedure ClearLayoutAll();
    function GetView(): jObject; override;
    procedure SetId(_id: integer);
    function GetItemIndex(): integer;
    procedure SetText(_text: string); override;
    function GetText(): string;  override;
    procedure Clear();
    procedure ShowDropDown();
    procedure SetThreshold(_threshold: integer);
    procedure Add(_text: string); overload;
    function CountDropDown(): integer;
    procedure ClearAll();
    procedure ClearDropDown();

    procedure SetTextAlignment(_alignment: TTextAlignment);
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (AValue : DWord); //setTextSize!
    procedure SetFontFace(AValue: TFontFace);
    procedure SetTextTypeFace(AValue: TTextTypeFace);
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetItems(AValue: TStrings);

    procedure CopyToClipboard();
    procedure PasteFromClipboard();
    procedure Append(_text: string);
    procedure AppendLn(_text: string);
    procedure AppendTab();
    procedure SetFontAndTextTypeFace(_fontFace: TFontFace; _fontStyle: TTextTypeFace);

    procedure Add(_item: string; _strTag: string); overload;
    procedure SetItem(_index: integer; _item: string; _strTag: string);
    procedure SetItemTagString(_index: integer; _strTag: string);
    function GetItemTagString(_index: integer): string;
    procedure Delete(_index: integer);
    procedure SetDropListTextColor(_color: TARGBColorBridge);
    procedure SetDropListBackgroundColor(_color: TARGBColorBridge);
    procedure SetSelectedPaddingTop(_paddingTop: integer);
    procedure SetSelectedPaddingBottom(_paddingBottom: integer);
    procedure ShowSoftInput();
    procedure HideSoftInput();
    procedure SetSoftInputOptions(_imeOption: TImeOptions);
    procedure SetFocus();
    procedure RequestFocus();
    procedure SetItemPaddingTop(_paddingTop: integer);
    procedure SetItemPaddingBottom(_paddingBottom: integer);
    procedure SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
    procedure SetHint(_hint: string);

    procedure GenEvent_OnClickComboDropDownItem(Obj: TObject; index: integer; caption: string);
    Procedure GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
    Procedure GenEvent_OnEnter (Obj: TObject);

    property Text: string read GetText write SetText;

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Alignment : TTextAlignment read FTextAlignment write SetTextAlignment;
    property Enabled   : Boolean read FEnabled   write SetEnabled;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property FontSize  : DWord   read FFontSize  write SetFontSize;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property Items: TStrings read FItems write SetItems;
    property ItemPaddingTop: integer read FItemPaddingTop write SetItemPaddingTop;
    property ItemPaddingBottom: integer read FItemPaddingBottom write SetItemPaddingBottom;
    property CloseSoftInputOnEnter: boolean read FCloseSoftInputOnEnter write SetCloseSoftInputOnEnter;
    property Hint: string read FHint write SetHint;

    property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
    property DropListBackgroundColor: TARGBColorBridge read FDropListBackgroundColor write SetDropListBackgroundColor;

    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnEnter: TOnNotify  read FOnEnter write FOnEnter;
    property OnLostFocus: TOnEditLostFocus read FOnLostFocus write FOnLostFocus;
    property OnClickDropDownItem: TOnClickCaptionItem read FOnClickDropDownItem write FOnClickDropDownItem;

end;

function jComboEditText_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jComboEditText_jFree(env: PJNIEnv; _jcomboedittext: JObject);
function jComboEditText_GetPasObj(env: PJNIEnv; _jcomboedittext: JObject): int64;
procedure jComboEditText_SetViewParent(env: PJNIEnv; _jcomboedittext: JObject; _viewgroup: jObject);
function jComboEditText_GetParent(env: PJNIEnv; _jcomboedittext: JObject): jObject;
procedure jComboEditText_RemoveFromViewParent(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcomboedittext: JObject; left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
procedure jComboEditText_SetLParamWidth(env: PJNIEnv; _jcomboedittext: JObject; w: integer);
procedure jComboEditText_SetLParamHeight(env: PJNIEnv; _jcomboedittext: JObject; h: integer);
function jComboEditText_GetLParamHeight(env: PJNIEnv; _jcomboedittext: JObject): integer;
function jComboEditText_GetLParamWidth(env: PJNIEnv; _jcomboedittext: JObject): integer;
procedure jComboEditText_SetLGravity(env: PJNIEnv; _jcomboedittext: JObject; _g: integer);
procedure jComboEditText_SetLWeight(env: PJNIEnv; _jcomboedittext: JObject; _w: single);
procedure jComboEditText_AddLParamsAnchorRule(env: PJNIEnv; _jcomboedittext: JObject; rule: integer);
procedure jComboEditText_AddLParamsParentRule(env: PJNIEnv; _jcomboedittext: JObject; rule: integer);
procedure jComboEditText_SetLayoutAll(env: PJNIEnv; _jcomboedittext: JObject; idAnchor: integer);
procedure jComboEditText_ClearLayoutAll(env: PJNIEnv; _jcomboedittext: JObject);
function jComboEditText_GetView(env: PJNIEnv; _jcomboedittext: JObject): jObject;
procedure jComboEditText_SetId(env: PJNIEnv; _jcomboedittext: JObject; _id: integer);
function jComboEditText_GetItemIndex(env: PJNIEnv; _jcomboedittext: JObject): integer;
procedure jComboEditText_SetText(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
function jComboEditText_GetText(env: PJNIEnv; _jcomboedittext: JObject): string;
procedure jComboEditText_Clear(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_ShowDropDown(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_SetThreshold(env: PJNIEnv; _jcomboedittext: JObject; _threshold: integer);
procedure jComboEditText_Add(env: PJNIEnv; _jcomboedittext: JObject; _text: string); overload;
function jComboEditText_CountDropDown(env: PJNIEnv; _jcomboedittext: JObject): integer;
procedure jComboEditText_ClearAll(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_ClearDropDown(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_SetTextAlignment(env: PJNIEnv; _jcomboedittext: JObject; align: integer);
procedure jComboEditText_CopyToClipboard(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_PasteFromClipboard(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_Append(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
procedure jComboEditText_AppendLn(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
procedure jComboEditText_AppendTab(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_SetFontAndTextTypeFace(env: PJNIEnv; _jcomboedittext: JObject; _fontFace: integer; _fontStyle: integer);
procedure jComboEditText_SetTextSize(env: PJNIEnv; _jcomboedittext: JObject; _size: DWord);
procedure jComboEditText_SetFontSizeUnit(env: PJNIEnv; _jcomboedittext: JObject; _unit: integer);
procedure jComboEditText_Add(env: PJNIEnv; _jcomboedittext: JObject; _item: string; _strTag: string); overload;
procedure jComboEditText_SetItem(env: PJNIEnv; _jcomboedittext: JObject; _index: integer; _item: string; _strTag: string);
procedure jComboEditText_SetItemTagString(env: PJNIEnv; _jcomboedittext: JObject; _index: integer; _strTag: string);
function jComboEditText_GetItemTagString(env: PJNIEnv; _jcomboedittext: JObject; _index: integer): string;
procedure jComboEditText_Delete(env: PJNIEnv; _jcomboedittext: JObject; _index: integer);
procedure jComboEditText_SetDropListTextColor(env: PJNIEnv; _jcomboedittext: JObject; _color: integer);
procedure jComboEditText_SetDropListBackgroundColor(env: PJNIEnv; _jcomboedittext: JObject; _color: integer);
procedure jComboEditText_SetSelectedPaddingTop(env: PJNIEnv; _jcomboedittext: JObject; _paddingTop: integer);
procedure jComboEditText_SetSelectedPaddingBottom(env: PJNIEnv; _jcomboedittext: JObject; _paddingBottom: integer);
Procedure jComboEditText_setTextColor(env:PJNIEnv; _jcomboedittext: jObject; color : DWord);
procedure jComboEditText_ShowSoftInput(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_HideSoftInput(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_SetSoftInputOptions(env: PJNIEnv; _jcomboedittext: JObject; _enterKeyOption: integer);
procedure jComboEditText_SetFocus(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_RequestFocus(env: PJNIEnv; _jcomboedittext: JObject);
procedure jComboEditText_SetItemPaddingTop(env: PJNIEnv; _jcomboedittext: JObject; _paddingTop: integer);
procedure jComboEditText_SetItemPaddingBottom(env: PJNIEnv; _jcomboedittext: JObject; _paddingBottom: integer);
procedure jComboEditText_SetCloseSoftInputOnEnter(env: PJNIEnv; _jcomboedittext: JObject; _closeSoftInput: boolean);
procedure jComboEditText_SetHint(env: PJNIEnv; _jcomboedittext: JObject; _hint: string);

implementation

uses
   customdialog, toolbar;

{---------  jComboEditText  --------------}

constructor jComboEditText.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  FMarginBottom := 5;
  FMarginLeft   := 5;
  FMarginRight  := 5;
  FMarginTop    := 5;
  FHeight       := 40;
  FWidth        := 100;

  FLParamWidth  := lpHalfOfParent;
  FLParamHeight := lpWrapContent;
  FAcceptChildrenAtDesignTime:= False;
  FTextAlignment:= taLeft;

  FFontFace := ffNormal;
  FTextTypeFace:= tfNormal;
  FItemPaddingTop:= 25;
  FItemPaddingBottom:= 25;

  FCloseSoftInputOnEnter:= True;

  FDropListTextColor:= colbrDefault;
  FDropListBackgroundColor:= colbrDefault;

  FItems:= TStringList.Create;

end;

destructor jComboEditText.Destroy;
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

procedure jComboEditText.Init(refApp: jApp);
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
  jComboEditText_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jComboEditText_SetId(FjEnv, FjObject, Self.Id);
  jComboEditText_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jComboEditText_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jComboEditText_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jComboEditText_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if  FFontColor <> colbrDefault then
    jComboEditText_SetTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FDropListTextColor <> colbrDefault then
    jComboEditText_SetDropListTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FDropListTextColor));

  if FDropListBackgroundColor <> colbrDefault then
    jComboEditText_SetDropListBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FDropListBackgroundColor));

  if FFontSizeUnit <> unitDefault then
     jComboEditText_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
    jComboEditText_SetTextSize(FjEnv, FjObject , FFontSize);

  jComboEditText_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

  if FItemPaddingTop <> 25 then
     jComboEditText_SetItemPaddingTop(FjEnv, FjObject, FItemPaddingTop);

  if FItemPaddingBottom <> 25 then
     jComboEditText_SetItemPaddingBottom(FjEnv, FjObject, FItemPaddingBottom);

  if not FCloseSoftInputOnEnter then
    jComboEditText_SetCloseSoftInputOnEnter(FjEnv, FjObject, FCloseSoftInputOnEnter);

  if FHint <> '' then
      jComboEditText_SetHint(FjEnv, FjObject, FHint);

  for i:= 0 to FItems.Count-1 do
     jComboEditText_Add(FjEnv, FjObject , FItems.Strings[i]);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jComboEditText.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jComboEditText.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jComboEditText.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jComboEditText_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jComboEditText_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jComboEditText_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jComboEditText.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jComboEditText_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jComboEditText_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jComboEditText_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jComboEditText.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jComboEditText_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jComboEditText.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jComboEditText.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jComboEditText_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jComboEditText_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jComboEditText_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jComboEditText.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jComboEditText.jCreate(): jObject;
begin
   Result:= jComboEditText_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jComboEditText.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_jFree(FjEnv, FjObject);
end;

function jComboEditText.GetPasObj(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetPasObj(FjEnv, FjObject);
end;

procedure jComboEditText.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jComboEditText.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetParent(FjEnv, FjObject);
end;

procedure jComboEditText.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_RemoveFromViewParent(FjEnv, FjObject);
end;

procedure jComboEditText.SetLeftTopRightBottomWidthHeight(left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, left ,top ,right ,bottom ,w ,h);
end;

procedure jComboEditText.SetLParamWidth(w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetLParamWidth(FjEnv, FjObject, w);
end;

procedure jComboEditText.SetLParamHeight(h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetLParamHeight(FjEnv, FjObject, h);
end;

function jComboEditText.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetLParamHeight(FjEnv, FjObject);
end;

function jComboEditText.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetLParamWidth(FjEnv, FjObject);
end;

procedure jComboEditText.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jComboEditText.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jComboEditText.AddLParamsAnchorRule(rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_AddLParamsAnchorRule(FjEnv, FjObject, rule);
end;

procedure jComboEditText.AddLParamsParentRule(rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_AddLParamsParentRule(FjEnv, FjObject, rule);
end;

procedure jComboEditText.SetLayoutAll(idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetLayoutAll(FjEnv, FjObject, idAnchor);
end;

procedure jComboEditText.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_ClearLayoutAll(FjEnv, FjObject);
end;

function jComboEditText.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetView(FjEnv, FjObject);
end;

procedure jComboEditText.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetId(FjEnv, FjObject, _id);
end;

function jComboEditText.GetItemIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetItemIndex(FjEnv, FjObject);
end;

procedure jComboEditText.SetText(_text: string);
begin
  //in designing component state: set value here...
  FText:= _text;
  if FInitialized then
     jComboEditText_SetText(FjEnv, FjObject, _text);
end;

function jComboEditText.GetText(): string;
begin
  //in designing component state: result value here...
  Result:= FText;
  if FInitialized then
   Result:= jComboEditText_GetText(FjEnv, FjObject);
end;

procedure jComboEditText.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_Clear(FjEnv, FjObject);
end;

procedure jComboEditText.ShowDropDown();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_ShowDropDown(FjEnv, FjObject);
end;

procedure jComboEditText.SetThreshold(_threshold: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetThreshold(FjEnv, FjObject, _threshold);
end;

procedure jComboEditText.Add(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jComboEditText_Add(FjEnv, FjObject, _text);
     FItems.Add(_text);
  end;
end;

function jComboEditText.CountDropDown(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_CountDropDown(FjEnv, FjObject);
end;

procedure jComboEditText.ClearAll();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FItems.Clear;
     jComboEditText_ClearAll(FjEnv, FjObject);
  end;
end;

procedure jComboEditText.ClearDropDown();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FItems.Clear;
     jComboEditText_ClearDropDown(FjEnv, FjObject);
  end;
end;

procedure jComboEditText.SetTextAlignment(_alignment: TTextAlignment);
begin
  //in designing component state: set value here...
  FTextAlignment:= _alignment;
  if FInitialized then
     jComboEditText_SetTextAlignment(FjEnv, FjObject, Ord(_alignment));
end;

procedure jComboEditText.SetFontColor(Value: TARGBColorBridge);
begin
 FFontColor:= Value;
 if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jComboEditText_setTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor))

end;

procedure jComboEditText.SetFontSize(AValue: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= AValue;
  if FInitialized then
     jComboEditText_SetTextSize(FjEnv, FjObject, AValue);
end;

procedure jComboEditText.SetFontFace(AValue: TFontFace);
begin
  //in designing component state: set value here...
  FFontFace:=  AValue;
  if FInitialized then
     jComboEditText_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(AValue) ,Ord(FTextTypeFace));
end;

procedure jComboEditText.SetTextTypeFace(AValue: TTextTypeFace);
begin
  //in designing component state: set value here...
  FTextTypeFace:= AValue;
  if FInitialized then
     jComboEditText_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace) ,Ord(AValue));
end;

procedure jComboEditText.SetItems(AValue: TStrings);
begin
   if AValue <> nil then
       FItems.Assign(AValue);
end;

procedure jComboEditText.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_CopyToClipboard(FjEnv, FjObject);
end;

procedure jComboEditText.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_PasteFromClipboard(FjEnv, FjObject);
end;

procedure jComboEditText.Append(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_Append(FjEnv, FjObject, _text);
end;

procedure jComboEditText.AppendLn(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_AppendLn(FjEnv, FjObject, _text);
end;

procedure jComboEditText.AppendTab();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_AppendTab(FjEnv, FjObject);
end;

procedure jComboEditText.SetFontAndTextTypeFace(_fontFace: TFontFace; _fontStyle: TTextTypeFace);
begin
  //in designing component state: set value here...
  FFontFace:=  _fontFace;
  FTextTypeFace:= _fontStyle;
  if FInitialized then
     jComboEditText_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(_fontFace), Ord(_fontStyle));
end;

procedure jComboEditText.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
 FFontSizeUnit:= _unit;
 if FInitialized then
     jComboEditText_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jComboEditText.Add(_item: string; _strTag: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jComboEditText_Add(FjEnv, FjObject, _item ,_strTag);
     FItems.Add(_item);
  end;
end;

procedure jComboEditText.SetItem(_index: integer; _item: string; _strTag: string);
begin
  //in designing component state: set value here...
  if _index < 0 then Exit;
  if FInitialized then
  begin
     if _index < FItems.Count then
     begin
       FItems.Strings[_index]:= _item;
       jComboEditText_SetItem(FjEnv, FjObject, _index ,_item ,_strTag);
     end;
  end;
end;

procedure jComboEditText.SetItemTagString(_index: integer; _strTag: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetItemTagString(FjEnv, FjObject, _index ,_strTag);
end;

function jComboEditText.GetItemTagString(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jComboEditText_GetItemTagString(FjEnv, FjObject, _index);
end;

procedure jComboEditText.Delete(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_Delete(FjEnv, FjObject, _index);
end;

procedure jComboEditText.SetDropListTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FDropListTextColor:= _color;
  if FInitialized then
     jComboEditText_SetDropListTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FDropListTextColor));
end;

procedure jComboEditText.SetDropListBackgroundColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FDropListBackgroundColor:= _color;
  if FInitialized then
     jComboEditText_SetDropListBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FDropListBackgroundColor));
end;

procedure jComboEditText.SetSelectedPaddingTop(_paddingTop: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetSelectedPaddingTop(FjEnv, FjObject, _paddingTop);
end;

procedure jComboEditText.SetSelectedPaddingBottom(_paddingBottom: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetSelectedPaddingBottom(FjEnv, FjObject, _paddingBottom);
end;


procedure jComboEditText.ShowSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_ShowSoftInput(FjEnv, FjObject);
end;

procedure jComboEditText.HideSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_HideSoftInput(FjEnv, FjObject);
end;

procedure jComboEditText.SetSoftInputOptions(_imeOption: TImeOptions);
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetSoftInputOptions(FjEnv, FjObject, Ord(_imeOption));
end;

procedure jComboEditText.SetFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_SetFocus(FjEnv, FjObject);
end;

procedure jComboEditText.RequestFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jComboEditText_RequestFocus(FjEnv, FjObject);
end;

procedure jComboEditText.SetItemPaddingTop(_paddingTop: integer);
begin
  //in designing component state: set value here...
  FItemPaddingTop:= _paddingTop;
  if FInitialized then
     jComboEditText_SetItemPaddingTop(FjEnv, FjObject, _paddingTop);
end;

procedure jComboEditText.SetItemPaddingBottom(_paddingBottom: integer);
begin
  //in designing component state: set value here...
  FItemPaddingBottom:= _paddingBottom;
  if FInitialized then
     jComboEditText_SetItemPaddingBottom(FjEnv, FjObject, _paddingBottom);
end;

procedure jComboEditText.SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
begin
  //in designing component state: set value here...
  FCloseSoftInputOnEnter:= _closeSoftInput;
  if FInitialized then
     jComboEditText_SetCloseSoftInputOnEnter(FjEnv, FjObject, _closeSoftInput);
end;

procedure jComboEditText.SetHint(_hint: string);
begin
  //in designing component state: set value here...
  FHint:= _hint;
  if FInitialized then
     jComboEditText_SetHint(FjEnv, FjObject, _hint);
end;

Procedure jComboEditText.GenEvent_OnClickComboDropDownItem(Obj: TObject; index: integer;  caption: string);
begin
  if Assigned(FOnClickDropDownItem) then FOnClickDropDownItem(Obj,index, caption);
end;

Procedure jComboEditText.GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
begin
  if Assigned(FOnLostFocus) then FOnLostFocus(Obj, txt);
end;

Procedure jComboEditText.GenEvent_OnEnter(Obj: TObject);
begin
  if Assigned(FOnEnter) then FOnEnter(Obj);
end;

{-------- jComboEditText_JNI_Bridge ----------}

function jComboEditText_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jComboEditText_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jComboEditText_jCreate(long _Self) {
  return (java.lang.Object)(new jComboEditText(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jComboEditText_jFree(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetPasObj(env: PJNIEnv; _jcomboedittext: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPasObj', '()J');
  Result:= env^.CallLongMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetViewParent(env: PJNIEnv; _jcomboedittext: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetParent(env: PJNIEnv; _jcomboedittext: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_RemoveFromViewParent(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcomboedittext: JObject; left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= left;
  jParams[1].i:= top;
  jParams[2].i:= right;
  jParams[3].i:= bottom;
  jParams[4].i:= w;
  jParams[5].i:= h;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetLParamWidth(env: PJNIEnv; _jcomboedittext: JObject; w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= w;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetLParamHeight(env: PJNIEnv; _jcomboedittext: JObject; h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= h;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetLParamHeight(env: PJNIEnv; _jcomboedittext: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetLParamWidth(env: PJNIEnv; _jcomboedittext: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetLGravity(env: PJNIEnv; _jcomboedittext: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetLWeight(env: PJNIEnv; _jcomboedittext: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_AddLParamsAnchorRule(env: PJNIEnv; _jcomboedittext: JObject; rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= rule;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_AddLParamsParentRule(env: PJNIEnv; _jcomboedittext: JObject; rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= rule;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetLayoutAll(env: PJNIEnv; _jcomboedittext: JObject; idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= idAnchor;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_ClearLayoutAll(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetView(env: PJNIEnv; _jcomboedittext: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetId(env: PJNIEnv; _jcomboedittext: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetItemIndex(env: PJNIEnv; _jcomboedittext: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetItemIndex', '()I');
  Result:= env^.CallIntMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetText(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetText', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetText(env: PJNIEnv; _jcomboedittext: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetText', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcomboedittext, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_Clear(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_ShowDropDown(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowDropDown', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetThreshold(env: PJNIEnv; _jcomboedittext: JObject; _threshold: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _threshold;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetThreshold', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_Add(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_CountDropDown(env: PJNIEnv; _jcomboedittext: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'CountDropDown', '()I');
  Result:= env^.CallIntMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_ClearAll(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearAll', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_ClearDropDown(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearDropDown', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetTextAlignment(env: PJNIEnv; _jcomboedittext: JObject; align: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= align;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextAlignment', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_CopyToClipboard(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyToClipboard', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_PasteFromClipboard(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteFromClipboard', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_Append(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'Append', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_AppendLn(env: PJNIEnv; _jcomboedittext: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'AppendLn', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_AppendTab(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'AppendTab', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetFontAndTextTypeFace(env: PJNIEnv; _jcomboedittext: JObject; _fontFace: integer; _fontStyle: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontFace;
  jParams[1].i:= _fontStyle;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontAndTextTypeFace', '(II)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetTextSize(env: PJNIEnv; _jcomboedittext: JObject; _size: DWord);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _size;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetFontSizeUnit(env: PJNIEnv; _jcomboedittext: JObject; _unit: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _unit;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_Add(env: PJNIEnv; _jcomboedittext: JObject; _item: string; _strTag: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_item));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_strTag));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetItem(env: PJNIEnv; _jcomboedittext: JObject; _index: integer; _item: string; _strTag: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_item));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_strTag));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItem', '(ILjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetItemTagString(env: PJNIEnv; _jcomboedittext: JObject; _index: integer; _strTag: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_strTag));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTagString', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jComboEditText_GetItemTagString(env: PJNIEnv; _jcomboedittext: JObject; _index: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetItemTagString', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcomboedittext, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_Delete(env: PJNIEnv; _jcomboedittext: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'Delete', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetDropListTextColor(env: PJNIEnv; _jcomboedittext: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDropListTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetDropListBackgroundColor(env: PJNIEnv; _jcomboedittext: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDropListBackgroundColor', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetSelectedPaddingTop(env: PJNIEnv; _jcomboedittext: JObject; _paddingTop: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _paddingTop;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedPaddingTop', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetSelectedPaddingBottom(env: PJNIEnv; _jcomboedittext: JObject; _paddingBottom: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _paddingBottom;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedPaddingBottom', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

Procedure jComboEditText_setTextColor(env:PJNIEnv; _jcomboedittext: jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, _jcomboedittext);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');   //direct jni api
  env^.CallVoidMethodA(env,_jcomboedittext,_jMethod,@_jParams);
  env^.DeleteLocalRef(env, cls);
end;

procedure jComboEditText_ShowSoftInput(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowSoftInput', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_HideSoftInput(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'HideSoftInput', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jComboEditText_SetSoftInputOptions(env: PJNIEnv; _jcomboedittext: JObject; _enterKeyOption: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _enterKeyOption;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSoftInputOptions', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetFocus(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFocus', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_RequestFocus(env: PJNIEnv; _jcomboedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestFocus', '()V');
  env^.CallVoidMethod(env, _jcomboedittext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetItemPaddingTop(env: PJNIEnv; _jcomboedittext: JObject; _paddingTop: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _paddingTop;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemPaddingTop', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetItemPaddingBottom(env: PJNIEnv; _jcomboedittext: JObject; _paddingBottom: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _paddingBottom;
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemPaddingBottom', '(I)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetCloseSoftInputOnEnter(env: PJNIEnv; _jcomboedittext: JObject; _closeSoftInput: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_closeSoftInput);
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCloseSoftInputOnEnter', '(Z)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jComboEditText_SetHint(env: PJNIEnv; _jcomboedittext: JObject; _hint: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hint));
  jCls:= env^.GetObjectClass(env, _jcomboedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHint', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcomboedittext, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
