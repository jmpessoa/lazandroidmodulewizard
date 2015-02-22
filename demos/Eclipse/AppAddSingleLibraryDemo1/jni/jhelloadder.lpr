{hint: save all files to location: C:\adt32\eclipse\workspace\AppAddSingleLibraryDemo1\jni }
library jhelloadder;  //[by LazAndroidWizard: 2/22/2015 4:52:05]

{$mode delphi}

uses
  Classes, SysUtils, CustApp, jni, unithelloadder;

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

{ Class:     com_example_appaddsinglelibrarydemo1_jHelloAdder
  Method:    Add
  Signature: (II)I }
function Add(PEnv: PJNIEnv; this: JObject; _a: JInt; _b: JInt): JInt; cdecl;
begin
  {your code....}
  Result:= _a + _b;
end;

{ Class:     com_example_appaddsinglelibrarydemo1_jHelloAdder
  Method:    StringUpperCase
  Signature: (Ljava/lang/String;)Ljava/lang/String; }
function StringUpperCase(PEnv: PJNIEnv; this: JObject; _str: JString): JString; cdecl;
var
  _jboolean: jBoolean;
  pascalStr: string;
begin
  {your code....}
   //function Get_pString(jStr: jObject): string;
  case _str = nil of
    True : pascalStr:= '';
    False: begin
          _jboolean := JNI_False;
           pascalStr:= string(  PEnv^.GetStringUTFChars(PEnv,_str,_jboolean));
         end;
  end;
  Result:= PEnv^.NewStringUTF(PEnv, PChar(Uppercase(pascalStr)));  ;
end;

const NativeMethods:array[0..1] of JNINativeMethod = (
   (name:'Add';
    signature:'(II)I';
    fnPtr:@Add;),
   (name:'StringUpperCase';
    signature:'(Ljava/lang/String;)Ljava/lang/String;';
    fnPtr:@StringUpperCase;)
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
     RegisterNativeMethods(curEnv, 'com/example/appaddsinglelibrarydemo1/jHelloAdder');
     gNoGUIPDalvikVM:= VM;{PJavaVM}
     gNoGUIjClassPath:= 'com/example/appaddsinglelibrarydemo1/jHelloAdder';
     gNoGUIjClass:= (curEnv^).FindClass(curEnv, 'com/example/appaddsinglelibrarydemo1/jHelloAdder');
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
  Add name 'Java_com_example_appaddsinglelibrarydemo1_jHelloAdder_Add',
  StringUpperCase name 'Java_com_example_appaddsinglelibrarydemo1_jHelloAdder_StringUpperCase';

begin
  gNoGUIApp:= TNoGUIApp.Create(nil);
  gNoGUIApp.Title:= 'My Android Pure Library';
  gNoGUIjAppName:= 'com.example.appaddsinglelibrarydemo1';
  gNoGUIAppjClassName:= 'com/example/appaddsinglelibrarydemo1/jHelloAdder';
  gNoGUIApp.jAppName:=gNoGUIjAppName;
  gNoGUIApp.jClassName:=gNoGUIAppjClassName;
  gNoGUIApp.Initialize;
  gNoGUIApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);
end.
