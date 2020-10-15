unit Spinner;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, systryparent, AndroidWidget;

type

TOnItemSelected = procedure(Sender: TObject; itemCaption: string; itemIndex: integer) of object;

{Draft Component code by "Lazarus Android Module Wizard" [6/12/2014 3:35:32]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

  jSpinner = class(jVisualControl)
  private
    FItems: TStrings;
    FOnItemSelected: TOnItemSelected;

    FSelectedFontColor: TARGBColorBridge;
    FDropListTextColor: TARGBColorBridge;
    FDropListBackgroundColor: TARGBColorBridge;
    FLastItemAsPrompt: boolean;

    FTextAlignment: TTextAlignment;

    FTextTypeFace: TTextTypeFace;
    FSelectedIndex: integer;
    FSelectedPaddingTop: integer;
    FSelectedPaddingBottom: integer;

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetItems(Value: TStrings);
    procedure SetSelectedFontColor(Value : TARGBColorBridge);

    procedure SetFontFace(AValue: TFontFace);
    procedure SetTextTypeFace(Value: TTextTypeFace);

    //procedure ListViewChange  (Sender: TObject);  //TODO
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout; override;
    
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject; override;

    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    function GetSelectedItemPosition(): integer;
    function GetSelectedItem(): string;
    procedure Add(_item: string); overload;
    procedure Clear;
    procedure SetSelectedTextColor(_color: integer);
    procedure SetDropListTextColor(_color: TARGBColorBridge {integer});
    procedure SetDropListBackgroundColor(_color: TARGBColorBridge {integer});
    procedure SetLastItemAsPrompt(_hasPrompt: boolean);
    function GetSize(): integer;
    procedure Delete(_index: integer);
    procedure SetSelection(_index: integer);
    procedure SetItem(_index: integer; _item: string); overload;
    function GetItems(_delimiter: char): string;
    procedure SetFontSize(_txtFontSize: DWord);
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetTextAlignment(_alignment: TTextAlignment);

    function GetText(): string;  override;
    procedure SetText(_index: integer);  overload;
    procedure SetSelectedIndex(_index: integer);
    function GetSelectedIndex(): integer;

    procedure SetItem(_index: integer; _item: string; _strTag: string);  overload;
    procedure Add(_item: string; _strTag: string);  overload;
    function GetItemTagString(_index: integer): string;
    procedure SetItemTagString(_index: integer; _strTag: string);
    procedure SetSelectedPaddingTop(_paddingTop: integer);
    procedure SetSelectedPaddingBottom(_paddingBottom: integer);
    procedure SetLGravity(_value: TLayoutGravity);

    procedure GenEvent_OnSpinnerItemSelected(Obj: TObject; caption: string; position: integer);

    property ViewParent: jObject  read  FjPRLayout write SetViewParent; // Java : Parent Relative Layout
    property Count: integer read GetSize;
    property Text: string read GetText;

  published

    property Items: TStrings read FItems write SetItems;
    property Visible: boolean read FVisible write SetVisible;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property SelectedFontColor: TARGBColorBridge  read FSelectedFontColor write SetSelectedFontColor;
    property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
    property DropListBackgroundColor: TARGBColorBridge  read FDropListBackgroundColor write SetDropListBackgroundColor;
    property LastItemAsPrompt: boolean read FLastItemAsPrompt write SetLastItemAsPrompt;
    property FontSize: Dword read FFontSize write SetFontSize;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property Alignment: TTextAlignment read FTextAlignment write SetTextAlignment;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
    property SelectedIndex: integer read GetSelectedIndex write SetSelectedIndex;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;

    property SelectedPaddingTop: integer read FSelectedPaddingTop write SetSelectedPaddingTop;
    property SelectedPaddingBottom: integer read FSelectedPaddingBottom write SetSelectedPaddingBottom;

    property OnItemSelected: TOnItemSelected  read FOnItemSelected write FOnItemSelected;
  end;

function jSpinner_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jSpinner_jFree(env: PJNIEnv; _jspinner: JObject);
procedure jSpinner_SetViewParent(env: PJNIEnv; _jspinner: JObject; _viewgroup: jObject);
procedure jSpinner_SetLParamWidth(env: PJNIEnv; _jspinner: JObject; _w: integer);
procedure jSpinner_SetLParamHeight(env: PJNIEnv; _jspinner: JObject; _h: integer);
procedure jSpinner_AddLParamsAnchorRule(env: PJNIEnv; _jspinner: JObject; _rule: integer);
procedure jSpinner_AddLParamsParentRule(env: PJNIEnv; _jspinner: JObject; _rule: integer);
procedure jSpinner_ClearLayoutAll(env: PJNIEnv; _JSpinner: JObject);
procedure jSpinner_SetLayoutAll(env: PJNIEnv; _jspinner: JObject; _idAnchor: integer);
procedure jSpinner_SetId(env: PJNIEnv; _jspinner: JObject; _id: integer);
function jSpinner_GetSelectedItemPosition(env: PJNIEnv; _jspinner: JObject): integer;
function jSpinner_GetSelectedItem(env: PJNIEnv; _jspinner: JObject): string;
procedure jSpinner_Clear(env: PJNIEnv; _JSpinner: JObject);
procedure jSpinner_SetSelectedTextColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
procedure jSpinner_SetDropListTextColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
procedure jSpinner_SetDropListBackgroundColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
procedure jSpinner_SetLastItemAsPrompt(env: PJNIEnv; _jspinner: JObject; _hasPrompt: boolean);
function jSpinner_GetSize(env: PJNIEnv; _jspinner: JObject): integer;
procedure jSpinner_Delete(env: PJNIEnv; _jspinner: JObject; _index: integer);
procedure jSpinner_SetSelection(env: PJNIEnv; _jspinner: JObject; _index: integer);
procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string); overload;

procedure jSpinner_SetTextFontSize(env: PJNIEnv; _jspinner: JObject; _txtFontSize: integer);
procedure jSpinner_SetFontSizeUnit(env: PJNIEnv; _jspinner: JObject; _unit: integer);
procedure jSpinner_SetTextAlignment(env: PJNIEnv; _jspinner: JObject; _alignment: integer);
procedure jSpinner_SetFontAndTextTypeFace(env: PJNIEnv; _jspinner: JObject; _fontFace: integer; _fontStyle: integer);
function jSpinner_GetText(env: PJNIEnv; _jspinner: JObject): string;
procedure jSpinner_SetText(env: PJNIEnv; _jspinner: JObject; _index: integer);
procedure jSpinner_SetSelectedIndex(env: PJNIEnv; _jspinner: JObject; _index: integer);
function jSpinner_GetSelectedIndex(env: PJNIEnv; _jspinner: JObject): integer;

procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string; _strTag: string); overload;
function jSpinner_GetItemTagString(env: PJNIEnv; _jspinner: JObject; _index: integer): string;
procedure jSpinner_SetItemTagString(env: PJNIEnv; _jspinner: JObject; _index: integer; _strTag: string);

procedure jSpinner_SetSelectedPaddingTop(env: PJNIEnv; _jspinner: JObject; _padTop: integer);
procedure jSpinner_SetSelectedPaddingBottom(env: PJNIEnv; _jspinner: JObject; _padBottom: integer);
procedure jSpinner_SetFrameGravity(env: PJNIEnv; _jspinner: JObject; _value: integer);
function jSpinner_GetParent(env: PJNIEnv; _jspinner: JObject): jObject;

implementation

{---------  jSpinner  --------------}

constructor jSpinner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;

  FHeight       := 40;
  FWidth        := 100;

  FLParamWidth  := lpHalfOfParent;
  FLParamHeight := lpWrapContent;

  //your code here....
  FItems:= TStringList.Create;
  //TStringList(FItems).OnChange:= ListViewChange;  //TODO

  FSelectedFontColor:= colbrDefault;
  FDropListTextColor:=  colbrDefault;
  FDropListBackgroundColor:=  colbrDefault;
  FLastItemAsPrompt:= False;
  FFontSize:= 0;

  FTextAlignment:= taCenter; //taCenterHorizontal

  FFontFace:= ffNormal;
  FTextTypeFace:= tfNormal;
  FSelectedIndex:= -1;

  FSelectedPaddingTop:= 15;
  FSelectedPaddingBottom:= 5;

end;

destructor jSpinner.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
      if FjObject  <> nil then
      begin
         jFree();
         FjObject := nil;
      end;
  end;
  //you others free code here...'
  FItems.Free;
  inherited Destroy;
end;

procedure jSpinner.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  i: integer;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp);      //  <<--  FjPRLayout:= jForm.view [default]!
   //your code here: set/initialize create params....
   FjObject := jCreate();

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
    jSpinner_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));

   jSpinner_SetViewParent(FjEnv, FjObject , FjPRLayout);
   jSpinner_SetId(FjEnv, FjObject , Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                  FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                  sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, FMarginLeft + FMarginRight ),
                  sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, FMarginTop + FMarginBottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jSpinner_AddlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jSpinner_AddlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jSpinner_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

   if FSelectedFontColor <> colbrDefault then
     Self.SetSelectedTextColor(GetARGB(FCustomColor, FSelectedFontColor));

   if FDropListTextColor <> colbrDefault then
      self.SetDropListTextColor(FDropListTextColor);

   if FDropListBackgroundColor <> colbrDefault then
     Self.SetDropListBackgroundColor(FDropListBackgroundColor);

   if FFontSizeUnit <> unitDefault then
       jSpinner_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

   if FFontSize <> 0 then
     jSpinner_SetTextFontSize(FjEnv, FjObject , FFontSize);

   jSpinner_SetTextAlignment(FjEnv, FjObject , Ord(FTextAlignment));
   jSpinner_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

   for i:= 0 to FItems.Count-1 do
   begin
     jni_proc_ttz( FjEnv, FjObject, 'Add', FItems.Strings[i], '0', false);
   end;

   if FItems.Count > 0 then
   begin
     if FSelectedIndex <= -1  then  FSelectedIndex:= 0;
     if FSelectedIndex >= FItems.Count then FSelectedIndex:= FItems.Count-1;
   end;

   if FLastItemAsPrompt then
   begin
     jSpinner_SetLastItemAsPrompt(FjEnv, FjObject , FLastItemAsPrompt);
     if (FSelectedIndex <> FItems.Count-1) then FSelectedIndex:= FItems.Count-1;
   end;

   if FSelectedPaddingTop <> 15 then
    jSpinner_SetSelectedPaddingTop(FjEnv, FjObject, FSelectedPaddingTop);

   if FSelectedPaddingBottom <> 5 then
    jSpinner_SetSelectedPaddingBottom(FjEnv, FjObject, FSelectedPaddingBottom);

   jSpinner_SetSelectedIndex(FjEnv, FjObject, FSelectedIndex);

   View_SetVisible(FjEnv, FjThis, FjObject, FVisible);
  end;
end;

procedure jSpinner.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

procedure jSpinner.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jSpinner_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jSpinner_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jSpinner_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jSpinner.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jSpinner.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject );
end;

function jSpinner.jCreate(): jObject;
begin
   Result:= jSpinner_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jSpinner.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_jFree(FjEnv, FjObject );
end;

procedure jSpinner.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout:= _viewgroup;
  if FInitialized then
     jSpinner_SetViewParent(FjEnv, FjObject , _viewgroup);
end;

function jSpinner.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSpinner_GetParent(FjEnv, FjObject);
end;


procedure jSpinner.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetLParamWidth(FjEnv, FjObject , _w);
end;

procedure jSpinner.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetLParamHeight(FjEnv, FjObject , _h);
end;

procedure jSpinner.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSpinner.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_AddLParamsAnchorRule(FjEnv, FjObject , _rule);
end;

procedure jSpinner.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_AddLParamsParentRule(FjEnv, FjObject , _rule);
end;

procedure jSpinner.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetLayoutAll(FjEnv, FjObject , _idAnchor);
end;

function jSpinner.GetSelectedItemPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSpinner_GetSelectedItemPosition(FjEnv, FjObject );
end;

function jSpinner.GetSelectedItem(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSpinner_GetSelectedItem(FjEnv, FjObject );
end;

procedure jSpinner.Add(_item: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc_ttz( FjEnv, FjObject, 'Add', _item, '0', true);
     FItems.Add(_item);
  end;
end;

procedure jSpinner.Clear; 
begin
  FItems.Clear;
  JSpinner_Clear(FjEnv, FjObject); 
end; 

procedure jSpinner.SetSelectedTextColor(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetSelectedTextColor(FjEnv, FjObject , _color);
end;

procedure jSpinner.SetDropListTextColor(_color: TARGBColorBridge{integer});
begin
  //in designing component state: set value here...
  FDropListTextColor:= _color;
  if FInitialized then
     jSpinner_SetDropListTextColor(FjEnv, FjObject , GetARGB(FCustomColor, _color));
end;

procedure jSpinner.SetDropListBackgroundColor(_color: TARGBColorBridge{integer});
begin
  //in designing component state: set value here...
  FDropListBackgroundColor:= _color;
  if FInitialized then
     jSpinner_SetDropListBackgroundColor(FjEnv, FjObject , GetARGB(FCustomColor, _color));
end;

procedure jSpinner.SetLastItemAsPrompt(_hasPrompt: boolean);
begin
  //in designing component state: set value here...
  FLastItemAsPrompt:= _hasPrompt;
  if FInitialized then
     jSpinner_SetLastItemAsPrompt(FjEnv, FjObject , _hasPrompt);
end;

function jSpinner.GetSize(): integer;
begin
  //in designing component state: result value here...
  Result:= FItems.Count;
  if FInitialized then
   Result:= jSpinner_GetSize(FjEnv, FjObject );
end;

procedure jSpinner.Delete(_index: integer);
begin
  //in designing component state: set value here...
  FItems.Delete(_index);
  if FInitialized then
     jSpinner_Delete(FjEnv, FjObject , _index);
end;

procedure jSpinner.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetSelection(FjEnv, FjObject , _index);
end;

procedure jSpinner.SetItem(_index: integer; _item: string);
begin
  //in designing component state: set value here...
  FItems.Strings[_index]:= _item;
  if FInitialized then
     jSpinner_SetItem(FjEnv, FjObject , _index ,_item);
end;

procedure jSpinner.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

function jSpinner.GetItems(_delimiter: char): string;
var
  saveDelimiter: char;
begin
  saveDelimiter:= FItems.Delimiter;
  FItems.Delimiter:= _delimiter;
  Result:= FItems.DelimitedText;
  FItems.Delimiter:= saveDelimiter;
end;

procedure jSpinner.GenEvent_OnSpinnerItemSelected(Obj: TObject; caption: string; position: integer);
begin
  if Assigned(FOnItemSelected) then FOnItemSelected(Obj, caption, position);
end;

Procedure jSpinner.SetSelectedFontColor(Value: TARGBColorBridge);
begin
  FSelectedFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
    SetSelectedTextColor(GetARGB(FCustomColor, FSelectedFontColor));
end;

procedure jSpinner.SetFontSize(_txtFontSize: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= _txtFontSize;
  if FInitialized then
     jSpinner_SetTextFontSize(FjEnv, FjObject, _txtFontSize);
end;

procedure jSpinner.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:= _unit;
  if FInitialized then
     jSpinner_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jSpinner.SetTextAlignment(_alignment: TTextAlignment);
begin
  //in designing component state: set value here...
  FTextAlignment:= _alignment;
  if FInitialized then
     jSpinner_SetTextAlignment(FjEnv, FjObject, Ord(_alignment));
end;

procedure jSpinner.SetFontFace(AValue: TFontFace);
begin
 FFontFace:= AValue;
 if(FInitialized) then
   jSpinner_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));
end;

procedure jSpinner.SetTextTypeFace(Value: TTextTypeFace);
begin
  FTextTypeFace:= Value;
  if(FInitialized) then
    jSpinner_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));
end;

function jSpinner.GetText(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    FText:= jSpinner_GetText(FjEnv, FjObject);
  end;
  Result := FText;
end;

procedure jSpinner.SetText(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jSpinner_SetText(FjEnv, FjObject, _index);
     FText:= jSpinner_GetText(FjEnv, FjObject);
  end;
end;

procedure jSpinner.SetSelectedIndex(_index: integer);
begin
  //in designing component state: set value here...
  FSelectedIndex:= _index;
  if FInitialized then
     jSpinner_SetSelectedIndex(FjEnv, FjObject, _index);
end;

function jSpinner.GetSelectedIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    FSelectedIndex:= jSpinner_GetSelectedIndex(FjEnv, FjObject);
  end;
  Result:= FSelectedIndex;
end;

procedure jSpinner.SetItem(_index: integer; _item: string; _strTag: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetItem(FjEnv, FjObject, _index ,_item ,_strTag);
end;

procedure jSpinner.Add(_item: string; _strTag: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc_ttz( FjEnv, FjObject, 'Add', _item, _strTag, true);
     FItems.Add(_item);
  end;
end;

function jSpinner.GetItemTagString(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSpinner_GetItemTagString(FjEnv, FjObject, _index);
end;

procedure jSpinner.SetItemTagString(_index: integer; _strTag: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetItemTagString(FjEnv, FjObject, _index ,_strTag);
end;

procedure jSpinner.SetSelectedPaddingTop(_paddingTop: integer);
begin
  //in designing component state: set value here...
  FSelectedPaddingTop:= _paddingTop;
  if FInitialized then
     jSpinner_SetSelectedPaddingTop(FjEnv, FjObject, _paddingTop);
end;

procedure jSpinner.SetSelectedPaddingBottom(_paddingBottom: integer);
begin
  //in designing component state: set value here...
  FSelectedPaddingBottom:= _paddingBottom;
  if FInitialized then
     jSpinner_SetSelectedPaddingBottom(FjEnv, FjObject, _paddingBottom);
end;

procedure jSpinner.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jSpinner_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));
end;

//TODO
(*
procedure jSpinner.ListViewChange(Sender: TObject);
var
  i: integer;
begin
  {if FInitialized then
  begin
    jSpinner_Clear(FjEnv, FjObject );
    for i:= 0 to FItems.Count - 1 do
    begin
       jSpinner_Add(FjEnv, FjObject , FItems.Strings[i]);
    end;
  end;}
end;
*)

{-------- jSpinner_JNI_Bridge ----------}

function jSpinner_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSpinner_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jSpinner_jCreate(long _Self) {
      return (java.lang.Object)(new jSpinner(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jSpinner_jFree(env: PJNIEnv; _jspinner: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jspinner, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetViewParent(env: PJNIEnv; _jspinner: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetLParamWidth(env: PJNIEnv; _jspinner: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetLParamHeight(env: PJNIEnv; _jspinner: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_AddLParamsAnchorRule(env: PJNIEnv; _jspinner: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_AddLParamsParentRule(env: PJNIEnv; _jspinner: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_ClearLayoutAll(env: PJNIEnv; _JSpinner: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'clearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jspinner, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetLayoutAll(env: PJNIEnv; _jspinner: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetId(env: PJNIEnv; _jspinner: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSpinner_GetSelectedItemPosition(env: PJNIEnv; _jspinner: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSelectedItemPosition', '()I');
  Result:= env^.CallIntMethod(env, _jspinner, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSpinner_getSelectedItem(env: PJNIEnv; _jspinner: JObject): string;
begin
  Result:= jni_func_out_t(env, _jspinner, 'GetSelectedItem');
end;

procedure jSpinner_Clear(env: PJNIEnv; _JSpinner: JObject); 
var 
 JCls: JClass = nil; 
 JMethod: jMethodID = nil; 
begin 
 JCls := env^.GetObjectClass(env, _jspinner); 
 JMethod := env^.GetMethodID(env, jCls, 'Clear', '()V'); 
 env^.CallVoidMethod(env, _JSpinner, JMethod); 
 env^.DeleteLocalRef(env, JCls);
end; 

procedure jSpinner_SetSelectedTextColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetDropListTextColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDropListTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetDropListBackgroundColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDropListBackgroundColor', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetLastItemAsPrompt(env: PJNIEnv; _jspinner: JObject; _hasPrompt: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_hasPrompt);
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLastItemAsPrompt', '(Z)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSpinner_GetSize(env: PJNIEnv; _jspinner: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSize', '()I');
  Result:= env^.CallIntMethod(env, _jspinner, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_Delete(env: PJNIEnv; _jspinner: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'Delete', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpinner_SetSelection(env: PJNIEnv; _jspinner: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelection', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_item));
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItem', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetTextFontSize(env: PJNIEnv; _jspinner: JObject; _txtFontSize: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _txtFontSize;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextFontSize', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetFontSizeUnit(env: PJNIEnv; _jspinner: JObject; _unit: integer);
var
   jParams: array[0..0] of jValue;
   jMethod: jMethodID=nil;
   jCls: jClass=nil;
begin
   jParams[0].i:= _unit;
   jCls:= env^.GetObjectClass(env, _jspinner);
   jMethod:= env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
   env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
   env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetTextAlignment(env: PJNIEnv; _jspinner: JObject; _alignment: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _alignment;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextAlignment', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetFontAndTextTypeFace(env: PJNIEnv; _jspinner: JObject; _fontFace: integer; _fontStyle: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontFace;
  jParams[1].i:= _fontStyle;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontAndTextTypeFace', '(II)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSpinner_GetText(env: PJNIEnv; _jspinner: JObject): string;
begin
  Result:= jni_func_out_t(env, _jspinner, 'GetText');
end;

procedure jSpinner_SetText(env: PJNIEnv; _jspinner: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetText', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetSelectedIndex(env: PJNIEnv; _jspinner: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedIndex', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSpinner_GetSelectedIndex(env: PJNIEnv; _jspinner: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSelectedIndex', '()I');
  Result:= env^.CallIntMethod(env, _jspinner, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string; _strTag: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_item));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_strTag));
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItem', '(ILjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jSpinner_GetItemTagString(env: PJNIEnv; _jspinner: JObject; _index: integer): string;
begin
  Result:= jni_func_i_out_t(env, _jspinner, 'GetItemTagString', _index);
end;

procedure jSpinner_SetItemTagString(env: PJNIEnv; _jspinner: JObject; _index: integer; _strTag: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_strTag));
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTagString', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetSelectedPaddingTop(env: PJNIEnv; _jspinner: JObject; _padTop: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _padTop;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedPaddingTop', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetSelectedPaddingBottom(env: PJNIEnv; _jspinner: JObject; _padBottom: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _padBottom;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedPaddingBottom', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_SetFrameGravity(env: PJNIEnv; _jspinner: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSpinner_GetParent(env: PJNIEnv; _jspinner: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jspinner, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
