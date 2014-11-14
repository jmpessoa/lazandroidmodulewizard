unit imagefilemanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

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
    function LoadFromAssets(strName: string): jObject;
    function LoadFromFile(_filename: string): jObject; overload;
    function LoadFromFile(_path: string; _filename: string): jObject; overload;
    procedure SaveToFile(_image: jObject; _filename: string); overload;
    procedure SaveToFile(_image: jObject;_path: string; _filename: string); overload;

 published

end;

function jImageFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jImageFileManager_jFree(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject);
procedure jImageFileManager_SaveToSdCard(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _image: jObject; _filename: string);
procedure jImageFileManager_ShowImagesFromGallery(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject);
function jImageFileManager_LoadFromSdCard(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _filename: string): jObject;
function jImageFileManager_LoadFromURL(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _imageURL: string): jObject;
function jImageFileManager_LoadFromAssets(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; strName: string): jObject;
function jImageFileManager_LoadFromFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _filename: string): jObject; overload;
function jImageFileManager_LoadFromFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _path: string; _filename: string): jObject; overload;
procedure jImageFileManager_SaveToFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _image: jObject; _filename: string); overload;
procedure jImageFileManager_SaveToFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _image: jObject;_path:string; _filename: string); overload;


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
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
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
   Result:= jImageFileManager_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jImageFileManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jImageFileManager.SaveToSdCard(_image: jObject; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_SaveToSdCard(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _image ,_filename);
end;

procedure jImageFileManager.ShowImagesFromGallery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_ShowImagesFromGallery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jImageFileManager.LoadFromSdCard(_filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromSdCard(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _filename);
end;

function jImageFileManager.LoadFromURL(_imageURL: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromURL(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _imageURL);
end;

function jImageFileManager.LoadFromAssets(strName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromAssets(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, strName);
end;

function jImageFileManager.LoadFromFile(_filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageFileManager_LoadFromFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _filename);
end;

function jImageFileManager.LoadFromFile(_path: string; _filename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jImageFileManager_LoadFromFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,_path, _filename);
end;

procedure jImageFileManager.SaveToFile(_image: jObject; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_SaveToFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _image ,_filename);
end;

procedure jImageFileManager.SaveToFile(_image: jObject; _path:string;  _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageFileManager_SaveToFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _image ,_path, _filename);
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


procedure jImageFileManager_jFree(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jimagefilemanager, jMethod);
end;


procedure jImageFileManager_SaveToSdCard(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _image: jObject; _filename: string);
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
end;


procedure jImageFileManager_ShowImagesFromGallery(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jimagefilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowImagesFromGallery', '()V');
  env^.CallVoidMethod(env, _jimagefilemanager, jMethod);
end;


function jImageFileManager_LoadFromSdCard(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _filename: string): jObject;
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
end;


function jImageFileManager_LoadFromURL(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _imageURL: string): jObject;
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
end;


function jImageFileManager_LoadFromAssets(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; strName: string): jObject;
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
end;


function jImageFileManager_LoadFromFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _filename: string): jObject;
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
end;

function jImageFileManager_LoadFromFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject;_path: string; _filename: string): jObject;
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
end;

procedure jImageFileManager_SaveToFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _image: jObject; _filename: string);
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
end;


procedure jImageFileManager_SaveToFile(env: PJNIEnv; this: JObject; _jimagefilemanager: JObject; _image: jObject; _path: string; _filename: string);
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
end;



end.
