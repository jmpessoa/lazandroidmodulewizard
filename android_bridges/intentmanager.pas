unit intentmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TIntentAction = (iaView, iaPick, iaSendto, idDial, iaCallbutton, iaCall, iaImageCapture,
                 iaDataRoaming,iaQuickLaunch, iaDate,iaSystem, iaWireless, iaDeviceInfo,
                 iaSend, iaSendMultiple, iaPickActivity, iaEdit, iaGetContent,
                 iaTimePick, iaVoiceCommand, iaWebSearch, iaMain, iaAppWidgetUpdate,
                 iaInstalPackage, iaDelete, iaManagerUnknownAppSources, iaManageOverlayPermission,  iaNone);

TIntentCategory = (icDefault, icLauncher, icHome, icInfo, icPreference, icAppBrowser,
                   icAppCalculator, icAppCalendar, icAppContacts, icAppEmail,
                   icAppGallery, icAppMaps, icAppMessaging, icAppMusic, icOpenable);

TIntentFlag = (ifActivityNewTask, ifActivityBroughtToFront, ifActivityTaskOnHome,
               ifActivityForwardResult, ifActivityClearWhenTaskReset,
               ifActivityClearTop, ifGrantReadUriPermission, ifGrantWriteUriPermission);

{Draft Component code by "Lazarus Android Module Wizard" [1/27/2015 0:43:07]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jIntentManager = class(jControl)
 private
   FIntentAction: TIntentAction;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure NewIntent(); // by ADiV
    function GetIntent(): jObject;
    function GetActivityStartedIntent(): jObject;
    procedure SetAction(_intentAction: string); overload;
    procedure SetAction(_intentAction: TIntentAction); overload;
    procedure SetMimeType(_mimeType: string);
    procedure SetDataUriAsString(_uriAsString: string);
    function  StartActivityForResult(_requestCode: integer) : boolean; overload;
    function  StartActivity() : boolean; overload;
    function  StartActivity(_chooserTitle: string) : boolean; overload;
    function  StartActivityForResult(_requestCode: integer; _chooserTitle: string) : boolean;  overload;
    procedure SendBroadcast();
    function GetAction(_intent: jObject): string;
    function HasExtra(_intent: jObject; _dataName: string): boolean;
    procedure PutExtraContactWebSite(_website: string); // by ADiV
    procedure PutExtraBundle(_bundleExtra: jObject);
    function GetExtraBundle(_intent: jObject): jObject;
    function GetExtraDoubleArray(_intent: jObject; _dataName: string): TDynArrayOfDouble;
    procedure PutExtraDoubleArray(_dataName: string; var _values: TDynArrayOfDouble);
    function GetExtraDouble(_intent: jObject; _dataName: string): double;
    procedure PutExtraDouble(_dataName: string; _value: double);
    function GetExtraFloatArray(_intent: jObject; _dataName: string): TDynArrayOfSingle;
    procedure PutExtraFloatArray(_dataName: string; var _values: TDynArrayOfSingle);
    function GetExtraFloat(_intent: jObject; _dataName: string): single;
    procedure PutExtraFloat(_dataName: string; _value: single);
    function GetExtraIntArray(_intent: jObject; _dataName: string): TDynArrayOfInteger;
    procedure PutExtraIntArray(_dataName: string; var _values: TDynArrayOfInteger);
    function GetExtraInt(_intent: jObject; _dataName: string): integer;
    procedure PutExtraInt(_dataName: string; _value: integer);
    procedure PutExtraLong(_dataName: string; _value: int64);
    procedure PutExtraBool(_dataName: string; _value: boolean);
    function GetExtraStringArray(_intent: jObject; _dataName: string): TDynArrayOfString;
    procedure PutExtraStringArray(_dataName: string; var _values: TDynArrayOfString);
    function GetExtraString(_intent: jObject; _dataName: string): string;
    procedure PutExtraString(_dataName: string; _value: string);
    procedure SetDataUri(_dataUri: jObject);
    function GetDataUri(_intent: jObject): jObject;
    function GetDataUriAsString(_intent: jObject): string;
    procedure PutExtraFile(_environmentDirectoryPath: string; _fileName: string);  overload;
    procedure PutExtraImage( _bmp : jObject; _title : string ); // by ADiV
    procedure PutExtraMailSubject(_mailSubject: string);
    procedure PutExtraMailBody(_mailBody: string);
    procedure PutExtraMailCCs(var _mailCCs: TDynArrayOfString);
    procedure PutExtraMailBCCs(var _mailBCCs: TDynArrayOfString);
    procedure PutExtraMailTos(var _mailTos: TDynArrayOfString);
    procedure PutExtraPhoneNumbers(var _callPhoneNumbers: TDynArrayOfString);
    function GetContactsContentUri(): jObject;
    function GetContactsPhoneUri(): jObject;
    function GetAudioExternContentUri(): jObject;
    function GetFilesExternContentUri(): jObject;
    function GetImagesExternContentUri(): jObject;
    function GetVideoExternContentUri(): jObject;
    function ParseUri(_uriAsString: string): jObject;
    function GetActionViewAsString(): string;
    function GetActionPickAsString(): string;
    function GetActionSendtoAsString(): string;
    function GetActionSendAsString(): string;
    function GetActionEditAsString(): string;
    function GetActionDialAsString(): string;
    function GetActionCallButtonAsString(): string;
    function ResolveActivity(): boolean;
    function GetMailtoUri(): jObject;   overload;
    function GetMailtoUri(_email: string): jObject;  overload;
    function GetTelUri(): jObject;   overload;
    function GetTelUri(_telNumber: string): jObject;  overload;
    function GetActionGetContentUri(): string;
    procedure PutExtraFile(_uri: jObject);  overload;
    function GetActionCallAsString(): string;
    function GetContactNumber(_contactUri: jObject): string;
    function GetContactEmail(_contactUri: jObject): string;
    function GetBundleContent(_intent: jObject): TDynArrayOfString; overload;
    function IsCallable(_intent: jObject): boolean; overload;
    function IsCallable(_intentAction: string): boolean; overload;

    function IsActionEqual(_intent: jObject; _intentAction: string): boolean;

    procedure PutExtraMediaStoreOutput(_environmentDirectoryPath: string; _fileName: string);
    function GetActionCameraCropAsString(): string;

    procedure AddCategory(_intentCategory: TIntentCategory);
    procedure SetFlag(_intentFlag: TIntentFlag);
    procedure AddFlag(_intentFlag: TIntentFlag); // By ADiV
    procedure SetComponent(_packageName: string; _javaClassName: string);

    procedure SetClassName(_packageName: string; _javaClassName: string);
    procedure SetClass(_fullJavaClassName: string); overload;
    procedure StartService();
    procedure SetClass(_packageName: string; _javaClassName: string); overload;
    procedure PutExtraText(_text: string);
    procedure SetPackage(_packageName: string);
    function IsPackageInstalled(_packageName: string): boolean; overload;
    function GetActionMainAsString(): string;
    procedure TryDownloadPackage(_packageName: string);
    procedure SetDataAndType(_uriData: jObject; _mimeType: string); overload;
    procedure SetDataAndType(_uriAsString: string; _mimeType: string); overload;
    function HasLaunchIntentForPackage(_packageName: string): boolean;
    function GetExtraSMS(_intent: jObject; _addressBodyDelimiter: string): string;
    function GetActionInstallPackageAsString(): string;
    function GetActionDeleteAsString(): string;

    // Functions to customize sharing apps By ADiV
    procedure GetShareItemsClear;
    procedure SetShareItemClass( _pos : integer );
    function  GetShareItemsCount() : integer;
    function  GetShareItemLabel(_pos: integer) : String;
    function  GetShareItemPackageName(_pos: integer) : String;
    function  GetShareItemBitmap( _pos : integer ) : jObject;

    procedure SetDataPackage;

    //https://forum.lazarus.freepascal.org/index.php/topic,55344.0.html
    //thanks to schumi !
    function GetExtraByteArray(_intent: jObject; _dataName: string): TDynArrayOfJByte;
    procedure PutExtraByteArray(_dataName: string; var _values: TDynArrayOfJByte);
    function JByteArrayToString(var _byteArray: TDynArrayOfJByte): string;

    function GetBundleContent(_intent: jObject; keyValueDelimiter: string): TDynArrayOfString; overload;

 published
    property IntentAction: TIntentAction read FIntentAction write SetAction;

end;

function jIntentManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
function jIntentManager_GetIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_GetActivityStartedIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_GetAction(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
function jIntentManager_HasExtra(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): boolean;
procedure jIntentManager_PutExtraBundle(env: PJNIEnv; _jintentmanager: JObject; _bundleExtra: jObject);
function jIntentManager_GetExtraBundle(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
function jIntentManager_GetExtraDoubleArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfDouble;
procedure jIntentManager_PutExtraDoubleArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfDouble);
function jIntentManager_GetExtraDouble(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): double;
procedure jIntentManager_PutExtraDouble(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: double);
function jIntentManager_GetExtraFloatArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfSingle;
procedure jIntentManager_PutExtraFloatArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfSingle);
function jIntentManager_GetExtraFloat(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): single;
procedure jIntentManager_PutExtraFloat(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: single);
function jIntentManager_GetExtraIntArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfInteger;
procedure jIntentManager_PutExtraIntArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfInteger);
function jIntentManager_GetExtraInt(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): integer;
function jIntentManager_GetExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfString;
procedure jIntentManager_PutExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfString);
function jIntentManager_GetExtraString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): string;
procedure jIntentManager_SetDataUri(env: PJNIEnv; _jintentmanager: JObject; _dataUri: jObject);
function jIntentManager_GetDataUri(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
function jIntentManager_GetDataUriAsString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
procedure jIntentManager_PutExtraMailCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailCCs: TDynArrayOfString);
procedure jIntentManager_PutExtraMailBCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailBCCs: TDynArrayOfString);
procedure jIntentManager_PutExtraMailTos(env: PJNIEnv; _jintentmanager: JObject; var _mailTos: TDynArrayOfString);
procedure jIntentManager_PutExtraPhoneNumbers(env: PJNIEnv; _jintentmanager: JObject; var _callPhoneNumbers: TDynArrayOfString);
function jIntentManager_ParseUri(env: PJNIEnv; _jintentmanager: JObject; _uriAsString: string): jObject;
function jIntentManager_GetMailtoUri(env: PJNIEnv; _jintentmanager: JObject; _email: string): jObject; overload;
function jIntentManager_GetTelUri(env: PJNIEnv; _jintentmanager: JObject; _telNumber: string): jObject; overload;
procedure jIntentManager_PutExtraFile(env: PJNIEnv; _jintentmanager: JObject; _uri: jObject); overload;
function jIntentManager_GetContactNumber(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
function jIntentManager_GetContactEmail(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
function jIntentManager_GetBundleContent(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): TDynArrayOfString; overload;

function jIntentManager_IsCallable(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): boolean;  overload;
function jIntentManager_IsActionEqual(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _intentAction: string): boolean;

procedure jIntentManager_SetDataAndType(env: PJNIEnv; _jintentmanager: JObject; _uriData: jObject; _mimeType: string); overload;
function jIntentManager_GetExtraSMS(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _addressBodyDelimiter: string): string;

function jIntentManager_GetExtraByteArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfJByte;
procedure jIntentManager_PutExtraByteArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfJByte);
function jIntentManager_ByteArrayToString(env: PJNIEnv; _jintentmanager: JObject; var _byteArray: TDynArrayOfJByte): string;

function jIntentManager_GetBundleContent(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; keyValueDelimiter: string): TDynArrayOfString; overload;
implementation


{---------  jIntentManager  --------------}

constructor jIntentManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FIntentAction:= iaNone;
end;

destructor jIntentManager.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_free(FjEnv, FjObject);
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jIntentManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jIntentManager_jCreate(FjEnv, int64(Self), FjThis);

  if FjObject = nil then exit;

  FInitialized:= True;
  if FIntentAction <> iaNone then
      jni_proc_i(FjEnv, FjObject, 'SetAction', Ord(FIntentAction));
end;

function jIntentManager.GetIntent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetIntent(FjEnv, FjObject);
end;

function jIntentManager.GetActivityStartedIntent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActivityStartedIntent(FjEnv, FjObject);
end;

procedure jIntentManager.SetAction(_intentAction: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetAction', _intentAction);
end;

procedure jIntentManager.SetAction(_intentAction: TIntentAction);
begin
  //in designing component state: set value here...
  FIntentAction:= _intentAction;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetAction', Ord(_intentAction));
end;

procedure jIntentManager.SetMimeType(_mimeType: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetMimeType', _mimeType);
end;

procedure jIntentManager.SetDataUriAsString(_uriAsString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetDataUriAsString', _uriAsString);
end;

function jIntentManager.StartActivityForResult(_requestCode: integer) : boolean;
begin
  Result := false;
  //in designing component state: set value here...
  if FInitialized then
   Result := jni_func_i_out_z(FjEnv, FjObject, 'StartActivityForResult', _requestCode);
end;

function jIntentManager.StartActivity() : boolean;
begin
  Result := false;
  //in designing component state: set value here...
  if FInitialized then
   Result := jni_func_out_z(FjEnv, FjObject, 'StartActivity');
end;

function jIntentManager.StartActivity(_chooserTitle: string) : boolean;
begin
  Result := false;
  //in designing component state: set value here...
  if FInitialized then
   Result := jni_func_t_out_z(FjEnv, FjObject, 'StartActivity', _chooserTitle);
end;

function jIntentManager.StartActivityForResult(_requestCode: integer; _chooserTitle: string) : boolean;
begin
  Result := false;
  //in designing component state: set value here...
  if FInitialized then
   Result := jni_func_it_out_z(FjEnv, FjObject, 'StartActivityForResult', _requestCode ,_chooserTitle);
end;

procedure jIntentManager.SendBroadcast();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'SendBroadcast');
end;

function jIntentManager.GetAction(_intent: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetAction(FjEnv, FjObject, _intent);
end;

function jIntentManager.HasExtra(_intent: jObject; _dataName: string): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_HasExtra(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraBundle(_bundleExtra: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraBundle(FjEnv, FjObject, _bundleExtra);
end;

function jIntentManager.GetExtraBundle(_intent: jObject): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraBundle(FjEnv, FjObject, _intent);
end;

function jIntentManager.GetExtraDoubleArray(_intent: jObject; _dataName: string): TDynArrayOfDouble;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraDoubleArray(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraDoubleArray(_dataName: string; var _values: TDynArrayOfDouble);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraDoubleArray(FjEnv, FjObject, _dataName ,_values);
end;

function jIntentManager.GetExtraDouble(_intent: jObject; _dataName: string): double;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraDouble(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraDouble(_dataName: string; _value: double);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraDouble(FjEnv, FjObject, _dataName ,_value);
end;

procedure jIntentManager.PutExtraBool(_dataName: string; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tz(FjEnv, FjObject, 'PutExtraBool', _dataName ,_value);
end;

procedure jIntentManager.PutExtraContactWebSite(_website: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'PutExtraContactWebSite', _website);
end;

function jIntentManager.GetExtraFloatArray(_intent: jObject; _dataName: string): TDynArrayOfSingle;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraFloatArray(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraFloatArray(_dataName: string; var _values: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraFloatArray(FjEnv, FjObject, _dataName ,_values);
end;

function jIntentManager.GetExtraFloat(_intent: jObject; _dataName: string): single;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraFloat(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraFloat(_dataName: string; _value: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraFloat(FjEnv, FjObject, _dataName ,_value);
end;

function jIntentManager.GetExtraIntArray(_intent: jObject; _dataName: string): TDynArrayOfInteger;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraIntArray(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraIntArray(_dataName: string; var _values: TDynArrayOfInteger);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraIntArray(FjEnv, FjObject, _dataName ,_values);
end;

function jIntentManager.GetExtraInt(_intent: jObject; _dataName: string): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraInt(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraInt(_dataName: string; _value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ti(FjEnv, FjObject, 'PutExtraInt', _dataName, _value);
end;

procedure jIntentManager.PutExtraLong(_dataName: string; _value: int64);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tj(FjEnv, FjObject, 'PutExtraLong', _dataName, _value);
end;


function jIntentManager.GetExtraStringArray(_intent: jObject; _dataName: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraStringArray(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraStringArray(_dataName: string; var _values: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraStringArray(FjEnv, FjObject, _dataName ,_values);
end;

function jIntentManager.GetExtraString(_intent: jObject; _dataName: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraString(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraString(_dataName: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'PutExtraString', _dataName ,_value);
end;

procedure jIntentManager.SetDataUri(_dataUri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetDataUri(FjEnv, FjObject, _dataUri);
end;

procedure jIntentManager.SetDataPackage;
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'SetDataPackage');
end;

function jIntentManager.GetDataUri(_intent: jObject): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetDataUri(FjEnv, FjObject, _intent);
end;

function jIntentManager.GetDataUriAsString(_intent: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetDataUriAsString(FjEnv, FjObject, _intent);
end;

procedure jIntentManager.PutExtraFile(_environmentDirectoryPath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'PutExtraFile', _environmentDirectoryPath ,_fileName);
end;

procedure jIntentManager.PutExtraMailSubject(_mailSubject: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'PutExtraMailSubject', _mailSubject);
end;

procedure jIntentManager.PutExtraMailBody(_mailBody: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'PutExtraMailBody', _mailBody);
end;

procedure jIntentManager.PutExtraMailCCs(var _mailCCs: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraMailCCs(FjEnv, FjObject, _mailCCs);
end;

procedure jIntentManager.PutExtraMailBCCs(var _mailBCCs: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraMailBCCs(FjEnv, FjObject, _mailBCCs);
end;

procedure jIntentManager.PutExtraMailTos(var _mailTos: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraMailTos(FjEnv, FjObject, _mailTos);
end;

procedure jIntentManager.PutExtraPhoneNumbers(var _callPhoneNumbers: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraPhoneNumbers(FjEnv, FjObject, _callPhoneNumbers);
end;

function jIntentManager.GetContactsContentUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetContactsContentUri');
end;

function jIntentManager.GetContactsPhoneUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetContactsPhoneUri');
end;

function jIntentManager.GetAudioExternContentUri(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetAudioExternContentUri');
end;

function jIntentManager.GetFilesExternContentUri(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetFilesExternContentUri');
end;

function jIntentManager.GetImagesExternContentUri(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetImagesExternContentUri');
end;

function jIntentManager.GetVideoExternContentUri(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetVideoExternContentUri');
end;

function jIntentManager.ParseUri(_uriAsString: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_ParseUri(FjEnv, FjObject, _uriAsString);
end;

function jIntentManager.GetActionViewAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionViewAsString');
end;

function jIntentManager.GetActionPickAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionPickAsString');
end;

function jIntentManager.GetActionSendtoAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionSendtoAsString');
end;

function jIntentManager.GetActionSendAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionSendAsString');
end;

function jIntentManager.GetActionEditAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionEditAsString');
end;

function jIntentManager.GetActionDialAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionDialAsString');
end;

function jIntentManager.GetActionCallButtonAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionCallButtonAsString');
end;

function jIntentManager.ResolveActivity(): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'ResolveActivity');
end;

function jIntentManager.GetMailtoUri(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetMailtoUri');
end;

function jIntentManager.GetMailtoUri(_email: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetMailtoUri(FjEnv, FjObject, _email);
end;

function jIntentManager.GetTelUri(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_uri(FjEnv, FjObject, 'GetTelUri');
end;

function jIntentManager.GetTelUri(_telNumber: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetTelUri(FjEnv, FjObject, _telNumber);
end;

function jIntentManager.GetActionGetContentUri(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionGetContentUri');
end;

procedure jIntentManager.PutExtraFile(_uri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraFile(FjEnv, FjObject, _uri);
end;

procedure jIntentManager.PutExtraImage( _bmp : jObject; _title : string );
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_bmp_t(FjEnv, FjObject, 'PutExtraImage', _bmp, _title);
end;

function jIntentManager.GetShareItemsCount() : integer;
begin
  Result := 0;

  if FInitialized then
   Result := jni_func_out_i(FjEnv, FjObject, 'GetShareItemsCount');
end;

function jIntentManager.GetShareItemLabel(_pos: integer) : String;
begin
  Result := '';

  if FInitialized then
   Result := jni_func_i_out_t(FjEnv, FjObject, 'GetShareItemLabel', _pos);
end;

function jIntentManager.GetShareItemPackageName(_pos: integer) : String;
begin
  Result := '';

  if FInitialized then
   Result := jni_func_i_out_t(FjEnv, FjObject, 'GetShareItemPackageName', _pos);
end;

function jIntentManager.GetShareItemBitmap( _pos : integer ) : jObject;
begin
 Result := nil;

  if FInitialized then
   Result := jni_func_i_out_bmp(FjEnv, FjObject, 'GetShareItemBitmap', _pos);
end;

procedure jIntentManager.GetShareItemsClear;
begin
 if FInitialized then
   jni_proc(FjEnv, FjObject, 'GetShareItemsClear');
end;

procedure jIntentManager.SetShareItemClass( _pos : integer );
begin
 if FInitialized then
   jni_proc_i(FjEnv, FjObject, 'SetShareItemClass', _pos);
end;

procedure jIntentManager.NewIntent();
begin
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'NewIntent');
end;

function jIntentManager.GetActionCallAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionCallAsString');
end;

function jIntentManager.GetContactNumber(_contactUri: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetContactNumber(FjEnv, FjObject, _contactUri);
end;

function jIntentManager.GetContactEmail(_contactUri: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetContactEmail(FjEnv, FjObject, _contactUri);
end;

function jIntentManager.GetBundleContent(_intent: jObject): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetBundleContent(FjEnv, FjObject, _intent);
end;

function jIntentManager.IsCallable(_intent: jObject): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_IsCallable(FjEnv, FjObject, _intent);
end;

function jIntentManager.IsCallable(_intentAction: string): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_z(FjEnv, FjObject, 'IsCallable', _intentAction);
end;

function jIntentManager.IsActionEqual(_intent: jObject; _intentAction: string): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_IsActionEqual(FjEnv, FjObject, _intent ,_intentAction);
end;

procedure jIntentManager.PutExtraMediaStoreOutput(_environmentDirectoryPath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'PutExtraMediaStoreOutput', _environmentDirectoryPath ,_fileName);
end;

function jIntentManager.GetActionCameraCropAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionCameraCropAsString');
end;

procedure jIntentManager.AddCategory(_intentCategory: TIntentCategory);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'AddCategory', Ord(_intentCategory));
end;

procedure jIntentManager.SetFlag(_intentFlag: TIntentFlag);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetFlag', Ord(_intentFlag));
end;

procedure jIntentManager.AddFlag(_intentFlag: TIntentFlag);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'AddFlag', Ord(_intentFlag));
end;

procedure jIntentManager.SetComponent(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'SetComponent', _packageName ,_javaClassName);
end;

procedure jIntentManager.SetClassName(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'SetClassName', _packageName ,_javaClassName);
end;

procedure jIntentManager.SetClass(_fullJavaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetClass', _fullJavaClassName);
end;

procedure jIntentManager.StartService();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'StartService');
end;

procedure jIntentManager.SetClass(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'SetClass', _packageName ,_javaClassName);
end;

procedure jIntentManager.PutExtraText(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'PutExtraText', _text);
end;

procedure jIntentManager.SetPackage(_packageName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetPackage', _packageName);
end;

function jIntentManager.IsPackageInstalled(_packageName: string): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_z(FjEnv, FjObject, 'IsPackageInstalled', _packageName);
end;

function jIntentManager.GetActionMainAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionMainAsString');
end;

procedure jIntentManager.TryDownloadPackage(_packageName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'TryDownloadPackage', _packageName);
end;

procedure jIntentManager.SetDataAndType(_uriData: jObject; _mimeType: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetDataAndType(FjEnv, FjObject, _uriData ,_mimeType);
end;

procedure jIntentManager.SetDataAndType(_uriAsString: string; _mimeType: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'SetDataAndType', _uriAsString ,_mimeType);
end;

function jIntentManager.HasLaunchIntentForPackage(_packageName: string): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_z(FjEnv, FjObject, 'HasLaunchIntentForPackage', _packageName);
end;

function jIntentManager.GetExtraSMS(_intent: jObject; _addressBodyDelimiter: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraSMS(FjEnv, FjObject, _intent ,_addressBodyDelimiter);
end;

function jIntentManager.GetActionInstallPackageAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionInstallPackageAsString');
end;

function jIntentManager.GetActionDeleteAsString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetActionDeleteAsString');
end;

function jIntentManager.GetExtraByteArray(_intent: jObject; _dataName: string): TDynArrayOfJByte;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraByteArray(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraByteArray(_dataName: string; var _values: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraByteArray(FjEnv, FjObject, _dataName ,_values);
end;

function jIntentManager.JByteArrayToString(var _byteArray: TDynArrayOfJByte): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_ByteArrayToString(FjEnv, FjObject, _byteArray);
end;


function jIntentManager.GetBundleContent(_intent: jObject; keyValueDelimiter: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetBundleContent(FjEnv, FjObject, _intent ,keyValueDelimiter);
end;

{-------- jIntentManager_JNI_Bridge ----------}

function jIntentManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin
  result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jIntentManager_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

(*
//Please, you need insert:

   public java.lang.Object jIntentManager_jCreate(long _Self) {
      return (java.lang.Object)(new jIntentManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


function jIntentManager_GetIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;     
label
  _exceptionOcurred;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntent', '()Landroid/content/Intent;');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetActivityStartedIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetActivityStartedIntent', '()Landroid/content/Intent;');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetAction(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;     
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetAction', '(Landroid/content/Intent;)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;

  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_HasExtra(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;     
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'HasExtra', '(Landroid/content/Intent;Ljava/lang/String;)Z');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraBundle(env: PJNIEnv; _jintentmanager: JObject; _bundleExtra: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;      
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraBundle', '(Landroid/os/Bundle;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _bundleExtra;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraBundle(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraBundle', '(Landroid/content/Intent;)Landroid/os/Bundle;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;

  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraDoubleArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin
  Result := nil;

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraDoubleArray', '(Landroid/content/Intent;Ljava/lang/String;)[D');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraDoubleArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfDouble);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil; 
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraDoubleArray', '(Ljava/lang/String;[D)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraDouble(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): double;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraDouble', '(Landroid/content/Intent;Ljava/lang/String;)D');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  Result:= env^.CallDoubleMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraDouble(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: double);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraDouble', '(Ljava/lang/String;D)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  jParams[1].d:= _value;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraFloatArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  Result := nil;

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraFloatArray', '(Landroid/content/Intent;Ljava/lang/String;)[F');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraFloatArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfSingle);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFloatArray', '(Ljava/lang/String;[F)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraFloat(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraFloat', '(Landroid/content/Intent;Ljava/lang/String;)F');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  Result:= env^.CallFloatMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraFloat(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFloat', '(Ljava/lang/String;F)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  jParams[1].f:= _value;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraIntArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfInteger;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  Result := nil;

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraIntArray', '(Landroid/content/Intent;Ljava/lang/String;)[I');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetIntArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraIntArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfInteger);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil; 
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraIntArray', '(Ljava/lang/String;[I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewIntArray(env, newSize0);  // allocate
  env^.SetIntArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraInt(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraInt', '(Landroid/content/Intent;Ljava/lang/String;)I');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  Result:= env^.CallIntMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;     
label
  _exceptionOcurred;
begin
  Result := nil;

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraStringArray', '(Landroid/content/Intent;Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfString);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;          
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraStringArray', '(Ljava/lang/String;[Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_values[i])));
  end;
  jParams[1].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetExtraString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraString', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_SetDataUri(env: PJNIEnv; _jintentmanager: JObject; _dataUri: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataUri', '(Landroid/net/Uri;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _dataUri;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetDataUri(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDataUri', '(Landroid/content/Intent;)Landroid/net/Uri;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;

  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetDataUriAsString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDataUriAsString', '(Landroid/content/Intent;)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;

  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraMailCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailCCs: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;          
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailCCs', '([Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  newSize0:= Length(_mailCCs);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_mailCCs[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraMailBCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailBCCs: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;        
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailBCCs', '([Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  newSize0:= Length(_mailBCCs);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_mailBCCs[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraMailTos(env: PJNIEnv; _jintentmanager: JObject; var _mailTos: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;          
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailTos', '([Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  newSize0:= Length(_mailTos);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_mailTos[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraPhoneNumbers(env: PJNIEnv; _jintentmanager: JObject; var _callPhoneNumbers: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;        
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraPhoneNumbers', '([Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  newSize0:= Length(_callPhoneNumbers);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_callPhoneNumbers[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_ParseUri(env: PJNIEnv; _jintentmanager: JObject; _uriAsString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;     
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ParseUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));

  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetMailtoUri(env: PJNIEnv; _jintentmanager: JObject; _email: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;     
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetMailtoUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_email));

  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetTelUri(env: PJNIEnv; _jintentmanager: JObject; _telNumber: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetTelUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_telNumber));

  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraFile(env: PJNIEnv; _jintentmanager: JObject; _uri: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFile', '(Landroid/net/Uri;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _uri;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetContactNumber(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactNumber', '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _contactUri;

  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jIntentManager_GetContactEmail(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactEmail', '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _contactUri;

  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jIntentManager_GetBundleContent(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;    
label
  _exceptionOcurred;
begin
  Result := nil;

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBundleContent', '(Landroid/content/Intent;)[Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jIntentManager_IsCallable(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsCallable', '(Landroid/content/Intent;)Z');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;

  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jIntentManager_IsActionEqual(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _intentAction: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsActionEqual', '(Landroid/content/Intent;Ljava/lang/String;)Z');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_intentAction));

  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jIntentManager_SetDataAndType(env: PJNIEnv; _jintentmanager: JObject; _uriData: jObject; _mimeType: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;    
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataAndType', '(Landroid/net/Uri;Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _uriData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mimeType));

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jIntentManager_GetExtraSMS(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _addressBodyDelimiter: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraSMS', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_addressBodyDelimiter));

  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jIntentManager_GetExtraByteArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  Result := nil;

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraByteArray', '(Landroid/content/Intent;Ljava/lang/String;)[B');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jIntentManager_PutExtraByteArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfJByte);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraByteArray', '(Ljava/lang/String;[I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jIntentManager_ByteArrayToString(env: PJNIEnv; _jintentmanager: JObject; var _byteArray: TDynArrayOfJByte): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ByteArrayToString', '([B)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_GetBundleContent(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; keyValueDelimiter: string): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBundleContent', '(Landroid/content/Intent;Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(keyValueDelimiter));

  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;
  env^.DeleteLocalRef(env,jParams[1].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
