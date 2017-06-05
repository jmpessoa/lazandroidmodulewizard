unit imagefilemanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [11/9/2014 17:38:45]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jImageFileManager = class(jControl)
 private

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SaveToSdCard(_image: jObject; _filename: string);
    procedure ShowImagesFromGallery();
    function LoadFromSdCard(_filename: string): jObject;
    function LoadFromURL(_imageURL: string): jObject;
    function LoadFromAssets(filename: string): jObject;
    function LoadFromResources(_imageResIdentifier: string): jObject;
    function LoadFromFile(_filenameInternalAppStorage: string): jObject; overload;
    function LoadFromFile(_pathEnvironment: string; _filename: string): jObject; overload;
    procedure SaveToFile(_image: jObject; _filename: string); overload;
    procedure SaveToFile(_image: jObject;_path: string; _filename: string); overload;
    function LoadFromUri(_imageUri: jObject): jObject;   overload;

    function LoadFromFile(_filename: string; _scale: integer): jObject; overload;
    function CreateBitmap(_width: integer; _height: integer): jObject;
    function GetBitmapWidth(_bitmap: jObject): integer;
    function GetBitmapHeight(_bitmap: jObject): integer;

    //_compressFormat -->> 'WEBP' or 'JPEG'  or 'PNG'
    function GetByteArrayFromBitmap(_bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;

    function SetByteArrayToBitmap(var _imageArray: TDynArrayOfJByte): jObject;
    function ClockWise(_bitmap: jObject; _imageView: jObject): jObject;
    function AntiClockWise(_bitmap: jObject; _imageView: jObject): jObject;
    function SetScale(_bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;
    function GetBitmapFromDecodedFile(_imagePath: string): jObject;
    function GetBitmapFromIntentResult(_intentData: jObject): jObject;
    function GetBitmapThumbnailFromCamera(_intentData: jObject): jObject;
    function LoadFromUri(_uriAsString: string): jObject; overload;

 published

end;

function jImageFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jImageFileManager_jFree(env: PJNIEnv; _jimagefilemanager: JObject);
procedure jImageFileManager_SaveToSdCard(env: PJNIEnv; _jimagefilemanager: JObject; _image: jObject; _filename: string);
procedure jImageFileManager_ShowImagesFromGallery(env: PJNIEnv; _jimagefilemanager: JObject);
function jImageFileManager_LoadFromSdCard(env: PJNIEnv; _jimagefilemanager: JObject; _filename: string): jObject;
function jImageFileManager_LoadFromURL(env: PJNIEnv; _jimagefilemanager: JObject; _imageURL: string): jObject;
function jImageFileManager_LoadFromAssets(env: PJNIEnv; _jimagefilemanager: JObject; strName: string): jObject;
function jImageFileManager_LoadFromResources(env: PJNIEnv; _jimagefilemanager: JObject; _imageResIdentifier: string): jObject;
function jImageFileManager_LoadFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _filename: string): jObject; overload;
function jImageFileManager_LoadFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _path: string; _filename: string): jObject; overload;
procedure jImageFileManager_SaveToFile(env: PJNIEnv; _jimagefilemanager: JObject; _image: jObject; _filename: string); overload;
procedure jImageFileManager_SaveToFile(env: PJNIEnv; _jimagefilemanager: JObject; _image: jObject;_path:string; _filename: string); overload;
function jImageFileManager_LoadFromUri(env: PJNIEnv; _jimagefilemanager: JObject; _imageUri: jObject): jObject;  overload;

function jImageFileManager_LoadFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _filename: string; _scale: integer): jObject;  overload;
function jImageFileManager_CreateBitmap(env: PJNIEnv; _jimagefilemanager: JObject; _width: integer; _height: integer): jObject;
function jImageFileManager_GetBitmapWidth(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject): integer;
function jImageFileManager_GetBitmapHeight(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject): integer;
function jImageFileManager_GetByteArrayFromBitmap(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;
function jImageFileManager_SetByteArrayToBitmap(env: PJNIEnv; _jimagefilemanager: JObject; var _imageArray: TDynArrayOfJByte): jObject;
function jImageFileManager_Clockwise(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject; _imageView: jObject): jObject;
function jImageFileManager_AntiClockWise(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject; _imageView: jObject): jObject;
function jImageFileManager_SetScale(env: PJNIEnv; _jimagefilemanager: JObject; _bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;

function jImageFileManager_GetBitmapFromDecodedFile(env: PJNIEnv; _jimagefilemanager: JObject; _imagePath: string): jObject;
function jImageFileManager_GetBitmapFromIntentResult(env: PJNIEnv; _jimagefilemanager: JObject; _intentData: jObject): jObject;
function jImageFileManager_GetBitmapThumbnailFromCamera(env: PJNIEnv; _jimagefilemanager: JObject; _intentData: jObject): jObject;

function jImageFileManager_LoadFromUri(env: PJNIEnv; _jimagefilemanager: JObject; _uriAsString: string): jObject; overload;

implementation

{---------  jImageFileManager  --------------}

constructor jImageFileManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jImageFileManager.Destroy;
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

procedure jImageFileManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jImageFileManager.jCreate(): jObject;
begin
   Result:= jImageFileManager_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jImageFileManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_jFree(FjEnv, FjObject);
end;

procedure jImageFileManager.SaveToSdCard(_image: jObject; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_SaveToSdCard(FjEnv, FjObject, _image ,_filename);
end;

procedure jImageFileManager.ShowImagesFromGallery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_ShowImagesFromGallery(FjEnv, FjObject);
end;

function jImageFileManager.LoadFromSdCard(_filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromSdCard(FjEnv, FjObject, _filename);
end;

function jImageFileManager.LoadFromURL(_imageURL: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromURL(FjEnv, FjObject, _imageURL);
end;

function jImageFileManager.LoadFromAssets(filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromAssets(FjEnv, FjObject, filename);
end;

function jImageFileManager.LoadFromResources(_imageResIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromResources(FjEnv, FjObject, _imageResIdentifier);
end;


function jImageFileManager.LoadFromFile(_filenameInternalAppStorage: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromFile(FjEnv, FjObject, _filenameInternalAppStorage);
end;

function jImageFileManager.LoadFromFile(_pathEnvironment: string; _filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jImageFileManager_LoadFromFile(FjEnv, FjObject,_pathEnvironment, _filename);
end;

procedure jImageFileManager.SaveToFile(_image: jObject; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_SaveToFile(FjEnv, FjObject, _image ,_filename);
end;

procedure jImageFileManager.SaveToFile(_image: jObject; _path:string;  _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_SaveToFile(FjEnv, FjObject, _image ,_path, _filename);
end;

function jImageFileManager.LoadFromUri(_imageUri: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromUri(FjEnv, FjObject, _imageUri);
end;

function jImageFileManager.LoadFromFile(_filename: string; _scale: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromFile(FjEnv, FjObject, _filename ,_scale);
end;

function jImageFileManager.CreateBitmap(_width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_CreateBitmap(FjEnv, FjObject, _width ,_height);
end;

function jImageFileManager.GetBitmapWidth(_bitmap: jObject): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_GetBitmapWidth(FjEnv, FjObject, _bitmap);
end;

function jImageFileManager.GetBitmapHeight(_bitmap: jObject): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_GetBitmapHeight(FjEnv, FjObject, _bitmap);
end;

function jImageFileManager.GetByteArrayFromBitmap(_bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;
begin
  //in designing component state: result value here...
  if FInitialized then
     Result:= jImageFileManager_GetByteArrayFromBitmap(FjEnv, FjObject, _bitmap ,_compressFormat);
end;

function jImageFileManager.SetByteArrayToBitmap(var _imageArray: TDynArrayOfJByte): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_SetByteArrayToBitmap(FjEnv, FjObject, _imageArray);
end;

function jImageFileManager.ClockWise(_bitmap: jObject; _imageView: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_ClockWise(FjEnv, FjObject, _bitmap ,_imageView);
end;

function jImageFileManager.AntiClockWise(_bitmap: jObject; _imageView: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_AntiClockWise(FjEnv, FjObject, _bitmap ,_imageView);
end;

function jImageFileManager.SetScale(_bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_SetScale(FjEnv, FjObject, _bmp ,_imageView ,_scaleX ,_scaleY);
end;


function jImageFileManager.GetBitmapFromDecodedFile(_imagePath: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_GetBitmapFromDecodedFile(FjEnv, FjObject, _imagePath);
end;

function jImageFileManager.GetBitmapFromIntentResult(_intentData: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_GetBitmapFromIntentResult(FjEnv, FjObject, _intentData);
end;


function jImageFileManager.GetBitmapThumbnailFromCamera(_intentData: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_GetBitmapThumbnailFromCamera(FjEnv, FjObject, _intentData);
end;

function jImageFileManager.LoadFromUri(_uriAsString: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromUri(FjEnv, FjObject, _uriAsString);
end;

{-------- jImageFileManager_JNI_Bridge ----------}

function jImageFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jImageFileManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jImageFileManager_jCreate(long _Self) {
      return (java.lang.Object)(new jImageFileManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jImageFileManager_jFree(env: PJNIEnv; _jimagefilemanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jimagefilemanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jImageFileManager_SaveToSdCard(env: PJNIEnv; _jimagefilemanager: JObject; _image: jObject; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _image;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToSdCard', '(Landroid/graphics/Bitmap;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jImageFileManager_ShowImagesFromGallery(env: PJNIEnv; _jimagefilemanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowImagesFromGallery', '()V');
  env^.CallVoidMethod(env, _jimagefilemanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_LoadFromSdCard(env: PJNIEnv; _jimagefilemanager: JObject; _filename: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromSdCard', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_LoadFromURL(env: PJNIEnv; _jimagefilemanager: JObject; _imageURL: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageURL));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromURL', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_LoadFromAssets(env: PJNIEnv; _jimagefilemanager: JObject; strName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(strName));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssets', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_LoadFromResources(env: PJNIEnv; _jimagefilemanager: JObject; _imageResIdentifier: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageResIdentifier));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromResources', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_LoadFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _filename: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_LoadFromFile(env: PJNIEnv; _jimagefilemanager: JObject;_path: string; _filename: string): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jImageFileManager_SaveToFile(env: PJNIEnv; _jimagefilemanager: JObject; _image: jObject; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _image;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Landroid/graphics/Bitmap;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jImageFileManager_SaveToFile(env: PJNIEnv; _jimagefilemanager: JObject; _image: jObject; _path: string; _filename: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _image;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Landroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_LoadFromUri(env: PJNIEnv; _jimagefilemanager: JObject; _imageUri: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _imageUri;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromUri', '(Landroid/net/Uri;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_LoadFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _filename: string; _scale: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jParams[1].i:= _scale;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;I)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_CreateBitmap(env: PJNIEnv; _jimagefilemanager: JObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateBitmap', '(II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_GetBitmapWidth(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapWidth', '(Landroid/graphics/Bitmap;)I');
  Result:= env^.CallIntMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_GetBitmapHeight(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapHeight', '(Landroid/graphics/Bitmap;)I');
  Result:= env^.CallIntMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_GetByteArrayFromBitmap(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_compressFormat));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteArrayFromBitmap', '(Landroid/graphics/Bitmap;Ljava/lang/String;)[B');
  jResultArray:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_SetByteArrayToBitmap(env: PJNIEnv; _jimagefilemanager: JObject; var _imageArray: TDynArrayOfJByte): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_imageArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_imageArray[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetByteArrayToBitmap', '([B)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_ClockWise(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject; _imageView: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].l:= _imageView;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ClockWise', '(Landroid/graphics/Bitmap;Landroid/widget/ImageView;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_AntiClockWise(env: PJNIEnv; _jimagefilemanager: JObject; _bitmap: jObject; _imageView: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].l:= _imageView;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'AntiClockWise', '(Landroid/graphics/Bitmap;Landroid/widget/ImageView;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_SetScale(env: PJNIEnv; _jimagefilemanager: JObject; _bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bmp;
  jParams[1].l:= _imageView;
  jParams[2].f:= _scaleX;
  jParams[3].f:= _scaleY;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScale', '(Landroid/graphics/Bitmap;Landroid/widget/ImageView;FF)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_GetBitmapFromDecodedFile(env: PJNIEnv; _jimagefilemanager: JObject; _imagePath: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imagePath));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapFromDecodedFile', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jImageFileManager_GetBitmapFromIntentResult(env: PJNIEnv; _jimagefilemanager: JObject; _intentData: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intentData;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapFromIntentData', '(Landroid/content/Intent;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_GetBitmapThumbnailFromCamera(env: PJNIEnv; _jimagefilemanager: JObject; _intentData: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intentData;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapThumbnailFromCamera', '(Landroid/content/Intent;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jImageFileManager_LoadFromUri(env: PJNIEnv; _jimagefilemanager: JObject; _uriAsString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromUri', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
