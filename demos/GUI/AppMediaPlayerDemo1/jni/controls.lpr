{hint: save all files to location: C:\adt32\eclipse\workspace\AppTest1\jni}
library controls;  //by Lamw: Lazarus Android Module Wizard: 7/9/2015 23:43:07]
 
{$mode delphi}
 
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, unit1;

{%region /fold 'LAMW generated code'}

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;Landroid/content/Intent;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject;
  layout: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnCreate(PEnv, this, context, layout, intent);
    AndroidModule1.Init(gApp);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnNewIntent
  Signature: (Landroid/content/Intent;)V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv, this, intent);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv, this, rotate);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv, this);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt;
  resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv, this, requestCode, resultCode, data);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
  cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv, this, menu);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject;
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
  cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv, this, menuItem, itemID,
    itemCaption, checked);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnPrepareOptionsMenu
  Signature: (Landroid/view/Menu;I)Z }
function pAppOnPrepareOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject;
  menuSize: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenu(PEnv, this, menu, menuSize);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnPrepareOptionsMenuItem
  Signature: (Landroid/view/Menu;Landroid/view/MenuItem;I)Z }
function pAppOnPrepareOptionsMenuItem(PEnv: PJNIEnv; this: JObject;
  menu: JObject; menuItem: JObject; itemIndex: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenuItem(PEnv, this, menu, menuItem,
    itemIndex);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
  cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv, this, menu);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject;
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
  cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv, this, menuItem, itemID,
    itemCaption, checked);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnDraw
  Signature: (J)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDraw(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt;
  cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, x2, y2);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnClickGeneric
  Signature: (JI)V }
procedure pOnClickGeneric(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  value: JInt); cdecl;
begin
  Java_Event_pOnClickGeneric(PEnv, this, TObject(pasobj), value);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnSpecialKeyDown
  Signature: (CILjava/lang/String;)Z }
function pAppOnSpecialKeyDown(PEnv: PJNIEnv; this: JObject; keyChar: JChar;
  keyCode: JInt; keyCodeString: JString): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnSpecialKeyDown(PEnv, this, keyChar, keyCode,
    keyCodeString);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt);
  cdecl;
begin
  Java_Event_pOnClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnLongClick
  Signature: (JI)V }
procedure pOnLongClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt
  ); cdecl;
begin
  Java_Event_pOnLongClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
  count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
  count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt
  ); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv, this, view, id);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject;
  view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv, this, adapter, view, position, id);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv, this, TObject(pasobj), direction);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv, this, TObject(pasobj),
    scaleFactor, state);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnLostFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnLostFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  text: JString); cdecl;
begin
  Java_Event_pOnLostFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnBeforeDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnBeforeDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnBeforeDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnAfterDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnAfterDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnAfterDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnLayouting
  Signature: (JZ)V }
procedure pOnLayouting(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  changed: JBoolean); cdecl;
begin
  Java_Event_pOnLayouting(PEnv, this, TObject(pasobj), changed);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pAppOnRequestPermissionResult
  Signature: (ILjava/lang/String;I)V }
procedure pAppOnRequestPermissionResult(PEnv: PJNIEnv; this: JObject;
  requestCode: JInt; permission: JString; grantResult: JInt); cdecl;
begin
  Java_Event_pAppOnRequestPermissionResult(PEnv, this, requestCode, permission,
    grantResult);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnMediaPlayerPrepared
  Signature: (JII)V }
procedure pOnMediaPlayerPrepared(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  videoWidth: JInt; videoHeigh: JInt); cdecl;
begin
  Java_Event_pOnMediaPlayerPrepared(PEnv, this, TObject(pasobj), videoWidth,
    videoHeigh);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnMediaPlayerVideoSizeChanged
  Signature: (JII)V }
procedure pOnMediaPlayerVideoSizeChanged(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; videoWidth: JInt; videoHeight: JInt); cdecl;
begin
  Java_Event_pOnMediaPlayerVideoSizeChanged(PEnv, this, TObject(pasobj),
    videoWidth, videoHeight);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnMediaPlayerCompletion
  Signature: (J)V }
procedure pOnMediaPlayerCompletion(PEnv: PJNIEnv; this: JObject; pasobj: JLong
  ); cdecl;
begin
  Java_Event_pOnMediaPlayerCompletion(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnMediaPlayerTimedText
  Signature: (JLjava/lang/String;)V }
procedure pOnMediaPlayerTimedText(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  timedText: JString); cdecl;
begin
  Java_Event_pOnMediaPlayerTimedText(PEnv, this, TObject(pasobj), timedText);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnSurfaceViewCreated
  Signature: (JLandroid/view/SurfaceHolder;)V }
procedure pOnSurfaceViewCreated(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  surfaceHolder: JObject); cdecl;
begin
  Java_Event_pOnSurfaceViewCreated(PEnv, this, TObject(pasobj), surfaceHolder);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnSurfaceViewDraw
  Signature: (JLandroid/graphics/Canvas;)V }
procedure pOnSurfaceViewDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject); cdecl;
begin
  Java_Event_pOnSurfaceViewDraw(PEnv, this, TObject(pasobj), canvas);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnSurfaceViewChanged
  Signature: (JII)V }
procedure pOnSurfaceViewChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  width: JInt; height: JInt); cdecl;
begin
  Java_Event_pOnSurfaceViewChanged(PEnv, this, TObject(pasobj), width, height);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnSurfaceViewTouch
  Signature: (JIIFFFF)V }
procedure pOnSurfaceViewTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  act: JInt; cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnSurfaceViewTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1,
    x2, y2);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnSurfaceViewDrawingInBackground
  Signature: (JF)Z }
function pOnSurfaceViewDrawingInBackground(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; progress: JFloat): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnSurfaceViewDrawingInBackground(PEnv, this, TObject(
    pasobj), progress);
end;

{ Class:     com_example_appmediaplayerdemo1_Controls
  Method:    pOnSurfaceViewDrawingPostExecute
  Signature: (JF)V }
procedure pOnSurfaceViewDrawingPostExecute(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; progress: JFloat); cdecl;
begin
  Java_Event_pOnSurfaceViewDrawingPostExecute(PEnv, this, TObject(pasobj),
    progress);
end;

const NativeMethods: array[0..47] of JNINativeMethod = (
   (name: 'pAppOnCreate';
    signature: '(Landroid/content/Context;Landroid/widget/RelativeLayout;'
      +'Landroid/content/Intent;)V';
    fnPtr: @pAppOnCreate; ),
   (name: 'pAppOnScreenStyle';
    signature: '()I';
    fnPtr: @pAppOnScreenStyle; ),
   (name: 'pAppOnNewIntent';
    signature: '(Landroid/content/Intent;)V';
    fnPtr: @pAppOnNewIntent; ),
   (name: 'pAppOnDestroy';
    signature: '()V';
    fnPtr: @pAppOnDestroy; ),
   (name: 'pAppOnPause';
    signature: '()V';
    fnPtr: @pAppOnPause; ),
   (name: 'pAppOnRestart';
    signature: '()V';
    fnPtr: @pAppOnRestart; ),
   (name: 'pAppOnResume';
    signature: '()V';
    fnPtr: @pAppOnResume; ),
   (name: 'pAppOnStart';
    signature: '()V';
    fnPtr: @pAppOnStart; ),
   (name: 'pAppOnStop';
    signature: '()V';
    fnPtr: @pAppOnStop; ),
   (name: 'pAppOnBackPressed';
    signature: '()V';
    fnPtr: @pAppOnBackPressed; ),
   (name: 'pAppOnRotate';
    signature: '(I)I';
    fnPtr: @pAppOnRotate; ),
   (name: 'pAppOnConfigurationChanged';
    signature: '()V';
    fnPtr: @pAppOnConfigurationChanged; ),
   (name: 'pAppOnActivityResult';
    signature: '(IILandroid/content/Intent;)V';
    fnPtr: @pAppOnActivityResult; ),
   (name: 'pAppOnCreateOptionsMenu';
    signature: '(Landroid/view/Menu;)V';
    fnPtr: @pAppOnCreateOptionsMenu; ),
   (name: 'pAppOnClickOptionMenuItem';
    signature: '(Landroid/view/MenuItem;ILjava/lang/String;Z)V';
    fnPtr: @pAppOnClickOptionMenuItem; ),
   (name: 'pAppOnPrepareOptionsMenu';
    signature: '(Landroid/view/Menu;I)Z';
    fnPtr: @pAppOnPrepareOptionsMenu; ),
   (name: 'pAppOnPrepareOptionsMenuItem';
    signature: '(Landroid/view/Menu;Landroid/view/MenuItem;I)Z';
    fnPtr: @pAppOnPrepareOptionsMenuItem; ),
   (name: 'pAppOnCreateContextMenu';
    signature: '(Landroid/view/ContextMenu;)V';
    fnPtr: @pAppOnCreateContextMenu; ),
   (name: 'pAppOnClickContextMenuItem';
    signature: '(Landroid/view/MenuItem;ILjava/lang/String;Z)V';
    fnPtr: @pAppOnClickContextMenuItem; ),
   (name: 'pOnDraw';
    signature: '(J)V';
    fnPtr: @pOnDraw; ),
   (name: 'pOnTouch';
    signature: '(JIIFFFF)V';
    fnPtr: @pOnTouch; ),
   (name: 'pOnClickGeneric';
    signature: '(JI)V';
    fnPtr: @pOnClickGeneric; ),
   (name: 'pAppOnSpecialKeyDown';
    signature: '(CILjava/lang/String;)Z';
    fnPtr: @pAppOnSpecialKeyDown; ),
   (name: 'pOnClick';
    signature: '(JI)V';
    fnPtr: @pOnClick; ),
   (name: 'pOnLongClick';
    signature: '(JI)V';
    fnPtr: @pOnLongClick; ),
   (name: 'pOnChange';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChange; ),
   (name: 'pOnChanged';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChanged; ),
   (name: 'pOnEnter';
    signature: '(J)V';
    fnPtr: @pOnEnter; ),
   (name: 'pOnClose';
    signature: '(J)V';
    fnPtr: @pOnClose; ),
   (name: 'pAppOnViewClick';
    signature: '(Landroid/view/View;I)V';
    fnPtr: @pAppOnViewClick; ),
   (name: 'pAppOnListItemClick';
    signature: '(Landroid/widget/AdapterView;Landroid/view/View;II)V';
    fnPtr: @pAppOnListItemClick; ),
   (name: 'pOnFlingGestureDetected';
    signature: '(JI)V';
    fnPtr: @pOnFlingGestureDetected; ),
   (name: 'pOnPinchZoomGestureDetected';
    signature: '(JFI)V';
    fnPtr: @pOnPinchZoomGestureDetected; ),
   (name: 'pOnLostFocus';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnLostFocus; ),
   (name: 'pOnBeforeDispatchDraw';
    signature: '(JLandroid/graphics/Canvas;I)V';
    fnPtr: @pOnBeforeDispatchDraw; ),
   (name: 'pOnAfterDispatchDraw';
    signature: '(JLandroid/graphics/Canvas;I)V';
    fnPtr: @pOnAfterDispatchDraw; ),
   (name: 'pOnLayouting';
    signature: '(JZ)V';
    fnPtr: @pOnLayouting; ),
   (name: 'pAppOnRequestPermissionResult';
    signature: '(ILjava/lang/String;I)V';
    fnPtr: @pAppOnRequestPermissionResult; ),
   (name: 'pOnMediaPlayerPrepared';
    signature: '(JII)V';
    fnPtr: @pOnMediaPlayerPrepared; ),
   (name: 'pOnMediaPlayerVideoSizeChanged';
    signature: '(JII)V';
    fnPtr: @pOnMediaPlayerVideoSizeChanged; ),
   (name: 'pOnMediaPlayerCompletion';
    signature: '(J)V';
    fnPtr: @pOnMediaPlayerCompletion; ),
   (name: 'pOnMediaPlayerTimedText';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnMediaPlayerTimedText; ),
   (name: 'pOnSurfaceViewCreated';
    signature: '(JLandroid/view/SurfaceHolder;)V';
    fnPtr: @pOnSurfaceViewCreated; ),
   (name: 'pOnSurfaceViewDraw';
    signature: '(JLandroid/graphics/Canvas;)V';
    fnPtr: @pOnSurfaceViewDraw; ),
   (name: 'pOnSurfaceViewChanged';
    signature: '(JII)V';
    fnPtr: @pOnSurfaceViewChanged; ),
   (name: 'pOnSurfaceViewTouch';
    signature: '(JIIFFFF)V';
    fnPtr: @pOnSurfaceViewTouch; ),
   (name: 'pOnSurfaceViewDrawingInBackground';
    signature: '(JF)Z';
    fnPtr: @pOnSurfaceViewDrawingInBackground; ),
   (name: 'pOnSurfaceViewDrawingPostExecute';
    signature: '(JF)V';
    fnPtr: @pOnSurfaceViewDrawingPostExecute; )
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

function JNI_OnLoad(VM: PJavaVM; {%H-}reserved: pointer): JInt; cdecl;
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
     RegisterNativeMethods(curEnv, 'com/example/appmediaplayerdemo1/Controls');
  end;
  gVM:= VM; {AndroidWidget.pas}
end;

procedure JNI_OnUnload(VM: PJavaVM; {%H-}reserved: pointer); cdecl;
var
  PEnv: PPointer;
  curEnv: PJNIEnv;
begin
  PEnv:= nil;
  (VM^).GetEnv(VM, @PEnv, JNI_VERSION_1_6);
  if PEnv <> nil then
  begin
    curEnv:= PJNIEnv(PEnv);
    (curEnv^).DeleteGlobalRef(curEnv, gjClass);
    gjClass:= nil; {AndroidWidget.pas}
    gVM:= nil; {AndroidWidget.pas}
  end;
  gApp.Terminate;
  FreeAndNil(gApp);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  pAppOnCreate name
    'Java_com_example_appmediaplayerdemo1_Controls_pAppOnCreate',
  pAppOnScreenStyle name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnScreenStyle',
  pAppOnNewIntent name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnDestroy',
  pAppOnPause name 'Java_com_example_appmediaplayerdemo1_Controls_pAppOnPause',
  pAppOnRestart name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnRestart',
  pAppOnResume name
    'Java_com_example_appmediaplayerdemo1_Controls_pAppOnResume',
  pAppOnStart name 'Java_com_example_appmediaplayerdemo1_Controls_pAppOnStart',
  pAppOnStop name 'Java_com_example_appmediaplayerdemo1_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnBackPressed',
  pAppOnRotate name
    'Java_com_example_appmediaplayerdemo1_Controls_pAppOnRotate',
  pAppOnConfigurationChanged name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pAppOnClickOptionMenuItem',
  pAppOnPrepareOptionsMenu name 'Java_com_example_appmediaplayerdemo1_Controls'
    +'_pAppOnPrepareOptionsMenu',
  pAppOnPrepareOptionsMenuItem name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pAppOnPrepareOptionsMenuItem',
  pAppOnCreateContextMenu name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pAppOnClickContextMenuItem',
  pOnDraw name 'Java_com_example_appmediaplayerdemo1_Controls_pOnDraw',
  pOnTouch name 'Java_com_example_appmediaplayerdemo1_Controls_pOnTouch',
  pOnClickGeneric name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnClickGeneric',
  pAppOnSpecialKeyDown name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnSpecialKeyDown',
  pOnClick name 'Java_com_example_appmediaplayerdemo1_Controls_pOnClick',
  pOnLongClick name
    'Java_com_example_appmediaplayerdemo1_Controls_pOnLongClick',
  pOnChange name 'Java_com_example_appmediaplayerdemo1_Controls_pOnChange',
  pOnChanged name 'Java_com_example_appmediaplayerdemo1_Controls_pOnChanged',
  pOnEnter name 'Java_com_example_appmediaplayerdemo1_Controls_pOnEnter',
  pOnClose name 'Java_com_example_appmediaplayerdemo1_Controls_pOnClose',
  pAppOnViewClick name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnViewClick',
  pAppOnListItemClick name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pAppOnListItemClick',
  pOnFlingGestureDetected name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pOnPinchZoomGestureDetected',
  pOnLostFocus name
    'Java_com_example_appmediaplayerdemo1_Controls_pOnLostFocus',
  pOnBeforeDispatchDraw name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnBeforeDispatchDraw',
  pOnAfterDispatchDraw name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnAfterDispatchDraw',
  pOnLayouting name
    'Java_com_example_appmediaplayerdemo1_Controls_pOnLayouting',
  pAppOnRequestPermissionResult name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pAppOnRequestPermissionResult',
  pOnMediaPlayerPrepared name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnMediaPlayerPrepared',
  pOnMediaPlayerVideoSizeChanged name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pOnMediaPlayerVideoSizeChanged',
  pOnMediaPlayerCompletion name 'Java_com_example_appmediaplayerdemo1_Controls'
    +'_pOnMediaPlayerCompletion',
  pOnMediaPlayerTimedText name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnMediaPlayerTimedText',
  pOnSurfaceViewCreated name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnSurfaceViewCreated',
  pOnSurfaceViewDraw name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnSurfaceViewDraw',
  pOnSurfaceViewChanged name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnSurfaceViewChanged',
  pOnSurfaceViewTouch name 'Java_com_example_appmediaplayerdemo1_Controls_'
    +'pOnSurfaceViewTouch',
  pOnSurfaceViewDrawingInBackground name 'Java_com_example_appmediaplayerdemo1'
    +'_Controls_pOnSurfaceViewDrawingInBackground',
  pOnSurfaceViewDrawingPostExecute name 'Java_com_example_appmediaplayerdemo1_'
    +'Controls_pOnSurfaceViewDrawingPostExecute';

{%endregion}

begin
  gApp:= jApp.Create(nil);{AndroidWidget.pas}
  gApp.Title:= 'My Android Bridges Library';
  gjAppName:= 'com.example.appmediaplayerdemo1';{AndroidWidget.pas}
  gjClassName:= 'com/example/appmediaplayerdemo1/Controls';{AndroidWidget.pas}
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TAndroidModule1, AndroidModule1);
end.
(*last [smart] upgrade: 7/4/2016 0:49:29*)
