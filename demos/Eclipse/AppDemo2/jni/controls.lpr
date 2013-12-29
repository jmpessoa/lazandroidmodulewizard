{hint: save all files to location: C:\adt32\eclipse\workspace\AppDemo2\jni }
library controls;
 
{$mode delphi}
 
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, unit1;
 
const
  curClassPathName: string='';
  curClass: JClass=nil;
  curVM: PJavaVM=nil;
  curEnv: PJNIEnv=nil;
 
{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject; layout: JObject); cdecl;
begin
  App.Init(PEnv,this,context,layout);AndroidModule1.Init(App);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnNewIntent
  Signature: ()V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnActive
  Signature: ()V }
procedure pAppOnActive(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnActive(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv,this,rotate);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt; resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv,this,requestCode,resultCode,data);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnClick
  Signature: (II)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JInt; value: JInt); cdecl;
begin
  Java_Event_pOnClick(PEnv,this,TObject(pasobj),value);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnChange
  Signature: (II)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JInt; EventType: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv,this,TObject(pasobj),EventType);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnEnter
  Signature: (I)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JInt); cdecl;
begin
  Java_Event_pOnEnter(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnTimer
  Signature: (I)V }
procedure pOnTimer(PEnv: PJNIEnv; this: JObject; pasobj: JInt); cdecl;
begin
  Java_Event_pOnTimer(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnDraw
  Signature: (ILandroid/graphics/Canvas;)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JInt; canvas: JObject); cdecl;
begin
  Java_Event_pOnDraw(PEnv,this,TObject(pasobj),canvas);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnTouch
  Signature: (IIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JInt; act: JInt; cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv,this,TObject(pasobj),act,cnt,x1,y1,x2,y2);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnGLRenderer
  Signature: (IIII)V }
procedure pOnGLRenderer(PEnv: PJNIEnv; this: JObject; pasobj: JInt; EventType: JInt; w: JInt; h: JInt); cdecl;
begin
  Java_Event_pOnGLRenderer(PEnv,this,TObject(pasobj),EventType,w,h);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnClose
  Signature: (I)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; actform: JInt); cdecl;
begin
  Java_Event_pOnClose(PEnv,this);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnWebViewStatus
  Signature: (IILjava/lang/String;)I }
function pOnWebViewStatus(PEnv: PJNIEnv; this: JObject; pasobj: JInt; EventType: JInt; url: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnWebViewStatus(PEnv,this,TObject(pasobj),EventType,url);
end;

{ Class:     com_example_appdemo2_Controls
  Method:    pOnAsyncEvent
  Signature: (III)V }
procedure pOnAsyncEvent(PEnv: PJNIEnv; this: JObject; pasobj: JInt; EventType: JInt; progress: JInt); cdecl;
begin
  Java_Event_pOnAsyncEvent(PEnv,this,TObject(pasobj),EventType,progress);
end;

const NativeMethods:array[0..22] of JNINativeMethod = (
   (name:'pAppOnScreenStyle';
    signature:'()I';
    fnPtr:@pAppOnScreenStyle;),
   (name:'pAppOnCreate';
    signature:'(Landroid/content/Context;Landroid/widget/RelativeLayout;)V';
    fnPtr:@pAppOnCreate;),
   (name:'pAppOnNewIntent';
    signature:'()V';
    fnPtr:@pAppOnNewIntent;),
   (name:'pAppOnDestroy';
    signature:'()V';
    fnPtr:@pAppOnDestroy;),
   (name:'pAppOnPause';
    signature:'()V';
    fnPtr:@pAppOnPause;),
   (name:'pAppOnRestart';
    signature:'()V';
    fnPtr:@pAppOnRestart;),
   (name:'pAppOnResume';
    signature:'()V';
    fnPtr:@pAppOnResume;),
   (name:'pAppOnActive';
    signature:'()V';
    fnPtr:@pAppOnActive;),
   (name:'pAppOnStop';
    signature:'()V';
    fnPtr:@pAppOnStop;),
   (name:'pAppOnBackPressed';
    signature:'()V';
    fnPtr:@pAppOnBackPressed;),
   (name:'pAppOnRotate';
    signature:'(I)I';
    fnPtr:@pAppOnRotate;),
   (name:'pAppOnConfigurationChanged';
    signature:'()V';
    fnPtr:@pAppOnConfigurationChanged;),
   (name:'pAppOnActivityResult';
    signature:'(IILandroid/content/Intent;)V';
    fnPtr:@pAppOnActivityResult;),
   (name:'pOnClick';
    signature:'(II)V';
    fnPtr:@pOnClick;),
   (name:'pOnChange';
    signature:'(II)V';
    fnPtr:@pOnChange;),
   (name:'pOnEnter';
    signature:'(I)V';
    fnPtr:@pOnEnter;),
   (name:'pOnTimer';
    signature:'(I)V';
    fnPtr:@pOnTimer;),
   (name:'pOnDraw';
    signature:'(ILandroid/graphics/Canvas;)V';
    fnPtr:@pOnDraw;),
   (name:'pOnTouch';
    signature:'(IIIFFFF)V';
    fnPtr:@pOnTouch;),
   (name:'pOnGLRenderer';
    signature:'(IIII)V';
    fnPtr:@pOnGLRenderer;),
   (name:'pOnClose';
    signature:'(I)V';
    fnPtr:@pOnClose;),
   (name:'pOnWebViewStatus';
    signature:'(IILjava/lang/String;)I';
    fnPtr:@pOnWebViewStatus;),
   (name:'pOnAsyncEvent';
    signature:'(III)V';
    fnPtr:@pOnAsyncEvent;)
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
  curClassPathName:= 'com/example/appdemo2/Controls';
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
  gVM:= VM {And_jni_Bridge};
  curEnv:= PJNIEnv(PEnv);
end;
 
procedure JNI_OnUnload(VM: PJavaVM; reserved: pointer); cdecl;
begin
  if curEnv <> nil then (curEnv^).UnregisterNatives(curEnv, curClass);
  curClass:= nil;
  curEnv:= nil;
  curVM:= nil;
  gVM:= nil;
  App.Terminate;
  FreeAndNil(App);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  pAppOnScreenStyle name 'Java_com_example_appdemo2_Controls_pAppOnScreenStyle',
  pAppOnCreate name 'Java_com_example_appdemo2_Controls_pAppOnCreate',
  pAppOnNewIntent name 'Java_com_example_appdemo2_Controls_pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_example_appdemo2_Controls_pAppOnDestroy',
  pAppOnPause name 'Java_com_example_appdemo2_Controls_pAppOnPause',
  pAppOnRestart name 'Java_com_example_appdemo2_Controls_pAppOnRestart',
  pAppOnResume name 'Java_com_example_appdemo2_Controls_pAppOnResume',
  pAppOnActive name 'Java_com_example_appdemo2_Controls_pAppOnActive',
  pAppOnStop name 'Java_com_example_appdemo2_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_com_example_appdemo2_Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_com_example_appdemo2_Controls_pAppOnRotate',
  pAppOnConfigurationChanged name 'Java_com_example_appdemo2_Controls_pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_example_appdemo2_Controls_pAppOnActivityResult',
  pOnClick name 'Java_com_example_appdemo2_Controls_pOnClick',
  pOnChange name 'Java_com_example_appdemo2_Controls_pOnChange',
  pOnEnter name 'Java_com_example_appdemo2_Controls_pOnEnter',
  pOnTimer name 'Java_com_example_appdemo2_Controls_pOnTimer',
  pOnDraw name 'Java_com_example_appdemo2_Controls_pOnDraw',
  pOnTouch name 'Java_com_example_appdemo2_Controls_pOnTouch',
  pOnGLRenderer name 'Java_com_example_appdemo2_Controls_pOnGLRenderer',
  pOnClose name 'Java_com_example_appdemo2_Controls_pOnClose',
  pOnWebViewStatus name 'Java_com_example_appdemo2_Controls_pOnWebViewStatus',
  pOnAsyncEvent name 'Java_com_example_appdemo2_Controls_pOnAsyncEvent';
 
begin
  App:= jApp.Create(nil);{Laz_And_Controls}
  App.Title:= 'My Android GUI Library';
  gjAppName:= 'com.example.appdemo2';{And_jni_Bridge}
  gjClassName:= 'com/example/appdemo2/Controls';{And_jni_Bridge}
  App.AppName:=gjAppName;
  App.ClassName:=gjClassName;
  App.Initialize;
  App.CreateForm(TAndroidModule1, AndroidModule1);
end.
