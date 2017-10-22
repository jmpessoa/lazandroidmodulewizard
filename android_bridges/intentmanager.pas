unit intentmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TIntentAction = (iaView, iaPick, iaSendto, idDial, iaCallbutton, iaCall, iaImageCapture,
                 iaDataRoaming,iaQuickLaunch, iaDate,iaSystem, iaWireless, iaDeviceInfo,
                 iaSend, iaSendMultiple, iaPickActivity, iaEdit, iaGetContent,
                 iaTimePick, iaVoiceCommand, iaWebSearch, iaMain, iaAppWidgetUpdate, iaNone);

TIntentCategory = (icDefault, icLauncher, icHome, icInfo, icPreference, icAppBrowser,
                   icAppCalculator, icAppCalendar, icAppContacts, icAppEmail,
                   icAppGallery, icAppMaps, icAppMessaging, icAppMusic);

TIntentFlag = (ifActivityNewTask, ifActivityBroughtToFront, ifActivityTaskOnHome,
               ifActivityForwardResult, ifActivityClearWhenTaskReset);

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
    function jCreate(): jObject;
    procedure jFree();
    function GetIntent(): jObject;
    function GetActivityStartedIntent(): jObject;
    procedure SetAction(_intentAction: string); overload;
    procedure SetAction(_intentAction: TIntentAction); overload;
    procedure SetMimeType(_mimeType: string);
    procedure SetDataUriAsString(_uriAsString: string);
    procedure StartActivityForResult(_requestCode: integer); overload;
    procedure StartActivity(); overload;
    procedure StartActivity(_chooserTitle: string); overload;
    procedure StartActivityForResult(_requestCode: integer; _chooserTitle: string);  overload;
    procedure SendBroadcast();
    function GetAction(_intent: jObject): string;
    function HasExtra(_intent: jObject; _dataName: string): boolean;
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
    function GetExtraStringArray(_intent: jObject; _dataName: string): TDynArrayOfString;
    procedure PutExtraStringArray(_dataName: string; var _values: TDynArrayOfString);
    function GetExtraString(_intent: jObject; _dataName: string): string;
    procedure PutExtraString(_dataName: string; _value: string);
    procedure SetDataUri(_dataUri: jObject);
    function GetDataUri(_intent: jObject): jObject;
    function GetDataUriAsString(_intent: jObject): string;
    procedure PutExtraFile(_environmentDirectoryPath: string; _fileName: string);  overload;
    procedure PutExtraMailSubject(_mailSubject: string);
    procedure PutExtraMailBody(_mailBody: string);
    procedure PutExtraMailCCs(var _mailCCs: TDynArrayOfString);
    procedure PutExtraMailBCCs(var _mailBCCs: TDynArrayOfString);
    procedure PutExtraMailTos(var _mailTos: TDynArrayOfString);
    procedure PutExtraPhoneNumbers(var _callPhoneNumbers: TDynArrayOfString);
    function GetContactsContentUri(): jObject;
    function GetContactsPhoneUri(): jObject;
    function GetAudioExternContentUri(): jObject;
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
    function GetBundleContent(_intent: jObject): TDynArrayOfString;
    function IsCallable(_intent: jObject): boolean;
    function IsActionEqual(_intent: jObject; _intentAction: string): boolean;

    procedure PutExtraMediaStoreOutput(_environmentDirectoryPath: string; _fileName: string);
    function GetActionCameraCropAsString(): string;

    procedure AddCategory(_intentCategory: TIntentCategory);
    procedure SetFlag(_intentFlag: TIntentFlag);
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

 published
    property IntentAction: TIntentAction read FIntentAction write SetAction;

end;

function jIntentManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jIntentManager_jFree(env: PJNIEnv; _jintentmanager: JObject);
function jIntentManager_GetIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_GetActivityStartedIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
procedure jIntentManager_SetAction(env: PJNIEnv; _jintentmanager: JObject; _intentAction: string);  overload;
procedure jIntentManager_SetMimeType(env: PJNIEnv; _jintentmanager: JObject; _mimeType: string);
procedure jIntentManager_SetDataUriAsString(env: PJNIEnv; _jintentmanager: JObject; _uriAsString: string);
procedure jIntentManager_StartActivityForResult(env: PJNIEnv; _jintentmanager: JObject; _requestCode: integer); overload;
procedure jIntentManager_StartActivity(env: PJNIEnv; _jintentmanager: JObject);  overload;
procedure jIntentManager_StartActivity(env: PJNIEnv; _jintentmanager: JObject; _chooserTitle: string); overload;
procedure jIntentManager_StartActivityForResult(env: PJNIEnv; _jintentmanager: JObject; _requestCode: integer; _chooserTitle: string); overload;
procedure jIntentManager_SendBroadcast(env: PJNIEnv; _jintentmanager: JObject);
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
procedure jIntentManager_PutExtraInt(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: integer);
function jIntentManager_GetExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfString;
procedure jIntentManager_PutExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfString);
function jIntentManager_GetExtraString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): string;
procedure jIntentManager_PutExtraString(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: string);
procedure jIntentManager_SetDataUri(env: PJNIEnv; _jintentmanager: JObject; _dataUri: jObject);
function jIntentManager_GetDataUri(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
function jIntentManager_GetDataUriAsString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
procedure jIntentManager_PutExtraFile(env: PJNIEnv; _jintentmanager: JObject; _environmentDirectoryPath: string; _fileName: string); overload;
procedure jIntentManager_PutExtraMailSubject(env: PJNIEnv; _jintentmanager: JObject; _mailSubject: string);
procedure jIntentManager_PutExtraMailBody(env: PJNIEnv; _jintentmanager: JObject; _mailBody: string);
procedure jIntentManager_PutExtraMailCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailCCs: TDynArrayOfString);
procedure jIntentManager_PutExtraMailBCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailBCCs: TDynArrayOfString);
procedure jIntentManager_PutExtraMailTos(env: PJNIEnv; _jintentmanager: JObject; var _mailTos: TDynArrayOfString);
procedure jIntentManager_PutExtraPhoneNumbers(env: PJNIEnv; _jintentmanager: JObject; var _callPhoneNumbers: TDynArrayOfString);
function jIntentManager_GetContactsContentUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_GetContactsPhoneUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_GetAudioExternContentUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_GetVideoExternContentUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
function jIntentManager_ParseUri(env: PJNIEnv; _jintentmanager: JObject; _uriAsString: string): jObject;
function jIntentManager_GetActionViewAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetActionPickAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetActionSendtoAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetActionSendAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetActionEditAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetActionDialAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetActionCallButtonAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_ResolveActivity(env: PJNIEnv; _jintentmanager: JObject): boolean;
function jIntentManager_GetMailtoUri(env: PJNIEnv; _jintentmanager: JObject): jObject; overload;
function jIntentManager_GetMailtoUri(env: PJNIEnv; _jintentmanager: JObject; _email: string): jObject; overload;
function jIntentManager_GetTelUri(env: PJNIEnv; _jintentmanager: JObject): jObject; overload;
function jIntentManager_GetTelUri(env: PJNIEnv; _jintentmanager: JObject; _telNumber: string): jObject; overload;
function jIntentManager_GetActionGetContentUri(env: PJNIEnv; _jintentmanager: JObject): string;
procedure jIntentManager_PutExtraFile(env: PJNIEnv; _jintentmanager: JObject; _uri: jObject); overload;
function jIntentManager_GetActionCallAsString(env: PJNIEnv; _jintentmanager: JObject): string;
function jIntentManager_GetContactNumber(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
function jIntentManager_GetContactEmail(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
function jIntentManager_GetBundleContent(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): TDynArrayOfString;

procedure jIntentManager_SetAction(env: PJNIEnv; _jintentmanager: JObject; _intentAction: integer); overload;
function jIntentManager_IsCallable(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): boolean;
function jIntentManager_IsActionEqual(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _intentAction: string): boolean;

procedure jIntentManager_PutExtraMediaStoreOutput(env: PJNIEnv; _jintentmanager: JObject; _environmentDirectoryPath: string; _fileName: string);
function jIntentManager_GetActionCameraCropAsString(env: PJNIEnv; _jintentmanager: JObject): string;
procedure jIntentManager_AddCategory(env: PJNIEnv; _jintentmanager: JObject; _intentCategory: integer);
procedure jIntentManager_SetFlag(env: PJNIEnv; _jintentmanager: JObject; _intentFlag: integer);
procedure jIntentManager_SetComponent(env: PJNIEnv; _jintentmanager: JObject; _packageName: string; _className: string);

procedure jIntentManager_SetClassName(env: PJNIEnv; _jintentmanager: JObject; _packageName: string; _className: string);
procedure jIntentManager_SetClass(env: PJNIEnv; _jintentmanager: JObject; _className: string); overload;
procedure jIntentManager_StartService(env: PJNIEnv; _jintentmanager: JObject);

procedure jIntentManager_SetClass(env: PJNIEnv; _jintentmanager: JObject; _packageName: string; _javaClassName: string);overload;
procedure jIntentManager_PutExtraText(env: PJNIEnv; _jintentmanager: JObject; _text: string);
procedure jIntentManager_SetPackage(env: PJNIEnv; _jintentmanager: JObject; _packageName: string);
function jIntentManager_IsPackageInstalled(env: PJNIEnv; _jintentmanager: JObject; _packageName: string): boolean; overload;
function jIntentManager_GetActionMainAsString(env: PJNIEnv; _jintentmanager: JObject): string;
procedure jIntentManager_TryDownloadPackage(env: PJNIEnv; _jintentmanager: JObject; _packageName: string);

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
       jFree();
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
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
  if FIntentAction <> iaNone then
      jIntentManager_SetAction(FjEnv, FjObject, Ord(FIntentAction));
end;


function jIntentManager.jCreate(): jObject;
begin
   Result:= jIntentManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jIntentManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_jFree(FjEnv, FjObject);
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
     jIntentManager_SetAction(FjEnv, FjObject, _intentAction);
end;

procedure jIntentManager.SetAction(_intentAction: TIntentAction);
begin
  //in designing component state: set value here...
  FIntentAction:= _intentAction;
  if FInitialized then
     jIntentManager_SetAction(FjEnv, FjObject, Ord(_intentAction));
end;

procedure jIntentManager.SetMimeType(_mimeType: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetMimeType(FjEnv, FjObject, _mimeType);
end;

procedure jIntentManager.SetDataUriAsString(_uriAsString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetDataUriAsString(FjEnv, FjObject, _uriAsString);
end;

procedure jIntentManager.StartActivityForResult(_requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_StartActivityForResult(FjEnv, FjObject, _requestCode);
end;

procedure jIntentManager.StartActivity();
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_StartActivity(FjEnv, FjObject);
end;

procedure jIntentManager.StartActivity(_chooserTitle: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_StartActivity(FjEnv, FjObject, _chooserTitle);
end;

procedure jIntentManager.StartActivityForResult(_requestCode: integer; _chooserTitle: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_StartActivityForResult(FjEnv, FjObject, _requestCode ,_chooserTitle);
end;

procedure jIntentManager.SendBroadcast();
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SendBroadcast(FjEnv, FjObject);
end;

function jIntentManager.GetAction(_intent: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetAction(FjEnv, FjObject, _intent);
end;

function jIntentManager.HasExtra(_intent: jObject; _dataName: string): boolean;
begin
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
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraBundle(FjEnv, FjObject, _intent);
end;

function jIntentManager.GetExtraDoubleArray(_intent: jObject; _dataName: string): TDynArrayOfDouble;
begin
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

function jIntentManager.GetExtraFloatArray(_intent: jObject; _dataName: string): TDynArrayOfSingle;
begin
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
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraInt(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraInt(_dataName: string; _value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraInt(FjEnv, FjObject, _dataName ,_value);
end;

function jIntentManager.GetExtraStringArray(_intent: jObject; _dataName: string): TDynArrayOfString;
begin
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
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetExtraString(FjEnv, FjObject, _intent ,_dataName);
end;

procedure jIntentManager.PutExtraString(_dataName: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraString(FjEnv, FjObject, _dataName ,_value);
end;

procedure jIntentManager.SetDataUri(_dataUri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetDataUri(FjEnv, FjObject, _dataUri);
end;

function jIntentManager.GetDataUri(_intent: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetDataUri(FjEnv, FjObject, _intent);
end;

function jIntentManager.GetDataUriAsString(_intent: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetDataUriAsString(FjEnv, FjObject, _intent);
end;

procedure jIntentManager.PutExtraFile(_environmentDirectoryPath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraFile(FjEnv, FjObject, _environmentDirectoryPath ,_fileName);
end;

procedure jIntentManager.PutExtraMailSubject(_mailSubject: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraMailSubject(FjEnv, FjObject, _mailSubject);
end;

procedure jIntentManager.PutExtraMailBody(_mailBody: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraMailBody(FjEnv, FjObject, _mailBody);
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
   Result:= jIntentManager_GetContactsContentUri(FjEnv, FjObject);
end;

function jIntentManager.GetContactsPhoneUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetContactsPhoneUri(FjEnv, FjObject);
end;

function jIntentManager.GetAudioExternContentUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetAudioExternContentUri(FjEnv, FjObject);
end;

function jIntentManager.GetVideoExternContentUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetVideoExternContentUri(FjEnv, FjObject);
end;

function jIntentManager.ParseUri(_uriAsString: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_ParseUri(FjEnv, FjObject, _uriAsString);
end;

function jIntentManager.GetActionViewAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionViewAsString(FjEnv, FjObject);
end;

function jIntentManager.GetActionPickAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionPickAsString(FjEnv, FjObject);
end;

function jIntentManager.GetActionSendtoAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionSendtoAsString(FjEnv, FjObject);
end;

function jIntentManager.GetActionSendAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionSendAsString(FjEnv, FjObject);
end;

function jIntentManager.GetActionEditAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionEditAsString(FjEnv, FjObject);
end;

function jIntentManager.GetActionDialAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionDialAsString(FjEnv, FjObject);
end;

function jIntentManager.GetActionCallButtonAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionCallButtonAsString(FjEnv, FjObject);
end;

function jIntentManager.ResolveActivity(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_ResolveActivity(FjEnv, FjObject);
end;

function jIntentManager.GetMailtoUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetMailtoUri(FjEnv, FjObject);
end;

function jIntentManager.GetMailtoUri(_email: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetMailtoUri(FjEnv, FjObject, _email);
end;

function jIntentManager.GetTelUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetTelUri(FjEnv, FjObject);
end;

function jIntentManager.GetTelUri(_telNumber: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetTelUri(FjEnv, FjObject, _telNumber);
end;

function jIntentManager.GetActionGetContentUri(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionGetContentUri(FjEnv, FjObject);
end;

procedure jIntentManager.PutExtraFile(_uri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraFile(FjEnv, FjObject, _uri);
end;

function jIntentManager.GetActionCallAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionCallAsString(FjEnv, FjObject);
end;

function jIntentManager.GetContactNumber(_contactUri: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetContactNumber(FjEnv, FjObject, _contactUri);
end;

function jIntentManager.GetContactEmail(_contactUri: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetContactEmail(FjEnv, FjObject, _contactUri);
end;

function jIntentManager.GetBundleContent(_intent: jObject): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetBundleContent(FjEnv, FjObject, _intent);
end;

function jIntentManager.IsCallable(_intent: jObject): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_IsCallable(FjEnv, FjObject, _intent);
end;

function jIntentManager.IsActionEqual(_intent: jObject; _intentAction: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_IsActionEqual(FjEnv, FjObject, _intent ,_intentAction);
end;

procedure jIntentManager.PutExtraMediaStoreOutput(_environmentDirectoryPath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraMediaStoreOutput(FjEnv, FjObject, _environmentDirectoryPath ,_fileName);
end;

function jIntentManager.GetActionCameraCropAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionCameraCropAsString(FjEnv, FjObject);
end;

procedure jIntentManager.AddCategory(_intentCategory: TIntentCategory);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_AddCategory(FjEnv, FjObject, Ord(_intentCategory));
end;

procedure jIntentManager.SetFlag(_intentFlag: TIntentFlag);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetFlag(FjEnv, FjObject, Ord(_intentFlag));
end;

procedure jIntentManager.SetComponent(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetComponent(FjEnv, FjObject, _packageName ,_javaClassName);
end;

procedure jIntentManager.SetClassName(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetClassName(FjEnv, FjObject, _packageName ,_javaClassName);
end;

procedure jIntentManager.SetClass(_fullJavaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetClass(FjEnv, FjObject, _fullJavaClassName);
end;

procedure jIntentManager.StartService();
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_StartService(FjEnv, FjObject);
end;

procedure jIntentManager.SetClass(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetClass(FjEnv, FjObject, _packageName ,_javaClassName);
end;

procedure jIntentManager.PutExtraText(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_PutExtraText(FjEnv, FjObject, _text);
end;

procedure jIntentManager.SetPackage(_packageName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_SetPackage(FjEnv, FjObject, _packageName);
end;

function jIntentManager.IsPackageInstalled(_packageName: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_IsPackageInstalled(FjEnv, FjObject, _packageName);
end;

function jIntentManager.GetActionMainAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jIntentManager_GetActionMainAsString(FjEnv, FjObject);
end;

procedure jIntentManager.TryDownloadPackage(_packageName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jIntentManager_TryDownloadPackage(FjEnv, FjObject, _packageName);
end;

{-------- jIntentManager_JNI_Bridge ----------}

function jIntentManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jIntentManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jIntentManager_jCreate(long _Self) {
      return (java.lang.Object)(new jIntentManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jIntentManager_jFree(env: PJNIEnv; _jintentmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntent', '()Landroid/content/Intent;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActivityStartedIntent(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActivityStartedIntent', '()Landroid/content/Intent;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_SetAction(env: PJNIEnv; _jintentmanager: JObject; _intentAction: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAction', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_SetMimeType(env: PJNIEnv; _jintentmanager: JObject; _mimeType: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_mimeType));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMimeType', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_SetDataUriAsString(env: PJNIEnv; _jintentmanager: JObject; _uriAsString: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataUriAsString', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_StartActivityForResult(env: PJNIEnv; _jintentmanager: JObject; _requestCode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivityForResult', '(I)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_StartActivity(env: PJNIEnv; _jintentmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivity', '()V');
  env^.CallVoidMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_StartActivity(env: PJNIEnv; _jintentmanager: JObject; _chooserTitle: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_chooserTitle));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivity', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_StartActivityForResult(env: PJNIEnv; _jintentmanager: JObject; _requestCode: integer; _chooserTitle: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _requestCode;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_chooserTitle));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivityForResult', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_SendBroadcast(env: PJNIEnv; _jintentmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SendBroadcast', '()V');
  env^.CallVoidMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetAction(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAction', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_HasExtra(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'HasExtra', '(Landroid/content/Intent;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraBundle(env: PJNIEnv; _jintentmanager: JObject; _bundleExtra: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bundleExtra;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraBundle', '(Landroid/os/Bundle;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraBundle(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraBundle', '(Landroid/content/Intent;)Landroid/os/Bundle;');
  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraDoubleArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraDoubleArray', '(Landroid/content/Intent;Ljava/lang/String;)[D');
  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraDoubleArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfDouble);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraDoubleArray', '(Ljava/lang/String;[D)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraDouble(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): double;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraDouble', '(Landroid/content/Intent;Ljava/lang/String;)D');
  Result:= env^.CallDoubleMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraDouble(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: double);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  jParams[1].d:= _value;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraDouble', '(Ljava/lang/String;D)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraFloatArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraFloatArray', '(Landroid/content/Intent;Ljava/lang/String;)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraFloatArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfSingle);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFloatArray', '(Ljava/lang/String;[F)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraFloat(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraFloat', '(Landroid/content/Intent;Ljava/lang/String;)F');
  Result:= env^.CallFloatMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraFloat(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  jParams[1].f:= _value;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFloat', '(Ljava/lang/String;F)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraIntArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfInteger;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraIntArray', '(Landroid/content/Intent;Ljava/lang/String;)[I');
  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetIntArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraIntArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfInteger);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewIntArray(env, newSize0);  // allocate
  env^.SetIntArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraIntArray', '(Ljava/lang/String;[I)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraInt(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraInt', '(Landroid/content/Intent;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraInt(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  jParams[1].i:= _value;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraInt', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraStringArray', '(Landroid/content/Intent;Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraStringArray(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; var _values: TDynArrayOfString);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  newSize0:= Length(_values);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_values[i])));
  end;
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraStringArray', '(Ljava/lang/String;[Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetExtraString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _dataName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtraString', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraString(env: PJNIEnv; _jintentmanager: JObject; _dataName: string; _value: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_value));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraString', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_SetDataUri(env: PJNIEnv; _jintentmanager: JObject; _dataUri: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _dataUri;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataUri', '(Landroid/net/Uri;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetDataUri(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDataUri', '(Landroid/content/Intent;)Landroid/net/Uri;');
  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetDataUriAsString(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDataUriAsString', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraFile(env: PJNIEnv; _jintentmanager: JObject; _environmentDirectoryPath: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_environmentDirectoryPath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraMailSubject(env: PJNIEnv; _jintentmanager: JObject; _mailSubject: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_mailSubject));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailSubject', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraMailBody(env: PJNIEnv; _jintentmanager: JObject; _mailBody: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_mailBody));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailBody', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraMailCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailCCs: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_mailCCs);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_mailCCs[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailCCs', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraMailBCCs(env: PJNIEnv; _jintentmanager: JObject; var _mailBCCs: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_mailBCCs);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_mailBCCs[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailBCCs', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraMailTos(env: PJNIEnv; _jintentmanager: JObject; var _mailTos: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_mailTos);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_mailTos[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMailTos', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraPhoneNumbers(env: PJNIEnv; _jintentmanager: JObject; var _callPhoneNumbers: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_callPhoneNumbers);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_callPhoneNumbers[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraPhoneNumbers', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetContactsContentUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactsContentUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetContactsPhoneUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactsPhoneUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_GetAudioExternContentUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAudioExternContentUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_GetVideoExternContentUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetVideoExternContentUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_ParseUri(env: PJNIEnv; _jintentmanager: JObject; _uriAsString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ParseUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionViewAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionViewAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionPickAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionPickAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionSendtoAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionSendtoAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_GetActionSendAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionSendAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionEditAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionEditAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionDialAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionDialAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionCallButtonAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionCallButtonAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
end;

function jIntentManager_ResolveActivity(env: PJNIEnv; _jintentmanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ResolveActivity', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jintentmanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetMailtoUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMailtoUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetMailtoUri(env: PJNIEnv; _jintentmanager: JObject; _email: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_email));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMailtoUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetTelUri(env: PJNIEnv; _jintentmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTelUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetTelUri(env: PJNIEnv; _jintentmanager: JObject; _telNumber: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_telNumber));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTelUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  Result:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionGetContentUri(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionGetContentUri', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraFile(env: PJNIEnv; _jintentmanager: JObject; _uri: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _uri;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraFile', '(Landroid/net/Uri;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionCallAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionCallAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetContactNumber(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _contactUri;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactNumber', '(Landroid/net/Uri;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetContactEmail(env: PJNIEnv; _jintentmanager: JObject; _contactUri: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _contactUri;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactEmail', '(Landroid/net/Uri;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jintentmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_GetBundleContent(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBundleContent', '(Landroid/content/Intent;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jintentmanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_SetAction(env: PJNIEnv; _jintentmanager: JObject; _intentAction: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _intentAction;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAction', '(I)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_IsCallable(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsCallable', '(Landroid/content/Intent;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_IsActionEqual(env: PJNIEnv; _jintentmanager: JObject; _intent: jObject; _intentAction: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsActionEqual', '(Landroid/content/Intent;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_PutExtraMediaStoreOutput(env: PJNIEnv; _jintentmanager: JObject; _environmentDirectoryPath: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_environmentDirectoryPath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraMediaStoreOutput', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jIntentManager_GetActionCameraCropAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionCameraCropAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_AddCategory(env: PJNIEnv; _jintentmanager: JObject; _intentCategory: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _intentCategory;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddCategory', '(I)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_SetFlag(env: PJNIEnv; _jintentmanager: JObject; _intentFlag: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _intentFlag;
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFlag', '(I)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_SetComponent(env: PJNIEnv; _jintentmanager: JObject; _packageName: string; _className: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_className));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetComponent', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_SetClassName(env: PJNIEnv; _jintentmanager: JObject; _packageName: string; _className: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_className));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetClassName', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_SetClass(env: PJNIEnv; _jintentmanager: JObject; _className: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_className));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetClass', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_StartService(env: PJNIEnv; _jintentmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'StartService', '()V');
  env^.CallVoidMethod(env, _jintentmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_SetClass(env: PJNIEnv; _jintentmanager: JObject; _packageName: string; _javaClassName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_javaClassName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetClass', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jIntentManager_PutExtraText(env: PJNIEnv; _jintentmanager: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PutExtraText', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_SetPackage(env: PJNIEnv; _jintentmanager: JObject; _packageName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPackage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_IsPackageInstalled(env: PJNIEnv; _jintentmanager: JObject; _packageName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsPackageInstalled', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jintentmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jIntentManager_GetActionMainAsString(env: PJNIEnv; _jintentmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionMainAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jintentmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jIntentManager_TryDownloadPackage(env: PJNIEnv; _jintentmanager: JObject; _packageName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jCls:= env^.GetObjectClass(env, _jintentmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'TryDownloadPackage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jintentmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
