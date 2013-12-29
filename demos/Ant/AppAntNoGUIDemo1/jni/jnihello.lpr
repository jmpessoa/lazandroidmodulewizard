{hint: save all files to location: C:\adt32\ant\workspace\AppAntNoGUIDemo1\jni }
library jnihello;
 
{$mode delphi}
 
uses
  Classes, SysUtils, CustApp, jni, unit1;
 
const
  curClassPathName: string='';
  curClass: JClass=nil;
  curVM: PJavaVM=nil;
  curEnv: PJNIEnv=nil;
 
type
 
  TApp = class(TCustomApplication)
   public
     procedure CreateForm(InstanceClass: TComponentClass; out Reference);
     constructor Create(TheOwner: TComponent); override;
     destructor Destroy; override;
  end;
 
procedure TApp.CreateForm(InstanceClass: TComponentClass; out Reference);
var
  Instance: TComponent;
begin
  Instance := TComponent(InstanceClass.NewInstance);
  TComponent(Reference):= Instance;
  Instance.Create(Self);
end;
 
constructor TApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;
 
destructor TApp.Destroy;
begin
  inherited Destroy;
end;
 
var
  App: TApp;
 
{ Class:     org_jmpessoa_appantnoguidemo1_JNIHello
  Method:    getString
  Signature: (I)Ljava/lang/String; }
function getString(PEnv: PJNIEnv; this: JObject; flag: JInt): JString; cdecl;
begin
  if flag = 1  then
    Result:= (PEnv^).NewStringUTF(PEnv, '1.New message from Pascal')
  else
    Result:= (PEnv^).NewStringUTF(PEnv, '2.New message from Pascal');
end;

{ Class:     org_jmpessoa_appantnoguidemo1_JNIHello
  Method:    getSum
  Signature: (II)I }
function getSum(PEnv: PJNIEnv; this: JObject; x: JInt; y: JInt): JInt; cdecl;
begin
  Result:= x + y;
end;

const NativeMethods:array[0..1] of JNINativeMethod = (
   (name:'getString';
    signature:'(I)Ljava/lang/String;';
    fnPtr:@getString;),
   (name:'getSum';
    signature:'(II)I';
    fnPtr:@getSum;)
);

function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar; methods: PJNINativeMethod; countMethods:integer):integer;
begin
  Result:= JNI_FALSE;
  curClass:= (PEnv^).FindClass(PEnv, className);
  if curClass <> nil then
  begin
    if (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods) > 0 then Result:= JNI_TRUE;
  end;
end;
 
function RegisterNativeMethods(PEnv: PJNIEnv): integer;
begin
  curClassPathName:= 'org/jmpessoa/appantnoguidemo1/JNIHello';
  Result:= RegisterNativeMethodsArray(PEnv, PChar(curClassPathName), @NativeMethods[0], Length(NativeMethods));
end;
 
function JNI_OnLoad(VM: PJavaVM; reserved: pointer): JInt; cdecl;
var
  PEnv: PPointer {PJNIEnv};
begin
  PEnv:= nil;
  Result:= JNI_VERSION_1_6;
  (VM^).GetEnv(VM, @PEnv, Result);
  if PEnv <> nil then RegisterNativeMethods(PJNIEnv(PEnv));
  curVM:= VM {PJavaVM};
  curEnv:= PJNIEnv(PEnv);
end;
 
procedure JNI_OnUnload(VM: PJavaVM; reserved: pointer); cdecl;
begin
  if curEnv <> nil then (curEnv^).UnregisterNatives(curEnv, curClass);
  curClass:= nil;
  curEnv:= nil;
  curVM:= nil;
  App.Terminate;
  FreeAndNil(App);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  getString name 'Java_org_jmpessoa_appantnoguidemo1_JNIHello_getString',
  getSum name 'Java_org_jmpessoa_appantnoguidemo1_JNIHello_getSum';
 
begin
  App:= TApp.Create(nil);
  App.Title:= 'My Android NoGUI Library';
  App.Initialize;
  App.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);
end.
