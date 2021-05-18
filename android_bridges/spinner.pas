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

procedure jSpinner_SetFontAndTextTypeFace(env: PJNIEnv; _jspinner: JObject; _fontFace: integer; _fontStyle: integer);

procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string; _strTag: string);

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
         jni_free(FjEnv, FjObject);
         FjObject := nil;
      end;
  end;
  //you others free code here...'
  if FItems <> nil then FItems.Free;
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
   FjObject := jSpinner_jCreate(FjEnv, FjThis , int64(Self));

   if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
    View_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));

   View_SetViewParent(FjEnv, FjObject , FjPRLayout);
   View_SetId(FjEnv, FjObject , Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                  FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                  sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, FMarginLeft + FMarginRight ),
                  sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, FMarginTop + FMarginBottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  View_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

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
       SetFontSizeUnit(FFontSizeUnit);

   if FFontSize <> 0 then
     SetFontSize(FFontSize);

   SetTextAlignment(FTextAlignment);
   jSpinner_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

   if FItems <> nil then
   begin
    for i:= 0 to FItems.Count-1 do
     jni_proc_ttz( FjEnv, FjObject, 'Add', FItems.Strings[i], '0', false);

    if FItems.Count > 0 then
    begin
     if FSelectedIndex <= -1  then  FSelectedIndex:= 0;
     if FSelectedIndex >= FItems.Count then FSelectedIndex:= FItems.Count-1;
    end;

    if FLastItemAsPrompt then
    begin
     SetLastItemAsPrompt(FLastItemAsPrompt);
     if (FSelectedIndex <> FItems.Count-1) then FSelectedIndex:= FItems.Count-1;
    end;
   end;

   if FSelectedPaddingTop <> 15 then
    SetSelectedPaddingTop(FSelectedPaddingTop);

   if FSelectedPaddingBottom <> 5 then
    SetSelectedPaddingBottom(FSelectedPaddingBottom);

   SetSelectedIndex(FSelectedIndex);

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
     View_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          View_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         View_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
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

procedure jSpinner.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout:= _viewgroup;
  if FInitialized then
     View_SetViewParent(FjEnv, FjObject , _viewgroup);
end;

function jSpinner.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetParent(FjEnv, FjObject);
end;


procedure jSpinner.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(FjEnv, FjObject , _w);
end;

procedure jSpinner.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(FjEnv, FjObject , _h);
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
     View_AddLParamsAnchorRule(FjEnv, FjObject , _rule);
end;

procedure jSpinner.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsParentRule(FjEnv, FjObject , _rule);
end;

procedure jSpinner.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLayoutAll(FjEnv, FjObject , _idAnchor);
end;

function jSpinner.GetSelectedItemPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetSelectedItemPosition' );
end;

function jSpinner.GetSelectedItem(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetSelectedItem' );
end;

procedure jSpinner.Add(_item: string);
begin
  if FItems = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc_ttz( FjEnv, FjObject, 'Add', _item, '0', true);
     FItems.Add(_item);
  end;
end;

procedure jSpinner.Clear; 
begin
  if FItems = nil then exit;
  FItems.Clear;
  jni_proc(FjEnv, FjObject, 'Clear');
end; 

procedure jSpinner.SetSelectedTextColor(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetSelectedTextColor', _color);
end;

procedure jSpinner.SetDropListTextColor(_color: TARGBColorBridge{integer});
begin
  //in designing component state: set value here...
  FDropListTextColor:= _color;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetDropListTextColor', GetARGB(FCustomColor, _color));
end;

procedure jSpinner.SetDropListBackgroundColor(_color: TARGBColorBridge{integer});
begin
  //in designing component state: set value here...
  FDropListBackgroundColor:= _color;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetDropListBackgroundColor', GetARGB(FCustomColor, _color));
end;

procedure jSpinner.SetLastItemAsPrompt(_hasPrompt: boolean);
begin
  //in designing component state: set value here...
  FLastItemAsPrompt:= _hasPrompt;
  if FjObject = nil then exit;

  jni_proc_z(FjEnv, FjObject, 'SetLastItemAsPrompt', _hasPrompt);
end;

function jSpinner.GetSize(): integer;
begin
  Result := 0;

  if FItems = nil then exit;
  //in designing component state: result value here...
  Result:= FItems.Count;
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetSize' );
end;

procedure jSpinner.Delete(_index: integer);
begin
  if FItems = nil then exit;
  //in designing component state: set value here...

  if (_index >= 0) and (_index < FItems.Count) then
  begin
   FItems.Delete(_index);

   if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'Delete', _index);
  end;
end;

procedure jSpinner.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetSelection', _index);
end;

procedure jSpinner.SetItem(_index: integer; _item: string);
begin
  if FItems = nil then exit;
  //in designing component state: set value here...

  if (_index >= 0) and (_index < FItems.Count) then
  begin
   FItems.Strings[_index]:= _item;

   if FInitialized then
     jni_proc_it(FjEnv, FjObject, 'SetItem', _index ,_item);
  end;
end;

procedure jSpinner.SetItems(Value: TStrings);
begin
  if FItems = nil then exit;
  if Value = nil then exit;

  FItems.Assign(Value);
end;

function jSpinner.GetItems(_delimiter: char): string;
var
  saveDelimiter: char;
begin
  Result := '';

  if FItems = nil then exit;

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
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetTextFontSize', _txtFontSize);
end;

procedure jSpinner.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:= _unit;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

procedure jSpinner.SetTextAlignment(_alignment: TTextAlignment);
begin
  //in designing component state: set value here...
  FTextAlignment:= _alignment;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetTextAlignment', Ord(_alignment));
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
    FText:= jni_func_out_t(FjEnv, FjObject, 'GetText');

  Result := FText;
end;

procedure jSpinner.SetText(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc_i(FjEnv, FjObject, 'SetText', _index);
     FText:= GetText();
  end;
end;

procedure jSpinner.SetSelectedIndex(_index: integer);
begin
  //in designing component state: set value here...
  FSelectedIndex:= _index;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetSelectedIndex', _index);
end;

function jSpinner.GetSelectedIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    FSelectedIndex:= jni_func_out_i(FjEnv, FjObject, 'GetSelectedIndex');
  end;
  Result:= FSelectedIndex;
end;

procedure jSpinner.SetItem(_index: integer; _item: string; _strTag: string);
begin
  if FItems = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
   if (_index >= 0) and (_index < FItems.Count) then
     jSpinner_SetItem(FjEnv, FjObject, _index ,_item ,_strTag);
end;

procedure jSpinner.Add(_item: string; _strTag: string);
begin
  if FItems = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc_ttz( FjEnv, FjObject, 'Add', _item, _strTag, true);
     FItems.Add(_item);
  end;
end;

function jSpinner.GetItemTagString(_index: integer): string;
begin
  if FItems = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
   if (_index >= 0) and (_index < FItems.Count) then
    Result:= jni_func_i_out_t(FjEnv, FjObject, 'GetItemTagString', _index);
end;

procedure jSpinner.SetItemTagString(_index: integer; _strTag: string);
begin
  if FItems = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
   if (_index >= 0) and (_index < FItems.Count) then
     jni_proc_it(FjEnv, FjObject, 'SetItemTagString', _index ,_strTag);
end;

procedure jSpinner.SetSelectedPaddingTop(_paddingTop: integer);
begin
  //in designing component state: set value here...
  FSelectedPaddingTop:= _paddingTop;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetSelectedPaddingTop', _paddingTop);
end;

procedure jSpinner.SetSelectedPaddingBottom(_paddingBottom: integer);
begin
  //in designing component state: set value here...
  FSelectedPaddingBottom:= _paddingBottom;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetSelectedPaddingBottom', _paddingBottom);
end;

procedure jSpinner.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
   View_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));
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
label
  _exceptionOcurred;
begin
  result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jSpinner_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

(*
//Please, you need insert:

   public java.lang.Object jSpinner_jCreate(long _Self) {
      return (java.lang.Object)(new jSpinner(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jSpinner_SetFontAndTextTypeFace(env: PJNIEnv; _jspinner: JObject; _fontFace: integer; _fontStyle: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jspinner);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontAndTextTypeFace', '(II)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _fontFace;
  jParams[1].i:= _fontStyle;

  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string; _strTag: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jspinner);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItem', '(ILjava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_item));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_strTag));

  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
