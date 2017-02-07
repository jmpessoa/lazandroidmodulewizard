unit contextmenu;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type


{Draft Component code by "Lazarus Android Module Wizard" [11/22/2014 1:16:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jContextMenu = class(jControl)
 private
    FOptions: TStrings;
    FHeaderTitle: string;
    FHeaderIcon: string;
    procedure SetOptions(Value: TStrings);
 protected

 public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function CheckItemCommute(_item: jObject): integer;
    function CheckItem(_item: jObject): integer;
    function UnCheckItem(_item: jObject): integer;
    function Size(): integer;
    function FindMenuItemByID(_itemID: integer): jObject;
    function GetMenuItemByIndex(_index: integer): jObject;
    procedure UnCheckAllMenuItem();
    procedure RegisterForContextMenu(_view: jObject);
    procedure UnRegisterForContextMenu(_View: JObject); 
    function AddItem(_menu: jObject; _itemID: integer; _caption: string; _itemType: TMenuItemType): jObject;
    procedure SetHeader(_menu: jObject; _title: string; _headerIconIdentifier: string);

    procedure SetHeaderTitle(_title: string);
    procedure SetHeaderIcon(_headerIconIdentifier: string);

    function IsItemChecked(_itemID: integer): boolean;

 published
    property Options: TStrings read FOptions write SetOptions;
    property HeaderTitle: string read FHeaderTitle write SetHeaderTitle;
    property HeaderIconIdentifier: string read FHeaderIcon write SetHeaderIcon;

end;

function jContextMenu_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jContextMenu_jFree(env: PJNIEnv; _jcontextmenu: JObject);
function jContextMenu_CheckItemCommute(env: PJNIEnv; _jcontextmenu: JObject; _item: jObject): integer;
function jContextMenu_CheckItem(env: PJNIEnv; _jcontextmenu: JObject; _item: jObject): integer;
function jContextMenu_UnCheckItem(env: PJNIEnv; _jcontextmenu: JObject; _item: jObject): integer;
function jContextMenu_Size(env: PJNIEnv; _jcontextmenu: JObject): integer;
function jContextMenu_FindMenuItemByID(env: PJNIEnv; _jcontextmenu: JObject; _itemID: integer): jObject;
function jContextMenu_GetMenuItemByIndex(env: PJNIEnv; _jcontextmenu: JObject; _index: integer): jObject;
procedure jContextMenu_UnCheckAllMenuItem(env: PJNIEnv; _jcontextmenu: JObject);
procedure jContextMenu_RegisterForContextMenu(env: PJNIEnv; _jcontextmenu: JObject; _view: jObject);
procedure JContextMenu_UnRegisterForContextMenu(env: PJNIEnv; _JContextMenu: JObject; _View: JObject); 
function jContextMenu_AddItem(env: PJNIEnv; _jcontextmenu: JObject; _menu: jObject; _itemID: integer; _caption: string; _itemType: integer): jObject;
procedure jContextMenu_SetHeader(env: PJNIEnv; _jcontextmenu: JObject; _menu: jObject; _title: string; _headerIconIdentifier: string);


procedure jContextMenu_SetHeaderTitle(env: PJNIEnv; _jcontextmenu: JObject; _title: string);
procedure jContextMenu_SetHeaderIconByIdentifier(env: PJNIEnv; _jcontextmenu: JObject;  _headerIconIdentifier: string);

function jContextMenu_IsItemChecked(env: PJNIEnv; _jcontextmenu: JObject; _itemID: integer): boolean;


implementation

{---------  jContextMenu  --------------}

constructor jContextMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FOptions:= TStringList.Create;

end;

destructor jContextMenu.Destroy;
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
  FOptions.Free;
  inherited Destroy;
end;

procedure jContextMenu.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jContextMenu.jCreate(): jObject;
begin
   Result:= jContextMenu_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jContextMenu.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jContextMenu_jFree(FjEnv, FjObject);
end;

function jContextMenu.CheckItemCommute(_item: jObject): integer;
begin
  //in designing component state: set value here...

  if FInitialized then
     Result:= jContextMenu_CheckItemCommute(FjEnv, FjObject, _item);
end;

function jContextMenu.CheckItem(_item: jObject): integer;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     Result:= jContextMenu_CheckItem(FjEnv, FjObject, _item);
  end;
end;

function jContextMenu.UnCheckItem(_item: jObject): integer;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     Result:= jContextMenu_UnCheckItem(FjEnv, FjObject, _item);
  end;
end;

function jContextMenu.Size(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContextMenu_Size(FjEnv, FjObject);
end;

function jContextMenu.FindMenuItemByID(_itemID: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContextMenu_FindMenuItemByID(FjEnv, FjObject, _itemID);
end;

function jContextMenu.GetMenuItemByIndex(_index: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jContextMenu_GetMenuItemByIndex(FjEnv, FjObject, _index);
end;

procedure jContextMenu.UnCheckAllMenuItem();
begin
  //in designing component state: set value here...
  if FInitialized then
     jContextMenu_UnCheckAllMenuItem(FjEnv, FjObject);
end;

procedure jContextMenu.RegisterForContextMenu(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContextMenu_RegisterForContextMenu(FjEnv, FjObject, _view);
end;

procedure jContextMenu.UnRegisterForContextMenu(_View: JObject); 
begin 
if(FInitialized) then 
  JContextMenu_UnRegisterForContextMenu(FjEnv, FjObject, _View); 
end; 

function jContextMenu.AddItem(_menu: jObject; _itemID: integer; _caption: string; _itemType: TMenuItemType): jObject;
begin
  //in designing component state: set value here...
  if FInitialized then
     Result:= jContextMenu_AddItem(FjEnv, FjObject, _menu ,_itemID ,_caption ,Ord(_itemType));
end;

procedure jContextMenu.SetOptions(Value: TStrings);
begin
  FOptions.Assign(Value);
end;

procedure jContextMenu.SetHeader(_menu: jObject; _title: string; _headerIconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContextMenu_SetHeader(FjEnv, FjObject, _menu ,_title ,_headerIconIdentifier);
end;

procedure jContextMenu.SetHeaderTitle( _title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContextMenu_SetHeaderTitle(FjEnv, FjObject ,_title);
end;

procedure jContextMenu.SetHeaderIcon(_headerIconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jContextMenu_SetHeaderIconByIdentifier(FjEnv, FjObject, _headerIconIdentifier);
end;

function jContextMenu.IsItemChecked( _itemID: integer): boolean;
begin
  //in designing component state: set value here...
  Result:= False;
  if FInitialized then
     Result:= jContextMenu_IsItemChecked(FjEnv, FjObject, _itemID);
end;

{-------- jContextMenu_JNI_Bridge ----------}

function jContextMenu_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jContextMenu_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jContextMenu_jCreate(long _Self) {
      return (java.lang.Object)(new jContextMenu(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jContextMenu_jFree(env: PJNIEnv; _jcontextmenu: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcontextmenu, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jContextMenu_CheckItemCommute(env: PJNIEnv; _jcontextmenu: JObject; _item: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _item;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckItemCommute', '(Landroid/view/MenuItem;)I');
  Result:= env^.CallIntMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jContextMenu_CheckItem(env: PJNIEnv; _jcontextmenu: JObject; _item: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _item;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckItem', '(Landroid/view/MenuItem;)I');
  Result:= env^.CallIntMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jContextMenu_UnCheckItem(env: PJNIEnv; _jcontextmenu: JObject; _item: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _item;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'UnCheckItem', '(Landroid/view/MenuItem;)I');
  Result:= env^.CallIntMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jContextMenu_Size(env: PJNIEnv; _jcontextmenu: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'Size', '()I');
  Result:= env^.CallIntMethod(env, _jcontextmenu, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jContextMenu_FindMenuItemByID(env: PJNIEnv; _jcontextmenu: JObject; _itemID: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _itemID;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'FindMenuItemByID', '(I)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jContextMenu_GetMenuItemByIndex(env: PJNIEnv; _jcontextmenu: JObject; _index: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMenuItemByIndex', '(I)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContextMenu_UnCheckAllMenuItem(env: PJNIEnv; _jcontextmenu: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'UnCheckAllMenuItem', '()V');
  env^.CallVoidMethod(env, _jcontextmenu, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContextMenu_RegisterForContextMenu(env: PJNIEnv; _jcontextmenu: JObject; _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _view;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterForContextMenu', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure JContextMenu_UnRegisterForContextMenu(env: PJNIEnv; _JContextMenu: JObject; _View: JObject); 
var 
  JParams: array[0..0] of JValue; 
  JMethod: JMethodID = nil; 
  JCls: JClass = nil; 
begin 
  JParams[0].l := _View; 
  JCls := env^.GetObjectClass(env, _JContextMenu); 
  JMethod := env^.GetMethodID(env, JCls, 'UnRegisterForContextMenu', '(Landroid/view/View;)V'); 
  env^.CallVoidMethodA(env, _JContextMenu, JMethod, @JParams);
  env^.DeleteLocalRef(env, jCls);
end; 

function jContextMenu_AddItem(env: PJNIEnv; _jcontextmenu: JObject; _menu: jObject; _itemID: integer; _caption: string; _itemType: integer): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemID;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_caption));
  jParams[3].i:= _itemType;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/ContextMenu;ILjava/lang/String;I)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jContextMenu_SetHeader(env: PJNIEnv; _jcontextmenu: JObject; _menu: jObject; _title: string; _headerIconIdentifier: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu; //JChar(_menu);
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_headerIconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHeader', '(Landroid/view/ContextMenu;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jContextMenu_SetHeaderTitle(env: PJNIEnv; _jcontextmenu: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHeaderTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jContextMenu_SetHeaderIconByIdentifier(env: PJNIEnv; _jcontextmenu: JObject; _headerIconIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_headerIconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHeaderIconByIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcontextmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jContextMenu_IsItemChecked(env: PJNIEnv; _jcontextmenu: JObject; _itemID: integer): boolean;
var
  jParams: array[0..0] of jValue;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _itemID;
  jCls:= env^.GetObjectClass(env, _jcontextmenu);
  jMethod:= env^.GetMethodID(env, jCls, 'IsItemChecked', '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jcontextmenu, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

end.
