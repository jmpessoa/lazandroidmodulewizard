unit uFormAndroidProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterJava, SynHighlighterPas,
  SynEditTypes, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls, ComCtrls,
  ShellCtrls, Menus, Clipbrd, types, Process, uRegisterForm;

type

  TSyntaxMode = (smDelphi, smObjFpc);

  { TFormAndroidProject }

  TFormAndroidProject = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Image1: TImage;
    ImageList1: TImageList;
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
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel7: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu4: TPopupMenu;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    StatusBar1: TStatusBar;
    SynFreePascalSyn1: TSynFreePascalSyn;
    SynJavaSyn1: TSynJavaSyn;
    SynMemo1: TSynMemo;
    SynMemo2: TSynMemo;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure PopupMenu1Close(Sender: TObject);
    procedure PopupMenu2Close(Sender: TObject);

    procedure PopupMenu4Close(Sender: TObject);
    procedure PopupMenu4Popup(Sender: TObject);
    procedure ShellListView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ShellTreeView1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ShellListView1DblClick(Sender: TObject);
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
    //FHackJNIFromClipboard: boolean;

    FProjectModel: string;
    FSaveProjectModel: string;
    FSaveJavaClassName: string;

    FHackListJNIHeader: TStringList;

    FHackListPascalClass: TStringList;
    FHackListPascalClassImpl: TStringList;
    FHackCreateParam: string;

    FHackCreateProperties: string;

    procedure DoJavaParse;

    function GetPascalCode(funcName, funcParam, funcResult: string): string;
    function GetPascalCodeHack(funcName, funcParam, funcResult, jniSignature: string): string;

    function GetParamNameHack(funcParam: string; var jParamSig: string): string;
    function GetJParamHack(paramType: string): string;
    function GetArrayTypeNameHack(paramType: string): string;

    function GetFuncParam(funcParam: string): string;
    function GetParam(param: string): string;
    function GetParamSignature(param: string): string;
    function GetFuncResult(funcResult: string): string;

    function GetArrayTypeByFuncResultHack(funcResult: string): string;

    function GetMethodNameHack(jType: string): string;
    function GetPascalFuncResultHack(jType: string): string;
    function GetPascalJType(jType: string): string;

    function GetJSignature(params, res: string): string;
    function GetJTypeSignature(jType: string): string;
    function GetResultSignature(funcResult: string): string;
    procedure TryInsertJavaCreate(txt: string);
    function GetHackListPascalClassInterf: string;

    procedure InsertJControlCodeTemplate(txt: string);
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

function TFormAndroidProject.GetMethodNameHack(jType: string): string;
begin
  Result:= 'Object';
  if Pos('String', jType) > 0 then
  begin
     Result:= 'Object';
  end else if Pos('int', jType) > 0  then
  begin
     Result := 'Int';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('double',jType) > 0 then
  begin
     Result := 'Double';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('float', jType) > 0 then
  begin
     Result := 'Float';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('char', jType) > 0 then
  begin
     Result := 'Char';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('short', jType) > 0 then
  begin
     Result := 'Short';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('boolean', jType) > 0 then
  begin
     Result := 'Boolean';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('byte', jType) > 0 then
  begin
     Result := 'Byte';
     if Pos('[', jType) > 0 then Result := 'Object';
  end
  else if Pos('long', jType) > 0 then
  begin
     Result := 'Long';
     if Pos('[', jType) > 0 then Result := 'Object';
  end;
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

function TFormAndroidProject.GetPascalFuncResultHack(jType: string): string;
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
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfSmallint';
  end
  else if Pos('boolean', jType) > 0 then
  begin
     Result := 'boolean';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfJBoolean';
  end
  else if Pos('byte', jType) > 0 then
  begin
     Result := 'byte';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfJByte';
  end
  else if Pos('long', jType) > 0 then
  begin
     Result := 'int64';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfInt64';
  end;
end;

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

function TFormAndroidProject.GetParamNameHack(funcParam: string; var jParamSig: string): string;
var
  strType: string;
begin
   Result:= Trim(funcParam);
   strType:= SplitStr(Result, ' ');
   jParamSig:= GetJTypeSignature(Trim(strType));
   Result:= Trim(Result);
end;

function TFormAndroidProject.GetArrayTypeNameHack(paramType: string): string;
begin
  Result:='';
  if paramType <> '' then
  begin
         if Pos('[I', paramType) > 0 then Result := 'Int'
    else if Pos('[D', paramType) > 0 then Result := 'Double'
    else if Pos('[F', paramType) > 0 then Result := 'Float'
    else if Pos('[C', paramType) > 0 then Result := 'Char'
    else if Pos('[S', paramType) > 0 then Result := 'Short'
    else if Pos('[Z', paramType) > 0 then Result := 'Boolean'
    else if Pos('[B', paramType) > 0 then Result := 'Byte'
    else if Pos('[J', paramType) > 0 then Result := 'Long'
    else if Pos('String', paramType) > 0 then Result := 'Object';
  end;
end;


procedure TFormAndroidProject.TryInsertJavaCreate(txt: string);
var
 i: integer;
 fileList: TStringList;
begin
 if MessageDlg('Changing "Controls.java" ...',
    'Insert ' + txt+' to "Controls.java" ?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
 begin
    i:= SynMemo1.Lines.Count-1;
    while Pos ('}', SynMemo1.Lines.Strings[i]) = 0 do
    begin
       Dec(i);
    end;
    SynMemo1.Lines.Strings[i]:= txt;
    SynMemo1.Lines.Add('}');
 end;

 if FPathToJavaClass <> '' then
 begin
   if FileExists(FPathToJavaClass) then
   begin
      fileList:= TStringList.Create;
      fileList.LoadFromFile(FPathToJavaClass);
      fileList.SaveToFile(FPathToJavaClass+'.bak');
      fileList.Free;
   end;
   SynMemo1.Lines.SaveToFile(FPathToJavaClass);
 end;
end;

function TFormAndroidProject.GetPascalCodeHack(funcName, funcParam, funcResult, jniSignature: string): string;
var
  i, j, ix, k, paramCount, countArrayParam, auxCount: integer;
  strList, listJCreate, lstParam, listDeleteLocalRef: TStringList;
  signature, auxFuncParam, paramType, paramJava: string;
  auxStr, auxStr2, paramName, auxFuncPascalParam, pascalParamName: string;
begin
  auxFuncParam:= '';
  paramCount:= 0;
  countArrayParam:= 0;
  k:= 0;
  auxCount:= 0;
  strList:= TStringList.Create;
  lstParam:= TStringList.Create;
  listDeleteLocalRef:= TStringList.Create;

  if funcResult = 'public' then  //just dummy result for java constructor method...
     funcResult:= 'constructor';

  if Pos('()', jniSignature) = 0 then //exist params
  begin
    if Trim(funcParam) <> '' then
    begin

       if FJavaClassName <> funcName then
         auxFuncParam:=  '(env: PJNIEnv; _'+LowerCase(FJavaClassName)+': JObject; '
       else
         auxFuncParam:=  '(env: PJNIEnv;';

       auxFuncPascalParam:= '';
       pascalParamName:= '';

       if Pos('String[', funcParam) > 0 then auxCount:= 1;

       if Pos(',',funcParam) = 0 then   //just one param...
       begin
          paramJava:= Trim(funcParam);
          paramJava:= SplitStr(paramJava, ' ');

          paramType:= '';
          paramName:= GetParamNameHack(funcParam, {var}paramType);

          paramCount:= 1;

          if Pos('[', paramJava) = 0 then
            auxFuncParam:= auxFuncParam + paramName + ': '+  GetPascalFuncResultHack(paramJava)
          else //yes, there is [
          begin
            auxFuncParam:= auxFuncParam + 'var '+paramName + ': '+ GetPascalFuncResultHack(paramJava);
            inc(countArrayParam);
          end;

          if Pos('[', paramJava) = 0 then
             auxFuncPascalParam:= auxFuncPascalParam + paramName + ': '+ GetPascalFuncResultHack(paramJava)
          else
             auxFuncPascalParam:= auxFuncPascalParam + 'var '+paramName + ': '+ GetPascalFuncResultHack(paramJava);

          pascalParamName:= paramName;
       end
       else  //two or more params..
       begin
          lstParam.StrictDelimiter:= True;
          lstParam.Delimiter:= ',';
          lstParam.DelimitedText:= Trim(funcParam);

          ix:=0;

          if funcResult = 'constructor' then ix:=1;

          for i:= ix to lstParam.Count-1 do
          begin
             paramJava:= Trim(lstParam.Strings[i]);
             paramJava:= SplitStr(paramJava, ' ');

             paramName:= GetParamNameHack(Trim(lstParam.Strings[i]), paramType);

             lstParam.Strings[i]:= paramName+'='+paramType;

             if Pos('[', paramJava) = 0 then
                auxFuncParam:= auxFuncParam + paramName + ': '+ GetPascalFuncResultHack(Trim(paramJava)) +'; '
             else
             begin
                auxFuncParam:= auxFuncParam + 'var '+paramName + ': '+ GetPascalFuncResultHack(Trim(paramJava))+'; ';
                inc(countArrayParam);
             end;

             if Pos('[', paramJava) = 0 then
               auxFuncPascalParam:= auxFuncPascalParam + paramName + ': '+ GetPascalFuncResultHack(Trim(paramJava)) +'; '
             else
               auxFuncPascalParam:= auxFuncPascalParam + 'var '+paramName + ': '+ GetPascalFuncResultHack(Trim(paramJava))+'; ';

             pascalParamName:= pascalParamName+ ' ,' + paramName;
          end;

          auxFuncParam:= Trim(auxFuncParam);
          auxFuncParam:= TrimChar(auxFuncParam, ';');

          auxFuncPascalParam:= Trim(auxFuncPascalParam);
          auxFuncPascalParam:= TrimChar(auxFuncPascalParam, ';');
          pascalParamName:= TrimChar(pascalParamName, ',');

          paramCount:= lstParam.Count;
       end;
    end;
  end  //no param ...
  else auxFuncParam:= '(env: PJNIEnv; _'+LowerCase(FJavaClassName)+': JObject';

  if funcResult = 'void' then
  begin
    signature:= 'procedure '+FJavaClassName+'_'+funcName+auxFuncParam+ ');';

    FHackListJNIHeader.Add(signature);

    FHackListPascalClass.Add('    procedure '+funcName+'('+auxFuncPascalParam+ ');');

    FHackListPascalClassImpl.Add(' ');
    FHackListPascalClassImpl.Add('procedure '+FJavaClassName+'.'+funcName+'('+auxFuncPascalParam+ ');');
    FHackListPascalClassImpl.Add('begin');
    FHackListPascalClassImpl.Add('  //in designing component state: set value here...');
    FHackListPascalClassImpl.Add('  if FInitialized then');
    if pascalParamName <> '' then pascalParamName:= ', '+ pascalParamName;
    FHackListPascalClassImpl.Add('     '+FJavaClassName+'_'+funcName+'(FjEnv, FjObject'+pascalParamName+');');
    FHackListPascalClassImpl.Add('end;');
  end
  else //not void...
  begin                                                   // '(env: PJNIEnv; this: jObject'

    if FJavaClassName <> funcName then
    begin
      signature:= 'function '+FJavaClassName+'_'+funcName+auxFuncParam+'): '+ GetPascalFuncResultHack(funcResult)+';'
    end
    else
    begin
      auxFuncParam:= auxFuncParam + '; this: jObject';
      signature:= 'function '+FJavaClassName+'_'+'jCreate'+auxFuncParam+'): '+ GetPascalFuncResultHack(funcResult)+';';
    end;

    FHackListJNIHeader.Add(signature);

    if FJavaClassName <> funcName then
      FHackListPascalClass.Add('    function '+funcName+'('+auxFuncPascalParam+'): '+ GetPascalFuncResultHack(funcResult)+';')
    else
    begin
      auxStr:= pascalParamName;
      FHackCreateParam:= TrimChar(auxStr, ',');
      SplitStr(FHackCreateParam, ',');   //remove "Self" param....

      auxStr:= auxFuncPascalParam;
      SplitStr(auxStr,';');
      FHackListPascalClass.Add('    function jCreate('+auxStr+'): '+ GetPascalFuncResultHack(funcResult)+';');
      FHackCreateProperties:= auxStr; //add properties to component ...  //** add F
    end;

    FHackListPascalClassImpl.Add(' ');

    if FJavaClassName <> funcName then
      FHackListPascalClassImpl.Add('function '+FJavaClassName+'.'+funcName+'('+auxFuncPascalParam+'): '+ GetPascalFuncResultHack(funcResult)+';')
    else
    begin
      auxStr:= auxFuncPascalParam;
      SplitStr(auxStr,';');
      FHackListPascalClassImpl.Add('function '+FJavaClassName+'.jCreate('+auxStr+'): '+ GetPascalFuncResultHack(funcResult)+';');
    end;

    FHackListPascalClassImpl.Add('begin');

    if FJavaClassName <> funcName then
    begin
       FHackListPascalClassImpl.Add('  //in designing component state: result value here...');
       FHackListPascalClassImpl.Add('  if FInitialized then');
    end;

    if pascalParamName <> '' then pascalParamName:= ', '+ pascalParamName;

    if FJavaClassName <> funcName then
       FHackListPascalClassImpl.Add('   Result:= '+FJavaClassName+'_'+funcName+'(FjEnv, FjObject'+StringReplace(pascalParamName,'_Self', 'int64(Self)',[])+');')
    else
    begin
      FHackListPascalClassImpl.Add('   Result:= '+FJavaClassName+'_jCreate(FjEnv'+StringReplace(pascalParamName,'_Self', 'int64(Self)',[])+', FjThis);');
    end;
    FHackListPascalClassImpl.Add('end;');
  end;

  strList.Add(signature);

  strList.Add('var');

  if Pos('String',funcResult) > 0 then
  begin
     strList.Add('  jStr: JString;');
     strList.Add('  jBoo: JBoolean;');
  end;

  if Pos('boolean',funcResult) > 0 then    //if isn't found, 0 is returned. The search is case-sensitive.
     strList.Add('  jBoo: JBoolean;');

  if Pos('char',funcResult) > 0 then
     strList.Add('  jCh: JChar;');

  if Pos('[',funcResult) > 0 then
  begin
     strList.Add('  resultSize: integer;');
     strList.Add('  jResultArray: jObject;');
     if Pos('String[', funcResult) > 0 then auxCount:= 2;
  end;

  if funcResult = 'constructor' then paramCount:= paramCount - 1; //constructor

  if paramCount > 0 then
  begin
    strList.Add('  jParams: array[0..'+IntToStr(paramCount-1)+'] of jValue;');
  end;

  strList.Add('  jMethod: jMethodID=nil;');
  strList.Add('  jCls: jClass=nil;');

  if countArrayParam > 0 then
  begin
     for j:= 0 to countArrayParam-1 do
     begin
       strList.Add('  newSize'+IntToStr(j)+': integer;');
       strList.Add('  jNewArray'+IntToStr(j)+': jObject=nil;');
     end;
  end;

  if auxCount <> 0 then
     strList.Add('  i: integer;');

  strList.Add('begin');
  if paramCount = 1 then
  begin
     if Pos('[', paramType) > 0 then
     begin
        strList.Add('  newSize0:= ?; //Length(?);');

        if Pos('String', paramType) = 0 then
          strList.Add('  jNewArray0:= env^.New'+GetArrayTypeNameHack(paramType)+'Array(env, newSize0);  // allocate')
        else
          strList.Add('  jNewArray0:= env^.New'+GetArrayTypeNameHack(paramType)+'Array(env, newSize0, env^.FindClass(env,''java/lang/String''),env^.NewStringUTF(env, PChar('''')));' );  // allocate');

        if Pos('String', paramType) = 0 then
          strList.Add('  env^.Set'+GetArrayTypeNameHack(paramType)+'ArrayRegion(env, jNewArray0, 0 , newSize0, @'+paramName+'[0] {source});')// copy');
        else
        begin
           strList.Add('  for i:= 0 to newSize0 - 1 do');
           strList.Add('  begin');
           strList.Add('     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar('+paramName+'[i])));');
           strList.Add('  end;');
        end;
        paramName:= 'jNewArray0';
        listDeleteLocalRef.Add('  env^.DeleteLocalRef(env,jParams[0].l);')
     end
     else  if Pos('/String;', paramType) > 0 then
     begin
        paramName:= 'env^.NewStringUTF(env, PChar('+paramName+'))';
        listDeleteLocalRef.Add('  env^.DeleteLocalRef(env,jParams[0].l);')
     end
     else if Pos('Z', paramType) > 0 then paramName:= 'JBool('+paramName+')'
     else if Pos('C', paramType) > 0 then paramName:= 'JChar('+paramName+')';
     strList.Add('  jParams[0].'+GetJParamHack(paramType)+':= '+paramName +';');
  end
  else
  begin
    ix:=0;
    if funcResult = 'constructor' then ix:=1;  //constructor
    for i:= ix to lstParam.Count-1 do
    begin
       lstParam.GetNameValue(i, paramName, paramType);
       if Pos('[', paramType) > 0 then
       begin
          strList.Add('  newSize'+IntToStr(k)+':= ?; //Length(?);');
          if Pos('String', paramType) = 0 then
            strList.Add('  jNewArray'+IntToStr(k)+':= env^.New'+GetArrayTypeNameHack(paramType)+'Array(env, newSize'+IntToStr(k)+');  // allocate')
          else
            strList.Add('  jNewArray'+IntToStr(k)+':= env^.New'+GetArrayTypeNameHack(paramType)+'Array(env, newSize0, env^.FindClass(env,''java/lang/String''),env^.NewStringUTF(env, PChar('''')));');  // allocate');
          if Pos('String', paramType) = 0 then
             strList.Add('  env^.Set'+GetArrayTypeNameHack(paramType)+'ArrayRegion(env, jNewArray'+IntToStr(k)+', 0 , newSize'+IntToStr(k)+', @'+paramName+'[0] {source});')// copy');
          else
          begin
              strList.Add('  for i:= 0 to newSize'+IntToStr(k)+' - 1 do');
              strList.Add('  begin');
              strList.Add('     env^.SetObjectArrayElement(env,jNewArray'+IntToStr(k)+',i,env^.NewStringUTF(env, PChar('+paramName+'[i])));');
              strList.Add('  end;');
          end;
          paramName:= 'jNewArray'+IntToStr(k);
          listDeleteLocalRef.Add('  env^.DeleteLocalRef(env,jParams['+IntToStr(i-ix)+'].l);');
          Inc(k);
       end
       else if Pos('/String;', paramType) > 0 then
       begin
          paramName:='env^.NewStringUTF(env, PChar('+paramName+'))';
          listDeleteLocalRef.Add('  env^.DeleteLocalRef(env,jParams['+IntToStr(i-ix)+'].l);')
       end
       else if Pos('Z', paramType) > 0 then paramName:= 'JBool('+paramName+')'
       else if Pos('C', paramType) > 0 then paramName:= 'JChar('+paramName+')';

       strList.Add('  jParams['+IntToStr(i-ix)+'].'+GetJParamHack(paramType)+':= '+paramName +';');
    end;
  end;
  if funcResult = 'constructor' then  //constructor
  begin
    strList.Add('  jCls:= Get_gjClass(env);');
    strList.Add('  jMethod:= env^.GetMethodID(env, jCls, '''+funcName+'_jCreate'+''', '''+jniSignature+'''); ');
  end
  else
  begin
    strList.Add('  jCls:= env^.GetObjectClass(env, _'+LowerCase(FJavaClassName)+');');
    strList.Add('  jMethod:= env^.GetMethodID(env, jCls, '''+funcName+''', '''+jniSignature+'''); ');
  end;

  if Pos('()', jniSignature) = 0 then //has params
  begin
     if funcResult = 'constructor' then
     begin
        strList.Add('  Result:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, this, jMethod, @jParams);');
        strList.Add('  Result:= env^.NewGlobalRef(env, Result);');
     end
     else if funcResult = 'void' then
        strList.Add('  env^.CallVoidMethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);')
     else
     begin
       if Pos('boolean',funcResult) > 0 then
       begin
          strList.Add('  jBoo:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
          strList.Add('  Result:= boolean(jBoo);')
       end
       else if Pos('char',funcResult) > 0 then
       begin
          strList.Add('  jCh:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
          strList.Add('  Result:= char(jCh);');
       end
       else if Pos('[',funcResult) > 0 then
       begin
         strList.Add('  jResultArray:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod,  @jParams);');
         strList.Add('  resultSize:= env^.GetArrayLength(env, jResultArray);');
         strList.Add('  SetLength(Result, resultSize);');
         if Pos('String', funcResult) > 0 then
         begin
             strList.Add('  for i:= 0 to resultsize - 1 do');
             strList.Add('  begin');
             strList.Add('    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);');
             strList.Add('    case jStr = nil of');
             strList.Add('       True : Result[i]:= '''';');
             strList.Add('       False: begin');
             strList.Add('                jBoo:= JNI_False;');
             strList.Add('                Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));');
             strList.Add('              end;');
             strList.Add('    end;');
             strList.Add('  end;');
         end
         else
         begin
             strList.Add('  env^.Get'+GetArrayTypeByFuncResultHack(funcResult)+'ArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});');
         end;
       end
       else if Pos('String',funcResult) > 0 then
       begin
         strList.Add('  jStr:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
         strList.Add('  case jStr = nil of');
         strList.Add('     True : Result:= '''';');
         strList.Add('     False: begin');
         strList.Add('              jBoo:= JNI_False;');
         strList.Add('              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));');
         strList.Add('            end;');
         strList.Add('  end;');
       end
       else strList.Add('  Result:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
     end
  end
  else //no params
  begin
    if funcResult = 'void' then
       strList.Add('  env^.CallVoidMethod(env, _'+LowerCase(FJavaClassName)+', jMethod);')
    else
    begin
      if Pos('boolean',funcResult) > 0 then
      begin
         strList.Add('  jBoo:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
         strList.Add('  Result:= boolean(jBoo);');
      end
      else if Pos('char',funcResult) > 0 then
      begin
         strList.Add('  jCh:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
         strList.Add('  Result:= boolean(jCh);');
      end
      else if Pos('[',funcResult) > 0 then
      begin
        strList.Add('  jresultArray:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
        strList.Add('  resultsize:= env^.GetArrayLength(env, jresultArray);');
        strList.Add('  SetLength(Result, resultsize);');
        if Pos('String', funcResult) > 0 then
        begin
            strList.Add('  for i:= 0 to resultsize - 1 do');
            strList.Add('  begin');
            strList.Add('    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);');
            strList.Add('    case jStr = nil of');
            strList.Add('       True : Result[i]:= '''';');
            strList.Add('       False: begin');
            strList.Add('               jBoo:= JNI_False;');
            strList.Add('               Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));');
            strList.Add('              end;');
            strList.Add('    end;');
            strList.Add('  end;');
        end
        else
        begin
            strList.Add('  env^.Get'+GetArrayTypeByFuncResultHack(funcResult)+'ArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});');
        end;
      end
      else if Pos('String',funcResult) > 0 then
      begin
         strList.Add('  jStr:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
         strList.Add('  case jStr = nil of');
         strList.Add('     True : Result:= '''';');
         strList.Add('     False: begin');
         strList.Add('              jBoo:= JNI_False;');
         strList.Add('              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));');
         strList.Add('            end;');
         strList.Add('  end;');
      end
      else strList.Add('  Result:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
    end;
  end;

  if listDeleteLocalRef.Text <> '' then
     strList.Add(Trim(listDeleteLocalRef.Text));

  strList.Add('end;');

  if funcResult = 'constructor' then
  begin
    listJCreate:= TStringList.Create;
    auxStr:= funcParam;
    SplitStr(auxStr,',');
    listJCreate.Add('  ');
    listJCreate.Add('   public java.lang.Object '+funcName+'_jCreate('+Trim(auxStr)+') {');
    auxStr2:= Trim(auxStr);
    SplitStr(auxStr2,' ');
    auxStr:='';
    ix:=1;
    for i:= ix to lstParam.Count-1 do
    begin
       lstParam.GetNameValue(i, paramName, paramType);
       auxStr:= auxStr + ',' +paramName;
    end;
    listJCreate.Add('      return (java.lang.Object)(new '+FJavaClassName+'(this'+auxStr+'));');
    listJCreate.Add('   }');
    listJCreate.Add('  ');

    TryInsertJavaCreate(listJCreate.Text); //just try

    strList.Add(' ');
    strList.Add('(*');
    strList.Add('//Please, you need insert: ');
    strList.Add(listJCreate.Text+ '//to end of "public class Controls" in "Controls.java"');
    strList.Add('*)');

    listJCreate.Free;
  end;

  strList.Add(' ');

  lstParam.Free;
  listDeleteLocalRef.Free;

  Result:= strList.Text;
  strList.Free;
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
  if ShellListView1.Selected <> nil then
  begin

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
                      Trim(auxParam),Trim(strList.Strings[strList.Count-2]){result})
      else
      begin
        strPascalCode:= GetPascalCodeHack(Trim(strList.Strings[strList.Count-1]) {funct},
                        Trim(auxParam),Trim(strList.Strings[strList.Count-2]){result}, methSignature);
      end;

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
end;

procedure TFormAndroidProject.PageControl1Change(Sender: TObject);
begin
   if not FHackJNIMethod then
   begin
     SynMemo2.Lines.Clear;
     if PageControl1.ActivePage = TabSheet2 then DoJavaParse;
   end
end;

procedure TFormAndroidProject.ShellListView1DblClick(Sender: TObject);
var
  i, j, k: integer;
  pathList: TStringList;
  fileName, pathPack: string;
  auxStr: string;
begin

  if ShellListView1.Selected <> nil then
  begin

     i:= LastPos(DirectorySeparator, FPathToJavaTemplates);
     FPathToWizardCode:= Copy(FPathToJavaTemplates, 1, i-1);

     if Pos('Controls.java', ShellListView1.Selected.Caption) >  0 then
        FModuleType:= 0  //JNI Bridges Controls
     else
        FModuleType:= 1;

     if (FPathToJavaTemplates <> '') and (not FHackJNIMethod) then
     begin
       FListJNIBridge.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'ControlsEvents.txt');
     end;

     Memo2List.Clear;
     SynMemo2.Lines.Clear;

     pathList:= TStringList.Create;

     FPathToJavaClass:= ShellListView1.GetPathFromItem(ShellListView1.Selected);

     StatusBar1.SimpleText:= FPathToJavaClass;

     pathList.StrictDelimiter:= True;
     pathList.Delimiter:= DirectorySeparator;
     pathList.DelimitedText:= FPathToJavaClass;
     fileName:= pathList.Strings[pathList.Count-1];

     FJavaClassName:= SplitStr(fileName,'.');
     FSaveJavaClassName:= FJavaClassName;


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
     SynMemo1.Lines.LoadFromFile(ShellListView1.GetPathFromItem(ShellListView1.Selected));
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
end;

procedure TFormAndroidProject.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  fileList: TStringList;
begin

  FJavaClassName:= FSaveJavaClassName;
  if not FHackJNIMethod then
  begin
      DoJavaParse;
      SynMemo2.Lines.Add(' ');
      FPascalJNIInterfaceCode:= SynMemo2.Lines.Text;
      if FPathToJavaClass <> '' then
      begin
        if FileExists(FPathToJavaClass) then
        begin
          fileList:= TStringList.Create;
          fileList.LoadFromFile(FPathToJavaClass);
          fileList.SaveToFile(FPathToJavaClass+'.bak');
          fileList.Free;
        end;
        SynMemo1.Lines.SaveToFile(FPathToJavaClass);
      end;
  end;

  FImportsList.Free;
  Memo2List.Free;
  FListJNIBridge.Free;

  FHackListJNIHeader.Free;
  FHackListPascalClass.Free;
  FHackListPascalClassImpl.Free;

  CanClose:= True;
end;

procedure TFormAndroidProject.FormShow(Sender: TObject);
var
  selectedNode, tempNode : TTreeNode;
begin
   SynMemo1.Lines.Clear;
   SynMemo2.Lines.Clear;
   PageControl1.ActivePage:= TabSheet1;
   Self.Caption:= Self.Caption+ ' <> ' + Self.AndroidProjectName;

   selectedNode:= ShellTreeView1.Items.FindNodeWithText('src');

   if selectedNode = nil then Exit;

   selectedNode.Expanded:= True;
   tempNode:= selectedNode.GetFirstVisibleChild;
   while tempNode  <> nil do
   begin
       selectedNode:= tempNode;
       selectedNode.Expanded:= True;
       tempNode:= selectedNode.GetFirstVisibleChild;
   end;

   ShellTreeView1.Selected:= selectedNode;

   StatusBar1.Panels.Items[0].Text:= ShellTreeView1.GetPathFromNode(ShellTreeView1.Selected);

end;

procedure TFormAndroidProject.MenuItem18Click(Sender: TObject);
var
  txtCaption: string;
begin
   txtCaption:= (Sender as TMenuItem).Caption;
   if Pos('About', txtCaption) > 0 then
   begin
      //02-december-2013 Add support to simonsayz's controls: http://blog.naver.com/simonsayz
      ShowMessage('Lamw: Lazarus Android Module Wizard [ver. 0.6 - rev. 16 - 18 February 2015 - by jmpessoa]');
   end;
end;

procedure TFormAndroidProject.MenuItem20Click(Sender: TObject);
begin
  Self.ModalResult:= mrCancel;
end;

procedure TFormAndroidProject.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TFormAndroidProject.PopupMenu1Close(Sender: TObject);
var
  pathPlusFileName: string;
  auxPath: string;
  strPack: string;
  auxList: TStringList;
  NodeSelected:  TTreeNode;
  ListManifest: TStringList;
  strAfterReplace: string;
  fileList: TStringList;
begin

  NodeSelected:= ShellTreeView1.Selected;
  if NodeSelected <> nil then
  begin
    pathPlusFileName:= ShellListView1.GetPathFromItem(ShellListView1.Selected);
    auxPath:= ExtractFilePath(pathPlusFileName);
    if Pos(FMainActivity+'.java', pathPlusFileName) > 0 then  //Android Bridges controls
    begin
      auxList:= TStringList.Create;
      auxList.LoadFromFile(pathPlusFileName);
      strPack:= Trim(auxList.Strings[0]); // ex: package com.template.appdummy;

      auxList.Clear;
      auxList.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + FMainActivity+'.java'); //App.Java
      auxList.Strings[0]:= strPack;
      auxList.SaveToFile(auxPath + FMainActivity+'.java' );

      auxList.Clear;

      if FileExists(auxPath + 'Controls.java') then
      begin
        fileList:= TStringList.Create;
        fileList.LoadFromFile(auxPath + 'Controls.java');
        fileList.SaveToFile(auxPath + 'Controls.java'+'.bak');
        fileList.Free;
      end;
      auxList.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'Controls.java');
      auxList.Strings[0]:= strPack;
      auxList.SaveToFile(auxPath + 'Controls.java');
      auxList.Free;

      ShellListView1.Root := '';
      ShellListView1.Root := auxPath;

      strPack:= TrimChar(strPack,';');
      SplitStr(strPack, ' ');
      strPack:= Trim(strPack);

      ListManifest:= TStringList.Create;

      ListManifest.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'AndroidManifest.txt');
      strAfterReplace  := StringReplace(ListManifest.Text, 'dummyPackage',strPack, [rfReplaceAll, rfIgnoreCase]);

      strPack:= strPack+'.'+FMainActivity; {gApp}
      strAfterReplace  := StringReplace(strAfterReplace, 'dummyAppName',strPack, [rfReplaceAll, rfIgnoreCase]);

      {fix bug  - 04 jan 2014}
      strAfterReplace  := StringReplace(strAfterReplace, 'dummySdkApi', FMinApi, [rfReplaceAll, rfIgnoreCase]);
      strAfterReplace  := StringReplace(strAfterReplace, 'dummyTargetApi', FTargetApi, [rfReplaceAll, rfIgnoreCase]);

      ListManifest.Clear;
      ListManifest.Text:= strAfterReplace;
      ListManifest.SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');
      ListManifest.Free;
    end;

  end;
end;

function TFormAndroidProject.GetHackListPascalClassInterf: string;
var
  listPascal, listProperties: TStringList;
  i: integer;
begin
  listPascal:= TStringList.Create;
  listPascal.Add('unit '+Copy(LowerCase(FJavaClassName),2,Length(FJavaClassName))+';');
  listPascal.Add(' ');
  listPascal.Add('{$mode delphi}');
  listPascal.Add(' ');
  listPascal.Add('interface');
  listPascal.Add(' ');
  listPascal.Add('uses');
  listPascal.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;'); //{,LResources}
  listPascal.Add(' ');
  listPascal.Add('type');
  listPascal.Add(' ');
  listPascal.Add('{Draft Component code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']}');
  listPascal.Add('{https://github.com/jmpessoa/lazandroidmodulewizard} ');
  listPascal.Add(' ');
  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('{jVisualControl template}');
    listPascal.Add(' ');
    listPascal.Add(FJavaClassName+' = class(jVisualControl)')
  end
  else
  begin
    listPascal.Add('{jControl template}');
    listPascal.Add(' ');
    listPascal.Add(FJavaClassName+' = class(jControl)');
  end;

  listPascal.Add(' private');

  listProperties:= TStringList.Create;

  if Pos('_', FHackCreateProperties) > 0 then
     listPascal.Add('   '+StringReplace(FHackCreateProperties,'_','F',[rfReplaceAll])+';') //** Add F
  else
  begin
    listProperties.StrictDelimiter:= True;
    listProperties.Delimiter:= ';';
    listProperties.DelimitedText:= FHackCreateProperties;
    for i:= 0 to listProperties.Count-1 do
    begin
      listPascal.Add('   '+'FP'+Trim(listProperties.Strings[i]) + ';'); //** Add F
    end;
  end;

  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
   listPascal.Add('    procedure SetVisible(Value: Boolean);');
   listPascal.Add('    procedure SetColor(Value: TARGBColorBridge); //background');
   listPascal.Add('    procedure UpdateLParamHeight;');
   listPascal.Add('    procedure UpdateLParamWidth;');
  end;

  listPascal.Add(' ');
  listPascal.Add(' protected');
  if Pos('jVisualControl', FProjectModel) > 0  then
     listPascal.Add('    procedure SetParentComponent(Value: TComponent); override;');
  listPascal.Add(' ');
  listPascal.Add(' public');
  listPascal.Add('    constructor Create(AOwner: TComponent); override;');
  listPascal.Add('    destructor  Destroy; override;');
  listPascal.Add('    procedure Init(refApp: jApp); override;');

  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('    procedure Refresh;');
    listPascal.Add('    procedure UpdateLayout; override;');
    listPascal.Add('    procedure ClearLayout;');
    listPascal.Add('    ');
    listPascal.Add('    procedure GenEvent_OnClick(Obj: TObject);');
  end;

  listPascal.Add(FHackListPascalClass.Text);

  listPascal.Add(' published');

  (* TODO:
  if Pos('_', FHackCreateProperties) > 0 then
  begin
    listProperties.StrictDelimiter:= True;
    listProperties.Delimiter:= ';';
    listProperties.DelimitedText:= StringReplace(FHackCreateProperties,'_', '',[rfReplaceAll]);
    for i:= 0 to listProperties.Count-1 do
    begin                              //UpperCaseFirst
      listPascal.Add('    property ' + UpperCaseFirst(Trim(listProperties.Strings[i])) +
                          ' read F'   + Trim(listProperties.Strings[i])+
                          ' write F'  + Trim(listProperties.Strings[i])+';'); //** Add F
    end;
  end
  else
  begin
    for i:= 0 to listProperties.Count-1 do
    begin                              //UpperCaseFirst
      listPascal.Add('    property P' + Trim(listProperties.Strings[i]) +
                          ' read FP'   + Trim(listProperties.Strings[i])+
                          ' write FP'  + Trim(listProperties.Strings[i])+';'); //** Add F
    end;
  end;
  *)

  listProperties.Free;

  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('    property BackgroundColor: TARGBColorBridge read FColor write SetColor;');
    listPascal.Add('    property OnClick: TOnNotify read FOnClick write FOnClick;');
  end;

  listPascal.Add(' ');
  listPascal.Add('end;');
  listPascal.Add(' ');
  listPascal.Add(FHackListJNIHeader.Text);
  listPascal.Add(' ');

  listPascal.Add('implementation');
  listPascal.Add(' ');
  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
  listPascal.Add('uses');
  listPascal.Add('   customdialog;');
  end;
  listPascal.Add('  ');
  listPascal.Add('{---------  '+  FJavaClassName +'  --------------}');
  listPascal.Add(' ');
  listPascal.Add('constructor '+FJavaClassName+'.Create(AOwner: TComponent);');
  listPascal.Add('begin');
  listPascal.Add('  inherited Create(AOwner);');

  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('  FMarginLeft   := 10;');
    listPascal.Add('  FMarginTop    := 10;');
    listPascal.Add('  FMarginBottom := 10;');
    listPascal.Add('  FMarginRight  := 10;');
    listPascal.Add('  FLParamWidth  := lpMatchParent;  //lpWrapContent');
    listPascal.Add('  FLParamHeight := lpWrapContent; //lpMatchParent');
    listPascal.Add('  FAcceptChildrenAtDesignTime:= False;');
  end;
  listPascal.Add('//your code here....');
  listPascal.Add('end;');
  listPascal.Add(' ');
  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('procedure '+FJavaClassName+'.SetParentComponent(Value: TComponent);');
    listPascal.Add('begin');
    listPascal.Add('  inherited SetParentComponent(Value);');
    listPascal.Add('  Self.Height:= 96; //??');
    listPascal.Add('  Self.Width:= 96; //??');
    listPascal.Add('  if Value <> nil then');
    listPascal.Add('  begin');
    listPascal.Add('      Parent:= TAndroidWidget(Value);');
    listPascal.Add('      Self.Width:= Trunc(TAndroidWidget(Parent).Width) - 13; //??');
    listPascal.Add('  end;');
    listPascal.Add('end;');
    listPascal.Add(' ');
  end;
  listPascal.Add('destructor '+FJavaClassName+'.Destroy;');
  listPascal.Add('begin');
  listPascal.Add('  if not (csDesigning in ComponentState) then');
  listPascal.Add('  begin');
  listPascal.Add('     if FjObject <> nil then');
  listPascal.Add('     begin');
  listPascal.Add('       jFree();');
  listPascal.Add('       FjObject:= nil;');
  listPascal.Add('     end;');
  listPascal.Add('  end;');
  listPascal.Add('  //you others free code here...''');
  listPascal.Add('  inherited Destroy;');
  listPascal.Add('end;');
  listPascal.Add(' ');
  listPascal.Add('procedure '+FJavaClassName+'.Init(refApp: jApp);');

  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
   listPascal.Add('var');
   listPascal.Add('  rToP: TPositionRelativeToParent;');
   listPascal.Add('  rToA: TPositionRelativeToAnchorID;');
  end;

  listPascal.Add('begin');
  listPascal.Add('  if FInitialized  then Exit;');
  listPascal.Add('  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!');
  listPascal.Add('  //your code here: set/initialize create params....');

  listProperties:= TStringList.Create;

  if Pos('_', FHackCreateParam) > 0 then
    listPascal.Add('  FjObject:= jCreate('+StringReplace(FHackCreateParam,'_','F',[rfReplaceAll])+'); //jSelf !')   //** add F
  else
  begin
    listProperties.StrictDelimiter:= True;
    listProperties.Delimiter:= ',';
    listProperties.DelimitedText:= FHackCreateParam;
    for i:= 0 to listProperties.Count-1 do
    begin
      listProperties.Strings[i]:= 'FP'+Trim(listProperties.Strings[i]); //ReplaceCharFirst(Trim(listProperties.Strings[i]),'F')+';'; //** Add F
    end;
    listPascal.Add('  FjObject:= jCreate('+listProperties.DelimitedText+'); //jSelf !');   //** add F
  end;

  listProperties.Free;
  listPascal.Add('  FInitialized:= True;');

  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('  if FParent <> nil then');
    listPascal.Add('  begin');
    listPascal.Add('    if FParent is jPanel then');
    listPascal.Add('    begin');
    listPascal.Add('      jPanel(FParent).Init(refApp);');
    listPascal.Add('      FjPRLayout:= jPanel(FParent).View;');
    listPascal.Add('    end;');
    listPascal.Add('    if FParent is jScrollView then');
    listPascal.Add('    begin');
    listPascal.Add('      jScrollView(FParent).Init(refApp);');
    listPascal.Add('      FjPRLayout:= jScrollView(FParent).View;');
    listPascal.Add('    end;');
    listPascal.Add('    if FParent is jCustomDialog then');
    listPascal.Add('    begin');
    listPascal.Add('      jCustomDialog(FParent).Init(refApp);');
    listPascal.Add('      FjPRLayout:= jCustomDialog(FParent).View;');
    listPascal.Add('    end;');
    listPascal.Add('  end;');

   listPascal.Add('  '+FJavaClassName+'_SetViewParent(FjEnv, FjObject, FjPRLayout);');
   listPascal.Add('  '+FJavaClassName+'_SetId(FjEnv, FjObject, Self.Id);');
   listPascal.Add('  '+FJavaClassName+'_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,');
   listPascal.Add('                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,');
   listPascal.Add('                        GetLayoutParams(gApp, FLParamWidth, sdW),');
   listPascal.Add('                        GetLayoutParams(gApp, FLParamHeight, sdH));');

   listPascal.Add('  ');
   listPascal.Add('  if FParent is jPanel then');
   listPascal.Add('  begin');
   listPascal.Add('    Self.UpdateLayout;');
   listPascal.Add('  end;');
   listPascal.Add('  ');

   listPascal.Add('  for rToA := raAbove to raAlignRight do');
   listPascal.Add('  begin');
   listPascal.Add('    if rToA in FPositionRelativeToAnchor then');
   listPascal.Add('    begin');
   listPascal.Add('      '+FJavaClassName+'_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));');
   listPascal.Add('    end;');
   listPascal.Add('  end;');
   listPascal.Add('  for rToP := rpBottom to rpCenterVertical do');
   listPascal.Add('  begin');
   listPascal.Add('    if rToP in FPositionRelativeToParent then');
   listPascal.Add('    begin');
   listPascal.Add('      '+FJavaClassName+'_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));');
   listPascal.Add('    end;');
   listPascal.Add('  end;');
   listPascal.Add('  ');
   listPascal.Add('  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id');
   listPascal.Add('  else Self.AnchorId:= -1; //dummy');
   listPascal.Add('  ');
   listPascal.Add('  '+FJavaClassName+'_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);');
   listPascal.Add('  ');
   listPascal.Add('  if  FColor <> colbrDefault then');
   listPascal.Add('    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FColor));');
   listPascal.Add('  ');
   listPascal.Add('  View_SetVisible(FjEnv, FjObject, FVisible);');
  end;
  listPascal.Add('end;');
  listPascal.Add('  ');
  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
   listPascal.Add('procedure '+FJavaClassName+'.SetColor(Value: TARGBColorBridge);');
   listPascal.Add('begin');
   listPascal.Add('  FColor:= Value;');
   listPascal.Add('  if (FInitialized = True) and (FColor <> colbrDefault)  then');
   listPascal.Add('    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FColor));');
   listPascal.Add('end;');

   listPascal.Add('procedure '+FJavaClassName+'.SetVisible(Value : Boolean);');
   listPascal.Add('begin');
   listPascal.Add('  FVisible:= Value;');
   listPascal.Add('  if FInitialized then');
   listPascal.Add('    View_SetVisible(FjEnv, FjObject, FVisible);');
   listPascal.Add('end;');

   listPascal.Add('procedure '+FJavaClassName+'.UpdateLParamWidth;');
   listPascal.Add('var');
   listPascal.Add('  side: TSide;');
   listPascal.Add('begin');
   listPascal.Add('  if FInitialized then');
   listPascal.Add('  begin');
   listPascal.Add('    if Self.Parent is jForm then');
   listPascal.Add('    begin');
   listPascal.Add('      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;');
   listPascal.Add('      '+FJavaClassName+'_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));');
   listPascal.Add('    end');
   listPascal.Add('    else');
   listPascal.Add('    begin');
   listPascal.Add('      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then');
   listPascal.Add('        '+FJavaClassName+'_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))');
   listPascal.Add('      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then');
   listPascal.Add('        '+FJavaClassName+'_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))');
   listPascal.Add('      else');
   listPascal.Add('        '+FJavaClassName+'_SetLParamWidth(FjEnv, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))');
   listPascal.Add('    end;');
   listPascal.Add('  end;');
   listPascal.Add('end;');
   listPascal.Add('   ');
   listPascal.Add('procedure '+FJavaClassName+'.UpdateLParamHeight;');
   listPascal.Add('var');
   listPascal.Add('  side: TSide;');
   listPascal.Add('begin');
   listPascal.Add('  if FInitialized then');
   listPascal.Add('  begin');
   listPascal.Add('    if Self.Parent is jForm then');
   listPascal.Add('    begin');
   listPascal.Add('      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;');
   listPascal.Add('      '+FJavaClassName+'_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));');
   listPascal.Add('    end');
   listPascal.Add('    else');
   listPascal.Add('    begin');
   listPascal.Add('      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then');
   listPascal.Add('        '+FJavaClassName+'_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))');
   listPascal.Add('      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then');
   listPascal.Add('        '+FJavaClassName+'_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))');
   listPascal.Add('      else');
   listPascal.Add('        '+FJavaClassName+'_SetLParamHeight(FjEnv, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))');
   listPascal.Add('    end;');
   listPascal.Add('  end;');
   listPascal.Add('end;');
   listPascal.Add('   ');
   listPascal.Add('procedure '+FJavaClassName+'.UpdateLayout;');
   listPascal.Add('begin');
   listPascal.Add('  if FInitialized then');
   listPascal.Add('  begin');
   listPascal.Add('    inherited UpdateLayout;');
   listPascal.Add('    UpdateLParamWidth;');
   listPascal.Add('    UpdateLParamHeight;');
   listPascal.Add('  '+FJavaClassName+'_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);');
   listPascal.Add('  end;');
   listPascal.Add('end;');
   listPascal.Add('   ');
   listPascal.Add('procedure '+FJavaClassName+'.Refresh;');
   listPascal.Add('begin');
   listPascal.Add('  if FInitialized then');
   listPascal.Add('    View_Invalidate(FjEnv, FjObject);');
   listPascal.Add('end;');
   listPascal.Add('   ');
   listPascal.Add('procedure '+FJavaClassName+'.ClearLayout;');
   listPascal.Add('var');
   listPascal.Add('   rToP: TPositionRelativeToParent;');
   listPascal.Add('   rToA: TPositionRelativeToAnchorID;');
   listPascal.Add('begin');
   listPascal.Add(' '+FJavaClassName+'_ClearLayoutAll(FjEnv, FjObject );');
   listPascal.Add('   for rToP := rpBottom to rpCenterVertical do');
   listPascal.Add('   begin');
   listPascal.Add('      if rToP in FPositionRelativeToParent then');
   listPascal.Add('        '+FJavaClassName+'_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));');
   listPascal.Add('   end;');
   listPascal.Add('   for rToA := raAbove to raAlignRight do');
   listPascal.Add('   begin');
   listPascal.Add('     if rToA in FPositionRelativeToAnchor then');
   listPascal.Add('       '+FJavaClassName+'_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));');
   listPascal.Add('   end;');
   listPascal.Add('end;');
   listPascal.Add(' ');
   listPascal.Add('//Event : Java -> Pascal');
   listPascal.Add('procedure '+FJavaClassName+'.GenEvent_OnClick(Obj: TObject);');
   listPascal.Add('begin');
   listPascal.Add('  if Assigned(FOnClick) then FOnClick(Obj);');
   listPascal.Add('end;');
  end;

  Result:= listPascal.Text;

  listPascal.Free;
end;

procedure TFormAndroidProject.PopupMenu2Close(Sender: TObject);
var
  selList: TStringList;
  clsLine, clsName: string;
  index, i: integer;
  foundClass: boolean;
  strCaption: string;
  responseStr : string;
begin

  strCaption:= (Sender as TMenuItem).Caption;


  if Pos('Search ', strCaption) > 0 then
  begin
     responseStr := InputBox('Java Source:', 'Search: [MatchCase+WholeWord]', '');
     if responseStr <> '' then
        SynMemo1.SearchReplace(responseStr, responseStr,[ssoMatchCase,ssoWholeWord]);
  end;


  if Pos('Insert ', strCaption) > 0 then
  begin
    InsertJControlCodeTemplate(strCaption);
    SynMemo1.PasteFromClipboard;
    Exit;
  end;

  FSaveProjectModel:= FProjectModel;

  if strCaption <> 'Cancel' then
  begin

    FHackJNIMethod:= True;

    SplitStr(strCaption, ' ');

    FProjectModel:= strCaption;   //ex. Write  "[Draft] Pascal jVisualControl Interface"

    selList:= TStringList.Create;
    selList.Text:= SynMemo1.SelText; //java class code...

    foundClass:= False;
    i:= 0;
    while (not foundClass) and (i < selList.Count) do
    begin
       clsLine:= Trim(selList.Strings[i]);
       if Pos('class', clsLine) > 0 then foundClass:= True;
       Inc(i);
    end;

    selList.Free;

    if foundClass then
    begin
      SplitStr(clsLine, ' ');  //remove "class" word...
      clsLine:= Trim(clsLine); //cleanup...

      if Pos(' ', clsLine) > 0  then index:= Pos(' ', clsLine)
      else if Pos('{', clsLine) > 0 then index:= Pos('{', clsLine)
      else if Pos(#10, clsLine) > 0 then index:= Pos(#10, clsLine);

      clsName:= Trim(Copy(clsLine,1,index-1));  //get class name
      if clsName <> '' then
      begin
        //FSaveJavaClassName:= FJavaClassName;
        FJavaClassName:= clsName;

        FHackListJNIHeader.Clear;
        FHackListPascalClass.Clear;
        FHackListPascalClassImpl.Clear;

        DoJavaParse;    //process...

        FHackListPascalClassImpl.Add(' ');
        FHackListPascalClassImpl.Add('{-------- '+FJavaClassName +'_JNI_Bridge ----------}');
        FHackListPascalClassImpl.Add(' ');

        SynMemo2.Lines.Clear;
        SynMemo2.Lines.Text:= GetHackListPascalClassInterf + FHackListPascalClassImpl.Text + FPascalJNIInterfaceCode;

        SynMemo2.Lines.Add('end.');

        PageControl1.ActivePage:= TabSheet2;
        SynMemo2.SelectAll;
        SynMemo2.CopyToClipboard;
        SynMemo2.ClearSelection;
        SynMemo2.PasteFromClipboard;
        ShowMessage('New '+clsName+' DRAFT Component Code was Copied To Clipboard!');
      end;
    end;
  end;

  FHackJNIMethod:= False;
  FProjectModel:= FSaveProjectModel;

end;

procedure TFormAndroidProject.InsertJControlCodeTemplate(txt: string);
var
  strList: TStringList;
  clipBoard: TClipboard;
  txtCaption, newJavaClassName: string;

begin
   txtCaption:= txt;
   if Pos('jControl', txtCaption) > 0 then
   begin
     newJavaClassName:= 'MyControl';
     strList:= TStringList.Create;
     clipBoard:= TClipboard.Create;
     strList.Add(' ');
     strList.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     strList.Add('/*jControl template*/');
     strList.Add(' ');
     strList.Add('class j'+newJavaClassName+' /*extends ...*/ {');
     strList.Add('  ');
     strList.Add('    private long     pascalObj = 0;      // Pascal Object');
     strList.Add('    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...');
     strList.Add('    private Context  context   = null;');
     strList.Add('  ');
     strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('  ');
     strList.Add('    public j'+newJavaClassName+'(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!');
     strList.Add('       //super(_ctrls.activity);');
     strList.Add('       context   = _ctrls.activity;');
     strList.Add('       pascalObj = _Self;');
     strList.Add('       controls  = _ctrls;');
     strList.Add('    }');
     strList.Add('  ');
     strList.Add('    public void jFree() {');
     strList.Add('      //free local objects...');
     strList.Add('    }');
     strList.Add('  ');
     strList.Add('  //write others [public] methods code here......');
     strList.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('  ');

     (*strList.Add('//just for test !  ');
       strList.Add('   public int[] GetIntArray(int _x, int _y, int _size) {');
       strList.Add('      int[] v = new int[_size];');
       strList.Add('      for (int i=0, i < _size, i++) {');
       strList.Add('         v[i] = _x + _y;');
       strList.Add('      }');
       strList.Add('      return v;');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public int[] GetInverseIntArray(int[] _a, int _size) {');
       strList.Add('      int v[] = new int[_size];');
       strList.Add('      for (int i=0, i < _size, i++) {');
       strList.Add('         v[i] = _a[(_size-1)-i]);');
       strList.Add('      }');
       strList.Add('      return v;');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public void SetBitmap(byte[] _a) {');
       strList.Add('     //');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public int[] GetSumIntArray(int[] _v1, int[] _v2, int _size) {');
       strList.Add('     int v[] = new int[_size];');
       strList.Add('     for (int i=0, i < _size, i++) {');
       strList.Add('         v[i] = _v1[i] + _v2[i];');
       strList.Add('     }');
       strList.Add('     return v;');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('  ');
       strList.Add('   public  Bitmap GetJavaBitmap() {');
       strList.Add('     //');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public byte[] GetByteArrayFromBitmap() {');
       strList.Add('      ByteArrayOutputStream stream = new ByteArrayOutputStream();');
       strList.Add('      this.bmp.compress(CompressFormat.PNG, 0, stream);');
       strList.Add('      return stream.toByteArray();');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public void SetByteArrayToBitmap(byte[] _image) {');
       strList.Add('      this.bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public byte[] GetValueAsBlod(int _columnIndex) {');
       strList.Add('      if (cursor != null) return cursor.getBlob(_columnIndex);');
       strList.Add('      else return null; ');
       strList.Add('   }');
       strList.Add('  ');
       strList.Add('   public Bitmap GetValueAsBitmap(int _columnIndex) {');
       strList.Add('	   bufBmp = null;');
       strList.Add('	   byte[] image = GetValueAsBlod(_columnIndex);');
       strList.Add('	   if (image != null) {');
       strList.Add('	     this.bufBmp = BitmapFactory.decodeByteArray(image, 0, image.length);');
       strList.Add('	   }');
       strList.Add('	   return bufBmp;');
       strList.Add('   }'); *)

     strList.Add('}');
     clipBoard.Clear;
     clipBoard.AsText:= strList.Text;
     strList.Free;
     clipBoard.Free;
   end;

   if Pos('jVisualControl', txtCaption) > 0 then
   begin
     newJavaClassName:= 'MyNewVisualControl';
     strList:= TStringList.Create;
     clipBoard:= TClipboard.Create;
     strList.Add(' ');
     strList.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     strList.Add('/*jVisualControl template*/');
     strList.Add('  ');
     strList.Add('class j'+newJavaClassName+' extends RelativeLayout /*dummy*/ { //please, fix what GUI object will be extended!');
     strList.Add('   ');
     strList.Add('   private long       pascalObj = 0;    // Pascal Object');
     strList.Add('   private Controls   controls  = null; // Control Class for events');
     strList.Add('   ');
     strList.Add('   private Context context = null;');
     strList.Add('   private ViewGroup parent   = null;         // parent view');
     strList.Add('   private RelativeLayout.LayoutParams lparams;              // layout XYWH ');
     strList.Add('   private OnClickListener onClickListener;   // click event');
     strList.Add('   private Boolean enabled  = true;           // click-touch enabled!');
     strList.Add('   private int lparamsAnchorRule[] = new int[30];');
     strList.Add('   private int countAnchorRule = 0;');
     strList.Add('   private int lparamsParentRule[] = new int[30];');
     strList.Add('   private int countParentRule = 0;');
     strList.Add('   private int lparamH = 100;');
     strList.Add('   private int lparamW = 100;');
     strList.Add('   private int marginLeft = 0;');
     strList.Add('   private int marginTop = 0;');
     strList.Add('   private int marginRight = 0;');
     strList.Add('   private int marginBottom = 0;');
     strList.Add('   private boolean mRemovedFromParent = false;');
     strList.Add('  ');
     strList.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('  ');
     strList.Add('   public j'+newJavaClassName+'(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!');
     strList.Add('      super(_ctrls.activity);');
     strList.Add('      context   = _ctrls.activity;');
     strList.Add('      pascalObj = _Self;');
     strList.Add('      controls  = _ctrls;');
     strList.Add('   ');
     strList.Add('      lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);');
     strList.Add('   ');
     strList.Add('      onClickListener = new OnClickListener(){');
     strList.Add('      /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!');
     strList.Add('              if (enabled) {');
     strList.Add('                 controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!');
     strList.Add('              }');
     strList.Add('           };');
     strList.Add('      };');
     strList.Add('      setOnClickListener(onClickListener);');
     strList.Add('   } //end constructor');
     strList.Add('   ');
     strList.Add('   public void jFree() {');
     strList.Add('      if (parent != null) { parent.removeView(this); }');
     strList.Add('      //free local objects...');
     strList.Add('      lparams = null;');
     //strList.Add('      parent = null;');
     strList.Add('      setOnClickListener(null);');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void SetViewParent(ViewGroup _viewgroup) {');
     strList.Add('      if (parent != null) { parent.removeView(this); }');
     strList.Add('      parent = _viewgroup;');
     strList.Add('      parent.addView(this,lparams);');
     strList.Add('      mRemovedFromParent = false;');
     strList.Add('   }');
     strList.Add('   ');
     strList.Add('   public void RemoveFromViewParent() {');
     strList.Add('      if (!mRemovedFromParent) {');
     strList.Add('         this.setVisibility(android.view.View.INVISIBLE);');
     strList.Add('         if (parent != null)');
     strList.Add('    	       parent.removeView(this);');
     strList.Add('	   mRemovedFromParent = true;');
     strList.Add('	}');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public View GetView() {');
     strList.Add('      return this;');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void SetLParamWidth(int _w) {');
     strList.Add('      lparamW = _w;');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void SetLParamHeight(int _h) {');
     strList.Add('      lparamH = _h;');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {');
     strList.Add('      marginLeft = _left;');
     strList.Add('      marginTop = _top;');
     strList.Add('      marginRight = _right;');
     strList.Add('      marginBottom = _bottom;');
     strList.Add('      lparamH = _h;');
     strList.Add('      lparamW = _w;');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void AddLParamsAnchorRule(int _rule) {');
     strList.Add('      lparamsAnchorRule[countAnchorRule] = _rule;');
     strList.Add('      countAnchorRule = countAnchorRule + 1;');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void AddLParamsParentRule(int _rule) {');
     strList.Add('      lparamsParentRule[countParentRule] = _rule;');
     strList.Add('      countParentRule = countParentRule + 1;');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void SetLayoutAll(int _idAnchor) {');
     strList.Add('  	lparams.width  = lparamW;');
     strList.Add('	lparams.height = lparamH;');
     strList.Add('	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);');
     strList.Add('	if (_idAnchor > 0) {');
     strList.Add('	    for (int i=0; i < countAnchorRule; i++) {');
     strList.Add('		lparams.addRule(lparamsAnchorRule[i], _idAnchor);');
     strList.Add('	    }');
     strList.Add('	}');
     strList.Add('      for (int j=0; j < countParentRule; j++) {');
     strList.Add('         lparams.addRule(lparamsParentRule[j]);');
     strList.Add('      }');
     strList.Add('      this.setLayoutParams(lparams);');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('   public void ClearLayoutAll() {');
     strList.Add('	for (int i=0; i < countAnchorRule; i++) {');
     strList.Add('  	   lparams.removeRule(lparamsAnchorRule[i]);');
     strList.Add('    	}');
     strList.Add('  ');
     strList.Add('	for (int j=0; j < countParentRule; j++) {');
     strList.Add('   	   lparams.removeRule(lparamsParentRule[j]);');
     strList.Add('	}');
     strList.Add('	countAnchorRule = 0;');
     strList.Add('	countParentRule = 0;');
     strList.Add('   }');
     strList.Add(' ');
     strList.Add('   public void SetId(int _id) { //wrapper method pattern ...');
     strList.Add('      this.setId(_id);');
     strList.Add('   }');
     strList.Add('  ');
     strList.Add('  //write others [public] methods code here......');
     strList.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('  ');
     strList.Add('} //end class');
     clipBoard.Clear;
     //ShowMessage(strList.Text);
     clipBoard.AsText:= strList.Text;
     strList.Free;
     clipBoard.Free;
   end;
end;

procedure TFormAndroidProject.PopupMenu4Close(Sender: TObject);
var
 AProcess: TProcess;
 iconPath, regFile, userTab: string;
 //auxStr, bufStr: string;
 strList: TStringList;
 i: integer;
 frm: TFormRegister;
begin
  if (Sender as TMenuItem).Caption <> 'Cancel' then
  begin
    if Pos('unit ', SynMemo2.Lines.Strings[0] ) = 0  then  // In case Substr isn't found, 0 is returned. The search is case-sensitive.
    begin
       ShowMessage('You do not have the code to create a component!');
       Exit;
    end;
    frm:= TFormRegister.Create(nil);
    frm.OpenDialog2.InitialDir:= FPathToWizardCode+DirectorySeparator;
    frm.Edit2.Text:= FPathToWizardCode+DirectorySeparator+'register_extras.pas';
    if frm.ShowModal = mrOK then
    begin
      iconPath:= frm.Edit1.Text;
      regFile:=  frm.Edit2.Text;
      if iconPath <> '' then
      begin
         if iconPath <> FPathToWizardCode+DirectorySeparator+LowerCase(FJavaClassName)+'.png' then
            CopyFile(iconPath,FPathToWizardCode+DirectorySeparator+LowerCase(FJavaClassName)+'.png');
         try
           AProcess := TProcess.Create(nil);
           AProcess.CurrentDirectory:= FPathToWizardCode;
           AProcess.Executable:= FPathToWizardCode+DirectorySeparator+'lazres.exe';
           {$IFDEF Linux}
              AProcess.Executable:= FPathToWizardCode+DirectorySeparator+'lazres';
           {$Endif}
           {$IFDEF Darwin}
              AProcess.Executable:= FPathToWizardCode+DirectorySeparator+'lazres.app';
           {$Endif}
           AProcess.Parameters.Add(LowerCase(FJavaClassName)+'_icon.lrs');
           AProcess.Parameters.Add(LowerCase(FJavaClassName)+'.png');
           AProcess.Options:= AProcess.Options + [poWaitOnExit];
           AProcess.Execute;
         finally
           AProcess.Free;
           strList:= TStringList.Create;
           if regFile <> '' then
           begin
             strList.LoadFromFile(regFile);
             if Pos('_Template', regFile) > 0 then
             begin
               userTab:= InputBox('Register [Tab] Component', 'Tab Name', 'myTab');
               regFile:= StringReplace(regFile,'_Template','_'+StringReplace(userTab,' ','_',[rfReplaceAll]),[]);

               strList.Strings[0]:= 'unit register_'+StringReplace(userTab,' ','_',[rfReplaceAll])+';';
               strList.Text:= StringReplace(strList.Text,'Template', userTab,[]);
             end;
             i:= 0;
             while i < strList.Count-1 do
             begin
               if Pos('Classes,', strList.strings[i]) > 0 then
               begin
                 Inc(i);
                 strList.Insert(i, '  '+Copy(LowerCase(FJavaClassName),2,Length(FJavaClassName))+',');
               end else
               if Pos('begin', strList.strings[i]) > 0 then
               begin
                  Inc(i);
                  strList.Insert(i, '  {$I '+LowerCase(FJavaClassName)+'_icon.lrs}');
               end else
               if Pos('[', strList.strings[i]) > 0 then
               begin
                  if Pos(']', strList.strings[i+1]) > 0 then
                  begin
                     Inc(i);
                     strList.Insert(i, '      '+FJavaClassName);
                  end
                  else
                  begin
                     Inc(i);
                     strList.Insert(i, '      '+FJavaClassName+',');
                  end;
               end;
               Inc(i);
             end;
             //FPathToWizardCode+DirectorySeparator+'reg_extras.pas'
             strList.SaveToFile(regFile);
           end;
           strList.Free;
           SynMemo2.SelectAll;
           SynMemo2.CopyToClipboard;
           SynMemo2.ClearSelection;
           SynMemo2.PasteFromClipboard;
           SynMemo2.Lines.SaveToFile(FPathToWizardCode+DirectorySeparator+Copy(LowerCase(FJavaClassName),2,Length(FJavaClassName))+'.pas');
           ShowMessage('Saved to: '+FPathToWizardCode+DirectorySeparator+Copy(LowerCase(FJavaClassName),2,Length(FJavaClassName))+'.pas');
         end; //finally
      end     //if iconPath
    end;      //showModal
    frm.Free;
  end;
end;

procedure TFormAndroidProject.PopupMenu4Popup(Sender: TObject);
begin
  //
end;

procedure TFormAndroidProject.ShellListView1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ShellTreeView1.Selected <> nil then
  begin
    if Pos(FMainActivity+'.java', ShellListView1.GetPathFromItem(ShellListView1.Selected)) > 0 then
      Handled:= False
    else
      Handled:= True;
  end;
end;

procedure TFormAndroidProject.ShellTreeView1Click(Sender: TObject);
begin
  StatusBar1.Panels.Items[0].Text:= ShellTreeView1.GetPathFromNode(ShellTreeView1.Selected);
end;

procedure TFormAndroidProject.FormCreate(Sender: TObject);
begin

  FHackJNIMethod:= False;

  FModuleType:= 0; //Using Android Bridges Components

  FSyntaxMode:= smDelphi;
  FImportsList:= TStringLIst.Create;
  Memo2List:= TStringList.Create;
  FListJNIBridge:= TStringList.Create;
  FHackListJNIHeader:= TStringList.Create;
  FHackListPascalClass:= TStringList.Create;
  FHackListPascalClassImpl:= TStringList.Create;

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

