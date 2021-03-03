{hint: save all files to location: C:\lamw\workspace\AppCompatAdMobDemo1\jni\ }
library controls;  //[by LAMW: Lazarus Android Module Wizard: 8/4/2018 23:34:44]
  
{$mode delphi}
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, unit1;
  
{%region /fold 'LAMW generated code'}

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;Landroid/content/Intent;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject;
  layout: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnCreate(PEnv, this, context, layout, intent);
    AndroidModule1.ReInit(gApp);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnNewIntent
  Signature: (Landroid/content/Intent;)V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv, this, intent);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv, this, rotate);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnUpdateLayout
  Signature: ()V }
procedure pAppOnUpdateLayout(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnUpdateLayout(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv, this);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt;
  resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv, this, requestCode, resultCode, data);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
  cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv, this, menu);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject;
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
  cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv, this, menuItem, itemID,
    itemCaption, checked);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnPrepareOptionsMenu
  Signature: (Landroid/view/Menu;I)Z }
function pAppOnPrepareOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject;
  menuSize: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenu(PEnv, this, menu, menuSize);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnPrepareOptionsMenuItem
  Signature: (Landroid/view/Menu;Landroid/view/MenuItem;I)Z }
function pAppOnPrepareOptionsMenuItem(PEnv: PJNIEnv; this: JObject;
  menu: JObject; menuItem: JObject; itemIndex: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenuItem(PEnv, this, menu, menuItem,
    itemIndex);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject);
  cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv, this, menu);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject;
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean);
  cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv, this, menuItem, itemID,
    itemCaption, checked);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnDraw
  Signature: (J)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDraw(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt;
  cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, x2, y2);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnClickGeneric
  Signature: (J)V }
procedure pOnClickGeneric(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClickGeneric(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnSpecialKeyDown
  Signature: (CILjava/lang/String;)Z }
function pAppOnSpecialKeyDown(PEnv: PJNIEnv; this: JObject; keyChar: JChar;
  keyCode: JInt; keyCodeString: JString): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnSpecialKeyDown(PEnv, this, keyChar, keyCode,
    keyCodeString);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnDown
  Signature: (J)V }
procedure pOnDown(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDown(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnUp
  Signature: (J)V }
procedure pOnUp(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnUp(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt);
  cdecl;
begin
  Java_Event_pOnClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnLongClick
  Signature: (J)V }
procedure pOnLongClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnLongClick(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnDoubleClick
  Signature: (J)V }
procedure pOnDoubleClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDoubleClick(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
  count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString;
  count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnBackPressed
  Signature: (J)V }
procedure pOnBackPressed(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBackPressed(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt
  ); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv, this, view, id);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject;
  view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv, this, adapter, view, position, id);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv, this, TObject(pasobj), direction);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv, this, TObject(pasobj),
    scaleFactor, state);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnLostFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnLostFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  text: JString); cdecl;
begin
  Java_Event_pOnLostFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; text: JString);
  cdecl;
begin
  Java_Event_pOnFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnBeforeDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnBeforeDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnBeforeDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAfterDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnAfterDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnAfterDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnLayouting
  Signature: (JZ)V }
procedure pOnLayouting(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  changed: JBoolean); cdecl;
begin
  Java_Event_pOnLayouting(PEnv, this, TObject(pasobj), changed);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pAppOnRequestPermissionResult
  Signature: (ILjava/lang/String;I)V }
procedure pAppOnRequestPermissionResult(PEnv: PJNIEnv; this: JObject;
  requestCode: JInt; permission: JString; grantResult: JInt); cdecl;
begin
  Java_Event_pAppOnRequestPermissionResult(PEnv, this, requestCode, permission,
    grantResult);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnRunOnUiThread
  Signature: (JI)V }
procedure pOnRunOnUiThread(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  tag: JInt); cdecl;
begin
  Java_Event_pOnRunOnUiThread(PEnv, this, TObject(pasobj), tag);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobLoaded
  Signature: (JI)V }
procedure pOnAdMobLoaded(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  admobType: JInt); cdecl;
begin
  Java_Event_pOnAdMobLoaded(PEnv, this, TObject(pasobj), admobType);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobFailedToLoad
  Signature: (JII)V }
procedure pOnAdMobFailedToLoad(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  admobType: JInt; errorCode: JInt); cdecl;
begin
  Java_Event_pOnAdMobFailedToLoad(PEnv, this, TObject(pasobj), admobType,
    errorCode);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobOpened
  Signature: (JI)V }
procedure pOnAdMobOpened(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  admobType: JInt); cdecl;
begin
  Java_Event_pOnAdMobOpened(PEnv, this, TObject(pasobj), admobType);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobClosed
  Signature: (JI)V }
procedure pOnAdMobClosed(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  admobType: JInt); cdecl;
begin
  Java_Event_pOnAdMobClosed(PEnv, this, TObject(pasobj), admobType);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobLeftApplication
  Signature: (JI)V }
procedure pOnAdMobLeftApplication(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  admobType: JInt); cdecl;
begin
  Java_Event_pOnAdMobLeftApplication(PEnv, this, TObject(pasobj), admobType);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobClicked
  Signature: (JI)V }
procedure pOnAdMobClicked(PEnv: PJNIEnv; this: JObject; pasobj: JLong;
  admobType: JInt); cdecl;
begin
  Java_Event_pOnAdMobClicked(PEnv, this, TObject(pasobj), admobType);
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobInitializationComplete
  Signature: (J)V }
procedure pOnAdMobInitializationComplete(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong); cdecl;
begin
  Java_Event_pOnAdMobInitializationComplete(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobRewardedUserEarned
  Signature: (J)V }
procedure pOnAdMobRewardedUserEarned(PEnv: PJNIEnv; this: JObject; pasobj: JLong
  ); cdecl;
begin
  Java_Event_pOnAdMobRewardedUserEarned(PEnv, this, TObject(pasobj));
end;

{ Class:     org_lamw_appcompatadmobdemo1_Controls
  Method:    pOnAdMobRewardedFailedToShow
  Signature: (JI)V }
procedure pOnAdMobRewardedFailedToShow(PEnv: PJNIEnv; this: JObject;
  pasobj: JLong; errorCode: JInt); cdecl;
begin
  Java_Event_pOnAdMobRewardedFailedToShow(PEnv, this, TObject(pasobj), errorCode
    );
end;

const NativeMethods: array[0..53] of JNINativeMethod = (
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
    fnPtr: @pOnRunOnUiThread; ),
   (name: 'pOnAdMobLoaded';
    signature: '(JI)V';
    fnPtr: @pOnAdMobLoaded; ),
   (name: 'pOnAdMobFailedToLoad';
    signature: '(JII)V';
    fnPtr: @pOnAdMobFailedToLoad; ),
   (name: 'pOnAdMobOpened';
    signature: '(JI)V';
    fnPtr: @pOnAdMobOpened; ),
   (name: 'pOnAdMobClosed';
    signature: '(JI)V';
    fnPtr: @pOnAdMobClosed; ),
   (name: 'pOnAdMobLeftApplication';
    signature: '(JI)V';
    fnPtr: @pOnAdMobLeftApplication; ),
   (name: 'pOnAdMobClicked';
    signature: '(JI)V';
    fnPtr: @pOnAdMobClicked; ),
   (name: 'pOnAdMobInitializationComplete';
    signature: '(J)V';
    fnPtr: @pOnAdMobInitializationComplete; ),
   (name: 'pOnAdMobRewardedUserEarned';
    signature: '(J)V';
    fnPtr: @pOnAdMobRewardedUserEarned; ),
   (name: 'pOnAdMobRewardedFailedToShow';
    signature: '(JI)V';
    fnPtr: @pOnAdMobRewardedFailedToShow; )
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
     RegisterNativeMethods(curEnv, 'org/lamw/appcompatadmobdemo1/Controls');
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
  pAppOnCreate name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnCreate',
  pAppOnScreenStyle name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnScreenStyle',
  pAppOnNewIntent name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnNewIntent',
  pAppOnDestroy name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnDestroy',
  pAppOnPause name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnPause',
  pAppOnRestart name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnRestart',
  pAppOnResume name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnResume',
  pAppOnStart name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnStart',
  pAppOnStop name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnBackPressed',
  pAppOnRotate name 'Java_org_lamw_appcompatadmobdemo1_Controls_pAppOnRotate',
  pAppOnUpdateLayout name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnUpdateLayout',
  pAppOnConfigurationChanged name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnClickOptionMenuItem',
  pAppOnPrepareOptionsMenu name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnPrepareOptionsMenu',
  pAppOnPrepareOptionsMenuItem name 'Java_org_lamw_appcompatadmobdemo1_'
    +'Controls_pAppOnPrepareOptionsMenuItem',
  pAppOnCreateContextMenu name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnClickContextMenuItem',
  pOnDraw name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnDraw',
  pOnTouch name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnTouch',
  pOnClickGeneric name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnClickGeneric',
  pAppOnSpecialKeyDown name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnSpecialKeyDown',
  pOnDown name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnDown',
  pOnUp name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnUp',
  pOnClick name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnClick',
  pOnLongClick name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnLongClick',
  pOnDoubleClick name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnDoubleClick',
  pOnChange name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnChange',
  pOnChanged name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnChanged',
  pOnEnter name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnEnter',
  pOnBackPressed name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnBackPressed',
  pOnClose name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnClose',
  pAppOnViewClick name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnViewClick',
  pAppOnListItemClick name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pAppOnListItemClick',
  pOnFlingGestureDetected name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_org_lamw_appcompatadmobdemo1_Controls'
    +'_pOnPinchZoomGestureDetected',
  pOnLostFocus name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnLostFocus',
  pOnFocus name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnFocus',
  pOnBeforeDispatchDraw name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnBeforeDispatchDraw',
  pOnAfterDispatchDraw name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAfterDispatchDraw',
  pOnLayouting name 'Java_org_lamw_appcompatadmobdemo1_Controls_pOnLayouting',
  pAppOnRequestPermissionResult name 'Java_org_lamw_appcompatadmobdemo1_'
    +'Controls_pAppOnRequestPermissionResult',
  pOnRunOnUiThread name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnRunOnUiThread',
  pOnAdMobLoaded name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobLoaded',
  pOnAdMobFailedToLoad name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobFailedToLoad',
  pOnAdMobOpened name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobOpened',
  pOnAdMobClosed name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobClosed',
  pOnAdMobLeftApplication name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobLeftApplication',
  pOnAdMobClicked name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobClicked',
  pOnAdMobInitializationComplete name 'Java_org_lamw_appcompatadmobdemo1_'
    +'Controls_pOnAdMobInitializationComplete',
  pOnAdMobRewardedUserEarned name 'Java_org_lamw_appcompatadmobdemo1_Controls_'
    +'pOnAdMobRewardedUserEarned',
  pOnAdMobRewardedFailedToShow name 'Java_org_lamw_appcompatadmobdemo1_'
    +'Controls_pOnAdMobRewardedFailedToShow';

{%endregion}
  
begin
  gApp:= jApp.Create(nil);
  gApp.Title:= 'LAMW JNI Android Bridges Library';
  gjAppName:= 'org.lamw.appcompatadmobdemo1';
  gjClassName:= 'org/lamw/appcompatadmobdemo1/Controls';
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TAndroidModule1, AndroidModule1);
end.
