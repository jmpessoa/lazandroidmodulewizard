{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTest2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
  Laz_And_Controls_Events, AndroidWidget, Laz_And_jni_Controls;
  
type


  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jButton5: jButton;
      jTextView1: jTextView;
      procedure AndroidModule1Click(Sender: TObject);
      procedure AndroidModule1Create(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jButton5Click(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
      procedure CallBackDynamicWidgetClick(jObjView: jObject; Id: integer);
      procedure CallBackDynamicWidgetItemClick(jObjAdapter: jObject; jObjView: jObject; position: integer; Id: integer);

  end;
  
var
  AndroidModule1: TAndroidModule1;


implementation
  
{$R *.lfm}

 {TAndroidModule1}

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  Self.OnViewClick:= CallBackDynamicWidgetClick;
  Self.OnListItemClick:= CallBackDynamicWidgetItemClick;
end;

procedure TAndroidModule1.CallBackDynamicWidgetClick(jObjView: jObject; Id: integer);
var
  jClass_button: jClass;
  jMethodId_getText: jMethodId;
  jMethodId_getId: jMethodId;
  jStr: jObject;
  jObjId: integer;
begin
  jClass_button:= Get_jClassLocalRef('android/widget/Button');
  //or: jClass_button:= Get_jObjectClass(jObjView);
  if Is_jInstanceOf(jObjView, jClass_button) then   //o
  begin
     //get method ::class ref, method name, (param segnature)return type
    jMethodId_getText:= Get_jMethodID(jClass_button, 'getText','()Ljava/lang/CharSequence;');
    jStr:= Call_jObjectMethod(jObjView, jMethodId_getText);
    jMethodId_getId:= Get_jMethodID(jClass_button, 'getId','()I');
    jObjId:= Call_jIntMethod(jObjView, jMethodId_getId);
    ShowMessage(Get_pString(jStr) + ' :: ID: ' + intToStr(jObjId));
  end;
  Delete_jLocalRef(jClass_button);   //just cleanup...
  //or just:
  //if Id = 1001 then ShowMessage('Id='+ IntToStr(Id));
end;

procedure TAndroidModule1.CallBackDynamicWidgetItemClick(jObjAdapter: jObject; jObjView: jObject; position: integer; Id: integer);
var
  param_pos: array[0..0] of jValue;
  jClass_listView: jClass;
  jMethodId_getItemAtPosition: jMethodId;
  jMethodId_getId: jMethodId;
  jObjRes: jObject;
  jObjId: integer;
begin

 (*
  jClass_listView:= Get_jClassLocalRef('android/widget/TextView');

  if Is_jInstanceOf(jObjView, jClass_ListView) then   //o
  begin
     //get method ::class ref, method name, (param segnature)return type
    jMethodId_getItemAtPosition:= Get_jMethodID(jClass_listView, 'getItemAtPosition ','(I)Ljava/lang/Object;');

    param_pos[0].i:= position;
    jObjRes:= Call_jObjectMethodA(jObjView, jMethodId_getItemAtPosition, param_pos);

    //jMethodId_getId:= Get_jMethodID(jClass_button, 'getId','()I');
    //jObjId:= Call_jIntMethod(jObjView, jMethodId_getId);

    ShowMessage(Get_pString(jObjRes) + ' :: ID: ' + intToStr(jObjId));
  end;
  Delete_jLocalRef(jClass_listView);   //just cleanup...
   *)

  //or just:
  ShowMessage('Position='+ IntToStr(position));

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  jParamsColor:array[0..0] of jValue;
  jParamsString:array[0..0] of jValue;
  jClass_button: jClass;
  jMethodId_setTextColor: jMethodID; //not is an object reference, not need cleanup ...
  jMethodId_setText: jMethodID;
  customColor: DWord;
begin
  customColor:= $FF2C2F3E;

  jClass_button:= Get_jClassLocalRef('android/widget/Button');

  jMethodId_setTextColor:= Get_jMethodID(jClass_button, 'setTextColor','(I)V');
  jParamsColor[0].i:= GetARGB(customColor, colbrPaleGreen); // integer ..
  Call_jVoidMethodA(jButton1.jSelf, jMethodId_setTextColor, jParamsColor);

  jMethodId_setText:= Get_jMethodID(jClass_button, 'setText','(Ljava/lang/CharSequence;)V');
  jParamsString[0].l:= Get_jString('Hello World!'); //result is a object!
  Call_jVoidMethodA(jButton1.jSelf, jMethodId_setText, jParamsString);

  Delete_jLocalParamRef(jParamsString, 0 {index});  //just cleanup...
  Delete_jLocalRef(jClass_button);   //just cleanup...
end;

//call class method!

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
   minInt: integer;
   squareRoot: double;

   jParamsInt:array[0..1] of jValue;

   jParamsDouble:array[0..0] of jValue;

begin
   jParamsInt[0].i:= 58;
   jParamsInt[1].i:= 34;
   minInt:= Call_jStaticIntMethodA('java/lang/Math', 'min', '(II)I', jParamsInt);
   ShowMessage('min(58,34) = '+IntToStr(minInt));

   jParamsDouble[0].d:= 144.0;
   squareRoot:= Call_jStaticDoubleMethodA('java/lang/Math', 'sqrt', '(D)D', jParamsDouble);
   ShowMessage('Sqrt(144) = '+FloatToStr(squareRoot));
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  len: integer;
  jParamsString:array[0..0] of jValue;

  jClass_string: jClass;
  jObj_string: jObject;

  jMethodId_concat: jMethodID;
  jMethodId_length: jMethodID; //not is an object reference!
  jMethodId_toUpperCase: jMethodID;

  jObj_strConcatenated: jObject;
  jObj_strUpper: jObject;
begin
  //create jObject String
  jClass_string:= Get_jClassLocalRef('java/lang/String'); // global ref!
  jParamsString[0].l:= Get_jString('Hello '); //result is object!
  jObj_string:= Create_jObjectLocalRefA(jClass_string,'Ljava/lang/String;', jParamsString);
  Delete_jLocalParamRef(jParamsString, 0 {index});  //just cleanup...

  //jObj_string:= Create_jObjectLocalRef(jClass_string); //create empty string ...
  //get 'concat' method ID ...

  jMethodId_concat:= Get_jMethodID(jClass_string, 'concat','(Ljava/lang/String;)Ljava/lang/String;');

  jParamsString[0].l:= Get_jString('World!'); //result is object!
  jObj_strConcatenated:= Call_jObjectMethodA(jObj_string, jMethodId_concat, jParamsString); //Hello World!"
  Delete_jLocalParamRef(jParamsString, 0 {index});  //just cleanup...

  if jObj_strConcatenated <> nil then
  begin
     ShowMessage(Get_pString(jObj_strConcatenated));
     //get "length" method ID ...
     jMethodId_length:= Get_jMethodID(jClass_string, 'length','()I');
     len:= Call_jIntMethod(jObj_strConcatenated, jMethodId_length);  //call "length"
     ShowMessage('Len(Hello World!) = '+ IntToStr(len));  //12
     //get "toUpperCase" method ID ...
     jMethodId_toUpperCase:= Get_jMethodID(jClass_string, 'toUpperCase','()Ljava/lang/String;');
     jObj_strUpper:= Call_jObjectMethod(jObj_strConcatenated, jMethodId_toUpperCase); //call "toUpperCase"
     ShowMessage(Get_pString(jObj_strUpper)); //show pascal string!
     Delete_jLocalRef(jObj_strConcatenated); //just cleanup...
     Delete_jLocalRef(jObj_strUpper);  //just cleanup...
  end;

  Delete_jLocalRef(jClass_string);
  Delete_jLocalRef(jObj_string);
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
var

  jParamsString:array[0..1] of jValue;

  jParamsId: array[0..0] of jValue;
  jParamsColor: array[0..0] of jValue;

  jParamsContext:array[0..0] of jValue;
  jParamsInt:array[0..1] of jValue;

  jParamsPosRelativeToParent: array[0..0] of jValue;
  jParamsPosRelativeToAnchor: array[0..1] of jValue;

  jParamsLayout: array[0..0] of jValue;
  jParamsButton:array[0..0] of jValue;
  jParamsListener: array[0..0] of jValue;

  jClass_button: jClass;
  jClass_Param: jClass;
  jClass_viewgroup: jClass;
  jClass_view: jClass;

  jMethodId_setText: jMethodID; //not is an object reference!
  jMethodId_setTextColor: jMethodID;
  jMethodId_setId: jMethodID;

  jMethodId_setLayoutParams: jMethodID;
  jMethodId_addRule: jMethodID;
  jMethodId_addRuleAnchor: jMethodID;
  jMethodId_getId: jMethodID;

  jMethodId_addView: jMethodID;
  jMethodId_setOnClickListener: jMethodID;

  jObj_layoutParams: jObject;
  jObj_button: jObject;
  anchorID: integer;
  list: array of string;
  customColor: DWord;
begin

   customColor:= $FF2C2F3E;

   jParamsContext[0].l:= gApp.GetContext; //get Activity/Context object

   //get class button
   jClass_button:= Get_jClassLocalRef('android/widget/Button');

   //create object button ::class ref,param signature, param
   jObj_button:=Create_jObjectLocalRefA(jClass_button, 'Landroid/content/Context;', jParamsContext);

   //get method :: class ref, method name, (param segnature)return type
   jMethodId_setText:= Get_jMethodID(jClass_button, 'setText','(Ljava/lang/CharSequence;)V');
   jParamsString[0].l:= Get_jString('Button 1!'); //result is object!
   Call_jVoidMethodA(jObj_button, jMethodId_setText, jParamsString);
   Delete_jLocalParamRef(jParamsString, 0 {index});  //just cleanup...


   //set sTextColor
   jMethodId_setTextColor:= Get_jMethodID(jClass_button, 'setTextColor','(I)V');
   jParamsColor[0].i:= GetARGB(customColor, colbrPaleGreen); // integer ..
   Call_jVoidMethodA(jObj_button, jMethodId_setTextColor, jParamsColor);

   //get method  setId
   jMethodId_setId:= Get_jMethodID(jClass_button, 'setId','(I)V');
   jParamsId[0].i:= 1001;
   Call_jVoidMethodA(jObj_button, jMethodId_setId, jParamsId);

   //create object LayoutParam and addRule
   jParamsInt[0].i:= GetLayoutParams(gApp, lpHalfOfParent {lpMatchParent}, sdW);  //W
   jParamsInt[1].i:= GetLayoutParams(gApp, lpWrapContent, sdH);  //H

   jClass_Param:= Get_jClassLocalRef('android/widget/RelativeLayout$LayoutParams');
   jObj_layoutParams:= Create_jObjectLocalRefA(jClass_Param,'II', jParamsInt);  //create an empty string!

   jMethodId_addRule:= Get_jMethodID(jClass_param, 'addRule','(I)V');

   jParamsPosRelativeToParent[0].i:= GetPositionRelativeToParent(rpLeft{rpCenterHorizontal});  //a rule ...
   Call_jVoidMethodA(jObj_layoutParams, jMethodId_addRule, jParamsPosRelativeToParent); //set center horiz

   //jParamsPosRelativeToParent[0].i:= GetPositionRelativeToParent(rpBottom);  //other rule ...
   //Call_jVoidMethodA(jObj_layoutParams, jMethodId_addRule, jParamsPosRelativeToParent);

   //Set anchor object ...
   jClass_view:= Get_jClassLocalRef('android/view/View');
   jMethodId_getId:= Get_jMethodID({jClass_button}jClass_view , 'getId','()I');
   anchorId:= Call_jIntMethod(jButton4.jSelf, jMethodId_getId); //choice jButton4 as anchor ...
   if anchorId <= 0 then
   begin
     anchorId:=  9999;
     jMethodId_setId:= Get_jMethodID({jClass_button} jClass_view, 'setId','(I)V');
     jParamsId[0].i:= anchorId;
     Call_jVoidMethodA(jButton4.jSelf, jMethodId_setId, jParamsId);
   end;
   jParamsPosRelativeToAnchor[0].i:= GetPositionRelativeToAnchor(raBelow);  //set below  jButton4
   jParamsPosRelativeToAnchor[1].i:= anchorId;
   jMethodId_addRuleAnchor:= Get_jMethodID(jClass_param, 'addRule','(II)V'); //rule and anchorID
   Call_jVoidMethodA(jObj_layoutParams, jMethodId_addRuleAnchor, jParamsPosRelativeToAnchor);

   Delete_jLocalRef(jClass_Param);

   //get setLayoutParams from class Button
   jMethodId_setLayoutParams:= Get_jMethodID(jClass_button, 'setLayoutParams','(Landroid/view/ViewGroup$LayoutParams;)V');
   jParamsLayout[0].l:= jObj_layoutParams;
   Call_jVoidMethodA(jObj_button, jMethodId_setLayoutParams, jParamsLayout); //setLayoutParams(jObj_layoutParams)


   //get setOnClickListener from class Button
   jParamsListener[0].l:=  Self.GetOnViewClickListener(Self.jSelf); //or Self.OnClickListener; //or gApp.GetClickListener;
   jMethodId_setOnClickListener:= Get_jMethodID(jClass_button, 'setOnClickListener','(Landroid/view/View$OnClickListener;)V');
   Call_jVoidMethodA(jObj_button, jMethodId_setOnClickListener, jParamsListener); //jMethodId_setOnClickListener(...)


   //get "addView" from android.view.ViewGroup
   jClass_viewgroup:= Get_jClassLocalRef('android/view/ViewGroup');
   jMethodId_addView:= Get_jMethodID(jClass_viewgroup, 'addView','(Landroid/view/View;)V');
   Delete_jLocalRef(jClass_viewgroup);

   jParamsButton[0].l:=  jObj_button;
   Call_jVoidMethodA(Self.View {theform view!}, jMethodId_addView, jParamsButton); // addView(jObj_button)

   Delete_jLocalRef(jParamsLayout[0].l); //just cleanup...
   //or: Delete_jLocalRef(jObj_param);

   Delete_jLocalRef(jObj_button);
   //or Delete_jLocalRef(jParamsButton[0].l); //just cleanup...

end;

procedure TAndroidModule1.jButton5Click(Sender: TObject);
var
  my_jObj: TAndroidListView;
  arrayStringsItems: array of string;
  jStringListAdapter: jObject;
begin

  SetLength(arrayStringsItems, 4);

  arrayStringsItems[0]:= 'Item 0';
  arrayStringsItems[1]:= 'Item 1';
  arrayStringsItems[2]:= 'Item 2';
  arrayStringsItems[3]:= 'Item 3';

  my_jObj:= TAndroidListView.Create(Self);
  my_jObj.LayoutParamWidth:= lpMatchParent; //lpHalfOfParent;   //try this!
  my_jObj.LayoutParamHeight:= lpWrapContent;

  my_jObj.Init(gApp);

  jStringListAdapter:= my_jObj.GetStringListAdapter(arrayStringsItems);

  my_jObj.SetArrayAdapter(jStringListAdapter);

  my_jObj.AddStringToListAdapter(jStringListAdapter, 'Hello');

  my_jObj.NotifyDataSetChanged(jStringListAdapter);

  //my_jObj.Text:= 'Button 1!';
  //my_jObj.SetTextColor(GetARGB(colbrPaleGreen));

  my_jObj.BackgroundColor:= colbrPaleGreen;

  my_jObj.Id:= 2001;

  my_jObj.AddParentRule(GetPositionRelativeToParent(rpCenterHorizontal{rpRight}));

   //my_jObj.AddParentRule(GetPositionRelativeToParent(rpBottom));

  my_jObj.AddAnchorRule(GetPositionRelativeToAnchor(raBelow), jButton4.jSelf);

  my_jObj.AddToView(Self.View);

  my_jObj.SetOnItemClickListener(Self.GetOnListItemClickListener(Self.jSelf));

end;

procedure TAndroidModule1.AndroidModule1Click(Sender: TObject);
begin
   ShowMessage('Form Click .... ');
end;


end.
