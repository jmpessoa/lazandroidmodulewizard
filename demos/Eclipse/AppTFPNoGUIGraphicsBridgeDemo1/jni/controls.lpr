{hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo1\jni\ }
library controls;  //[by LazAndroidWizard: 4/17/2015 20:31:10]

{$mode delphi}

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,
  Laz_And_Controls_Events, unit1;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnScreenStyle
  Signature: ()I }
function pAppOnScreenStyle(PEnv: PJNIEnv; this: JObject): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnScreenStyle(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnCreate
  Signature: (Landroid/content/Context;Landroid/widget/RelativeLayout;)V }
procedure pAppOnCreate(PEnv: PJNIEnv; this: JObject; context: JObject; layout: JObject); cdecl;
begin
  gApp.Init(PEnv,this,context,layout);AndroidModule1.Init(gApp);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnNewIntent
  Signature: ()V }
procedure pAppOnNewIntent(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnNewIntent(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnDestroy
  Signature: ()V }
procedure pAppOnDestroy(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnDestroy(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnPause
  Signature: ()V }
procedure pAppOnPause(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnPause(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnRestart
  Signature: ()V }
procedure pAppOnRestart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnRestart(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnResume
  Signature: ()V }
procedure pAppOnResume(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnResume(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnStart
  Signature: ()V }
procedure pAppOnStart(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStart(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnStop
  Signature: ()V }
procedure pAppOnStop(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnStop(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnBackPressed
  Signature: ()V }
procedure pAppOnBackPressed(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnBackPressed(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnRotate
  Signature: (I)I }
function pAppOnRotate(PEnv: PJNIEnv; this: JObject; rotate: JInt): JInt; cdecl;
begin
  Result:=Java_Event_pAppOnRotate(PEnv,this,rotate);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnConfigurationChanged
  Signature: ()V }
procedure pAppOnConfigurationChanged(PEnv: PJNIEnv; this: JObject); cdecl;
begin
  Java_Event_pAppOnConfigurationChanged(PEnv,this);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnActivityResult
  Signature: (IILandroid/content/Intent;)V }
procedure pAppOnActivityResult(PEnv: PJNIEnv; this: JObject; requestCode: JInt; resultCode: JInt; data: JObject); cdecl;
begin
  Java_Event_pAppOnActivityResult(PEnv,this,requestCode,resultCode,data);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnCreateOptionsMenu
  Signature: (Landroid/view/Menu;)V }
procedure pAppOnCreateOptionsMenu(PEnv: PJNIEnv; this: JObject; menu: JObject); cdecl;
begin
  Java_Event_pAppOnCreateOptionsMenu(PEnv,this,menu);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnClickOptionMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickOptionMenuItem(PEnv: PJNIEnv; this: JObject; menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean); cdecl;
begin
  Java_Event_pAppOnClickOptionMenuItem(PEnv,this,menuItem,itemID,itemCaption,Boolean(checked));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnCreateContextMenu
  Signature: (Landroid/view/ContextMenu;)V }
procedure pAppOnCreateContextMenu(PEnv: PJNIEnv; this: JObject; menu: JObject); cdecl;
begin
  Java_Event_pAppOnCreateContextMenu(PEnv,this,menu);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnClickContextMenuItem
  Signature: (Landroid/view/MenuItem;ILjava/lang/String;Z)V }
procedure pAppOnClickContextMenuItem(PEnv: PJNIEnv; this: JObject; menuItem: JObject; itemID: JInt; itemCaption: JString; checked: JBoolean); cdecl;
begin
  Java_Event_pAppOnClickContextMenuItem(PEnv,this,menuItem,itemID,itemCaption,Boolean(checked));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnClick
  Signature: (JI)V }
procedure pOnClick(PEnv: PJNIEnv; this: JObject; pasobj: JLong; value: JInt); cdecl;
begin
  Java_Event_pOnClick(PEnv,this,TObject(pasobj),value);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnChange
  Signature: (JLjava/lang/String;I)V }
procedure pOnChange(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString; count: JInt); cdecl;
begin
  Java_Event_pOnChange(PEnv,this,TObject(pasobj),txt,count);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnChanged
  Signature: (JLjava/lang/String;I)V }
procedure pOnChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; txt: JString; count: JInt); cdecl;
begin
  Java_Event_pOnChanged(PEnv,this,TObject(pasobj),txt,count);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnEnter
  Signature: (J)V }
procedure pOnEnter(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnEnter(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnTimer
  Signature: (J)V }
procedure pOnTimer(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnTimer(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnDraw
  Signature: (JLandroid/graphics/Canvas;)V }
procedure pOnDraw(PEnv: PJNIEnv; this: JObject; pasobj: JLong; canvas: JObject); cdecl;
begin
  Java_Event_pOnDraw(PEnv,this,TObject(pasobj),canvas);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnTouch
  Signature: (JIIFFFF)V }
procedure pOnTouch(PEnv: PJNIEnv; this: JObject; pasobj: JLong; act: JInt; cnt: JInt; x1: JFloat; y1: JFloat; x2: JFloat; y2: JFloat); cdecl;
begin
  Java_Event_pOnTouch(PEnv,this,TObject(pasobj),act,cnt,x1,y1,x2,y2);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnGLRenderer
  Signature: (JIII)V }
procedure pOnGLRenderer(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt; w: JInt; h: JInt); cdecl;
begin
  Java_Event_pOnGLRenderer(PEnv,this,TObject(pasobj),EventType,w,h);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnClose
  Signature: (J)V }
procedure pOnClose(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnClose(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnWebViewStatus
  Signature: (JILjava/lang/String;)I }
function pOnWebViewStatus(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt; url: JString): JInt; cdecl;
begin
  Result:=Java_Event_pOnWebViewStatus(PEnv,this,TObject(pasobj),EventType,url);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnAsyncEvent
  Signature: (JII)V }
procedure pOnAsyncEvent(PEnv: PJNIEnv; this: JObject; pasobj: JLong; EventType: JInt; progress: JInt); cdecl;
begin
  Java_Event_pOnAsyncEvent(PEnv,this,TObject(pasobj),EventType,progress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnClickWidgetItem
  Signature: (JIZ)V }
procedure pOnClickWidgetItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; position: JInt; checked: JBoolean); cdecl;
begin
  Java_Event_pOnClickWidgetItem(PEnv,this,TObject(pasobj),position,Boolean(checked));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnClickCaptionItem
  Signature: (JILjava/lang/String;)V }
procedure pOnClickCaptionItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickCaptionItem(PEnv,this,TObject(pasobj),position,caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothEnabled
  Signature: (J)V }
procedure pOnBluetoothEnabled(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothEnabled(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothDisabled
  Signature: (J)V }
procedure pOnBluetoothDisabled(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothDisabled(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothDeviceFound
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothDeviceFound(PEnv: PJNIEnv; this: JObject; pasobj: JLong; deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothDeviceFound(PEnv,this,TObject(pasobj),deviceName,deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothDiscoveryStarted
  Signature: (J)V }
procedure pOnBluetoothDiscoveryStarted(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothDiscoveryStarted(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothDiscoveryFinished
  Signature: (JII)V }
procedure pOnBluetoothDiscoveryFinished(PEnv: PJNIEnv; this: JObject; pasobj: JLong; countFoundedDevices: JInt; countPairedDevices: JInt); cdecl;
begin
  Java_Event_pOnBluetoothDiscoveryFinished(PEnv,this,TObject(pasobj),countFoundedDevices,countPairedDevices);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothDeviceBondStateChanged
  Signature: (JILjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothDeviceBondStateChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; state: JInt; deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothDeviceBondStateChanged(PEnv,this,TObject(pasobj),state,deviceName,deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothClientSocketConnected
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothClientSocketConnected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothClientSocketConnected(PEnv,this,TObject(pasobj),deviceName,deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothClientSocketIncomingMessage
  Signature: (JLjava/lang/String;)V }
procedure pOnBluetoothClientSocketIncomingMessage(PEnv: PJNIEnv; this: JObject; pasobj: JLong; messageText: JString); cdecl;
begin
  Java_Event_pOnBluetoothClientSocketIncomingMessage(PEnv,this,TObject(pasobj),messageText);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothClientSocketWritingMessage
  Signature: (J)V }
procedure pOnBluetoothClientSocketWritingMessage(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothClientSocketWritingMessage(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothServerSocketConnected
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothServerSocketConnected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothServerSocketConnected(PEnv,this,TObject(pasobj),deviceName,deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothServerSocketIncomingMessage
  Signature: (JLjava/lang/String;)V }
procedure pOnBluetoothServerSocketIncomingMessage(PEnv: PJNIEnv; this: JObject; pasobj: JLong; messageText: JString); cdecl;
begin
  Java_Event_pOnBluetoothServerSocketIncomingMessage(PEnv,this,TObject(pasobj),messageText);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothServerSocketWritingMessage
  Signature: (J)V }
procedure pOnBluetoothServerSocketWritingMessage(PEnv: PJNIEnv; this: JObject; pasobj: JLong); cdecl;
begin
  Java_Event_pOnBluetoothServerSocketWritingMessage(PEnv,this,TObject(pasobj));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBluetoothServerSocketListen
  Signature: (JLjava/lang/String;Ljava/lang/String;)V }
procedure pOnBluetoothServerSocketListen(PEnv: PJNIEnv; this: JObject; pasobj: JLong; deviceName: JString; deviceAddress: JString); cdecl;
begin
  Java_Event_pOnBluetoothServerSocketListen(PEnv,this,TObject(pasobj),deviceName,deviceAddress);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnSpinnerItemSeleceted
  Signature: (JILjava/lang/String;)V }
procedure pOnSpinnerItemSeleceted(PEnv: PJNIEnv; this: JObject; pasobj: JLong; position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnSpinnerItemSeleceted(PEnv,this,TObject(pasobj),position,caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnLocationChanged
  Signature: (JDDDLjava/lang/String;)V }
procedure pOnLocationChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; latitude: JDouble; longitude: JDouble; altitude: JDouble; address: JString); cdecl;
begin
  Java_Event_pOnLocationChanged(PEnv,this,TObject(pasobj),latitude,longitude,altitude,address);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnLocationStatusChanged
  Signature: (JILjava/lang/String;Ljava/lang/String;)V }
procedure pOnLocationStatusChanged(PEnv: PJNIEnv; this: JObject; pasobj: JLong; status: JInt; provider: JString; msgStatus: JString); cdecl;
begin
  Java_Event_pOnLocationStatusChanged(PEnv,this,TObject(pasobj),status,provider,msgStatus);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnLocationProviderEnabled
  Signature: (JLjava/lang/String;)V }
procedure pOnLocationProviderEnabled(PEnv: PJNIEnv; this: JObject; pasobj: JLong; provider: JString); cdecl;
begin
  Java_Event_pOnLocationProviderEnabled(PEnv,this,TObject(pasobj),provider);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnLocationProviderDisabled
  Signature: (JLjava/lang/String;)V }
procedure pOnLocationProviderDisabled(PEnv: PJNIEnv; this: JObject; pasobj: JLong; provider: JString); cdecl;
begin
  Java_Event_pOnLocationProviderDisabled(PEnv,this,TObject(pasobj),provider);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnViewClick
  Signature: (Landroid/view/View;I)V }
procedure pAppOnViewClick(PEnv: PJNIEnv; this: JObject; view: JObject; id: JInt); cdecl;
begin
  Java_Event_pAppOnViewClick(PEnv,this,view,id);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pAppOnListItemClick
  Signature: (Landroid/widget/AdapterView;Landroid/view/View;II)V }
procedure pAppOnListItemClick(PEnv: PJNIEnv; this: JObject; adapter: JObject; view: JObject; position: JInt; id: JInt); cdecl;
begin
  Java_Event_pAppOnListItemClick(PEnv,this,adapter,view,position,id);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnActionBarTabSelected
  Signature: (JLandroid/view/View;Ljava/lang/String;)V }
procedure pOnActionBarTabSelected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; view: JObject; title: JString); cdecl;
begin
  Java_Event_pOnActionBarTabSelected(PEnv,this,TObject(pasobj),view,title);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnActionBarTabUnSelected
  Signature: (JLandroid/view/View;Ljava/lang/String;)V }
procedure pOnActionBarTabUnSelected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; view: JObject; title: JString); cdecl;
begin
  Java_Event_pOnActionBarTabUnSelected(PEnv,this,TObject(pasobj),view,title);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnCustomDialogShow
  Signature: (JLandroid/app/Dialog;Ljava/lang/String;)V }
procedure pOnCustomDialogShow(PEnv: PJNIEnv; this: JObject; pasobj: JLong; dialog: JObject; title: JString); cdecl;
begin
  Java_Event_pOnCustomDialogShow(PEnv,this,TObject(pasobj),dialog,title);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnClickToggleButton
  Signature: (JZ)V }
procedure pOnClickToggleButton(PEnv: PJNIEnv; this: JObject; pasobj: JLong; state: JBoolean); cdecl;
begin
  Java_Event_pOnClickToggleButton(PEnv,this,TObject(pasobj),Boolean(state));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnChangeSwitchButton
  Signature: (JZ)V }
procedure pOnChangeSwitchButton(PEnv: PJNIEnv; this: JObject; pasobj: JLong; state: JBoolean); cdecl;
begin
  Java_Event_pOnChangeSwitchButton(PEnv,this,TObject(pasobj),Boolean(state));
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnClickGridItem
  Signature: (JILjava/lang/String;)V }
procedure pOnClickGridItem(PEnv: PJNIEnv; this: JObject; pasobj: JLong; position: JInt; caption: JString); cdecl;
begin
  Java_Event_pOnClickGridItem(PEnv,this,TObject(pasobj),position,caption);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnChangedSensor
  Signature: (JLandroid/hardware/Sensor;I[FJ)V }
procedure pOnChangedSensor(PEnv: PJNIEnv; this: JObject; pasobj: JLong; sensor: JObject; sensorType: JInt; values: JFloatArray; timestamp: JLong); cdecl;
begin
  Java_Event_pOnChangedSensor(PEnv,this,TObject(pasobj),sensor,sensorType,values,timestamp);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnListeningSensor
  Signature: (JLandroid/hardware/Sensor;I)V }
procedure pOnListeningSensor(PEnv: PJNIEnv; this: JObject; pasobj: JLong; sensor: JObject; sensorType: JInt); cdecl;
begin
  Java_Event_pOnListeningSensor(PEnv,this,TObject(pasobj),sensor,sensorType);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnUnregisterListeningSensor
  Signature: (JILjava/lang/String;)V }
procedure pOnUnregisterListeningSensor(PEnv: PJNIEnv; this: JObject; pasobj: JLong; sensorType: JInt; sensorName: JString); cdecl;
begin
  Java_Event_pOnUnregisterListeningSensor(PEnv,this,TObject(pasobj),sensorType,sensorName);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnBroadcastReceiver
  Signature: (JLandroid/content/Intent;)V }
procedure pOnBroadcastReceiver(PEnv: PJNIEnv; this: JObject; pasobj: JLong; intent: JObject); cdecl;
begin
  Java_Event_pOnBroadcastReceiver(PEnv,this,TObject(pasobj),intent);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnTimePicker
  Signature: (JII)V }
procedure pOnTimePicker(PEnv: PJNIEnv; this: JObject; pasobj: JLong; hourOfDay: JInt; minute: JInt); cdecl;
begin
  Java_Event_pOnTimePicker(PEnv,this,TObject(pasobj),hourOfDay,minute);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnDatePicker
  Signature: (JIII)V }
procedure pOnDatePicker(PEnv: PJNIEnv; this: JObject; pasobj: JLong; year: JInt; monthOfYear: JInt; dayOfMonth: JInt); cdecl;
begin
  Java_Event_pOnDatePicker(PEnv,this,TObject(pasobj),year,monthOfYear,dayOfMonth);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnFlingGestureDetected
  Signature: (JI)V }
procedure pOnFlingGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; direction: JInt); cdecl;
begin
  Java_Event_pOnFlingGestureDetected(PEnv,this,TObject(pasobj),direction);
end;

{ Class:     com_example_apptfpnoguigraphicsbridgedemo1_Controls
  Method:    pOnPinchZoomGestureDetected
  Signature: (JFI)V }
procedure pOnPinchZoomGestureDetected(PEnv: PJNIEnv; this: JObject; pasobj: JLong; scaleFactor: JFloat; state: JInt); cdecl;
begin
  Java_Event_pOnPinchZoomGestureDetected(PEnv,this,TObject(pasobj),scaleFactor,state);
end;

const NativeMethods:array[0..63] of JNINativeMethod = (
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
    (name:'pAppOnCreateOptionsMenu';
    signature:'(Landroid/view/Menu;)V';
    fnPtr:@pAppOnCreateOptionsMenu;),
    (name:'pAppOnClickOptionMenuItem';
    signature:'(Landroid/view/MenuItem;ILjava/lang/String;Z)V';
    fnPtr:@pAppOnClickOptionMenuItem;),
    (name:'pAppOnCreateContextMenu';
    signature:'(Landroid/view/ContextMenu;)V';
    fnPtr:@pAppOnCreateContextMenu;),
    (name:'pAppOnClickContextMenuItem';
    signature:'(Landroid/view/MenuItem;ILjava/lang/String;Z)V';
    fnPtr:@pAppOnClickContextMenuItem;),
    (name:'pOnClick';
    signature:'(JI)V';
    fnPtr:@pOnClick;),
    (name:'pOnChange';
    signature:'(JLjava/lang/String;I)V';
    fnPtr:@pOnChange;),
    (name:'pOnChanged';
    signature:'(JLjava/lang/String;I)V';
    fnPtr:@pOnChanged;),
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
    (name:'pOnWebViewStatus';
    signature:'(JILjava/lang/String;)I';
    fnPtr:@pOnWebViewStatus;),
    (name:'pOnAsyncEvent';
    signature:'(JII)V';
    fnPtr:@pOnAsyncEvent;),
    (name:'pOnClickWidgetItem';
    signature:'(JIZ)V';
    fnPtr:@pOnClickWidgetItem;),
    (name:'pOnClickCaptionItem';
    signature:'(JILjava/lang/String;)V';
    fnPtr:@pOnClickCaptionItem;),
    (name:'pOnBluetoothEnabled';
    signature:'(J)V';
    fnPtr:@pOnBluetoothEnabled;),
    (name:'pOnBluetoothDisabled';
    signature:'(J)V';
    fnPtr:@pOnBluetoothDisabled;),
    (name:'pOnBluetoothDeviceFound';
    signature:'(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr:@pOnBluetoothDeviceFound;),
    (name:'pOnBluetoothDiscoveryStarted';
    signature:'(J)V';
    fnPtr:@pOnBluetoothDiscoveryStarted;),
    (name:'pOnBluetoothDiscoveryFinished';
    signature:'(JII)V';
    fnPtr:@pOnBluetoothDiscoveryFinished;),
    (name:'pOnBluetoothDeviceBondStateChanged';
    signature:'(JILjava/lang/String;Ljava/lang/String;)V';
    fnPtr:@pOnBluetoothDeviceBondStateChanged;),
    (name:'pOnBluetoothClientSocketConnected';
    signature:'(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr:@pOnBluetoothClientSocketConnected;),
    (name:'pOnBluetoothClientSocketIncomingMessage';
    signature:'(JLjava/lang/String;)V';
    fnPtr:@pOnBluetoothClientSocketIncomingMessage;),
    (name:'pOnBluetoothClientSocketWritingMessage';
    signature:'(J)V';
    fnPtr:@pOnBluetoothClientSocketWritingMessage;),
    (name:'pOnBluetoothServerSocketConnected';
    signature:'(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr:@pOnBluetoothServerSocketConnected;),
    (name:'pOnBluetoothServerSocketIncomingMessage';
    signature:'(JLjava/lang/String;)V';
    fnPtr:@pOnBluetoothServerSocketIncomingMessage;),
    (name:'pOnBluetoothServerSocketWritingMessage';
    signature:'(J)V';
    fnPtr:@pOnBluetoothServerSocketWritingMessage;),
    (name:'pOnBluetoothServerSocketListen';
    signature:'(JLjava/lang/String;Ljava/lang/String;)V';
    fnPtr:@pOnBluetoothServerSocketListen;),
    (name:'pOnSpinnerItemSeleceted';
    signature:'(JILjava/lang/String;)V';
    fnPtr:@pOnSpinnerItemSeleceted;),
    (name:'pOnLocationChanged';
    signature:'(JDDDLjava/lang/String;)V';
    fnPtr:@pOnLocationChanged;),
    (name:'pOnLocationStatusChanged';
    signature:'(JILjava/lang/String;Ljava/lang/String;)V';
    fnPtr:@pOnLocationStatusChanged;),
    (name:'pOnLocationProviderEnabled';
    signature:'(JLjava/lang/String;)V';
    fnPtr:@pOnLocationProviderEnabled;),
    (name:'pOnLocationProviderDisabled';
    signature:'(JLjava/lang/String;)V';
    fnPtr:@pOnLocationProviderDisabled;),
    (name:'pAppOnViewClick';
    signature:'(Landroid/view/View;I)V';
    fnPtr:@pAppOnViewClick;),
    (name:'pAppOnListItemClick';
    signature:'(Landroid/widget/AdapterView;Landroid/view/View;II)V';
    fnPtr:@pAppOnListItemClick;),
    (name:'pOnActionBarTabSelected';
    signature:'(JLandroid/view/View;Ljava/lang/String;)V';
    fnPtr:@pOnActionBarTabSelected;),
    (name:'pOnActionBarTabUnSelected';
    signature:'(JLandroid/view/View;Ljava/lang/String;)V';
    fnPtr:@pOnActionBarTabUnSelected;),
    (name:'pOnCustomDialogShow';
    signature:'(JLandroid/app/Dialog;Ljava/lang/String;)V';
    fnPtr:@pOnCustomDialogShow;),
    (name:'pOnClickToggleButton';
    signature:'(JZ)V';
    fnPtr:@pOnClickToggleButton;),
    (name:'pOnChangeSwitchButton';
    signature:'(JZ)V';
    fnPtr:@pOnChangeSwitchButton;),
    (name:'pOnClickGridItem';
    signature:'(JILjava/lang/String;)V';
    fnPtr:@pOnClickGridItem;),
    (name:'pOnChangedSensor';
    signature:'(JLandroid/hardware/Sensor;I[FJ)V';
    fnPtr:@pOnChangedSensor;),
    (name:'pOnListeningSensor';
    signature:'(JLandroid/hardware/Sensor;I)V';
    fnPtr:@pOnListeningSensor;),
    (name:'pOnUnregisterListeningSensor';
    signature:'(JILjava/lang/String;)V';
    fnPtr:@pOnUnregisterListeningSensor;),
    (name:'pOnBroadcastReceiver';
    signature:'(JLandroid/content/Intent;)V';
    fnPtr:@pOnBroadcastReceiver;),
    (name:'pOnTimePicker';
    signature:'(JII)V';
    fnPtr:@pOnTimePicker;),
    (name:'pOnDatePicker';
    signature:'(JIII)V';
    fnPtr:@pOnDatePicker;),
    (name:'pOnFlingGestureDetected';
    signature:'(JI)V';
    fnPtr:@pOnFlingGestureDetected;),
    (name:'pOnPinchZoomGestureDetected';
    signature:'(JFI)V';
    fnPtr:@pOnPinchZoomGestureDetected;)
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
      RegisterNativeMethods(curEnv, 'com/example/apptfpnoguigraphicsbridgedemo1/Controls');
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
    (curEnv^).DeleteGlobalRef(curEnv, gjClass);
    gjClass:= nil;
    gVM:= nil;
  end;
  gApp.Terminate;
  FreeAndNil(gApp);
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload',
  pAppOnScreenStyle name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnScreenStyle',
  pAppOnCreate name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnCreate',
  pAppOnNewIntent name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnNewIntent',
  pAppOnDestroy name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnDestroy',
  pAppOnPause name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnPause',
  pAppOnRestart name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnRestart',
  pAppOnResume name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnResume',
  pAppOnStart name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnStart',
  pAppOnStop name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnStop',
  pAppOnBackPressed name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnBackPressed',
  pAppOnRotate name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnRotate',
  pAppOnConfigurationChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnConfigurationChanged',
  pAppOnActivityResult name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnActivityResult',
  pAppOnCreateOptionsMenu name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnCreateOptionsMenu',
  pAppOnClickOptionMenuItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnClickOptionMenuItem',
  pAppOnCreateContextMenu name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnCreateContextMenu',
  pAppOnClickContextMenuItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnClickContextMenuItem',
  pOnClick name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnClick',
  pOnChange name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnChange',
  pOnChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnChanged',
  pOnEnter name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnEnter',
  pOnTimer name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnTimer',
  pOnDraw name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnDraw',
  pOnTouch name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnTouch',
  pOnGLRenderer name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnGLRenderer',
  pOnClose name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnClose',
  pOnWebViewStatus name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnWebViewStatus',
  pOnAsyncEvent name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnAsyncEvent',
  pOnClickWidgetItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnClickWidgetItem',
  pOnClickCaptionItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnClickCaptionItem',
  pOnBluetoothEnabled name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothEnabled',
  pOnBluetoothDisabled name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothDisabled',
  pOnBluetoothDeviceFound name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothDeviceFound',
  pOnBluetoothDiscoveryStarted name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothDiscoveryStarted',
  pOnBluetoothDiscoveryFinished name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothDiscoveryFinished',
  pOnBluetoothDeviceBondStateChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothDeviceBondStateChanged',
  pOnBluetoothClientSocketConnected name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothClientSocketConnected',
  pOnBluetoothClientSocketIncomingMessage name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothClientSocketIncomingMessage',
  pOnBluetoothClientSocketWritingMessage name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothClientSocketWritingMessage',
  pOnBluetoothServerSocketConnected name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothServerSocketConnected',
  pOnBluetoothServerSocketIncomingMessage name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothServerSocketIncomingMessage',
  pOnBluetoothServerSocketWritingMessage name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothServerSocketWritingMessage',
  pOnBluetoothServerSocketListen name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBluetoothServerSocketListen',
  pOnSpinnerItemSeleceted name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnSpinnerItemSeleceted',
  pOnLocationChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnLocationChanged',
  pOnLocationStatusChanged name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnLocationStatusChanged',
  pOnLocationProviderEnabled name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnLocationProviderEnabled',
  pOnLocationProviderDisabled name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnLocationProviderDisabled',
  pAppOnViewClick name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnViewClick',
  pAppOnListItemClick name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pAppOnListItemClick',
  pOnActionBarTabSelected name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnActionBarTabSelected',
  pOnActionBarTabUnSelected name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnActionBarTabUnSelected',
  pOnCustomDialogShow name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnCustomDialogShow',
  pOnClickToggleButton name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnClickToggleButton',
  pOnChangeSwitchButton name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnChangeSwitchButton',
  pOnClickGridItem name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnClickGridItem',
  pOnChangedSensor name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnChangedSensor',
  pOnListeningSensor name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnListeningSensor',
  pOnUnregisterListeningSensor name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnUnregisterListeningSensor',
  pOnBroadcastReceiver name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnBroadcastReceiver',
  pOnTimePicker name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnTimePicker',
  pOnDatePicker name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnDatePicker',
  pOnFlingGestureDetected name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnFlingGestureDetected',
  pOnPinchZoomGestureDetected name 'Java_com_example_apptfpnoguigraphicsbridgedemo1_Controls_pOnPinchZoomGestureDetected';

begin
  gApp:= jApp.Create(nil);
  gApp.Title:= 'JNI Android Bridges Library';
  gjAppName:= 'com.example.apptfpnoguigraphicsbridgedemo1';
  gjClassName:= 'com/example/apptfpnoguigraphicsbridgedemo1/Controls';
  gApp.AppName:=gjAppName;
  gApp.ClassName:=gjClassName;
  gApp.Initialize;
  gApp.CreateForm(TAndroidModule1, AndroidModule1);
end.
