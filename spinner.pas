unit Spinner;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget;

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

    //FFontSize: integer;

    procedure SetColor(Value: TARGBColorBridge);

    procedure SetItems(Value: TStrings);
    procedure SetSelectedFontColor(Value : TARGBColorBridge);

    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetjParent(_viewgroup: jObject);
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure SetId(_id: integer);
    function GetSelectedItemPosition(): integer;
    function GetSelectedItem(): string;
    procedure Add(_item: string);
    procedure Clear;
    procedure SetSelectedTextColor(_color: integer);
    procedure SetDropListTextColor(_color: TARGBColorBridge {integer});
    procedure SetDropListBackgroundColor(_color: TARGBColorBridge {integer});
    procedure SetLastItemAsPrompt(_hasPrompt: boolean);
    function GetSize(): integer;
    procedure Delete(_index: integer);
    procedure SetSelection(_index: integer);
    procedure SetItem(_index: integer; _item: string);
    procedure SetFontSize(_txtFontSize: DWord);

    property jParent: jObject  read  FjPRLayout write SetjParent; // Java : Parent Relative Layout

    procedure GenEvent_OnSpinnerItemSeleceted(Obj: TObject; caption: string; position: integer);
    property Count: integer read GetSize;
  published

    property Items: TStrings read FItems write SetItems;
    property OnItemSelected: TOnItemSelected  read FOnItemSelected write FOnItemSelected;

    property Visible: boolean read FVisible write SetVisible;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property SelectedFontColor: TARGBColorBridge  read FSelectedFontColor write SetSelectedFontColor;
    property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
    property DropListBackgroundColor: TARGBColorBridge  read FDropListBackgroundColor write SetDropListBackgroundColor;
    property LastItemAsPrompt: boolean read FLastItemAsPrompt write SetLastItemAsPrompt;
    property FontSize: Dword read FFontSize write SetFontSize;
  end;

function jSpinner_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jSpinner_jFree(env: PJNIEnv; _jspinner: JObject);
procedure jSpinner_SetjParent(env: PJNIEnv; _jspinner: JObject; _viewgroup: jObject);
procedure jSpinner_SetLParamWidth(env: PJNIEnv; _jspinner: JObject; _w: integer);
procedure jSpinner_SetLParamHeight(env: PJNIEnv; _jspinner: JObject; _h: integer);
procedure jSpinner_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jspinner: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jSpinner_AddLParamsAnchorRule(env: PJNIEnv; _jspinner: JObject; _rule: integer);
procedure jSpinner_AddLParamsParentRule(env: PJNIEnv; _jspinner: JObject; _rule: integer);
procedure jSpinner_SetLayoutAll(env: PJNIEnv; _jspinner: JObject; _idAnchor: integer);
procedure jSpinner_SetId(env: PJNIEnv; _jspinner: JObject; _id: integer);
function jSpinner_GetSelectedItemPosition(env: PJNIEnv; _jspinner: JObject): integer;
function jSpinner_GetSelectedItem(env: PJNIEnv; _jspinner: JObject): string;
procedure jSpinner_Add(env: PJNIEnv; _jspinner: JObject; _item: string);
procedure jSpinner_Clear(env: PJNIEnv; _JSpinner: JObject);
procedure jSpinner_SetSelectedTextColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
procedure jSpinner_SetDropListTextColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
procedure jSpinner_SetDropListBackgroundColor(env: PJNIEnv; _jspinner: JObject; _color: integer);
procedure jSpinner_SetLastItemAsPrompt(env: PJNIEnv; _jspinner: JObject; _hasPrompt: boolean);
function jSpinner_GetSize(env: PJNIEnv; _jspinner: JObject): integer;
procedure jSpinner_Delete(env: PJNIEnv; _jspinner: JObject; _index: integer);
procedure jSpinner_SetSelection(env: PJNIEnv; _jspinner: JObject; _index: integer);
procedure jSpinner_SetItem(env: PJNIEnv; _jspinner: JObject; _index: integer; _item: string);

procedure jSpinner_SetTextFontSize(env: PJNIEnv; _jspinner: JObject; _txtFontSize: integer);


implementation

uses
  customdialog;

{---------  jSpinner  --------------}

constructor jSpinner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 5;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 5;
  FHeight       := 40;
  FWidth        := 96;
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  //your code here....
  FItems:= TStringList.Create;
  FSelectedFontColor:= colbrDefault;
  FDropListTextColor:=  colbrDefault;
  FDropListBackgroundColor:=  colbrDefault;
  FLastItemAsPrompt:= False;
  FFontSize:= 0;
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
  if FInitialized  then Exit;
  inherited Init(refApp);      //  <<--  FjPRLayout:= jForm.view [default]!
  //your code here: set/initialize create params....
  FjObject := jCreate();
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
  end;
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;
  jSpinner_SetjParent(FjEnv, FjObject , FjPRLayout);
  jSpinner_SetId(FjEnv, FjObject , Self.Id);
  jSpinner_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
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

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  if FSelectedFontColor <> colbrDefault then
     Self.SetSelectedTextColor(GetARGB(FCustomColor, FSelectedFontColor))
  else
     Self.SetSelectedTextColor(GetARGB(FCustomColor, colbrSilver));

  if FDropListTextColor <> colbrDefault then self.SetDropListTextColor(FDropListTextColor);
  if FDropListBackgroundColor <> colbrDefault then  Self.SetDropListBackgroundColor(FDropListBackgroundColor);

  for i:= 0 to FItems.Count-1 do
  begin
    Self.Add(FItems.Strings[i]);
  end;

  if (FLastItemAsPrompt) then Self.SetLastItemAsPrompt(FLastItemAsPrompt);

  if FFontSize <> 0 then
     jSpinner_SetTextFontSize(FjEnv, FjObject , FFontSize);

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);
end;

procedure jSpinner.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

{
procedure jSpinner.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if jForm(Owner).Orientation = jForm(Owner).App.Orientation then
      side:= sdW
    else
      side:= sdH;
    jSpinner_SetLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
  end;
end;

procedure jSpinner.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if jForm(Owner).Orientation = gApp.Orientation then
      side:= sdH
    else
      side:= sdW;
    jSpinner_SetLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
  end;
end;
}

procedure jSpinner.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jSpinner_SetLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jSpinner_SetLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jSpinner_SetLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jSpinner_SetLParamWidth(FjEnv, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
    end;
  end;
end;

procedure jSpinner.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jSpinner_SetLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jSpinner_SetLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jSpinner_SetLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jSpinner_SetLParamHeight(FjEnv, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jSpinner.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jSpinner_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
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

procedure jSpinner.SetjParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout:= _viewgroup;
  if FInitialized then
     jSpinner_SetjParent(FjEnv, FjObject , _viewgroup);
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
     jSpinner_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject , _left ,_top ,_right ,_bottom ,_w ,_h);
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

procedure jSpinner.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpinner_SetId(FjEnv, FjObject , _id);
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
     jSpinner_Add(FjEnv, FjObject , _item);
end;

procedure jSpinner.Clear; 
begin 
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
  if FInitialized then
   Result:= jSpinner_GetSize(FjEnv, FjObject );
end;

procedure jSpinner.Delete(_index: integer);
begin
  //in designing component state: set value here...
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
  if FInitialized then
     jSpinner_SetItem(FjEnv, FjObject , _index ,_item);
end;

procedure jSpinner.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;


procedure jSpinner.GenEvent_OnSpinnerItemSeleceted(Obj: TObject; caption: string; position: integer);
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


procedure jSpinner_SetjParent(env: PJNIEnv; _jspinner: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetjParent', '(Landroid/view/ViewGroup;)V');
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


procedure jSpinner_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jspinner: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
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
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSelectedItem', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jspinner, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpinner_Add(env: PJNIEnv; _jspinner: JObject; _item: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_item));
  jCls:= env^.GetObjectClass(env, _jspinner);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jspinner, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jCls);
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

end.
