// *****************************************************************************
// *****************************************************************************
//
//                   WebDAV (RFC 2518) client for LAMW
//
//    LAMW WebDAV client uses the jWebDav class from the "jWebDav.java" file.
//  Supports both Basic and Digest authorization on the server.
//    The authorization type is selected automatically inside the JAVA code
//  when calling all commands depending on the WebDAV server responses.
//    Chunked blockdata is also implemented when receiving data from
//  the server.
//
// *****************************************************************************
// *****************************************************************************
//
//    The following commands are defined in the jWebDav class:
//
//  procedure SetUserNameAndPassword(_userName: string; _password: string);
//    - setting the user name and password for authorization on the server
//
//  procedure SetHostNameAndPort (_hostName: string; _port: integer);
//    - setting the server name and port number
//
//  function PROPFIND (_element: string): string;
//    - getting the properties of an object on the server in XML format
//
//  function DELETE (_elementHref: string): string;
//    - deleting an object on the server
//
//  function GET (_elementHref: string; _fileName: string): string;
//    - copying a file from storage to the device in the calling thread
//
//  function PUT (_elementHref: string; _fileName: string): string;
//    - copying a file from the device to storage in the calling thread
//
//  procedure DnLoadFile(_elementHref: string; _fileName: string);
//    - copying a file from storage to the device in the internal JAVA thread
//
//  procedure UpLoadFile(_elementHref: string; _fileName: string);
//    - copying a file from the device to storage in the internal JAVA thread
//
//    The following jWebDav Call Back procedures are required to interact with
//  the internal JAVA thread when exchanging files between the device and storage
//  on the server:
//
//  property OnWebDavGetResultStr : TOnWebDavGetResultStr;
//    - processes the operation result string (DnLoadFile or UpLoadFile)
//
//  property OnWebDavGetProgress : TOnWebDavGetProgress;
//    - displays the progress of the operation (DnLoadFile or UpLoadFile)
//
// *****************************************************************************
// *****************************************************************************

unit webdav;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type
// *****************************************************************************
// ***************************** jWebDav ***************************************
// *****************************************************************************
  TOnWebDavGetResultStr =
    procedure(Sender:TObject; inputLine:string)  of object;

  TOnWebDavGetProgress  =
    procedure(Sender:TObject; position:integer;
                              Size    :integer)  of object;

  jWebDav               =
    class(jControl)
      private
        FOnWebDavGetResultStr : TOnWebDavGetResultStr;
        FOnWebDavGetProgress  : TOnWebDavGetProgress;
      public
        constructor Create(AOwner: TComponent);                        override;
        destructor  Destroy;                                           override;
        procedure   Init;                                              override;
        function    jCreate() : jObject;
        procedure   jFree();
//------------------------------------------------------------------------------
        procedure   SetUserNameAndPassword(_userName: string; _password: string);
        procedure   SetHostNameAndPort    (_hostName: string; _port: integer);
//------------------------------------------------------------------------------
        function    PROPFIND  (    _element: string): string;
        function    DELETE    (_elementHref: string): string;
        function    PUT       (_elementHref: string; _fileName: string): string;
        function    GET       (_elementHref: string; _fileName: string): string;
//------------------------------------------------------------------------------
        function    MKCOL     (    _element: string): string;
        function    PROPPATCH (_elementHref: string; _elementProp
                                                              : string): string;
        procedure   UpLoadFile(_elementHref: string; _fileName: string);
        procedure   DnLoadFile(_elementHref: string; _fileName: string);
//------------------------------------------------------------------------------
        procedure   GenEvent_OnWebDavGetResultStr(Sender:TObject; inputLine:string);
        procedure   GenEvent_OnWebDavGetProgress (Sender:TObject; position :integer;
                                                                  Size     :integer);
//------------------------------------------------------------------------------
      published
        property    OnWebDavGetResultStr : TOnWebDavGetResultStr
                                                     read  FOnWebDavGetResultStr
                                                     write FOnWebDavGetResultStr;
        property    OnWebDavGetProgress  : TOnWebDavGetProgress
                                                     read  FOnWebDavGetProgress
                                                     write FOnWebDavGetProgress;
    end;


function  jWebDav_jCreate   (env: PJNIEnv; _Self: int64; this: jObject): jObject;

procedure jWebDav_jFree     (env: PJNIEnv; _jwebdav: JObject);

procedure jWebDav_SetUserNameAndPassword
                            (env: PJNIEnv; _jwebdav: JObject; _userName: string;
                                                              _password: string);
procedure jWebDav_SetHostNameAndPort
                            (env: PJNIEnv; _jwebdav: JObject; _hostName: string;
                                                              _port: integer);
function  jWebDav_PROPFIND  (env: PJNIEnv; _jwebdav: JObject; _element : string)
                                                                       : string;
function  jWebDav_DELETE    (env: PJNIEnv; _jwebdav: JObject; _elementHref
                                                                       : string)
                                                                       : string;
function  jWebDav_PUT       (env: PJNIEnv; _jwebdav: JObject; _elementHref
                                                                       : string;
                                                              _fileName: string)
                                                                       : string;
function  jWebDav_GET       (env: PJNIEnv; _jwebdav: JObject; _elementHref
                                                                       : string;
                                                              _fileName: string)
                                                                       : string;
function  jWebDav_MKCOL     (env: PJNIEnv; _jwebdav: JObject; _element : string)
                                                                       : string;
function  jWebDav_PROPPATCH (env: PJNIEnv; _jwebdav: JObject; _elementHref
                                                                       : string;
                                                              _elementProp
                                                                       : string)
                                                                       : string;
procedure jWebDav_UpLoadFile(env: PJNIEnv; _jwebdav: JObject; _elementHref
                                                                       : string;
                                                              _fileName: string);
procedure jWebDav_DnLoadFile(env: PJNIEnv; _jwebdav: JObject; _elementHref
                                                                       : string;
                                                              _fileName: string);


implementation


// *****************************************************************************
// ***************************** jWebDav ***************************************
// *****************************************************************************
constructor jWebDav.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
                    // your code here....
end;

destructor jWebDav.Destroy;
begin
  If Not (csDesigning in ComponentState) then
    begin
      If FjObject <> Nil then
        begin
          jFree();
          FjObject:= Nil;
        end;
    end;
                    // you others free code here...'
  inherited Destroy;
end;

procedure jWebDav.Init;
begin
  If FInitialized  then Exit;
  inherited Init;   // set default ViewParent/FjPRLayout as jForm.View!
                    // your code here: set/initialize create params....
     FjObject  := jCreate();
                    // jSelf !
  If FjObject   = Nil then Exit;
  FInitialized := True;
end;

function jWebDav.jCreate(): jObject;
begin
  Result:= jWebDav_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jWebDav.jFree();
begin
  //in designing component state: set value here...
  If FInitialized then
     jWebDav_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jWebDav.SetUserNameAndPassword(_userName: string; _password: string);
begin
  //in designing component state: set value here...
  If FInitialized then
     jWebDav_SetUserNameAndPassword(gApp.jni.jEnv, FjObject, _userName ,_password);
end;

procedure jWebDav.SetHostNameAndPort    (_hostName: string; _port: integer);
begin
  //in designing component state: set value here...
  If FInitialized then
     jWebDav_SetHostNameAndPort(gApp.jni.jEnv, FjObject, _hostName ,_port);
end;

function jWebDav.PROPFIND(_element: string): string;
begin
  //in designing component state: result value here...
  If FInitialized then
    Result:= jWebDav_PROPFIND(gApp.jni.jEnv, FjObject, _element)
                  else
    Result:= '';
end;

function jWebDav.DELETE(_elementHref: string): string;
begin
  //in designing component state: result value here...
  If FInitialized then
    Result:= jWebDav_DELETE(gApp.jni.jEnv, FjObject, _elementHref)
                  else
    Result:= '';
end;

function jWebDav.PUT(_elementHref: string; _fileName: string): string;
begin
  //in designing component state: result value here...
  If FInitialized then
    Result:= jWebDav_PUT(gApp.jni.jEnv, FjObject, _elementHref ,_fileName)
                  else
    Result:= '';
end;

function jWebDav.GET(_elementHref: string; _fileName: string): string;
begin
  //in designing component state: result value here...
  If FInitialized then
    Result:= jWebDav_GET(gApp.jni.jEnv, FjObject, _elementHref ,_fileName)
                  else
    Result:= '';
end;

function jWebDav.MKCOL(_element: string): string;
begin
  //in designing component state: result value here...
  If FInitialized then
    Result:= jWebDav_MKCOL(gApp.jni.jEnv, FjObject, _element)
                  else
    Result:= '';
end;

function jWebDav.PROPPATCH(_elementHref: string; _elementProp: string): string;
begin
  //in designing component state: result value here...
  If FInitialized then
    Result:= jWebDav_PROPPATCH(gApp.jni.jEnv, FjObject, _elementHref ,_elementProp)
                  else
    Result:= '';
end;

procedure jWebDav.UpLoadFile(_elementHref: string; _fileName: string);
begin
  //in designing component state: set value here...
  If FInitialized then
    jWebDav_UpLoadFile(gApp.jni.jEnv, FjObject, _elementHref ,_fileName);
end;

procedure jWebDav.DnLoadFile(_elementHref: string; _fileName: string);
begin
  //in designing component state: set value here...
  If FInitialized then
    jWebDav_DnLoadFile(gApp.jni.jEnv, FjObject, _elementHref ,_fileName);
end;

procedure jWebDav.GenEvent_OnWebDavGetResultStr(Sender:TObject;inputLine:string);
begin
  If Assigned(FOnWebDavGetResultStr)then FOnWebDavGetResultStr(Sender,inputLine);
end;

procedure jWebDav.GenEvent_OnWebDavGetProgress(Sender:TObject; position:integer;
                                                               Size    :integer);
begin
  If Assigned(FOnWebDavGetProgress) then FOnWebDavGetProgress(Sender,position,Size);
end;


// *****************************************************************************
// *********************** jWebDav_JNI_Bridge **********************************
// *****************************************************************************
function jWebDav_jCreate(env: PJNIEnv; _Self: int64; this: jObject): jObject;
var
  jParams : Array[0..0] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result  := Nil;
  If (env  = Nil) or (this = Nil) then Exit;
     jCls := Get_gjClass(env);
  If jCls  = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'jWebDav_jCreate',
                                '(J)Ljava/lang/Object;');
  If jMethod = Nil then GoTo _exceptionOcurred;
  jParams[0].j:= _Self;
  Result  :=   env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result  :=   env^.NewGlobalRef     (env, Result);

  _exceptionOcurred: If jni_ExceptionOccurred(env) then result := Nil;
end;


procedure jWebDav_jFree(env: PJNIEnv; _jwebdav: JObject);
var
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  If (env = Nil) or (_jwebdav = Nil) then exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  If jMethod = Nil then
    begin      env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;
               env^.CallVoidMethod(env, _jwebdav, jMethod);
               env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jWebDav_SetUserNameAndPassword(env: PJNIEnv; _jwebdav: JObject;
                                         _userName: string; _password: string);
var
  jParams : Array[0..1] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  If (env = Nil) or (_jwebdav = Nil) then exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'SetUserNameAndPassword',
                                '(Ljava/lang/String;Ljava/lang/String;)V');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_userName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));

                 env^.CallVoidMethodA(env, _jwebdav, jMethod, @jParams);
                 env^.DeleteLocalRef (env,  jParams[0].l);
                 env^.DeleteLocalRef (env,  jParams[1].l);
                 env^.DeleteLocalRef (env,  jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jWebDav_SetHostNameAndPort(env: PJNIEnv; _jwebdav: JObject;
                                     _hostName: string; _port: integer);
var
  jParams : Array[0..1] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  If (env = Nil) or (_jwebdav = Nil) then exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'SetHostNameAndPort',
                               '(Ljava/lang/String;I)V');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_hostName));
  jParams[1].i:= _port;

                 env^.CallVoidMethodA(env, _jwebdav, jMethod, @jParams);
                 env^.DeleteLocalRef (env,  jParams[0].l);
                 env^.DeleteLocalRef (env,  jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jWebDav_PROPFIND(env: PJNIEnv; _jwebdav: JObject; _element: string): string;
var
  jStr    : JString;
  jParams : Array[0..0] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result:= '';
  If (env = Nil) or (_jwebdav = Nil) then Exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'PROPFIND',
                                '(Ljava/lang/String;)Ljava/lang/String;');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_element));
  jStr        := env^.CallObjectMethodA(env, _jwebdav, jMethod, @jParams);
  Result      := GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jWebDav_DELETE(env: PJNIEnv; _jwebdav: JObject; _elementHref: string): string;
var
  jStr    : JString;
  jParams : Array[0..0] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result:= '';
  If (env = Nil) or (_jwebdav = Nil) then Exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'DELETE',
                                '(Ljava/lang/String;)Ljava/lang/String;');
  If jMethod = Nil
    then begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_elementHref));
  jStr        := env^.CallObjectMethodA(env, _jwebdav, jMethod, @jParams);
  Result      := GetPStringAndDeleteLocalRef(env, jStr);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jWebDav_PUT(env: PJNIEnv; _jwebdav: JObject; _elementHref: string;
                     _fileName: string): string;
var
  jStr    : JString;
  jParams : Array[0..1] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result:= '';
  If (env = Nil) or (_jwebdav = Nil) then exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'PUT',
       '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_elementHref));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jStr        := env^.CallObjectMethodA(env, _jwebdav, jMethod, @jParams);

  Result      := GetPStringAndDeleteLocalRef(env, jStr);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env,jParams[1].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jWebDav_GET(env: PJNIEnv; _jwebdav: JObject; _elementHref: string;
                     _fileName: string): string;
var
  jStr    : JString;
  jParams : Array[0..1] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result:= '';
  If (env = Nil) or (_jwebdav = Nil) then exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'GET',
       '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_elementHref));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jStr        := env^.CallObjectMethodA(env, _jwebdav, jMethod, @jParams);
  Result      := GetPStringAndDeleteLocalRef(env, jStr);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env,jParams[1].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jWebDav_MKCOL(env: PJNIEnv; _jwebdav: JObject; _element: string): string;
var
  jStr    : JString;
  jParams : Array[0..0] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result:= '';
  If (env = Nil) or (_jwebdav = Nil) then Exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'MKCOL',
                                '(Ljava/lang/String;)Ljava/lang/String;');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_element));
  jStr        := env^.CallObjectMethodA(env, _jwebdav, jMethod, @jParams);
  Result      := GetPStringAndDeleteLocalRef(env, jStr);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jWebDav_PROPPATCH(env: PJNIEnv; _jwebdav: JObject; _elementHref: string;
                           _elementProp: string): string;
var
  jStr    : JString;
  jParams : Array[0..1] of jValue;
  jMethod : jMethodID = Nil;
  jCls    : jClass    = Nil;
label
  _exceptionOcurred;
begin
  Result:= '';
  If (env = Nil) or (_jwebdav = Nil) then Exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'PROPPATCH',
                                '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_elementHref));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_elementProp));
  jStr        := env^.CallObjectMethodA(env, _jwebdav, jMethod, @jParams);
  Result      := GetPStringAndDeleteLocalRef(env, jStr);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env,jParams[1].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jWebDav_UpLoadFile(env: PJNIEnv; _jwebdav: JObject;
                             _elementHref: string; _fileName: string);
var
  jParams  : array[0..1] of jValue;
  jMethod  : jMethodID = Nil;
  jCls     : jClass    = Nil;
label
  _exceptionOcurred;
begin
  If (env = Nil) or (_jwebdav = Nil) then Exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'UpLoadFile',
                                '(Ljava/lang/String;Ljava/lang/String;)V');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_elementHref));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
                 env^.CallVoidMethodA(env, _jwebdav, jMethod, @jParams);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env,jParams[1].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jWebDav_DnLoadFile(env: PJNIEnv; _jwebdav: JObject; _elementHref: string; _fileName: string);
var
  jParams  : Array[0..1] of jValue;
  jMethod  : jMethodID = Nil;
  jCls     : jClass    = Nil;
label
  _exceptionOcurred;
begin
  If (env = Nil) or (_jwebdav = Nil) then Exit;
     jCls:= env^.GetObjectClass(env, _jwebdav);
  If jCls = Nil then GoTo _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'DnLoadFile',
                                '(Ljava/lang/String;Ljava/lang/String;)V');
  If jMethod = Nil then
    begin env^.DeleteLocalRef(env, jCls); GoTo _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_elementHref));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
                 env^.CallVoidMethodA(env, _jwebdav, jMethod, @jParams);
                 env^.DeleteLocalRef(env,jParams[0].l);
                 env^.DeleteLocalRef(env,jParams[1].l);
                 env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;



end.
