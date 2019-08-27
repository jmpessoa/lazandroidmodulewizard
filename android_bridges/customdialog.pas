unit customdialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

  TCustomDialogBackKeyPressed = Procedure(Sender: TObject; title: string) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [12/5/2014 1:49:10]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

  jCustomDialog = class(jVisualControl)
  private
    //FTitle: string;
    FIconIdentifier: string;    // -->>  ../res/drawable  ex: just 'ic_launcher' [not 'ic_launcher.png']
    FOnShow: TCustomDialogShow;
    FOnBackKeyPressed: TCustomDialogBackKeyPressed;
    //FCloseOnBackKeyPressed: boolean;
    //FCanceledOnTouchOutside: boolean;
    FCancelable: boolean;
    FShowTitle : boolean;

    procedure SetColor(Value: TARGBColorBridge); //background
    procedure SetIconIdentifier(_iconIdentifier: string);
  protected
    procedure SetText(_title: string); override;   //****

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent(); override;

    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure Show(); overload;
    procedure Show(_title: string); overload;
    procedure Show(_title: string; _iconIdentifier: string); overload;
    function  GetDialogWidth(): integer;
    function  GetDialogHeight(): integer;
    procedure Close();
    //procedure SetCloseOnBackKeyPressed(_value: boolean);
    //procedure SetCanceledOnTouchOutside(_value: boolean);
     procedure SetCancelable(_value: boolean);

    procedure GenEvent_OnCustomDialogShow(Obj: TObject; dialog: jObject; title: string);
    procedure GenEvent_OnCustomDialogBackKeyPressed(Obj: TObject; title: string);
  published
    property Text: string read GetText write SetText;
    property IconIdentifier: string read FIconIdentifier write SetIconIdentifier;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property CloseOnBackKeyPressed: boolean  read FCloseOnBackKeyPressed write SetCloseOnBackKeyPressed;
    //property CanceledOnTouchOutside: boolean   read FCanceledOnTouchOutside write SetCanceledOnTouchOutside;
    property Cancelable: boolean read FCancelable write SetCancelable;
    property ShowTitle: boolean read FShowTitle write FShowTitle;
    property OnShow: TCustomDialogShow read FOnShow write FOnShow;
    property OnBackKeyPressed: TCustomDialogBackKeyPressed read FOnBackKeyPressed write FOnBackKeyPressed;
  end;

function jCustomDialog_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _showTitle : boolean): jObject;
procedure jCustomDialog_jFree(env: PJNIEnv; _jcustomdialog: JObject);
procedure jCustomDialog_SetViewParent(env: PJNIEnv; _jcustomdialog: JObject; _viewgroup: jObject);
procedure jCustomDialog_RemoveFromViewParent(env: PJNIEnv; _jcustomdialog: JObject);

procedure jCustomDialog_SetLParamWidth(env: PJNIEnv; _jcustomdialog: JObject; _w: integer);
procedure jCustomDialog_SetLParamHeight(env: PJNIEnv; _jcustomdialog: JObject; _h: integer);
procedure jCustomDialog_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcustomdialog: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jCustomDialog_AddLParamsAnchorRule(env: PJNIEnv; _jcustomdialog: JObject; _rule: integer);
procedure jCustomDialog_AddLParamsParentRule(env: PJNIEnv; _jcustomdialog: JObject; _rule: integer);
procedure jCustomDialog_SetLayoutAll(env: PJNIEnv; _jcustomdialog: JObject; _idAnchor: integer);
procedure jCustomDialog_ClearLayoutAll(env: PJNIEnv; _jcustomdialog: JObject);
procedure jCustomDialog_SetId(env: PJNIEnv; _jcustomdialog: JObject; _id: integer);

procedure jCustomDialog_Show(env: PJNIEnv; _jcustomdialog: JObject);overload;
procedure jCustomDialog_Show(env: PJNIEnv; _jcustomdialog: JObject; _title: string);overload;
procedure jCustomDialog_Show(env: PJNIEnv; _jcustomdialog: JObject; _title: string; _iconIdentifier: string);overload;

function  jCustomDialog_GetDialogWidth(env: PJNIEnv; _jcustomdialog: JObject): integer;
function  jCustomDialog_GetDialogHeight(env: PJNIEnv; _jcustomdialog: JObject): integer;

procedure jCustomDialog_SetTitle(env: PJNIEnv; _jcustomdialog: JObject; _title: string);
procedure jCustomDialog_SetIconIdentifier(env: PJNIEnv; _jcustomdialog: JObject; _iconIdentifier: string);
procedure jCustomDialog_Close(env: PJNIEnv; _jcustomdialog: JObject);
//procedure jCustomDialog_SetCloseOnBackKeyPressed(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);
//procedure jCustomDialog_SetCanceledOnTouchOutside(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);
procedure jCustomDialog_SetCancelable(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);


implementation

{---------  jCustomDialog  --------------}

constructor jCustomDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96;
  FWidth        := 300;
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
  //FCloseOnBackKeyPressed:= True;
  //FCanceledOnTouchOutside:= True;
  FCancelable:= True;
  FShowTitle := True;
    //your code here....
  FVisible:= False;
  FIconIdentifier := '';
end;

destructor jCustomDialog.Destroy;
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
  inherited Destroy;
end;

procedure jCustomDialog.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....

   FjObject:= jCreate();   //jSelf/View

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   jCustomDialog_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jCustomDialog_SetId(FjEnv, FjObject, Self.Id);

  end;

  jCustomDialog_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));


  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCustomDialog_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jCustomDialog_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jCustomDialog_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject{FjRLayout}{wiew!}, GetARGB(FCustomColor, FColor));

   {
   if not FCloseOnBackKeyPressed then
    jCustomDialog_SetCloseOnBackKeyPressed(FjEnv, FjObject, FCloseOnBackKeyPressed);

   if not CanceledOnTouchOutside then
     jCustomDialog_SetCanceledOnTouchOutside(FjEnv, FjObject, FCanceledOnTouchOutside);
   }

   if not FCancelable then
      jCustomDialog_SetCancelable(FjEnv, FjObject, FCancelable);

   View_SetVisible(FjEnv, FjThis, FjObject, FVisible);
  end;
end;

procedure jCustomDialog.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject {FjRLayout}{view!}, GetARGB(FCustomColor, FColor)); // @@
end;

procedure jCustomDialog.UpdateLayout;
begin
  if not FInitialized then exit;

  //ClearLayout();

  inherited UpdateLayout;

  if getDialogWidth()  > 0 then FWidth := getDialogWidth();

  //init(gApp);
end;

procedure jCustomDialog.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

function jCustomDialog.GetDialogWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomDialog_GetDialogWidth(FjEnv, FjObject);
end;

function jCustomDialog.GetDialogHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomDialog_GetDialogHeight(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jCustomDialog.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jCustomDialog.jCreate(): jObject;
begin
   Result:= jCustomDialog_jCreate(FjEnv, FjThis , int64(Self), FShowTitle);
end;

procedure jCustomDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_jFree(FjEnv, FjObject);
end;

procedure jCustomDialog.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  //inherited SetViewParent(_viewgroup);
  FjPRLayout:= _viewgroup;
  if FInitialized then
     jCustomDialog_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jCustomDialog.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_RemoveFromViewParent(FjEnv, FjObject);
end;

procedure jCustomDialog.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jCustomDialog.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jCustomDialog.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jCustomDialog.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jCustomDialog.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jCustomDialog.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jCustomDialog.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jCustomDialog_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jCustomDialog_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jCustomDialog_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jCustomDialog.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomDialog_SetId(FjEnv, FjObject, _id);
end;

procedure jCustomDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(FjEnv, FjObject);
     if FText <> '' then
       jCustomDialog_Show(FjEnv, FjObject, FText)
     else
       jCustomDialog_Show(FjEnv, FjObject);
  end;
end;


procedure jCustomDialog.Show(_title: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(FjEnv, FjObject);
     if FIconIdentifier <> '' then
        jCustomDialog_Show(FjEnv, FjObject, _title, FIconIdentifier)
     else
        jCustomDialog_Show(FjEnv, FjObject, _title)
  end;
end;

procedure jCustomDialog.Show(_title: string;  _iconIdentifier: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  FIconIdentifier:= _iconIdentifier;
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(FjEnv, FjObject);
     jCustomDialog_Show(FjEnv, FjObject, _title, _iconIdentifier);
  end;
end;

procedure jCustomDialog.SetText(_title: string);
begin
  //in designing component state: set value here...
  inherited SetText(_title);
  if FInitialized then
    jCustomDialog_SetTitle(FjEnv, FjObject, _title);
end;

procedure jCustomDialog.SetIconIdentifier(_iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCustomDialog_SetIconIdentifier(FjEnv, FjObject, _iconIdentifier);
end;

procedure jCustomDialog.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
    jCustomDialog_Close(FjEnv, FjObject);
end;

{
procedure jCustomDialog.SetCloseOnBackKeyPressed(_value: boolean);
begin
  //in designing component state: set value here...
  FCloseOnBackKeyPressed:= _value;
  if FInitialized then
     jCustomDialog_SetCloseOnBackKeyPressed(FjEnv, FjObject, FCloseOnBackKeyPressed);
end;

procedure jCustomDialog.SetCanceledOnTouchOutside(_value: boolean);
begin
  //in designing component state: set value here...
  FCanceledOnTouchOutside:= _value;
  if FInitialized then
     jCustomDialog_SetCanceledOnTouchOutside(FjEnv, FjObject, FCanceledOnTouchOutside);
end;
}

procedure jCustomDialog.SetCancelable(_value: boolean);
begin
  //in designing component state: set value here...
  FCancelable:= _value;
  if FInitialized then
     jCustomDialog_SetCancelable(FjEnv, FjObject, FCancelable);
end;

procedure jCustomDialog.GenEvent_OnCustomDialogShow(Obj: TObject; dialog: jObject; title: string);
begin
   if Assigned(OnShow) then OnShow(Obj, dialog, title);
end;


procedure jCustomDialog.GenEvent_OnCustomDialogBackKeyPressed(Obj: TObject; title: string);
begin
   if Assigned(FOnBackKeyPressed) then FOnBackKeyPressed(Obj, title);
end;

{-------- jCustomDialog_JNI_Bridge ----------}

function jCustomDialog_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _showTitle : boolean): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_showTitle);
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jCustomDialog_jCreate', '(JZ)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jCustomDialog_jCreate(long _Self) {
      return (java.lang.Object)(new jCustomDialog(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jCustomDialog_jFree(env: PJNIEnv; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_SetViewParent(env: PJNIEnv; _jcustomdialog: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_RemoveFromViewParent(env: PJNIEnv; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_SetLParamWidth(env: PJNIEnv; _jcustomdialog: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_SetLParamHeight(env: PJNIEnv; _jcustomdialog: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcustomdialog: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_AddLParamsAnchorRule(env: PJNIEnv; _jcustomdialog: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_AddLParamsParentRule(env: PJNIEnv; _jcustomdialog: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_SetLayoutAll(env: PJNIEnv; _jcustomdialog: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_ClearLayoutAll(env: PJNIEnv; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomDialog_SetId(env: PJNIEnv; _jcustomdialog: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_Show(env: PJNIEnv; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_Show(env: PJNIEnv; _jcustomdialog: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_Show(env: PJNIEnv; _jcustomdialog: JObject; _title: string; _iconIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jCustomDialog_GetDialogWidth(env: PJNIEnv; _jcustomdialog: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDialogWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jCustomDialog_GetDialogHeight(env: PJNIEnv; _jcustomdialog: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDialogHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_SetTitle(env: PJNIEnv; _jcustomdialog: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_SetIconIdentifier(env: PJNIEnv; _jcustomdialog: JObject; _iconIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIconIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_Close(env: PJNIEnv; _jcustomdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  env^.CallVoidMethod(env, _jcustomdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

{
procedure jCustomDialog_SetCloseOnBackKeyPressed(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCloseOnBackKeyPressed', '(Z)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomDialog_SetCanceledOnTouchOutside(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCanceledOnTouchOutside', '(Z)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
}

procedure jCustomDialog_SetCancelable(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jcustomdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCancelable', '(Z)V');
  env^.CallVoidMethodA(env, _jcustomdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
