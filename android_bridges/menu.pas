unit menu;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/5/2014 1:07:26]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMenu = class(jControl)
 private
    FOptions: TStrings;
    FIcons: TStrings;
    procedure SetOptions(Value: TStrings);
    procedure SetIcons(Value: TStrings);
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
    procedure AddSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString); overload;
    procedure AddCheckableSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
    function Size(): integer;
    function FindMenuItemByID(_itemID: integer): jObject;
    function GetMenuItemByIndex(_index: integer): jObject;
    procedure UnCheckAllMenuItem();
    function CountSubMenus(): integer;
    procedure UnCheckAllSubMenuItemByIndex(_subMenuIndex: integer);
    procedure RegisterForContextMenu(_view: jObject);
    procedure UnRegisterForContextMenu(_View: JObject); 

    procedure AddItem(_menu: jObject; _itemID: integer; _caption: string; _iconIdentifier: string; _itemType: TMenuItemType; _showAsAction: TMenuItemShowAsAction); overload;
    procedure AddItem(_subMenu: jObject; _itemID: integer; _caption: string; _itemType: TMenuItemType); overload;
    function AddSubMenu(_menu: jObject; _title: string; _headerIconIdentifier: string): jObject; overload;
    procedure InvalidateOptionsMenu(); //force call to OnPrepareOptionsMenu and PrepareOptionsMenuItem events

    procedure SetItemVisible(_item: jObject; _value: boolean); overload;
    procedure SetItemVisible(_menu: jObject; _index: integer; _value: boolean); overload;
    procedure Clear(_menu: jObject); overload;
    procedure Clear();  overload;
    procedure SetItemTitle(_item: jObject; _title: string);  overload;
    procedure SetItemTitle(_menu: jObject; _index: integer; _title: string);  overload;
    procedure SetItemIcon(_item: jObject; _iconIdentifier: integer);     overload;
    procedure SetItemIcon(_menu: jObject; _index: integer; _iconIdentifier: integer);  overload;
    procedure SetItemChecked(_item: jObject; _value: boolean);
    procedure SetItemCheckable(_item: jObject; _value: boolean);
    function GetItemIdByIndex(_menu: jObject; _index: integer): integer;
    function GetItemIndexById(_menu: jObject; _id: integer): integer;
    procedure RemoveItemById(_menu: jObject; _id: integer);
    procedure RemoveItemByIndex(_menu: jObject; _index: integer);
    procedure AddDropDownItem(_menu: jObject; _view: jObject);

 published
    property Options: TStrings read FOptions write SetOptions;
    property IconIdentifiers: TStrings read FIcons write SetIcons;
end;

function jMenu_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jMenu_AddItem(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string; _iconIdentifier: string; _itemType: integer; _showAsAction: integer); overload;
procedure jMenu_AddItem(env: PJNIEnv; _jmenu: JObject; _subMenu: jObject; _itemID: integer; _caption: string; _itemType: integer); overload;
function jMenu_AddSubMenu(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _title: string; _headerIconIdentifier: string): jObject; overload;

procedure jMenu_SetItemVisible(env: PJNIEnv; _jmenu: JObject; _item: jObject; _value: boolean); overload;
procedure jMenu_SetItemVisible(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _index: integer; _value: boolean); overload;
procedure jMenu_Clear(env: PJNIEnv; _jmenu: JObject; _menu: jObject);  overload;
procedure jMenu_SetItemTitle(env: PJNIEnv; _jmenu: JObject; _item: jObject; _title: string);  overload;
procedure jMenu_SetItemIcon(env: PJNIEnv; _jmenu: JObject; _item: jObject; _iconIdentifier: integer);  overload;
procedure jMenu_SetItemIcon(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _index: integer; _iconIdentifier: integer); overload;
procedure jMenu_AddDropDownItem(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _view: jObject);

implementation

{---------  jMenu  --------------}

constructor jMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FIcons:= TStringList.Create;
  FOptions:= TStringList.Create;
end;

destructor jMenu.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
  end;
  //you others free code here...
  FOptions.Free;
  FIcons.Free;
  inherited Destroy;
end;

procedure jMenu.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jMenu.jCreate(): jObject;
begin
   Result:= jMenu_jCreate(gApp.jni.jEnv, gApp.jni.jThis , int64(Self));
end;

procedure jMenu.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'jFree');
end;

procedure jMenu.Add(_menu: jObject; _itemID: integer; _caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_it(gApp.jni.jEnv, FjObject, 'Add', _menu ,_itemID ,_caption);
end;

procedure jMenu.AddCheckable(_menu: jObject; _itemID: integer; _caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_it(gApp.jni.jEnv, FjObject, 'AddCheckable', _menu ,_itemID ,_caption);
end;

procedure jMenu.AddDrawable(_menu: jObject; _itemID: integer; _caption: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_it(gApp.jni.jEnv, FjObject, 'AddDrawable', _menu ,_itemID ,_caption);
end;

procedure jMenu.SetOptions(Value: TStrings);
begin
  FOptions.Assign(Value);
end;

procedure jMenu.SetIcons(Value: TStrings);
begin
  FIcons.Assign(Value);
end;

procedure jMenu.CheckItemCommute(_item: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_mei(gApp.jni.jEnv, FjObject, 'CheckItemCommute', _item);
end;

procedure jMenu.CheckItem(_item: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_mei(gApp.jni.jEnv, FjObject, 'CheckItem', _item);
end;

procedure jMenu.UnCheckItem(_item: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_mei(gApp.jni.jEnv, FjObject, 'UnCheckItem', _item);
end;

procedure jMenu.AddSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_i_das(gApp.jni.jEnv, FjObject, 'AddSubMenu', _menu ,_startItemID ,_captions);
end;

procedure jMenu.AddCheckableSubMenu(_menu: jObject; _startItemID: integer; var _captions: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_i_das(gApp.jni.jEnv, FjObject, 'AddCheckableSubMenu', _menu ,_startItemID ,_captions);
end;

function jMenu.Size(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'Size');
end;

function jMenu.FindMenuItemByID(_itemID: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_mei(gApp.jni.jEnv, FjObject, 'FindMenuItemByID', _itemID);
end;

function jMenu.GetMenuItemByIndex(_index: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_mei(gApp.jni.jEnv, FjObject, 'GetMenuItemByIndex', _index);
end;

procedure jMenu.UnCheckAllMenuItem();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'UnCheckAllMenuItem');
end;

function jMenu.CountSubMenus(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'CountSubMenus');
end;

procedure jMenu.UnCheckAllSubMenuItemByIndex(_subMenuIndex: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'UnCheckAllSubMenuItemByIndex', _subMenuIndex);
end;

procedure jMenu.RegisterForContextMenu(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_viw(gApp.jni.jEnv, FjObject, 'RegisterForContextMenu', _view);
end;

procedure jMenu.UnRegisterForContextMenu(_View: JObject); 
begin 
  if(FInitialized) then 
   jni_proc_viw(gApp.jni.jEnv, FjObject, 'UnRegisterForContextMenu', _View);
end; 

procedure jMenu.AddItem(_menu: jObject; _itemID: integer; _caption: string; _iconIdentifier: string; _itemType: TMenuItemType; _showAsAction: TMenuItemShowAsAction);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddItem(gApp.jni.jEnv, FjObject, _menu ,_itemID ,_caption ,_iconIdentifier ,Ord(_itemType),Ord(_showAsAction));
end;

procedure jMenu.AddItem(_subMenu: jObject; _itemID: integer; _caption: string;  _itemType: TMenuItemType);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddItem(gApp.jni.jEnv, FjObject, _subMenu ,_itemID ,_caption ,Ord(_itemType));
end;

function jMenu.AddSubMenu(_menu: jObject; _title: string; _headerIconIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMenu_AddSubMenu(gApp.jni.jEnv, FjObject, _menu ,_title ,_headerIconIdentifier);
end;

procedure jMenu.InvalidateOptionsMenu();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'InvalidateOptionsMenu');
end;

procedure jMenu.SetItemVisible(_item: jObject; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_SetItemVisible(gApp.jni.jEnv, FjObject, _item ,_value);
end;

procedure jMenu.SetItemVisible(_menu: jObject; _index: integer; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_SetItemVisible(gApp.jni.jEnv, FjObject, _menu ,_index ,_value);
end;

procedure jMenu.Clear(_menu: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_Clear(gApp.jni.jEnv, FjObject, _menu);
end;

procedure jMenu.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'Clear');
end;

procedure jMenu.SetItemTitle(_item: jObject; _title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_SetItemTitle(gApp.jni.jEnv, FjObject, _item ,_title);
end;

procedure jMenu.SetItemTitle(_menu: jObject; _index: integer; _title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_it(gApp.jni.jEnv, FjObject, 'SetItemTitle', _menu ,_index ,_title);
end;

procedure jMenu.SetItemIcon(_item: jObject; _iconIdentifier: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_SetItemIcon(gApp.jni.jEnv, FjObject, _item ,_iconIdentifier);
end;

procedure jMenu.SetItemIcon(_menu: jObject; _index: integer; _iconIdentifier: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_SetItemIcon(gApp.jni.jEnv, FjObject, _menu ,_index ,_iconIdentifier);
end;

procedure jMenu.SetItemChecked(_item: jObject; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_mei_z(gApp.jni.jEnv, FjObject, 'SetItemChecked', _item ,_value);
end;

procedure jMenu.SetItemCheckable(_item: jObject; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_mei_z(gApp.jni.jEnv, FjObject, 'SetItemCheckable', _item ,_value);
end;

function jMenu.GetItemIdByIndex(_menu: jObject; _index: integer): integer;
begin
  Result := -1;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_men_i_out_i(gApp.jni.jEnv, FjObject, 'GetItemIdByIndex', _menu ,_index);
end;

function jMenu.GetItemIndexById(_menu: jObject; _id: integer): integer;
begin
  Result := -1;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_men_i_out_i(gApp.jni.jEnv, FjObject, 'GetItemIndexById', _menu ,_id);
end;

procedure jMenu.RemoveItemById(_menu: jObject; _id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_i(gApp.jni.jEnv, FjObject, 'RemoveItemById', _menu ,_id);
end;

procedure jMenu.RemoveItemByIndex(_menu: jObject; _index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_men_i(gApp.jni.jEnv, FjObject, 'RemoveItemByIndex', _menu ,_index);
end;

procedure jMenu.AddDropDownItem(_menu: jObject; _view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMenu_AddDropDownItem(gApp.jni.jEnv, FjObject, _menu ,_view);
end;

{-------- jMenu_JNI_Bridge ----------}

function jMenu_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;

  if (env = nil) or (this = nil) then exit;
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

procedure jMenu_AddItem(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _itemID: integer; _caption: string; _iconIdentifier: string; _itemType: integer; _showAsAction: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/Menu;ILjava/lang/String;Ljava/lang/String;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _itemID;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_caption));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jParams[4].i:= _itemType;
  jParams[5].i:= _showAsAction;

  if jParams[2].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[3].l = nil then begin env^.DeleteLocalRef(env, jParams[2].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jMenu_AddItem(env: PJNIEnv; _jmenu: JObject; _subMenu: jObject; _itemID: integer; _caption: string; _itemType: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/SubMenu;ILjava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _subMenu;
  jParams[1].i:= _itemID;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_caption));
  jParams[3].i:= _itemType;

  if jParams[2].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jMenu_AddSubMenu(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _title: string; _headerIconIdentifier: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddSubMenu', '(Landroid/view/Menu;Ljava/lang/String;Ljava/lang/String;)Landroid/view/SubMenu;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_headerIconIdentifier));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env, jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jmenu, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jMenu_SetItemVisible(env: PJNIEnv; _jmenu: JObject; _item: jObject; _value: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemVisible', '(Landroid/view/MenuItem;Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _item;
  jParams[1].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jMenu_SetItemVisible(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _index: integer; _value: boolean);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemVisible', '(Landroid/view/Menu;IZ)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _index;
  jParams[2].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jMenu_Clear(env: PJNIEnv; _jmenu: JObject; _menu: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '(Landroid/view/Menu;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jMenu_SetItemTitle(env: PJNIEnv; _jmenu: JObject; _item: jObject; _title: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTitle', '(Landroid/view/MenuItem;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _item;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jMenu_SetItemIcon(env: PJNIEnv; _jmenu: JObject; _item: jObject; _iconIdentifier: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemIcon', '(Landroid/view/MenuItem;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _item;
  jParams[1].i:= _iconIdentifier;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jMenu_SetItemIcon(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _index: integer; _iconIdentifier: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemIcon', '(Landroid/view/Menu;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _index;
  jParams[2].i:= _iconIdentifier;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jMenu_AddDropDownItem(env: PJNIEnv; _jmenu: JObject; _menu: jObject; _view: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jmenu = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jmenu);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddDropDownItem', '(Landroid/view/Menu;Landroid/view/View;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].l:= _view;

  env^.CallVoidMethodA(env, _jmenu, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
