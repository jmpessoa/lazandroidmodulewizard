unit rawjnihelper;

interface

uses
   Classes, SysUtils, StrUtils;

function GetNativeParamName(param: string): string;
function TryNativeConvertSignature(param: string): string;
function TryNativeConvertParam(param: string): string;
function GetNativePascalTypeSignature(jSignature: string): string;
function GetNativePascalFuncResultHack(jType: string): string;
function GetNativePascalSignature(const methodNative: string; out eventname: string; out outType: string): string;
procedure GetNativeMethodInterfaceList(pascalMainUnit: string; jclassname: string; nativeMethod: TStringList;
                                       namingBypass: TStringList;
                                       out bridgeContentList: TStringList;
                                       out unitInterfaceList: TStringList;
                                       out unitImplementationList: TStringList);

function GetJavaClassName(selList: TStringList): string;
procedure GetNativeMethodList(selList: TStringList; nativeEventMethodList: TStringList; namingBypassList: TStringList);
procedure ProduceRawJniInterface(pascalMainUnit: string; jclasspath: string;
                                 out bridgeContentList: TStringList;
                                 out unitInterfaceList: TStringList;
                                 out unitImplementationList: TStringList);
function GetCallSignature(const nativeMethod: string): string;

implementation

function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result:= theString;
       theString:= '';
    end;
  end;
end;

function GetCallSignature(const nativeMethod: string): string;
var
  method: string;
  signature: string;
  params, paramName: string;
  i, d, p, p1, p2: integer;
  listParam: TStringList;
begin
  listParam:= TStringList.Create;
  method:= nativeMethod;

  p:= Pos('native', method);
  method:= Copy(method, p+Length('native'), MaxInt);
  p1:= Pos('(', method);
  p2:= PosEx(')', method, p1 + 1);
  d:=(p2-p1);

  params:= Copy(method, p1+1, d-1); //long pasobj, long elapsedTimeMillis
  method:= Copy(method, 1, p1-1);
  method:= Trim(method); //void pOnChronometerTick
  Delete(method, 1, Pos(' ', method));
  method:= Trim(method); //pOnChronometerTick

  signature:= '(PEnv,this';  //no param...

  if  Length(params) > 3 then
  begin
    listParam.Delimiter:= ',';
    listParam.StrictDelimiter:= True;
    listParam.DelimitedText:= params;

    for i:= 0 to listParam.Count-1 do
    begin
       paramName:= Trim(listParam.Strings[i]); //long pasobj
       Delete(paramName, 1, Pos(' ', paramName));
       listParam.Strings[i]:= Trim(paramName);
    end;

    for i:= 0 to listParam.Count-1 do
    begin
      if Pos('pasobj', listParam.Strings[i]) > 0 then
        signature:= signature + ',TObject(' + listParam.Strings[i]+')'
      else
        signature:= signature + ',' + listParam.Strings[i];
    end;

    Result:= method+'=Java_Call_'+method+signature+');'; //Java_Event_

  end;

  listParam.Free;
end;

function GetNativeOutPascalReturnInit(ptype: string): string;
begin
  Result:= '0';
  if ptype = 'TDynArrayOfInteger' then Result:= 'nil'
  else if ptype = 'TDynArrayOfString'  then Result:= 'nil'
  else if ptype = 'TDynArrayOfSingle'  then Result:= 'nil'
  else if ptype = 'TDynArrayOfDouble'  then Result:= 'nil'
  else if ptype = 'TDynArrayOfJByte'   then Result:= 'nil'
  else if ptype = 'boolean' then Result:= 'False'
  else if ptype = 'string'  then Result:= '''''';
end;

function GetNativeParamName(param: string): string;
var
  pname, ptype: string;
begin
  ptype:= param;
  pname:= SplitStr(ptype, ':');
  Result:= pname;
end;

function TryNativeConvertSignature(param: string): string;
var
  pname, ptype: string;
begin
  Result:= param;
  ptype:= param;
  pname:= SplitStr(ptype, ':');
  if Pos('jfloatArray', ptype) > 0 then Result:= pname + ':' + 'array of single'
  else if Pos('jdoubleArray', ptype) > 0 then Result:= pname + ':' + 'array of double'
  else if Pos('jintArray', ptype) > 0 then Result:= pname + ':' + 'array of integer'
  else if Pos('jbyteArray', ptype) > 0 then Result:= pname + ':' + 'array of shortint'
  else if Pos('jString', ptype) > 0 then Result:= pname + ':' + 'string'
  else if Pos('jstringArray', ptype) > 0 then Result:= pname + ':' + 'array of string'
  else if Pos('jBoolean', ptype) > 0 then Result:= pname + ':' + 'boolean';
end;

function TryNativeConvertParam(param: string): string;
var
  pname, ptype: string;
begin
  ptype:= param;
  pname:= SplitStr(ptype, ':');
  Result:= pname;
  if Pos('jString', ptype) > 0 then Result:= 'GetString(env,'+pname+')'
  else if Pos('jBoolean', ptype) > 0 then Result:= 'boolean('+pname+')'
  else if Pos('jbyteArray', ptype) > 0 then Result:= 'GetDynArrayOfJByte(env,'+pname+')'  //array of shortint
  else if Pos('jintArray', ptype) > 0 then Result:= 'GetDynArrayOfInteger(env,'+pname+')'
  else if Pos('jfloatArray', ptype) > 0 then Result:= 'GetDynArrayOfSingle(env,'+pname+')'
  else if Pos('jdoubleArray', ptype) > 0 then Result:= 'GetDynArrayOfDouble(env,'+pname+')'
  else if Pos('jstringArray', ptype) > 0 then Result:= 'GetDynArrayOfString(env,'+pname+')';
end;

//----------------------------Native Call Pascal Interface------------------
function GetNativePascalTypeSignature(jSignature: string): string;
var
  jType, pType: string;
  jName: string;
begin
    pType:= 'JObject';

    jName:= Trim(jSignature);
    jType:= SplitStr(jName, ' ');

    if Pos('String', jType) > 0 then
    begin
      pType:= 'jString';
      if Pos('String[', jType) > 0 then pType:= 'jstringArray';
    end
    else if Pos('int', jType) > 0  then  //The search is case-sensitive!
    begin
       pType := 'integer';
       if Pos('[', jType) > 0 then pType := 'jintArray';
    end
    else if Pos('double',jType) > 0 then
    begin
       pType := 'double';
       if Pos('[', jType) > 0 then pType := 'jdoubleArray';
    end
    else if Pos('float', jType) > 0 then
    begin
       pType := 'single';
       if Pos('[', jType) > 0 then pType := 'jfloatArray';
    end
    else if Pos('char', jType) > 0 then
    begin
       pType := 'jchar';
       if Pos('[', jType) > 0 then pType := 'jcharArray';
    end
    else if Pos('short', jType) > 0 then
    begin
       pType := 'smallint';
       if Pos('[', jType) > 0 then pType := 'jshortArray';
    end
    else if Pos('boolean', jType) > 0 then
    begin
       pType := 'jBoolean';
       if Pos('[', jType) > 0 then pType := 'jbooleanArray';
    end
    else if Pos('byte', jType) > 0 then
    begin
       pType := 'jbyte';
       if Pos('[', jType) > 0 then pType := 'jbyteArray';
    end
    else if Pos('long', jType) > 0 then
    begin
       pType := 'int64';
       if Pos('[', jType) > 0 then pType := 'jlongArray';
    end;

    if  jName <> '' then
      Result:= jName + ':' + pType
    else
      Result:= pType;

end;

function GetNativePascalFuncResultHack(jType: string): string;
begin
  Result:= 'jObject';
  if Pos('String', jType) > 0 then
  begin
     Result:= 'string';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfString';
  end else if Pos('int', jType) > 0  then
  begin
     Result := 'integer';  //longint
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfInteger';
  end
  else if Pos('double',jType) > 0 then
  begin
     Result := 'double';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfDouble';
  end
  else if Pos('float', jType) > 0 then
  begin
     Result := 'single';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfSingle';
  end
  else if Pos('char', jType) > 0 then
  begin
     Result := 'char';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfJChar';
  end
  else if Pos('short', jType) > 0 then
  begin
     Result := 'smallint';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfSmallint';  //smallint
  end
  else if Pos('boolean', jType) > 0 then
  begin
     Result := 'boolean';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfJBoolean';
  end
  else if Pos('byte', jType) > 0 then
  begin
     Result := 'byte';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfJByte';  //array of shortint
  end
  else if Pos('long', jType) > 0 then
  begin
     Result := 'int64';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfInt64';
  end;

  if Result = 'jObject' then
      if Pos('[', jType) > 0 then Result := 'TDynArrayOfJObject';

end;

function GetNativePascalSignature(const methodNative: string; out eventname: string; out outType: string): string;
var
  method: string;
  signature: string;
  params: string;
  i, d, p, p1, p2: integer;
  listParam: TStringList;
  fTypereturn: string;
begin
  listParam:= TStringList.Create;

  fTypereturn:= '';
  method:= methodNative;

  p:= Pos('native', method);
  method:= Copy(method, p+Length('native'), MaxInt);
  p1:= Pos('(', method);
  p2:= PosEx(')', method, p1 + 1);
  d:=(p2-p1);

  params:= Copy(method, p1+1, d-1); //long pasobj, long elapsedTimeMillis
                                    //long pasobj, int state, String phoneNumber
  method:= Copy(method, 1, p1-1);
  method:= Trim(method);            //void pOnChronometerTick

  fTypereturn:= Trim(SplitStr(method, ' '));

  method:= Trim(method);            //pOnChronometerTick

  signature:= '(env:PJNIEnv;this:JObject';
  if Length(params) > 3  then
  begin
    listParam.Delimiter:= ',';
    listParam.StrictDelimiter:= True;
    listParam.DelimitedText:= params;
    for i:= 0 to listParam.Count-1 do
    begin
      if Pos('pasobj', listParam.Strings[i]) > 0 then
         signature:= signature + ';'+ 'Sender:TObject'
      else
         signature:= signature + ';' + GetNativePascalTypeSignature(Trim(listParam.Strings[i]));
    end;
  end;

  //raw jni
  if fTypereturn = 'void' then
    Result:= 'procedure Java_Call_'+method+signature+');'
  else
  begin
    outType:= GetNativePascalFuncResultHack(fTypereturn) ;
    Result:= 'function Java_Call_'+method+signature+'):'+GetNativePascalTypeSignature(fTypereturn)+';';
  end;

  eventname:= method;  //raw jni

  listParam.Free;
end;

procedure GetNativeMethodInterfaceList(pascalMainUnit: string; jclassname: string; nativeMethod: TStringList;
                                       namingBypass: TStringList;
                                       out bridgeContentList: TStringList;
                                       out unitInterfaceList: TStringList;
                                       out unitImplementationList: TStringList);
var
  signature, outEventname, params, pasSignature, pasParams: string;
  listBody, listParam: TStringList;
  p1, p2, i, count, dx,  j, k: integer;
  aux, outPascalReturnType, smallEventName: string;

  LazAndControlsEventsHeader: TStringList;
  LazAndControlsEventsBody: TStringList;

  PasHeaderType: TStringList;
  PasHeaderProperty: TStringList;
  PasHeaderProcedure: TStringList;
  PasHeaderPublished: TStringList;
  PasBody: TStringList;
  has_pasobj_param: boolean;
begin

  listParam:= TStringList.Create;
  listParam.Delimiter:= ';';
  listParam.StrictDelimiter:= True;
  listBody:= TStringList.Create;

  LazAndControlsEventsHeader:= TStringList.Create;
  LazAndControlsEventsBody:= TStringList.Create;

  PasHeaderType:= TStringList.Create;
  PasHeaderProperty:= TStringList.Create;
  PasHeaderProcedure:= TStringList.Create;
  PasHeaderPublished:= TStringList.Create;
  PasBody:= TStringList.Create;


  for k:= 0 to nativeMethod.Count-1 do
  begin
    outPascalReturnType:= ''; //jString, jBoolean, integer, single
    outEventname:='';

    listParam.Clear;
    listBody.Clear;

    signature:= GetNativePascalSignature(nativeMethod.Strings[k], outEventname, outPascalReturnType);

    if Pos('Sender', signature) > 0 then
         has_pasobj_param:= True;

    LazAndControlsEventsHeader.Add(signature);

    p1:= Pos('(', signature);
    p2:= Pos(')', signature);
    listParam.DelimitedText:= Copy(signature, p1+1,p2-(p1+1)); // env:PJNIEnv;this:JObject;Obj:TObject;state:integer;phoneNumber:jString

    smallEventName:= StringReplace(outEventname,namingBypass.Strings[k],'',[rfIgnoreCase, rfReplaceAll]);

    has_pasobj_param:= False;
    pasSignature:='';

    params:= '';
    pasParams:= '';
    dx:=2;
    {ex. dx:
    env:PJNIEnv
    this:JObject

    x:integer
    y:integer
    }

    if has_pasobj_param  then
    begin
       pasSignature:='Sender:TObject';
       params:= 'Sender';
       pasParams:= 'Sender';
       dx:= 3;
    end;

    LazAndControlsEventsBody.Add(signature);

    {ex. dx = 3:
    env:PJNIEnv
    this:JObject
    Sender:TObject

    x:integer
    y:integer
    }

    count:= listParam.Count;
    if count > dx then
    begin
      for i:= dx to count-1 do
      begin
         //Sender:TObject; x:integer; y:integer    or
         //x:integer; y:string
         aux:= listParam.Strings[i];
         if pasSignature <> '' then
             pasSignature:= pasSignature + ';'+ TryNativeConvertSignature(aux)
         else
             pasSignature:= TryNativeConvertSignature(aux);

         if pasParams <> '' then
            pasParams:=pasParams + ',' +GetNativeParamName(aux)
         else
            pasParams:= GetNativeParamName(aux);

         if params <> '' then
           params:= params + ','+ TryNativeConvertParam(aux)
         else
           params:= TryNativeConvertParam(aux);

      end;
    end;

    if outPascalReturnType <> '' then
    begin
      LazAndControlsEventsBody.Add('var');
      LazAndControlsEventsBody.Add('  outReturn: '+outPascalReturnType+';');
    end;

    LazAndControlsEventsBody.Add('begin');

    //raw jni
    //LazAndControlsEventsBody.Add('  //'+Self.EditMainUnit.Text+'.EnvJni.Jni.jEnv:= env;');
    //LazAndControlsEventsBody.Add('  //'+Self.EditMainUnit.Text+'.EnvJni.Jni.jThis:= this;');

    //Raw jni
    if outPascalReturnType = '' then
      LazAndControlsEventsBody.Add('   '+pascalMainUnit+'.'+outEventname+'('+params+');')
    else
      LazAndControlsEventsBody.Add('    outReturn:= '+pascalMainUnit+'.'+outEventname+'('+params+');');


    if outPascalReturnType <> '' then
    begin

      if outPascalReturnType = 'string' then
        LazAndControlsEventsBody.Add('  Result:=GetJString(env,outReturn);')
      else if outPascalReturnType = 'boolean' then
         LazAndControlsEventsBody.Add('  Result:=JBool(outReturn);')

      else if outPascalReturnType = 'TDynArrayOfJByte' then
        LazAndControlsEventsBody.Add('  Result:=GetJObjectOfDynArrayOfJByte(env,outReturn);')

      else if outPascalReturnType = 'TDynArrayOfInteger' then
        LazAndControlsEventsBody.Add('  Result:=GetJObjectOfDynArrayOfInteger(env,outReturn);')

      else if outPascalReturnType = 'TDynArrayOfSingle' then
        LazAndControlsEventsBody.Add('  Result:=GetJObjectOfDynArrayOfSingle(env,outReturn);')

      else if outPascalReturnType = 'TDynArrayOfDouble' then
        LazAndControlsEventsBody.Add('  Result:=GetJObjectOfDynArrayOfDouble(env,outReturn);')

      else if outPascalReturnType = 'TDynArrayOfString' then
        LazAndControlsEventsBody.Add('  Result:=GetJObjectOfDynArrayOfString(env,outReturn);')

      else
        LazAndControlsEventsBody.Add('  Result:=outReturn;');
    end;

    LazAndControlsEventsBody.Add('end;');

    //raw jni
      if outPascalReturnType = '' then
         PasHeaderType.Add('procedure '+outEventname+'('+pasSignature+');')
      else                                                                        //TryNativeReConvertOutSignature
         PasHeaderType.Add('function '+outEventname+'('+pasSignature+'): '+ outPascalReturnType+';');

  end;//for

  bridgeContentList.Clear;

  bridgeContentList.Add(' ');

  //raw init
  //bridgeContentList.Add('//------------------- java_call_bridge_'+jclassname+'.pas  ----------------------');

  bridgeContentList.Add('unit java_call_bridge_'+jclassname+';');
  bridgeContentList.Add(' ');
  bridgeContentList.Add('{$mode delphi} ');
  bridgeContentList.Add(' ');
  bridgeContentList.Add('interface');
  bridgeContentList.Add(' ');
  bridgeContentList.Add('uses');
  bridgeContentList.Add('  jni, jnihelper;');
  bridgeContentList.Add(' ');
  for j:= 0 to  (LazAndControlsEventsHeader.Count-1) do
  begin
     bridgeContentList.Add(LazAndControlsEventsHeader.Strings[j]);
  end;

  bridgeContentList.Add(' ');
  bridgeContentList.Add('implementation');
  bridgeContentList.Add(' ');
  bridgeContentList.Add('uses');
  bridgeContentList.Add('  '+pascalMainUnit+';');
  bridgeContentList.Add(' ');
  for j:= 0 to  (LazAndControlsEventsBody.Count-1) do
  begin
     bridgeContentList.Add(LazAndControlsEventsBody.Strings[j]);
  end;
  bridgeContentList.Add(' ');
  bridgeContentList.Add('end. ');
  bridgeContentList.Add(' ');

  //*************************

  unitInterfaceList.Clear;
  //unitContentList.Add('//--------------------'+pascalMainUnit+'.pas ------------------------');
  //unitInterfaceList.Add('//' + pascalMainUnit+'.pas ');
  //unitInterfaceList.Add(' ');
  //unitInterfaceList.Add('//interface');
  //unitInterfaceList.Add(' ');
  //unitInterfaceList.Add('//type');
  //unitInterfaceList.Add('//TEnvJni=record');
  //unitInterfaceList.Add('//  jEnv: PJNIEnv;');  //a pointer reference to the JNI environment,
  //unitInterfaceList.Add('//  jThis: jObject;');  //a reference to the object making this call (or class if static-> lamwrawlib1.java).
  //unitInterfaceList.Add('//end;');
  //unitInterfaceList.Add(' ');
  //unitInterfaceList.Add('//var');
  //unitInterfaceList.Add('   //EnvJni: TEnvJni');

  unitInterfaceList.Add(' ');
  for j:= 0 to (PasHeaderType.Count-1) do
  begin
     unitInterfaceList.Add(PasHeaderType.Strings[j]);
  end;
  //unitInterfaceList.Add(' ');

  //raw jni
  //unitImplementationList.Add(' ');
  //unitImplementationList.Add('//implementation');
  //unitImplementationList.Add(' ');
  unitImplementationList.Add(' ');
  for j:= 0 to (PasHeaderType.Count-1) do
  begin
     unitImplementationList.Add(PasHeaderType.Strings[j]);
     unitImplementationList.Add('begin');
     unitImplementationList.Add('   //');
     unitImplementationList.Add('end;');
     unitImplementationList.Add(' ');
  end;
  //unitImplementationList.Add(' ');
  //unitImplementationList.Add('//end.');

  LazAndControlsEventsHeader.Free;
  LazAndControlsEventsBody.Free;

  PasHeaderType.Free;
  PasHeaderProperty.Free;
  PasHeaderProcedure.Free;
  PasHeaderPublished.Free;
  PasBody.Free;

  listParam.Free;
  listBody.Free;

end;

function GetJavaClassName(selList: TStringList): string;
var
  clsLine: string;
  foundClass: boolean;
  i, index: integer;
begin
    if selList.Text = '' then Exit;
    foundClass:= False;
    i:= 0;
    while (not foundClass) and (i < selList.Count) do
    begin
       clsLine:= selList.Strings[i];
       if Pos('class ', clsLine) > 0 then foundClass:= True;
       Inc(i);
    end;
    if foundClass then
    begin
      clsLine:= Trim(clsLine); //cleanup...
      if Pos('public ', clsLine) > 0 then   //public class jMyComponent
      begin
         SplitStr(clsLine, ' ');  //remove "public" word...
         clsLine:= Trim(clsLine); //cleanup...
      end;
      SplitStr(clsLine, ' ');  //remove "class" word...
      clsLine:= Trim(clsLine); //cleanup...

      if Pos(' ', clsLine) > 0  then index:= Pos(' ', clsLine)
      else if Pos('{', clsLine) > 0 then index:= Pos('{', clsLine)
      else if Pos(#10, clsLine) > 0 then index:= Pos(#10, clsLine);

      Result:= Trim(Copy(clsLine,1,index-1));  //get class name
   end;
end;

procedure GetNativeMethodList(selList: TStringList; nativeEventMethodList: TStringList; namingBypassList: TStringList);
var
  i: integer;
  aux, nativeMethod: string;
begin
    if selList.Text = '' then Exit;
    i:= 0;
    while i < selList.Count do
    begin
       if Pos(' native ', selList.Strings[i]) > 0 then
       begin
          aux:= selList.Strings[i];
          nativeMethod:= SplitStr(aux, '//');
          nativeEventMethodList.Add(nativeMethod);
          aux:= Trim(aux);
          if aux <> '' then
            namingBypassList.Add(aux)
          else
            namingBypassList.Add('//');
       end;
       Inc(i);
    end
end;


procedure ProduceRawJniInterface(pascalMainUnit: string; jclasspath: string;
                                 out bridgeContentList: TStringList;
                                 out unitInterfaceList: TStringList;
                                 out unitImplementationList: TStringList);
var
  jclsName: string;
  auxList: TStringList;
  nativeEventMethodList, namingBypassList: TStringList;
begin

     auxList:= TStringList.Create;
     auxList.LoadFromFile(jclasspath);

     jclsName:= Trim(GetJavaClassName(auxList));
     nativeEventMethodList:= TStringList.Create;
     namingBypassList:= TStringList.Create;

     //nativeEventMethod:= GetNativeMethod(auxList, namingBypass);
     GetNativeMethodList(auxList, nativeEventMethodList, namingBypassList);

     //GetNativeMethodInterface(clsName,nativeEventMethod,namingBypass, SynMemo2.Lines);

     if nativeEventMethodList.Count > 0 then
             GetNativeMethodInterfaceList(pascalMainUnit, jclsName,
                                       nativeEventMethodList,
                                       namingBypassList,
                                       bridgeContentList,
                                       unitInterfaceList,
                                       unitImplementationList);

     nativeEventMethodList.Free;
     namingBypassList.Free;
     auxList.Free;
end;

end.
