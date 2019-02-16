unit radiogroup;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TOnCheckedChanged = procedure(Sender: TObject; checkedIndex: integer; checkedCaption: string) of Object;

TRGOrientation = (rgHorizontal, rgVertical);
{Draft Component code by "Lazarus Android Module Wizard" [12/25/2015 22:08:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jRadioGroup = class(jVisualControl)
 private
    FOrientation: TRGOrientation;
    FOnCheckedChanged: TOnCheckedChanged;
    FCheckedIndex: integer;
    FItems: TStrings;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure Check(_id: integer);
    procedure ClearCheck();
    function GetCheckedRadioButtonId(): integer;
    function GetChildCount(): integer;
    procedure SetOrientation(_orientation: TRGOrientation);

    procedure CheckRadioButtonByCaption(_caption: string);
    procedure CheckRadioButtonByIndex(_index: integer);
    function GetChekedRadioButtonCaption(): string;
    function GetChekedRadioButtonIndex(): integer;
    function IsChekedRadioButtonByCaption(_caption: string): boolean;
    function IsChekedRadioButtonById(_id: integer): boolean;
    function IsChekedRadioButtonByIndex(_index: integer): boolean;

    procedure SetRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);

    procedure SetItems(Value: TStrings);
    procedure Add(_radioTitle: string); overload;
    procedure Add(_radioTitle: string; _color: TARGBColorBridge);  overload;

    procedure GenEvent_CheckedChanged(Sender: TObject; checkedIndex: integer; checkedCaption: string);
    property CheckedIndex: integer read GetChekedRadioButtonIndex write CheckRadioButtonByIndex;
 published
    property Orientation: TRGOrientation read FOrientation write SetOrientation;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnCheckedChanged: TOnCheckedChanged read FOnCheckedChanged write FOnCheckedChanged;
    property Items: TStrings read FItems write SetItems;

end;

function jRadioGroup_jCreate(env: PJNIEnv;_Self: int64; this: jObject; _orientation: integer): jObject;
procedure jRadioGroup_jFree(env: PJNIEnv; _jradiogroup: JObject);
procedure jRadioGroup_SetViewParent(env: PJNIEnv; _jradiogroup: JObject; _viewgroup: jObject);
procedure jRadioGroup_RemoveFromViewParent(env: PJNIEnv; _jradiogroup: JObject);
function jRadioGroup_GetView(env: PJNIEnv; _jradiogroup: JObject): jObject;
procedure jRadioGroup_SetLParamWidth(env: PJNIEnv; _jradiogroup: JObject; _w: integer);
procedure jRadioGroup_SetLParamHeight(env: PJNIEnv; _jradiogroup: JObject; _h: integer);
procedure jRadioGroup_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jradiogroup: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jRadioGroup_AddLParamsAnchorRule(env: PJNIEnv; _jradiogroup: JObject; _rule: integer);
procedure jRadioGroup_AddLParamsParentRule(env: PJNIEnv; _jradiogroup: JObject; _rule: integer);
procedure jRadioGroup_SetLayoutAll(env: PJNIEnv; _jradiogroup: JObject; _idAnchor: integer);
procedure jRadioGroup_ClearLayoutAll(env: PJNIEnv; _jradiogroup: JObject);
procedure jRadioGroup_SetId(env: PJNIEnv; _jradiogroup: JObject; _id: integer);
procedure jRadioGroup_Check(env: PJNIEnv; _jradiogroup: JObject; _id: integer);
procedure jRadioGroup_ClearCheck(env: PJNIEnv; _jradiogroup: JObject);
function jRadioGroup_GetCheckedRadioButtonId(env: PJNIEnv; _jradiogroup: JObject): integer;
function jRadioGroup_GetChildCount(env: PJNIEnv; _jradiogroup: JObject): integer;
procedure jRadioGroup_SetOrientation(env: PJNIEnv; _jradiogroup: JObject; _orientation: integer);
procedure jRadioGroup_CheckRadioButtonByCaption(env: PJNIEnv; _jradiogroup: JObject; _caption: string);
procedure jRadioGroup_CheckRadioButtonByIndex(env: PJNIEnv; _jradiogroup: JObject; _index: integer);
function jRadioGroup_GetChekedRadioButtonCaption(env: PJNIEnv; _jradiogroup: JObject): string;
function jRadioGroup_GetChekedRadioButtonIndex(env: PJNIEnv; _jradiogroup: JObject): integer;
function jRadioGroup_IsChekedRadioButtonByCaption(env: PJNIEnv; _jradiogroup: JObject; _caption: string): boolean;
function jRadioGroup_IsChekedRadioButtonById(env: PJNIEnv; _jradiogroup: JObject; _id: integer): boolean;
function jRadioGroup_IsChekedRadioButtonByIndex(env: PJNIEnv; _jradiogroup: JObject; _index: integer): boolean;
procedure jRadioGroup_SetRoundCorner(env: PJNIEnv; _jradiogroup: JObject);
procedure jRadioGroup_SetRadiusRoundCorner(env: PJNIEnv; _jradiogroup: JObject; _radius: integer);
procedure jRadioGroup_Add(env: PJNIEnv; _jradiogroup: JObject; _radioTitle: string); overload;
procedure jRadioGroup_Add(env: PJNIEnv; _jradiogroup: JObject; _radioTitle: string; _color: integer); overload;


implementation

{---------  jRadioGroup  --------------}

constructor jRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 96; //??
  FLParamWidth  := lpWrapContent;//lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
  FOrientation:= rgVertical;
  FCheckedIndex:= -1;
  FItems:= TStringList.Create;
end;

destructor jRadioGroup.Destroy;
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

procedure jRadioGroup.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  i: integer;
begin

  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject:= jCreate(); //jSelf !

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jRadioGroup_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jRadioGroup_SetId(FjEnv, FjObject, Self.Id);
  end;

  jRadioGroup_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jRadioGroup_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jRadioGroup_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jRadioGroup_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));


   for i:= 0 to FItems.Count-1 do
   begin
    if FItems.Strings[i] <> '' then
        jRadioGroup_Add(FjEnv, FjObject , FItems.Strings[i]);
   end;

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jRadioGroup.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jRadioGroup.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jRadioGroup.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jRadioGroup.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal

procedure jRadioGroup.GenEvent_CheckedChanged(Sender: TObject; checkedIndex: integer; checkedCaption: string);
begin
  if Assigned(FOnCheckedChanged) then FOnCheckedChanged(Sender, checkedIndex, checkedCaption);
end;


function jRadioGroup.jCreate(): jObject;
begin
   Result:= jRadioGroup_jCreate(FjEnv, int64(Self), FjThis, Ord(FOrientation));
end;

procedure jRadioGroup.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_jFree(FjEnv, FjObject);
end;

procedure jRadioGroup.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout:= _viewgroup;  // <<--------------
  if FInitialized then
     jRadioGroup_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jRadioGroup.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_RemoveFromViewParent(FjEnv, FjObject);
end;

function jRadioGroup.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_GetView(FjEnv, FjObject);
end;

procedure jRadioGroup.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jRadioGroup.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jRadioGroup.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jRadioGroup.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jRadioGroup.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jRadioGroup.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jRadioGroup.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jRadioGroup_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jRadioGroup_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jRadioGroup_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jRadioGroup.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetId(FjEnv, FjObject, _id);
end;

procedure jRadioGroup.Check(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_Check(FjEnv, FjObject, _id);
end;

procedure jRadioGroup.ClearCheck();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_ClearCheck(FjEnv, FjObject);
end;

function jRadioGroup.GetCheckedRadioButtonId(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_GetCheckedRadioButtonId(FjEnv, FjObject);
end;

function jRadioGroup.GetChildCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_GetChildCount(FjEnv, FjObject);
end;

procedure jRadioGroup.SetOrientation(_orientation: TRGOrientation);
begin
  //in designing component state: set value here...
  FOrientation:= _orientation;
  if FInitialized then
     jRadioGroup_SetOrientation(FjEnv, FjObject, Ord(_orientation));
end;

procedure jRadioGroup.CheckRadioButtonByCaption(_caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_CheckRadioButtonByCaption(FjEnv, FjObject, _caption);
end;

procedure jRadioGroup.CheckRadioButtonByIndex(_index: integer);
begin
  //in designing component state: set value here...
  FCheckedIndex:= _index;
  if FInitialized then
     jRadioGroup_CheckRadioButtonByIndex(FjEnv, FjObject, _index);
end;

function jRadioGroup.GetChekedRadioButtonCaption(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_GetChekedRadioButtonCaption(FjEnv, FjObject);
end;

function jRadioGroup.GetChekedRadioButtonIndex(): integer;
begin
  //in designing component state: result value here...
  Result:= FCheckedIndex;
  if FInitialized then
   Result:= jRadioGroup_GetChekedRadioButtonIndex(FjEnv, FjObject);
end;

function jRadioGroup.IsChekedRadioButtonByCaption(_caption: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_IsChekedRadioButtonByCaption(FjEnv, FjObject, _caption);
end;

function jRadioGroup.IsChekedRadioButtonById(_id: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_IsChekedRadioButtonById(FjEnv, FjObject, _id);
end;

function jRadioGroup.IsChekedRadioButtonByIndex(_index: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRadioGroup_IsChekedRadioButtonByIndex(FjEnv, FjObject, _index);
end;

procedure jRadioGroup.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetRoundCorner(FjEnv, FjObject);
end;

procedure jRadioGroup.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_SetRadiusRoundCorner(FjEnv, FjObject, _radius);
end;

procedure jRadioGroup.SetItems(Value: TStrings);
var
  i: integer;
begin
  FItems.Assign(Value);

  if FInitialized then
  begin
    for i:= 0 to FItems.Count - 1 do
    begin
       if FItems.Strings[i] <> '' then
         jRadioGroup_Add(FjEnv, FjObject , FItems.Strings[i]);
    end;
  end;

end;

procedure jRadioGroup.Add(_radioTitle: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_Add(FjEnv, FjObject, _radioTitle);
end;

procedure jRadioGroup.Add(_radioTitle: string; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioGroup_Add(FjEnv, FjObject, _radioTitle ,GetARGB(FCustomColor, _color));
end;

{-------- jRadioGroup_JNI_Bridge ----------}

function jRadioGroup_jCreate(env: PJNIEnv;_Self: int64; this: jObject; _orientation: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].i:= _orientation;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jRadioGroup_jCreate', '(JI)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jRadioGroup_jCreate(long _Self, int _orientation) {
      return (java.lang.Object)(new jRadioGroup(this,_Self,_orientation));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jRadioGroup_jFree(env: PJNIEnv; _jradiogroup: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_SetViewParent(env: PJNIEnv; _jradiogroup: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_RemoveFromViewParent(env: PJNIEnv; _jradiogroup: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_GetView(env: PJNIEnv; _jradiogroup: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/widget/RadioGroup;');
  Result:= env^.CallObjectMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_SetLParamWidth(env: PJNIEnv; _jradiogroup: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_SetLParamHeight(env: PJNIEnv; _jradiogroup: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jradiogroup: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_AddLParamsAnchorRule(env: PJNIEnv; _jradiogroup: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_AddLParamsParentRule(env: PJNIEnv; _jradiogroup: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_SetLayoutAll(env: PJNIEnv; _jradiogroup: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_ClearLayoutAll(env: PJNIEnv; _jradiogroup: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_SetId(env: PJNIEnv; _jradiogroup: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_Check(env: PJNIEnv; _jradiogroup: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'Check', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_ClearCheck(env: PJNIEnv; _jradiogroup: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearCheck', '()V');
  env^.CallVoidMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_GetCheckedRadioButtonId(env: PJNIEnv; _jradiogroup: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCheckedRadioButtonId', '()I');
  Result:= env^.CallIntMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_GetChildCount(env: PJNIEnv; _jradiogroup: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'GetChildCount', '()I');
  Result:= env^.CallIntMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jRadioGroup_SetOrientation(env: PJNIEnv; _jradiogroup: JObject; _orientation: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _orientation;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOrientation', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_CheckRadioButtonByCaption(env: PJNIEnv; _jradiogroup: JObject; _caption: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckRadioButtonByCaption', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_CheckRadioButtonByIndex(env: PJNIEnv; _jradiogroup: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckRadioButtonByIndex', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_GetChekedRadioButtonCaption(env: PJNIEnv; _jradiogroup: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'GetChekedRadioButtonCaption', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jradiogroup, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_GetChekedRadioButtonIndex(env: PJNIEnv; _jradiogroup: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'GetChekedRadioButtonIndex', '()I');
  Result:= env^.CallIntMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_IsChekedRadioButtonByCaption(env: PJNIEnv; _jradiogroup: JObject; _caption: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'IsChekedRadioButtonByCaption', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jradiogroup, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_IsChekedRadioButtonById(env: PJNIEnv; _jradiogroup: JObject; _id: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'IsChekedRadioButtonById', '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jradiogroup, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jRadioGroup_IsChekedRadioButtonByIndex(env: PJNIEnv; _jradiogroup: JObject; _index: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'IsChekedRadioButtonByIndex', '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jradiogroup, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jRadioGroup_SetRoundCorner(env: PJNIEnv; _jradiogroup: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRoundCorner', '()V');
  env^.CallVoidMethod(env, _jradiogroup, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jRadioGroup_SetRadiusRoundCorner(env: PJNIEnv; _jradiogroup: JObject; _radius: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _radius;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRadiusRoundCorner', '(I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jRadioGroup_Add(env: PJNIEnv; _jradiogroup: JObject; _radioTitle: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_radioTitle));
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRadioGroup_Add(env: PJNIEnv; _jradiogroup: JObject; _radioTitle: string; _color: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_radioTitle));
  jParams[1].i:= _color;
  jCls:= env^.GetObjectClass(env, _jradiogroup);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jradiogroup, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
