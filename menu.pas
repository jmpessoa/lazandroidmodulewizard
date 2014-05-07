unit menu;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/5/2014 1:07:26]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMenu = class(jControl)
 private
    FOptions: TStrings;
    procedure SetOptions(Value: TStrings);
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Add(_menu: jObject; _itemID: integer; _caption: string);
    procedure AddCheckable(_menu: jObject; _itemID: integer; _caption: string);
    procedure AddDrawable(_menu: jObject; _itemID: integer; _caption: string);
    procedure CheckItemCommute(_item: jObject);
    procedure CheckItem(_item: jObject);
    procedure UnCheckItem(_item: jObject);
    procedure AddSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
    procedure AddCheckableSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
    function Size(): integer;
    function FindMenuItemByID(_itemID: integer): jObject;
    function GetMenuItemByIndex(_index: integer): jObject;
    procedure UnCheckAllMenuItem();
    function CountSubMenus(): integer;
    procedure UnCheckAllSubMenuItemByIndex(_subMenuIndex: integer);
    procedure RegisterForContextMenu(_view: jObject);

 published
    property Options: TStrings read FOptions write SetOptions;
end;

function jMenu_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jMenu_jFree(env: PJNIEnv; this: JObject; _jmenu: JObject);
procedure jMenu_Add(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string);
procedure jMenu_AddCheckable(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string);
procedure jMenu_AddDrawable(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string);
procedure jMenu_CheckItemCommute(env: PJNIEnv; this: JObject; _jmenu: JObject; _item: jObject);
procedure jMenu_CheckItem(env: PJNIEnv; this: JObject; _jmenu: JObject; _item: jObject);
procedure jMenu_UnCheckItem(env: PJNIEnv; this: JObject; _jmenu: JObject; _item: jObject);
procedure jMenu_AddSubMenu(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
procedure jMenu_AddCheckableSubMenu(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
function jMenu_Size(env: PJNIEnv; this: JObject; _jmenu: JObject): integer;
function jMenu_FindMenuItemByID(env: PJNIEnv; this: JObject; _jmenu: JObject; _itemID: integer): jObject;
function jMenu_GetMenuItemByIndex(env: PJNIEnv; this: JObject; _jmenu: JObject; _index: integer): jObject;
procedure jMenu_UnCheckAllMenuItem(env: PJNIEnv; this: JObject; _jmenu: JObject);
function jMenu_CountSubMenus(env: PJNIEnv; this: JObject; _jmenu: JObject): integer;
procedure jMenu_UnCheckAllSubMenuItemByIndex(env: PJNIEnv; this: JObject; _jmenu: JObject; _subMenuIndex: integer);
procedure jMenu_RegisterForContextMenu(env: PJNIEnv; this: JObject; _jmenu: JObject; _view: jObject);

implementation

{---------  jMenu  --------------}

constructor jMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FOptions:= TStringList.Create;
end;

destructor jMenu.Destroy;
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
  //you others free code here...
  FOptions.Free;
  inherited Destroy;
end;

procedure jMenu.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jMenu.jCreate(): jObject;
begin
   Result:= jMenu_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jMenu.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jMenu.Add(_menu: jObject; _itemID: integer; _caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_Add(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _menu ,_itemID ,_caption);
end;

procedure jMenu.AddCheckable(_menu: jObject; _itemID: integer; _caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddCheckable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _menu ,_itemID ,_caption);
end;

procedure jMenu.AddDrawable(_menu: jObject; _itemID: integer; _caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddDrawable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _menu ,_itemID ,_caption);
end;

procedure jMenu.SetOptions(Value: TStrings);
begin
  FOptions.Assign(Value);
end;

procedure jMenu.CheckItemCommute(_item: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_CheckItemCommute(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _item);
end;

procedure jMenu.CheckItem(_item: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_CheckItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _item);
end;

procedure jMenu.UnCheckItem(_item: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_UnCheckItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _item);
end;

procedure jMenu.AddSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddSubMenu(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _menu ,_startItemID ,_captions);
end;

procedure jMenu.AddCheckableSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddCheckableSubMenu(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _menu ,_startItemID ,_captions);
end;

function jMenu.Size(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMenu_Size(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jMenu.FindMenuItemByID(_itemID: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMenu_FindMenuItemByID(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _itemID);
end;

function jMenu.GetMenuItemByIndex(_index: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMenu_GetMenuItemByIndex(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _index);
end;

procedure jMenu.UnCheckAllMenuItem();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_UnCheckAllMenuItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jMenu.CountSubMenus(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMenu_CountSubMenus(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jMenu.UnCheckAllSubMenuItemByIndex(_subMenuIndex: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_UnCheckAllSubMenuItemByIndex(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _subMenuIndex);
end;

procedure jMenu.RegisterForContextMenu(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_RegisterForContextMenu(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _view);
end;

{-------- jMenu_JNI_Bridge ----------}

function jMenu_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMenu_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jMenu_jCreate(long _Self) {
      return (java.lang.Object)(new jMenu(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jMenu_jFree(env: PJNIEnv; this: JObject; _jmenu: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmenu, jMethod);
end;

procedure jMenu_Add(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemID;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(Landroid/view/Menu;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

procedure jMenu_AddCheckable(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemID;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'AddCheckable', '(Landroid/view/Menu;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

procedure jMenu_AddDrawable(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemID;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'AddDrawable', '(Landroid/view/Menu;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

procedure jMenu_CheckItemCommute(env: PJNIEnv; this: JObject; _jmenu: JObject; _item: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _item;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckItemCommute', '(Landroid/view/MenuItem;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
end;


procedure jMenu_CheckItem(env: PJNIEnv; this: JObject; _jmenu: JObject; _item: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _item;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckItem', '(Landroid/view/MenuItem;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
end;


procedure jMenu_UnCheckItem(env: PJNIEnv; this: JObject; _jmenu: JObject; _item: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _item;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'UnCheckItem', '(Landroid/view/MenuItem;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
end;

procedure jMenu_AddSubMenu(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _startItemID;
  newSize0:= Length(_captions); //?; Length(?);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_captions[i])));
  end;
  jParams[2].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'AddSubMenu', '(Landroid/view/Menu;I[Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

procedure jMenu_AddCheckableSubMenu(env: PJNIEnv; this: JObject; _jmenu: JObject; _menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _startItemID;
  newSize0:= Length(_captions); //?; //Length(?);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_captions[i])));
  end;
  jParams[2].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'AddCheckableSubMenu', '(Landroid/view/Menu;I[Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

function jMenu_Size(env: PJNIEnv; this: JObject; _jmenu: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'Size', '()I');
  Result:= env^.CallIntMethod(env, _jmenu, jMethod);
end;

function jMenu_FindMenuItemByID(env: PJNIEnv; this: JObject; _jmenu: JObject; _itemID: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _itemID;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'FindMenuItemByID', '(I)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jmenu, jMethod, @jParams);
end;

function jMenu_GetMenuItemByIndex(env: PJNIEnv; this: JObject; _jmenu: JObject; _index: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMenuItemByIndex', '(I)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jmenu, jMethod, @jParams);
end;

procedure jMenu_UnCheckAllMenuItem(env: PJNIEnv; this: JObject; _jmenu: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'UnCheckAllMenuItem', '()V');
  env^.CallVoidMethod(env, _jmenu, jMethod);
end;

function jMenu_CountSubMenus(env: PJNIEnv; this: JObject; _jmenu: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'CountSubMenus', '()I');
  Result:= env^.CallIntMethod(env, _jmenu, jMethod);
end;

procedure jMenu_UnCheckAllSubMenuItemByIndex(env: PJNIEnv; this: JObject; _jmenu: JObject; _subMenuIndex: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _subMenuIndex;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'UnCheckAllSubMenuItemByIndex', '(I)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
end;

procedure jMenu_RegisterForContextMenu(env: PJNIEnv; this: JObject; _jmenu: JObject; _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _view;
  jCls:= env^.GetObjectClass(env, _jmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterForContextMenu', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
end;

end.
