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
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
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
        jni_free(gApp.jni.jEnv, FjObject);
        FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jCustomDialog.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....

   FjObject := jCustomDialog_jCreate(gApp.jni.jEnv, gApp.jni.jThis , int64(Self), FShowTitle);

   if FjObject = nil then exit;   //jSelf/View

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   View_Setid(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
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
    View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject{FjRLayout}{wiew!}, GetARGB(FCustomColor, FColor));

   {
   if not FCloseOnBackKeyPressed then
    jCustomDialog_SetCloseOnBackKeyPressed(gApp.jni.jEnv, FjObject, FCloseOnBackKeyPressed);

   if not CanceledOnTouchOutside then
     jCustomDialog_SetCanceledOnTouchOutside(gApp.jni.jEnv, FjObject, FCanceledOnTouchOutside);
   }

   if not FCancelable then
      SetCancelable(FCancelable);

   View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
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
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject {FjRLayout}{view!}, GetARGB(FCustomColor, FColor)); // @@
end;

procedure jCustomDialog.UpdateLayout;
begin
  if not FInitialized then exit;

  //ClearLayout();

  inherited UpdateLayout;

  if getDialogWidth()  > 0 then FWidth := getDialogWidth();

  //init;
end;

procedure jCustomDialog.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

function jCustomDialog.GetDialogWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetDialogWidth');
end;

function jCustomDialog.GetDialogHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetDialogHeight');
end;

//Event : Java -> Pascal
procedure jCustomDialog.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jCustomDialog.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  //inherited SetViewParent(_viewgroup);
  FjPRLayout:= _viewgroup;
  if FjObject <> nil then
     View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jCustomDialog.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jCustomDialog.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jCustomDialog.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jCustomDialog.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jCustomDialog.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

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
     //jCustomDialog_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
     if FText <> '' then
       jni_proc_t(gApp.jni.jEnv, FjObject, 'Show', FText)
     else
       jni_proc(gApp.jni.jEnv, FjObject, 'Show');
  end;
end;


procedure jCustomDialog.Show(_title: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
     if FIconIdentifier <> '' then
        jni_proc_tt(gApp.jni.jEnv, FjObject, 'Show', _title, FIconIdentifier)
     else
        jni_proc_t(gApp.jni.jEnv, FjObject, 'Show', _title)
  end;
end;

procedure jCustomDialog.Show(_title: string;  _iconIdentifier: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  FIconIdentifier:= _iconIdentifier;
  if FInitialized then
  begin
     //jCustomDialog_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
     jni_proc_tt(gApp.jni.jEnv, FjObject, 'Show', _title, _iconIdentifier);
  end;
end;

procedure jCustomDialog.SetText(_title: string);
begin
  //in designing component state: set value here...
  inherited SetText(_title);
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetTitle', _title);
end;

procedure jCustomDialog.SetIconIdentifier(_iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetIconIdentifier', _iconIdentifier);
end;

procedure jCustomDialog.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Close');
end;

{
procedure jCustomDialog.SetCloseOnBackKeyPressed(_value: boolean);
begin
  //in designing component state: set value here...
  FCloseOnBackKeyPressed:= _value;
  if FInitialized then
     jCustomDialog_SetCloseOnBackKeyPressed(gApp.jni.jEnv, FjObject, FCloseOnBackKeyPressed);
end;

procedure jCustomDialog.SetCanceledOnTouchOutside(_value: boolean);
begin
  //in designing component state: set value here...
  FCanceledOnTouchOutside:= _value;
  if FInitialized then
     jCustomDialog_SetCanceledOnTouchOutside(gApp.jni.jEnv, FjObject, FCanceledOnTouchOutside);
end;
}

procedure jCustomDialog.SetCancelable(_value: boolean);
begin
  //in designing component state: set value here...
  FCancelable:= _value;

  if FjObject <> nil then
     jni_proc_z(gApp.jni.jEnv, FjObject, 'SetCancelable', FCancelable);
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
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jCustomDialog_jCreate', '(JZ)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_showTitle);

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
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
