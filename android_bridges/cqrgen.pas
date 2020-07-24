unit cqrgen;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/21/2020 23:23:40]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcQRGen = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function GetURLQRCode(_url: string): jObject; overload;
    function GetTextQRCode(_txt: string): jObject; overload;
    function GetEMailQRCode(_email: string): jObject; overload;
    function GetMeCardQRCode(_name: string; _email: string; _address: string; _phone: string): jObject; overload;
    function GetVCardQRCode(_name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string): jObject; overload;

    function GetURLQRCode(_url: string; _width: integer; _height: integer): jObject; overload;
    function GetTextQRCode(_txt: string; _width: integer; _height: integer): jObject; overload;
    function GetEMailQRCode(_email: string; _width: integer; _height: integer): jObject; overload;
    function GetMeCardQRCode(_name: string; _email: string; _address: string; _phone: string; _width: integer; _height: integer): jObject; overload;
    function GetVCardQRCode(_name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string; _width: integer; _height: integer): jObject; overload;


 published

end;

function jcQRGen_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcQRGen_jFree(env: PJNIEnv; _jcqrgen: JObject);

function jcQRGen_GetURLQRCode(env: PJNIEnv; _jcqrgen: JObject; _url: string): jObject; overload;
function jcQRGen_GetTextQRCode(env: PJNIEnv; _jcqrgen: JObject; _txt: string): jObject; overload;
function jcQRGen_GetEMailQRCode(env: PJNIEnv; _jcqrgen: JObject; _email: string): jObject; overload;
function jcQRGen_GetMeCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string): jObject; overload;
function jcQRGen_GetVCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string): jObject; overload;

function jcQRGen_GetURLQRCode(env: PJNIEnv; _jcqrgen: JObject; _url: string; _width: integer; _height: integer): jObject; overload;
function jcQRGen_GetTextQRCode(env: PJNIEnv; _jcqrgen: JObject; _txt: string; _width: integer; _height: integer): jObject; overload;
function jcQRGen_GetEMailQRCode(env: PJNIEnv; _jcqrgen: JObject; _email: string; _width: integer; _height: integer): jObject; overload;
function jcQRGen_GetMeCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string; _width: integer; _height: integer): jObject; overload;
function jcQRGen_GetVCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string; _width: integer; _height: integer): jObject; overload;


implementation

{---------  jcQRGen  --------------}

constructor jcQRGen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcQRGen.Destroy;
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

procedure jcQRGen.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jcQRGen.jCreate(): jObject;
begin
   Result:= jcQRGen_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jcQRGen.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcQRGen_jFree(FjEnv, FjObject);
end;

function jcQRGen.GetURLQRCode(_url: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetURLQRCode(FjEnv, FjObject, _url);
end;

function jcQRGen.GetTextQRCode(_txt: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetTextQRCode(FjEnv, FjObject, _txt);
end;

function jcQRGen.GetEMailQRCode(_email: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetEMailQRCode(FjEnv, FjObject, _email);
end;

function jcQRGen.GetMeCardQRCode(_name: string; _email: string; _address: string; _phone: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetMeCardQRCode(FjEnv, FjObject, _name ,_email ,_address ,_phone);
end;

function jcQRGen.GetVCardQRCode(_name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetVCardQRCode(FjEnv, FjObject, _name ,_email ,_address ,_phone ,_title ,_company ,_website);
end;

function jcQRGen.GetURLQRCode(_url: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetURLQRCode(FjEnv, FjObject, _url ,_width ,_height);
end;

function jcQRGen.GetTextQRCode(_txt: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetTextQRCode(FjEnv, FjObject, _txt ,_width ,_height);
end;

function jcQRGen.GetEMailQRCode(_email: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetEMailQRCode(FjEnv, FjObject, _email ,_width ,_height);
end;

function jcQRGen.GetMeCardQRCode(_name: string; _email: string; _address: string; _phone: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetMeCardQRCode(FjEnv, FjObject, _name ,_email ,_address ,_phone ,_width ,_height);
end;

function jcQRGen.GetVCardQRCode(_name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcQRGen_GetVCardQRCode(FjEnv, FjObject, _name ,_email ,_address ,_phone ,_title ,_company ,_website ,_width ,_height);
end;

{-------- jcQRGen_JNI_Bridge ----------}

function jcQRGen_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcQRGen_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcQRGen_jFree(env: PJNIEnv; _jcqrgen: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcqrgen, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcQRGen_GetURLQRCode(env: PJNIEnv; _jcqrgen: JObject; _url: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_url));
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetURLQRCode', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetTextQRCode(env: PJNIEnv; _jcqrgen: JObject; _txt: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txt));
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextQRCode', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetEMailQRCode(env: PJNIEnv; _jcqrgen: JObject; _email: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_email));
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetEMailQRCode', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetMeCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_email));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_phone));
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMeCardQRCode', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetVCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string): jObject;
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_email));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_phone));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[5].l:= env^.NewStringUTF(env, PChar(_company));
  jParams[6].l:= env^.NewStringUTF(env, PChar(_website));
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetVCardQRCode', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env,jParams[6].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcQRGen_GetURLQRCode(env: PJNIEnv; _jcqrgen: JObject; _url: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_url));
  jParams[1].i:= _width;
  jParams[2].i:= _height;
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetURLQRCode', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetTextQRCode(env: PJNIEnv; _jcqrgen: JObject; _txt: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txt));
  jParams[1].i:= _width;
  jParams[2].i:= _height;
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextQRCode', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetEMailQRCode(env: PJNIEnv; _jcqrgen: JObject; _email: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_email));
  jParams[1].i:= _width;
  jParams[2].i:= _height;
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetEMailQRCode', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetMeCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_email));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_phone));
  jParams[4].i:= _width;
  jParams[5].i:= _height;
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMeCardQRCode', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcQRGen_GetVCardQRCode(env: PJNIEnv; _jcqrgen: JObject; _name: string; _email: string; _address: string; _phone: string; _title: string; _company: string; _website: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..8] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_email));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_phone));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[5].l:= env^.NewStringUTF(env, PChar(_company));
  jParams[6].l:= env^.NewStringUTF(env, PChar(_website));
  jParams[7].i:= _width;
  jParams[8].i:= _height;
  jCls:= env^.GetObjectClass(env, _jcqrgen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetVCardQRCode', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcqrgen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env,jParams[6].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
