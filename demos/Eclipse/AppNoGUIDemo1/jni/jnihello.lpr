{hint: save all files to location: C:\adt32\eclipse\workspace\AppNoGUIDemo1\jni }
library jnihello;
 
{$mode delphi}
 
uses
  Classes, SysUtils, CustApp, jni, unit1;
 
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
 
  { Class:     com_example_appnoguidemo1_JNIHello
    Method:    getString
    Signature: (I)Ljava/lang/String; }
  function getString(PEnv: PJNIEnv; this: JObject; flag: JInt): JString; cdecl;
  begin

    if flag = 1  then
      Result:= (PEnv^).NewStringUTF(PEnv, '1.New message from JNI Pascal')
    else
      Result:= (PEnv^).NewStringUTF(PEnv, '2.New message from JNI Pascal');

  end;

  { Class:     com_example_appnoguidemo1_JNIHello
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
var
  curClass: jClass;
begin
  Result:= JNI_FALSE;
  curClass:= (PEnv^).FindClass(PEnv, className);
  if curClass <> nil then
  begin
    if (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods) > 0 then Result:= JNI_TRUE;
  end;
end;
 
function RegisterNativeMethods(PEnv: PJNIEnv; className: PChar): integer;
begin
  Result:= RegisterNativeMethodsArray(PEnv, className, @NativeMethods[0], Length(NativeMethods));
end;
 
function JNI_OnLoad(VM: PJavaVM; reserved: pointer): JInt; cdecl;
var
  PEnv: PPointer;
  curEnv: PJNIEnv;
begin
  PEnv:= nil;
  Result:= JNI_VERSION_1_6;
  (VM^).GetEnv(VM, @PEnv, Result);
  if PEnv <> nil then
  begin
     curEnv:= PJNIEnv(PEnv);
     RegisterNativeMethods(curEnv, 'com/example/appnoguidemo1/JNIHello');
     gPDalvikVM:= VM;{PJavaVM}{unit1}
     gjClassPath:= 'com/example/appnoguidemo1/JNIHello';{unit1}
     gjClass:= (curEnv^).FindClass(curEnv, 'com/example/appnoguidemo1/JNIHello');{unit1}
     gjClass:= (curEnv^).NewGlobalRef(curEnv, gjClass);{unit1}
  end;
end;
 
procedure JNI_OnUnload(VM: PJavaVM; reserved: pointer); cdecl;
var
  PEnv: PPointer;
  curEnv: PJNIEnv;
begin
  PEnv:= nil;
  (VM^).GetEnv(VM, @PEnv, JNI_VERSION_1_6);
  if PEnv <> nil then
  begin
    curEnv:= PJNIEnv(PEnv);
    (curEnv^).UnregisterNatives(curEnv, gjClass{unit1});
    (curEnv^).DeleteGlobalRef(curEnv, gjClass{unit1});
    gjClass:= nil;
    gPDalvikVM:= nil;
  end;
  App.Terminate;
  FreeAndNil(App);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  getString name 'Java_com_example_appnoguidemo1_JNIHello_getString',
  getSum name 'Java_com_example_appnoguidemo1_JNIHello_getSum';
 
begin
  App:= TApp.Create(nil);
  App.Title:= 'My Android NoGUI Library';
  App.Initialize;
  App.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);
end.
