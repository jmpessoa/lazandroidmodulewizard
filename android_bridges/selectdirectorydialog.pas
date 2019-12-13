unit selectdirectorydialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TOnDirectorySelected=procedure(Sender:TObject;path:string) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [12/12/2019 20:49:18]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSelectDirectoryDialog = class(jControl)
 private
    FOnDirectorySelected: TOnDirectorySelected;
    FInitialDirectory: TEnvDirectory;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetInitialEnvDirectory(_initialEnvDirectory: TEnvDirectory);
    procedure Show(_initialEnvDirectory: TEnvDirectory); overload;
    procedure Show();  overload;

    procedure GenEvent_OnDirectorySelected(Sender:TObject;path:string);

 published
    property OnDirectorySelected: TOnDirectorySelected read FOnDirectorySelected write FOnDirectorySelected;
    property InitialDirectory: TEnvDirectory read FInitialDirectory write SetInitialEnvDirectory;
end;

function jSelectDirectoryDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSelectDirectoryDialog_jFree(env: PJNIEnv; _jselectdirectorydialog: JObject);
procedure jSelectDirectoryDialog_SetInitialDirectory(env: PJNIEnv; _jselectdirectorydialog: JObject; _initialEnvDirectory: integer);
procedure jSelectDirectoryDialog_Show(env: PJNIEnv; _jselectdirectorydialog: JObject; _initialEnvDirectory: integer);overload;
procedure jSelectDirectoryDialog_Show(env: PJNIEnv; _jselectdirectorydialog: JObject); overload;


implementation

{---------  jSelectDirectoryDialog  --------------}

constructor jSelectDirectoryDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FInitialDirectory:= dirDownloads;
end;

destructor jSelectDirectoryDialog.Destroy;
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

procedure jSelectDirectoryDialog.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  jSelectDirectoryDialog_SetInitialDirectory(FjEnv, FjObject, Ord(FInitialDirectory));

  FInitialized:= True;
end;


function jSelectDirectoryDialog.jCreate(): jObject;
begin
   Result:= jSelectDirectoryDialog_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSelectDirectoryDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSelectDirectoryDialog_jFree(FjEnv, FjObject);
end;

procedure jSelectDirectoryDialog.SetInitialEnvDirectory(_initialEnvDirectory: TEnvDirectory);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSelectDirectoryDialog_SetInitialDirectory(FjEnv, FjObject, Ord(_initialEnvDirectory));
end;

procedure jSelectDirectoryDialog.Show(_initialEnvDirectory: TEnvDirectory);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSelectDirectoryDialog_Show(FjEnv, FjObject, Ord(_initialEnvDirectory) );
end;

procedure jSelectDirectoryDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSelectDirectoryDialog_Show(FjEnv, FjObject);
end;

procedure jSelectDirectoryDialog.GenEvent_OnDirectorySelected(Sender:TObject;path:string);
begin
  if Assigned(FOnDirectorySelected) then FOnDirectorySelected(Sender,path);
end;

{-------- jSelectDirectoryDialog_JNI_Bridge ----------}

function jSelectDirectoryDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSelectDirectoryDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jSelectDirectoryDialog_jFree(env: PJNIEnv; _jselectdirectorydialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jselectdirectorydialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jselectdirectorydialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSelectDirectoryDialog_SetInitialDirectory(env: PJNIEnv; _jselectdirectorydialog: JObject; _initialEnvDirectory: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _initialEnvDirectory;
  jCls:= env^.GetObjectClass(env, _jselectdirectorydialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetInitialDirectory', '(I)V');
  env^.CallVoidMethodA(env, _jselectdirectorydialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSelectDirectoryDialog_Show(env: PJNIEnv; _jselectdirectorydialog: JObject; _initialEnvDirectory: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _initialEnvDirectory;
  jCls:= env^.GetObjectClass(env, _jselectdirectorydialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(I)V');
  env^.CallVoidMethodA(env, _jselectdirectorydialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSelectDirectoryDialog_Show(env: PJNIEnv; _jselectdirectorydialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jselectdirectorydialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jselectdirectorydialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
