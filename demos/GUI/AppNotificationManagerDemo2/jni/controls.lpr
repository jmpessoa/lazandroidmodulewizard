{hint: save all files to location: C:\android-neon\eclipse\workspace\AppNotificationManagerDemo2\jni\ }
library controls;  //[by Lamw: Lazarus Android Module Wizard: 3/18/2017 16:32:33]
  
{$mode delphi}
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, unit1;
  
{%region /fold 'LAMW generated code'}

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;Landroid/content/Intent;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject;
  layout: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnCreate(PEnv, this, context, layout, intent);
    AndroidModule1.Reinit;
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnNewIntent
  Signature: (Landroid/content/Intent;)V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv, this, intent);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv, this, rotate);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnUpdateLayout
  Signature: ()V }
procedure pAppOnUpdateLayout(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnUpdateLayout(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv, this);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt;
  resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv, this, requestCode, resultCode, data);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
  cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv, this, menu);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject;
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
  cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv, this, menuItem, itemID,
    itemCaption, checked);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnPrepareOptionsMenu
  Signature: (Landroid/view/Menu;I)Z }
function pAppOnPrepareOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject;
  menuSize: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenu(PEnv, this, menu, menuSize);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnPrepareOptionsMenuItem
  Signature: (Landroid/view/Menu;Landroid/view/MenuItem;I)Z }
function pAppOnPrepareOptionsMenuItem(PEnv: PJNIEnv; this: JObject;
  menu: JObject; menuItem: JObject; itemIndex: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenuItem(PEnv, this, menu, menuItem,
    itemIndex);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
  cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv, this, menu);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject;
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
  cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv, this, menuItem, itemID,
    itemCaption, checked);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnDraw
  Signature: (J)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDraw(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt;
  cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, x2, y2);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnClickGeneric
  Signature: (J)V }
procedure pOnClickGeneric(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClickGeneric(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnSpecialKeyDown
  Signature: (CILjava/lang/String;)Z }
function pAppOnSpecialKeyDown(PEnv: PJNIEnv; this: JObject; keyChar: JChar;
  keyCode: JInt; keyCodeString: JString): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnSpecialKeyDown(PEnv, this, keyChar, keyCode,
    keyCodeString);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnDown
  Signature: (J)V }
procedure pOnDown(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDown(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnUp
  Signature: (J)V }
procedure pOnUp(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnUp(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt);
  cdecl;
begin
  Java_Event_pOnClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnLongClick
  Signature: (J)V }
procedure pOnLongClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnLongClick(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnDoubleClick
  Signature: (J)V }
procedure pOnDoubleClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDoubleClick(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
  count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
  count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnBackPressed
  Signature: (J)V }
procedure pOnBackPressed(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBackPressed(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnDone
  Signature: (J)V }
procedure pOnDone(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDone(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnSearch
  Signature: (J)V }
procedure pOnSearch(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnSearch(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnNext
  Signature: (J)V }
procedure pOnNext(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnNext(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnGo
  Signature: (J)V }
procedure pOnGo(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnGo(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt
  ); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv, this, view, id);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject;
  view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv, this, adapter, view, position, id);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv, this, TObject(pasobj), direction);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv, this, TObject(pasobj),
    scaleFactor, state);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnLostFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnLostFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  text: JString); cdecl;
begin
  Java_Event_pOnLostFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; text: JString);
  cdecl;
begin
  Java_Event_pOnFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnBeforeDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnBeforeDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnBeforeDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnAfterDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnAfterDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnAfterDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnLayouting
  Signature: (JZ)V }
procedure pOnLayouting(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  changed: JBoolean); cdecl;
begin
  Java_Event_pOnLayouting(PEnv, this, TObject(pasobj), changed);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pAppOnRequestPermissionResult
  Signature: (ILjava/lang/String;I)V }
procedure pAppOnRequestPermissionResult(PEnv: PJNIEnv; this: JObject;
  requestCode: JInt; permission: JString; grantResult: JInt); cdecl;
begin
  Java_Event_pAppOnRequestPermissionResult(PEnv, this, requestCode, permission,
    grantResult);
end;

{ Class:     com_example_appnotificationmanagerdemo2_Controls
  Method:    pOnRunOnUiThread
  Signature: (JI)V }
procedure pOnRunOnUiThread(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  tag: JInt); cdecl;
begin
  Java_Event_pOnRunOnUiThread(PEnv, this, TObject(pasobj), tag);
end;

const NativeMethods: array[0..48] of JNINativeMethod = (
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
   (name: 'pAppOnUpdateLayout';
    signature: '()V';
    fnPtr: @pAppOnUpdateLayout; ),
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
    signature: '(J)V';
    fnPtr: @pOnClickGeneric; ),
   (name: 'pAppOnSpecialKeyDown';
    signature: '(CILjava/lang/String;)Z';
    fnPtr: @pAppOnSpecialKeyDown; ),
   (name: 'pOnDown';
    signature: '(J)V';
    fnPtr: @pOnDown; ),
   (name: 'pOnUp';
    signature: '(J)V';
    fnPtr: @pOnUp; ),
   (name: 'pOnClick';
    signature: '(JI)V';
    fnPtr: @pOnClick; ),
   (name: 'pOnLongClick';
    signature: '(J)V';
    fnPtr: @pOnLongClick; ),
   (name: 'pOnDoubleClick';
    signature: '(J)V';
    fnPtr: @pOnDoubleClick; ),
   (name: 'pOnChange';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChange; ),
   (name: 'pOnChanged';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChanged; ),
   (name: 'pOnEnter';
    signature: '(J)V';
    fnPtr: @pOnEnter; ),
   (name: 'pOnBackPressed';
    signature: '(J)V';
    fnPtr: @pOnBackPressed; ),
   (name: 'pOnDone';
    signature: '(J)V';
    fnPtr: @pOnDone; ),
   (name: 'pOnSearch';
    signature: '(J)V';
    fnPtr: @pOnSearch; ),
   (name: 'pOnNext';
    signature: '(J)V';
    fnPtr: @pOnNext; ),
   (name: 'pOnGo';
    signature: '(J)V';
    fnPtr: @pOnGo; ),
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
   (name: 'pOnFocus';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnFocus; ),
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
   (name: 'pOnRunOnUiThread';
    signature: '(JI)V';
    fnPtr: @pOnRunOnUiThread; )
);

function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar;
  methods: PJNINativeMethod; countMethods: integer): integer;
var
  curClass: jClass;
begin
  Result:= JNI_FALSE;
  curClass:= (PEnv^).FindClass(PEnv, className);
  if curClass <> nil then
    result := (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods);
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
  rc: integer;
begin
  PEnv:= nil;
  Result:= JNI_VERSION_1_6;

  if (VM^).GetEnv(VM, @PEnv, Result) <> JNI_OK then
  begin
   result := JNI_ERR;
   exit;
  end;

  if PEnv <> nil then
  begin
     curEnv:= PJNIEnv(PEnv);
     rc := RegisterNativeMethods(curEnv, 'com/example/appnotificationmanagerdem'
       +'o2/Controls');
     if (rc <> JNI_OK) then result := rc;
  end;
  gVM:= VM; {AndroidWidget.pas}
end;

procedure JNI_OnUnload(VM: PJavaVM; {%H-}reserved: pointer); cdecl;
var
  PEnv: PPointer;
  curEnv: PJNIEnv;
begin
  PEnv:= nil;

  if (VM^).GetEnv(VM, @PEnv, JNI_VERSION_1_6) <> JNI_OK then exit;

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
  pAppOnCreate name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnCreate',
  pAppOnScreenStyle name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnScreenStyle',
  pAppOnNewIntent name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnDestroy',
  pAppOnPause name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnPause',
  pAppOnRestart name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnRestart',
  pAppOnResume name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnResume',
  pAppOnStart name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnStart',
  pAppOnStop name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnStop',
  pAppOnBackPressed name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnRotate',
  pAppOnUpdateLayout name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnUpdateLayout',
  pAppOnConfigurationChanged name 'Java_com_example_appnotificationmanagerdemo'
    +'2_Controls_pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_com_example_appnotificationmanagerdemo2'
    +'_Controls_pAppOnClickOptionMenuItem',
  pAppOnPrepareOptionsMenu name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnPrepareOptionsMenu',
  pAppOnPrepareOptionsMenuItem name 'Java_com_example_appnotificationmanagerdem'
    +'o2_Controls_pAppOnPrepareOptionsMenuItem',
  pAppOnCreateContextMenu name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_com_example_appnotificationmanagerdemo'
    +'2_Controls_pAppOnClickContextMenuItem',
  pOnDraw name 'Java_com_example_appnotificationmanagerdemo2_Controls_pOnDraw',
  pOnTouch name
    'Java_com_example_appnotificationmanagerdemo2_Controls_pOnTouch',
  pOnClickGeneric name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnClickGeneric',
  pAppOnSpecialKeyDown name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnSpecialKeyDown',
  pOnDown name 'Java_com_example_appnotificationmanagerdemo2_Controls_pOnDown',
  pOnUp name 'Java_com_example_appnotificationmanagerdemo2_Controls_pOnUp',
  pOnClick name
    'Java_com_example_appnotificationmanagerdemo2_Controls_pOnClick',
  pOnLongClick name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnLongClick',
  pOnDoubleClick name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnDoubleClick',
  pOnChange name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnChange',
  pOnChanged name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnChanged',
  pOnEnter name
    'Java_com_example_appnotificationmanagerdemo2_Controls_pOnEnter',
  pOnBackPressed name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnBackPressed',
  pOnDone name 'Java_com_example_appnotificationmanagerdemo2_Controls_pOnDone',
  pOnSearch name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnSearch',
  pOnNext name 'Java_com_example_appnotificationmanagerdemo2_Controls_pOnNext',
  pOnGo name 'Java_com_example_appnotificationmanagerdemo2_Controls_pOnGo',
  pOnClose name
    'Java_com_example_appnotificationmanagerdemo2_Controls_pOnClose',
  pAppOnViewClick name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pAppOnViewClick',
  pAppOnListItemClick name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pAppOnListItemClick',
  pOnFlingGestureDetected name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_com_example_appnotificationmanagerdemo'
    +'2_Controls_pOnPinchZoomGestureDetected',
  pOnLostFocus name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnLostFocus',
  pOnFocus name
    'Java_com_example_appnotificationmanagerdemo2_Controls_pOnFocus',
  pOnBeforeDispatchDraw name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pOnBeforeDispatchDraw',
  pOnAfterDispatchDraw name 'Java_com_example_appnotificationmanagerdemo2_'
    +'Controls_pOnAfterDispatchDraw',
  pOnLayouting name 'Java_com_example_appnotificationmanagerdemo2_Controls_'
    +'pOnLayouting',
  pAppOnRequestPermissionResult name 'Java_com_example_appnotificationmanagerde'
    +'mo2_Controls_pAppOnRequestPermissionResult',
  pOnRunOnUiThread name 'Java_com_example_appnotificationmanagerdemo2_Controls'
    +'_pOnRunOnUiThread';

{%endregion}
  
begin
  gApp:= jApp.Create(nil);
  gApp.Title:= 'JNI Android Bridges Library';
  gjAppName:= 'com.example.appnotificationmanagerdemo2';
  gjClassName:= 'com/example/appnotificationmanagerdemo2/Controls';
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TAndroidModule1, AndroidModule1);
end.
