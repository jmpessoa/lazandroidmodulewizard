unit gdxform;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TGdxKeyPressedAction = (kaNone, kaCloseScreen, kaAppExit);
TGdxKeyCode = (kcUnknown, kcBackKey);

TOnGDXFormShow=procedure(Sender:TObject) of object;
TOnGDXFormResize=procedure(Sender:TObject;width:integer;height:integer) of object;
TOnGDXFormRender=procedure(Sender:TObject;deltaTime:single) of object;
TOnGDXFormClose=procedure(Sender:TObject) of object;
TOnGDXFormTouchDown=procedure(Sender:TObject;screenX:integer;screenY:integer;pointer:integer;button:integer) of object;
TOnGDXFormTouchUp=procedure(Sender:TObject;screenX:integer;screenY:integer;pointer:integer;button:integer) of object;
TOnGDXFormKeyPressed=procedure(Sender:TObject;keyCode:TGdxKeyCode{;var outActionReturn:TGdxKeyPressedAction}) of object;

TOnGDXFormResume=procedure(Sender:TObject) of object;
TOnGDXFormPause=procedure(Sender:TObject) of object;
TOnGDXFormHide=procedure(Sender:TObject) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [10/7/2019 15:06:20]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

{ jGdxForm }

jGdxForm = class(TAndroidForm)
 private
    //FActive: boolean;
    FOnGDXFormShow: TOnGDXFormShow;
    FOnGDXFormResize: TOnGDXFormResize;
    FOnGDXFormRender: TOnGDXFormRender;
    FOnGDXFormClose: TOnGDXFormClose;
    FOnGDXFormTouchDown: TOnGDXFormTouchDown;
    FOnGDXFormTouchUp: TOnGDXFormTouchUp;
    FOnGDXFormKeyPressed: TOnGDXFormKeyPressed;
    FOnGDXFormResume: TOnGDXFormResume;
    FOnGDXFormPause: TOnGDXFormPause;
    FOnGDXFormHide: TOnGDXFormHide;

    //  http://www.informit.com/articles/article.aspx?p=28278&seqNum=4
    {
    procedure ReadIntWidth(Reader: TReader);   //hiding   in ".lfm"
    procedure WriteIntWidth(Writer: TWriter);  //

    procedure ReadIntHeight(Reader: TReader);   //hiding  in ".lfm"
    procedure WriteIntHeight(Writer: TWriter);  //
     }
 protected
    procedure SetActivityMode(Value: TActivityMode); override;
    //procedure DefineProperties(Filer: TFiler); override;  //hiding  "gdxactivityMode"  in ".lfm"
 public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNew(AOwner: TComponent);

    destructor Destroy; override;
    procedure Init; override;
    procedure ReInit;
    function jCreate( _active: boolean): jObject;
    procedure jFree();

    Procedure Close;
    procedure Finish();
    procedure Show();

    function GetWidth(): integer; override;
    function GetHeight(): integer;  override;
    procedure SetWidth(const AValue: integer);
    procedure SetHeight(const AValue: integer);

    procedure ClearColor(_red: single; _green: single; _blue: single; _alpha: single);
    function GetGamePlayingSeconds(): int64;
    function GetGameRenderCount(): int64;
    function GetGameStartTimeMilliSeconds(): int64;
    function GetGameEndTimeMilliSeconds(): int64;
    function GetGameCurrentTimeMilliSeconds(): int64;

    procedure GenEvent_OnGDXFormShow(Sender:TObject);
    procedure GenEvent_OnGDXFormResize(Sender:TObject;width:integer;height:integer);
    procedure GenEvent_OnGDXFormRender(Sender:TObject;deltaTime:single);
    procedure GenEvent_OnGDXFormClose(Sender:TObject);
    procedure GenEvent_OnGDXFormTouchDown(Sender:TObject;screenX:integer;screenY:integer;pointer:integer;button:integer);
    procedure GenEvent_OnGDXFormTouchUp(Sender:TObject;screenX:integer;screenY:integer;pointer:integer;button:integer);
    procedure GenEvent_OnGDXFormKeyPressed(Sender:TObject;keyCode:integer{;var outReturn:integer});
    procedure GenEvent_OnGDXFormResume(Sender:TObject);
    procedure GenEvent_OnGDXFormPause(Sender:TObject);
    procedure GenEvent_OnGDXFormHide(Sender:TObject);

 published
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;

    property ActivityMode: TActivityMode read FActivityMode write SetActivityMode;
    property OnShow: TOnGDXFormShow read FOnGDXFormShow write FOnGDXFormShow;
    property OnKeyPressed: TOnGDXFormKeyPressed read FOnGDXFormKeyPressed write FOnGDXFormKeyPressed;
    property OnResize: TOnGDXFormResize read FOnGDXFormResize write FOnGDXFormResize;
    property OnRender: TOnGDXFormRender read FOnGDXFormRender write FOnGDXFormRender;
    property OnClose: TOnGDXFormClose read FOnGDXFormClose write FOnGDXFormClose;
    property OnResume: TOnGDXFormResume read FOnGDXFormResume write FOnGDXFormResume;
    property OnPause: TOnGDXFormPause read FOnGDXFormPause write FOnGDXFormPause;
    property OnHide: TOnGDXFormHide read FOnGDXFormHide write FOnGDXFormHide;
    property OnTouchDown: TOnGDXFormTouchDown read FOnGDXFormTouchDown write FOnGDXFormTouchDown;
    property OnTouchUp: TOnGDXFormTouchUp read FOnGDXFormTouchUp write FOnGDXFormTouchUp;
end;

function jGdxForm_jCreate(env: PJNIEnv;_Self: int64; _active: boolean; this: jObject): jObject;
procedure jGdxForm_jFree(env: PJNIEnv; _jgdxform: JObject);

procedure jGdxForm_Show(env: PJNIEnv; _jgdxform: JObject);

function jGdxForm_GetWidth(env: PJNIEnv; _jgdxform: JObject): integer;
function jGdxForm_GetHeight(env: PJNIEnv; _jgdxform: JObject): integer;
procedure jGdxForm_ClearColor(env: PJNIEnv; _jgdxform: JObject; _red: single; _green: single; _blue: single; _alpha: single);
function jGdxForm_GetGamePlayingSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
function jGdxForm_GetGameRenderCount(env: PJNIEnv; _jgdxform: JObject): int64;
function jGdxForm_GetGameStartTimeMilliSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
function jGdxForm_GetGameEndTimeMilliSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
function jGdxForm_GetGameCurrentTimeMilliSeconds(env: PJNIEnv; _jgdxform: JObject): int64;


implementation

{---------  jGdxForm  --------------}

constructor jGdxForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner); //don't load stream
end;

{
procedure jGdxForm.ReadIntWidth(Reader: TReader);
begin
   FWidth:= Reader.ReadInteger;
end;

procedure jGdxForm.WriteIntWidth(Writer: TWriter);
begin
    Writer.WriteInteger(FWidth);
end;

procedure jGdxForm.ReadIntHeight(Reader: TReader);
begin
  FHeight:= Reader.ReadInteger;
end;

procedure jGdxForm.WriteIntHeight(Writer: TWriter);
begin
  Writer.WriteInteger(FHeight);
end;

procedure jGdxForm.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Width', ReadIntWidth, WriteIntWidth, Width<>0);
  Filer.DefineProperty('Height', ReadIntHeight, WriteIntHeight, Height<>0);
end;
}

procedure jGdxForm.SetActivityMode(Value: TActivityMode);
begin
  if  (Value = actMain) or (Value = actGdxScreen)  then
    FActivityMode:= Value;
end;

constructor jGdxForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner); //no stream loaded yet. {thanks to  x2nie !!}

  FjObject:= nil;
  FVisible:= False;
  FormState:= fsFormCreate;

  FModuleType:= -1; //gdx
  FActivityMode:= ActivityModeDesign; //actMain;  //actMain, actRecyclable, actSplash, act...

  FScreenWH.Height:= 320; //dummy
  FScreenWH.Width:= 400;
  FWidth := 320;
  FHeight := 400;

  FScreenStyle:= ssUnknown;

  FInitialized:= False;
  Finished:= False;
  FormBaseIndex:= -1;  //dummy - main form not have a form base
  FormIndex:= -1;      //dummy

  //now load the stream
  //InitInheritedComponent(Self, TAndroidWidget {TAndroidForm});
  InitInheritedComponent(Self, jGdxForm {Need for Android 12});

end;

procedure jGdxForm.Init;
var
  i: integer;
begin

    if FInitialized  then Exit;
    if gApp = nil then Exit;
  
    if not gApp.Initialized then Exit;

    inherited Init;

    FVisible := False;

    if FActivityMode =  actMain then  //actMain
    begin
       FVisible := True;
       Randomize;
    end;

    FjObject:= jCreate(Self.Visible); //jSelf !

    FInitialized:= True;

    FScreenStyle:= gApp.Orientation;
    FScreenWH:= gApp.Screen.WH;   //sAved on start!
    FPackageName:= gApp.AppName;

    for i:= (Self.ComponentCount-1) downto 0 do
    begin
      if (Self.Components[i] is jControl) then
      begin
         (Self.Components[i] as jControl).Init;
      end;
    end;

    if gApp.GetCurrentFormsIndex = (cjFormsMax-1) then Exit; //no more form is possible!
    
    FormBaseIndex:= gApp.TopIndex;           //initial = -1

    if FormIndex < 0 then //if it is a new form .... [not a ReInit form ...]
        FormIndex:= gApp.GetNewFormsIndex;  //first valid index = 0;

    gApp.Forms.Stack[FormIndex].Form:= Self;
    FormState:= fsFormWork;

    if FVisible then
    begin
      gApp.TopIndex:= FormIndex;
    end;

end;

procedure jGdxForm.ReInit;
var
  i: integer;
begin

  if not FInitialized then
  begin
     Self.Init;
     Exit;
  end;

  for i:= (Self.ComponentCount-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
       (Self.Components[i] as jControl).Initialized:= False;
    end;
  end;

  self.Initialized:= False;
  Self.Init;
end;

function jGdxForm.jCreate( _active: boolean): jObject;
begin
   Result:= jGdxForm_jCreate(gApp.jni.jEnv, int64(Self) ,_active, gApp.jni.jThis);
end;

destructor jGdxForm.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       if FInitialized and (not Finished) then
       begin
          jFree();
          gApp.jni.jEnv^.DeleteGlobalRef(gApp.jni.jEnv,FjObject);
          FjObject:= nil;
       end;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jGdxForm.jFree();
begin
  //in designing component state: set value here...
  if (FInitialized) and (FjObject <> nil) then
     jGdxForm_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jGdxForm.Finish();
begin
  if FInitialized and (not Finished)  then
  begin
    jFree();
    Finished:= True;
  end;
end;

//called by Java_Event_pAppOnBackPressed
procedure jGdxForm.Close;
var
   Inx, formBaseInx: integer;
begin

   if Assigned(FOnGDXFormClose) then FOnGDXFormClose(Self);

   Inx:= FormIndex;
   //Prevents the error that is called close before it has been show [by TR3E]

   if Inx = gapp.TopIndex then
   begin
     formBaseInx:= FormBaseIndex;
     gApp.TopIndex:= formBaseInx; //update topIndex...
   end else
     formBaseInx:= -1;

   FVisible:= False;

   if FActivityMode = actMain {or (FormBaseIndex = -1)}  then
   begin
     Self.Finish();
     gApp.Finish;
   end
   else
   begin
     Self.jFree();
     if formBaseInx >= 0 then    //try backtracking...
        jGdxForm(gApp.Forms.Stack[formBaseInx].Form).Show;
   end;

end;

procedure jGdxForm.Show();
begin

  //in designing component state: set value here...
  if FInitialized then
  begin
    FormState:= fsFormWork;
    FormBaseIndex:= gApp.TopIndex;
    gApp.TopIndex:= Self.FormIndex;
    FVisible:= True;
    jGdxForm_Show(gApp.jni.jEnv, FjObject);
  end;

end;

function jGdxForm.GetWidth(): integer;
begin
  //in designing component state: result value here...
  Result:= FWidth;
  if FInitialized then
   Result:= jGdxForm_GetWidth(gApp.jni.jEnv, FjObject);
end;

function jGdxForm.GetHeight(): integer;
begin
  //in designing component state: result value here...
  Result:= FHeight;
  if FInitialized then
   Result:= jGdxForm_GetHeight(gApp.jni.jEnv, FjObject);
end;

procedure jGdxForm.SetWidth(const AValue: integer);
begin
  FWidth:= AValue;
end;

procedure jGdxForm.SetHeight(const AValue: integer);
begin
  FHeight:= AValue;
end;

procedure jGdxForm.ClearColor(_red: single; _green: single; _blue: single; _alpha: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxForm_ClearColor(gApp.jni.jEnv, FjObject, _red ,_green ,_blue ,_alpha);
end;

function jGdxForm.GetGamePlayingSeconds(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxForm_GetGamePlayingSeconds(gApp.jni.jEnv, FjObject);
end;

function jGdxForm.GetGameRenderCount(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxForm_GetGameRenderCount(gApp.jni.jEnv, FjObject);
end;

function jGdxForm.GetGameStartTimeMilliSeconds(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxForm_GetGameStartTimeMilliSeconds(gApp.jni.jEnv, FjObject);
end;

function jGdxForm.GetGameEndTimeMilliSeconds(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxForm_GetGameEndTimeMilliSeconds(gApp.jni.jEnv, FjObject);
end;

function jGdxForm.GetGameCurrentTimeMilliSeconds(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxForm_GetGameCurrentTimeMilliSeconds(gApp.jni.jEnv, FjObject);
end;

procedure jGdxForm.GenEvent_OnGDXFormShow(Sender:TObject);
begin
  if Assigned(FOnGDXFormShow) then FOnGDXFormShow(Sender);
end;

procedure jGdxForm.GenEvent_OnGDXFormResize(Sender:TObject;width:integer;height:integer);
begin
  if Assigned(FOnGDXFormResize) then FOnGDXFormResize(Sender,width,height);
end;

procedure jGdxForm.GenEvent_OnGDXFormRender(Sender:TObject;deltaTime:single);
begin
  if Assigned(FOnGDXFormRender) then FOnGDXFormRender(Sender,deltaTime);
end;

procedure jGdxForm.GenEvent_OnGDXFormClose(Sender:TObject);
begin
  Self.Close();
end;

procedure jGdxForm.GenEvent_OnGDXFormKeyPressed(Sender:TObject;keyCode:integer{;var outReturn:integer});
var
  //outAction: TGdxKeyPressedAction;
  key: TGdxKeyCode;
begin

  key:= kcUnknown;
  case keyCode of
    4: key:= kcBackKey;
  end;

  //outAction:= kaNone;
  if Assigned(FOnGDXFormKeyPressed) then FOnGDXFormKeyPressed(Sender,key{,outAction});
  //outReturn:= Ord(outAction);
end;

procedure jGdxForm.GenEvent_OnGDXFormTouchDown(Sender:TObject;screenX:integer;screenY:integer;pointer:integer;button:integer);
begin
  if Assigned(FOnGDXFormTouchDown) then FOnGDXFormTouchDown(Sender,screenX,screenY,pointer,button);
end;

procedure jGdxForm.GenEvent_OnGDXFormTouchUp(Sender:TObject;screenX:integer;screenY:integer;pointer:integer;button:integer);
begin
  if Assigned(FOnGDXFormTouchUp) then FOnGDXFormTouchUp(Sender,screenX,screenY,pointer,button);
end;

procedure jGdxForm.GenEvent_OnGDXFormResume(Sender:TObject);
begin
  if Assigned(FOnGDXFormResume) then FOnGDXFormResume(Sender);
end;

procedure jGdxForm.GenEvent_OnGDXFormPause(Sender:TObject);
begin
  if Assigned(FOnGDXFormPause) then FOnGDXFormPause(Sender);
end;

procedure jGdxForm.GenEvent_OnGDXFormHide(Sender:TObject);
begin
  if Assigned(FOnGDXFormHide) then FOnGDXFormHide(Sender);
end;

{-------- jGdxForm_JNI_Bridge ----------}

function jGdxForm_jCreate(env: PJNIEnv;_Self: int64; _active: boolean; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_active);
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxForm_jCreate', '(JZ)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxForm_jFree(env: PJNIEnv; _jgdxform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  if _jgdxform <> nil then
  begin
    jCls:= env^.GetObjectClass(env, _jgdxform);
    jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
    env^.CallVoidMethod(env, _jgdxform, jMethod);
    env^.DeleteLocalRef(env, jCls);
    //env^.DeleteGlobalRef(env,_jgdxform);
  end;
end;

procedure jGdxForm_Show(env: PJNIEnv; _jgdxform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxForm_GetWidth(env: PJNIEnv; _jgdxform: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetWidth', '()I');
  Result:= env^.CallIntMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxForm_GetHeight(env: PJNIEnv; _jgdxform: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetHeight', '()I');
  Result:= env^.CallIntMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxForm_ClearColor(env: PJNIEnv; _jgdxform: JObject; _red: single; _green: single; _blue: single; _alpha: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _red;
  jParams[1].f:= _green;
  jParams[2].f:= _blue;
  jParams[3].f:= _alpha;
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearColor', '(FFFF)V');
  env^.CallVoidMethodA(env, _jgdxform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxForm_GetGamePlayingSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGamePlayingSeconds', '()J');
  Result:= env^.CallLongMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxForm_GetGameRenderCount(env: PJNIEnv; _jgdxform: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGameRenderCount', '()J');
  Result:= env^.CallLongMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxForm_GetGameStartTimeMilliSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGameStartTimeMilliSeconds', '()J');
  Result:= env^.CallLongMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxForm_GetGameEndTimeMilliSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGameEndTimeMilliSeconds', '()J');
  Result:= env^.CallLongMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxForm_GetGameCurrentTimeMilliSeconds(env: PJNIEnv; _jgdxform: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGameCurrentTimeMilliSeconds', '()J');
  Result:= env^.CallLongMethod(env, _jgdxform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
