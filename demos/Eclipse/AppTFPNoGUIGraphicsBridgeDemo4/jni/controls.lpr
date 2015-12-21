{hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo4\jni\ }
library controls;  //[by Lamw: Lazarus Android Module Wizard: 12/20/2015 23:57:35]
  
{$mode delphi}
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, unit1;
  
{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject; 
  layout: JObject); cdecl;
begin
  gApp.Init(PEnv, this, context, layout); AndroidModule1.Init(gApp);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnNewIntent
  Signature: ()V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv, this, rotate);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv, this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt; 
  resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv, this, requestCode, resultCode, data);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject); 
  cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv, this, menu);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject; 
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean); 
  cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv, this, menuItem, itemID, 
    itemCaption, Boolean(checked));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnPrepareOptionsMenu
  Signature: (Landroid/view/Menu;I)Z }
function pAppOnPrepareOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject; 
  menuSize: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenu(PEnv, this, menu, menuSize);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnPrepareOptionsMenuItem
  Signature: (Landroid/view/Menu;Landroid/view/MenuItem;I)Z }
function pAppOnPrepareOptionsMenuItem(PEnv: PJNIEnv; this: JObject; 
  menu: JObject; menuItem: JObject; itemIndex: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pAppOnPrepareOptionsMenuItem(PEnv, this, menu, menuItem, 
    itemIndex);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject); 
  cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv, this, menu);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject; 
  menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean); 
  cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv, this, menuItem, itemID, 
    itemCaption, Boolean(checked));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt); 
  cdecl;
begin
  Java_Event_pOnClick(PEnv, this, TObject(pasobj), value);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString; 
  count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString; 
  count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv, this, TObject(pasobj), txt, count);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnTimer
  Signature: (J)V }
procedure pOnTimer(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnTimer(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnDraw
  Signature: (JLandroid/graphics/Canvas;)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong; canvas: JObject
  ); cdecl;
begin
  Java_Event_pOnDraw(PEnv, this, TObject(pasobj), canvas);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt; 
  cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, x2, y2);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnGLRenderer
  Signature: (JIII)V }
procedure pOnGLRenderer(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  EventType: JInt; w: JInt; h: JInt); cdecl;
begin
  Java_Event_pOnGLRenderer(PEnv, this, TObject(pasobj), EventType, w, h);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnWebViewStatus
  Signature: (JILjava/lang/String;)I }
function pOnWebViewStatus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  EventType: JInt; url: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnWebViewStatus(PEnv, this, TObject(pasobj), EventType, 
    url);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnAsyncEventDoInBackground
  Signature: (JI)Z }
function pOnAsyncEventDoInBackground(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnAsyncEventDoInBackground(PEnv, this, TObject(pasobj), 
    progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnAsyncEventProgressUpdate
  Signature: (JI)I }
function pOnAsyncEventProgressUpdate(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pOnAsyncEventProgressUpdate(PEnv, this, TObject(pasobj), 
    progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnAsyncEventPreExecute
  Signature: (J)I }
function pOnAsyncEventPreExecute(PEnv: PJNIEnv; this: JObject; pasobj: JLong
  ): JInt; cdecl;
begin
  Result:=Java_Event_pOnAsyncEventPreExecute(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnAsyncEventPostExecute
  Signature: (JI)V }
procedure pOnAsyncEventPostExecute(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  progress: JInt); cdecl;
begin
  Java_Event_pOnAsyncEventPostExecute(PEnv, this, TObject(pasobj), progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnClickWidgetItem
  Signature: (JIZ)V }
procedure pOnClickWidgetItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; checked: JBoolean); cdecl;
begin
  Java_Event_pOnClickWidgetItem(PEnv, this, TObject(pasobj), position, Boolean(
    checked));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnClickCaptionItem
  Signature: (JILjava/lang/String;)V }
procedure pOnClickCaptionItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickCaptionItem(PEnv, this, TObject(pasobj), position, caption
    );
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnListViewLongClickCaptionItem
  Signature: (JILjava/lang/String;)V }
procedure pOnListViewLongClickCaptionItem(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnListViewLongClickCaptionItem(PEnv, this, TObject(pasobj), 
    position, caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnListViewDrawItemCaptionColor
  Signature: (JILjava/lang/String;)I }
function pOnListViewDrawItemCaptionColor(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; position: JInt; caption: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemCaptionColor(PEnv, this, TObject(pasobj
    ), position, caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnListViewDrawItemBitmap
  Signature: (JILjava/lang/String;)Landroid/graphics/Bitmap; }
function pOnListViewDrawItemBitmap(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; caption: JString): JObject; cdecl;
begin
  Result:=Java_Event_pOnListViewDrawItemBitmap(PEnv, this, TObject(pasobj), 
    position, caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothEnabled
  Signature: (J)V }
procedure pOnBluetoothEnabled(PEnv: PJNIEnv; this: JObject; pasobj: JLong); 
  cdecl;
begin
  Java_Event_pOnBluetoothEnabled(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothDisabled
  Signature: (J)V }
procedure pOnBluetoothDisabled(PEnv: PJNIEnv; this: JObject; pasobj: JLong); 
  cdecl;
begin
  Java_Event_pOnBluetoothDisabled(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothDeviceFound
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothDeviceFound(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothDeviceFound(PEnv, this, TObject(pasobj), deviceName, 
    deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothDiscoveryStarted
  Signature: (J)V }
procedure pOnBluetoothDiscoveryStarted(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothDiscoveryStarted(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothDiscoveryFinished
  Signature: (JII)V }
procedure pOnBluetoothDiscoveryFinished(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; countFoundedDevices: JInt; countPairedDevices: JInt); cdecl;
begin
  Java_Event_pOnBluetoothDiscoveryFinished(PEnv, this, TObject(pasobj), 
    countFoundedDevices, countPairedDevices);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothDeviceBondStateChanged
  Signature: (JILjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothDeviceBondStateChanged(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; state: JInt; deviceName: JString; deviceAddress: JString); 
  cdecl;
begin
  Java_Event_pOnBluetoothDeviceBondStateChanged(PEnv, this, TObject(pasobj), 
    state, deviceName, deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothClientSocketConnected
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothClientSocketConnected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothClientSocketConnected(PEnv, this, TObject(pasobj), 
    deviceName, deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothClientSocketIncomingData
  Signature: (J[B[B)V }
procedure pOnBluetoothClientSocketIncomingData(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; byteArrayContent: JByteArray; byteArrayHeader: JByteArray); 
  cdecl;
begin
  Java_Event_pOnBluetoothClientSocketIncomingData(PEnv, this, TObject(pasobj), 
    byteArrayContent, byteArrayHeader);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothClientSocketDisconnected
  Signature: (J)V }
procedure pOnBluetoothClientSocketDisconnected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothClientSocketDisconnected(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothServerSocketConnected
  Signature: (JLjava/lang/String;Ljava/lang/String;)Z }
function pOnBluetoothServerSocketConnected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; deviceName: JString; deviceAddress: JString): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnBluetoothServerSocketConnected(PEnv, this, TObject(
    pasobj), deviceName, deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothServerSocketIncomingData
  Signature: (J[B[B)Z }
function pOnBluetoothServerSocketIncomingData(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; byteArrayContent: JByteArray; byteArrayHeader: JByteArray
  ): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnBluetoothServerSocketIncomingData(PEnv, this, TObject(
    pasobj), byteArrayContent, byteArrayHeader);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothServerSocketListen
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothServerSocketListen(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; serverName: JString; strUUID: JString); cdecl;
begin
  Java_Event_pOnBluetoothServerSocketListen(PEnv, this, TObject(pasobj), 
    serverName, strUUID);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBluetoothServerSocketAcceptTimeout
  Signature: (J)V }
procedure pOnBluetoothServerSocketAcceptTimeout(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothServerSocketAcceptTimeout(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSpinnerItemSeleceted
  Signature: (JILjava/lang/String;)V }
procedure pOnSpinnerItemSeleceted(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnSpinnerItemSeleceted(PEnv, this, TObject(pasobj), position, 
    caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnLocationChanged
  Signature: (JDDDLjava/lang/String;)V }
procedure pOnLocationChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  latitude: JDouble; longitude: JDouble; altitude: JDouble; address: JString); 
  cdecl;
begin
  Java_Event_pOnLocationChanged(PEnv, this, TObject(pasobj), latitude, 
    longitude, altitude, address);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnLocationStatusChanged
  Signature: (JILjava/lang/String;Ljava/lang/String;)V }
procedure pOnLocationStatusChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  status: JInt; provider: JString; msgStatus: JString); cdecl;
begin
  Java_Event_pOnLocationStatusChanged(PEnv, this, TObject(pasobj), status, 
    provider, msgStatus);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnLocationProviderEnabled
  Signature: (JLjava/lang/String;)V }
procedure pOnLocationProviderEnabled(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; provider: JString); cdecl;
begin
  Java_Event_pOnLocationProviderEnabled(PEnv, this, TObject(pasobj), provider);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnLocationProviderDisabled
  Signature: (JLjava/lang/String;)V }
procedure pOnLocationProviderDisabled(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; provider: JString); cdecl;
begin
  Java_Event_pOnLocationProviderDisabled(PEnv, this, TObject(pasobj), provider);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt
  ); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv, this, view, id);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject; 
  view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv, this, adapter, view, position, id);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnActionBarTabSelected
  Signature: (JLandroid/view/View;Ljava/lang/String;)V }
procedure pOnActionBarTabSelected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  view: JObject; title: JString); cdecl;
begin
  Java_Event_pOnActionBarTabSelected(PEnv, this, TObject(pasobj), view, title);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnActionBarTabUnSelected
  Signature: (JLandroid/view/View;Ljava/lang/String;)V }
procedure pOnActionBarTabUnSelected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; view: JObject; title: JString); cdecl;
begin
  Java_Event_pOnActionBarTabUnSelected(PEnv, this, TObject(pasobj), view, title
    );
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnCustomDialogShow
  Signature: (JLandroid/app/Dialog;Ljava/lang/String;)V }
procedure pOnCustomDialogShow(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  dialog: JObject; title: JString); cdecl;
begin
  Java_Event_pOnCustomDialogShow(PEnv, this, TObject(pasobj), dialog, title);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnCustomDialogBackKeyPressed
  Signature: (JLjava/lang/String;)V }
procedure pOnCustomDialogBackKeyPressed(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; title: JString); cdecl;
begin
  Java_Event_pOnCustomDialogBackKeyPressed(PEnv, this, TObject(pasobj), title);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnClickToggleButton
  Signature: (JZ)V }
procedure pOnClickToggleButton(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  state: JBoolean); cdecl;
begin
  Java_Event_pOnClickToggleButton(PEnv, this, TObject(pasobj), Boolean(state));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnChangeSwitchButton
  Signature: (JZ)V }
procedure pOnChangeSwitchButton(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  state: JBoolean); cdecl;
begin
  Java_Event_pOnChangeSwitchButton(PEnv, this, TObject(pasobj), Boolean(state));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnClickGridItem
  Signature: (JILjava/lang/String;)V }
procedure pOnClickGridItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickGridItem(PEnv, this, TObject(pasobj), position, caption);                            
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnLongClickGridItem
  Signature: (JILjava/lang/String;)V }
procedure pOnLongClickGridItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnLongClickGridItem(PEnv, this, TObject(pasobj), position, caption
    );
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnGridDrawItemCaptionColor
  Signature: (JILjava/lang/String;)I }
function pOnGridDrawItemCaptionColor(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; position: JInt; caption: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnGridDrawItemCaptionColor(PEnv, this, TObject(pasobj), 
    position, caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnGridDrawItemBitmap
  Signature: (JILjava/lang/String;)Landroid/graphics/Bitmap; }
function pOnGridDrawItemBitmap(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  position: JInt; caption: JString): JObject; cdecl;
begin
  Result:=Java_Event_pOnGridDrawItemBitmap(PEnv, this, TObject(pasobj), 
    position, caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnChangedSensor
  Signature: (JLandroid/hardware/Sensor;I[FJ)V }
procedure pOnChangedSensor(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  sensor: JObject; sensorType: JInt; values: JFloatArray; timestamp: JLong); 
  cdecl;
begin
  Java_Event_pOnChangedSensor(PEnv, this, TObject(pasobj), sensor, sensorType, 
    values, timestamp);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnListeningSensor
  Signature: (JLandroid/hardware/Sensor;I)V }
procedure pOnListeningSensor(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  sensor: JObject; sensorType: JInt); cdecl;
begin
  Java_Event_pOnListeningSensor(PEnv, this, TObject(pasobj), sensor, sensorType
    );
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnUnregisterListeningSensor
  Signature: (JILjava/lang/String;)V }
procedure pOnUnregisterListeningSensor(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; sensorType: JInt; sensorName: JString); cdecl;
begin
  Java_Event_pOnUnregisterListeningSensor(PEnv, this, TObject(pasobj), 
    sensorType, sensorName);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnBroadcastReceiver
  Signature: (JLandroid/content/Intent;)V }
procedure pOnBroadcastReceiver(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  intent: JObject); cdecl;
begin
  Java_Event_pOnBroadcastReceiver(PEnv, this, TObject(pasobj), intent);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnTimePicker
  Signature: (JII)V }
procedure pOnTimePicker(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  hourOfDay: JInt; minute: JInt); cdecl;
begin
  Java_Event_pOnTimePicker(PEnv, this, TObject(pasobj), hourOfDay, minute);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnDatePicker
  Signature: (JIII)V }
procedure pOnDatePicker(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  year: JInt; monthOfYear: JInt; dayOfMonth: JInt); cdecl;
begin
  Java_Event_pOnDatePicker(PEnv, this, TObject(pasobj), year, monthOfYear, 
    dayOfMonth);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv, this, TObject(pasobj), direction);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv, this, TObject(pasobj), 
    scaleFactor, state);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnShellCommandExecuted
  Signature: (JLjava/lang/String;)V }
procedure pOnShellCommandExecuted(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  cmdResult: JString); cdecl;
begin
  Java_Event_pOnShellCommandExecuted(PEnv, this, TObject(pasobj), cmdResult);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnTCPSocketClientMessageReceived
  Signature: (J[Ljava/lang/String;)V }
procedure pOnTCPSocketClientMessageReceived(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; messagesReceived: JStringArray); cdecl;
begin
  Java_Event_pOnTCPSocketClientMessageReceived(PEnv, this, TObject(pasobj), 
    messagesReceived);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnTCPSocketClientConnected
  Signature: (J)V }
procedure pOnTCPSocketClientConnected(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong); cdecl;
begin
  Java_Event_pOnTCPSocketClientConnected(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnHttpClientContentResult
  Signature: (JLjava/lang/String;)V }
procedure pOnHttpClientContentResult(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; content: JString); cdecl;
begin
  Java_Event_pOnHttpClientContentResult(PEnv, this, TObject(pasobj), content);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnHttpClientCodeResult
  Signature: (JI)V }
procedure pOnHttpClientCodeResult(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  code: JInt); cdecl;
begin
  Java_Event_pOnHttpClientCodeResult(PEnv, this, TObject(pasobj), code);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSurfaceViewCreated
  Signature: (JLandroid/view/SurfaceHolder;)V }
procedure pOnSurfaceViewCreated(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  surfaceHolder: JObject); cdecl;
begin
  Java_Event_pOnSurfaceViewCreated(PEnv, this, TObject(pasobj), surfaceHolder);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSurfaceViewDraw
  Signature: (JLandroid/graphics/Canvas;)V }
procedure pOnSurfaceViewDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  canvas: JObject); cdecl;
begin
  Java_Event_pOnSurfaceViewDraw(PEnv, this, TObject(pasobj), canvas);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSurfaceViewChanged
  Signature: (JII)V }
procedure pOnSurfaceViewChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  width: JInt; height: JInt); cdecl;
begin
  Java_Event_pOnSurfaceViewChanged(PEnv, this, TObject(pasobj), width, height);                                             
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnMediaPlayerPrepared
  Signature: (JII)V }
procedure pOnMediaPlayerPrepared(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  videoWidth: JInt; videoHeigh: JInt); cdecl;
begin
  Java_Event_pOnMediaPlayerPrepared(PEnv, this, TObject(pasobj), videoWidth, 
    videoHeigh);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnMediaPlayerVideoSizeChanged
  Signature: (JII)V }
procedure pOnMediaPlayerVideoSizeChanged(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; videoWidth: JInt; videoHeight: JInt); cdecl;
begin
  Java_Event_pOnMediaPlayerVideoSizeChanged(PEnv, this, TObject(pasobj), 
    videoWidth, videoHeight);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnMediaPlayerCompletion
  Signature: (J)V }
procedure pOnMediaPlayerCompletion(PEnv: PJNIEnv; this: JObject; pasobj: JLong
  ); cdecl;
begin
  Java_Event_pOnMediaPlayerCompletion(PEnv, this, TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnMediaPlayerTimedText
  Signature: (JLjava/lang/String;)V }
procedure pOnMediaPlayerTimedText(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  timedText: JString); cdecl;
begin
  Java_Event_pOnMediaPlayerTimedText(PEnv, this, TObject(pasobj), timedText);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSurfaceViewTouch
  Signature: (JIIFFFF)V }
procedure pOnSurfaceViewTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; 
  act: JInt; cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnSurfaceViewTouch(PEnv, this, TObject(pasobj), act, cnt, x1, y1, 
    x2, y2);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSurfaceViewDrawingInBackground
  Signature: (JF)Z }
function pOnSurfaceViewDrawingInBackground(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JFloat): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnSurfaceViewDrawingInBackground(PEnv, this, TObject(
    pasobj), progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSurfaceViewDrawingPostExecute
  Signature: (JF)V }
procedure pOnSurfaceViewDrawingPostExecute(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JFloat); cdecl;
begin
  Java_Event_pOnSurfaceViewDrawingPostExecute(PEnv, this, TObject(pasobj), 
    progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnContactManagerContactsExecuted
  Signature: (JI)V }
procedure pOnContactManagerContactsExecuted(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; count: JInt); cdecl;
begin
  Java_Event_pOnContactManagerContactsExecuted(PEnv, this, TObject(pasobj), 
    count);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnContactManagerContactsProgress
  Signature: (JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;I)Z }
function pOnContactManagerContactsProgress(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; contactInfo: JString; contactShortInfo: JString; 
  contactPhotoUriAsString: JString; contactPhoto: JObject; progress: JInt
  ): JBoolean; cdecl;
begin
  Result:=Java_Event_pOnContactManagerContactsProgress(PEnv, this, TObject(
    pasobj), contactInfo, contactShortInfo, contactPhotoUriAsString, 
    contactPhoto, progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSeekBarProgressChanged
  Signature: (JIZ)V }
procedure pOnSeekBarProgressChanged(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt; fromUser: JBoolean); cdecl;
begin
  Java_Event_pOnSeekBarProgressChanged(PEnv, this, TObject(pasobj), progress, 
    Boolean(fromUser));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSeekBarStartTrackingTouch
  Signature: (JI)V }
procedure pOnSeekBarStartTrackingTouch(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt); cdecl;
begin
  Java_Event_pOnSeekBarStartTrackingTouch(PEnv, this, TObject(pasobj), progress
    );
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo4_Controls
  Method:    pOnSeekBarStopTrackingTouch
  Signature: (JI)V }
procedure pOnSeekBarStopTrackingTouch(PEnv: PJNIEnv; this: JObject; 
  pasobj: JLong; progress: JInt); cdecl;
begin
  Java_Event_pOnSeekBarStopTrackingTouch(PEnv, this, TObject(pasobj), progress);
end;

const NativeMethods: array[0..95] of JNINativeMethod = (
    (name: 'pAppOnScreenStyle';
    signature: '()I';
    fnPtr: @pAppOnScreenStyle; ),
    (name: 'pAppOnCreate';
    signature: '(Landroid/content/Context;Landroid/widget/RelativeLayout;)V';
    fnPtr: @pAppOnCreate; ),
    (name: 'pAppOnNewIntent';
    signature: '()V';
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
    (name: 'pOnClick';
    signature: '(JI)V';
    fnPtr: @pOnClick; ),
    (name: 'pOnChange';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChange; ),
    (name: 'pOnChanged';
    signature: '(JLjava/lang/String;I)V';
    fnPtr: @pOnChanged; ),
    (name: 'pOnEnter';
    signature: '(J)V';
    fnPtr: @pOnEnter; ),
    (name: 'pOnTimer';
    signature: '(J)V';
    fnPtr: @pOnTimer; ),
    (name: 'pOnDraw';
    signature: '(JLandroid/graphics/Canvas;)V';
    fnPtr: @pOnDraw; ),
    (name: 'pOnTouch';
    signature: '(JIIFFFF)V';
    fnPtr: @pOnTouch; ),
    (name: 'pOnGLRenderer';
    signature: '(JIII)V';
    fnPtr: @pOnGLRenderer; ),
    (name: 'pOnClose';
    signature: '(J)V';
    fnPtr: @pOnClose; ),
    (name: 'pOnWebViewStatus';
    signature: '(JILjava/lang/String;)I';
    fnPtr: @pOnWebViewStatus; ),
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
    (name: 'pOnClickWidgetItem';
    signature: '(JIZ)V';
    fnPtr: @pOnClickWidgetItem; ),
    (name: 'pOnClickCaptionItem';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnClickCaptionItem; ),
    (name: 'pOnListViewLongClickCaptionItem';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnListViewLongClickCaptionItem; ),
    (name: 'pOnListViewDrawItemCaptionColor';
    signature: '(JILjava/lang/String;)I';
    fnPtr: @pOnListViewDrawItemCaptionColor; ),
    (name: 'pOnListViewDrawItemBitmap';
    signature: '(JILjava/lang/String;)Landroid/graphics/Bitmap;';
    fnPtr: @pOnListViewDrawItemBitmap; ),
    (name: 'pOnBluetoothEnabled';
    signature: '(J)V';
    fnPtr: @pOnBluetoothEnabled; ),
    (name: 'pOnBluetoothDisabled';
    signature: '(J)V';
    fnPtr: @pOnBluetoothDisabled; ),
    (name: 'pOnBluetoothDeviceFound';
    signature: '(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnBluetoothDeviceFound; ),
    (name: 'pOnBluetoothDiscoveryStarted';
    signature: '(J)V';
    fnPtr: @pOnBluetoothDiscoveryStarted; ),
    (name: 'pOnBluetoothDiscoveryFinished';
    signature: '(JII)V';
    fnPtr: @pOnBluetoothDiscoveryFinished; ),
    (name: 'pOnBluetoothDeviceBondStateChanged';
    signature: '(JILjava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnBluetoothDeviceBondStateChanged; ),
    (name: 'pOnBluetoothClientSocketConnected';
    signature: '(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnBluetoothClientSocketConnected; ),
    (name: 'pOnBluetoothClientSocketIncomingData';
    signature: '(J[B[B)V';
    fnPtr: @pOnBluetoothClientSocketIncomingData; ),
    (name: 'pOnBluetoothClientSocketDisconnected';
    signature: '(J)V';
    fnPtr: @pOnBluetoothClientSocketDisconnected; ),
    (name: 'pOnBluetoothServerSocketConnected';
    signature: '(JLjava/lang/String;Ljava/lang/String;)Z';
    fnPtr: @pOnBluetoothServerSocketConnected; ),
    (name: 'pOnBluetoothServerSocketIncomingData';
    signature: '(J[B[B)Z';
    fnPtr: @pOnBluetoothServerSocketIncomingData; ),
    (name: 'pOnBluetoothServerSocketListen';
    signature: '(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnBluetoothServerSocketListen; ),
    (name: 'pOnBluetoothServerSocketAcceptTimeout';
    signature: '(J)V';
    fnPtr: @pOnBluetoothServerSocketAcceptTimeout; ),
    (name: 'pOnSpinnerItemSeleceted';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnSpinnerItemSeleceted; ),
    (name: 'pOnLocationChanged';
    signature: '(JDDDLjava/lang/String;)V';
    fnPtr: @pOnLocationChanged; ),
    (name: 'pOnLocationStatusChanged';
    signature: '(JILjava/lang/String;Ljava/lang/String;)V';
    fnPtr: @pOnLocationStatusChanged; ),
    (name: 'pOnLocationProviderEnabled';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnLocationProviderEnabled; ),
    (name: 'pOnLocationProviderDisabled';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnLocationProviderDisabled; ),
    (name: 'pAppOnViewClick';
    signature: '(Landroid/view/View;I)V';
    fnPtr: @pAppOnViewClick; ),
    (name: 'pAppOnListItemClick';
    signature: '(Landroid/widget/AdapterView;Landroid/view/View;II)V';
    fnPtr: @pAppOnListItemClick; ),
    (name: 'pOnActionBarTabSelected';
    signature: '(JLandroid/view/View;Ljava/lang/String;)V';
    fnPtr: @pOnActionBarTabSelected; ),
    (name: 'pOnActionBarTabUnSelected';
    signature: '(JLandroid/view/View;Ljava/lang/String;)V';
    fnPtr: @pOnActionBarTabUnSelected; ),
    (name: 'pOnCustomDialogShow';
    signature: '(JLandroid/app/Dialog;Ljava/lang/String;)V';
    fnPtr: @pOnCustomDialogShow; ),
    (name: 'pOnCustomDialogBackKeyPressed';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnCustomDialogBackKeyPressed; ),
    (name: 'pOnClickToggleButton';
    signature: '(JZ)V';
    fnPtr: @pOnClickToggleButton; ),
    (name: 'pOnChangeSwitchButton';
    signature: '(JZ)V';
    fnPtr: @pOnChangeSwitchButton; ),
    (name: 'pOnClickGridItem';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnClickGridItem; ),
    (name: 'pOnLongClickGridItem';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnLongClickGridItem; ),
    (name: 'pOnGridDrawItemCaptionColor';
    signature: '(JILjava/lang/String;)I';
    fnPtr: @pOnGridDrawItemCaptionColor; ),
    (name: 'pOnGridDrawItemBitmap';
    signature: '(JILjava/lang/String;)Landroid/graphics/Bitmap;';
    fnPtr: @pOnGridDrawItemBitmap; ),
    (name: 'pOnChangedSensor';
    signature: '(JLandroid/hardware/Sensor;I[FJ)V';
    fnPtr: @pOnChangedSensor; ),
    (name: 'pOnListeningSensor';
    signature: '(JLandroid/hardware/Sensor;I)V';
    fnPtr: @pOnListeningSensor; ),
    (name: 'pOnUnregisterListeningSensor';
    signature: '(JILjava/lang/String;)V';
    fnPtr: @pOnUnregisterListeningSensor; ),
    (name: 'pOnBroadcastReceiver';
    signature: '(JLandroid/content/Intent;)V';
    fnPtr: @pOnBroadcastReceiver; ),
    (name: 'pOnTimePicker';
    signature: '(JII)V';
    fnPtr: @pOnTimePicker; ),
    (name: 'pOnDatePicker';
    signature: '(JIII)V';
    fnPtr: @pOnDatePicker; ),
    (name: 'pOnFlingGestureDetected';
    signature: '(JI)V';
    fnPtr: @pOnFlingGestureDetected; ),
    (name: 'pOnPinchZoomGestureDetected';
    signature: '(JFI)V';
    fnPtr: @pOnPinchZoomGestureDetected; ),
    (name: 'pOnShellCommandExecuted';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnShellCommandExecuted; ),
    (name: 'pOnTCPSocketClientMessageReceived';
    signature: '(J[Ljava/lang/String;)V';
    fnPtr: @pOnTCPSocketClientMessageReceived; ),
    (name: 'pOnTCPSocketClientConnected';
    signature: '(J)V';
    fnPtr: @pOnTCPSocketClientConnected; ),
    (name: 'pOnHttpClientContentResult';
    signature: '(JLjava/lang/String;)V';
    fnPtr: @pOnHttpClientContentResult; ),
    (name: 'pOnHttpClientCodeResult';
    signature: '(JI)V';
    fnPtr: @pOnHttpClientCodeResult; ),
    (name: 'pOnSurfaceViewCreated';
    signature: '(JLandroid/view/SurfaceHolder;)V';
    fnPtr: @pOnSurfaceViewCreated; ),
    (name: 'pOnSurfaceViewDraw';
    signature: '(JLandroid/graphics/Canvas;)V';
    fnPtr: @pOnSurfaceViewDraw; ),
    (name: 'pOnSurfaceViewChanged';
    signature: '(JII)V';
    fnPtr: @pOnSurfaceViewChanged; ),
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
    (name: 'pOnSurfaceViewTouch';
    signature: '(JIIFFFF)V';
    fnPtr: @pOnSurfaceViewTouch; ),
    (name: 'pOnSurfaceViewDrawingInBackground';
    signature: '(JF)Z';
    fnPtr: @pOnSurfaceViewDrawingInBackground; ),
    (name: 'pOnSurfaceViewDrawingPostExecute';
    signature: '(JF)V';
    fnPtr: @pOnSurfaceViewDrawingPostExecute; ),
    (name: 'pOnContactManagerContactsExecuted';
    signature: '(JI)V';
    fnPtr: @pOnContactManagerContactsExecuted; ),
    (name: 'pOnContactManagerContactsProgress';
    signature: '(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;'
      +'Landroid/graphics/Bitmap;I)Z';
    fnPtr: @pOnContactManagerContactsProgress; ),
    (name: 'pOnSeekBarProgressChanged';
    signature: '(JIZ)V';
    fnPtr: @pOnSeekBarProgressChanged; ),
    (name: 'pOnSeekBarStartTrackingTouch';
    signature: '(JI)V';
    fnPtr: @pOnSeekBarStartTrackingTouch; ),
    (name: 'pOnSeekBarStopTrackingTouch';
    signature: '(JI)V';
    fnPtr: @pOnSeekBarStopTrackingTouch; )
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
      RegisterNativeMethods(curEnv, 'com/example/apptfpnoguigraphicsbridgedemo4'
        +'/Controls');
  end;
  gVM:= VM; {AndroidWidget.pas}
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
  pAppOnScreenStyle name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pAppOnScreenStyle',
  pAppOnCreate name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pAppOnCreate',
  pAppOnNewIntent name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls'
    +'_pAppOnDestroy',
  pAppOnPause name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pAppOnPause',
  pAppOnRestart name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls'
    +'_pAppOnRestart',
  pAppOnResume name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pAppOnResume',
  pAppOnStart name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pAppOnStart',
  pAppOnStop name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pAppOnStop',
  pAppOnBackPressed name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pAppOnRotate',
  pAppOnConfigurationChanged name 'Java_com_example_apptfpnoguigraphicsbridgede'
    +'mo4_Controls_pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_com_example_apptfpnoguigraphicsbridgedem'
    +'o4_Controls_pAppOnClickOptionMenuItem',
  pAppOnPrepareOptionsMenu name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pAppOnPrepareOptionsMenu',
  pAppOnPrepareOptionsMenuItem name 'Java_com_example_apptfpnoguigraphicsbridge'
    +'demo4_Controls_pAppOnPrepareOptionsMenuItem',
  pAppOnCreateContextMenu name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_com_example_apptfpnoguigraphicsbridgede'
    +'mo4_Controls_pAppOnClickContextMenuItem',
  pOnClick name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnClick',
  pOnChange name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnChange',
  pOnChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnChanged',
  pOnEnter name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnEnter',
  pOnTimer name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnTimer',
  pOnDraw name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnDraw',
  pOnTouch name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnTouch',
  pOnGLRenderer name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls'
    +'_pOnGLRenderer',
  pOnClose name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnClose',
  pOnWebViewStatus name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnWebViewStatus',
  pOnAsyncEventDoInBackground name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnAsyncEventDoInBackground',
  pOnAsyncEventProgressUpdate name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnAsyncEventProgressUpdate',
  pOnAsyncEventPreExecute name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnAsyncEventPreExecute',
  pOnAsyncEventPostExecute name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnAsyncEventPostExecute',
  pOnClickWidgetItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnClickWidgetItem',
  pOnClickCaptionItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnClickCaptionItem',
  pOnListViewLongClickCaptionItem name 'Java_com_example_apptfpnoguigraphicsbri'
    +'dgedemo4_Controls_pOnListViewLongClickCaptionItem',
  pOnListViewDrawItemCaptionColor name 'Java_com_example_apptfpnoguigraphicsbri'
    +'dgedemo4_Controls_pOnListViewDrawItemCaptionColor',
  pOnListViewDrawItemBitmap name 'Java_com_example_apptfpnoguigraphicsbridgedem'
    +'o4_Controls_pOnListViewDrawItemBitmap',
  pOnBluetoothEnabled name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnBluetoothEnabled',
  pOnBluetoothDisabled name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnBluetoothDisabled',
  pOnBluetoothDeviceFound name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnBluetoothDeviceFound',
  pOnBluetoothDiscoveryStarted name 'Java_com_example_apptfpnoguigraphicsbridge'
    +'demo4_Controls_pOnBluetoothDiscoveryStarted',
  pOnBluetoothDiscoveryFinished name 'Java_com_example_apptfpnoguigraphicsbridg'
    +'edemo4_Controls_pOnBluetoothDiscoveryFinished',
  pOnBluetoothDeviceBondStateChanged name 'Java_com_example_apptfpnoguigraphics'
    +'bridgedemo4_Controls_pOnBluetoothDeviceBondStateChanged',
  pOnBluetoothClientSocketConnected name 'Java_com_example_apptfpnoguigraphicsb'
    +'ridgedemo4_Controls_pOnBluetoothClientSocketConnected',
  pOnBluetoothClientSocketIncomingData name 'Java_com_example_'
    +'apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnBluetoothClientSocketIncomingData',
  pOnBluetoothClientSocketDisconnected name 'Java_com_example_'
    +'apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnBluetoothClientSocketDisconnected',
  pOnBluetoothServerSocketConnected name 'Java_com_example_apptfpnoguigraphicsb'
    +'ridgedemo4_Controls_pOnBluetoothServerSocketConnected',
  pOnBluetoothServerSocketIncomingData name 'Java_com_example_'
    +'apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnBluetoothServerSocketIncomingData',
  pOnBluetoothServerSocketListen name 'Java_com_example_apptfpnoguigraphicsbrid'
    +'gedemo4_Controls_pOnBluetoothServerSocketListen',
  pOnBluetoothServerSocketAcceptTimeout name 'Java_com_example_'
    +'apptfpnoguigraphicsbridgedemo4_Controls_'
    +'pOnBluetoothServerSocketAcceptTimeout',
  pOnSpinnerItemSeleceted name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnSpinnerItemSeleceted',
  pOnLocationChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnLocationChanged',
  pOnLocationStatusChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnLocationStatusChanged',
  pOnLocationProviderEnabled name 'Java_com_example_apptfpnoguigraphicsbridgede'
    +'mo4_Controls_pOnLocationProviderEnabled',
  pOnLocationProviderDisabled name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnLocationProviderDisabled',
  pAppOnViewClick name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pAppOnViewClick',
  pAppOnListItemClick name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pAppOnListItemClick',
  pOnActionBarTabSelected name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnActionBarTabSelected',
  pOnActionBarTabUnSelected name 'Java_com_example_apptfpnoguigraphicsbridgedem'
    +'o4_Controls_pOnActionBarTabUnSelected',
  pOnCustomDialogShow name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnCustomDialogShow',
  pOnCustomDialogBackKeyPressed name 'Java_com_example_apptfpnoguigraphicsbridg'
    +'edemo4_Controls_pOnCustomDialogBackKeyPressed',
  pOnClickToggleButton name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnClickToggleButton',
  pOnChangeSwitchButton name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnChangeSwitchButton',
  pOnClickGridItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnClickGridItem',
  pOnLongClickGridItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnLongClickGridItem',
  pOnGridDrawItemCaptionColor name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnGridDrawItemCaptionColor',
  pOnGridDrawItemBitmap name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnGridDrawItemBitmap',
  pOnChangedSensor name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnChangedSensor',
  pOnListeningSensor name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnListeningSensor',
  pOnUnregisterListeningSensor name 'Java_com_example_apptfpnoguigraphicsbridge'
    +'demo4_Controls_pOnUnregisterListeningSensor',
  pOnBroadcastReceiver name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnBroadcastReceiver',
  pOnTimePicker name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls'
    +'_pOnTimePicker',
  pOnDatePicker name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_Controls'
    +'_pOnDatePicker',
  pOnFlingGestureDetected name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnPinchZoomGestureDetected',
  pOnShellCommandExecuted name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnShellCommandExecuted',
  pOnTCPSocketClientMessageReceived name 'Java_com_example_apptfpnoguigraphicsb'
    +'ridgedemo4_Controls_pOnTCPSocketClientMessageReceived',
  pOnTCPSocketClientConnected name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnTCPSocketClientConnected',
  pOnHttpClientContentResult name 'Java_com_example_apptfpnoguigraphicsbridgede'
    +'mo4_Controls_pOnHttpClientContentResult',
  pOnHttpClientCodeResult name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnHttpClientCodeResult',
  pOnSurfaceViewCreated name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnSurfaceViewCreated',
  pOnSurfaceViewDraw name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnSurfaceViewDraw',
  pOnSurfaceViewChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnSurfaceViewChanged',
  pOnMediaPlayerPrepared name 'Java_com_example_apptfpnoguigraphicsbridgedemo4'
    +'_Controls_pOnMediaPlayerPrepared',
  pOnMediaPlayerVideoSizeChanged name 'Java_com_example_apptfpnoguigraphicsbrid'
    +'gedemo4_Controls_pOnMediaPlayerVideoSizeChanged',
  pOnMediaPlayerCompletion name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnMediaPlayerCompletion',
  pOnMediaPlayerTimedText name 'Java_com_example_apptfpnoguigraphicsbridgedemo'
    +'4_Controls_pOnMediaPlayerTimedText',
  pOnSurfaceViewTouch name 'Java_com_example_apptfpnoguigraphicsbridgedemo4_'
    +'Controls_pOnSurfaceViewTouch',
  pOnSurfaceViewDrawingInBackground name 'Java_com_example_apptfpnoguigraphicsb'
    +'ridgedemo4_Controls_pOnSurfaceViewDrawingInBackground',
  pOnSurfaceViewDrawingPostExecute name 'Java_com_example_apptfpnoguigraphicsbr'
    +'idgedemo4_Controls_pOnSurfaceViewDrawingPostExecute',
  pOnContactManagerContactsExecuted name 'Java_com_example_apptfpnoguigraphicsb'
    +'ridgedemo4_Controls_pOnContactManagerContactsExecuted',
  pOnContactManagerContactsProgress name 'Java_com_example_apptfpnoguigraphicsb'
    +'ridgedemo4_Controls_pOnContactManagerContactsProgress',
  pOnSeekBarProgressChanged name 'Java_com_example_apptfpnoguigraphicsbridgedem'
    +'o4_Controls_pOnSeekBarProgressChanged',
  pOnSeekBarStartTrackingTouch name 'Java_com_example_apptfpnoguigraphicsbridge'
    +'demo4_Controls_pOnSeekBarStartTrackingTouch',
  pOnSeekBarStopTrackingTouch name 'Java_com_example_apptfpnoguigraphicsbridged'
    +'emo4_Controls_pOnSeekBarStopTrackingTouch';

  
begin
  gApp:= jApp.Create(nil);
  gApp.Title:= 'JNI Android Bridges Library';
  gjAppName:= 'com.example.apptfpnoguigraphicsbridgedemo4';
  gjClassName:= 'com/example/apptfpnoguigraphicsbridgedemo4/Controls';
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TAndroidModule1, AndroidModule1);
end.
