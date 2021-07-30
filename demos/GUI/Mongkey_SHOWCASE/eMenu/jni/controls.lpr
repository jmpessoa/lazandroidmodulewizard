{hint: Pascal files location: ...\eMenu\jni }
library controls;  //[by LAMW: Lazarus Android Module Wizard: 6/30/2021 10:22:27]
  
{$mode delphi}
  
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, u_main, u_menu_view;
  
{%region /fold 'LAMW generated code'}

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;Landroid/content/Intent;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject; 
  layout: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnCreate(PEnv, this, context, layout, intent); f_main.ReInit(
    gApp);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnNewIntent
  Signature: (Landroid/content/Intent;)V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject; intent: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv, this, intent);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv, this, rotate);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnUpdateLayout
  Signature: ()V }
procedure pAppOnUpdateLayout(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnUpdateLayout(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv, this);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt; 
  resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv, this, requestCode, resultCode, data);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject); 
  cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv, this, menu);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject; 
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean); 
  cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv, this, menuItem, itemID, 
    itemCaption, checked);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnPrepareOptionsMenu
  Signature: (Landroid/view/Menu;I)Z }
function pAppOnPrepareOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject; 
  menuSize: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenu(PEnv, this, menu, menuSize);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnPrepareOptionsMenuItem
  Signature: (Landroid/view/Menu;Landroid/view/MenuItem;I)Z }
function pAppOnPrepareOptionsMenuItem(PEnv: PJNIEnv; this: JObject; 
  menu: JObject; menuItem: JObject; itemIndex: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenuItem(PEnv, this, menu, menuItem, 
    itemIndex);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject); 
  cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv, this, menu);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject; 
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean); 
  cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv, this, menuItem, itemID, 
    itemCaption, checked);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnDraw
  Signature: (J)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDraw(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt; 
  cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, x2, y2);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnClickGeneric
  Signature: (J)V }
procedure pOnClickGeneric(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClickGeneric(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnSpecialKeyDown
  Signature: (CILjava/lang/String;)Z }
function pAppOnSpecialKeyDown(PEnv: PJNIEnv; this: JObject; keyChar: JChar; 
  keyCode: JInt; keyCodeString: JString): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnSpecialKeyDown(PEnv, this, keyChar, keyCode, 
    keyCodeString);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnDown
  Signature: (J)V }
procedure pOnDown(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDown(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnUp
  Signature: (J)V }
procedure pOnUp(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnUp(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt); 
  cdecl;
begin
  Java_Event_pOnClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnLongClick
  Signature: (J)V }
procedure pOnLongClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnLongClick(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnDoubleClick
  Signature: (J)V }
procedure pOnDoubleClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnDoubleClick(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString; 
  count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString; 
  count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnBackPressed
  Signature: (J)V }
procedure pOnBackPressed(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBackPressed(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt
  ); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv, this, view, id);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject; 
  view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv, this, adapter, view, position, id);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv, this, TObject(pasobj), direction);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv, this, TObject(pasobj), 
    scaleFactor, state);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnLostFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnLostFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  text: JString); cdecl;
begin
  Java_Event_pOnLostFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnFocus
  Signature: (JLjava/lang/String;)V }
procedure pOnFocus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; text: JString); 
  cdecl;
begin
  Java_Event_pOnFocus(PEnv, this, TObject(pasobj), text);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnBeforeDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnBeforeDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnBeforeDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnAfterDispatchDraw
  Signature: (JLandroid/graphics/Canvas;I)V }
procedure pOnAfterDispatchDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  canvas: JObject; tag: JInt); cdecl;
begin
  Java_Event_pOnAfterDispatchDraw(PEnv, this, TObject(pasobj), canvas, tag);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnLayouting
  Signature: (JZ)V }
procedure pOnLayouting(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  changed: JBoolean); cdecl;
begin
  Java_Event_pOnLayouting(PEnv, this, TObject(pasobj), changed);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pAppOnRequestPermissionResult
  Signature: (ILjava/lang/String;I)V }
procedure pAppOnRequestPermissionResult(PEnv: PJNIEnv; this: JObject; 
  requestCode: JInt; permission: JString; grantResult: JInt); cdecl;
begin
  Java_Event_pAppOnRequestPermissionResult(PEnv, this, requestCode, permission, 
    grantResult);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRunOnUiThread
  Signature: (JI)V }
procedure pOnRunOnUiThread(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  tag: JInt); cdecl;
begin
  Java_Event_pOnRunOnUiThread(PEnv, this, TObject(pasobj), tag);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnAsyncEventDoInBackground
  Signature: (JI)Z }
function pOnAsyncEventDoInBackground(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnAsyncEventDoInBackground(PEnv, this, TObject(pasobj), 
    progress);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnAsyncEventProgressUpdate
  Signature: (JI)I }
function pOnAsyncEventProgressUpdate(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pOnAsyncEventProgressUpdate(PEnv, this, TObject(pasobj), 
    progress);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnAsyncEventPreExecute
  Signature: (J)I }
function pOnAsyncEventPreExecute(PEnv: PJNIEnv; this: JObject; pasobj: JLong
  ): JInt; cdecl;
begin
  Result:=Java_Event_pOnAsyncEventPreExecute(PEnv, this, TObject(pasobj));
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnAsyncEventPostExecute
  Signature: (JI)V }
procedure pOnAsyncEventPostExecute(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  progress: JInt); cdecl;
begin
  Java_Event_pOnAsyncEventPostExecute(PEnv, this, TObject(pasobj), progress);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnImageViewPopupItemSelected
  Signature: (JLjava/lang/String;)V }
procedure pOnImageViewPopupItemSelected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; caption: JString); cdecl;
begin
  Java_Event_pOnImageViewPopupItemSelected(PEnv, this, TObject(pasobj), caption
    );
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnScrollViewChanged
  Signature: (JIIIIII)V }
procedure pOnScrollViewChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  currenthorizontal: JInt; currentVertical: JInt; previousHorizontal: JInt; 
  previousVertical: JInt; onPosition: JInt; scrolldiff: JInt); cdecl;
begin
  Java_Event_pOnScrollViewChanged(PEnv, this, TObject(pasobj), 
    currenthorizontal, currentVertical, previousHorizontal, previousVertical, 
    onPosition, scrolldiff);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnScrollViewInnerItemClick
  Signature: (JI)V }
procedure pOnScrollViewInnerItemClick(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemId: JInt); cdecl;
begin
  Java_Event_pOnScrollViewInnerItemClick(PEnv, this, TObject(pasobj), itemId);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnScrollViewInnerItemLongClick
  Signature: (JII)V }
procedure pOnScrollViewInnerItemLongClick(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; index: JInt; itemId: JInt); cdecl;
begin
  Java_Event_pOnScrollViewInnerItemLongClick(PEnv, this, TObject(pasobj), 
    index, itemId);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemClick
  Signature: (JI)V }
procedure pOnRecyclerViewItemClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  itemIndex: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemClick(PEnv, this, TObject(pasobj), itemIndex);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemLongClick
  Signature: (JI)V }
procedure pOnRecyclerViewItemLongClick(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemLongClick(PEnv, this, TObject(pasobj), itemIndex
    );
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemTouchUp
  Signature: (JI)V }
procedure pOnRecyclerViewItemTouchUp(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemTouchUp(PEnv, this, TObject(pasobj), itemIndex);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemTouchDown
  Signature: (JI)V }
procedure pOnRecyclerViewItemTouchDown(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemTouchDown(PEnv, this, TObject(pasobj), itemIndex
    );
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemWidgetClick
  Signature: (JIIII)V }
procedure pOnRecyclerViewItemWidgetClick(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt; widgetClass: JInt; widgetId: JInt; 
  status: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemWidgetClick(PEnv, this, TObject(pasobj), 
    itemIndex, widgetClass, widgetId, status);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemWidgetLongClick
  Signature: (JIII)V }
procedure pOnRecyclerViewItemWidgetLongClick(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt; widgetClass: JInt; widgetId: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemWidgetLongClick(PEnv, this, TObject(pasobj), 
    itemIndex, widgetClass, widgetId);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemWidgetTouchUp
  Signature: (JIII)V }
procedure pOnRecyclerViewItemWidgetTouchUp(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt; widgetClass: JInt; widgetId: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemWidgetTouchUp(PEnv, this, TObject(pasobj), 
    itemIndex, widgetClass, widgetId);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnRecyclerViewItemWidgetTouchDown
  Signature: (JIII)V }
procedure pOnRecyclerViewItemWidgetTouchDown(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; itemIndex: JInt; widgetClass: JInt; widgetId: JInt); cdecl;
begin
  Java_Event_pOnRecyclerViewItemWidgetTouchDown(PEnv, this, TObject(pasobj), 
    itemIndex, widgetClass, widgetId);
end;

{ Class:     food_tekno_emenu_Controls
  Method:    pOnTimer
  Signature: (J)V }
procedure pOnTimer(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnTimer(PEnv, this, TObject(pasobj));
end;

const NativeMethods: array[0..61] of JNINativeMethod = (
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
   (name: 'pOnAsyncEventDoInBackground';
    signature: '(JI)Z';
    fnPtr: @pOnAsyncEventDoInBackground; ),
   (name: 'pOnAsyncEventProgressUpdate';
    signature: '(JI)I';
    fnPtr: @pOnAsyncEventProgressUpdate; ),
   (name: 'pOnAsyncEventPreExecute';
    signature: '(J)I';
    fnPtr: @pOnAsyncEventPreExecute; ),
   (name: 'pOnAsyncEventPostExecute';
    signature: '(JI)V';
    fnPtr: @pOnAsyncEventPostExecute; ),
   (name: 'pOnImageViewPopupItemSelected';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnImageViewPopupItemSelected; ),
   (name: 'pOnScrollViewChanged';
    signature: '(JIIIIII)V';
    fnPtr: @pOnScrollViewChanged; ),
   (name: 'pOnScrollViewInnerItemClick';
    signature: '(JI)V';
    fnPtr: @pOnScrollViewInnerItemClick; ),
   (name: 'pOnScrollViewInnerItemLongClick';
    signature: '(JII)V';
    fnPtr: @pOnScrollViewInnerItemLongClick; ),
   (name: 'pOnRecyclerViewItemClick';
    signature: '(JI)V';
    fnPtr: @pOnRecyclerViewItemClick; ),
   (name: 'pOnRecyclerViewItemLongClick';
    signature: '(JI)V';
    fnPtr: @pOnRecyclerViewItemLongClick; ),
   (name: 'pOnRecyclerViewItemTouchUp';
    signature: '(JI)V';
    fnPtr: @pOnRecyclerViewItemTouchUp; ),
   (name: 'pOnRecyclerViewItemTouchDown';
    signature: '(JI)V';
    fnPtr: @pOnRecyclerViewItemTouchDown; ),
   (name: 'pOnRecyclerViewItemWidgetClick';
    signature: '(JIIII)V';
    fnPtr: @pOnRecyclerViewItemWidgetClick; ),
   (name: 'pOnRecyclerViewItemWidgetLongClick';
    signature: '(JIII)V';
    fnPtr: @pOnRecyclerViewItemWidgetLongClick; ),
   (name: 'pOnRecyclerViewItemWidgetTouchUp';
    signature: '(JIII)V';
    fnPtr: @pOnRecyclerViewItemWidgetTouchUp; ),
   (name: 'pOnRecyclerViewItemWidgetTouchDown';
    signature: '(JIII)V';
    fnPtr: @pOnRecyclerViewItemWidgetTouchDown; ),
   (name: 'pOnTimer';
    signature: '(J)V';
    fnPtr: @pOnTimer; )
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
     RegisterNativeMethods(curEnv, 'food/tekno/emenu/Controls');
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
  pAppOnCreate name 'Java_food_tekno_emenu_Controls_pAppOnCreate',
  pAppOnScreenStyle name 'Java_food_tekno_emenu_Controls_pAppOnScreenStyle',
  pAppOnNewIntent name 'Java_food_tekno_emenu_Controls_pAppOnNewIntent',
  pAppOnDestroy name 'Java_food_tekno_emenu_Controls_pAppOnDestroy',
  pAppOnPause name 'Java_food_tekno_emenu_Controls_pAppOnPause',
  pAppOnRestart name 'Java_food_tekno_emenu_Controls_pAppOnRestart',
  pAppOnResume name 'Java_food_tekno_emenu_Controls_pAppOnResume',
  pAppOnStart name 'Java_food_tekno_emenu_Controls_pAppOnStart',
  pAppOnStop name 'Java_food_tekno_emenu_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_food_tekno_emenu_Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_food_tekno_emenu_Controls_pAppOnRotate',
  pAppOnUpdateLayout name 'Java_food_tekno_emenu_Controls_pAppOnUpdateLayout',
  pAppOnConfigurationChanged name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnClickOptionMenuItem',
  pAppOnPrepareOptionsMenu name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnPrepareOptionsMenu',
  pAppOnPrepareOptionsMenuItem name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnPrepareOptionsMenuItem',
  pAppOnCreateContextMenu name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnClickContextMenuItem',
  pOnDraw name 'Java_food_tekno_emenu_Controls_pOnDraw',
  pOnTouch name 'Java_food_tekno_emenu_Controls_pOnTouch',
  pOnClickGeneric name 'Java_food_tekno_emenu_Controls_pOnClickGeneric',
  pAppOnSpecialKeyDown name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnSpecialKeyDown',
  pOnDown name 'Java_food_tekno_emenu_Controls_pOnDown',
  pOnUp name 'Java_food_tekno_emenu_Controls_pOnUp',
  pOnClick name 'Java_food_tekno_emenu_Controls_pOnClick',
  pOnLongClick name 'Java_food_tekno_emenu_Controls_pOnLongClick',
  pOnDoubleClick name 'Java_food_tekno_emenu_Controls_pOnDoubleClick',
  pOnChange name 'Java_food_tekno_emenu_Controls_pOnChange',
  pOnChanged name 'Java_food_tekno_emenu_Controls_pOnChanged',
  pOnEnter name 'Java_food_tekno_emenu_Controls_pOnEnter',
  pOnBackPressed name 'Java_food_tekno_emenu_Controls_pOnBackPressed',
  pOnClose name 'Java_food_tekno_emenu_Controls_pOnClose',
  pAppOnViewClick name 'Java_food_tekno_emenu_Controls_pAppOnViewClick',
  pAppOnListItemClick name 'Java_food_tekno_emenu_Controls_pAppOnListItemClick',
  pOnFlingGestureDetected name 'Java_food_tekno_emenu_Controls_'
    +'pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_food_tekno_emenu_Controls_'
    +'pOnPinchZoomGestureDetected',
  pOnLostFocus name 'Java_food_tekno_emenu_Controls_pOnLostFocus',
  pOnFocus name 'Java_food_tekno_emenu_Controls_pOnFocus',
  pOnBeforeDispatchDraw name 'Java_food_tekno_emenu_Controls_'
    +'pOnBeforeDispatchDraw',
  pOnAfterDispatchDraw name 'Java_food_tekno_emenu_Controls_'
    +'pOnAfterDispatchDraw',
  pOnLayouting name 'Java_food_tekno_emenu_Controls_pOnLayouting',
  pAppOnRequestPermissionResult name 'Java_food_tekno_emenu_Controls_'
    +'pAppOnRequestPermissionResult',
  pOnRunOnUiThread name 'Java_food_tekno_emenu_Controls_pOnRunOnUiThread',
  pOnAsyncEventDoInBackground name 'Java_food_tekno_emenu_Controls_'
    +'pOnAsyncEventDoInBackground',
  pOnAsyncEventProgressUpdate name 'Java_food_tekno_emenu_Controls_'
    +'pOnAsyncEventProgressUpdate',
  pOnAsyncEventPreExecute name 'Java_food_tekno_emenu_Controls_'
    +'pOnAsyncEventPreExecute',
  pOnAsyncEventPostExecute name 'Java_food_tekno_emenu_Controls_'
    +'pOnAsyncEventPostExecute',
  pOnImageViewPopupItemSelected name 'Java_food_tekno_emenu_Controls_'
    +'pOnImageViewPopupItemSelected',
  pOnScrollViewChanged name 'Java_food_tekno_emenu_Controls_'
    +'pOnScrollViewChanged',
  pOnScrollViewInnerItemClick name 'Java_food_tekno_emenu_Controls_'
    +'pOnScrollViewInnerItemClick',
  pOnScrollViewInnerItemLongClick name 'Java_food_tekno_emenu_Controls_'
    +'pOnScrollViewInnerItemLongClick',
  pOnRecyclerViewItemClick name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemClick',
  pOnRecyclerViewItemLongClick name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemLongClick',
  pOnRecyclerViewItemTouchUp name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemTouchUp',
  pOnRecyclerViewItemTouchDown name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemTouchDown',
  pOnRecyclerViewItemWidgetClick name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemWidgetClick',
  pOnRecyclerViewItemWidgetLongClick name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemWidgetLongClick',
  pOnRecyclerViewItemWidgetTouchUp name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemWidgetTouchUp',
  pOnRecyclerViewItemWidgetTouchDown name 'Java_food_tekno_emenu_Controls_'
    +'pOnRecyclerViewItemWidgetTouchDown',
  pOnTimer name 'Java_food_tekno_emenu_Controls_pOnTimer';

{%endregion}
  
begin
  gApp:= jApp.Create(nil);
  gApp.Screen.Style:=ssLandscape;
  gApp.Title:= 'LAMW JNI Android Bridges Library';
  gjAppName:= 'food.tekno.emenu';
  gjClassName:= 'food/tekno/emenu/Controls';
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(Tf_main, f_main);
end.
