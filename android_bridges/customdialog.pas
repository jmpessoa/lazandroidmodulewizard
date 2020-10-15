unit customdialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type
  TCustomDialogShow = Procedure(Sender: TObject; dialog: jObject; title: string) of Object;
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

    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure Show(); overload;
    procedure Show(_title: string); overload;
    procedure Show(_title: string; _iconIdentifier: string); overload;
    function  GetWidth : integer; override;
    function  GetHeight : integer; override;
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

//procedure jCustomDialog_SetCloseOnBackKeyPressed(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);
//procedure jCustomDialog_SetCanceledOnTouchOutside(env: PJNIEnv; _jcustomdialog: JObject; _value: boolean);


implementation

{---------  jCustomDialog  --------------}

constructor jCustomDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
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

   FjObject := jCreate(); if FjObject = nil then exit;   //jSelf/View

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   SetViewParent(FjPRLayout);
   jni_proc_i(FjEnv, FjObject, 'setId', Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                  FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                  sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                  sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
    if rToA in FPositionRelativeToAnchor then
      AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));

  for rToP := rpBottom to rpCenterVertical do
    if rToP in FPositionRelativeToParent then
      AddLParamsParentRule(GetPositionRelativeToParent(rToP));

  if Self.Anchor <> nil then
   Self.AnchorId:= Self.Anchor.Id
  else
   Self.AnchorId:= -1; //dummy

  SetLayoutAll(Self.AnchorId);

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
      SetCancelable(FCancelable);

   View_SetVisible(FjEnv, FjThis, FjObject, FVisible);
  end;
end;

function jCustomDialog.GetWidth: integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if GetDialogWidth() <> 0 then
   Result := GetDialogWidth()
  else
   Result := sysGetWidthOfParent(FParent);
end;

function jCustomDialog.GetHeight: integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if GetDialogHeight() <> 0 then
   Result := GetDialogHeight()
  else
   Result := sysGetHeightOfParent(FParent);
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
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetDialogWidth');
end;

function jCustomDialog.GetDialogHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetDialogHeight');
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
     jni_proc(FjEnv, FjObject, 'jFree');
end;

procedure jCustomDialog.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  //inherited SetViewParent(_viewgroup);
  FjPRLayout:= _viewgroup;
  if FjObject <> nil then
     jni_proc_vig(FjEnv, FjObject, 'SetViewParent', FjPRLayout);
end;

procedure jCustomDialog.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RemoveFromViewParent');
end;

procedure jCustomDialog.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'AddLParamsAnchorRule', _rule);
end;

procedure jCustomDialog.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'AddLParamsParentRule', _rule);
end;

procedure jCustomDialog.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'SetLayoutAll', _idAnchor);
end;

procedure jCustomDialog.ClearLayout();
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
          AddLParamsParentRule(GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jCustomDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(FjEnv, FjObject);
     if FText <> '' then
       jni_proc_t(FjEnv, FjObject, 'Show', FText)
     else
       jni_proc(FjEnv, FjObject, 'Show');
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
        jni_proc_tt(FjEnv, FjObject, 'Show', _title, FIconIdentifier)
     else
        jni_proc_t(FjEnv, FjObject, 'Show', _title)
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
     jni_proc_tt(FjEnv, FjObject, 'Show', _title, _iconIdentifier);
  end;
end;

procedure jCustomDialog.SetText(_title: string);
begin
  //in designing component state: set value here...
  inherited SetText(_title);
  if FInitialized then
    jni_proc_t(FjEnv, FjObject, 'SetTitle', _title);
end;

procedure jCustomDialog.SetIconIdentifier(_iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(FjEnv, FjObject, 'SetIconIdentifier', _iconIdentifier);
end;

procedure jCustomDialog.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(FjEnv, FjObject, 'Close');
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

  if FjObject <> nil then
     jni_proc_z(FjEnv, FjObject, 'SetCancelable', FCancelable);
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

end.
