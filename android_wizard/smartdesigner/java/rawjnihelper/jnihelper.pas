Unit jnihelper;

{$mode delphi}

interface   

uses
  jni;

type

 jstringArray = jobject;
 TDynArrayOfSmallint = array of smallint;
 TDynArrayOfInteger = array of integer;

 TDynArrayOfLongint = array of longint;
 TDynArrayOfDouble = array of double;
 TDynArrayOfSingle = array of single;
 TDynArrayOfInt64  = array of int64;
 TDynArrayOfString = array of string;

 TDynArrayOfJChar = array of JChar;
 TDynArrayOfJBoolean = array of JBoolean;

 //jbyte <->  shortint
 TDynArrayOfJByte = array of JByte;  //array of shortint
 TDynArrayOfShortint = array of shortint;  //array of jbyte

 TDynArrayOfJObject = array of JObject;

 TArrayOfByte = array of JByte;
 TArrayOfJByte = array of JByte;

function GetString(env: PJNIEnv; jstr: JString): string;
function GetJString(env: PJNIEnv; str: string): JString;
function GetDynArrayOfString(env: PJNIEnv; stringArrayData: jstringArray): TDynArrayOfString;
function GetDynArrayOfSingle(env: PJNIEnv; floatArrayData: jfloatArray): TDynArrayOfSingle;
function GetDynArrayOfDouble(env: PJNIEnv; doubleArrayData: jfloatArray): TDynArrayOfDouble;
function GetDynArrayOfInteger(env: PJNIEnv; intArrayData: jintArray): TDynArrayOfInteger;
function GetDynArrayOfJByte(env: PJNIEnv; byteArrayData: jbytearray): TDynArrayOfJByte;

function GetJObjectOfDynArrayOfJByte(env: PJNIEnv; var dataContent: TDynArrayOfJByte):jbyteArray; //jObject;
function GetJObjectOfDynArrayOfSingle(env: PJNIEnv; var dataContent: TDynArrayOfSingle):jfloatArray; // jObject;
function GetJObjectOfDynArrayOfDouble(env: PJNIEnv; var dataContent: TDynArrayOfDouble):jdoubleArray; // jObject;
function GetJObjectOfDynArrayOfInteger(env: PJNIEnv; var dataContent: TDynArrayOfInteger):jintArray; // jObject;
function GetJObjectOfDynArrayOfString(env: PJNIEnv; var dataContent: TDynArrayOfString): jstringArray;  // jObject;
function GetJBoolean(b: boolean): byte;

implementation

function GetJBoolean(b: boolean): byte;
begin
  Case b of
   True  : Result := 1;
   False : Result := 0;
  End;
end;

function GetString(env: PJNIEnv; jstr: JString): string;
var
 _jBoolean: JBoolean;
begin
    Result := '';
    if jstr <> nil then
    begin
      _jBoolean:= JNI_False;
      Result:= string(env^.GetStringUTFChars(env,jstr,@_jBoolean));
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

end.
