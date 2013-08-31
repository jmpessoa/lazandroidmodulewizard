unit uFormAndroidProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterJava, SynHighlighterPas,
  Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  EditBtn, ShellCtrls, Menus, types;

type

  { TFormAndroidProject }

  TFormAndroidProject = class(TForm)
    bbOK: TBitBtn;
    BitBtn2: TBitBtn;
    ImageList1: TImageList;
    MenuItem1: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    PopupMenu1: TPopupMenu;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    StatusBar1: TStatusBar;
    SynFreePascalSyn1: TSynFreePascalSyn;
    SynJavaSyn1: TSynJavaSyn;
    SynMemo1: TSynMemo;
    SynMemo2: TSynMemo;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure PopupMenu1Close(Sender: TObject);
    procedure TabSheet3Clicked;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ShellListView1DblClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { private declarations }
    FJNIDecoratedMethodName: string;
    FJavaClassName: string;
    FPascalJNIInterfaceCode: string;
    FPathToJavaClass: string;
    FImportsList: TStringLIst;
    Memo2List: TStringList;

    function GetPascalCode(funcName, funcParam, funcResult: string): string;
    function GetFuncParam(funcParam: string): string;
    function GetParam(param: string): string;
    function GetParamSignature(param: string): string;
    function GetFuncResult(funcResult: string): string;
    function GetPascalJType(jType: string): string;
    function GetJSignature(params, res: string): string;
    function GetJTypeSignature(jType: string): string;
    function GetResultSignature(funcResult: string): string;
  public
    { public declarations }
    property JavaClassName: string read FJavaClassName write FJavaClassName;
    property PascalJNIInterfaceCode: string read FPascalJNIInterfaceCode write FPascalJNIInterfaceCode;
    property PathToJavaClass: string read FPathToJavaClass  write FPathToJavaClass;
    property JNIDecoratedMethodName: string read FJNIDecoratedMethodName write FJNIDecoratedMethodName;
  end;

var
  FormAndroidProject: TFormAndroidProject;

function TrimChar(query: string; delimiter: char): string;
function ReplaceChar(query: string; oldchar, newchar: char):string;
function SplitStr(var theString: string; delimiter: string): string;
function DeleteLineBreaks(const S: string): string;

implementation

{$R *.lfm}

{ TFormAndroidProject }

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
  Result:=GetPascalJType(funcResult)+'; cdecl;';
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
begin
  if jType <> '' then
  begin
    Result:= '';
    if Pos('String', jType) > 0 then Result:= 'Ljava/lang/String;'
    else if Pos('int', jType) > 0  then
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
       Result := 'Byte';
       if Pos('[', jType) > 0 then Result := '[B';
    end
    else if Pos('long', jType) > 0 then
    begin
       Result := 'J';
       if Pos('[', jType) > 0 then Result := '[J';
    end
    else if Pos('void', jType) > 0 then Result := 'V';

    if Result = '' then
    begin
        auxList:= TStringList.Create;
        for i:= 0 to FImportsList.Count-1 do
        begin
          auxList.Delimiter:='/';
          auxList.DelimitedText:= FImportsList.Strings[i];
          if CompareStr(jType, auxList.Strings[auxList.Count-1]) = 0 then
             Result:= FImportsList.Strings[i];
        end;
        auxList.Free;
    end;
    if Result = '' then Result:= 'UNKNOWN';
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
  auxParam:= ReplaceChar(Trim(funcParam),' ','~');
  paramList:= TStringList.Create;
  if Pos(',', auxParam) > 0 then
  begin
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
  Result:= '(PEnv: PJNIEnv; this: JObject; '+TrimChar(Result,';')+')';
  paramList.Free;
end;

function TFormAndroidProject.GetPascalCode(funcName, funcParam, funcResult: string): string;
var
  strList: TStringList;
  signature: string;
  auxFuncParam: string;
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
    strList.Add('  {your code....}');
    strList.Add('end;');
  end
  else
  begin
    signature:= 'function '+funcName+auxFuncParam+': '+ GetFuncResult(funcResult);
    strList.Add(signature);
    strList.Add('begin');
    strList.Add('  {your code....}');
    strList.Add('  {Result:=;}');
    strList.Add('end;');
  end;
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
  auxParam:= ReplaceChar(Trim(params),' ','~');
  paramList:= TStringList.Create;
  if Pos(',', auxParam) > 0 then
  begin
    paramList.Delimiter:=',';
    paramList.CommaText:= auxParam;
    count:= paramList.Count;
    for k:= 0 to count-1 do
    begin
      Result:= Result+GetParamSignature(TrimChar(paramList.Strings[k],'~'));
    end;
  end
  else
  begin
    Result:= Result+GetParamSignature(TrimChar(auxParam,'~'));
  end;
  Result:= Result+ ')'+GetParamSignature(res);
  paramList.Free;
end;

procedure TFormAndroidProject.TabSheet3Clicked;
var
  pNative, pPublic, pComment1, pSemicolon: integer;
  s1, s2: string;
  i, p1, p2: integer;
  strList, Memo3List, Memo4List, Memo5List, Memo6List: TStringList;
  auxStr, auxName, auxParam, strPascalCode, auxSignature, auxPathJNI,
  strNativeMethodsHeader, strNativeMethodsBody, methSignature, methName, pathToClassName: string;
  strOnLoadList: TStringList;
begin
  if ShellListView1.Selected <> nil then
  begin
    Memo2List.Clear;
    SynMemo2.Clear;
    i:= 0;
    strList:= TStringList.Create;
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
    for i:=0 to strList.Count-1 do
    begin
       s1:= strList.Strings[i];
       pPublic:= Pos('public ', s1);
       pComment1:= Pos('//', s1);
       if pComment1 > 0 then
       begin
          if pPublic < pComment1 then
          begin
            if s1 <> '' then Memo2List.Add(s1);
          end;
       end
       else
       begin
          if s1 <> '' then Memo2List.Add(s1);
       end;
    end;
    strList.Free;
    strList:= TStringList.Create;
    Memo3List:= TStringList.Create;
    Memo4List:= TStringList.Create;
    Memo5List:= TStringList.Create;
    Memo6List:= TStringList.Create;

    Memo6List.Add('exports');
    Memo6List.Add('  JNI_OnLoad name ''JNI_OnLoad'',');
    Memo6List.Add('  JNI_OnUnload name ''JNI_OnUnload'',');

    strNativeMethodsHeader:= 'const NativeMethods:array[0..'+
                              IntToStr(Memo2List.Count-1)+'] of JNINativeMethod = (';
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

      strNativeMethodsBody:= strNativeMethodsBody +
       '   (name:'''+ methName + ''';'+LineEnding +
       '    signature:'''+ methSignature+''';'+ LineEnding +
       '    fnPtr:@'+ methName + ';)';

       if i < (Memo2List.Count - 1) then
         strNativeMethodsBody:= strNativeMethodsBody+','+LineEnding
       else
         strNativeMethodsBody:= strNativeMethodsBody+LineEnding;


      strPascalCode:= auxSignature+GetPascalCode(Trim(strList.Strings[strList.Count-1]) {funct},
                      Trim(auxParam),Trim(strList.Strings[strList.Count-2]){result});

      Memo5List.Add(strPascalCode);
      Memo6List.Add('  '+Trim(strList.Strings[strList.Count-1])+' name '''+
                       FJNIDecoratedMethodName+'_'+Trim(strList.Strings[strList.Count-1])+''',');
    end;
    strNativeMethodsHeader:= strNativeMethodsHeader + LineEnding +
                             strNativeMethodsBody+');'+ LineEnding;
    strOnLoadList:= TStringList.Create;
    strOnLoadList.Add('function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar; methods: PJNINativeMethod; countMethods:integer):integer;');
    strOnLoadList.Add('begin');
    strOnLoadList.Add('  Result:= JNI_FALSE;');
    strOnLoadList.Add('  curClass:= (PEnv^).FindClass(PEnv, className);');
    strOnLoadList.Add('  if curClass <> nil then');
    strOnLoadList.Add('  begin');
    strOnLoadList.Add('    if (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods) > 0 then Result:= JNI_TRUE;');
    strOnLoadList.Add('  end;');
    strOnLoadList.Add('end;');
    strOnLoadList.Add(' ');
    pathToClassName:= ReplaceChar(auxPathJNI, '_', '/');
    strOnLoadList.Add('function RegisterNativeMethods(PEnv: PJNIEnv): integer;');
    strOnLoadList.Add('begin');
    strOnLoadList.Add('  curClassPathName:= '''+pathToClassName+''';');
    strOnLoadList.Add('  Result:= RegisterNativeMethodsArray(PEnv, PChar(curClassPathName), @NativeMethods[0], Length(NativeMethods));');
    strOnLoadList.Add('end;');
    strOnLoadList.Add(' ');
    strOnLoadList.Add('function JNI_OnLoad(VM: PJavaVM; reserved: pointer): JInt; cdecl;');
    strOnLoadList.Add('var');
    strOnLoadList.Add('  PEnv: PPointer {PJNIEnv};');
    strOnLoadList.Add('begin');
    strOnLoadList.Add('  PEnv:= nil;');
    strOnLoadList.Add('  Result:= JNI_VERSION_1_6;');
    strOnLoadList.Add('  (VM^).GetEnv(VM, @PEnv, Result);');
    strOnLoadList.Add('  if PEnv <> nil then RegisterNativeMethods(PJNIEnv(PEnv));');
    strOnLoadList.Add('  curVM:= VM {PJavaVM};');
    strOnLoadList.Add('  curEnv:= PJNIEnv(PEnv);');
    strOnLoadList.Add('end;');
    strOnLoadList.Add(' ');
    strOnLoadList.Add('procedure JNI_OnUnload(VM: PJavaVM; reserved: pointer); cdecl;');
    strOnLoadList.Add('begin');
    strOnLoadList.Add('  if curEnv <> nil then (curEnv^).UnregisterNatives(curEnv, curClass);');
    strOnLoadList.Add('  curClass:= nil;');
    strOnLoadList.Add('  curEnv:= nil;');
    strOnLoadList.Add('  curVM:= nil;');
    strOnLoadList.Add('  Application.Terminate;');
    strOnLoadList.Add('  FreeAndNil(Application);');
    strOnLoadList.Add('end;');

    auxStr:= Memo6List.Strings[Memo6List.Count-1];

    Memo6List.Strings[Memo6List.Count-1]:= ReplaceChar(auxStr,',',';');
    FPascalJNIInterfaceCode:= Memo5List.Text + strNativeMethodsHeader + LineEnding+
                              strOnLoadList.Text + LineEnding+Memo6List.Text;

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
   if PageControl1.ActivePage = TabSheet3 then TabSheet3Clicked;
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
    // LabelJClass.Caption:= ShellListView1.GetPathFromItem(ShellListView1.Selected);

     Memo2List.Clear;
     SynMemo2.Lines.Clear;

     pathList:= TStringList.Create;

     FPathToJavaClass:= ShellListView1.GetPathFromItem(ShellListView1.Selected);
     //FPathToJavaClass:= FLabelPath;
     StatusBar1.SimpleText:= FPathToJavaClass;

     pathList.Delimiter:='\';
     pathList.DelimitedText:= FPathToJavaClass;
     fileName:= pathList.Strings[pathList.Count-1];
    // LabelJClass.Caption:= fileName;

     FJavaClassName:= SplitStr(fileName, '.');
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
        if Pos('import ', auxStr) > 0 then
        begin
           SplitStr(auxStr,' ');
           auxStr:= ReplaceChar(auxStr,'.','/');
           FImportsList.Add('L'+trim(auxStr));
        end;
     end;
     pathList.Free;
     TabSheet3Clicked;
  end;
end;

procedure TFormAndroidProject.ToolButton1Click(Sender: TObject);
begin
   ShowMessage('LazAndroidModuleWizard 0.1 by jmpessoa');
end;

procedure TFormAndroidProject.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
   TabSheet3Clicked;
   FPascalJNIInterfaceCode:= SynMemo2.Lines.Text;
   if FPathToJavaClass <> '' then SynMemo1.Lines.SaveToFile(FPathToJavaClass);
   FImportsList.Free;
   Memo2List.Free;
end;

procedure TFormAndroidProject.FormShow(Sender: TObject);
begin
   SynMemo1.Lines.Clear;
   SynMemo2.Lines.Clear;
   PageControl1.ActivePage:= TabSheet1;
end;

procedure TFormAndroidProject.PopupMenu1Close(Sender: TObject);
var
  str: string;
begin
  str:='{var jstr: JString; str:string}'+ LineEnding;
  str:= str + 'jstr:= (PEnv^).NewStringUTF(PEnv,PChar(str));';
  SynMemo2.InsertTextAtCaret(str);
end;

procedure TFormAndroidProject.FormCreate(Sender: TObject);
begin
  FImportsList:= TStringLIst.Create;
  Memo2List:= TStringList.Create;
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

function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
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

end.

