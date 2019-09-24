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
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
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
    function SaveToFile(_image: jObject;_path: string; _filename: string) : boolean; overload;
    function LoadFromUri(_imageUri: jObject): jObject;   overload;

    function GetBitmapToGrayscale( _bitmap : jObject ): jObject;

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

 published

end;

function jImageFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;

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
     jni_proc(FjEnv, FjObject, 'jFree');
end;

function jImageFileManager.SaveToSdCard(_image: jObject; _filename: string) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_t_out_z(FjEnv, FjObject, 'SaveToSdCard', _image ,_filename);
end;

procedure jImageFileManager.ShowImagesFromGallery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'ShowImagesFromGallery');
end;

function jImageFileManager.LoadFromSdCard(_filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromSdCard', _filename);
end;

function jImageFileManager.LoadFromURL(_imageURL: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromURL', _imageURL);
end;

function jImageFileManager.GetBitmapToGrayscale( _bitmap : jObject ): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(FjEnv, FjObject, 'GetBitmapToGrayscale', _bitmap);
end;

function jImageFileManager.LoadFromAssets(filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromAssets', filename);
end;

function jImageFileManager.LoadFromRawFolder(FileName: string): jObject;
begin

  if(FInitialized) then
    Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromRawFolder', FileName);
end;

function jImageFileManager.LoadFromResources(_imageResIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromResources', _imageResIdentifier);
end;


function jImageFileManager.LoadFromFile(_filenameInternalAppStorage: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromFile', _filenameInternalAppStorage);
end;

function jImageFileManager.LoadFromFile(_pathEnvironment: string; _filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jni_func_tt_out_bmp(FjEnv, FjObject, 'LoadFromFile', _pathEnvironment, _filename);
end;

function jImageFileManager.SaveToFile(_image: jObject; _filename: string) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_t_out_z(FjEnv, FjObject, 'SaveToFile', _image ,_filename);
end;

function jImageFileManager.SaveToFile(_image: jObject; _path:string;  _filename: string) : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_bmp_tt_out_z(FjEnv, FjObject, 'SaveToFile', _image ,_path, _filename);
end;

function jImageFileManager.LoadFromUri(_imageUri: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_uri_out_bmp(FjEnv, FjObject, 'LoadFromUri', _imageUri);
end;

function jImageFileManager.LoadFromFile(_filename: string; _scale: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ti_out_bmp(FjEnv, FjObject, 'LoadFromFile', _filename ,_scale);
end;

function jImageFileManager.CreateBitmap(_width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ii_out_bmp(FjEnv, FjObject, 'CreateBitmap', _width ,_height);
end;

function jImageFileManager.GetBitmapWidth(_bitmap: jObject): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_i(FjEnv, FjObject, 'GetBitmapWidth', _bitmap);
end;

function jImageFileManager.GetBitmapHeight(_bitmap: jObject): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_i(FjEnv, FjObject, 'GetBitmapHeight', _bitmap);
end;

function jImageFileManager.GetByteArrayFromBitmap(_bitmap: jObject; _compressFormat: string): TDynArrayOfJByte;
begin
  //in designing component state: result value here...
  if FInitialized then
     Result:= jni_func_bmp_t_out_dab(FjEnv, FjObject, 'GetByteArrayFromBitmap', _bitmap ,_compressFormat);
end;

function jImageFileManager.SetByteArrayToBitmap(var _imageArray: TDynArrayOfJByte): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dab_out_bmp(FjEnv, FjObject, 'SetByteArrayToBitmap', _imageArray);
end;

function jImageFileManager.ClockWise(_bitmap: jObject ): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(FjEnv, FjObject, 'ClockWise', _bitmap);
end;

function jImageFileManager.AntiClockWise(_bitmap: jObject ): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_out_bmp(FjEnv, FjObject, 'AntiClockWise', _bitmap );
end;

function jImageFileManager.SetScale(_bmp: jObject; _scaleX: single; _scaleY: single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_bmp_ff_out_bmp(FjEnv, FjObject, 'SetScale', _bmp,_scaleX ,_scaleY);
end;

function jImageFileManager.GetBitmapFromDecodedFile(_imagePath: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'GetBitmapFromDecodedFile', _imagePath);
end;

function jImageFileManager.GetBitmapFromIntentResult(_intentData: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_n_out_bmp(FjEnv, FjObject, 'GetBitmapFromIntentResult', _intentData);
end;


function jImageFileManager.GetBitmapThumbnailFromCamera(_intentData: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_n_out_bmp(FjEnv, FjObject, 'GetBitmapThumbnailFromCamera', _intentData);
end;

function jImageFileManager.LoadFromUri(_uriAsString: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(FjEnv, FjObject, 'LoadFromUri', _uriAsString);
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


end.
