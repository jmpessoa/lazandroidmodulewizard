unit uformjnirawlibsignature;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, StrUtils,
  Buttons;

type

  { TFormJniRawLibSignature }

  TFormJniRawLibSignature = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    NativeMethodMemo: TMemo;
    JniLibraryContentMemo: TMemo;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private

  public
    //JClassName: string;
    FullPackageName: string;
    RawJniJClassName: string;
    RawJniJClassWrapper: TStringList;

  end;

var
  FormJniRawLibSignature: TFormJniRawLibSignature;

implementation

{$R *.lfm}

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


//********* JNI raw library support ******
(*
jni reference type

jboolean=byte;        // unsigned 8 bits
jbyte=shortint;       // signed 8 bits
jchar=word;           // unsigned 16 bits
jshort=smallint;      // signed 16 bits
jint=longint;         // signed 32 bits
jlong=int64;          // signed 64 bits
jfloat=single;        // 32-bit IEEE 754
jdouble=double;       // 64-bit IEEE 754
jsize=jint;            // "cardinal indices and sizes"

// Reference type
jobject=pointer;
jclass=jobject;
jstring=jobject;
jarray=jobject;
jobjectArray=jarray;
jbooleanArray=jarray;
jbyteArray=jarray;
jcharArray=jarray;
jshortArray=jarray;
jintArray=jarray;
jlongArray=jarray;
jfloatArray=jarray;
jdoubleArray=jarray;
*)

function GetJNIType(jfullparam: string): string;   //int y
var
  jType, pType: string;
  param: string;
begin
    pType:= 'jobject';

    param:= Trim(jfullparam);
    jType:= SplitStr(param, ' '); // --> jType = int; param = y;

    if Pos('String', jType) > 0 then
    begin
      pType:= 'jstring';
      if Pos('String[', jType) > 0 then pType:= 'jstringArray'; //need def type: jstringArray = jobjec
    end
    else if Pos('int', jType) > 0  then  //The search is case-sensitive!
    begin
       pType := 'jint';
       if Pos('[', jType) > 0 then pType := 'jintArray';
    end
    else if Pos('double',jType) > 0 then
    begin
       pType := 'jdouble';
       if Pos('[', jType) > 0 then pType := 'jdoubleArray';
    end
    else if Pos('float', jType) > 0 then
    begin
       pType := 'jfloat';
       if Pos('[', jType) > 0 then pType := 'jfloatArray';
    end
    else if Pos('char', jType) > 0 then
    begin
       pType := 'jchar';
       if Pos('[', jType) > 0 then pType := 'jcharArray';
    end
    else if Pos('short', jType) > 0 then
    begin
       pType := 'jshort';
       if Pos('[', jType) > 0 then pType := 'jshortArray';
    end
    else if Pos('boolean', jType) > 0 then
    begin
       pType := 'jboolean';
       if Pos('[', jType) > 0 then pType := 'jbooleanArray';
    end
    else if Pos('byte', jType) > 0 then
    begin
       pType := 'jbyte';
       if Pos('[', jType) > 0 then pType := 'jbyteArray';
    end
    else if Pos('long', jType) > 0 then
    begin
       pType := 'jlong';
       if Pos('[', jType) > 0 then pType := 'jlongArray';
    end;

    if  param <> '' then
      Result:= param + ':' + pType  // "y:jint"
    else
      Result:= pType;

end;

function GetJNIMethodSignature(const methodNative: string; fullpackName: string; jwrapperclass: string; out exportSignature: string): string;
var
  signature, auxPackName: string;
  method, params: string;
  i, d, p, p1, p2: integer;
  listParam: TStringList;
  funcTypeReturn: string;
begin
  listParam:= TStringList.Create;

  funcTypeReturn:= '';
  auxPackName:= StringReplace(fullpackName, '.', '_', [rfReplaceAll]);

  p:= Pos('native', methodNative);
  method:= Copy(methodNative, p+Length('native'), MaxInt);
  p1:= Pos('(', method);
  p2:= PosEx(')', method, p1 + 1);
  d:=(p2-p1);

  params:= Copy(method, p1+1, d-1); //long elapsedTimeMillis
                                    //int state, String phoneNumber
  method:= Copy(method, 1, p1-1);
  method:= Trim(method);

  funcTypeReturn:= Trim(SplitStr(method, ' '));

  method:= Trim(method);

  signature:= '(env:PJNIEnv;this:jobject';
  if Length(params) > 3 then
  begin
    listParam.Delimiter:= ',';
    listParam.StrictDelimiter:= True;
    listParam.DelimitedText:= params;
    for i:= 0 to listParam.Count-1 do
    begin
        signature:= signature + ';' + GetJNIType(Trim(listParam.Strings[i]));
    end;
  end;

  if funcTypeReturn = 'void' then
  begin
    Result:= 'procedure '+method+signature+'); cdecl;';
    exportSignature:= method + ' name '  + '''Java_'+auxPackName+'_'+jwrapperclass+'_'+method+'''';
  end
  else
  begin
    Result:= 'function '+method+signature+'):'+GetJNIType(funcTypeReturn)+'; cdecl;';
    exportSignature:= method + ' name '  + '''Java_'+auxPackName+'_'+jwrapperclass+'_'+method+'''';
  end;

  listParam.Free;
end;

procedure ProduceJNISignatures(nativeMethodList: TStrings;
                               fullPackageName: string; jclassWrapper: string;
                               out jniSignatureList: TStringList;
                               out jniExportSignatureList: TStringList);
var
  auxList: TStringList;
  i, count: integer;
  signature, outExportsSignature: string;
begin
  if  nativeMethodList = nil then Exit;
  if  jniSignatureList = nil then Exit;
  if  jniExportSignatureList = nil then Exit;

  auxList:= TStringList.Create;
  count:= nativeMethodList.Count;
  for i:=0 to count-1 do
  begin
     signature:= GetJNIMethodSignature(nativeMethodList.Strings[i], fullPackageName, jclassWrapper, outExportsSignature);
     jniSignatureList.Add(signature);
     jniExportSignatureList.Add(outExportsSignature);
  end;
  auxList.Free;
end;

procedure ProduceJWrapperClass(nativeMethodList: TStrings; packageName: string;
                               jwrapperClass: string;  out jwrapperClassList: TStringList);
var
   i, count: integer;
begin
    if  nativeMethodList = nil then Exit;
    if  jwrapperClassList = nil then Exit;

    jwrapperClassList.Clear;
    jwrapperClassList.Add('package '+packageName+';');
    jwrapperClassList.Add(' ');
    jwrapperClassList.Add('import android.util.Log;');
    jwrapperClassList.Add(' ');
    jwrapperClassList.Add('public class '+jwrapperClass+' {');
    jwrapperClassList.Add('    static {');
    jwrapperClassList.Add('        try {');
    jwrapperClassList.Add('            System.loadLibrary("'+Lowercase(jwrapperClass)+'");');
    jwrapperClassList.Add('        }');
    jwrapperClassList.Add('        catch (UnsatisfiedLinkError e) {');
    jwrapperClassList.Add('            Log.e("Error loading JNI lib <'+Lowercase(jwrapperClass)+'>", "exception", e);');
    jwrapperClassList.Add('        }');
    jwrapperClassList.Add('    }');
    count:= nativeMethodList.Count;
    for i:= 0 to count-1 do
    begin
       jwrapperClassList.Add('    '+nativeMethodList.Strings[i]);
    end;
    jwrapperClassList.Add('}');

end;

procedure ProduceJNILibrarySignatures(jniSignatureList: TStringList; jniExportSignatureList: TStringList;  out jniLibrarySignatureList: TStringList);
var
 i, count: integer;
 ch: char;
begin
  if  jniSignatureList = nil then Exit;
  if  jniExportSignatureList = nil then Exit;
  if  jniLibrarySignatureList = nil then Exit;

  jniLibrarySignatureList.Add('type');
  jniLibrarySignatureList.Add('  jstringArray = jobject;');
  jniLibrarySignatureList.Add(' ');

  count:= jniSignatureList.Count;
  for i:= 0 to count-1 do
  begin
     jniLibrarySignatureList.Add(jniSignatureList.Strings[i]);
     jniLibrarySignatureList.Add('begin');
     jniLibrarySignatureList.Add('    //');
     jniLibrarySignatureList.Add('end;');
     jniLibrarySignatureList.Add(' ');
  end;

  jniLibrarySignatureList.Add(' ');
  jniLibrarySignatureList.Add('exports');

  count:= jniExportSignatureList.Count;
  ch:= ',';
  if count = 1 then ch:= ';';

  for i:= 0 to count-1 do
  begin
     jniLibrarySignatureList.Add('   '+jniExportSignatureList.Strings[i] + ch);
     if i = count-2 then ch:= ';';
  end;

end;
//*************************

{ TFormJniRawLibSignature }

procedure TFormJniRawLibSignature.SpeedButton1Click(Sender: TObject);
var
  i,  count: integer;
  auxList: TStringList;
  jniSignatureList, jniExportSignatureList: TStringList;
begin

  auxList:= TStringList.Create;
  jniSignatureList:= TStringList.Create;
  jniExportSignatureList:= TStringList.Create;

  if RawJniJClassWrapper = nil then
    RawJniJClassWrapper:= TStringList.Create;

  if RawJniJClassWrapper.Count = 0 then
  begin
     ProduceJWrapperClass(NativeMethodMemo.Lines, fullPackageName, RawJniJClassName, {out} RawJniJClassWrapper);
  end;

  jniSignatureList.Clear;
  jniExportSignatureList.Clear;

  ProduceJNISignatures(NativeMethodMemo.Lines, fullPackageName, RawJniJClassName, {out} jniSignatureList, {out} jniExportSignatureList);

  auxList.Clear;
  ProduceJNILibrarySignatures(jniSignatureList, jniExportSignatureList, {out} auxList);

  count:= auxList.Count;
  for i:= 0 to count-1 do
  begin
     JniLibraryContentMemo.Lines.Add(auxList.Strings[i]);
  end;

  auxList.Free;
  jniSignatureList.Free;
  jniExportSignatureList.Free;
end;

function GetJClassName(content: string): string;
var
  p, i: integer;
  c: char;
  jclassName: string;
begin
  p:= Pos(' class ', content);
  p:= p + Length(' class ');

  i:= p;
  c:= content[i];
  while c <> '{' do
  begin
       i:= i + 1;
       c:= content[i];
  end;
  jclassName:= Trim(Copy(content, p, i-p));
  if Pos(' ', jclassName) <= 0 then
  begin
    Result:= jclassName;
  end
  else   //App extends AppCompatActivity
  begin
     p:= Pos(' ', jclassName);
     Result:= Trim(Copy(jclassName, 1, p));
  end;
end;

procedure TFormJniRawLibSignature.SpeedButton2Click(Sender: TObject);
var
  filename: string;
  i, count: integer;
  jclassname: string;
begin
  if OpenDialog1.Execute then
  begin
      if RawJniJClassWrapper = nil then
         RawJniJClassWrapper:= TStringList.Create
      else
         RawJniJClassWrapper.Clear;

      filename:= OpenDialog1.FileName;
      if Pos('.java', filename) > 0 then
      begin
         RawJniJClassWrapper.LoadFromFile(filename);
         jclassname:= GetJClassName(RawJniJClassWrapper.Text);
      end;
      count:= RawJniJClassWrapper.Count;
      for i:=0 to count-1 do
      begin
         if Pos(' native ', RawJniJClassWrapper.Strings[i]) > 0 then
              NativeMethodMemo.Lines.Add(RawJniJClassWrapper.Strings[i]);
      end;
      RawJniJClassName:= '';
      if NativeMethodMemo.Lines.Count > 0 then
      begin
        RawJniJClassName:= jclassname;
      end
      else
      begin
         RawJniJClassWrapper.Clear;
      end;
  end;
end;

procedure TFormJniRawLibSignature.FormCreate(Sender: TObject);
begin
  RawJniJClassWrapper:= TStringList.Create;
end;

procedure TFormJniRawLibSignature.FormDestroy(Sender: TObject);
begin
  if RawJniJClassWrapper <> nil then RawJniJClassWrapper.Free;
end;

end.

