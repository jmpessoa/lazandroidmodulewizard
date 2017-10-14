unit autocompletetextview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [4/21/2016 22:29:07]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jAutoTextView = class(jVisualControl)
 private
    FFontFace: TFontFace;
    FTextAlignment: TTextAlignment;
    FTextTypeFace: TTextTypeFace;
    FFontSize     : DWord;
    FItems        : TStrings;
    FOnClickDropDownItem: TOnClickCaptionItem;
    FOnLostFocus: TOnEditLostFocus;
    FOnEnter  : TOnNotify;
    FCloseSoftInputOnEnter: boolean;
    FHint: string;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
 protected
    //
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;

    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();
    function GetView(): jObject; override;

    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    function GetItemIndex(): integer;

    procedure SetText(_text: string); override;
    function GetText(): string;  override;

    procedure Clear();
    procedure ShowDropDown();
    procedure SetThreshold(_threshold: integer);
    procedure Add(_text: string);
    function CountDropDown(): integer;
    procedure ClearAll();
    procedure ClearDropDown();

    procedure CopyToClipboard();
    procedure PasteFromClipboard();
    procedure Append(_text: string);
    procedure AppendLn(_text: string);
    procedure AppendTab();

    procedure SetFontAndTextTypeFace(_fontFace: TFontFace; _fontStyle: TTextTypeFace);

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure SetFontFace(AValue: TFontFace);
    procedure SetTextTypeFace(AValue: TTextTypeFace);
    Procedure SetTextAlignment(AValue: TTextAlignment);
    Procedure SetFontColor(Value : TARGBColorBridge);

    Procedure SetFontSize (AValue : DWord); //setTextSize!
    procedure SetItems(AValue: TStrings);
    procedure ShowSoftInput();
    procedure HideSoftInput();
    procedure SetSoftInputOptions(_imeOption: TImeOptions);
    procedure SetFocus();
    procedure RequestFocus();
    procedure SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
    procedure SetHint(_hint: string);

    procedure GenEvent_OnClickAutoDropDownItem(Obj: TObject; index: integer; caption: string);
    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    Procedure GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
    Procedure GenEvent_OnEnter (Obj: TObject);

    property Text: string read GetText write SetText;

 published
    property Alignment : TTextAlignment read FTextAlignment write SetTextAlignment;
    property Enabled   : Boolean read FEnabled   write SetEnabled;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property FontSize  : DWord   read FFontSize  write SetFontSize;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Items: TStrings read FItems write SetItems;
    property CloseSoftInputOnEnter: boolean read FCloseSoftInputOnEnter write SetCloseSoftInputOnEnter;
    property Hint: string read FHint write SetHint;

    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnEnter: TOnNotify  read FOnEnter write FOnEnter;
    property OnLostFocus: TOnEditLostFocus read FOnLostFocus write FOnLostFocus;
    property OnClickDropDownItem: TOnClickCaptionItem read FOnClickDropDownItem write FOnClickDropDownItem;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw read FOnAfterDispatchDraw write FOnAfterDispatchDraw;

end;

function jAutoTextView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jAutoTextView_jFree(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_SetViewParent(env: PJNIEnv; _jAutoTextView: JObject; _viewgroup: jObject);
procedure jAutoTextView_RemoveFromViewParent(env: PJNIEnv; _jAutoTextView: JObject);
function jAutoTextView_GetView(env: PJNIEnv; _jAutoTextView: JObject): jObject;

procedure jAutoTextView_SetLParamWidth(env: PJNIEnv; _jAutoTextView: JObject; _w: integer);
procedure jAutoTextView_SetLParamHeight(env: PJNIEnv; _jAutoTextView: JObject; _h: integer);

procedure jAutoTextView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jAutoTextView: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jAutoTextView_AddLParamsAnchorRule(env: PJNIEnv; _jAutoTextView: JObject; _rule: integer);
procedure jAutoTextView_AddLParamsParentRule(env: PJNIEnv; _jAutoTextView: JObject; _rule: integer);
procedure jAutoTextView_SetLayoutAll(env: PJNIEnv; _jAutoTextView: JObject; _idAnchor: integer);
procedure jAutoTextView_ClearLayoutAll(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_SetId(env: PJNIEnv; _jAutoTextView: JObject; _id: integer);
function jAutoTextView_GetItemIndex(env: PJNIEnv; _jAutoTextView: JObject): integer;
procedure jAutoTextView_SetText(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
function jAutoTextView_GetText(env: PJNIEnv; _jAutoTextView: JObject): string;
procedure jAutoTextView_Clear(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_ShowDropDown(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_SetThreshold(env: PJNIEnv; _jAutoTextView: JObject; _threshold: integer);
procedure jAutoTextView_Add(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
function jAutoTextView_CountDropDown(env: PJNIEnv; _jAutoTextView: JObject): integer;
procedure jAutoTextView_ClearAll(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_ClearDropDown(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_SetTextAlignment(env: PJNIEnv; _jAutoTextView: JObject; align: integer);
procedure jAutoTextView_CopyToClipboard(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_PasteFromClipboard(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_Append(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
procedure jAutoTextView_AppendLn(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
procedure jAutoTextView_AppendTab(env: PJNIEnv; _jAutoTextView: JObject);
procedure jAutoTextView_SetFontAndTextTypeFace(env: PJNIEnv; _jAutoTextView: JObject; _fontFace: integer; _fontStyle: integer);
procedure jAutoTextView_SetTextSize(env: PJNIEnv; _jAutoTextView: JObject; AValue: DWord);
procedure jAutoTextView_SetFontSizeUnit(env: PJNIEnv; _jAutoTextView: JObject; _unit: integer);
Procedure jAutoTextView_setTextColor(env:PJNIEnv; TextView: jObject; color : DWord);

function jAutoTextView_GetLParamHeight(env: PJNIEnv; _jautotextview: JObject): integer;
function jAutoTextView_GetLParamWidth(env: PJNIEnv; _jautotextview: JObject): integer;

procedure jAutoTextView_ShowSoftInput(env: PJNIEnv; _jautotextview: JObject);
procedure jAutoTextView_HideSoftInput(env: PJNIEnv; _jautotextview: JObject);
procedure jAutoTextView_SetSoftInputOptions(env: PJNIEnv; _jautotextview: JObject; _imeOption: integer);
procedure jAutoTextView_SetFocus(env: PJNIEnv; _jautotextview: JObject);
procedure jAutoTextView_RequestFocus(env: PJNIEnv; _jautotextview: JObject);
procedure jAutoTextView_SetCloseSoftInputOnEnter(env: PJNIEnv; _jautotextview: JObject; _closeSoftInput: boolean);
procedure jAutoTextView_SetHint(env: PJNIEnv; _jautotextview: JObject; _hint: string);

implementation

uses
   customdialog, toolbar;

{---------  jAutoTextView  --------------}

constructor jAutoTextView.Create(AOwner: TComponent);
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
  //FText:= '';
  FFontFace := ffNormal;
  FTextTypeFace:= tfNormal;
  FCloseSoftInputOnEnter:= True;

  FItems:= TStringList.Create;

end;

destructor jAutoTextView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //your others free code here...'
  FItems.Free;
  inherited Destroy;
end;

procedure jAutoTextView.Init(refApp: jApp);
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
  jAutoTextView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jAutoTextView_SetId(FjEnv, FjObject, Self.Id);
  jAutoTextView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jAutoTextView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jAutoTextView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jAutoTextView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if  FFontColor <> colbrDefault then
    jAutoTextView_SetTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
     jAutoTextView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
    jAutoTextView_SetTextSize(FjEnv, FjObject , FFontSize);

  jAutoTextView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

  if not FCloseSoftInputOnEnter then
    jAutoTextView_SetCloseSoftInputOnEnter(FjEnv, FjObject, FCloseSoftInputOnEnter);

  if FHint <> '' then
     jAutoTextView_SetHint(FjEnv, FjObject, FHint);

  for i:= 0 to FItems.Count-1 do
     jAutoTextView_Add(FjEnv, FjObject , FItems.Strings[i]);

  View_SetVisible(FjEnv, FjObject, FVisible);

end;

procedure jAutoTextView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jAutoTextView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jAutoTextView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jAutoTextView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jAutoTextView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jAutoTextView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jAutoTextView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jAutoTextView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jAutoTextView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jAutoTextView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jAutoTextView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jAutoTextView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jAutoTextView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jAutoTextView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jAutoTextView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jAutoTextView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jAutoTextView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jAutoTextView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jAutoTextView.jCreate(): jObject;
begin
   Result:= jAutoTextView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jAutoTextView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_jFree(FjEnv, FjObject);
end;

procedure jAutoTextView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jAutoTextView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jAutoTextView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAutoTextView_GetView(FjEnv, FjObject);
end;

procedure jAutoTextView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jAutoTextView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jAutoTextView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jAutoTextView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jAutoTextView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jAutoTextView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jAutoTextView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jAutoTextView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetId(FjEnv, FjObject, _id);
end;

function jAutoTextView.GetItemIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAutoTextView_GetItemIndex(FjEnv, FjObject);
end;

procedure jAutoTextView.SetText(_text: string);
begin
  //in designing component state: set value here...
  FText:= _text;
  if FInitialized then
     jAutoTextView_SetText(FjEnv, FjObject, _text);
end;

function jAutoTextView.GetText(): string;
begin
  //in designing component state: result value here...
  Result:= FText;
  if FInitialized then
   Result:= jAutoTextView_GetText(FjEnv, FjObject);
end;

procedure jAutoTextView.Clear();
begin
  //in designing component state: set value here...
  FText:= '';
  if FInitialized then
     jAutoTextView_Clear(FjEnv, FjObject);
end;

procedure jAutoTextView.ShowDropDown();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_ShowDropDown(FjEnv, FjObject);
end;

procedure jAutoTextView.SetThreshold(_threshold: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetThreshold(FjEnv, FjObject, _threshold);
end;

procedure jAutoTextView.Add(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jAutoTextView_Add(FjEnv, FjObject, _text);
     FItems.Add(_text);
  end;
end;

function jAutoTextView.CountDropDown(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAutoTextView_CountDropDown(FjEnv, FjObject);
end;

procedure jAutoTextView.ClearAll();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jAutoTextView_ClearAll(FjEnv, FjObject);
     FItems.Clear;
  end;
end;

procedure jAutoTextView.ClearDropDown();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FItems.Clear;
     jAutoTextView_ClearDropDown(FjEnv, FjObject);
  end;
end;

procedure jAutoTextView.SetTextAlignment(AValue: TTextAlignment);
begin
  //in designing component state: set value here...
  FTextAlignment:= AValue;
  if FInitialized then
     jAutoTextView_SetTextAlignment(FjEnv, FjObject, Ord(AValue));
end;

procedure jAutoTextView.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_CopyToClipboard(FjEnv, FjObject);
end;

procedure jAutoTextView.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_PasteFromClipboard(FjEnv, FjObject);
end;

procedure jAutoTextView.Append(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_Append(FjEnv, FjObject, _text);
end;

procedure jAutoTextView.AppendLn(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_AppendLn(FjEnv, FjObject, _text);
end;

procedure jAutoTextView.AppendTab();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_AppendTab(FjEnv, FjObject);
end;

procedure jAutoTextView.SetFontAndTextTypeFace(_fontFace: TFontFace; _fontStyle: TTextTypeFace);
begin
  //in designing component state: set value here...
  FFontFace:=  _fontFace;
  FTextTypeFace:= _fontStyle;
  if FInitialized then
     jAutoTextView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(_fontFace) ,Ord(_fontStyle));
end;


procedure jAutoTextView.SetFontFace(AValue: TFontFace);
begin
  //in designing component state: set value here...
  FFontFace:=  AValue;
  if FInitialized then
     jAutoTextView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(AValue) ,Ord(FTextTypeFace));
end;

procedure jAutoTextView.SetTextTypeFace(AValue: TTextTypeFace);
begin
  //in designing component state: set value here...
  FTextTypeFace:= AValue;
  if FInitialized then
     jAutoTextView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace) ,Ord(AValue));
end;


procedure jAutoTextView.SetFontSize(AValue: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= AValue;
  if FInitialized then
     jAutoTextView_SetTextSize(FjEnv, FjObject, AValue);
end;

procedure jAutoTextView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:= _unit;
  if FInitialized then
     jAutoTextView_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jAutoTextView.SetFontColor(Value: TARGBColorBridge);
begin
 FFontColor:= Value;
 if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jAutoTextView_setTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor))
end;

procedure jAutoTextView.SetItems(AValue: TStrings);
begin
   if AValue <> nil then
       FItems.Assign(AValue);
end;

function jAutoTextView.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jAutoTextView_GetLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
           Result:= (FParent as jForm).ScreenWH.Width
         else
           Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
           Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jAutoTextView.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jAutoTextView_GetLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height   //take from start!
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

procedure jAutoTextView.ShowSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_ShowSoftInput(FjEnv, FjObject);
end;

procedure jAutoTextView.HideSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_HideSoftInput(FjEnv, FjObject);
end;

procedure jAutoTextView.SetSoftInputOptions(_imeOption: TImeOptions);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetSoftInputOptions(FjEnv, FjObject, Ord(_imeOption));
end;

procedure jAutoTextView.SetFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_SetFocus(FjEnv, FjObject);
end;

procedure jAutoTextView.RequestFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAutoTextView_RequestFocus(FjEnv, FjObject);
end;

procedure jAutoTextView.SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
begin
  //in designing component state: set value here...
  FCloseSoftInputOnEnter:= _closeSoftInput;
  if FInitialized then
     jAutoTextView_SetCloseSoftInputOnEnter(FjEnv, FjObject, _closeSoftInput);
end;

procedure jAutoTextView.SetHint(_hint: string);
begin
  //in designing component state: set value here...
  FHint:= _hint;
  if FInitialized then
     jAutoTextView_SetHint(FjEnv, FjObject, _hint);
end;

Procedure jAutoTextView.GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

Procedure jAutoTextView.GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

Procedure jAutoTextView.GenEvent_OnClickAutoDropDownItem(Obj: TObject; index: integer;  caption: string);
begin
  if Assigned(FOnClickDropDownItem) then FOnClickDropDownItem(Obj,index, caption);
end;

Procedure jAutoTextView.GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
begin
  if Assigned(FOnLostFocus) then FOnLostFocus(Obj, txt);
end;

Procedure jAutoTextView.GenEvent_OnEnter(Obj: TObject);
begin
  if Assigned(FOnEnter) then FOnEnter(Obj);
end;

{-------- jAutoTextView_JNI_Bridge ----------}

function jAutoTextView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jAutoTextView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jAutoTextView_jCreate(long _Self) {
      return (java.lang.Object)(new jAutoTextView(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jAutoTextView_jFree(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetViewParent(env: PJNIEnv; _jAutoTextView: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_RemoveFromViewParent(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jAutoTextView_GetView(env: PJNIEnv; _jAutoTextView: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetLParamWidth(env: PJNIEnv; _jAutoTextView: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetLParamHeight(env: PJNIEnv; _jAutoTextView: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jAutoTextView: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_AddLParamsAnchorRule(env: PJNIEnv; _jAutoTextView: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_AddLParamsParentRule(env: PJNIEnv; _jAutoTextView: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetLayoutAll(env: PJNIEnv; _jAutoTextView: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_ClearLayoutAll(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetId(env: PJNIEnv; _jAutoTextView: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jAutoTextView_GetItemIndex(env: PJNIEnv; _jAutoTextView: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'GetItemIndex', '()I');
  Result:= env^.CallIntMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetText(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetText', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jAutoTextView_GetText(env: PJNIEnv; _jAutoTextView: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'GetText', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jAutoTextView, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_Clear(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_ShowDropDown(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowDropDown', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetThreshold(env: PJNIEnv; _jAutoTextView: JObject; _threshold: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _threshold;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetThreshold', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_Add(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jAutoTextView_CountDropDown(env: PJNIEnv; _jAutoTextView: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'CountDropDown', '()I');
  Result:= env^.CallIntMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_ClearAll(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearAll', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_ClearDropDown(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearDropDown', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetTextAlignment(env: PJNIEnv; _jAutoTextView: JObject; align: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= align;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextAlignment', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_CopyToClipboard(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyToClipboard', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_PasteFromClipboard(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteFromClipboard', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_Append(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'Append', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_AppendLn(env: PJNIEnv; _jAutoTextView: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'AppendLn', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_AppendTab(env: PJNIEnv; _jAutoTextView: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'AppendTab', '()V');
  env^.CallVoidMethod(env, _jAutoTextView, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetFontAndTextTypeFace(env: PJNIEnv; _jAutoTextView: JObject; _fontFace: integer; _fontStyle: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontFace;
  jParams[1].i:= _fontStyle;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontAndTextTypeFace', '(II)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


//// Font Height ( Pixel )
procedure jAutoTextView_SetTextSize(env: PJNIEnv; _jAutoTextView: JObject; AValue: DWord);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= AValue;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_SetFontSizeUnit(env: PJNIEnv; _jAutoTextView: JObject; _unit: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _unit;
  jCls:= env^.GetObjectClass(env, _jAutoTextView);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
  env^.CallVoidMethodA(env, _jAutoTextView, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

Procedure jAutoTextView_setTextColor(env:PJNIEnv; TextView: jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
  env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env, cls);
end;

function jAutoTextView_GetLParamHeight(env: PJNIEnv; _jautotextview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jautotextview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jAutoTextView_GetLParamWidth(env: PJNIEnv; _jautotextview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jautotextview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAutoTextView_ShowSoftInput(env: PJNIEnv; _jautotextview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowSoftInput', '()V');
  env^.CallVoidMethod(env, _jautotextview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_HideSoftInput(env: PJNIEnv; _jautotextview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'HideSoftInput', '()V');
  env^.CallVoidMethod(env, _jautotextview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAutoTextView_SetSoftInputOptions(env: PJNIEnv; _jautotextview: JObject; _imeOption: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _imeOption;
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSoftInputOptions', '(I)V');
  env^.CallVoidMethodA(env, _jautotextview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAutoTextView_SetFocus(env: PJNIEnv; _jautotextview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFocus', '()V');
  env^.CallVoidMethod(env, _jautotextview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAutoTextView_RequestFocus(env: PJNIEnv; _jautotextview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestFocus', '()V');
  env^.CallVoidMethod(env, _jautotextview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAutoTextView_SetCloseSoftInputOnEnter(env: PJNIEnv; _jautotextview: JObject; _closeSoftInput: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_closeSoftInput);
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCloseSoftInputOnEnter', '(Z)V');
  env^.CallVoidMethodA(env, _jautotextview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAutoTextView_SetHint(env: PJNIEnv; _jautotextview: JObject; _hint: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hint));
  jCls:= env^.GetObjectClass(env, _jautotextview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHint', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jautotextview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
