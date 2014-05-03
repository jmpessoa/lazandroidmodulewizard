{hint: save all files to location: C:\adt32\eclipse\workspace\AppTryCode3\jni }
library controls;
 
{$mode delphi}
 
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, unit1;
 
{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject; layout: JObject); cdecl;
begin
  gApp.Init(PEnv,this,context,layout);AndroidModule1.Init(gApp);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnNewIntent
  Signature: ()V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv,this,rotate);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv,this);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt; resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv,this,requestCode,resultCode,data);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt); cdecl;
begin
  Java_Event_pOnClick(PEnv,this,TObject(pasobj),value);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnChange
  Signature: (JI)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv,this,TObject(pasobj),EventType);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnTimer
  Signature: (J)V }
procedure pOnTimer(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnTimer(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnDraw
  Signature: (JLandroid/graphics/Canvas;)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong; canvas: JObject); cdecl;
begin
  Java_Event_pOnDraw(PEnv,this,TObject(pasobj),canvas);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt; cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv,this,TObject(pasobj),act,cnt,x1,y1,x2,y2);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnGLRenderer
  Signature: (JIII)V }
procedure pOnGLRenderer(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt; w: JInt; h: JInt); cdecl;
begin
  Java_Event_pOnGLRenderer(PEnv,this,TObject(pasobj),EventType,w,h);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnActive
  Signature: (J)V }
procedure pOnActive(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnActive(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnWebViewStatus
  Signature: (JILjava/lang/String;)I }
function pOnWebViewStatus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt; url: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnWebViewStatus(PEnv,this,TObject(pasobj),EventType,url);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnAsyncEvent
  Signature: (JII)V }
procedure pOnAsyncEvent(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt; progress: JInt); cdecl;
begin
  Java_Event_pOnAsyncEvent(PEnv,this,TObject(pasobj),EventType,progress);
end;

{ Class:     com_example_apptrycode3_Controls
  Method:    pOnClickWidgetItem
  Signature: (JIZ)V }
procedure pOnClickWidgetItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; position: JInt; checked: JBoolean); cdecl;
begin
  Java_Event_pOnClickWidgetItem(PEnv,this,TObject(pasobj),position,Boolean(checked));
end;

const NativeMethods:array[0..24] of JNINativeMethod = (
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
   (name:'pAppOnStart';
    signature:'()V';
    fnPtr:@pAppOnStart;),
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
    signature:'(JI)V';
    fnPtr:@pOnClick;),
   (name:'pOnChange';
    signature:'(JI)V';
    fnPtr:@pOnChange;),
   (name:'pOnEnter';
    signature:'(J)V';
    fnPtr:@pOnEnter;),
   (name:'pOnTimer';
    signature:'(J)V';
    fnPtr:@pOnTimer;),
   (name:'pOnDraw';
    signature:'(JLandroid/graphics/Canvas;)V';
    fnPtr:@pOnDraw;),
   (name:'pOnTouch';
    signature:'(JIIFFFF)V';
    fnPtr:@pOnTouch;),
   (name:'pOnGLRenderer';
    signature:'(JIII)V';
    fnPtr:@pOnGLRenderer;),
   (name:'pOnClose';
    signature:'(J)V';
    fnPtr:@pOnClose;),
   (name:'pOnActive';
    signature:'(J)V';
    fnPtr:@pOnActive;),
   (name:'pOnWebViewStatus';
    signature:'(JILjava/lang/String;)I';
    fnPtr:@pOnWebViewStatus;),
   (name:'pOnAsyncEvent';
    signature:'(JII)V';
    fnPtr:@pOnAsyncEvent;),
   (name:'pOnClickWidgetItem';
    signature:'(JIZ)V';
    fnPtr:@pOnClickWidgetItem;)
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
     RegisterNativeMethods(curEnv, 'com/example/apptrycode3/Controls');
  end;
  gVM:= VM;{And_jni_Bridge}
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
    (curEnv^).DeleteGlobalRef(curEnv, gjClass{And_jni_Bridge});
    gVM:= nil;{And_jni_Bridge}
  end;
  gApp.Terminate;
  FreeAndNil(gApp);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  pAppOnScreenStyle name 'Java_com_example_apptrycode3_Controls_pAppOnScreenStyle',
  pAppOnCreate name 'Java_com_example_apptrycode3_Controls_pAppOnCreate',
  pAppOnNewIntent name 'Java_com_example_apptrycode3_Controls_pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_example_apptrycode3_Controls_pAppOnDestroy',
  pAppOnPause name 'Java_com_example_apptrycode3_Controls_pAppOnPause',
  pAppOnRestart name 'Java_com_example_apptrycode3_Controls_pAppOnRestart',
  pAppOnResume name 'Java_com_example_apptrycode3_Controls_pAppOnResume',
  pAppOnStart name 'Java_com_example_apptrycode3_Controls_pAppOnStart',
  pAppOnStop name 'Java_com_example_apptrycode3_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_com_example_apptrycode3_Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_com_example_apptrycode3_Controls_pAppOnRotate',
  pAppOnConfigurationChanged name 'Java_com_example_apptrycode3_Controls_pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_example_apptrycode3_Controls_pAppOnActivityResult',
  pOnClick name 'Java_com_example_apptrycode3_Controls_pOnClick',
  pOnChange name 'Java_com_example_apptrycode3_Controls_pOnChange',
  pOnEnter name 'Java_com_example_apptrycode3_Controls_pOnEnter',
  pOnTimer name 'Java_com_example_apptrycode3_Controls_pOnTimer',
  pOnDraw name 'Java_com_example_apptrycode3_Controls_pOnDraw',
  pOnTouch name 'Java_com_example_apptrycode3_Controls_pOnTouch',
  pOnGLRenderer name 'Java_com_example_apptrycode3_Controls_pOnGLRenderer',
  pOnClose name 'Java_com_example_apptrycode3_Controls_pOnClose',
  pOnActive name 'Java_com_example_apptrycode3_Controls_pOnActive',
  pOnWebViewStatus name 'Java_com_example_apptrycode3_Controls_pOnWebViewStatus',
  pOnAsyncEvent name 'Java_com_example_apptrycode3_Controls_pOnAsyncEvent',
  pOnClickWidgetItem name 'Java_com_example_apptrycode3_Controls_pOnClickWidgetItem';
 
begin
  gApp:= jApp.Create(nil);{Laz_And_Controls}
  gApp.Title:= 'My Android Bridges Library';
  gjAppName:= 'com.example.apptrycode3';{And_jni_Bridge}
  gjClassName:= 'com/example/apptrycode3/Controls';{And_jni_Bridge}
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TAndroidModule1, AndroidModule1);
end.
