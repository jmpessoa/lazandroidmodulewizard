{hint: Pascal files location: ...\AppNoGUIDemo1\jni }
library appnoguidemo1;  //[by LAMW: Lazarus Android Module Wizard: 2/1/2021 2:24:54]
  
{$mode delphi}
  
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, jni, unit1;
  
type
  
  TNoGUIApp = class(TCustomApplication)
  public
      jClassName: string;
      jAppName: string;
      procedure CreateForm(InstanceClass: TComponentClass; out Reference);
      constructor Create(TheOwner: TComponent); override;
      destructor Destroy; override;
  end;
  
procedure TNoGUIApp.CreateForm(InstanceClass: TComponentClass; out Reference);
var
  Instance: TComponent;
begin
  Instance := TComponent(InstanceClass.NewInstance);
  TComponent(Reference):= Instance;
  Instance.Create(Self);
end;
  
constructor TNoGUIApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;
  
destructor TNoGUIApp.Destroy;
begin
  inherited Destroy;
end;
  
var
  gNoGUIApp: TNoGUIApp;
  gNoGUIjAppName: string;
  gNoGUIAppjClassName: string;

{%region /fold 'LAMW generated code'}

{ Class:     org_lamw_appnoguidemo1_AppNoGUIDemo1
  Method:    getString
  Signature: (I)Ljava/lang/String; }
function getString(PEnv: PJNIEnv; this: JObject; flag: JInt): JString; cdecl;
begin
  {your code....}
    if flag = 1  then
      Result:= (PEnv^).NewStringUTF(PEnv, '1.New message from JNI Pascal')
    else
      Result:= (PEnv^).NewStringUTF(PEnv, '2.New message from JNI Pascal');
end;

{ Class:     org_lamw_appnoguidemo1_AppNoGUIDemo1
  Method:    getSum
  Signature: (II)I }
function getSum(PEnv: PJNIEnv; this: JObject; x: JInt; y: JInt): JInt; cdecl;
begin
  {your code....}
  Result:= x + y;
end;

const NativeMethods: array[0..1] of JNINativeMethod = (
    (name: 'getString';
    signature: '(I)Ljava/lang/String;';
    fnPtr: @getString; ),
    (name: 'getSum';
    signature: '(II)I';
    fnPtr: @getSum; )
);

function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar; 
  methods: PJNINativeMethod; countMethods: integer): integer;
var
  curClass: jClass;
begin
  Result:= JNI_FALSE;
  curClass:= (PEnv^).FindClass(PEnv, className);
  if curClass <> nil then
  begin
    if (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods) > 0 
      then Result:= JNI_TRUE;
  end;
end;
  
function RegisterNativeMethods(PEnv: PJNIEnv; className: PChar): integer;
begin
  Result:= RegisterNativeMethodsArray(PEnv, className, @NativeMethods[0], Length
    (NativeMethods));
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
      RegisterNativeMethods(curEnv, 'org/lamw/appnoguidemo1/AppNoGUIDemo1');
      gNoGUIPDalvikVM:= VM; {PJavaVM}
      gNoGUIjClassPath:= 'org/lamw/appnoguidemo1/AppNoGUIDemo1';
      gNoGUIjClass:= (curEnv^).FindClass(curEnv, 'org/lamw/appnoguidemo1/'
        +'AppNoGUIDemo1');
      gNoGUIjClass:= (curEnv^).NewGlobalRef(curEnv, gNoGUIjClass);
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
    (curEnv^).DeleteGlobalRef(curEnv, gNoGUIjClass);
    gNoGUIjClass:= nil;
    gNoGUIPDalvikVM:= nil;
  end;
  gNoGUIApp.Terminate;
  FreeAndNil(gNoGUIApp);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  getString name 'Java_org_lamw_appnoguidemo1_AppNoGUIDemo1_getString',
  getSum name 'Java_org_lamw_appnoguidemo1_AppNoGUIDemo1_getSum';
  

{%endregion}
  
begin
  gNoGUIApp:= TNoGUIApp.Create(nil);
  gNoGUIApp.Title:= 'My Android Pure Library';
  gNoGUIjAppName:= 'org.lamw.appnoguidemo1';
  gNoGUIAppjClassName:= 'org/lamw/appnoguidemo1/AppNoGUIDemo1';
  gNoGUIApp.jAppName:=gNoGUIjAppName;
  gNoGUIApp.jClassName:=gNoGUIAppjClassName;
  gNoGUIApp.Initialize;
  gNoGUIApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);
end.
