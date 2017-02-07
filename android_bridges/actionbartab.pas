unit actionbartab;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/2/2014 22:24:11]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jActionBarTab = class(jControl)
 private
    FTitles: TStrings;
    FIconIdentifiers: TStrings;

    FOnActionBarTabSelected: TActionBarTabSelected;
    FOnActionBarTabUnSelected: TActionBarTabSelected;

    procedure SetTitles(Value: TStrings);
    procedure SetIconIdentifiers(Value: TStrings);
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function GetActionBar(): jObject;

    procedure Add(_title: string; _panel: jObject; _iconIdentifier: string);  overload;
    procedure Add(_title: string; _panel: jObject);    overload;
    procedure Add(_title: string; _panel: jObject; _customTabView: jObject);  overload;
    procedure SetTabNavigationMode();
    procedure RemoveAllTabs();

    function GetSelectedTab(): jObject;
    procedure SelectTab(tab: jObject);
    function GetTabAtIndex(_index: integer): jObject;
    procedure SelectTabByIndex(_index: integer);

    procedure GenEvent_OnActionBarTabSelected(Obj: TObject; view: jObject; title: string);
    procedure GenEvent_OnActionBarTabUnSelected(Obj: TObject; view: jObject; title: string);

 published
    property Titles: TStrings read FTitles write SetTitles;
    property IconIdentifiers: TStrings read FIconIdentifiers write SetIconIdentifiers;
    property OnTabSelected: TActionBarTabSelected read FOnActionBarTabSelected write FOnActionBarTabSelected;
    property OnUnSelected: TActionBarTabSelected read FOnActionBarTabUnSelected write FOnActionBarTabUnSelected;

end;

function jActionBarTab_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jActionBarTab_jFree(env: PJNIEnv; _jActionBarTab: JObject);
function jActionBarTab_GetActionBar(env: PJNIEnv; _jActionBarTab: JObject): jObject;

procedure jActionBarTab_Add(env: PJNIEnv; _jActionBarTab: JObject; _title: string; _panel: jObject; _iconIdentifier: string);  overload;
procedure jActionBarTab_Add(env: PJNIEnv; _jActionBarTab: JObject; _title: string; _panel: jObject);    overload;
procedure jActionBarTab_Add(env: PJNIEnv; _jActionBarTab: JObject; _title: string; _panel: jObject; _customTabView: jObject);  overload;
procedure jActionBarTab_SetTabNavigationMode(env: PJNIEnv; _jActionBarTab: JObject);
procedure jActionBarTab_RemoveAllTabs(env: PJNIEnv; _jActionBarTab: JObject);

function jActionBarTab_GetSelectedTab(env: PJNIEnv; _jactionbartab: JObject): jObject;
procedure jActionBarTab_SelectTab(env: PJNIEnv; _jactionbartab: JObject; tab: jObject);
function jActionBarTab_GetTabAtIndex(env: PJNIEnv; _jactionbartab: JObject; _index: integer): jObject;
procedure jActionBarTab_SelectTabByIndex(env: PJNIEnv; _jactionbartab: JObject; _index: integer);



implementation

{---------  jActionBarTab  --------------}

constructor jActionBarTab.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FTitles:= TStringList.Create;
  FIconIdentifiers:= TStringList.Create;
end;

destructor jActionBarTab.Destroy;
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
  FTitles.Free;
  FIconIdentifiers.Free;
  inherited Destroy;
end;

procedure jActionBarTab.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;

function jActionBarTab.jCreate(): jObject;
begin
   Result:= jActionBarTab_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jActionBarTab.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_jFree(FjEnv, FjObject);
end;

function jActionBarTab.GetActionBar(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jActionBarTab_GetActionBar(FjEnv, FjObject);
end;

procedure jActionBarTab.Add(_title: string; _panel: jObject; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_Add(FjEnv, FjObject, _title ,_panel ,_iconIdentifier);
end;

procedure jActionBarTab.Add(_title: string; _panel: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_Add(FjEnv, FjObject, _title ,_panel);
end;

procedure jActionBarTab.Add(_title: string; _panel: jObject; _customTabView: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_Add(FjEnv, FjObject, _title ,_panel ,_customTabView);
end;

procedure jActionBarTab.SetTabNavigationMode();
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_SetTabNavigationMode(FjEnv, FjObject);
end;

procedure jActionBarTab.RemoveAllTabs();
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_RemoveAllTabs(FjEnv, FjObject);
end;

procedure jActionBarTab.SetTitles(Value: TStrings);
begin
  FTitles.Assign(Value);
end;

procedure jActionBarTab.SetIconIdentifiers(Value: TStrings);
begin
  FIconIdentifiers.Assign(Value);
end;


function jActionBarTab.GetSelectedTab(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jActionBarTab_GetSelectedTab(FjEnv, FjObject);
end;

procedure jActionBarTab.SelectTab(tab: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_SelectTab(FjEnv, FjObject, tab);
end;

function jActionBarTab.GetTabAtIndex(_index: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jActionBarTab_GetTabAtIndex(FjEnv, FjObject, _index);
end;

procedure jActionBarTab.SelectTabByIndex(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActionBarTab_SelectTabByIndex(FjEnv, FjObject, _index);
end;


procedure jActionBarTab.GenEvent_OnActionBarTabSelected(Obj: TObject; view: jObject; title: string);
begin
   if Assigned(OnTabSelected) then OnTabSelected(Obj, view, title);
end;

procedure jActionBarTab.GenEvent_OnActionBarTabUnSelected(Obj: TObject; view: jObject; title: string);
begin
   if Assigned(OnUnSelected) then OnUnSelected(Obj, view, title);
end;


{-------- jActionBarTab_JNI_Bridge ----------}

function jActionBarTab_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jActionBarTab_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jActionBarTab_jCreate(long _Self) {
      return (java.lang.Object)(new jActionBarTab(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jActionBarTab_jFree(env: PJNIEnv; _jActionBarTab: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jActionBarTab, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jActionBarTab_GetActionBar(env: PJNIEnv; _jActionBarTab: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionBar', '()Landroid/app/ActionBar;');
  Result:= env^.CallObjectMethod(env, _jActionBarTab, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActionBarTab_Add(env: PJNIEnv; _jActionBarTab: JObject; _title: string; _panel: jObject; _iconIdentifier: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= _panel;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Landroid/view/View;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jActionBarTab, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActionBarTab_Add(env: PJNIEnv; _jActionBarTab: JObject; _title: string; _panel: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= _panel;
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jActionBarTab, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jActionBarTab_Add(env: PJNIEnv; _jActionBarTab: JObject; _title: string; _panel: jObject; _customTabView: jObject);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= _panel;
  jParams[2].l:= _customTabView;
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Ljava/lang/String;Landroid/view/View;Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jActionBarTab, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActionBarTab_SetTabNavigationMode(env: PJNIEnv; _jActionBarTab: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTabNavigationMode', '()V');
  env^.CallVoidMethod(env, _jActionBarTab, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActionBarTab_RemoveAllTabs(env: PJNIEnv; _jActionBarTab: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jActionBarTab);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveAllTabs', '()V');
  env^.CallVoidMethod(env, _jActionBarTab, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jActionBarTab_GetSelectedTab(env: PJNIEnv; _jactionbartab: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jactionbartab);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSelectedTab', '()Landroid/app/ActionBar/Tab;');
  Result:= env^.CallObjectMethod(env, _jactionbartab, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActionBarTab_SelectTab(env: PJNIEnv; _jactionbartab: JObject; tab: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= tab;
  jCls:= env^.GetObjectClass(env, _jactionbartab);
  jMethod:= env^.GetMethodID(env, jCls, 'SelectTab', '(LActionBar/Tab;)V');
  env^.CallVoidMethodA(env, _jactionbartab, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jActionBarTab_GetTabAtIndex(env: PJNIEnv; _jactionbartab: JObject; _index: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jactionbartab);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTabAtIndex', '(I)Landroid/app/ActionBar/Tab;');
  Result:= env^.CallObjectMethodA(env, _jactionbartab, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActionBarTab_SelectTabByIndex(env: PJNIEnv; _jactionbartab: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jactionbartab);
  jMethod:= env^.GetMethodID(env, jCls, 'SelectTabByIndex', '(I)V');
  env^.CallVoidMethodA(env, _jactionbartab, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
