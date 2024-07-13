unit Laz_And_Controls_Events;    //by jmpessoa

{$mode delphi}

interface

uses
   Classes, SysUtils, And_jni;

   // AdMob Events
   procedure Java_Event_pOnAdMobLoaded(env: PJNIEnv; this: jobject; Obj: TObject; admobType : integer);
   procedure Java_Event_pOnAdMobFailedToLoad(env: PJNIEnv; this: jobject; Obj: TObject; admobType, errorCode: integer);
   procedure Java_Event_pOnAdMobOpened(env: PJNIEnv; this: jobject; Obj: TObject; admobType : integer);
   procedure Java_Event_pOnAdMobClosed(env: PJNIEnv; this: jobject; Obj: TObject; admobType : integer);
   procedure Java_Event_pOnAdMobClicked(env: PJNIEnv; this: jobject; Obj: TObject; admobType : integer);
   procedure Java_Event_pOnAdMobInitializationComplete(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnAdMobFailedToShow(env: PJNIEnv; this: jobject; Obj: TObject; admobType, errorCode: integer);
   procedure Java_Event_pOnAdMobRewardedUserEarned(env: PJNIEnv; this: jobject; Obj: TObject);

   procedure Java_Event_pOnBluetoothEnabled(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothDisabled(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothDeviceFound(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString );
   procedure Java_Event_pOnBluetoothDiscoveryStarted(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothDiscoveryFinished(env: PJNIEnv; this: jobject; Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
   procedure Java_Event_pOnBluetoothDeviceBondStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; state: integer; deviceName: JString; deviceAddress: JString);

   procedure Java_Event_pOnBluetoothClientSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
   procedure Java_Event_pOnBluetoothClientSocketIncomingData(env: PJNIEnv; this: jobject; Obj: TObject; byteArrayData: JByteArray; byteArrayHeader: JByteArray);
   procedure Java_Event_pOnBluetoothClientSocketDisconnected(env: PJNIEnv; this: jobject; Obj: TObject);

   function Java_Event_pOnBluetoothServerSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString): JBoolean;
   function Java_Event_pOnBluetoothServerSocketIncomingData(env: PJNIEnv; this: jobject; Obj: TObject; byteArrayData: JByteArray; byteArrayHeader: JByteArray): JBoolean;

   procedure Java_Event_pOnBluetoothServerSocketListen(env: PJNIEnv; this: jobject; Obj: TObject; serverName: JString; strUUID: JString);
   procedure Java_Event_pOnBluetoothServerSocketAcceptTimeout(env: PJNIEnv; this: jobject; Obj: TObject);

   procedure Java_Event_pOnSpinnerItemSelected(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);

   procedure Java_Event_pOnLocationChanged(env: PJNIEnv; this: jobject; Obj: TObject; latitude: JDouble; longitude: JDouble; altitude: JDouble; address: JString);
   procedure Java_Event_pOnLocationStatusChanged(env: PJNIEnv; this: jobject; Obj: TObject; status: integer; provider: JString; msgStatus: JString);
   procedure Java_Event_pOnLocationProviderEnabled(env: PJNIEnv; this: jobject; Obj: TObject; provider:JString);
   procedure Java_Event_pOnLocationProviderDisabled(env: PJNIEnv; this: jobject; Obj: TObject; provider: JString);
   procedure Java_Event_pOnGpsStatusChanged(env: PJNIEnv; this: jobject; Obj: TObject; countSatellites: integer; gpsStatusEvent: integer);

   Procedure Java_Event_pOnActionBarTabSelected(env: PJNIEnv; this: jobject; Obj: TObject; view: jObject; title: jString);
   Procedure Java_Event_pOnActionBarTabUnSelected(env: PJNIEnv; this: jobject; Obj: TObject; view:jObject; title: jString);

   Procedure Java_Event_pOnCustomDialogShow(env: PJNIEnv; this: jobject; Obj: TObject; dialog:jObject; title: jString);
   Procedure Java_Event_pOnCustomDialogBackKeyPressed(env: PJNIEnv; this: jobject; Obj: TObject; title: jString);

   Procedure Java_Event_pOnClickToggleButton(env: PJNIEnv; this: jobject; Obj: TObject; state: jboolean); overload;
   Procedure Java_Event_pOnClickToggleButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean);  overload; //deprecated
   procedure Java_Event_pOnLongClickToggleButton(env:PJNIEnv;this:JObject;Sender:TObject;state:jBoolean);

   Procedure Java_Event_pOnChangeSwitchButton(env: PJNIEnv; this: jobject; Obj: TObject; state: jboolean); overload;
   Procedure Java_Event_pOnChangeSwitchButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean);  overload; //deprecated

   Procedure Java_Event_pOnClickGridItem(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);
   Procedure Java_Event_pOnLongClickGridItem(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);

   Procedure Java_Event_pOnChangedSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: JObject; sensorType: integer; values: JObject; timestamp: jLong);
   Procedure Java_Event_pOnListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: jObject; sensorType: integer);

   Procedure Java_Event_pOnUnregisterListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensorType: integer; sensorName: JString);
   Procedure Java_Event_pOnBroadcastReceiver(env: PJNIEnv; this: jobject; Obj: TObject; intent:jObject);

   Procedure Java_Event_pOnTimePicker(env: PJNIEnv; this: jobject; Obj: TObject; hourOfDay: integer; minute: integer);
   Procedure Java_Event_pOnDatePicker(env: PJNIEnv; this: jobject; Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);

   Procedure Java_Event_pOnShellCommandExecuted(env: PJNIEnv; this: jobject; Obj: TObject; cmdResult: JString);

   procedure Java_Event_pOnTCPSocketClientMessageReceived(env: PJNIEnv; this: jobject; Obj: TObject; messageReceived: JString);
   procedure Java_Event_pOnTCPSocketClientBytesReceived(env: PJNIEnv; this: jobject; Obj: TObject; byteArrayReceived: JByteArray);
   procedure Java_Event_pOnTCPSocketClientConnected(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnTCPSocketClientFileSendProgress(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; sendFileSize: integer; filesize: integer);
   procedure Java_Event_pOnTCPSocketClientFileSendFinished(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; filesize: integer);
   procedure Java_Event_pOnTCPSocketClientFileGetProgress(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; remainingFileSize: integer; filesize: integer);
   procedure Java_Event_pOnTCPSocketClientFileGetFinished(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; filesize: integer);
   procedure Java_Event_pOnTCPSocketClientDisConnected(env:PJNIEnv;this:JObject;Sender:TObject);

   Procedure Java_Event_pOnMediaPlayerVideoSizeChanged(env: PJNIEnv; this: jobject; Obj: TObject; videoWidth: integer; videoHeight: integer);
   Procedure Java_Event_pOnMediaPlayerCompletion(env: PJNIEnv; this: jobject; Obj: TObject);
   Procedure Java_Event_pOnMediaPlayerPrepared(env: PJNIEnv; this: jobject; Obj: TObject; videoWidth: integer; videoHeigh: integer);
   Procedure Java_Event_pOnMediaPlayerTimedText(env: PJNIEnv; this: jobject; Obj: TObject; timedText: JString);

   Procedure Java_Event_pOnSoundPoolLoadComplete(env: PJNIEnv; this: jobject; Obj: TObject; soundId : integer; status: integer);

   Procedure Java_Event_pOnSurfaceViewCreated(env: PJNIEnv; this: jobject; Obj: TObject;
                                  surfaceHolder: jObject);

   Procedure Java_Event_pOnSurfaceViewDraw (env: PJNIEnv; this: jobject; Obj: TObject; canvas: jObject);
   Procedure Java_Event_pOnSurfaceViewChanged(env: PJNIEnv; this: jobject; Obj: TObject; width: integer; height: integer);

   procedure Java_Event_pOnSurfaceViewTouch(env: PJNIEnv; this: jobject;
                              Obj: TObject;
                              act,cnt: integer; x1,y1,x2,y2 : single);

   function Java_Event_pOnSurfaceViewDrawingInBackground(env: PJNIEnv; this: jobject; Obj: TObject; progress: single): JBoolean;
   procedure Java_Event_pOnSurfaceViewDrawingPostExecute(env: PJNIEnv; this: jobject; Obj: TObject; progress: single);

   procedure Java_Event_pOnDrawingViewTouch(env: PJNIEnv; this: jobject; Obj: TObject; action, countPoints: integer;
                                 arrayX: jObject; arrayY: jObject; flingGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

   procedure Java_Event_pOnDrawingViewDraw(env: PJNIEnv; this: jobject; Obj: TObject; action, countPoints: integer;
                                      arrayX: jObject; arrayY: jObject; flingGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

   procedure Java_Event_pOnDrawingViewSizeChanged(env: PJNIEnv; this: jobject; Obj: TObject;
                                      width: integer; height: integer; oldWidth: integer; oldHeight: integer);

   Procedure Java_Event_pOnContactManagerContactsExecuted(env: PJNIEnv; this: jobject; Obj: TObject; count: integer);

   function Java_Event_pOnContactManagerContactsProgress(env: PJNIEnv; this: jobject; Obj: TObject; contactInfo: JString;
                                                                                                    contactShortInfo: JString;
                                                                                                    contactPhotoUriAsString: JString;
                                                                                                    contactPhoto: jObject;
                                                                                                    progress: integer): jBoolean;

   function  Java_Event_pOnGridDrawItemCaptionColor(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JInt;
   function  Java_Event_pOnGridDrawItemBitmap(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JObject;

   procedure Java_Event_pOnSeekBarProgressChanged(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer; fromUser: jboolean); overload;
   procedure Java_Event_pOnSeekBarProgressChanged(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer; fromUser: boolean); overload; //deprecated

   procedure Java_Event_pOnSeekBarStartTrackingTouch(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer);
   procedure Java_Event_pOnSeekBarStopTrackingTouch(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer);

   procedure Java_Event_pOnRatingBarChanged(env: PJNIEnv; this: jobject; Obj: TObject; rating: single);

   procedure Java_Event_pRadioGroupCheckedChanged(env: PJNIEnv; this: jobject; Obj: TObject; checkedIndex: integer; checkedCaption: JString);

   Procedure Java_Event_pOnClickGeneric(env: PJNIEnv; this: jobject; Obj: TObject);

   Procedure Java_Event_pOnClickAutoDropDownItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
   procedure Java_Event_pOnChronometerTick(env: PJNIEnv; this: jobject; Obj: TObject; elapsedTimeMillis: JLong);
   Procedure Java_Event_pOnNumberPicker(env: PJNIEnv; this: jobject; Obj: TObject; oldValue: integer; newValue: integer);
   function Java_Event_pOnUDPSocketReceived(env: PJNIEnv; this: jobject; Obj: TObject;
                             content: JString; fromIP: JString; fromPort: integer): JBoolean;

   procedure Java_Event_pOnFileSelected(env: PJNIEnv; this: jobject; Obj: TObject; path: JString; fileName: JString);

   procedure Java_Event_pOnMikrotikAsyncReceive(env: PJNIEnv; this: jobject; Obj: TObject; delimitedContent: JString; delimiter: JString );

   Procedure Java_Event_pOnClickComboDropDownItem(env: PJNIEnv; this: jobject; Obj: TObject;
                                                  index: integer; caption: JString);

   Procedure Java_Event_pOnExpandableListViewChildClick(env: PJNIEnv; this: jobject; Obj: TObject;
                                                             groupPosition: integer; groupHeader:JString;
                                                             childItemPosition: integer;
                                                             childItemCaption: JString);

   Procedure Java_Event_pOnExpandableListViewGroupExpand(env: PJNIEnv; this: jobject; Obj: TObject;
                                                              groupPosition: integer; groupHeader: JString);

   Procedure Java_Event_pOnExpandableListViewGroupCollapse(env: PJNIEnv; this: jobject; Obj: TObject;
                                                              groupPosition: integer; groupHeader: JString);

   Procedure Java_Event_pOnGL2SurfaceCreate(env: PJNIEnv; this: jobject; Obj: TObject);
   Procedure Java_Event_pOnGL2SurfaceChanged(env: PJNIEnv; this: jobject; Obj: TObject; width: integer; height: integer);
   Procedure Java_Event_pOnGL2SurfaceDrawFrame(env: PJNIEnv; this: jobject; Obj: TObject);

   Procedure Java_Event_pOnGL2SurfaceTouch(env: PJNIEnv; this: jobject; Obj: TObject;
                                           action, countPoints: integer;
                                           arrayX: jObject; arrayY: jObject;
                                           flingGesture: integer; pinchZoomGestureState: integer;
                                           zoomScaleFactor: single);

   Procedure Java_Event_pOnGL2SurfaceDestroyed(env: PJNIEnv; this: jobject; Obj: TObject);

   Procedure Java_Event_pOnRecyclerViewItemClick(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
   Procedure Java_Event_pOnRecyclerViewItemLongClick(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
   Procedure Java_Event_pOnRecyclerViewItemTouchUp(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
   Procedure Java_Event_pOnRecyclerViewItemTouchDown(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);

   Procedure Java_Event_pOnClickNavigationViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);
   Procedure Java_Event_pOnClickBottomNavigationViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);

   Procedure Java_Event_pOnClickTreeViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);
   Procedure Java_Event_pOnLongClickTreeViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);

   Procedure Java_Event_pOnSTabSelected(env: PJNIEnv; this: jobject; Obj: TObject; position: integer;  title: JString);

   Procedure Java_Event_pOnCustomCameraSurfaceChanged(env: PJNIEnv; this: jobject; Obj: TObject; width: integer; height: integer);
   Procedure Java_Event_pOnCustomCameraPictureTaken(env: PJNIEnv; this: jobject; Obj: TObject; picture: JObject;  fullPath: JString);


   Procedure Java_Event_pOnCalendarSelectedDayChange(env: PJNIEnv; this: jobject; Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);

   Procedure Java_Event_pOnSearchViewFocusChange(env: PJNIEnv; this: jobject; Obj: TObject; hasFocus: jBoolean);
   Procedure Java_Event_pOnSearchViewQueryTextSubmit(env: PJNIEnv; this: jobject; Obj: TObject; query: JString);
   Procedure Java_Event_pOnSearchViewQueryTextChange(env: PJNIEnv; this: jobject; Obj: TObject; newText: JString );
   procedure Java_Event_pOnClickX(env:PJNIEnv;this:JObject;Sender:TObject);

   Procedure Java_Event_pOnTelephonyCallStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; state: integer; phoneNumber: JString );
   Procedure Java_Event_pOnGetUidTotalMobileBytesFinished(env: PJNIEnv; this: jobject; Obj: TObject; bytesResult: jLong; uid:integer );
   Procedure Java_Event_pOnGetUidTotalWifiBytesFinished(env: PJNIEnv; this: jobject; Obj: TObject; bytesResult: jLong; uid:integer );

   Procedure Java_Event_pOnRecyclerViewItemWidgetClick(env: PJNIEnv; this: jobject; Obj: TObject;
                                                       itemIndex: integer; widgetClass: integer;
                                                        widgetId: integer; status: integer);
   Procedure Java_Event_pOnRecyclerViewItemWidgetLongClick(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      itemIndex: integer; widgetClass: integer;
                                                      widgetId: integer);

   Procedure Java_Event_pOnRecyclerViewItemWidgetTouchUp(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      itemIndex: integer; widgetClass: integer;
                                                      widgetId: integer);

   Procedure Java_Event_pOnRecyclerViewItemWidgetTouchDown(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      itemIndex: integer; widgetClass: integer;
                                                      widgetId: integer);

   Procedure Java_Event_pOnZBarcodeScannerViewResult(env: PJNIEnv; this: jobject; Obj: TObject;
                                                       codedata: JString; codetype: integer);

   //Procedure Java_Event_pOnZBarcodeScannerViewPictureTaken(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      // picture: JObject; fullPath: JString);
   //Procedure Java_Event_pOnZBarcodeScannerViewPictureMake(env: PJNIEnv; this: jobject; Obj: TObject);

   procedure Java_Event_pOnMidiManagerDeviceAdded(env:PJNIEnv;this:JObject;Sender:TObject;deviceId:integer;deviceName:jString;productId:jString;manufacture:jString);
   procedure Java_Event_pOnMidiManagerDeviceRemoved(env:PJNIEnv;this:JObject;Sender:TObject;deviceId:integer;deviceName:jString;productId:jString;manufacture:jString);
   function Java_Event_pOnOpenMapViewRoadDraw(env:PJNIEnv;this:JObject;Sender:TObject;roadCode:integer;roadStatus:integer;roadDuration:double;roadDistance:double):jintArray;
   procedure Java_Event_pOnOpenMapViewClick(env:PJNIEnv;this:JObject;Sender:TObject;latitude:double;longitude:double);
   procedure Java_Event_pOnOpenMapViewLongClick(env:PJNIEnv;this:JObject;Sender:TObject;latitude:double;longitude:double);
   procedure Java_Event_pOnOpenMapViewMarkerClick(env:PJNIEnv;this:JObject;Sender:TObject;title:jString;latitude:double;longitude:double);

   procedure Java_Event_pOnSignaturePadStartSigning(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnSignaturePadSigned(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnSignaturePadClear(env:PJNIEnv;this:JObject;Sender:TObject);

   procedure Java_Event_pOnMailMessagesCount(env:PJNIEnv;this:JObject;Sender:TObject;count:integer);
   procedure Java_Event_pOnMailMessageRead(env:PJNIEnv;this:JObject;Sender:TObject;position:integer;Header:jString;Date:jString;Subject:jString;ContentType:jString;ContentText:jString;Attachments:jString);

   procedure Java_Event_pOnSFTPClientTryConnect(env:PJNIEnv;this:JObject;Sender:TObject;success:jBoolean);
   procedure Java_Event_pOnSFTPClientDownloadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
   procedure Java_Event_pOnSFTPClientUploadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
   procedure Java_Event_pOnSFTPClientListing(env:PJNIEnv;this:JObject;Sender:TObject;remotePath:jString;fileName:jString;fileSize:integer);
   procedure Java_Event_pOnSFTPClientListed(env:PJNIEnv;this:JObject;Sender:TObject;count:integer);

   procedure Java_Event_pOnFTPClientTryConnect(env:PJNIEnv;this:JObject;Sender:TObject;success:jBoolean);
   procedure Java_Event_pOnFTPClientDownloadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
   procedure Java_Event_pOnFTPClientUploadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
   procedure Java_Event_pOnFTPClientListing(env:PJNIEnv;this:JObject;Sender:TObject;remotePath:jString;fileName:jString;fileSize:integer);
   procedure Java_Event_pOnFTPClientListed(env:PJNIEnv;this:JObject;Sender:TObject;count:integer);

   procedure Java_Event_pOnBluetoothSPPDataReceived(env:PJNIEnv;this:JObject;Sender:TObject;jbyteArrayData:jbyteArray;messageData:jString);
   procedure Java_Event_pOnBluetoothSPPDeviceConnected(env:PJNIEnv;this:JObject;Sender:TObject;deviceName:jString;deviceAddress:jString);
   procedure Java_Event_pOnBluetoothSPPDeviceDisconnected(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnBluetoothSPPDeviceConnectionFailed(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnBluetoothSPPServiceStateChanged(env:PJNIEnv;this:JObject;Sender:TObject;serviceState:integer);
   procedure Java_Event_pOnBluetoothSPPListeningNewAutoConnection(env:PJNIEnv;this:JObject;Sender:TObject;deviceName:jString;deviceAddress:jString);
   procedure Java_Event_pOnBluetoothSPPAutoConnectionStarted(env:PJNIEnv;this:JObject;Sender:TObject);

   procedure Java_Event_pOnDirectorySelected(env:PJNIEnv;this:JObject;Sender:TObject;path:jString);

   procedure Java_Event_pOnMsSqlJDBCConnectionExecuteQueryAsync(env:PJNIEnv;this:JObject;Sender:TObject;messageStatus:jString);
   procedure Java_Event_pOnMsSqlJDBCConnectionOpenAsync(env:PJNIEnv;this:JObject;Sender:TObject;messageStatus:jString);
   procedure Java_Event_pOnMsSqlJDBCConnectionExecuteUpdateAsync(env:PJNIEnv;this:JObject;Sender:TObject;messageStatus:jString);

   procedure Java_Event_pOnBeginOfSpeech(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnSpeechBufferReceived(env:PJNIEnv;this:JObject;Sender:TObject;txtBytes:jbyteArray);
   procedure Java_Event_pOnEndOfSpeech(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnSpeechResults(env:PJNIEnv;this:JObject;Sender:TObject;txt:jString);

   //by Marco Bramardi
   procedure Java_Event_pOnBillingClientEvent(env:PJNIEnv; this:JObject; Obj: TObject; xml: JString);

   //jcToyTimerService
   procedure Java_Event_pOnToyTimerServicePullElapsedTime(env:PJNIEnv;this:JObject;Sender:TObject;elapsedTime:int64);

   procedure Java_Event_pOnBluetoothLEConnected(env:PJNIEnv;this:JObject;Sender:TObject;deviceName:jString;deviceAddress:jString;bondState:integer);
   procedure Java_Event_pOnBluetoothLEScanCompleted(env:PJNIEnv;this:JObject;Sender:TObject;deviceNameArray:jstringArray;deviceAddressArray:jstringArray);
   procedure Java_Event_pOnBluetoothLEServiceDiscovered(env:PJNIEnv;this:JObject;Sender:TObject;serviceIndex:integer;serviceUUID:jString;characteristicUUIDArray:jstringArray);
   procedure Java_Event_pOnBluetoothLECharacteristicChanged(env:PJNIEnv;this:JObject;Sender:TObject;strValue:jString;strCharacteristic:jString);
   procedure Java_Event_pOnBluetoothLECharacteristicRead(env:PJNIEnv;this:JObject;Sender:TObject;strValue:jString;strCharacteristic:jString);

   //jsFirebasePushNotificationListener
   procedure Java_Event_pOnGetTokenComplete(env:PJNIEnv;this:JObject;Sender:TObject;token:jString;isSuccessful:jBoolean;statusMessage:jString);

   //jBatteryManager
   procedure Java_Event_pOnBatteryCharging(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer;pluggedBy:integer);
   procedure Java_Event_pOnBatteryDisCharging(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
   procedure Java_Event_pOnBatteryFull(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
   procedure Java_Event_pOnBatteryUnknown(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
   procedure Java_Event_pOnBatteryNotCharging(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);

   //jModbus
   procedure Java_Event_pOnModbusConnect(env:PJNIEnv;this:JObject;Sender:TObject;success:jBoolean;msg:jString);

   // jcWebSocketClient
   procedure Java_Event_pWebSocketClientOnOpen(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pWebSocketClientOnTextReceived(env:PJNIEnv;this:JObject;Sender:TObject;msgContent:jString);
   procedure Java_Event_pWebSocketClientOnBinaryReceived(env:PJNIEnv;this:JObject;Sender:TObject;data:jbyteArray);
   procedure Java_Event_pWebSocketClientOnPingReceived(env:PJNIEnv;this:JObject;Sender:TObject;data:jbyteArray);
   procedure Java_Event_pWebSocketClientOnPongReceived(env:PJNIEnv;this:JObject;Sender:TObject;data:jbyteArray);
   procedure Java_Event_pWebSocketClientOnException(env:PJNIEnv;this:JObject;Sender:TObject;exceptionMessage:jString);
   procedure Java_Event_pWebSocketClientOnCloseReceived(env:PJNIEnv;this:JObject;Sender:TObject);

   //jsArduinoAflakSerial
   procedure Java_Event_pOnArduinoAflakSerialAttached(env:PJNIEnv;this:JObject;Sender:TObject;usb:JObject);
   procedure Java_Event_pOnArduinoAflakSerialDetached(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnArduinoAflakSerialMessageReceived(env:PJNIEnv;this:JObject;Sender:TObject;jbytesReceived:jbyteArray);
   procedure Java_Event_pOnArduinoAflakSerialOpened(env:PJNIEnv;this:JObject;Sender:TObject);
   procedure Java_Event_pOnArduinoAflakSerialStatusChanged(env:PJNIEnv;this:JObject;Sender:TObject;statusMessage:jString);

implementation

uses
   AndroidWidget, bluetooth, bluetoothclientsocket, bluetoothserversocket,
   spinner, location, actionbartab, customdialog, togglebutton, switchbutton, gridview,
   sensormanager, broadcastreceiver, datepickerdialog, timepickerdialog, shellcommand,
   tcpsocketclient, surfaceview, mediaplayer, contactmanager, seekbar, ratingbar,
   radiogroup, drawingview, autocompletetextview, chronometer, numberpicker,
   udpsocket, opendialog, comboedittext,toolbar, expandablelistview, gl2surfaceview,
   sfloatingbutton, framelayout,stoolbar, snavigationview, srecyclerview, sbottomnavigationview,
   stablayout, treelistview, customcamera, calendarview, searchview, telephonymanager,
   sadmob, zbarcodescannerview, cmikrotikrouteros, scontinuousscrollableimageview,
   midimanager, copenmapview, csignaturepad, soundpool, cmail, sftpclient,
   ftpclient, cbluetoothspp, selectdirectorydialog, mssqljdbcconnection, customspeechtotext,
   cbillingclient, ctoytimerservice, bluetoothlowenergy,
   sfirebasepushnotificationlistener, batterymanager, modbus,
   cwebsocketclient, ujsarduinoaflakserial, imagebutton;

function GetString(env: PJNIEnv; jstr: JString): string;
var
 _jBoolean: JBoolean;
begin
    Result := '';
    if jstr <> nil then
    begin
      _jBoolean:= JNI_False;
      Result:= string(env^.GetStringUTFChars(env,jstr,@_jBoolean) );
    end;
end;

function GetJString(env: PJNIEnv; str: string): JString;
begin
  Result:= env^.NewStringUTF(env, PChar(str));
end;

function GetDynArrayOfString(env: PJNIEnv; stringArrayData: jstringArray): TDynArrayOfString;
var
  jstr: JString;
  jBoo: JBoolean;
  sizeArray: integer;
  i: integer;
begin
    Result := nil;
    sizeArray:=  env^.GetArrayLength(env, stringArrayData);
    SetLength(Result, sizeArray);
    for i:= 0 to sizeArray - 1 do
    begin
      jstr:= env^.GetObjectArrayElement(env, stringArrayData, i);
      case jstr = nil of
         True : Result[i]:= '';
         False: begin
                   jBoo:= JNI_False;
                   Result[i]:= string(env^.GetStringUTFChars(env,jstr, @jBoo));
                 end;
      end;
    end;
end;

function GetDynArrayOfSingle(env: PJNIEnv; floatArrayData: jfloatArray): TDynArrayOfSingle;
var
  sizeArray: integer;
begin
  Result := nil;
  sizeArray:=  env^.GetArrayLength(env, floatArrayData);
  SetLength(Result, sizeArray);
  env^.GetFloatArrayRegion(env, floatArrayData, 0, sizeArray, @Result[0] {target});
end;

function GetDynArrayOfDouble(env: PJNIEnv; doubleArrayData: jfloatArray): TDynArrayOfDouble;
var
  sizeArray: integer;
begin
  Result := nil;
  sizeArray:=  env^.GetArrayLength(env, doubleArrayData);
  SetLength(Result, sizeArray);
  env^.GetDoubleArrayRegion(env, doubleArrayData, 0, sizeArray, @Result[0] {target});
end;

function GetDynArrayOfInteger(env: PJNIEnv; intArrayData: jintArray): TDynArrayOfInteger;
var
  sizeArray: integer;
begin
  Result := nil;
  sizeArray:=  env^.GetArrayLength(env, intArrayData);
  SetLength(Result, sizeArray);
  env^.GetIntArrayRegion(env, intArrayData, 0, sizeArray, @Result[0] {target});
end;

function GetDynArrayOfJByte(env: PJNIEnv; byteArrayData: jbytearray): TDynArrayOfJByte;
var
  sizeArray: integer;
begin
  Result := nil;
  sizeArray:=  env^.GetArrayLength(env, byteArrayData);
  SetLength(Result, sizeArray);
  env^.GetByteArrayRegion(env, byteArrayData, 0, sizeArray, @Result[0] {target});
end;

function GetJObjectOfDynArrayOfJByte(env: PJNIEnv; var dataContent: TDynArrayOfJByte):jbyteArray; //jObject;
var
  newSize0: integer;
begin
  Result:= nil;
  newSize0:= Length(dataContent);
  Result:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, Result, 0 , newSize0, @dataContent[0] {source});
end;

function GetJObjectOfDynArrayOfSingle(env: PJNIEnv; var dataContent: TDynArrayOfSingle):jfloatArray; // jObject;
var
  newSize0: integer;
begin
  Result:= nil;
  newSize0:= Length(dataContent);
  Result:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, Result, 0 , newSize0, @dataContent[0] {source});
end;

function GetJObjectOfDynArrayOfDouble(env: PJNIEnv; var dataContent: TDynArrayOfDouble):jdoubleArray; // jObject;
var
  newSize0: integer;
begin
  Result:= nil;
  newSize0:= Length(dataContent);
  Result:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, Result, 0 , newSize0, @dataContent[0] {source});
end;

function GetJObjectOfDynArrayOfInteger(env: PJNIEnv; var dataContent: TDynArrayOfInteger):jintArray; // jObject;
var
  newSize0: integer;
begin
  Result:= nil;
  newSize0:= Length(dataContent);
  Result:= env^.NewIntArray(env, newSize0);  // allocate
  env^.SetIntArrayRegion(env, Result, 0 , newSize0, @dataContent[0] {source});
end;

function GetJObjectOfDynArrayOfString(env: PJNIEnv; var dataContent: TDynArrayOfString): jstringArray;  // jObject;
var
  newSize0: integer;
  i: integer;
begin
  Result:= nil;
  newSize0:= Length(dataContent);
  Result:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,Result,i,env^.NewStringUTF(env, PChar(dataContent[i])));
  end;
end;

//--------
procedure Java_Event_pOnBluetoothEnabled(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetooth then
  begin
    jBluetooth(Obj).GenEvent_OnBluetoothEnabled(Obj);
  end;
end;

procedure Java_Event_pOnBluetoothDisabled(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetooth then
  begin
    jBluetooth(Obj).GenEvent_OnBluetoothDisabled(Obj);
  end;
end;

Procedure Java_Event_pOnBluetoothDeviceFound(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString );
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetooth then
  begin
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetooth(Obj).GenEvent_OnBluetoothDeviceFound(Obj, pasStrName, pasStrAddress);
  end;

end;

procedure Java_Event_pOnBluetoothDiscoveryStarted(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetooth then
  begin
    jBluetooth(Obj).GenEvent_OnBluetoothDiscoveryStarted(Obj);
  end;
end;

procedure Java_Event_pOnBluetoothDiscoveryFinished(env: PJNIEnv; this: jobject; Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetooth then
  begin
    jBluetooth(Obj).GenEvent_OnBluetoothDiscoveryFinished(Obj, countFoundedDevices, countPairedDevices);
  end;
end;

procedure Java_Event_pOnBluetoothDeviceBondStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; state: integer; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetooth then
  begin
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetooth(Obj).GenEvent_OnBluetoothDeviceBondStateChanged(Obj, state, pasStrName, pasStrAddress);
  end;
end;

procedure Java_Event_pOnBluetoothClientSocketIncomingData(env: PJNIEnv; this: jobject; Obj: TObject; byteArrayData: JByteArray; byteArrayHeader: JByteArray);
var
  sizeArray: integer;
  arrayResult: TDynArrayOfJByte; //array of jByte;  //shortint

  sizeArrayHeader: integer;
  arrayResultHeader: TDynArrayOfJByte; //array of jByte;  //shortint

begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  arrayResult := nil;
  arrayResultHeader := nil;

  if byteArrayData <> nil then
  begin
    sizeArray:=  env^.GetArrayLength(env, byteArrayData);
    SetLength(arrayResult, sizeArray);
    env^.GetByteArrayRegion(env, byteArrayData, 0, sizeArray, @arrayResult[0] {target});
  end;

  if byteArrayHeader <> nil then
  begin
    sizeArrayHeader:=  env^.GetArrayLength(env, byteArrayHeader);
    SetLength(arrayResultHeader, sizeArrayHeader);
    env^.GetByteArrayRegion(env, byteArrayHeader, 0, sizeArrayHeader, @arrayResultHeader[0] {target});
  end;

  if Obj is jBluetoothClientSocket then
  begin
    jBluetoothClientSocket(Obj).GenEvent_OnBluetoothClientSocketIncomingData(Obj, arrayResult, arrayResultHeader);
  end;

end;

procedure Java_Event_pOnBluetoothClientSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetoothClientSocket then
  begin
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetoothClientSocket(Obj).GenEvent_OnBluetoothClientSocketConnected(Obj, pasStrName, pasStrAddress);
  end;
end;

procedure Java_Event_pOnBluetoothClientSocketDisconnected(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetoothClientSocket then
  begin
    jBluetoothClientSocket(Obj).GenEvent_OnBluetoothClientSocketDisconnected(Obj);
  end;
end;

function Java_Event_pOnBluetoothServerSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString): JBoolean;
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
 keepConnected: boolean;
begin
  keepConnected := true;
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetoothServerSocket then
  begin
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketConnected(Obj, pasStrName, pasStrAddress, keepConnected);
  end;
  Result:= JBool(keepConnected);
end;

function Java_Event_pOnBluetoothServerSocketIncomingData(env: PJNIEnv; this: jobject; Obj: TObject; byteArrayData: JByteArray; byteArrayHeader: JByteArray): JBoolean;
var
  sizeArray: integer;
  sizeArrayHeader: integer;

  arrayResult: TDynArrayOfJByte; //array of jByte;  //shortint
  arrayResultHeader: TDynArrayOfJByte; //array of jByte;  //shortint

  keepConnected: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  keepConnected := true;

  arrayResult := nil;
  arrayResultHeader := nil;

  if byteArrayData <> nil then
  begin
     sizeArray:=  env^.GetArrayLength(env, byteArrayData);
     SetLength(arrayResult, sizeArray);
     env^.GetByteArrayRegion(env, byteArrayData, 0, sizeArray, @arrayResult[0] {target});
  end;

  if byteArrayHeader <> nil then
  begin
    sizeArrayHeader:=  env^.GetArrayLength(env, byteArrayHeader);
    SetLength(arrayResultHeader, sizeArrayHeader);
    env^.GetByteArrayRegion(env, byteArrayHeader, 0, sizeArrayHeader, @arrayResultHeader[0] {target});
  end;

  if Obj is jBluetoothServerSocket then
  begin
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketIncomingData(Obj, arrayResult, arrayResultHeader, keepConnected);
  end;
  Result:= JBool(keepConnected);
end;



procedure Java_Event_pOnBluetoothServerSocketListen(env: PJNIEnv; this: jobject; Obj: TObject; serverName: JString; strUUID: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetoothServerSocket then
  begin
    pasStrName := '';
    if serverName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,serverName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if strUUID <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,strUUID,@_jBoolean) );
    end;
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketListen(Obj, pasStrName, pasStrAddress);
  end;
end;

procedure Java_Event_pOnBluetoothServerSocketAcceptTimeout(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBluetoothServerSocket then
  begin
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketAcceptTimeout(Obj);
  end;
end;

procedure Java_Event_pOnAdMobLoaded(env: PJNIEnv; this: jobject; Obj: TObject; admobType: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobLoaded(Obj, admobType);
  end;
end;

procedure Java_Event_pOnAdMobInitializationComplete(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobInitializationComplete(Obj);
  end;
end;

procedure Java_Event_pOnAdMobClicked(env: PJNIEnv; this: jobject; Obj: TObject; admobType: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobClicked(Obj, admobType);
  end;
end;

procedure Java_Event_pOnAdMobFailedToLoad(env: PJNIEnv; this: jobject; Obj: TObject; admobType, errorCode: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobFailedToLoad(Obj, admobType, errorCode);
  end;
end;

procedure Java_Event_pOnAdMobOpened(env: PJNIEnv; this: jobject; Obj: TObject; admobType: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobOpened(Obj, admobType);
  end;
end;

procedure Java_Event_pOnAdMobClosed(env: PJNIEnv; this: jobject; Obj: TObject; admobType: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobClosed(Obj, admobType);
  end;
end;

procedure Java_Event_pOnAdMobRewardedUserEarned(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobRewardedUserEarned(Obj);
  end;
end;

procedure Java_Event_pOnAdMobFailedToShow(env: PJNIEnv; this: jobject; Obj: TObject; admobType, errorCode: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jsAdMob then
  begin
     jsAdMob(Obj).GenEvent_OnAdMobFailedToShow(Obj, admobType, errorCode);
  end;
end;

procedure Java_Event_pOnSpinnerItemSelected(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);
var
 pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSpinner then
  begin
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(Env,caption,@_jBoolean) );
    end;
    jSpinner(Obj).GenEvent_OnSpinnerItemSelected(Obj, pasCaption, position);
  end;
end;

procedure Java_Event_pOnLocationChanged(env: PJNIEnv; this: jobject; Obj: TObject; latitude: JDouble; longitude: JDouble; altitude: JDouble; address: JString);
var
  pasaddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jLocation then
  begin
    pasaddress:='';

    if address <> nil then
    begin
      _jBoolean:= JNI_False;
      pasaddress:= string( env^.GetStringUTFChars(Env,address,@_jBoolean) );
    end;

    jLocation(Obj).GenEvent_OnLocationChanged(Obj, latitude, longitude, altitude, pasaddress);
  end;
end;

procedure Java_Event_pOnLocationStatusChanged(env: PJNIEnv; this: jobject; Obj: TObject; status: integer; provider: JString; msgStatus: JString);
var
 pasmsgStatus, pasprovider: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jLocation then
  begin
    pasmsgStatus:= '';
    pasprovider:= '';
    if provider <> nil then
    begin
      _jBoolean:= JNI_False;
      pasprovider:= string( env^.GetStringUTFChars(Env,provider,@_jBoolean) );
    end;

    if msgStatus <> nil then
    begin
      _jBoolean:= JNI_False;
      pasmsgStatus:= string( env^.GetStringUTFChars(Env,msgStatus,@_jBoolean) );
    end;

    jLocation(Obj).GenEvent_OnLocationStatusChanged(Obj, status, pasprovider, pasmsgStatus);
  end;
end;

procedure Java_Event_pOnLocationProviderEnabled(env: PJNIEnv; this: jobject; Obj: TObject; provider:JString);
var
 pasprovider: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jLocation then
  begin
    pasprovider := '';
    if provider <> nil then
    begin
      _jBoolean:= JNI_False;
      pasprovider:= string( env^.GetStringUTFChars(Env,provider,@_jBoolean) );
    end;
    jLocation(Obj).GenEvent_OnLocationProviderEnabled(Obj, pasprovider);
  end;
end;

procedure Java_Event_pOnLocationProviderDisabled(env: PJNIEnv; this: jobject; Obj: TObject; provider: JString);
var
 pasprovider: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jLocation then
  begin
    pasprovider := '';
    if provider <> nil then
    begin
      _jBoolean:= JNI_False;
      pasprovider:= string( env^.GetStringUTFChars(Env,provider,@_jBoolean) );
    end;
    jLocation(Obj).GenEvent_OnLocationProviderDisabled(Obj, pasprovider);
  end;
end;

procedure Java_Event_pOnGpsStatusChanged(env: PJNIEnv; this: jobject; Obj: TObject; countSatellites: integer; gpsStatusEvent: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jLocation then
  begin
    jLocation(Obj).GenEvent_OnGpsStatusChanged(Obj, countSatellites, gpsStatusEvent);
  end;
end;


Procedure Java_Event_pOnActionBarTabSelected(env: PJNIEnv; this: jobject; Obj: TObject; view: jObject; title: jString);
var
  pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jActionBarTab then
  begin
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string( env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jActionBarTab(Obj).GenEvent_OnActionBarTabSelected(Obj, view, pastitle);
  end;
end;

Procedure Java_Event_pOnActionBarTabUnSelected(env: PJNIEnv; this: jobject; Obj: TObject; view:jObject; title: jString);
var
   pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jActionBarTab then
  begin
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string(env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jActionBarTab(Obj).GenEvent_OnActionBarTabUnSelected(Obj, view, pastitle);
  end;
end;

Procedure Java_Event_pOnCustomDialogShow(env: PJNIEnv; this: jobject; Obj: TObject; dialog:jObject; title: jString);
var
   pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jCustomDialog then
  begin
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string(env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jCustomDialog(Obj).GenEvent_OnCustomDialogShow(Obj, dialog, pastitle);
  end;
end;

Procedure Java_Event_pOnCustomDialogBackKeyPressed(env: PJNIEnv; this: jobject; Obj: TObject; title: jString);
var
   pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jCustomDialog then
  begin
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string(env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jCustomDialog(Obj).GenEvent_OnCustomDialogBackKeyPressed(Obj, pastitle);
  end;
end;

Procedure Java_Event_pOnClickToggleButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean); //deprecated
begin
  Java_Event_pOnClickToggleButton(env,this,Obj,JBoolean(state));
end;

Procedure Java_Event_pOnClickToggleButton(env: PJNIEnv; this: jobject; Obj: TObject; state: jboolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jToggleButton then
  begin
    jToggleButton(Obj).GenEvent_OnClickToggleButton(Obj, Boolean(state));
  end;
end;

procedure Java_Event_pOnLongClickToggleButton(env:PJNIEnv;this:JObject;Sender:TObject;state:jBoolean);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jToggleButton then
  begin
    jToggleButton(Sender).GenEvent_OnLongClickToggleButton(Sender,boolean(state));
  end;
end;

Procedure Java_Event_pOnChangeSwitchButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean); //deprecated
begin
  Java_Event_pOnChangeSwitchButton(env,this,Obj,JBoolean(state));
end;

Procedure Java_Event_pOnChangeSwitchButton(env: PJNIEnv; this: jobject; Obj: TObject; state: jboolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSwitchButton then
  begin
    jSwitchButton(Obj).GenEvent_OnChangeSwitchButton(Obj, Boolean(state));
  end;
end;

Procedure Java_Event_pOnClickGridItem(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);
var
   pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jGridView then
  begin
    pasCaption:= '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string(env^.GetStringUTFChars(Env, caption,@_jBoolean) );
    end;
    jGridView(Obj).GenEvent_OnClickGridItem(Obj, position, pasCaption);
  end;
end;

Procedure Java_Event_pOnLongClickGridItem(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);
var
   pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jGridView then
  begin
    pasCaption:= '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string(env^.GetStringUTFChars(Env, caption,@_jBoolean) );
    end;
    jGridView(Obj).GenEvent_OnLongClickGridItem(Obj, position, pasCaption);
  end;
end;

Procedure Java_Event_pOnChangedSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: JObject; sensorType: integer; values: JObject; timestamp: jLong);
var
  sizeArray: integer;
  arrayResult: array of single;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  arrayResult := nil;

  if values <> nil then
  begin
    sizeArray:=  env^.GetArrayLength(env, values);
    SetLength(arrayResult, sizeArray);
    env^.GetFloatArrayRegion(env, values, 0, sizeArray, @arrayResult[0] {target});
  end;

  if Obj is jSensorManager then
  begin
    jSensorManager(Obj).GenEvent_OnChangedSensor(Obj, sensor, sensorType, arrayResult, timestamp{sizeArray});
  end;

end;

Procedure Java_Event_pOnListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: jObject; sensorType: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSensorManager then
  begin
    jSensorManager(Obj).GenEvent_OnListeningSensor(Obj, sensor, sensorType);
  end;
end;

Procedure Java_Event_pOnUnregisterListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensorType: integer; sensorName: JString);
var
   pasSensorName: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSensorManager then
  begin
    pasSensorName:= '';
    if sensorName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasSensorName:= string(env^.GetStringUTFChars(Env, sensorName,@_jBoolean) );
    end;
    jSensorManager(Obj).GenEvent_OnUnregisterListeningSensor(Obj, sensorType, pasSensorName);
  end;
end;

Procedure Java_Event_pOnBroadcastReceiver(env: PJNIEnv; this: jobject; Obj: TObject; intent:jObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jBroadcastReceiver then
  begin
    jBroadcastReceiver(Obj).GenEvent_OnBroadcastReceiver(Obj,  intent);
  end;
end;


Procedure Java_Event_pOnTimePicker(env: PJNIEnv; this: jobject; Obj: TObject; hourOfDay: integer; minute: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTimePickerDialog then
  begin
    jTimePickerDialog(Obj).GenEvent_OnTimePicker(Obj, hourOfDay, minute);
  end;
end;

Procedure Java_Event_pOnDatePicker(env: PJNIEnv; this: jobject; Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jDatePickerDialog then
  begin
    jDatePickerDialog(Obj).GenEvent_OnDatePicker(Obj,  year, monthOfYear, dayOfMonth);
  end;
end;

Procedure Java_Event_pOnCalendarSelectedDayChange(env: PJNIEnv; this: jobject; Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jCalendarView then
  begin
    jCalendarView(Obj).GenEvent_OnSelectedDayChange(Obj,  year, monthOfYear, dayOfMonth);
  end;
end;

Procedure Java_Event_pOnShellCommandExecuted(env: PJNIEnv; this: jobject; Obj: TObject; cmdResult: JString);
var
   pascmdResult:  string;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jShellCommand then
  begin
    pascmdResult := '';
    if cmdResult <> nil then
    begin
      jBoo := JNI_False;
      pascmdResult:= string( env^.GetStringUTFChars(Env,cmdResult,@jBoo) );
    end;
    jShellCommand(Obj).GenEvent_OnShellCommandExecuted(Obj, pascmdResult);
  end;
end;

Procedure Java_Event_pOnTCPSocketClientMessageReceived(env: PJNIEnv; this: jobject; Obj: TObject; messageReceived: JString);
var
   pasMessageReceived: string;
   jBoo: jBoolean;
begin

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTCPSocketClient then
  begin

    pasMessageReceived := '';

    if messageReceived <> nil then
    begin
      jBoo := JNI_False;
      pasMessageReceived:= string( env^.GetStringUTFChars(Env,messageReceived,@jBoo) );
    end;

    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientMessagesReceived(Obj, pasMessageReceived);
  end;
end;

Procedure Java_Event_pOnTCPSocketClientBytesReceived(env: PJNIEnv; this: jobject; Obj: TObject; byteArrayReceived: JByteArray);
var
  sizeArray: integer;
  arrayResult: TDynArrayOfJByte; //array of jByte;  //shortint
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  arrayResult := nil;

  if byteArrayReceived <> nil then
  begin
    sizeArray:=  env^.GetArrayLength(env, byteArrayReceived);
    SetLength(arrayResult, sizeArray);
    env^.GetByteArrayRegion(env, byteArrayReceived, 0, sizeArray, @arrayResult[0] {target});
  end;

  if Obj is jTCPSocketClient then
  begin
    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientBytesReceived(Obj, arrayResult);
  end;

end;

Procedure Java_Event_pOnTCPSocketClientConnected(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTCPSocketClient then
  begin
    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientConnected(Obj);
  end;
end;

Procedure Java_Event_pOnTCPSocketClientFileSendProgress(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; sendFileSize: integer; filesize: integer);
var
   pasfilename:  string;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTCPSocketClient then
  begin
    pasfilename := '';
    if filename <> nil then
    begin
      jBoo := JNI_False;
      pasfilename:= string( env^.GetStringUTFChars(Env,filename,@jBoo) );
    end;
    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientFileSendProgress(Obj, pasfilename, sendFileSize, filesize);
  end;
end;

Procedure Java_Event_pOnTCPSocketClientFileSendFinished(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; filesize: integer);
var
   pasfilename:  string;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTCPSocketClient then
  begin
    pasfilename := '';
    if filename <> nil then
    begin
      jBoo := JNI_False;
      pasfilename:= string( env^.GetStringUTFChars(Env,filename,@jBoo) );
    end;
    jTCPSocketClient(Obj).GenEvent_pOnTCPSocketClientFileSendFinished(Obj, pasfilename, filesize);
  end;
end;

procedure Java_Event_pOnTCPSocketClientFileGetProgress(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; remainingFileSize: integer; filesize: integer);
var
   pasfilename:  string;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTCPSocketClient then
  begin
    pasfilename := '';
    if filename <> nil then
    begin
      jBoo := JNI_False;
      pasfilename:= string( env^.GetStringUTFChars(Env,filename,@jBoo) );
    end;
    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientFileGetProgress(Obj, pasfilename, remainingFileSize, filesize);
  end;
end;

procedure Java_Event_pOnTCPSocketClientFileGetFinished(env: PJNIEnv; this: jobject; Obj: TObject; filename: JString; filesize: integer);
var
   pasfilename:  string;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTCPSocketClient then
  begin
    pasfilename := '';
    if filename <> nil then
    begin
      jBoo := JNI_False;
      pasfilename:= string( env^.GetStringUTFChars(Env,filename,@jBoo) );
    end;
    jTCPSocketClient(Obj).GenEvent_pOnTCPSocketClientFileGetFinished(Obj, pasfilename, filesize);
  end;
end;

procedure Java_Event_pOnTCPSocketClientDisConnected(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jTCPSocketClient then
  begin
    jTCPSocketClient(Sender).GenEvent_OnTCPSocketClientDisConnected(Sender);
  end;
end;

Procedure Java_Event_pOnSurfaceViewCreated(env: PJNIEnv; this: jobject; Obj: TObject;
                               surfaceHolder: jObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSurfaceView then
  begin
    jSurfaceView(Obj).GenEvent_OnSurfaceViewCreated(Obj,surfaceHolder);
  end;
end;

Procedure Java_Event_pOnSurfaceViewDraw (env: PJNIEnv; this: jobject; Obj: TObject; canvas: jObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSurfaceView then
  begin
    jSurfaceView(Obj).GenEvent_OnSurfaceViewDraw(Obj, canvas);
  end;
end;

Procedure Java_Event_pOnMediaPlayerPrepared(env: PJNIEnv; this: jobject; Obj: TObject; videoWidth: integer; videoHeigh: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jMediaPlayer then
  begin
    jMediaPlayer(Obj).GenEvent_OnPrepared(Obj, videoWidth, videoHeigh);
  end;
end;

Procedure Java_Event_pOnMediaPlayerVideoSizeChanged(env: PJNIEnv; this: jobject; Obj: TObject; videoWidth: integer; videoHeight: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jMediaPlayer then
  begin
    jMediaPlayer(Obj).GenEvent_OnVideoSizeChanged(Obj, videoWidth, videoHeight);
  end;
end;

Procedure Java_Event_pOnMediaPlayerCompletion(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jMediaPlayer then
  begin
    jMediaPlayer(Obj).GenEvent_OnCompletion(Obj);
  end;
end;

Procedure Java_Event_pOnMediaPlayerTimedText(env: PJNIEnv; this: jobject; Obj: TObject; timedText: JString);
var
   pastimedText:  string;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jMediaPlayer then
  begin
    pastimedText := '';
    if timedText <> nil then
    begin
      jBoo := JNI_False;
      pastimedText:= string( env^.GetStringUTFChars(Env,timedText,@jBoo) );
    end;
    jMediaPlayer(Obj).GenEvent_pOnMediaPlayerTimedText(Obj, pastimedText);
  end;
end;

Procedure Java_Event_pOnSoundPoolLoadComplete(env: PJNIEnv; this: jobject; Obj: TObject; soundId : integer; status: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSoundPool then
  begin
    jSoundPool(Obj).GenEvent_OnLoadComplete(Obj, soundId, status);
  end;
end;

procedure Java_Event_pOnSurfaceViewTouch(env: PJNIEnv; this: jobject;
                              Obj: TObject;
                              act,cnt: integer; x1,y1,x2,y2 : single);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jSurfaceView then
  begin
      jSurfaceView(Obj).GenEvent_OnSurfaceViewTouch(Obj,act,cnt,x1,y1,x2,y2);
  end;
end;


Procedure Java_Event_pOnSurfaceViewChanged(env: PJNIEnv; this: jobject;
                              Obj: TObject; width: integer; height: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSurfaceView then
  begin
    jSurfaceView(Obj).GenEvent_OnSurfaceViewChanged(Obj, width, height);
  end;
end;

function Java_Event_pOnSurfaceViewDrawingInBackground(env: PJNIEnv; this: jobject; Obj: TObject; progress: single): JBoolean;
var
  running: boolean;
begin
  running:= True;
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jSurfaceView then
  begin
      jSurfaceView(Obj).GenEvent_OnSurfaceViewDrawingInBackground(Obj,progress,running);
  end;
  Result:= JBool(running);
end;

procedure Java_Event_pOnSurfaceViewDrawingPostExecute(env: PJNIEnv; this: jobject; Obj: TObject; progress: single);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jSurfaceView then
  begin
      jSurfaceView(Obj).GenEvent_OnSurfaceViewDrawingPostExecute(Obj,progress);
  end;
end;

procedure Java_Event_pOnDrawingViewTouch(env: PJNIEnv; this: jobject; Obj: TObject; action, countPoints: integer;
                              arrayX: jObject; arrayY: jObject; flingGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);
var
  sizeArray: integer;
  arrayResultX: array of single;
  arrayResultY: array of single;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  arrayResultX := nil;
  arrayResultY := nil;

  if not Assigned(Obj)  then Exit;

  if Obj is jDrawingView then
  begin
      sizeArray:= countPoints;
      if arrayX <> nil then
      begin
        //sizeArray:=  env^.GetArrayLength(env, arrayX);
        SetLength(arrayResultX, sizeArray);
        env^.GetFloatArrayRegion(env, arrayX, 0, sizeArray, @arrayResultX[0] {target});
      end;

      if arrayY <> nil then
      begin
        //sizeArray:=  env^.GetArrayLength(env, arrayX);
        SetLength(arrayResultY, sizeArray);
        env^.GetFloatArrayRegion(env, arrayY, 0, sizeArray, @arrayResultY[0] {target});
      end;

      jDrawingView(Obj).GenEvent_OnDrawingViewTouch(Obj,action,countPoints,
                                                    arrayResultX,arrayResultY,
                                                    flingGesture,pinchZoomGestureState, zoomScaleFactor);
  end;
end;

procedure Java_Event_pOnDrawingViewDraw(env: PJNIEnv; this: jobject; Obj: TObject; action, countPoints: integer;
                                   arrayX: jObject; arrayY: jObject; flingGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);
var
  sizeArray: integer;
  arrayResultX: array of single;
  arrayResultY: array of single;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  arrayResultX := nil;
  arrayResultY := nil;

  if not Assigned(Obj)  then Exit;

  if Obj is jDrawingView then
  begin
      sizeArray:= countPoints;
      if arrayX <> nil then
      begin
        //sizeArray:=  env^.GetArrayLength(env, arrayX);
        SetLength(arrayResultX, sizeArray);
        env^.GetFloatArrayRegion(env, arrayX, 0, sizeArray, @arrayResultX[0] {target});
      end;

      if arrayY <> nil then
      begin
        //sizeArray:=  env^.GetArrayLength(env, arrayX);
        SetLength(arrayResultY, sizeArray);
        env^.GetFloatArrayRegion(env, arrayY, 0, sizeArray, @arrayResultY[0] {target});
      end;

      jDrawingView(Obj).GenEvent_OnDrawingViewDraw(Obj,action,countPoints,
                                                    arrayResultX,arrayResultY,
                                                    flingGesture,pinchZoomGestureState, zoomScaleFactor);
  end;
end;

procedure Java_Event_pOnDrawingViewSizeChanged(env: PJNIEnv; this: jobject; Obj: TObject;
                                   width: integer; height: integer; oldWidth: integer; oldHeight: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jDrawingView then
  begin
      jDrawingView(Obj).GenEvent_OnDrawingViewSizeChanged(Obj,width, height, oldWidth, oldHeight);
  end;
end;

procedure Java_Event_pOnRatingBarChanged(env: PJNIEnv; this: jobject; Obj: TObject; rating: single);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jRatingBar then
  begin
      jRatingBar(Obj).GenEvent_OnRatingBarChanged(Obj,rating);
  end;
end;

Procedure Java_Event_pOnContactManagerContactsExecuted(env: PJNIEnv; this: jobject; Obj: TObject; count: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jContactManager then
  begin
      jContactManager(Obj).GenEvent_OnContactManagerContactsExecuted(Obj, count);
  end;
end;

function Java_Event_pOnContactManagerContactsProgress(env: PJNIEnv; this: jobject; Obj: TObject; contactInfo: JString;
                                                                                                 contactShortInfo: JString;
                                                                                                 contactPhotoUriAsString: JString;
                                                                                                 contactPhoto: jObject;
                                                                                                 progress: integer): jBoolean;
var
   pascontact, pascontactShortInfo, pascontactPhotoUriAsString:  string;
   jBoo: jBoolean;
   continueListing: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  continueListing:= True;

  if Obj is jContactManager then
  begin
    pascontact := '';

    if contactInfo <> nil then
    begin
      jBoo := JNI_False;
      pascontact:= string( env^.GetStringUTFChars(Env,contactInfo,@jBoo) );
    end;

    pascontactShortInfo := '';
    if contactShortInfo <> nil then
    begin
      jBoo := JNI_False;
      pascontactShortInfo:= string( env^.GetStringUTFChars(Env,contactShortInfo,@jBoo) );
    end;

    pascontactPhotoUriAsString := '';
    if contactPhotoUriAsString <> nil then
    begin
      jBoo := JNI_False;
      pascontactPhotoUriAsString:= string( env^.GetStringUTFChars(Env,contactPhotoUriAsString,@jBoo) );
    end;

    jContactManager(Obj).GenEvent_OnContactManagerContactsProgress(Obj, pascontact, pascontactShortInfo, pascontactPhotoUriAsString, contactPhoto, progress, continueListing);
  end;
  Result:= JBool(continueListing);
end;

function  Java_Event_pOnGridDrawItemCaptionColor(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JInt;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outColor: dword;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outColor:= 0;
  if Obj is jGridVIew then
  begin
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jGridVIew(Obj).GenEvent_OnDrawItemCaptionColor(Obj, index, pasCaption, outColor);
  end;
  Result:= outColor;
end;

procedure Java_Event_pRadioGroupCheckedChanged(env: PJNIEnv; this: jobject; Obj: TObject; checkedIndex: integer; checkedCaption: JString);
var
  pascheckedCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jRadioGroup then
  begin
    pascheckedCaption := '';
    if checkedCaption <> nil then
    begin
      _jBoolean:= JNI_False;
      pascheckedCaption:= string( env^.GetStringUTFChars(env,checkedCaption,@_jBoolean) );
    end;
    jRadioGroup(Obj).GenEvent_CheckedChanged(Obj, checkedIndex, pascheckedCaption);
  end;
end;

function Java_Event_pOnGridDrawItemBitmap(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JObject;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outBitmap: jObject;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outBitmap:= nil;
  if Obj is jGridVIew then
  begin
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jGridVIew(Obj).GenEvent_OnDrawItemBitmap(Obj, index, pasCaption, outBitmap);
  end;
  Result:= outBitmap;
end;

procedure Java_Event_pOnSeekBarProgressChanged(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer; fromUser: boolean); //deprecated
begin
  Java_Event_pOnSeekBarProgressChanged(env,this,Obj,progress, JBoolean(fromUser));
end;

procedure Java_Event_pOnSeekBarProgressChanged(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer; fromUser: jboolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jSeekBar then
  begin
     jSeekBar(Obj).GenEvent_OnSeekBarProgressChanged(Obj, progress, Boolean(fromUser));
  end;
end;

procedure Java_Event_pOnSeekBarStartTrackingTouch(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jSeekBar then
  begin
    jSeekBar(Obj).GenEvent_OnSeekBarStartTrackingTouch(Obj, progress);
  end;
end;

procedure Java_Event_pOnSeekBarStopTrackingTouch(env: PJNIEnv; this: jobject; Obj: TObject; progress: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj)  then Exit;
  if Obj is jSeekBar then
  begin
     jSeekBar(Obj).GenEvent_OnSeekBarStopTrackingTouch(Obj, progress);
  end;
end;

Procedure Java_Event_pOnClickAutoDropDownItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
var
   pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jAutoTextView then
  begin
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jAutoTextView(Obj).GenEvent_OnClickAutoDropDownItem(Obj, index, pasCaption);
  end;
end;

Procedure Java_Event_pOnClickComboDropDownItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
var
   pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jComboEditText then
  begin
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jComboEditText(Obj).GenEvent_OnClickComboDropDownItem(Obj, index, pasCaption);
  end;
end;

Procedure Java_Event_pOnClickGeneric(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;
  //------------------------------------------------------
  if not (Assigned(Obj)) then Exit;
  if Obj is jAutoTextView then
  begin
    jAutoTextView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jChronometer then
  begin
    jChronometer(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jComboEditText then
  begin
    jComboEditText(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jToolbar then
  begin
    jToolbar(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jsToolbar then   //android support library...
  begin
    jsToolbar(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jsFloatingButton then   //android support library...
  begin
    jsFloatingButton(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jFrameLayout then
  begin
    jFrameLayout(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jSearchView then
  begin
    jSearchView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jZBarcodeScannerView then
  begin
    jZBarcodeScannerView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jsContinuousScrollableImageView then
  begin
    jsContinuousScrollableImageView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

  if Obj is jImageButton then
  begin
    jImageButton(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;

end;

procedure Java_Event_pOnChronometerTick(env: PJNIEnv; this: jobject; Obj: TObject; elapsedTimeMillis: JLong);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jChronometer then
  begin
    jChronometer(Obj).GenEvent_OnChronometerTick(Obj, int64(elapsedTimeMillis));
  end;
end;

Procedure Java_Event_pOnNumberPicker(env: PJNIEnv; this: jobject; Obj: TObject; oldValue: integer; newValue: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jNumberPickerDialog then
  begin
    jNumberPickerDialog(Obj).GenEvent_OnNumberPicker(Obj, oldValue, newValue);
  end;
end;

function Java_Event_pOnUDPSocketReceived(env: PJNIEnv; this: jobject; Obj: TObject;
                               content: JString; fromIP: JString; fromPort: integer): JBoolean;
var
   pascontent, pasfromIP:  string;
   jBoo: jBoolean;
   outListening: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outListening:= True;  //continue listening
  if Obj is jUDPSocket then
  begin
    pascontent := '';
    if content <> nil then
    begin
      jBoo := JNI_False;
      pascontent:= string( env^.GetStringUTFChars(Env,content,@jBoo) );
    end;
    pasfromIP:= '';
    if fromIP <> nil then
    begin
      jBoo := JNI_False;
      pasfromIP:= string( env^.GetStringUTFChars(Env,fromIP,@jBoo) );
    end;
    jUDPSocket(Obj).GenEvent_OnUDPSocketReceived(Obj, pascontent, pasfromIP, fromPort, outListening);
  end;
  Result:= JBool(outListening);
end;

procedure Java_Event_pOnFileSelected(env: PJNIEnv; this: jobject; Obj: TObject; path: JString; fileName: JString);
var
   pasFileName: string;
   pasPath: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jOpenDialog then
  begin
    pasFileName := '';
    if fileName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasFileName:= string( env^.GetStringUTFChars(env,fileName,@_jBoolean) );
    end;

    pasPath := '';
    if path <> nil then
    begin
      _jBoolean:= JNI_False;
      pasPath:= string( env^.GetStringUTFChars(env,path,@_jBoolean) );
    end;

    jOpenDialog(Obj).GenEvent_OnFileSelected(Obj, pasPath, pasFileName);
  end;
end;

procedure Java_Event_pOnMikrotikAsyncReceive(env: PJNIEnv; this: jobject; Obj: TObject; delimitedContent: JString; delimiter: JString );
var
   pasdelimitedContent: string;
   pasdelimiter: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jcMikrotikRouterOS then
  begin
    pasdelimitedContent:= '';
    if delimitedContent <> nil then
    begin
      _jBoolean:= JNI_False;
      pasdelimitedContent:= string( env^.GetStringUTFChars(env,delimitedContent,@_jBoolean) );
    end;

    pasdelimiter := '';
    if delimiter <> nil then
    begin
      _jBoolean:= JNI_False;
      pasdelimiter:= string( env^.GetStringUTFChars(env,delimiter,@_jBoolean) );
    end;

    jcMikrotikRouterOS(Obj).GenEvent_OnMikrotikAsyncReceive(Obj, pasdelimitedContent, pasdelimiter);
  end;
end;


Procedure Java_Event_pOnExpandableListViewGroupExpand(env: PJNIEnv; this: jobject; Obj: TObject;
                                                           groupPosition: integer; groupHeader: JString);
var
  pasgroupHeader: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jExpandableListView then
  begin
    pasgroupHeader := '';
    if groupHeader <> nil then
    begin
      _jBoolean:= JNI_False;
      pasgroupHeader:= string( env^.GetStringUTFChars(env,groupHeader,@_jBoolean) );
    end;
    jExpandableListView(Obj).GenEvent_OnGroupExpand(Obj, groupPosition, pasgroupHeader);
  end;

end;

Procedure Java_Event_pOnClickNavigationViewItem(env: PJNIEnv; this: jobject; Obj: TObject;  itemIndex: integer; itemCaption: JString);
var
  pasitemCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsNavigationView then
  begin
    pasitemCaption := '';
    if itemCaption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasitemCaption:= string( env^.GetStringUTFChars(env,itemCaption,@_jBoolean) );
    end;
    jsNavigationView(Obj).GenEvent_OnClickNavigationViewItem(Obj, itemIndex, pasitemCaption);
  end;
end;

Procedure Java_Event_pOnClickBottomNavigationViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);
var
  pasitemCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsBottomNavigationView then
  begin
    pasitemCaption := '';
    if itemCaption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasitemCaption:= string( env^.GetStringUTFChars(env,itemCaption,@_jBoolean) );
    end;
    jsBottomNavigationView(Obj).GenEvent_OnClickNavigationViewItem(Obj, itemIndex, pasitemCaption);
  end;
end;

Procedure Java_Event_pOnClickTreeViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);
var
  pasitemCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTreeListView then
  begin
    pasitemCaption := '';
    if itemCaption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasitemCaption:= string( env^.GetStringUTFChars(env,itemCaption,@_jBoolean) );
    end;
    jTreeListView(Obj).GenEvent_OnClickTreeViewItem(Obj, itemIndex, pasitemCaption);
  end;
end;


Procedure Java_Event_pOnLongClickTreeViewItem(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer; itemCaption: JString);
var
  pasitemCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTreeListView then
  begin
    pasitemCaption := '';
    if itemCaption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasitemCaption:= string( env^.GetStringUTFChars(env,itemCaption,@_jBoolean) );
    end;
    jTreeListView(Obj).GenEvent_OnLongClickTreeViewItem(Obj, itemIndex, pasitemCaption);
  end;
end;


Procedure Java_Event_pOnExpandableListViewGroupCollapse(env: PJNIEnv; this: jobject; Obj: TObject;
                                                           groupPosition: integer; groupHeader: JString);
var
  pasgroupHeader: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jExpandableListView then
  begin
    pasgroupHeader := '';
    if groupHeader <> nil then
    begin
      _jBoolean:= JNI_False;
      pasgroupHeader:= string( env^.GetStringUTFChars(env,groupHeader,@_jBoolean) );
    end;
    jExpandableListView(Obj).GenEvent_OnGroupCollapse(Obj, groupPosition, pasgroupHeader);
  end;

end;

Procedure Java_Event_pOnExpandableListViewChildClick(env: PJNIEnv; this: jobject; Obj: TObject;
                                                          groupPosition: integer; groupHeader:JString;
                                                          childItemPosition: integer;
                                                          childItemCaption: JString);
var
  pasgroupHeader: string;
  paschildItemCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jExpandableListView then
  begin
    pasgroupHeader := '';
    if groupHeader <> nil then
    begin
      _jBoolean:= JNI_False;
      pasgroupHeader:= string( env^.GetStringUTFChars(env,groupHeader,@_jBoolean) );
    end;

    paschildItemCaption := '';
    if childItemCaption <> nil then
    begin
      _jBoolean:= JNI_False;
      paschildItemCaption:= string( env^.GetStringUTFChars(env,childItemCaption,@_jBoolean) );
    end;

    jExpandableListView(Obj).GenEvent_OnChildClick(Obj, groupPosition, pasgroupHeader, childItemPosition, paschildItemCaption);
  end;

end;

Procedure Java_Event_pOnGL2SurfaceCreate(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jGL2SurfaceView then
  begin
    jGL2SurfaceView(Obj).GenEvent_OnGL2SurfaceCreate(Obj);
  end;
end;

Procedure Java_Event_pOnGL2SurfaceDestroyed(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jGL2SurfaceView then
  begin
    jGL2SurfaceView(Obj).GenEvent_OnGL2SurfaceDestroyed(Obj);
  end;
end;

Procedure Java_Event_pOnGL2SurfaceChanged(env: PJNIEnv; this: jobject; Obj: TObject; width: integer; height: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jGL2SurfaceView then
  begin
    jGL2SurfaceView(Obj).GenEvent_OnGL2SurfaceChanged(Obj, width, height);
  end;
end;

Procedure Java_Event_pOnGL2SurfaceDrawFrame(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jGL2SurfaceView then
  begin
    jGL2SurfaceView(Obj).GenEvent_OnGL2SurfaceDrawFrame(Obj);
  end;
end;

Procedure Java_Event_pOnGL2SurfaceTouch(env: PJNIEnv; this: jobject; Obj: TObject;
                                        action, countPoints: integer;
                                        arrayX: jObject; arrayY: jObject;
                                        flingGesture: integer; pinchZoomGestureState: integer;
                                        zoomScaleFactor: single);

var
  sizeArray: integer;
  arrayResultX: array of single;
  arrayResultY: array of single;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  arrayResultX := nil;
  arrayResultY := nil;

  if not Assigned(Obj)  then Exit;

  if Obj is jGL2SurfaceView then
  begin
      sizeArray:= countPoints;
      if arrayX <> nil then
      begin
        //sizeArray:=  env^.GetArrayLength(env, arrayX);
        SetLength(arrayResultX, sizeArray);
        env^.GetFloatArrayRegion(env, arrayX, 0, sizeArray, @arrayResultX[0] {target});
      end;

      if arrayY <> nil then
      begin
        //sizeArray:=  env^.GetArrayLength(env, arrayX);
        SetLength(arrayResultY, sizeArray);
        env^.GetFloatArrayRegion(env, arrayY, 0, sizeArray, @arrayResultY[0] {target});
      end;

      jGL2SurfaceView(Obj).GenEvent_OnGL2SurfaceTouch(Obj,action,countPoints,
                                                    arrayResultX,arrayResultY,
                                                    flingGesture,pinchZoomGestureState, zoomScaleFactor);
  end;
end;

//Updated by ADiV
Procedure Java_Event_pOnRecyclerViewItemClick(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemClick(Obj, itemIndex);
  end;
end;

// By ADiV
Procedure Java_Event_pOnRecyclerViewItemLongClick(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemLongClick(Obj, itemIndex);
  end;
end;

// By ADiV
Procedure Java_Event_pOnRecyclerViewItemTouchUp(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemTouchUp(Obj, itemIndex);
  end;
end;

// By ADiV
Procedure Java_Event_pOnRecyclerViewItemTouchDown(env: PJNIEnv; this: jobject; Obj: TObject; itemIndex: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemTouchDown(Obj, itemIndex);
  end;
end;

Procedure Java_Event_pOnSTabSelected(env: PJNIEnv; this: jobject; Obj: TObject; position: integer;  title: JString);
var
  pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsTabLayout then
  begin
    pastitle := '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string( env^.GetStringUTFChars(env,title,@_jBoolean) );
    end;
    jsTabLayout(Obj).GenEvent_OnSTabSelected(Obj, position, pastitle);
  end;
end;

procedure Java_Event_pOnCustomCameraSurfaceChanged(env: PJNIEnv; this: jobject; Obj: TObject; width: integer; height: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jCustomCamera then
  begin
    jCustomCamera(Obj).GenEvent_OnCustomCameraSurfaceChanged(Obj, width, height);
  end;
end;

Procedure Java_Event_pOnCustomCameraPictureTaken(env: PJNIEnv; this: jobject; Obj: TObject; picture: JObject; fullPath: JString);
var
  pasfullPath: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jCustomCamera then
  begin
    pasfullPath := '';
    if fullPath <> nil then
    begin
      _jBoolean:= JNI_False;
      pasfullPath:= string( env^.GetStringUTFChars(env,fullPath,@_jBoolean) );
    end;
    jCustomCamera(Obj).GenEvent_OnCustomCameraPictureTaken(Obj, picture, pasfullPath);
  end;
end;

Procedure Java_Event_pOnSearchViewFocusChange(env: PJNIEnv; this: jobject; Obj: TObject; hasFocus: jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSearchView then
  begin
    jSearchView(Obj).GenEvent_OnSearchViewFocusChange(Obj, Boolean(hasFocus));
  end;
end;


Procedure Java_Event_pOnSearchViewQueryTextSubmit(env: PJNIEnv; this: jobject; Obj: TObject; query: JString);
var
  pasquery: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSearchView then
  begin
    pasquery := '';
    if query <> nil then
    begin
      _jBoolean:= JNI_False;
      pasquery:= string( env^.GetStringUTFChars(env,query,@_jBoolean) );
    end;
    jSearchView(Obj).GenEvent_OnSearchViewQueryTextSubmit(Obj, pasquery);
  end;
end;

Procedure Java_Event_pOnSearchViewQueryTextChange(env: PJNIEnv; this: jobject; Obj: TObject; newText: JString );
var
  pasnewText: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jSearchView then
  begin
    pasnewText := '';
    if newText <> nil then
    begin
      _jBoolean:= JNI_False;
      pasnewText:= string( env^.GetStringUTFChars(env,newText,@_jBoolean) );
    end;
    jSearchView(Obj).GenEvent_OnSearchViewQueryTextChange(Obj, pasnewText);
  end;
end;

procedure Java_Event_pOnClickX(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSearchView then
  begin
    jSearchView(Sender).GenEvent_OnClickX(Sender);
  end;
end;

Procedure Java_Event_pOnTelephonyCallStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; state: integer; phoneNumber: JString );
var
  pasPhoneNumber: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTelephonyManager then
  begin
    pasPhoneNumber := '';
    if phoneNumber <> nil then
    begin
      _jBoolean:= JNI_False;
      pasPhoneNumber:= string( env^.GetStringUTFChars(env,phoneNumber,@_jBoolean) );
    end;
    jTelephonyManager(Obj).GenEvent_OnTelephonyCallStateChanged(Obj, TTelephonyCallState(state), pasPhoneNumber);
  end;
end;

Procedure Java_Event_pOnGetUidTotalMobileBytesFinished(env: PJNIEnv; this: jobject; Obj: TObject; bytesResult: JLong; uid: integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTelephonyManager then
  begin
    jTelephonyManager(Obj).GenEvent_OnGetUidTotalMobileBytesFinished(Obj, int64(bytesResult), uid);
  end;
end;

Procedure Java_Event_pOnGetUidTotalWifiBytesFinished(env: PJNIEnv; this: jobject; Obj: TObject; bytesResult: JLong; uid: integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTelephonyManager then
  begin
    jTelephonyManager(Obj).GenEvent_OnGetUidTotalWifiBytesFinished(Obj, int64(bytesResult), uid);
  end;
end;


// UPDATED by [ADiV]
Procedure Java_Event_pOnRecyclerViewItemWidgetClick(env: PJNIEnv; this: jobject; Obj: TObject;
                                                    itemIndex: integer; widgetClass: integer;
                                                    widgetId: integer; status: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemWidgetClick(Obj,itemIndex, TItemContentFormat(widgetClass),widgetId, TItemWidgetStatus(status));
  end;
end;

// By [ADiV]
Procedure Java_Event_pOnRecyclerViewItemWidgetLongClick(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      itemIndex: integer; widgetClass: integer;
                                                      widgetId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemWidgetLongClick(Obj,itemIndex, TItemContentFormat(widgetClass),widgetId);
  end;
end;

// By [ADiV]
Procedure Java_Event_pOnRecyclerViewItemWidgetTouchUp(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      itemIndex: integer; widgetClass: integer;
                                                      widgetId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemWidgetTouchUp(Obj,itemIndex, TItemContentFormat(widgetClass),widgetId);
  end;
end;

// By [ADiV]
Procedure Java_Event_pOnRecyclerViewItemWidgetTouchDown(env: PJNIEnv; this: jobject; Obj: TObject;
                                                      itemIndex: integer; widgetClass: integer;
                                                      widgetId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jsRecyclerView then
  begin
    jsRecyclerView(Obj).GenEvent_OnRecyclerViewItemWidgetTouchDown(Obj,itemIndex, TItemContentFormat(widgetClass),widgetId);
  end;
end;

Procedure Java_Event_pOnZBarcodeScannerViewResult(env: PJNIEnv; this: jobject; Obj: TObject;
                                                    codedata: JString; codetype: integer);

var
  _jBoolean: JBoolean;
  pascodedata: string;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jZBarcodeScannerView then
  begin
    pascodedata := '';
    if codedata <> nil then
    begin
      _jBoolean:= JNI_False;
      pascodedata:= string( env^.GetStringUTFChars(env,codedata,@_jBoolean) );
    end;
    jZBarcodeScannerView(Obj).GenEvent_OnZBarcodeScannerViewResult(Obj,pascodedata, codetype);
  end;
end;

procedure Java_Event_pOnMidiManagerDeviceAdded(env:PJNIEnv;this:JObject;Sender:TObject;deviceId:integer;deviceName:jString;productId:jString;manufacture:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jMidiManager then
  begin
    jMidiManager(Sender).GenEvent_OnMidiManagerDeviceAdded(Sender,deviceId,GetString(env,deviceName),GetString(env,productId),GetString(env,manufacture));
  end;
end;

procedure Java_Event_pOnMidiManagerDeviceRemoved(env:PJNIEnv;this:JObject;Sender:TObject;deviceId:integer;deviceName:jString;productId:jString;manufacture:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jMidiManager then
  begin
    jMidiManager(Sender).GenEvent_OnMidiManagerDeviceRemoved(Sender,deviceId,GetString(env,deviceName),GetString(env,productId),GetString(env,manufacture));
  end;
end;

function Java_Event_pOnOpenMapViewRoadDraw(env:PJNIEnv;this:JObject;Sender:TObject;roadCode:integer;roadStatus:integer; roadDuration:double;roadDistance:double):jintArray;
var
  outReturn: TDynArrayOfInteger;
  outReturnColor: dword;
  outReturnWidth: integer;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outReturn:=nil;
  if Sender is jcOpenMapView then
  begin
    jcOpenMapView(Sender).GenEvent_OnOpenMapViewRoadDraw(Sender,roadCode,roadStatus,roadDuration,roadDistance,outReturnColor,outReturnWidth);
  end;
  SetLength(outReturn, 2);
  outReturn[0]:= outReturnColor;
  outReturn[1]:= outReturnWidth;
  Result:=GetJObjectOfDynArrayOfInteger(env,outReturn);
  SetLength(outReturn, 0);
end;

procedure Java_Event_pOnOpenMapViewClick(env:PJNIEnv;this:JObject;Sender:TObject;latitude:double;longitude:double);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcOpenMapView then
  begin
    jcOpenMapView(Sender).GenEvent_OnOpenMapViewClick(Sender,latitude,longitude);
  end;
end;

procedure Java_Event_pOnOpenMapViewLongClick(env:PJNIEnv;this:JObject;Sender:TObject;latitude:double;longitude:double);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcOpenMapView then
  begin
    jcOpenMapView(Sender).GenEvent_OnOpenMapViewLongClick(Sender,latitude,longitude);
  end;
end;

procedure Java_Event_pOnOpenMapViewMarkerClick(env:PJNIEnv;this:JObject;Sender:TObject;title:jString;latitude:double;longitude:double);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcOpenMapView then
  begin
    jcOpenMapView(Sender).GenEvent_OnOpenMapViewMarkerClick(Sender,GetString(env,title),latitude,longitude);
  end;
end;

procedure Java_Event_pOnSignaturePadStartSigning(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcSignaturePad then
  begin
    jcSignaturePad(Sender).GenEvent_OnSignaturePadStartSigning(Sender);
  end;
end;

procedure Java_Event_pOnSignaturePadSigned(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcSignaturePad then
  begin
    jcSignaturePad(Sender).GenEvent_OnSignaturePadSigned(Sender);
  end;
end;

procedure Java_Event_pOnSignaturePadClear(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcSignaturePad then
  begin
    jcSignaturePad(Sender).GenEvent_OnSignaturePadClear(Sender);
  end;
end;

procedure Java_Event_pOnMailMessageRead(env:PJNIEnv;this:JObject;Sender:TObject;position:integer;Header:jString;Date:jString;Subject:jString;ContentType:jString;ContentText:jString;Attachments:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcMail then
  begin
    jcMail(Sender).GenEvent_OnMailMessageRead(Sender,position,GetString(env,Header),GetString(env,Date),GetString(env,Subject),GetString(env,ContentType),GetString(env,ContentText),GetString(env,Attachments));
  end;
end;

procedure Java_Event_pOnMailMessagesCount(env:PJNIEnv;this:JObject;Sender:TObject;count:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcMail then
  begin
    jcMail(Sender).GenEvent_OnMailMessagesCount(Sender,count);
  end;
end;

procedure Java_Event_pOnSFTPClientTryConnect(env:PJNIEnv;this:JObject;Sender:TObject;success:jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSFTPClient then
  begin
    jSFTPClient(Sender).GenEvent_OnSFTPClientTryConnect(Sender,boolean(success));
  end;
end;

procedure Java_Event_pOnSFTPClientDownloadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSFTPClient then
  begin
    jSFTPClient(Sender).GenEvent_OnSFTPClientDownloadFinished(Sender,GetString(env,destination),boolean(success));
  end;
end;

procedure Java_Event_pOnSFTPClientUploadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSFTPClient then
  begin
    jSFTPClient(Sender).GenEvent_OnSFTPClientUploadFinished(Sender,GetString(env,destination),boolean(success));
  end;
end;

procedure Java_Event_pOnSFTPClientListing(env:PJNIEnv;this:JObject;Sender:TObject;remotePath:jString;fileName:jString;fileSize:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSFTPClient then
  begin
    jSFTPClient(Sender).GenEvent_OnSFTPClientListing(Sender,GetString(env,remotePath),GetString(env,fileName),fileSize);
  end;
end;

procedure Java_Event_pOnSFTPClientListed(env:PJNIEnv;this:JObject;Sender:TObject;count:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSFTPClient then
  begin
    jSFTPClient(Sender).GenEvent_OnSFTPClientListed(Sender,count);
  end;
end;

procedure Java_Event_pOnFTPClientTryConnect(env:PJNIEnv;this:JObject;Sender:TObject;success:jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jFTPClient then
  begin
    jFTPClient(Sender).GenEvent_OnFTPClientTryConnect(Sender,boolean(success));
  end;
end;

procedure Java_Event_pOnFTPClientDownloadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jFTPClient then
  begin
    jFTPClient(Sender).GenEvent_OnFTPClientDownloadFinished(Sender,GetString(env,destination),boolean(success));
  end;
end;

procedure Java_Event_pOnFTPClientUploadFinished(env:PJNIEnv;this:JObject;Sender:TObject;destination:jString;success:jBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jFTPClient then
  begin
    jFTPClient(Sender).GenEvent_OnFTPClientUploadFinished(Sender,GetString(env,destination),boolean(success));
  end;
end;

procedure Java_Event_pOnFTPClientListing(env:PJNIEnv;this:JObject;Sender:TObject;remotePath:jString;fileName:jString;fileSize:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jFTPClient then
  begin
    jFTPClient(Sender).GenEvent_OnFTPClientListing(Sender,GetString(env,remotePath),GetString(env,fileName),fileSize);
  end;
end;

procedure Java_Event_pOnFTPClientListed(env:PJNIEnv;this:JObject;Sender:TObject;count:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jFTPClient then
  begin
    jFTPClient(Sender).GenEvent_OnFTPClientListed(Sender,count);
  end;
end;

procedure Java_Event_pOnBluetoothSPPDataReceived(env:PJNIEnv;this:JObject;Sender:TObject;jbyteArrayData:jbyteArray;messageData:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
    jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPDataReceived(Sender,GetDynArrayOfJByte(env,jbyteArrayData),GetString(env,messageData));
  end;
end;

procedure Java_Event_pOnBluetoothSPPDeviceConnected(env:PJNIEnv;this:JObject;Sender:TObject;deviceName:jString;deviceAddress:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
    jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPDeviceConnected(Sender,GetString(env,deviceName),GetString(env,deviceAddress));
  end;
end;

procedure Java_Event_pOnBluetoothSPPDeviceDisconnected(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
    jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPDeviceDisconnected(Sender);
  end;
end;

procedure Java_Event_pOnBluetoothSPPDeviceConnectionFailed(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
    jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPDeviceConnectionFailed(Sender);
  end;
end;

procedure Java_Event_pOnBluetoothSPPServiceStateChanged(env:PJNIEnv;this:JObject;Sender:TObject;serviceState:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
    jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPServiceStateChanged(Sender, serviceState);
  end;
end;

procedure Java_Event_pOnBluetoothSPPListeningNewAutoConnection(env:PJNIEnv;this:JObject;Sender:TObject;deviceName:jString;deviceAddress:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
    jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPListeningNewAutoConnection(Sender,GetString(env,deviceName),GetString(env,deviceAddress));
  end;
end;

procedure Java_Event_pOnBluetoothSPPAutoConnectionStarted(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcBluetoothSPP then
  begin
   jcBluetoothSPP(Sender).GenEvent_OnBluetoothSPPAutoConnectionStarted(Sender);
  end;
end;

procedure Java_Event_pOnDirectorySelected(env:PJNIEnv;this:JObject;Sender:TObject;path:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSelectDirectoryDialog then
  begin
    jSelectDirectoryDialog(Sender).GenEvent_OnDirectorySelected(Sender,GetString(env,path));
  end;
end;

procedure Java_Event_pOnMsSqlJDBCConnectionExecuteQueryAsync(env:PJNIEnv;this:JObject;Sender:TObject;messageStatus:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jMsSqlJDBCConnection then
  begin
    jMsSqlJDBCConnection(Sender).GenEvent_OnMsSqlJDBCConnectionExecuteQueryAsync(Sender,GetString(env,messageStatus));
  end;
end;

procedure Java_Event_pOnMsSqlJDBCConnectionOpenAsync(env:PJNIEnv;this:JObject;Sender:TObject;messageStatus:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jMsSqlJDBCConnection then
  begin
    jMsSqlJDBCConnection(Sender).GenEvent_OnMsSqlJDBCConnectionOpenAsync(Sender,GetString(env,messageStatus));
  end;
end;

procedure Java_Event_pOnMsSqlJDBCConnectionExecuteUpdateAsync(env:PJNIEnv;this:JObject;Sender:TObject;messageStatus:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jMsSqlJDBCConnection then
  begin
    jMsSqlJDBCConnection(Sender).GenEvent_OnMsSqlJDBCConnectionExecuteUpdateAsync(Sender,GetString(env,messageStatus));
  end;
end;

//jCustomSpeechToText
procedure Java_Event_pOnBeginOfSpeech(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jCustomSpeechToText then
  begin
    jCustomSpeechToText(Sender).GenEvent_OnBeginOfSpeech(Sender);
  end;
end;
procedure Java_Event_pOnSpeechBufferReceived(env:PJNIEnv;this:JObject;Sender:TObject;txtBytes:jbyteArray);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jCustomSpeechToText then
  begin
   jCustomSpeechToText(Sender).GenEvent_OnSpeechBufferReceived(Sender,GetDynArrayOfJByte(env,txtBytes));
  end;
end;
procedure Java_Event_pOnEndOfSpeech(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jCustomSpeechToText then
  begin
    jCustomSpeechToText(Sender).GenEvent_OnEndOfSpeech(Sender);
  end;
end;
procedure Java_Event_pOnSpeechResults(env:PJNIEnv;this:JObject;Sender:TObject;txt:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jCustomSpeechToText then
  begin
    jCustomSpeechToText(Sender).GenEvent_OnSpeechResults(Sender,GetString(env,txt));
  end;
end;

procedure Java_Event_pOnBillingClientEvent(env:PJNIEnv; this:JObject; Obj: TObject; xml: JString);
var
  pasStr: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  pasStr := '';
  if xml <> nil then begin
    _jBoolean := JNI_False;
    pasStr    := String( env^.GetStringUTFChars(Env,xml,@_jBoolean) );
  end;

  jcBillingClient(Obj).GenEvent_OnBillingClientEvent(pasStr);
end;

//jcToyTimerService
procedure Java_Event_pOnToyTimerServicePullElapsedTime(env:PJNIEnv;this:JObject;Sender:TObject;elapsedTime:int64);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jcToyTimerService then
  begin
    jcToyTimerService(Sender).GenEvent_OnToyTimerServicePullElapsedTime(Sender,elapsedTime);
  end;
end;

//jBluetoothLowEnergy
procedure Java_Event_pOnBluetoothLEConnected(env:PJNIEnv;this:JObject;Sender:TObject;deviceName:jString;deviceAddress:jString;bondState:integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jBluetoothLowEnergy then
  begin
    jBluetoothLowEnergy(Sender).GenEvent_OnBluetoothLEConnected(Sender,GetString(env,deviceName),GetString(env,deviceAddress),bondState);
  end;
end;
procedure Java_Event_pOnBluetoothLEScanCompleted(env:PJNIEnv;this:JObject;Sender:TObject;deviceNameArray:jstringArray;deviceAddressArray:jstringArray);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jBluetoothLowEnergy then
  begin
     jBluetoothLowEnergy(Sender).GenEvent_OnBluetoothLEScanCompleted(Sender,GetDynArrayOfString(env,deviceNameArray),GetDynArrayOfString(env,deviceAddressArray));
  end;
end;
procedure Java_Event_pOnBluetoothLEServiceDiscovered(env:PJNIEnv;this:JObject;Sender:TObject;serviceIndex:integer;serviceUUID:jString;characteristicUUIDArray:jstringArray);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jBluetoothLowEnergy then
  begin
    jBluetoothLowEnergy(Sender).GenEvent_OnBluetoothLEServiceDiscovered(Sender,serviceIndex,GetString(env,serviceUUID),GetDynArrayOfString(env,characteristicUUIDArray));
  end;
end;
procedure Java_Event_pOnBluetoothLECharacteristicChanged(env:PJNIEnv;this:JObject;Sender:TObject;strValue:jString;strCharacteristic:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jBluetoothLowEnergy then
  begin
    jBluetoothLowEnergy(Sender).GenEvent_OnBluetoothLECharacteristicChanged(Sender,GetString(env,strValue),GetString(env,strCharacteristic));
  end;
end;
procedure Java_Event_pOnBluetoothLECharacteristicRead(env:PJNIEnv;this:JObject;Sender:TObject;strValue:jString;strCharacteristic:jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jBluetoothLowEnergy then
  begin
    jBluetoothLowEnergy(Sender).GenEvent_OnBluetoothLECharacteristicRead(Sender,GetString(env,strValue),GetString(env,strCharacteristic));
  end;
end;

//jsFirebasePushNotificationListener
procedure Java_Event_pOnGetTokenComplete(env:PJNIEnv;this:JObject;Sender:TObject;token:jString;isSuccessful:jBoolean;statusMessage:jString);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jsFirebasePushNotificationListener then
  begin
    jsFirebasePushNotificationListener(Sender).GenEvent_OnGetTokenComplete(Sender,GetString(env,token),boolean(isSuccessful),GetString(env,statusMessage));
  end;
end;

//jBatteryManager
procedure Java_Event_pOnBatteryCharging(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer;pluggedBy:integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jBatteryManager then
  begin
    jBatteryManager(Sender).GenEvent_OnBatteryCharging(Sender,batteryAtPercentLevel,pluggedBy);
  end;
end;
procedure Java_Event_pOnBatteryDisCharging(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jBatteryManager then
  begin
    jBatteryManager(Sender).GenEvent_OnBatteryDisCharging(Sender,batteryAtPercentLevel);
  end;
end;
procedure Java_Event_pOnBatteryFull(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jBatteryManager then
  begin
    jBatteryManager(Sender).GenEvent_OnBatteryFull(Sender,batteryAtPercentLevel);
  end;
end;
procedure Java_Event_pOnBatteryUnknown(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jBatteryManager then
  begin
    jBatteryManager(Sender).GenEvent_OnBatteryUnknown(Sender,batteryAtPercentLevel);
  end;
end;
procedure Java_Event_pOnBatteryNotCharging(env:PJNIEnv;this:JObject;Sender:TObject;batteryAtPercentLevel:integer);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jBatteryManager then
  begin
    jBatteryManager(Sender).GenEvent_OnBatteryNotCharging(Sender,batteryAtPercentLevel);
  end;
end;

procedure Java_Event_pOnModbusConnect(env:PJNIEnv;this:JObject;Sender:TObject;success:jBoolean;msg:jString);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jModbus then
  begin
   jModbus(Sender).GenEvent_OnModbusConnect(Sender,boolean(success),GetString(env,msg));
  end;
end;

procedure Java_Event_pWebSocketClientOnOpen(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnOpen(Sender);
  end;
end;

procedure Java_Event_pWebSocketClientOnTextReceived(env:PJNIEnv;this:JObject;Sender:TObject;msgContent:jString);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnTextReceived(Sender,GetString(env,msgContent));
  end;
end;

procedure Java_Event_pWebSocketClientOnBinaryReceived(env:PJNIEnv;this:JObject;Sender:TObject;data:jbyteArray);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnBinaryReceived(Sender,GetDynArrayOfJByte(env,data));
  end;
end;

procedure Java_Event_pWebSocketClientOnPingReceived(env:PJNIEnv;this:JObject;Sender:TObject;data:jbyteArray);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnPingReceived(Sender,GetDynArrayOfJByte(env,data));
  end;
end;

procedure Java_Event_pWebSocketClientOnPongReceived(env:PJNIEnv;this:JObject;Sender:TObject;data:jbyteArray);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnPongReceived(Sender,GetDynArrayOfJByte(env,data));
  end;
end;

procedure Java_Event_pWebSocketClientOnException(env:PJNIEnv;this:JObject;Sender:TObject;exceptionMessage:jString);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnException(Sender,GetString(env,exceptionMessage));
  end;
end;

procedure Java_Event_pWebSocketClientOnCloseReceived(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis:= this;

  if Sender is jcWebSocketClient then
  begin
    jcWebSocketClient(Sender).GenEvent_WebSocketClientOnCloseReceived(Sender);
  end;
end;

procedure Java_Event_pOnArduinoAflakSerialAttached(env:PJNIEnv;this:JObject;Sender:TObject;usb:JObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Sender is jsArduinoAflakSerial then
  begin
    jsArduinoAflakSerial(Sender).GenEvent_OnArduinoAflakSerialAttached(Sender,usb);
  end;
end;
procedure Java_Event_pOnArduinoAflakSerialDetached(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Sender is jsArduinoAflakSerial then
  begin
    jsArduinoAflakSerial(Sender).GenEvent_OnArduinoAflakSerialDetached(Sender);
  end;
end;
procedure Java_Event_pOnArduinoAflakSerialMessageReceived(env:PJNIEnv;this:JObject;Sender:TObject;jbytesReceived:jbyteArray);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Sender is jsArduinoAflakSerial then
  begin
    jsArduinoAflakSerial(Sender).GenEvent_OnArduinoAflakSerialMessageReceived(Sender,GetDynArrayOfJByte(env,jbytesReceived));
  end;
end;
procedure Java_Event_pOnArduinoAflakSerialOpened(env:PJNIEnv;this:JObject;Sender:TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Sender is jsArduinoAflakSerial then
  begin
    jsArduinoAflakSerial(Sender).GenEvent_OnArduinoAflakSerialOpened(Sender);
  end;
end;

procedure Java_Event_pOnArduinoAflakSerialStatusChanged(env:PJNIEnv;this:JObject;Sender:TObject;statusMessage:jString);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Sender is jsArduinoAflakSerial then
  begin
    jsArduinoAflakSerial(Sender).GenEvent_OnArduinoAflakSerialStatusChanged(Sender,GetString(env,statusMessage));
  end;
end;

end.
