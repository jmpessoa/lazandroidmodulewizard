unit register_extras;
  
{$mode objfpc}{$H+}
  
interface

//please, do not change this code format/layout!

uses
  Classes,
  bluetoothlowenergy,
  netapi,
  barcodegen,
  ussdservice,
  customspeechtotext,
  selectdirectorydialog,
  ftpclient,
  sftpclient,
  brightness,
  soundpool,
  wifimanager,
  midimanager,
  expression,
  mssqljdbcconnection,
  oraclejdbcconnection,
  uploadservice,
  xlswriter,
  telephonymanager,
  smsmanager,
  modaldialog,
  incomingcallwidgetprovider,
  smswidgetprovider,
  speechtotext,
  texttospeech,
  gmaps,
  windowmanager,
  opendialog,
  fileprovider,
  udpsocket,
  numberpicker,
  activitylauncher,
  mediaplayer,
  mediarecorder,
  downloadmanager,
  downloadservice,
  location,
  sharefile,
  alarmmanager,
  tcpsocketclient,
  textfilemanager,
  imagefilemanager,
  intentmanager,
  broadcastreceiver,
  notificationmanager,
  preferences,
  contactmanager,
  sensormanager,
  datepickerdialog,
  timepickerdialog,
  bluetooth,
  bluetoothclientsocket,
  bluetoothserversocket,
  shellcommand,
  dumpjavamethods,
  myhello,
  Laz_And_Controls, 
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin
  {$I jnetapi_icon.lrs}
  {$I jbarcodegen_icon.lrs}
  {$I jussdservice_icon.lrs}
  {$I jftpclient_icon.lrs}
  {$I jsftpclient_icon.lrs}
  {$I jbrightness_icon.lrs}
  {$I jsoundpool_icon.lrs}
  {$I jwifimanager_icon.lrs}
  {$I jexpression_icon.lrs}
  {$I jxlswriter_icon.lrs}
  {$I jmodaldialog_icon.lrs}
  {$I jincomingcallwidgetprovider_icon.lrs}
  {$I jsmswidgetprovider_icon.lrs}
  {$I jspeechtotext_icon.lrs}
  {$I jtexttospeech_icon.lrs}
  {$I jcustomspeechtotext_icon.lrs}
  {$I jmaps_icon.lrs}
  {$I jwindowmanager_icon.lrs}
  {$I jselectdirectorydialog_icon.lrs}
  {$I jopendialog_icon.lrs}
  {$I jfileprovider_icon.lrs}
  {$I judpsocket_icon.lrs}
  {$I jnumberpickerdialog_icon.lrs}
  {$I jactivitylauncher_icon.lrs}
  {$I jdatepickerdialog_icon.lrs}
  {$I jtimepickerdialog_icon.lrs}
  {$I jDialogYN_icon.lrs}
  {$I jDialogProgress_icon.lrs}
  {$I jmediaplayer_icon.lrs}
  {$I jmidimanager_icon.lrs}
  {$I jmediarecorder_icon.lrs}
  {$I jdownloadmanager_icon.lrs}
  {$I jdownloadservice_icon.lrs}
  {$I juploadservice_icon.lrs}
  {$I jcamera_icon.lrs}
  {$I jtelephonymanager_icon.lrs}
  {$I jsmsmanager_icon.lrs}
  {$I jsms_icon.lrs}
  {$I jlocation_icon.lrs}
  {$I jsharefile_icon.lrs}
  {$I jalarmmanager_icon.lrs}
  {$I jtextfilemanager_icon.lrs}
  {$I jimagefilemanager_icon.lrs}
  {$I jintentmanager_icon.lrs}
  {$I jbroadcastreceiver_icon.lrs}
  {$I jnotificationmanager_icon.lrs}
  {$I jpreferences_icon.lrs}
  {$I jcontactmanager_icon.lrs}
  {$I jsensormanager_icon.lrs}
  {$I jhttpclient_icon.lrs}
  {$I jsmtpclient_icon.lrs}
  {$I jtcpsocketclient_icon.lrs}
  {$I jAsyncTask_icon.lrs}
  {$I jTimer_icon.lrs}
  {$I jbluetooth_icon.lrs}
  {$I jbluetoothclientsocket_icon.lrs}
  {$I jbluetoothserversocket_icon.lrs}
  {$I jbluetoothlowenergy_icon.lrs}
  {$I jsqlitedataaccess_icon.lrs}
  {$I jsqlitecursor_icon.lrs}
  {$I joraclejdbcconnection_icon.lrs}
  {$I jmssqljdbcconnection_icon.lrs}
  {$I jshellcommand_icon.lrs}
  {$I jdumpjavamethods_icon.lrs}
  {$I jmyhello_icon.lrs}

  RegisterComponents('Android Bridges Extra',
   [
      jNetApi,
      jBarcodeGen,
      jUSSDService,
      jFTPClient,
      jSFTPClient,
      jBrightness,
      jSoundPool,
      jWifiManager,
      jExpression,
      jXLSWriter,
      jModalDialog,
      jIncomingCallWidgetProvider,
      jSMSWidgetProvider,
      jSpeechToText,
      jTextToSpeech,
      jCustomSpeechToText,
      jMaps,
      jWindowManager,
      jSelectDirectoryDialog,
      jOpenDialog,
      jFileProvider,
      jUDPSocket,
      jNumberPickerDialog,
      jActivityLauncher,
      jDatePickerDialog,
      jTimePickerDialog,
      jDialogYN,
      jDialogProgress,
      jNotificationManager,
      jIntentManager,
      jBroadcastReceiver,
      jSensorManager,
      jContactManager,
      jMediaRecorder,
      jMediaPlayer,
      jMidiManager,
      jDownloadManager,
      jDownloadService,
      jUploadService,
      jAlarmManager,
      jTelephonyManager,
      jSMSManager,
      jSMS,
      jCamera,
      jLocation,
      jPreferences,
      jTextFileManager,
      jImageFileManager,
      jSharefile,
      jHttpClient,
      jSmtpClient,
      jTCPSocketClient,
      jTimer,
      jAsyncTask,
      jBluetooth,
      jBluetoothClientSocket,
      jBluetoothServerSocket,
      jBluetoothLowEnergy,
      jSqliteDataAccess,
      jSqliteCursor,
      jOracleJDBCConnection,
      jMsSqlJDBCConnection,
      jShellCommand,
      jDumpJavaMethods,
      jMyHello
   ]
  );
end;
  
end.
