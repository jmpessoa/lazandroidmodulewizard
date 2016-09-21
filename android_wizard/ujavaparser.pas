unit uJavaParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TLexType = (ltError, ltIdent, ltNumber, ltString, ltDelim);

  { TJavaParser }

  TJavaParser = class
  private
    FParsed: Boolean;
    FStream: TStream;
    FMemStream: TMemoryStream;
    FImports, // used to create signatures <JavaClass>="full class name", e.g. String=java.lang.String
    FPascalJNI: TStringList;
    FStreamSize: Int64;
    FRootClass: string;
    FCurChar: Char;
    FCurLex: string;
    FCurLexType: TLexType;
    FNativeMethods: TFPList;
    function gc: Char;
    function gl: TLexType;
    procedure ClearNativeMethods;
    procedure MakePascalJNI(Bodies: TStrings);
    procedure Parse;
    procedure ParseClass;
    procedure ParseImport;
    procedure ParseInterfaceClass;
    procedure ParsePackage;
    function ReadJavaType(out signature: string): string;
    procedure ReadTill(Token: string); inline;
    procedure ReadTillCurlBracketClose;
  public
    constructor Create(Stream: TStream);
    constructor Create(FileName: string);
    constructor Create(Strings: TStrings);
    destructor Destroy; override;

    function GetPascalJNIInterfaceCode(Bodies: TStrings): string;
    function GetPascalJNIInterfaceCode(BodiesFilePath: string): string;
  end;

implementation

type

  { TNativeMetodDesc }

  TNativeMetodDesc = class
  public
    nativeName: string;
    Signature: string;
    Params: string;     // pascal
    ResultType: string; // pascal
    constructor Create(AMethodName, ASignature, AParams, AResultType: string);
  end;

{ TNativeMetodDesc }

constructor TNativeMetodDesc.Create(AMethodName, ASignature, AParams, AResultType: string);
begin
  nativeName := AMethodName;
  Signature := ASignature;
  Params := AParams;
  ResultType := AResultType;
end;

{ TJavaParser }

function TJavaParser.gc: Char;
begin
  if FStream.Position < FStreamSize then
    FStream.Read(FCurChar, 1)
  else
    FCurChar := #0;
  Result := FCurChar;
end;

function TJavaParser.gl: TLexType;
begin
  repeat
    case FCurChar of
    #0:
      begin
        FCurLexType := ltError;
        FCurLex := '';
        Exit(ltError);
      end;
    ' ', #9, #10, #13: gc;
    'a'..'z', 'A'..'Z', '_':
      begin
        Result := ltIdent;
        FCurLex := '';
        repeat
          FCurLex := FCurLex + FCurChar;
          gc;
        until not (FCurChar in ['a'..'z', 'A'..'Z', '_', '0'..'9']);
        { it maybe keyword but it is not significant }
        FCurLexType := Result;
        Exit;
      end;
    '0'..'9': // not fully implemented (not needed)
      begin
        Result := ltNumber;
        FCurLex := '';
        repeat
          FCurLex := FCurLex + FCurChar;
          gc;
        until not (FCurChar in ['0'..'9']);
        FCurLexType := Result;
        Exit;
      end;
    '/':
      begin
        gc;
        if FCurChar = '/' then
        begin
          { one line comment }
          while not (FCurChar in [#0, #10, #13]) do gc;
        end else
        if FCurChar = '*' then
        begin
          { multiline comment }
          repeat
            if FCurChar = '*' then
            begin
              gc;
              if FCurChar = '/' then
              begin
                gc;
                Break;
              end
            end else
              gc;
          until FCurChar = #0;
        end;
      end;
    '"':
      begin
        Result := ltString;
        FCurLex := FCurChar;
        repeat
          gc;
          FCurLex := FCurLex + FCurChar;
          if FCurChar = '\' then
          begin
            gc;
            FCurLex := FCurLex + FCurChar;
            gc;
            FCurLex := FCurLex + FCurChar;
          end
        until FCurChar = '"';
        gc;
        FCurLexType := Result;
        Exit;
      end;
    else { one char delim }
      Result := ltDelim;
      FCurLex := FCurChar;
      gc;
      FCurLexType := Result;
      Exit;
    end;
  until False;
end;

procedure TJavaParser.ClearNativeMethods;
var
  i: Integer;
begin
  for i := 0 to FNativeMethods.Count - 1 do
    TObject(FNativeMethods[i]).Free;
  FNativeMethods.Clear;
end;

procedure TJavaParser.MakePascalJNI(Bodies: TStrings);

  procedure RemoveLastChar;
  var
    i: Integer;
    str: string;
  begin
    i := FPascalJNI.Count - 1;
    str := FPascalJNI[i];
    SetLength(str, Length(str) - 1);
    FPascalJNI[i] := str;
  end;

var
  i: Integer;
  cls, str: string;
begin
  FPascalJNI.Clear;

  cls := StringReplace(FRootClass, '.', '_', [rfReplaceAll]);
  if FNativeMethods.Count = 0 then
    raise Exception.Create('[MakePascalJNI] No native methods in public class!');
  for i := 0 to FNativeMethods.Count - 1 do
    with TNativeMetodDesc(FNativeMethods[i]) do
    begin
      FPascalJNI.Add('{ Class:     ' + cls);
      FPascalJNI.Add('  Method:    ' + nativeName);
      FPascalJNI.Add('  Signature: ' + Signature + ' }');
      if ResultType = '' then
        str := 'procedure ' + nativeName + Params + ';'
      else
        str := 'function ' + nativeName + Params + ': ' + ResultType + ';';
      str := str + ' cdecl;';
      FPascalJNI.Add(str);
      FPascalJNI.Add('begin');
      if Assigned(Bodies) then
        str := Bodies.Values[nativeName]
      else
        str := '';
      if str = '' then
        str := '// TODO ?'
      else
        if ResultType <> '' then
          str := 'Result:=' + str;
      FPascalJNI.Add('  ' + str);
      FPascalJNI.Add('end;');
      FPascalJNI.Add('');
    end;
  FPascalJNI.Add(Format('const NativeMethods:array[0..%d] of JNINativeMethod = (',
    [FNativeMethods.Count - 1]));
  for i := 0 to FNativeMethods.Count - 1 do
    with TNativeMetodDesc(FNativeMethods[i]) do
    begin
      FPascalJNI.Add(Format('   (name:''%s'';', [nativeName]));
      FPascalJNI.Add(Format('    signature:''%s'';', [Signature]));
      FPascalJNI.Add(Format('    fnPtr:@%s;),', [nativeName]));
    end;
  i := FPascalJNI.Count - 1;
  str := FPascalJNI[i];
  SetLength(str, Length(str) - 1);
  FPascalJNI[i] := str;
  FPascalJNI.Add(');');
  FPascalJNI.Add('');

  str := StringReplace(FRootClass, '.', '/', [rfReplaceAll]);
  FPascalJNI.Add('function RegisterNativeMethodsArray(PEnv: PJNIEnv; className: PChar; methods: PJNINativeMethod; countMethods:integer):integer;');
  FPascalJNI.Add('var');
  FPascalJNI.Add('  curClass: jClass;');
  FPascalJNI.Add('begin');
  FPascalJNI.Add('  Result:= JNI_FALSE;');
  FPascalJNI.Add('  curClass:= (PEnv^).FindClass(PEnv, className);');
  FPascalJNI.Add('  if curClass <> nil then');
  FPascalJNI.Add('  begin');
  FPascalJNI.Add('    if (PEnv^).RegisterNatives(PEnv, curClass, methods, countMethods) > 0 then Result:= JNI_TRUE;');
  FPascalJNI.Add('  end;');
  FPascalJNI.Add('end;');
  FPascalJNI.Add('');
  FPascalJNI.Add('function RegisterNativeMethods(PEnv: PJNIEnv; className: PChar): integer;');
  FPascalJNI.Add('begin');
  FPascalJNI.Add('  Result:= RegisterNativeMethodsArray(PEnv, className, @NativeMethods[0], Length(NativeMethods));');
  FPascalJNI.Add('end;');
  FPascalJNI.Add('');
  FPascalJNI.Add('function JNI_OnLoad(VM: PJavaVM; {%H-}reserved: pointer): JInt; cdecl;');
  FPascalJNI.Add('var');
  FPascalJNI.Add('  PEnv: PPointer;');
  FPascalJNI.Add('  curEnv: PJNIEnv;');
  FPascalJNI.Add('begin');
  FPascalJNI.Add('  PEnv:= nil;');
  FPascalJNI.Add('  Result:= JNI_VERSION_1_6;');
  FPascalJNI.Add('  (VM^).GetEnv(VM, @PEnv, Result);');
  FPascalJNI.Add('  if PEnv <> nil then');
  FPascalJNI.Add('  begin');
  FPascalJNI.Add('     curEnv:= PJNIEnv(PEnv);');
  FPascalJNI.Add('     RegisterNativeMethods(curEnv, ''' + str + ''');');
  FPascalJNI.Add('  end;');
  FPascalJNI.Add('  gVM:= VM; {AndroidWidget.pas}');
  FPascalJNI.Add('end;');
  FPascalJNI.Add('');
  FPascalJNI.Add('procedure JNI_OnUnload(VM: PJavaVM; {%H-}reserved: pointer); cdecl;');
  FPascalJNI.Add('var');
  FPascalJNI.Add('  PEnv: PPointer;');
  FPascalJNI.Add('  curEnv: PJNIEnv;');
  FPascalJNI.Add('begin');
  FPascalJNI.Add('  PEnv:= nil;');
  FPascalJNI.Add('  (VM^).GetEnv(VM, @PEnv, JNI_VERSION_1_6);');
  FPascalJNI.Add('  if PEnv <> nil then');
  FPascalJNI.Add('  begin');
  FPascalJNI.Add('    curEnv:= PJNIEnv(PEnv);');
  FPascalJNI.Add('    (curEnv^).DeleteGlobalRef(curEnv, gjClass);');
  FPascalJNI.Add('    gjClass:= nil; {AndroidWidget.pas}');
  FPascalJNI.Add('    gVM:= nil; {AndroidWidget.pas}');
  FPascalJNI.Add('  end;');
  FPascalJNI.Add('  gApp.Terminate;');
  FPascalJNI.Add('  FreeAndNil(gApp);');
  FPascalJNI.Add('end;');
  FPascalJNI.Add('');
  FPascalJNI.Add('exports');
  FPascalJNI.Add('  JNI_OnLoad name ''JNI_OnLoad'',');
  FPascalJNI.Add('  JNI_OnUnload name ''JNI_OnUnload'',');

  cls := 'Java_' + StringReplace(FRootClass, '.', '_', [rfReplaceAll]) + '_';
  for i := 0 to FNativeMethods.Count - 1 do
    with TNativeMetodDesc(FNativeMethods[i]) do
      FPascalJNI.Add('  ' + nativeName + ' name ''' + cls + nativeName + ''',');
  i := FPascalJNI.Count - 1;
  str := FPascalJNI[i];
  if str <> '' then
    str[Length(str)] := ';';
  FPascalJNI[i] := str;
end;

procedure TJavaParser.Parse;
begin
  ClearNativeMethods;
  FRootClass := '';
  gc; gl;
  repeat
    if FCurLexType = ltIdent then
      case FCurLex[1] of
      'c':
        if FCurLex = 'class' then ParseClass
        else gl;
      'i':
        if FCurLex = 'import' then ParseImport
        else gl;
      'p':
        if FCurLex = 'package' then ParsePackage
        else
        if FCurLex = 'public' then
        begin
          gl;
          if FCurLex = 'class' then
            ParseInterfaceClass
          // maybe "final", "abstract", etc. - not handled yet
          //else raise Exception.Create('"class" expected after "public"');
        end
        else gl;
      else
        gl;
      end
    else
      gl;
  until FCurLexType = ltError; { EOF }
  FParsed := True;
end;

procedure TJavaParser.ParseClass;
begin
  gl;
  ReadTillCurlBracketClose;
end;

procedure TJavaParser.ParseImport;
var s, cl: string;
begin
  gl;
  s := FCurLex;
  gl;
  while FCurLex = '.' do
  begin
    gl;
    s := s + '/' + FCurLex;
    cl := FCurLex;
    gl;
  end;
  if cl <> '*' then
    FImports.Values[cl] := 'L' + s + ';';
  gl;
end;

procedure TJavaParser.ParseInterfaceClass;
var
  natType, natName: string;
  s, sig, signature, params, typ: string;
begin
  gl;
  FRootClass := FRootClass + '.' + FCurLex;
  ReadTill('{');
  while FCurLex <> '}' do
  begin
    if FCurLexType = ltError then
      raise Exception.Create('[ParseInterfaceClass] Unexpected EOF');
    if FCurLex = '{' then ReadTillCurlBracketClose else
    if FCurLex = 'public' then
    begin
      gl;
      if FCurLex = 'native' then
      begin
        gl;
        natType := ReadJavaType(sig);
        natName := FCurLex;
        gl; // "("
        gl;
        signature := '(';
        params := 'PEnv: PJNIEnv; this: JObject;';
        while FCurLex <> ')' do
        begin
          typ := ReadJavaType(s);
          signature := signature + s;
          params := params + ' ' + FCurLex + ': ' + typ + ';';
          gl;
          if FCurLex = ',' then gl;
        end;
        signature := signature + ')' + sig;
        params := '(' + params;
        params[Length(params)] := ')';
        FNativeMethods.Add(TNativeMetodDesc.Create(natName, signature, params, natType));
        gl; //")"
        gl; //";"
      end;
    end else gl;
  end;
  gl;
end;

procedure TJavaParser.ParsePackage;
begin
  gl;
  while FCurLex <> ';' do
  begin
    FRootClass := FRootClass + FCurLex;
    gl;
  end;
end;

function TJavaParser.ReadJavaType(out signature: string): string;
begin
{http://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.7.16.1-130
    B 	byte
    C 	char
    D 	double
    F  	float
    I 	int
    J 	long
    S 	short
    Z 	boolean
    [ 	Array    }
  if FCurLexType <> ltIdent then
    raise Exception.Create('[ReadJavaType] incorrect lex="' + FCurLex + '"');
  signature := '';
  case FCurLex[1] of
  'b':
    if FCurLex = 'byte' then
      signature := 'B'
    else
    if FCurLex = 'boolean' then
      signature := 'Z';
  'c': if FCurLex = 'char' then signature := 'C';
  'd': if FCurLex = 'double' then signature := 'D';
  'f': if FCurLex = 'float' then signature := 'F';
  'i': if FCurLex = 'int' then signature := 'I';
  'l': if FCurLex = 'long' then signature := 'J';
  's': if FCurLex = 'short' then signature := 'S';
  'v': if FCurLex = 'void' then signature := 'V';
  end;
  if signature <> '' then
  begin
    Result := 'J' + FCurLex;
    Result[2] := upcase(Result[2]);
  end else begin
    if FCurLex = 'String' then
      Result := 'JString'
    else
      Result := 'JObject';
    signature := FImports.Values[FCurLex];
    if signature = '' then
      raise Exception.Create('[ReadJavaType] Cannot find path of class "' + FCurLex + '"');
  end;
  gl;
  while FCurLex = '[' do
  begin
    Result := Result + 'Array'; // see And_jni.pas: does not contain defs for [][]
    signature := '[' + signature;
    gl; // "]"
    gl;
  end;
  if signature = 'V' then Result := '';
end;

procedure TJavaParser.ReadTill(Token: string);
begin
  while (FCurLexType <> ltError) and (FCurLex <> Token) do gl;
  gl;
end;

procedure TJavaParser.ReadTillCurlBracketClose;
var k: Integer;
begin
  k := 0;
  repeat
    if FCurLexType = ltDelim then
    begin
      if FCurLex = '{' then
        Inc(k)
      else
      if FCurLex = '}' then
      begin
        Dec(k);
        if k <= 0 then
        begin
          gl;
          Exit;
        end;
      end;
    end;
    gl;
  until FCurLexType = ltError;
end;

constructor TJavaParser.Create(Stream: TStream);
begin
  FStream := Stream;
  FStreamSize := FStream.Size;
  FImports := TStringList.Create;
  FImports.Values['String'] := 'Ljava/lang/String;';
  FPascalJNI := TStringList.Create;
  FNativeMethods := TFPList.Create;
end;

constructor TJavaParser.Create(FileName: string);
begin
  FMemStream := TMemoryStream.Create;
  FMemStream.LoadFromFile(FileName);
  FMemStream.Position := 0;
  Create(FMemStream);
end;

constructor TJavaParser.Create(Strings: TStrings);
begin
  FMemStream := TMemoryStream.Create;
  Strings.SaveToStream(FMemStream);
  FMemStream.Position := 0;
  Create(FMemStream);
end;

destructor TJavaParser.Destroy;
begin
  ClearNativeMethods;
  FNativeMethods.Free;
  FMemStream.Free;
  FImports.Free;
  FPascalJNI.Free;
  inherited Destroy;
end;

function TJavaParser.GetPascalJNIInterfaceCode(Bodies: TStrings): string;
begin
  if not FParsed then
  begin
    Parse;
    MakePascalJNI(Bodies);
  end;
  Result := FPascalJNI.Text;
end;

function TJavaParser.GetPascalJNIInterfaceCode(BodiesFilePath: string): string;
var Bodies: TStringList;
begin
  Bodies := TStringList.Create;
  try
    Bodies.LoadFromFile(BodiesFilePath);
    Result := GetPascalJNIInterfaceCode(Bodies);
  finally
    Bodies.Free;
  end;
end;

end.

