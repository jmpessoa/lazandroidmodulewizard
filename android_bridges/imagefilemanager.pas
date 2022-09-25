unit imagefilemanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [11/9/2014 17:38:45]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

{ jImageFileManager }

jImageFileManager = class(jControl)
 private

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function  SaveToSdCard(_image: jObject; _filename: string) : boolean;
    procedure ShowImagesFromGallery();
    function LoadFromSdCard(_filename: string): jObject;
    function LoadFromURL(_imageURL: string): jObject;
    function LoadFromAssets(filename: string): jObject;
    function LoadFromRawFolder(FileName: string): jObject;
    function LoadFromResources(_imageResIdentifier: string): jObject;
    function LoadFromFile(_filenameInternalAppStorage: string): jObject; overload;
    function LoadFromFile(_pathEnvironment: string; _filename: string): jObject; overload;
    function SaveToFile(_image: jObject; _filename: string) : boolean; overload;
    function SaveToFile(_image: jObject; _path: string; _filename: string ) : boolean; overload;
    function SaveToGallery(_image: jObject; _folderName, _fileName : string ) : boolean;
    function LoadFromUri(_imageUri: jObject): jObject;   overload;

    function GetBitmapToGrayscale( _bitmap : jObject ): jObject;
    function GetBitmapInvert( _bitmap : jObject ): jObject;

    function LoadFromFile(_filename: string; _scale: integer): jObject; overload;
    function CreateBitmap(_width: integer; _height: integer): jObject;
    function GetBitmapWidth(_bitmap: jObject): integer;
    function GetBitmapHeight(_bitmap: jObject): integer;

    //_compressFormat -->> 'WEBP' or 'JPEG'  or 'PNG'
    function GetByteArrayFromBitmap(_bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;

    function SetByteArrayToBitmap(var _imageArray: TDynArrayOfJByte): jObject;
    function ClockWise(_bitmap: jObject ): jObject;
    function AntiClockWise(_bitmap: jObject ): jObject;
    function SetScale(_bmp: jObject; _scaleX: single; _scaleY: single): jObject;
    function GetBitmapFromDecodedFile(_imagePath: string): jObject;
    function GetBitmapFromIntentResult(_intentData: jObject): jObject;
    function GetBitmapThumbnailFromCamera(_intentData: jObject): jObject;
    function LoadFromUri(_uriAsString: string): jObject; overload;

    function GetOrientation( _imageUri: jObject   ): integer; overload;
    function GetOrientation( _uriAsString: string ): integer; overload;
    function GetBitmapOrientation(_bitmap: jObject; _orientation : integer ): jObject;

    function ImageOpen() : boolean;

    function LoadThumbnailFromFile(_fullFilePath: string; _maxWidth: integer; _maxHeight: integer): jObject;
    function LoadThumbnailFromAssets(_fileName: string; _maxWidth: integer; _maxHeight: integer): jObject;


 published

end;

function jImageFileManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
function jImageFileManager_LoadThumbnailFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _fullFilePath: string; _maxWidth: integer; _maxHeight: integer): jObject;
function jImageFileManager_LoadThumbnailFromAssets(env: PJNIEnv; _jimagefilemanager: JObject; _fileName: string; _maxWidth: integer; _maxHeight: integer): jObject;


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
           jni_free(gApp.jni.jEnv, FjObject);
           FjObject:= nil;
        end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jImageFileManager.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....

  FjObject := jImageFileManager_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);

  if FjObject = nil then exit;

  FInitialized:= True;
end;

function jImageFileManager.SaveToSdCard(_image: jObject; _filename: string) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_t_out_z(gApp.jni.jEnv, FjObject, 'SaveToSdCard', _image ,_filename);
end;

procedure jImageFileManager.ShowImagesFromGallery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'ShowImagesFromGallery');
end;

function jImageFileManager.ImageOpen() : boolean;
begin
  Result := false;
  //in designing component state: set value here...
  if FInitialized then
     jni_func_out_z(gApp.jni.jEnv, FjObject, 'ImageOpen');
end;

function jImageFileManager.LoadFromSdCard(_filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromSdCard', _filename);
end;

function jImageFileManager.LoadFromURL(_imageURL: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromURL', _imageURL);
end;

function jImageFileManager.GetBitmapToGrayscale( _bitmap : jObject ): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapToGrayscale', _bitmap);
end;

function jImageFileManager.GetBitmapInvert( _bitmap : jObject ): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapInvert', _bitmap);
end;

function jImageFileManager.LoadFromAssets(filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromAssets', filename);
end;

function jImageFileManager.LoadFromRawFolder(FileName: string): jObject;
begin

  if(FInitialized) then
    Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromRawFolder', FileName);
end;

function jImageFileManager.LoadFromResources(_imageResIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromResources', _imageResIdentifier);
end;


function jImageFileManager.LoadFromFile(_filenameInternalAppStorage: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromFile', _filenameInternalAppStorage);
end;

function jImageFileManager.LoadFromFile(_pathEnvironment: string; _filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jni_func_tt_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromFile', _pathEnvironment, _filename);
end;

function jImageFileManager.SaveToFile(_image: jObject; _filename: string) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_t_out_z(gApp.jni.jEnv, FjObject, 'SaveToFile', _image ,_filename);
end;

function jImageFileManager.SaveToFile(_image: jObject; _path:string;  _filename: string) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_tt_out_z(gApp.jni.jEnv, FjObject, 'SaveToFile', _image ,_path, _filename);
end;

function jImageFileManager.SaveToGallery(_image: jObject; _folderName, _fileName : string ) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_tt_out_z(gApp.jni.jEnv, FjObject, 'SaveToGallery', _image ,_folderName, _filename);
end;

function jImageFileManager.LoadFromUri(_imageUri: jObject): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_uri_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromUri', _imageUri);
end;

function jImageFileManager.GetOrientation( _imageUri: jObject ) : integer;
begin
 Result := 0;
 //in designing component state: result value here...
 if FInitialized then
   Result:= jni_func_uri_out_i(gApp.jni.jEnv, FjObject, 'GetOrientation', _imageUri);
end;

function jImageFileManager.GetOrientation(_uriAsString: string): integer;
begin
  Result := 0;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'GetOrientation', _uriAsString);
end;

function jImageFileManager.LoadFromFile(_filename: string; _scale: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ti_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromFile', _filename ,_scale);
end;

function jImageFileManager.CreateBitmap(_width: integer; _height: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ii_out_bmp(gApp.jni.jEnv, FjObject, 'CreateBitmap', _width ,_height);
end;

function jImageFileManager.GetBitmapWidth(_bitmap: jObject): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_i(gApp.jni.jEnv, FjObject, 'GetBitmapWidth', _bitmap);
end;

function jImageFileManager.GetBitmapHeight(_bitmap: jObject): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_i(gApp.jni.jEnv, FjObject, 'GetBitmapHeight', _bitmap);
end;

function jImageFileManager.GetByteArrayFromBitmap(_bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
     Result:= jni_func_bmp_t_out_dab(gApp.jni.jEnv, FjObject, 'GetByteArrayFromBitmap', _bitmap ,_compressFormat);
end;

function jImageFileManager.SetByteArrayToBitmap(var _imageArray: TDynArrayOfJByte): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dab_out_bmp(gApp.jni.jEnv, FjObject, 'SetByteArrayToBitmap', _imageArray);
end;

function jImageFileManager.GetBitmapOrientation(_bitmap: jObject; _orientation : integer ): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_i_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapOrientation', _bitmap, _orientation);
end;

function jImageFileManager.ClockWise(_bitmap: jObject ): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(gApp.jni.jEnv, FjObject, 'ClockWise', _bitmap);
end;

function jImageFileManager.AntiClockWise(_bitmap: jObject ): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(gApp.jni.jEnv, FjObject, 'AntiClockWise', _bitmap );
end;

function jImageFileManager.SetScale(_bmp: jObject; _scaleX: single; _scaleY: single): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_ff_out_bmp(gApp.jni.jEnv, FjObject, 'SetScale', _bmp,_scaleX ,_scaleY);
end;

function jImageFileManager.GetBitmapFromDecodedFile(_imagePath: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapFromDecodedFile', _imagePath);
end;

function jImageFileManager.GetBitmapFromIntentResult(_intentData: jObject): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_int_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapFromIntentResult', _intentData);
end;


function jImageFileManager.GetBitmapThumbnailFromCamera(_intentData: jObject): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_int_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapThumbnailFromCamera', _intentData);
end;

function jImageFileManager.LoadFromUri(_uriAsString: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromUri', _uriAsString);
end;

function jImageFileManager.LoadThumbnailFromFile(_fullFilePath: string; _maxWidth: integer; _maxHeight: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadThumbnailFromFile(gApp.jni.jEnv, FjObject, _fullFilePath ,_maxWidth ,_maxHeight);
end;

function jImageFileManager.LoadThumbnailFromAssets(_fileName: string; _maxWidth: integer; _maxHeight: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadThumbnailFromAssets(gApp.jni.jEnv, FjObject, _fileName ,_maxWidth ,_maxHeight);
end;

{-------- jImageFileManager_JNI_Bridge ----------}

function jImageFileManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jImageFileManager_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


function jImageFileManager_LoadThumbnailFromFile(env: PJNIEnv; _jimagefilemanager: JObject; _fullFilePath: string; _maxWidth: integer; _maxHeight: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagefilemanager = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'LoadThumbnailFromFile', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullFilePath));
  jParams[1].i:= _maxWidth;
  jParams[2].i:= _maxHeight;


  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jImageFileManager_LoadThumbnailFromAssets(env: PJNIEnv; _jimagefilemanager: JObject; _fileName: string; _maxWidth: integer; _maxHeight: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagefilemanager = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'LoadThumbnailFromAssets', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jParams[1].i:= _maxWidth;
  jParams[2].i:= _maxHeight;


  Result:= env^.CallObjectMethodA(env, _jimagefilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
