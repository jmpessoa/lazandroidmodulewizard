unit Laz_And_jni_Controls;

{$mode delphi}

interface

uses
  Classes, SysUtils, Math, types, And_jni, AndroidWidget;

type

TAndroidVisualControl= class(jVisualControl)
private

protected

  FjClass_Param: jObject;
  FjObj_layoutParams: jObject;
  function GetId: integer;
  procedure SetId(Value: integer);
  procedure SetBackgroundColor(Value: TARGBColorBridge);

public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp); override;

  procedure AddParentRule(Value: integer);
  procedure AddAnchorRule(Value: integer; AnchorId: integer); overload;
  procedure AddAnchorRule(Value: integer; Anchor: jObject); overload;
  procedure SetOnClickListener(jClickListener: jObject);
  procedure AddToView(jView: jObject);

  property BackgroundColor: TARGBColorBridge read FColor write SetBackgroundColor; //background ... needed by design...

end;

TAndroidTextView= class(TAndroidVisualControl)
private
  procedure SetText(Value: string);
  function  GetText: string;

  //function GetTextColor: integer;
  procedure SetTextColor(Value: TARGBColorBridge);

protected
  //FText: string;
  //FTextColor: integer;

  //procedure SetName(const NewName: TComponentName); override;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp); override;

  property Text: string read GetText write SetText;
  //property TextColor: integer read GetTextColor write SetTextColor;
  property FontColor   : TARGBColorBridge read FFontColor write SetTextColor;  //needed by design...
end;

TAndroidEditText= class(TAndroidTextView)
private
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp); override;
end;

TAndroidButton= class(TAndroidTextView)
private
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp); override;
end;

TAndroidRadioButton= class(TAndroidTextView)
private
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp); override;

  function IsChecked: boolean;
  procedure SetChecked(Value: boolean );

end;

TAndroidCheckBox= class(TAndroidTextView)
private
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp); override;

  function IsChecked: boolean;
  procedure SetChecked(Value: boolean );

end;

TAndroidListView= class(TAndroidVisualControl)
private
  FItems: TStrings;
  procedure SetItems(Value: TStrings);
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Init(refApp: jApp);
  procedure SetArrayAdapter(jAdapter: jObject);
  function GetStringListAdapter(strList: array of string): jObject;
  function GetItemAtPosition(position: integer): jObject;
  procedure AddStringToListAdapter(jAdapter: jObject; str: string);
  procedure NotifyDataSetChanged(jAdapter: jObject);
  procedure SetOnItemClickListener(jItemClickListener: jObject);

  property Items: TStrings read FItems write SetItems;
end;


function jBool( Bool : Boolean ) : byte;

implementation

{TAndroidControl}
(*
constructor TAndroidControl.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

destructor TAndroidControl.Destroy;
begin
 inherited Destroy;
end;
 *)

{TAndroidVisualControl}

constructor TAndroidVisualControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAndroidVisualControl.Destroy;
begin
 inherited Destroy;
end;

procedure TAndroidVisualControl.Init(refApp: jApp);
var
  jParamsContext:array[0..0] of jValue;
  jParamsInt: array[0..1] of jValue;
  jParamsLayout: array[0..0] of jValue;
  jMethodId_setLayoutParams: jMethodID;
begin
  Inherited Init(refApp);

  jParamsContext[0].l:= refApp.GetContext; //get Activity/Context jObject

  FjObject := Create_jObjectLocalRefA(FjClass, 'Landroid/content/Context;', jParamsContext);

  jParamsInt[0].i:= GetLayoutParams(refApp, FLParamWidth, sdW);  //W
  jParamsInt[1].i:= GetLayoutParams(refApp, FLParamHeight, sdH);  //H

  FjClass_Param:= Get_jClassLocalRef('android/widget/RelativeLayout$LayoutParams');
  FjObj_layoutParams:= Create_jObjectLocalRefA(FjClass_Param,'II', jParamsInt);
  jMethodId_setLayoutParams:= Get_jMethodID(FjClass, 'setLayoutParams','(Landroid/view/ViewGroup$LayoutParams;)V');
  jParamsLayout[0].l:= FjObj_layoutParams;
  Call_jVoidMethodA(FjObject , jMethodId_setLayoutParams, jParamsLayout); //setLayoutParams(jObj_layoutParams)

  FInitialized:= True;

end;

procedure TAndroidVisualControl.AddToView(jView: jObject);
var
  jParams_jSelf: array[0..0] of jValue;
  jClass_viewgroup: jObject;
  jMethodId_addView: jMethodID;
begin
  jClass_viewgroup:= Get_jClassLocalRef('android/view/ViewGroup');
  jMethodId_addView:= Get_jMethodID(jClass_viewgroup, 'addView','(Landroid/view/View;)V');
  Delete_jLocalRef(jClass_viewgroup);
  jParams_jSelf[0].l:=  FjObject ;
  Call_jVoidMethodA(jView, jMethodId_addView, jParams_jSelf);
end;

procedure TAndroidVisualControl.SetOnClickListener(jClickListener: jObject);
var
  jParamsListener: array[0..0] of jValue;
  jMethodId_setOnClickListener: jMethodID;
begin
  if FInitialized then
  begin
   jParamsListener[0].l:= jClickListener;
   jMethodId_setOnClickListener:= Get_jMethodID(FjClass, 'setOnClickListener','(Landroid/view/View$OnClickListener;)V');
   Call_jVoidMethodA(FjObject , jMethodId_setOnClickListener, jParamsListener);
  end;
end;

{
procedure TAndroidVisualControl.SetClassPath(clssPath: string);
begin
 FClassPath:= clssPath;
end;
}

procedure TAndroidVisualControl.SetId(Value: integer);
var
  jParams_setId: array[0..0] of jValue;
  jMethodId_setId: jMethodID; //not is an object reference!
begin
  FId:= Value;
  if FInitialized then
  begin
    //get method :: class ref, method name, (param segnature)return type
    jMethodId_setId:= Get_jMethodID(FjClass, 'setId','(I)V');
    jParams_setId[0].i:= FId;
    Call_jVoidMethodA(FjObject , jMethodId_setId, jParams_setId);
  end;
end;

function TAndroidVisualControl.GetId: integer;
var

  jMethodId_getId: jMethodID;
begin
  Result:= Fid;
  if FInitialized then
  begin
   //get method :: class ref, method name, (param segnature)return type
   jMethodId_getId:= Get_jMethodID(FjClass, 'getId','()I');
   Result:= Call_jIntMethod(FjObject , jMethodId_getId);
  end;
end;

procedure TAndroidVisualControl.SetBackgroundColor(Value: TARGBColorBridge);
var
  jParams_setBackgroundColor: array[0..0] of jValue;
  jMethodId_setBackgroundColor: jMethodID; //not is an object reference!
begin
  FColor:=  Value; //background color...
  if FInitialized then
  begin
   //get method :: class ref, method name, (param segnature)return type
   jMethodId_setBackgroundColor:= Get_jMethodID(FjClass, 'setBackgroundColor','(I)V');
   jParams_setBackgroundColor[0].i:= GetARGB(FCustomColor, FColor); // integer ..
   Call_jVoidMethodA(FjObject , jMethodId_setBackgroundColor, jParams_setBackgroundColor);
  end;
end;

procedure TAndroidVisualControl.AddParentRule(Value: integer);
var
 jParamsPosRelativeToParent: array[0..0] of jValue;
 jMethodId_addRule: jMethodID;
begin
if FInitialized then
begin
  jMethodId_addRule:= Get_jMethodID(FjClass_param, 'addRule','(I)V');
  jParamsPosRelativeToParent[0].i:= Value; //a rule ...  //GetPositionRelativeToParent(rpCenterHorizontal);
  Call_jVoidMethodA(FjObj_layoutParams, jMethodId_addRule, jParamsPosRelativeToParent);
end;
end;

procedure TAndroidVisualControl.AddAnchorRule(Value: integer; AnchorId: integer);
var
  jParamsPosRelativeToAnchor: array[0..1] of jValue;
  jMethodId_addRule: jMethodID;
begin
  if FInitialized then
  begin
   jMethodId_addRule:= Get_jMethodID(FjClass_param, 'addRule','(II)V');
   jParamsPosRelativeToAnchor[0].i:= Value;
   jParamsPosRelativeToAnchor[1].i:= AnchorId;
   Call_jVoidMethodA(FjObj_layoutParams, jMethodId_addRule, jParamsPosRelativeToAnchor); //set center horiz
  end;
end;

procedure TAndroidVisualControl.AddAnchorRule(Value: integer; Anchor: jObject); overload;
var
 jParamsId: array[0..1] of jValue;
 jParamsPosRelativeToAnchor: array[0..1] of jValue;
 jMethodId_addRule: jMethodID;
 jMethodId_getId:  jMethodID;
 jMethodId_setId:  jMethodID;
 anchorId: integer;
 jClass_view: jClass;
begin

 //Set anchor object ...
  if FInitialized then
  begin
    jClass_view:= Get_jClassLocalRef('android/view/View');
    jMethodId_getId:= Get_jMethodID(jClass_view, 'getId','()I');
    anchorId:= Call_jIntMethod(Anchor, jMethodId_getId);
    if anchorId <= 0 then
    begin
      anchorId:=  199991;   //random!
      jMethodId_setId:= Get_jMethodID(jClass_view, 'setId','(I)V');
      jParamsId[0].i:= anchorId;
      Call_jVoidMethodA(Anchor, jMethodId_setId, jParamsId);
    end;
    jMethodId_addRule:= Get_jMethodID(FjClass_param, 'addRule','(II)V');
    jParamsPosRelativeToAnchor[0].i:= Value;
    jParamsPosRelativeToAnchor[1].i:= anchorId;
    Call_jVoidMethodA(FjObj_layoutParams, jMethodId_addRule, jParamsPosRelativeToAnchor); //set center horiz
  end;

end;

{TAndroidTextView}

constructor TAndroidTextView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClassPath:= 'android/widget/TextView';
  FText:= 'TextView';
end;

destructor TAndroidTextView.Destroy;
begin
 inherited Destroy;
end;

procedure TAndroidTextView.Init(refApp: jApp);
begin
  Inherited Init(refApp);
  if FText <> '' then Self.SetText(FText);
end;

procedure TAndroidTextView.SetText(Value: string);
var
  jParams_setText: array[0..0] of jValue;
  jMethodId_setText: jMethodID; //not is an object reference!
begin
  FText:= Value;
  if (csDesigning in ComponentState) then Invalidate;

  if FInitialized then
  begin
    //get method :: class ref, method name, (param segnature)return type
    jMethodId_setText:= Get_jMethodID(FjClass, 'setText','(Ljava/lang/CharSequence;)V');
    jParams_setText[0].l:= Get_jString(FText); //result is a jObject!
    Call_jVoidMethodA(FjObject , jMethodId_setText, jParams_setText);
    Delete_jLocalParamRef(jParams_setText, 0 {index});  //just cleanup...
  end;
end;

function TAndroidTextView.GetText: string;
begin
    Result:= FText;
end;

procedure TAndroidTextView.SetTextColor(Value: TARGBColorBridge);
var
  jParams_setTextColor: array[0..0] of jValue;
  jMethodId_setTextColor: jMethodID; //not is an object reference!
begin
  //FTextColor:= Value;
  FFontColor:= Value;
  if FInitialized then
  begin
   //get method :: class ref, method name, (param segnature)return type
   jMethodId_setTextColor:= Get_jMethodID(FjClass, 'setTextColor','(I)V');
   jParams_setTextColor[0].i:= GetARGB(FCustomcolor, Value); // integer ..
   Call_jVoidMethodA(FjObject , jMethodId_setTextColor, jParams_setTextColor);
  end;
end;

(*
function TAndroidTextView.GetTextColor: integer;
var
  jMethodId_getTextColor: jMethodID;
begin
  Result:= FTextColor;
  if FInitialized then
  begin
    //get method :: class ref, method name, (param segnature)return type
    jMethodId_getTextColor:= Get_jMethodID(FjClass, 'getTextColor','()I');
    Result:= Call_jIntMethod(jSelf, jMethodId_getTextColor);
  end;
end;
*)

(*
procedure TAndroidTextView.SetName(const NewName: TComponentName);
begin
  if (csDesigning in ComponentState) then
     if Name = FText then FText:= NewName;
  inherited SetName(NewName);
end;
*)

{TAndroidEditText}

constructor TAndroidEditText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClassPath:= 'android/widget/EditText';
 //
end;

destructor TAndroidEditText.Destroy;
begin
  inherited Destroy;
end;

procedure TAndroidEditText.Init(refApp: jApp);
begin
   Inherited Init(refApp);
end;

{TAndroidButton}

constructor TAndroidButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText:= 'Button';
  FClassPath:= 'android/widget/Button';
end;

destructor TAndroidButton.Destroy;
begin
 inherited Destroy;
end;

procedure TAndroidButton.Init(refApp: jApp);
begin
 Inherited Init(refApp);
end;

{TAndroidRadioButton}

constructor TAndroidRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText:= 'RadioButton';
  FClassPath:= 'android/widget/RadioButton';
end;

destructor TAndroidRadioButton.Destroy;
begin
 inherited Destroy;
end;

procedure TAndroidRadioButton.Init(refApp: jApp);
begin
 Inherited Init(refApp);
end;

function TAndroidRadioButton.IsChecked: boolean;
var
  jMethodId_isChecked: jMethodID;
begin
  if FInitialized then
  begin
    jMethodId_isChecked:= Get_jMethodID(FjClass, 'isChecked','()Z');
    Result:= boolean(Call_jBooleanMethod(FjObject , jMethodId_isChecked));
 end;
end;

procedure TAndroidRadioButton.SetChecked(Value: boolean);
var
  jMethodId_setChecked: jMethodID;
  Param_check: array[0..0] of jValue;
begin
  if FInitialized then
  begin
    Param_check[0].z:= jBool(Value);
    jMethodId_setChecked:= Get_jMethodID(FjClass, 'setChecked','(Z)V');
    Call_jVoidMethodA(FjObject , jMethodId_setChecked, Param_check);
 end;
end;


{TAndroidCheckBox}

constructor TAndroidCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText:= 'CheckBox';
  FClassPath:= 'android/widget/CheckBox';
end;

destructor TAndroidCheckBox.Destroy;
begin
 inherited Destroy;
end;

procedure TAndroidCheckBox.Init(refApp: jApp);
begin
 Inherited Init(refApp);
end;

function TAndroidCheckBox.IsChecked: boolean;
var
  jMethodId_isChecked: jMethodID;
begin
  if FInitialized then
  begin
    jMethodId_isChecked:= Get_jMethodID(FjClass, 'isChecked','()Z');
    Result:= boolean(Call_jBooleanMethod(FjObject , jMethodId_isChecked));
 end;
end;

procedure TAndroidCheckBox.SetChecked(Value: boolean);
var
  jMethodId_setChecked: jMethodID;
  Param_check: array[0..0] of jValue;
begin
  if FInitialized then
  begin
    Param_check[0].z:= jBool(Value);
    jMethodId_setChecked:= Get_jMethodID(FjClass, 'setChecked','(Z)V');
    Call_jVoidMethodA(FjObject , jMethodId_setChecked, Param_check);
 end;
end;


   {TAndroidListView}

constructor TAndroidListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClassPath:= 'android/widget/ListView';
  FItems:= TstringList.Create;
end;

destructor TAndroidListView.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TAndroidListView.Init(refApp: jApp);
begin
  Inherited Init(refApp);
end;

procedure TAndroidListView.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TAndroidListView.SetArrayAdapter(jAdapter: jObject);
var
  jClass_listView: jClass;
  jMethodId_setAdapter: jMethodID;
  Param_adapter: array[0..0] of jValue;
begin
    //Set anchor object ...
  if FInitialized then
  begin
    jClass_listView:= Get_jClassLocalRef('android/widget/ListView');
    Param_adapter[0].l:= jAdapter;
    jMethodId_setAdapter:= Get_jMethodID(jClass_listView, 'setAdapter','(Landroid/widget/ListAdapter;)V');
    Call_jVoidMethodA(FjObject , jMethodId_setAdapter, Param_adapter); //set center horiz
 end;
end;

procedure TAndroidListView.AddStringToListAdapter(jAdapter: jObject; str: string);
var
  jParamsString:array[0..0] of jValue;
  jClass_arrayAdapter: jClass;
  jClass_string: jClass;
  jObj_string: jObject;
  jMethodId_Add:  jMethodID;

begin
  jClass_string:= Get_jClassLocalRef('java/lang/String');
  jClass_arrayAdapter:= Get_jClassLocalRef('android/widget/ArrayAdapter');
  jMethodId_Add:= Get_jMethodID(jClass_arrayAdapter, 'add','(Ljava/lang/Object;)V');
  jParamsString[0].l:= Get_jString(str);
  jObj_string:= Create_jObjectLocalRefA(jClass_string,'Ljava/lang/String;', jParamsString);
  jParamsString[0].l:= jObj_string;
  Call_jVoidMethodA(jAdapter, jMethodId_Add, jParamsString); //set center horiz
  Delete_jLocalParamRef(jParamsString, 0 {index});         //just cleanup...
end;

procedure TAndroidListView.NotifyDataSetChanged(jAdapter: jObject);
var
  jClass_arrayAdapter: jClass;
  jMethodId_notifyDataSetChanged:  jMethodID;
begin
  jClass_arrayAdapter:= Get_jClassLocalRef('android/widget/ArrayAdapter');
  jMethodId_notifyDataSetChanged:= Get_jMethodID(jClass_arrayAdapter, 'notifyDataSetChanged','()V');
  Call_jVoidMethod(jAdapter, jMethodId_notifyDataSetChanged);
end;

function TAndroidListView.GetStringListAdapter(strList: array of string):jObject;
var
  len, i: integer;
  jParamsString:array[0..0] of jValue;

  jParams_adapter:array[0..2] of jValue;
  jClass_arrayAdapter: jClass;

  jClass_string: jClass;
  jObj_string: jObject;

  jMethodId_Add1:  jMethodID;
  jClass_ArrayList: jClass;
  jObj_arrayList: jObject;

begin
  jClass_string:= Get_jClassLocalRef('java/lang/String');
  len:= Length(strList);

  jClass_ArrayList:= Get_jClassLocalRef('java/util/ArrayList');

  jMethodId_Add1:= Get_jMethodID(jClass_ArrayList, 'add','(Ljava/lang/Object;)Z');

  jObj_ArrayList:=Create_jObjectLocalRef(jClass_ArrayList);

  for i:= 0 to len-1 do
  begin
    jParamsString[0].l:= Get_jString(strList[i]);
    jObj_string:= Create_jObjectLocalRefA(jClass_string,'Ljava/lang/String;', jParamsString);
    jParamsString[0].l:= jObj_string;
    Call_jBooleanMethodA(jObj_ArrayList, jMethodId_Add1, jParamsString); //set center horiz
    Delete_jLocalParamRef(jParamsString, 0 {index});         //just cleanup...
  end;

  jParams_adapter[0].l:= gApp.GetContext;
  // http://developer.android.com/reference/android/R.layout.html
  jParams_adapter[1].i:= 17367043;  //public static final int simple_list_item_1
  jParams_adapter[2].l:= jObj_ArrayList;
  jClass_arrayAdapter:= Get_jClassLocalRef('android/widget/ArrayAdapter');
  Result:= Create_jObjectLocalRefA(jClass_arrayAdapter, 'Landroid/content/Context;ILjava/util/List;',jParams_adapter);
end;

function TAndroidListView.GetItemAtPosition(position: integer): jObject;
var
  jParams_itemAtPos: array[0..0] of jValue;
  jMethodId_getItemAtPosition:  jMethodID;
begin
  jMethodId_getItemAtPosition:= Get_jMethodID(FjClass, 'getItemAtPosition','(I)V');
  jParams_itemAtPos[0].i:= position;
  Result:=Call_jObjectMethodA(FjObject, jMethodId_getItemAtPosition, jParams_itemAtPos);
end;

procedure TAndroidListView.SetOnItemClickListener(jItemClickListener: jObject);
var
  jParams_listener: array[0..0] of jValue;
  jMethodId_setOnItemClickListener:  jMethodID;
begin
  if FInitialized then
  begin
    jParams_listener[0].l:= jItemClickListener;
    jMethodId_setOnItemClickListener:= Get_jMethodID(FjClass, 'setOnItemClickListener',
                                                              '(Landroid/widget/AdapterView$OnItemClickListener;)V');
     Call_jVoidMethodA(FjObject, jMethodId_SetOnItemClickListener, jParams_listener);
  end;
end;

// generic ...

function jBool( Bool : Boolean ) : byte;
 begin
  Case Bool of
   True  : Result := 1;
   False : Result := 0;
  End;
 end;


end.

