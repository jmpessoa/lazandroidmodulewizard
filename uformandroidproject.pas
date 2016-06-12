unit uFormAndroidProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterJava, SynHighlighterPas,
   Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls, ComCtrls,
   Menus, Clipbrd, ActnList;

type

  TSyntaxMode = (smDelphi, smObjFpc);

  { TFormAndroidProject }

  TFormAndroidProject = class(TForm)
    acOk: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StatusBar1: TStatusBar;
    SynFreePascalSyn1: TSynFreePascalSyn;
    SynJavaSyn1: TSynJavaSyn;
    SynJavaSyn2: TSynJavaSyn;
    SynMemo1: TSynMemo;
    SynMemo2: TSynMemo;
    SynMemo3: TSynMemo;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);

  private
    { private declarations }
    FJNIDecoratedMethodName: string;
    FJavaClassName: string;
    FPascalJNIInterfaceCode: string;
    FPathToJavaClass: string;
    FImportsList: TStringLIst;
    FModuleType: integer;
    FSyntaxMode: TSyntaxMode;
    FPathToClassName: string;

    FPathToJavaTemplates: string;

    FPathToWizardCode: string;

    FAndroidProjectName: string;
    FMainActivity: string;
    FListJNIBridge: TStringList;
    FMinApi: string;
    FTargetApi: string;

    Memo2List: TStringList;

    FHackJNIMethod: boolean;

    FProjectModel: string;

    FFullPackageName: string;
    FFullJavaSrcPath: string;
    FSmallProjName: string;


    procedure DoJavaParse;

    function GetPascalCode(funcName, funcParam, funcResult: string): string;
    function GetJParamHack(paramType: string): string;

    function GetFuncParam(funcParam: string): string;
    function GetParam(param: string): string;
    function GetParamSignature(param: string): string;
    function GetFuncResult(funcResult: string): string;

    function GetArrayTypeByFuncResultHack(funcResult: string): string;

    function GetPascalJType(jType: string): string;

    function GetJSignature(params, res: string): string;
    function GetJTypeSignature(jType: string): string;
    function GetResultSignature(funcResult: string): string;

  public
    { public declarations }
    property HackJNIMethod: boolean read FHackJNIMethod write FHackJNIMethod;
    property ProjectModel: string read FProjectModel write FProjectModel;
    property PathToClassName: string read FPathToClassName write FPathToClassName;
    property ModuleType: integer read FModuleType write FModuleType;
    property SyntaxMode: TSyntaxMode read FSyntaxMode write FSyntaxMode;
    property JavaClassName: string read FJavaClassName write FJavaClassName;
    property PascalJNIInterfaceCode: string read FPascalJNIInterfaceCode write FPascalJNIInterfaceCode;
    property PathToJavaClass: string read FPathToJavaClass  write FPathToJavaClass;
    property JNIDecoratedMethodName: string read FJNIDecoratedMethodName write FJNIDecoratedMethodName;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;
    property MainActivity: string read FMainActivity write FMainActivity;
    property MinApi: string  read FMinApi write FMinApi;
    property TargetApi: string  read FTargetApi write FTargetApi;
    property FullPackageName: string read FFullPackageName write FFullPackageName;
    property FullJavaSrcPath: string read FFullJavaSrcPath write FFullJavaSrcPath;
    property SmallProjName:  string read FSmallProjName write FSmallProjName;

  end;

var
  FormAndroidProject: TFormAndroidProject;

function TrimChar(query: string; delimiter: char): string;
function SplitStr(var theString: string; delimiter: string): string;
function LastPos(delimiter: string; str: string): integer;
function DeleteLineBreaks(const S: string): string;

function UpperCaseFirst(str: string): string;
function ReplaceCharFirst(str: string; newChar: char): string;

implementation

{$R *.lfm}

{ TFormAndroidProject }

function TFormAndroidProject.GetArrayTypeByFuncResultHack(funcResult: string): string;
begin
     Result:='.*.'+funcResult+'.*.';
          if Pos('int[', funcResult) > 0 then Result := 'Int'
     else if Pos('double[', funcResult) > 0 then Result := 'Double'
     else if Pos('float[', funcResult) > 0 then Result := 'Float'
     else if Pos('char[', funcResult) > 0 then Result := 'Char'
     else if Pos('short[', funcResult) > 0 then Result := 'Short'
     else if Pos('boolean[', funcResult) > 0 then Result := 'Boolean'
     else if Pos('byte[', funcResult) > 0 then Result := 'Byte'
     else if Pos('long[', funcResult) > 0 then Result := 'Long'
     else if Pos('String[', funcResult) > 0 then Result := 'String';
end;

function TFormAndroidProject.GetPascalJType(jType: string): string;
begin
  Result:= 'JObject';
  if Pos('String', jType) > 0 then
  begin
     Result:= 'JString';
     if Pos('[', jType) > 0 then Result := 'JStringArray';  //20-may-2015
  end else if Pos('int', jType) > 0  then
  begin
     Result := 'JInt';
     if Pos('[', jType) > 0 then Result := 'JIntArray';
  end
  else if Pos('double',jType) > 0 then
  begin
     Result := 'JDouble';
     if Pos('[', jType) > 0 then Result := 'JDoubleArray';
  end
  else if Pos('float', jType) > 0 then
  begin
     Result := 'JFloat';
     if Pos('[', jType) > 0 then Result := 'JFloatArray';
  end
  else if Pos('char', jType) > 0 then
  begin
     Result := 'JChar';
     if Pos('[', jType) > 0 then Result := 'JCharArray';
  end
  else if Pos('short', jType) > 0 then
  begin
     Result := 'JShort';
     if Pos('[', jType) > 0 then Result := 'JShortArray';
  end
  else if Pos('boolean', jType) > 0 then
  begin
     Result := 'JBoolean';
     if Pos('[', jType) > 0 then Result := 'JBooleanArray';
  end
  else if Pos('byte', jType) > 0 then
  begin
     Result := 'JByte';
     if Pos('[', jType) > 0 then Result := 'JByteArray';
  end
  else if Pos('long', jType) > 0 then
  begin
     Result := 'JLong';
     if Pos('[', jType) > 0 then Result := 'JLongArray';
  end;
end;

function TFormAndroidProject.GetFuncResult(funcResult: string): string;
begin
  if not FHackJNIMethod then
    Result:=GetPascalJType(funcResult)+'; cdecl;'
  else
    Result:=GetPascalJType(funcResult);
end;


{
     jboolean=byte;        // unsigned 8 bits
     jbyte=shortint;       // signed 8 bits
     jchar=word;           // unsigned 16 bits
     jshort=smallint;      // signed 16 bits
     jint=longint;         // signed 32 bits
     jlong=int64;          // signed 64 bits
     jfloat=single;        // 32-bit IEEE 754
     jdouble=double;       // 64-bit IEEE 754
}


function TFormAndroidProject.GetResultSignature(funcResult: string): string;
begin
  Result:=GetJTypeSignature(funcResult);
end;

function TFormAndroidProject.GetParam(param: string): string;
var
  typeValue: string;
  nameValue: string;
begin
  nameValue:= TrimChar(param,'~');
  typeValue:= SplitStr(nameValue,'~');
  Result:= TrimChar(nameValue,'~');
  Result:= Result +': ' +GetPascalJType(typeValue);
end;

function TFormAndroidProject.GetJTypeSignature(jType: string): string;
var
  i: integer;
  auxList: TStringList;
  auxStr: string;
begin
  Result:= '';
  if jType <> '' then
  begin
         if Pos('.', jType) > 0 then
         begin
            auxStr:= jType;
            Result:= 'L'+StringReplace(auxStr,'.','/',[rfReplaceAll])+';';
         end
    else if Pos('String', jType) > 0 then
    begin
        Result:= 'Ljava/lang/String;';
        if Pos('String[', jType) > 0 then Result:= '[Ljava/lang/String;';
    end
    else if Pos('int', jType) > 0  then  //The search is case-sensitive!
    begin
       Result := 'I';
       if Pos('[', jType) > 0 then Result := '[I';
    end
    else if Pos('double',jType) > 0 then
    begin
       Result := 'D';
       if Pos('[', jType) > 0 then Result := '[D';
    end
    else if Pos('float', jType) > 0 then
    begin
       Result := 'F';
       if Pos('[', jType) > 0 then Result := '[F';
    end
    else if Pos('char', jType) > 0 then
    begin
       Result := 'C';
       if Pos('[', jType) > 0 then Result := '[C';
    end
    else if Pos('short', jType) > 0 then
    begin
       Result := 'S';
       if Pos('[', jType) > 0 then Result := '[S';
    end
    else if Pos('boolean', jType) > 0 then
    begin
       Result := 'Z';
       if Pos('[', jType) > 0 then Result := '[Z';
    end
    else if Pos('byte', jType) > 0 then
    begin
       Result := 'B';  //<--- fix here 12/12/2013! thanks to Roberto Federiconi
       if Pos('[', jType) > 0 then Result := '[B';
    end
    else if Pos('long', jType) > 0 then
    begin
       Result := 'J';
       if Pos('[', jType) > 0 then Result := '[J';
    end
    else if Pos('void', jType) > 0 then Result := 'V'
    else if Pos('public', jType) > 0 then Result := 'Ljava/lang/Object;';  //constructor!

    if Result = '' then
    begin
        for i:= 0 to FImportsList.Count-1 do
        begin
          if Pos(jType+';',FImportsList.Strings[i]) > 0 then   //fix here 09-september-2013
          begin                                                //again fix here 21-sept-2013
             auxList:= TStringList.Create;
             auxList.StrictDelimiter:=True;
             auxList.Delimiter:='/';
             auxList.DelimitedText:= FImportsList.Strings[i];
             if CompareText(jType+';', auxList.Strings[auxList.Count-1]) = 0 then
             begin
                Result:= FImportsList.Strings[i];
             end;
             auxList.Free;
          end;
        end;
    end;

    if Result = '' then Result:= 'UNKNOWN';
    if Pos('Controls', jType) > 0 then Result:= '';
  end;
end;

function TFormAndroidProject.GetParamSignature(param: string): string;
var
  typeValue: string;
  nameValue: string;
begin
  nameValue:= TrimChar(param,'~');
  typeValue:= SplitStr(nameValue,'~');
  Result:= TrimChar(nameValue,'~');
  Result:= GetJTypeSignature(typeValue);
end;

function TFormAndroidProject.GetFuncParam(funcParam: string): string;
var
  paramList: TStringList;
  k, count: integer;
  auxParam: string;
begin
  auxParam:= StringReplace(Trim(funcParam),' ','~',[rfReplaceAll]);
  paramList:= TStringList.Create;
  if Pos(',', auxParam) > 0 then
  begin
    paramList.StrictDelimiter:= True;
    paramList.Delimiter:=',';
    paramList.CommaText:= auxParam;
    Result:=' ';
    count:= paramList.Count;
    for k:= 0 to count-1 do
    begin
      Result:= Result+' '+GetParam(TrimChar(paramList.Strings[k],'~')) +';';
    end;
  end
  else
  begin
    Result:= GetParam(TrimChar(auxParam,'~'));
  end;

  if not FHackJNIMethod then
    Result:= '(PEnv: PJNIEnv; this: JObject; '+TrimChar(Result,';')+')'
  else
    Result:= '(env: PJNIEnv; '+FJavaClassName+': JObject; '+TrimChar(Result,';')+')';

  paramList.Free;
end;

function TFormAndroidProject.GetPascalCode(funcName, funcParam, funcResult: string): string;
var
  strList: TStringList;
  strAux, signature, auxFuncParam: string;
begin
  strList:= TStringList.Create;
  auxFuncParam:= Trim(funcParam);

  if auxFuncParam <> '' then
  begin
     auxFuncParam:= GetFuncParam(auxFuncParam);
  end
  else
  begin
     auxFuncParam:= '(PEnv: PJNIEnv; this: JObject)';
  end;

  if funcResult = 'void' then
  begin
    signature:= 'procedure '+funcName+auxFuncParam+'; cdecl;';
    strList.Add(signature);
    strList.Add('begin');
    if FModuleType = 0 then  //GUI controls
    begin
        strAux:= FListJNIBridge.Values[funcName];
        strList.Add('  '+strAux);
    end
    else
    begin
       strList.Add('  {your code....}');
    end;
    strList.Add('end;');
  end
  else
  begin
    signature:= 'function '+funcName+ auxFuncParam+': '+ GetFuncResult(funcResult);
    strList.Add(signature);
    strList.Add('begin');
    if FModuleType = 0 then  //GUI controls
    begin
        strAux:= FListJNIBridge.Values[funcName];
        strList.Add('  Result:='+strAux);
    end
    else
    begin
      strList.Add('  {your code....}');
      strList.Add('  {Result:=;}');
    end;
    strList.Add('end;');
  end;
  Result:= strList.Text;
  strList.Free;
end;

{
   (z:jboolean);
   (b:jbyte);
   (c:jchar);
   (s:jshort);
   (i:jint);
   (j:jlong);
   (f:jfloat);
   (d:jdouble);
   (l:jobject);
}

function TFormAndroidProject.GetJParamHack(paramType: string): string;
begin
   if (Pos(';', paramType) > 0) or (Pos('[', paramType) > 0) then Result:='l'
   else Result:= LowerCase(paramType);
end;


function TFormAndroidProject.GetJSignature(params, res: string): string;
var
  paramList: TStringList;
  k, count: integer;
  auxParam: string;
begin
  Result:='(';
  auxParam:= StringReplace(Trim(params),' ','~',[rfReplaceAll]);
  paramList:= TStringList.Create;
  if Pos(',', auxParam) > 0 then
  begin
    paramList.StrictDelimiter:= True;
    paramList.Delimiter:=',';
    paramList.CommaText:= auxParam;
    count:= paramList.Count;
    for k:= 0 to count-1 do
    begin
      Result:= Result+ GetParamSignature(TrimChar(paramList.Strings[k],'~'));
    end;
  end
  else
  begin
    Result:= Result+GetParamSignature(TrimChar(auxParam,'~'));
  end;
  Result:= Result+ ')'+GetParamSignature(res);
  paramList.Free;
end;

procedure TFormAndroidProject.DoJavaParse;
var
  pNative, pPublic, pComment1, pComment2, pSemicolon: integer;
  s1, s2: string;
  i, p1, p2: integer;
  strList, Memo3List, Memo4List, Memo5List, Memo6List: TStringList;
  auxStr, auxName, auxParam, strPascalCode, auxSignature, auxPathJNI,
  strNativeMethodsHeader, strNativeMethodsBody, methSignature, methName: string;
  strOnLoadList: TStringList;
  clipList: TStringList;
begin
    if SynMemo1.Lines.Count < 3 then Exit;

    Memo2List.Clear;   //global
    SynMemo2.Clear;    //global

    Memo3List:= TStringList.Create;
    Memo4List:= TStringList.Create;
    Memo5List:= TStringList.Create;
    Memo6List:= TStringList.Create;
    strOnLoadList:= TStringList.Create;

    strList:= TStringList.Create;

    if not FHackJNIMethod then
    begin
      i:= 0;
      while i < SynMemo1.Lines.Count do
      begin
         s1:= SynMemo1.Lines.Strings[i];
         pNative:= Pos(' native ', s1);
         if pNative > 0  then
         begin
            s2:= s1;
            pSemicolon:= Pos(';', s1);
            while pSemicolon = 0 do
            begin
              inc(i);
              s1:= s1 + SynMemo1.Lines.Strings[i];
              s2:=DeleteLineBreaks(s1);
              pSemicolon:= Pos(';', s2);
            end;
            strList.Add(s2)
         end;
         inc(i);
      end;
    end
    else //FHackJNIMethodc=True
    begin
       clipList:= TStringList.Create;
       clipList.Text:= SynMemo1.SelText;
       i:= 0;
       while i < clipList.Count do
       begin
          s1:= clipList.Strings[i];
          pNative:= Pos('public ', s1);
          if pNative > 0  then
          begin
             s2:= s1;
             pSemicolon:= Pos(')', s1);
             while pSemicolon = 0 do
             begin
               inc(i);
               s1:= s1 + clipList.Strings[i];
               s2:=DeleteLineBreaks(s1);
               pSemicolon:= Pos(')', s2);
             end;
             strList.Add(s2);
          end;
          inc(i);
       end;
       clipList.Free;
    end;

    for i:=0 to strList.Count-1 do   //check if the code was "//" [commented] or  "/*.*/" [invisible]
    begin
       s1:= strList.Strings[i];
       if s1 <> '' then
       begin
         pPublic:= Pos('public ', s1);
         pComment1:= Pos('//', s1);
         if pComment1 = 0 then  pComment1:= 10000;  //not found...
         pComment2:= Pos('/*.*/', s1);              //just a mask for parse invisibility...
         if pComment2 = 0 then  pComment2:= 10000;  //not found...
         if (pPublic < pComment1) and (pPublic < pComment2)  then Memo2List.Add(s1);
       end;
    end;
    strList.Clear;

    if not FHackJNIMethod then
    begin
     Memo6List.Add('exports');
     Memo6List.Add('  JNI_OnLoad name ''JNI_OnLoad'',');
     Memo6List.Add('  JNI_OnUnload name ''JNI_OnUnload'',');

     strNativeMethodsHeader:= 'const NativeMethods:array[0..'+
                              IntToStr(Memo2List.Count-1)+'] of JNINativeMethod = (';
    end;

    strNativeMethodsBody:= '';

    for i:=0 to Memo2List.Count - 1 do
    begin
      auxStr:= Trim(Memo2List.Strings[i]);
      p1:= Pos('(', auxStr);
      p2:= Pos(')', auxStr);
      auxName:=  Copy(auxStr, 0, p1-1);
      auxParam:= Copy(auxStr, p1+1, (p2-p1)-1);

      strList.DelimitedText:= auxName;
      Memo3List.Add(Trim(strList.Strings[strList.Count-1]));
      Memo3List.Add(Trim(strList.Strings[strList.Count-2]));

      Memo4List.Add(auxParam);

      auxPathJNI:= FJNIDecoratedMethodName;
      SplitStr(auxPathJNI,'_');

      methName:= Trim(strList.Strings[strList.Count-1]);
      methSignature:= GetJSignature(Trim(auxParam), Trim(strList.Strings[strList.Count-2]));

      auxSignature:= '{ Class:     '+ auxPathJNI + LineEnding +
                       '  Method:    '+ methName + LineEnding +
                       '  Signature: '+ methSignature+' }'+ LineEnding;

      if not FHackJNIMethod then
      begin
        //ShowMessage(methSignature);
        strNativeMethodsBody:= strNativeMethodsBody +
         '   (name:'''+ methName + ''';'+LineEnding +
         '    signature:'''+ methSignature+''';'+ LineEnding +
         '    fnPtr:@'+ methName + ';)';

        if i < (Memo2List.Count - 1) then
          strNativeMethodsBody:= strNativeMethodsBody+','+LineEnding
        else
          strNativeMethodsBody:= strNativeMethodsBody+LineEnding;
      end;

      if not FHackJNIMethod then
        strPascalCode:= auxSignature+GetPascalCode(Trim(strList.Strings[strList.Count-1]) {funct},
                      Trim(auxParam),Trim(strList.Strings[strList.Count-2]){result});

      Memo5List.Add(strPascalCode);
      Memo6List.Add('  '+Trim(strList.Strings[strList.Count-1])+' name '''+
                       FJNIDecoratedMethodName+'_'+Trim(strList.Strings[strList.Count-1])+''',');
    end;

    if not FHackJNIMethod then
    begin
      strNativeMethodsHeader:= strNativeMethodsHeader + LineEnding +
                             strNativeMethodsBody+');'+ LineEnding;

      strOnLoadList.Add('function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar; methods: PJNINativeMethod; countMethods:integer):integer;');
      strOnLoadList.Add('var');
      strOnLoadList.Add('  curClass: jClass;');
      strOnLoadList.Add('begin');
      strOnLoadList.Add('  Result:= JNI_FALSE;');
      strOnLoadList.Add('  curClass:= (PEnv^).FindClass(PEnv, className);');
      strOnLoadList.Add('  if curClass <> nil then');
      strOnLoadList.Add('  begin');
      strOnLoadList.Add('    if (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods) > 0 then Result:= JNI_TRUE;');
      strOnLoadList.Add('  end;');
      strOnLoadList.Add('end;');
      strOnLoadList.Add(' ');
      PathToClassName:= StringReplace(auxPathJNI, '_', '/',[rfReplaceAll]);
      strOnLoadList.Add('function RegisterNativeMethods(PEnv: PJNIEnv; className: PChar): integer;');
      strOnLoadList.Add('begin');
      strOnLoadList.Add('  Result:= RegisterNativeMethodsArray(PEnv, className, @NativeMethods[0], Length(NativeMethods));');
      strOnLoadList.Add('end;');
      strOnLoadList.Add(' ');

      strOnLoadList.Add('function JNI_OnLoad(VM: PJavaVM; reserved: pointer): JInt; cdecl;');
      strOnLoadList.Add('var');
      strOnLoadList.Add('  PEnv: PPointer;');
      strOnLoadList.Add('  curEnv: PJNIEnv;');
      strOnLoadList.Add('begin');
      strOnLoadList.Add('  PEnv:= nil;');
      strOnLoadList.Add('  Result:= JNI_VERSION_1_6;');
      strOnLoadList.Add('  (VM^).GetEnv(VM, @PEnv, Result);');
      strOnLoadList.Add('  if PEnv <> nil then');
      strOnLoadList.Add('  begin');
      strOnLoadList.Add('     curEnv:= PJNIEnv(PEnv);');
      strOnLoadList.Add('     RegisterNativeMethods(curEnv, '''+PathToClassName+''');');

      if FModuleType = 1 then //NoGUI
      begin
        strOnLoadList.Add('     gNoGUIPDalvikVM:= VM;{PJavaVM}');
        strOnLoadList.Add('     gNoGUIjClassPath:= '''+PathToClassName+''';');
        strOnLoadList.Add('     gNoGUIjClass:= (curEnv^).FindClass(curEnv, '''+PathToClassName+''');');
        strOnLoadList.Add('     gNoGUIjClass:= (curEnv^).NewGlobalRef(curEnv, gNoGUIjClass);');
      end;

      strOnLoadList.Add('  end;');
      if FModuleType = 0 then
      begin
         strOnLoadList.Add('  gVM:= VM;{And_jni_Bridge}');
      end;
      strOnLoadList.Add('end;');

      strOnLoadList.Add(' ');
      strOnLoadList.Add('procedure JNI_OnUnload(VM: PJavaVM; reserved: pointer); cdecl;');
      strOnLoadList.Add('var');
      strOnLoadList.Add('  PEnv: PPointer;');
      strOnLoadList.Add('  curEnv: PJNIEnv;');
      strOnLoadList.Add('begin');
      strOnLoadList.Add('  PEnv:= nil;');
      strOnLoadList.Add('  (VM^).GetEnv(VM, @PEnv, JNI_VERSION_1_6);');
      strOnLoadList.Add('  if PEnv <> nil then');
      strOnLoadList.Add('  begin');
      strOnLoadList.Add('    curEnv:= PJNIEnv(PEnv);');

      if FModuleType = 1 then  //Not Android Bridges  Controls...
      begin
      //strOnLoadList.Add('    (curEnv^).UnregisterNatives(curEnv, gNoGUIjClass);');
      strOnLoadList.Add('    (curEnv^).DeleteGlobalRef(curEnv, gNoGUIjClass);');
      strOnLoadList.Add('    gNoGUIjClass:= nil;');
      strOnLoadList.Add('    gNoGUIPDalvikVM:= nil;');
      end;

      if FModuleType = 0 then
      begin
        strOnLoadList.Add('    (curEnv^).DeleteGlobalRef(curEnv, gjClass);');
        strOnLoadList.Add('    gjClass:= nil;');
        strOnLoadList.Add('    gVM:= nil;');
      end;

      strOnLoadList.Add('  end;');

      if FModuleType = 0 then
      begin
      strOnLoadList.Add('  gApp.Terminate;');
      strOnLoadList.Add('  FreeAndNil(gApp);');
      end
      else  //NoGUI -->> Not Android Bridges  Controls...
      begin
        strOnLoadList.Add('  gNoGUIApp.Terminate;');
        strOnLoadList.Add('  FreeAndNil(gNoGUIApp);');
      end;
      strOnLoadList.Add('end;');
    end;

    auxStr:= Memo6List.Strings[Memo6List.Count-1];
    Memo6List.Strings[Memo6List.Count-1]:= StringReplace(auxStr,',',';',[rfReplaceAll]);

    if not FHackJNIMethod then
       FPascalJNIInterfaceCode:= Memo5List.Text + strNativeMethodsHeader + LineEnding+
                                 strOnLoadList.Text + LineEnding+Memo6List.Text
    else
       FPascalJNIInterfaceCode:= Memo5List.Text + LineEnding;

    if not FHackJNIMethod then
       SynMemo2.Lines.Text:= FPascalJNIInterfaceCode;

    Memo3List.Free;
    Memo4List.Free;
    Memo5List.Free;
    Memo6List.Free;

    strList.Free;
    strOnLoadList.Free;
end;

procedure TFormAndroidProject.PageControl1Change(Sender: TObject);
begin
   if not FHackJNIMethod then
   begin
     if PageControl1.ActivePage = TabSheet2 then
     begin
       SynMemo2.ReadOnly:= False;
       SynMemo2.Lines.Clear;
       DoJavaParse;
       SynMemo2.Lines.Add(' ');
       FPascalJNIInterfaceCode:= SynMemo2.Lines.Text;
       SynMemo2.ReadOnly:= True;
     end;
   end
end;


procedure TFormAndroidProject.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
   if ModalResult = mrOk then
   begin

     if MessageDlg('"App.java" changed...', 'Save "App.java" ?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
     begin
       SynMemo3.Lines.SaveToFile(FFullJavaSrcPath+DirectorySeparator+'App.java');
     end;

     if MessageDlg('"'+FSmallProjName+'.java" changed...', 'Save "'+FSmallProjName+'.java" ?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
     begin
       SynMemo1.Lines.SaveToFile(FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java');
     end;

     if FPascalJNIInterfaceCode =  '' then
     begin
       PageControl1.ActivePage:= TabSheet2;
     end;

   end;
end;

procedure TFormAndroidProject.FormShow(Sender: TObject);
var
  strPack, pathPack, auxStr, pathPlusFileName: string;
  pathList: TStringList;
  auxList: TStringList;
  i,j,k: integer;

begin
   SynMemo1.Lines.Clear;
   SynMemo2.Lines.Clear;
   SynMemo3.Lines.Clear;

   PageControl1.ActivePage:= TabSheet1;

   Self.Caption:= 'Lamw: Lazarus Android Module Wizard "NoGUI" Project';

   StatusBar1.Panels.Items[0].Text:= FFullJavaSrcPath;

   if FModuleType = 1 then   //NoGUI
   begin

     FJavaClassName:= FSmallProjName;

     PageControl1.Pages[0].Visible:= True;
     PageControl1.Pages[1].Caption:= FSmallProjName+'.java';

     pathPlusFileName:= FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java';;
     SynMemo3.Lines.LoadFromFile(FFullJavaSrcPath+DirectorySeparator+'App.java');
     SynMemo1.Lines.LoadFromFile(FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java');

     SynMemo3.ReadOnly:= False;
     SynMemo1.ReadOnly:= False;
     if SynMemo1.Lines.Count < 3 then Exit;
   end;

   PageControl1.TabIndex:= 1;
   auxList:= TStringList.Create;
   auxList.LoadFromFile(pathPlusFileName);
   strPack:= Trim(auxList.Strings[0]);                 // ex: package com.template.appdummy;
   strPack:= TrimChar(strPack,';');
   SplitStr(strPack, ' ');
   strPack:= Trim(strPack);
   FFullPackageName:= strPack;
   auxList.Free;

   i:= LastPos(DirectorySeparator, FPathToJavaTemplates);
   FPathToWizardCode:= Copy(FPathToJavaTemplates, 1, i-1);
   FPathToJavaClass:= FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java';

   pathList:= TStringList.Create;
   pathList.StrictDelimiter:= True;
   pathList.Delimiter:= DirectorySeparator;

   pathList.DelimitedText:= FPathToJavaClass;
   for i:= 0 to pathList.Count-2 do
   begin
      if Pos('src',pathList.Strings[i]) > 0  then k:= i;
   end;

   pathPack:='';
   for j:= k+1 to pathList.Count-2 do
   begin
     pathPack:= pathPack + '_'+ pathList.Strings[j];
   end;

   FJNIDecoratedMethodName:= 'Java'+pathPack+'_'+ FJavaClassName;

   FImportsList.Clear;
   for i:= 0 to SynMemo1.Lines.Count-1 do
   begin
      auxStr:= SynMemo1.Lines.Strings[i];
      if auxStr <> '' then   //minor fix... 08-september-2013
      begin
        if Pos('import ', auxStr) > 0 then
        begin
           SplitStr(auxStr,' ');
           auxStr:= StringReplace(auxStr,'.','/',[rfReplaceAll]);
           FImportsList.Add('L'+trim(auxStr));
        end;
      end;
   end;
   pathList.Free;

end;


procedure TFormAndroidProject.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    FImportsList.Free;
    Memo2List.Free;
    FListJNIBridge.Free;
end;

procedure TFormAndroidProject.FormCreate(Sender: TObject);
begin
  FHackJNIMethod:= False;
  FSyntaxMode:= smDelphi;
  FImportsList:= TStringLIst.Create;
  Memo2List:= TStringList.Create;
  FListJNIBridge:= TStringList.Create;
end;

procedure TFormAndroidProject.MenuItem18Click(Sender: TObject);
var
  txtCaption: string;
begin
   txtCaption:= (Sender as TMenuItem).Caption;
   if Pos('About', txtCaption) > 0 then
   begin
      //02-december-2013 Add support to simonsayz's controls: http://blog.naver.com/simonsayz
      ShowMessage('Lamw: Lazarus Android Module Wizard [ver. 0.6 - rev. 36 - 03 August 2015]');
   end;
end;

procedure TFormAndroidProject.MenuItem20Click(Sender: TObject);
begin
   Self.ModalResult:= mrCancel;
end;

   {...........generics.............}
function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;

function LastPos(delimiter: string; str: string): integer;
var
  strTemp: string;
  index: integer;
begin
  strTemp:= str;
  index:= Pos(delimiter, strTemp);
  Result:= index;
  while index > 0 do
  begin
     SplitStr(strTemp, delimiter);
     index:= Pos(delimiter, strTemp);
     Result:= Result +  index;
  end;
end;

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
       Result := theString;
       theString := '';
    end;
  end;
end;

function DeleteLineBreaks(const S: string): string;
var
   Source, SourceEnd: PChar;
begin
   Source := Pointer(S) ;
   SourceEnd := Source + Length(S) ;
   while Source < SourceEnd do
   begin
      case Source^ of
        #10: Source^ := #32;
        #13: Source^ := #32;
      end;
      Inc(Source) ;
   end;
   Result := S;
end;

function UpperCaseFirst(str: string): string;
var
  retStr, upStr: string;
begin
  if str <> '' then
  begin
    retStr:= Trim(str);
    upStr:= UpperCase(retStr);
    retStr[1]:= upStr[1];
    Result:= retStr;
  end;
end;

function ReplaceCharFirst(str: string; newChar: char): string;
var
  retStr: string;
begin
  retStr:= Trim(str);
  if retStr <> '' then
  begin
    retStr[1]:= newChar;
    Result:= retStr;
  end;
end;

end.

