unit contactmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type


 { TODO
 TShowInListing = (ciAll, ciDisplayName, ciMobileNumber, ciHomeNumber,  ciWorkNumber,
                   ciHomeEmail, ciWorkEmail,    ciCompanyName, ciJobTitle, ciPhoto, ciID);

 TShowInListingSet = Set of TShowInListing;
 }

TOnGetContactsFinished = procedure(Sender: TObject; count: integer) of Object;
TOnGetContactsProgress = procedure(Sender: TObject; contactInfo: string; contactShortInfo: string;
                                                    contactPhotoUriAsString: string;
                                                    contactPhoto: jObject;
                                                    progress: integer; out continueListing: boolean) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [6/16/2015 23:27:55]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jContactManager = class(jControl)
 private
     //FShowInListing: TShowInListingSet;
    FOnGetContactsFinished: TOnGetContactsFinished;
    FOnGetContactsProgress: TOnGetContactsProgress;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function GetMobilePhoneNumber(_displayName: string): string;
    function GetContactID(_displayName: string): string;
    procedure UpdateDisplayName(_displayName: string; _newDisplayName: string);
    procedure UpdateMobilePhoneNumber(_displayName: string; _newMobileNumber: string);
    procedure UpdateWorkPhoneNumber(_displayName: string; _newWorkNumber: string);
    procedure UpdateHomePhoneNumber(_displayName: string; _newHomeNumber: string);
    procedure UpdateHomeEmail(_displayName: string; _newHomeEmail: string);
    procedure UpdateWorkEmail(_displayName: string; _newWorkEmail: string);
    procedure UpdateOrganization(_displayName: string; _newCompany: string; _newJobTitle: string);
    procedure UpdatePhoto(_displayName: string; _bitmapImage: jObject);
    function GetPhoto(_displayName: string): jObject;

    procedure AddContact(_displayName: string; _mobileNumber: string; _homeNumber: string;  _workNumber: string; _homeEmail: string; _workEmail: string; _companyName: string; _jobTitle: string; _bitmapImage: jObject); overload;
    procedure GetContactsAsync(_delimiter: string);

    procedure AddContact(_displayName: string; _mobileNumber: string); overload;
    function GetDisplayName(_contactID: string): string;
    procedure DeleteContact(_displayName: string);
    function GetPhotoByUriAsString(_uriAsString: string): jObject;
    function GetContactInfo(_displayName: string; _delimiter: string): string;
    function GetContactsFromSIMCard(_delimiter: string): TDynArrayOfString;
    //procedure DeleteContactFromSIMCard(_displayName: string);

    procedure GenEvent_OnContactManagerContactsExecuted(Sender: TObject; count: integer);
    procedure GenEvent_OnContactManagerContactsProgress(Sender: TObject; contactInfo: string;
                                                        contactShortInfo: string;
                                                        contactPhotoUriAsString: string;
                                                        contactPhoto: jObject;  progress: integer; out continueListing: boolean);
 published
    //property ShowInListing: TShowInListingSet read FShowInListing write FShowInListing;
    property OnGetContactsFinished: TOnGetContactsFinished read FOnGetContactsFinished write FOnGetContactsFinished;
    property OnGetContactsProgress: TOnGetContactsProgress read FOnGetContactsProgress write FOnGetContactsProgress;
end;

function jContactManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jContactManager_jFree(env: PJNIEnv; _jcontactmanager: JObject);

function jContactManager_GetMobilePhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string): string;
function jContactManager_GetContactID(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string): string;
procedure jContactManager_UpdateDisplayName(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newDisplayName: string);
procedure jContactManager_UpdateMobilePhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newMobileNumber: string);
procedure jContactManager_UpdateWorkPhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newWorkNumber: string);
procedure jContactManager_UpdateHomePhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newHomeNumber: string);
procedure jContactManager_UpdateHomeEmail(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newHomeEmail: string);
procedure jContactManager_UpdateWorkEmail(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newWorkEmail: string);
procedure jContactManager_UpdateOrganization(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newCompany: string; _newJobTitle: string);
procedure jContactManager_UpdatePhoto(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _bitmapImage: jObject);
function jContactManager_GetPhoto(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string): jObject;

procedure jContactManager_AddContact(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _mobileNumber: string; _homeNumber: string; _workNumber: string; _homeEmail: string; _workEmail: string; _companyName: string; _jobTitle: string; _bitmapImage: jObject); overload;
procedure jContactManager_GetContactsAsync(env: PJNIEnv; _jcontactmanager: JObject; _delimiter: string);

procedure jContactManager_AddContact(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _mobileNumber: string); overload;
function jContactManager_GetDisplayName(env: PJNIEnv; _jcontactmanager: JObject; _contactID: string): string;
procedure jContactManager_DeleteContact(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string);

function jContactManager_GetPhotoByUriAsString(env: PJNIEnv; _jcontactmanager: JObject; _uriAsString: string): jObject;
function jContactManager_GetContactInfo(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _delimiter: string): string;

function jContactManager_GetContactsFromSIMCard(env: PJNIEnv; _jcontactmanager: JObject; _delimiter: string): TDynArrayOfString;

//procedure jContactManager_DeleteContactFromSIMCard(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string);


implementation


{---------  jContactManager  --------------}

constructor jContactManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jContactManager.Destroy;
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

procedure jContactManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jContactManager.jCreate(): jObject;
begin
   Result:= jContactManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jContactManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_jFree(FjEnv, FjObject);
end;

function jContactManager.GetMobilePhoneNumber(_displayName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetMobilePhoneNumber(FjEnv, FjObject, _displayName);
end;

function jContactManager.GetContactID(_displayName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetContactID(FjEnv, FjObject, _displayName);
end;

procedure jContactManager.UpdateDisplayName(_displayName: string; _newDisplayName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateDisplayName(FjEnv, FjObject, _displayName ,_newDisplayName);
end;

procedure jContactManager.UpdateMobilePhoneNumber(_displayName: string; _newMobileNumber: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateMobilePhoneNumber(FjEnv, FjObject, _displayName ,_newMobileNumber);
end;

procedure jContactManager.UpdateWorkPhoneNumber(_displayName: string; _newWorkNumber: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateWorkPhoneNumber(FjEnv, FjObject, _displayName ,_newWorkNumber);
end;

procedure jContactManager.UpdateHomePhoneNumber(_displayName: string; _newHomeNumber: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateHomePhoneNumber(FjEnv, FjObject, _displayName ,_newHomeNumber);
end;

procedure jContactManager.UpdateHomeEmail(_displayName: string; _newHomeEmail: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateHomeEmail(FjEnv, FjObject, _displayName ,_newHomeEmail);
end;

procedure jContactManager.UpdateWorkEmail(_displayName: string; _newWorkEmail: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateWorkEmail(FjEnv, FjObject, _displayName ,_newWorkEmail);
end;

procedure jContactManager.UpdateOrganization(_displayName: string; _newCompany: string; _newJobTitle: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdateOrganization(FjEnv, FjObject, _displayName ,_newCompany ,_newJobTitle);
end;

procedure jContactManager.UpdatePhoto(_displayName: string; _bitmapImage: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_UpdatePhoto(FjEnv, FjObject, _displayName ,_bitmapImage);
end;

function jContactManager.GetPhoto(_displayName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetPhoto(FjEnv, FjObject, _displayName);
end;

procedure jContactManager.AddContact(_displayName: string; _mobileNumber: string; _homeNumber: string;  _workNumber: string; _homeEmail: string; _workEmail: string; _companyName: string; _jobTitle: string; _bitmapImage: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_AddContact(FjEnv, FjObject, _displayName , _mobileNumber, _homeNumber  ,_workNumber ,_homeEmail ,_workEmail ,_companyName ,_jobTitle ,_bitmapImage);
end;

procedure jContactManager.GetContactsAsync(_delimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_GetContactsAsync(FjEnv, FjObject, _delimiter);
end;

procedure jContactManager.GenEvent_OnContactManagerContactsExecuted(Sender: TObject; count: integer);
begin
  if Assigned(FOnGetContactsFinished) then  FOnGetContactsFinished(Sender, count);
end;

procedure jContactManager.GenEvent_OnContactManagerContactsProgress(Sender: TObject; contactInfo: string;
                                                        contactShortInfo: string;
                                                        contactPhotoUriAsString: string;
                                                        contactPhoto: jObject;  progress: integer; out continueListing: boolean);
begin
  continueListing:= True;
  if Assigned(FOnGetContactsProgress) then  FOnGetContactsProgress(Sender, contactInfo, contactShortInfo,
                                                                    contactPhotoUriAsString, contactPhoto,
                                                                    progress, continueListing);
end;

procedure jContactManager.AddContact(_displayName: string; _mobileNumber: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_AddContact(FjEnv, FjObject, _displayName ,_mobileNumber);
end;

function jContactManager.GetDisplayName(_contactID: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetDisplayName(FjEnv, FjObject, _contactID);
end;

procedure jContactManager.DeleteContact(_displayName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_DeleteContact(FjEnv, FjObject, _displayName);
end;

function jContactManager.GetPhotoByUriAsString(_uriAsString: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetPhotoByUriAsString(FjEnv, FjObject, _uriAsString);
end;

function jContactManager.GetContactInfo(_displayName: string; _delimiter: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetContactInfo(FjEnv, FjObject, _displayName ,_delimiter);
end;

function jContactManager.GetContactsFromSIMCard(_delimiter: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContactManager_GetContactsFromSIMCard(FjEnv, FjObject, _delimiter);
end;

{
procedure jContactManager.DeleteContactFromSIMCard(_displayName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContactManager_DeleteContactFromSIMCard(FjEnv, FjObject, _displayName);
end;
}

{-------- jContactManager_JNI_Bridge ----------}

function jContactManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jContactManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jContactManager_jCreate(long _Self) {
      return (java.lang.Object)(new jContactManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jContactManager_jFree(env: PJNIEnv; _jcontactmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcontactmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jContactManager_GetMobilePhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMobilePhoneNumber', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jContactManager_GetContactID(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactID', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateDisplayName(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newDisplayName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newDisplayName));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateDisplayName', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateMobilePhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newMobileNumber: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newMobileNumber));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateMobilePhoneNumber', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateWorkPhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newWorkNumber: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newWorkNumber));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateWorkPhoneNumber', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateHomePhoneNumber(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newHomeNumber: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newHomeNumber));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateHomePhoneNumber', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateHomeEmail(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newHomeEmail: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newHomeEmail));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateHomeEmail', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateWorkEmail(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newWorkEmail: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newWorkEmail));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateWorkEmail', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdateOrganization(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _newCompany: string; _newJobTitle: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_newCompany));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_newJobTitle));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateOrganization', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_UpdatePhoto(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _bitmapImage: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= _bitmapImage;
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdatePhoto', '(Ljava/lang/String;Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jContactManager_GetPhoto(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPhoto', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jContactManager_AddContact(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _mobileNumber: string; _homeNumber: string; _workNumber:
                     string; _homeEmail: string; _workEmail: string; _companyName: string; _jobTitle: string; _bitmapImage: jObject);
var
  jParams: array[0..8] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mobileNumber));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_homeNumber));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_workNumber));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_homeEmail));
  jParams[5].l:= env^.NewStringUTF(env, PChar(_workEmail));
  jParams[6].l:= env^.NewStringUTF(env, PChar(_companyName));
  jParams[7].l:= env^.NewStringUTF(env, PChar(_jobTitle));
  jParams[8].l:= _bitmapImage;
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddContact', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env,jParams[6].l);
  env^.DeleteLocalRef(env,jParams[7].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jContactManager_GetContactsAsync(env: PJNIEnv; _jcontactmanager: JObject; _delimiter: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactsAsync', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jContactManager_AddContact(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _mobileNumber: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mobileNumber));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddContact', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jContactManager_GetDisplayName(env: PJNIEnv; _jcontactmanager: JObject; _contactID: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_contactID));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDisplayName', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContactManager_DeleteContact(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'DeleteContact', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jContactManager_GetPhotoByUriAsString(env: PJNIEnv; _jcontactmanager: JObject; _uriAsString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPhotoByUriAsString', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jContactManager_GetContactInfo(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string; _delimiter: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactInfo', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jContactManager_GetContactsFromSIMCard(env: PJNIEnv; _jcontactmanager: JObject; _delimiter: string): TDynArrayOfString;
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
  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContactsFromSIMCard', '(Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jcontactmanager, jMethod,  @jParams);
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
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

{
procedure jContactManager_DeleteContactFromSIMCard(env: PJNIEnv; _jcontactmanager: JObject; _displayName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_displayName));
  jCls:= env^.GetObjectClass(env, _jcontactmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'DeleteContactFromSIMCard', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontactmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;
}

end.
