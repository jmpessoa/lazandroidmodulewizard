unit opendialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnFileSelected = procedure(Sender: TObject; path: string; fileName: string) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [1/27/2017 22:26:55]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jOpenDialog = class(jControl)
 private
   FOnFileSelected: TOnFileSelected;
   FFileExtension: string;
   FInitialDirectory: TEnvDirectory;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure Show(_fileExtension: string); overload;
    procedure Show(); overload;
    procedure Show(_initialEnvDirectory: TEnvDirectory; _fileExtension: string); overload;

    procedure SetInitialEnvDirectory(_initialEnvDirectory: TEnvDirectory);
    procedure SetFileExtension(_fileExtension: string);

    procedure GenEvent_OnFileSelected(Obj: TObject; path: string; fileName: string);

 published
    property OnFileSelected: TOnFileSelected read FOnFileSelected write FOnFileSelected;
    property FileExtension: string read FFileExtension write SetFileExtension;
    property InitialDirectory: TEnvDirectory read FInitialDirectory write SetInitialEnvDirectory;
end;

function jOpenDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jOpenDialog_jFree(env: PJNIEnv; _jopendialog: JObject);
procedure jOpenDialog_Show(env: PJNIEnv; _jopendialog: JObject; _fileExtension: string); overload;
procedure jOpenDialog_Show(env: PJNIEnv; _jopendialog: JObject); overload;
procedure jOpenDialog_Show(env: PJNIEnv; _jopenfile: JObject; _initialEnvDirectory: integer; _fileExtension: string); overload;

procedure jOpenDialog_SetInitialDirectory(env: PJNIEnv; _jopenfile: JObject; _initialEnvDirectory: integer);
procedure jOpenDialog_SetFileExtension(env: PJNIEnv; _jopenfile: JObject; _fileExtension: string);

implementation


{---------  jOpenDialog  --------------}

constructor jOpenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FFileExtension:= '*';
  FInitialDirectory:= dirDownloads;
end;

destructor jOpenDialog.Destroy;
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

procedure jOpenDialog.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !

  FInitialized:= True;

  if FFileExtension <> '' then
     SetFileExtension(FFileExtension);

  jOpenDialog_SetInitialDirectory(FjEnv, FjObject, Ord(FInitialDirectory));

end;

function jOpenDialog.jCreate(): jObject;
begin
  Result:= jOpenDialog_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jOpenDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jOpenDialog_jFree(FjEnv, FjObject);
end;

procedure jOpenDialog.Show(_fileExtension: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jOpenDialog_Show(FjEnv, FjObject, _fileExtension);
end;

procedure jOpenDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jOpenDialog_Show(FjEnv, FjObject);
end;

procedure jOpenDialog.Show(_initialEnvDirectory: TEnvDirectory; _fileExtension: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jOpenDialog_Show(FjEnv, FjObject, Ord(_initialEnvDirectory) ,_fileExtension);
end;

procedure jOpenDialog.SetInitialEnvDirectory(_initialEnvDirectory: TEnvDirectory);
begin
  //in designing component state: set value here...
  FInitialDirectory:= _initialEnvDirectory;
  if FInitialized then
     jOpenDialog_SetInitialDirectory(FjEnv, FjObject, Ord(_initialEnvDirectory));
end;

procedure jOpenDialog.SetFileExtension(_fileExtension: string);
var
  p: integer;
  aux: string;
begin
  //in designing component state: set value here...
  FFileExtension:= _fileExtension;
  if FInitialized then
  begin
     aux:= FFileExtension;
     p:= Pos('.', FFileExtension);
     if  p > 0 then
     begin
       aux:= Copy(aux, p+1, Length(aux));
     end;
     if Pos('*', aux) > 0 then  aux:= '';
     jOpenDialog_SetFileExtension(FjEnv, FjObject, aux);
  end;
end;

procedure jOpenDialog.GenEvent_OnFileSelected(Obj: TObject; path: string; fileName: string);
begin
  if Assigned(FOnfileSelected) then FOnfileSelected(Obj, path, fileName);
end;

{-------- jOpenDialog_JNI_Bridge ----------}

function jOpenDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jOpenDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jOpenDialog_jCreate(long _Self) {
  return (java.lang.Object)(new jOpenDialog(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jOpenDialog_jFree(env: PJNIEnv; _jopendialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jopendialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jopendialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOpenDialog_Show(env: PJNIEnv; _jopendialog: JObject; _fileExtension: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileExtension));
  jCls:= env^.GetObjectClass(env, _jopendialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jopendialog, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOpenDialog_Show(env: PJNIEnv; _jopendialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jopendialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jopendialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOpenDialog_Show(env: PJNIEnv; _jopenfile: JObject; _initialEnvDirectory: integer; _fileExtension: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _initialEnvDirectory;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileExtension));
  jCls:= env^.GetObjectClass(env, _jopenfile);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jopenfile, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jOpenDialog_SetInitialDirectory(env: PJNIEnv; _jopenfile: JObject; _initialEnvDirectory: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _initialEnvDirectory;
  jCls:= env^.GetObjectClass(env, _jopenfile);
  jMethod:= env^.GetMethodID(env, jCls, 'SetInitialDirectory', '(I)V');
  env^.CallVoidMethodA(env, _jopenfile, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jOpenDialog_SetFileExtension(env: PJNIEnv; _jopenfile: JObject; _fileExtension: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileExtension));
  jCls:= env^.GetObjectClass(env, _jopenfile);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFileExtension', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jopenfile, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
