unit ufrmCompCreate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterJava, SynHighlighterPas,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls, Menus, Clipbrd,
  StdCtrls, Buttons, SynEditTypes, Process, uregistercompform, inifiles,strutils,
  PackageIntf, LazIDEIntf, uformimportjarstuff, uFormComplements;

type

  { TFrmCompCreate }

  TFrmCompCreate = class(TForm)
    BitBtn1: TBitBtn;
    BitBtnJAR: TBitBtn;
    EditMainUnit: TEdit;
    GroupBoxJavaClass: TGroupBox;
    GroupBoxMainUnit: TGroupBox;
    Memo1: TMemo;
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
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenuDraftCode: TPopupMenu;
    PopupMenuRegister: TPopupMenu;
    RadioGroupPasInterface: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StatusBar1: TStatusBar;
    SynJavaSyn1: TSynJavaSyn;
    SynMemo1: TSynMemo;
    SynMemo2: TSynMemo;
    SynPasSyn1: TSynPasSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure BitBtnJARClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopupMenu1Close(Sender: TObject);
    procedure PopupMenu2Close(Sender: TObject);
    procedure RadioGroupPasInterfaceSelectionChanged(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
    FProjectModel: string;

    FHackListJNIHeader: TStringList;
    FHackListPascalClass: TStringList;
    FHackListPascalClassImpl: TStringList;
    Memo2List: TStringList;
    FImportsList: TStringLIst;

    FHackCreateParam: string;

    FHackCreateProperties: string;
    FPascalJNIInterfaceCode: string;
    FJavaClassName: string;
    FJNIDecoratedMethodName: string;
    FPathToJavaClass: string;

    FPathToJavaTemplates: string;  //C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\java
    FPathToLAMW: string;
    FFirstFocus: boolean;

    FPathToJARFile: string;
    FJARFilename:  string;
    FListJarClass: TStringList;
    FPathToJavaJDK: string;        //PathToJavaJDK=C:\Program Files\Java\jdk1.8.0_151
    //FNativeEventNamingBypass: string;

    FIsKotlin: boolean;

    procedure DoJavaParse(produceAll: boolean);
    procedure DoKotlinParse(produceAll: boolean);

    function SwapKotlinParams(params: string): string;
    function GetJavaTypeFromKotlin(ktType: string): string;
    function GetJavaSignatureFromKotlin(ktSign: string): string;
    function GetKotlinClassName(selList: TStringList): string;
    function GetKotlinClassConstructorSignature(selList: TStringList): string;
    function TryIsKotlinComplementary(selList: TStrings): boolean;

    procedure InsertJControlCodeTemplate(txt: string);
    function GetHackListPascalClassInterf(produceAll: boolean): string;
    function GetJSignature(params, res: string): string;
    function GetPascalCodeHack(funcName, funcParam, funcResult, jniSignature: string): string;
    function GetParamSignature(param: string): string;
    function GetJTypeSignature(jType: string): string;
    function GetParamNameHack(funcParam: string; var jParamSig: string): string;
    function GetPascalFuncResultHack(jType: string): string;
    function GetArrayTypeNameHack(paramType: string): string;
    function GetJParamHack(paramType: string): string;
    function GetMethodNameHack(jType: string): string;
    function GetArrayTypeByFuncResultHack(funcResult: string): string;
    procedure TryInsertJavaCreate(txt: string);
    procedure LoadSettings(const fileName: string);
    procedure AddComplements(javaclassName: string);
    function GetJavaClassName(selList: TStringList): string;

    function GetCleanDepData(aux: string): string;

    //native event interface...

    function GetNativePascalTypeSignature(jSignature: string): string;
    function TryNativeReConvertOutSignature(ptype: string): string;
    function GetNativeParamName(param: string): string;
    function TryNativeConvertParam(param: string): string;
    function TryNativeConvertSignature(param: string): string;
    function GetNativePascalFuncResultHack(jType: string): string;
    function GetNativePascalSignature(const methodNative: string; out eventname: string; out outType: string): string;
    function GetNativeOutPascalReturnInit(ptype: string): string;

    procedure GetNativeMethodList(selList: TStringList; nativeEventMethodList: TStringList; namingBypassList: TStringList);
    procedure GetNativeMethodInterfaceList(jclassname: string; nativeMethod: TStringList; namingBypass: TStringList; MemoLines: TStrings);

    procedure ProduceImportsDictionary();

  public
    { public declarations }
  end;

  function SplitStr(var theString: string; delimiter: string): string;
  function DeleteLineBreaks(const S: string): string;
  function ReplaceCharFirst(str: string; newChar: char): string;
  function TrimChar(query: string; delimiter: char): string;
  function ReplaceChar(query: string; oldchar, newchar: char):string;
  function LastPos(delimiter: string; str: string): integer;
  function RunCmdProcess(const cmd: string): integer;

var
  FrmCompCreate: TFrmCompCreate;

implementation

uses LazFileUtils;

{$R *.lfm}

procedure TFrmCompCreate.TryInsertJavaCreate(txt: string);
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
   if FileExistsUTF8(FPathToJavaClass) then
   begin
      fileList:= TStringList.Create;
      fileList.LoadFromFile(FPathToJavaClass);
      fileList.SaveToFile(FPathToJavaClass+'.bak');
      fileList.Free;
   end;
   SynMemo1.Lines.SaveToFile(FPathToJavaClass);
 end;
end;

function TFrmCompCreate.GetArrayTypeByFuncResultHack(funcResult: string): string;
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

function TFrmCompCreate.GetMethodNameHack(jType: string): string;
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

function TFrmCompCreate.GetJParamHack(paramType: string): string;
begin
   if (Pos(';', paramType) > 0) or (Pos('[', paramType) > 0) then Result:='l'
   else Result:= LowerCase(paramType);
end;

function TFrmCompCreate.GetArrayTypeNameHack(paramType: string): string;
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


function TFrmCompCreate.GetPascalFuncResultHack(jType: string): string;
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
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfJByte'; //array of shortint!  -128 + 127
  end
  else if Pos('long', jType) > 0 then
  begin
     Result := 'int64';
     if Pos('[', jType) > 0 then Result := 'TDynArrayOfInt64';
  end;

  if Result = 'jObject' then
      if Pos('[', jType) > 0 then Result := 'TDynArrayOfJObject';

end;


function TFrmCompCreate.GetParamNameHack(funcParam: string; var jParamSig: string): string;
var
  strType: string;
begin
   Result:= Trim(funcParam);
   strType:= SplitStr(Result, ' ');
   jParamSig:= GetJTypeSignature(Trim(strType));
   Result:= Trim(Result);
end;

function TFrmCompCreate.GetJTypeSignature(jType: string): string;
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
            Result:= 'L'+ ReplaceChar(auxStr,'.','/')+';';
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
          if Pos(jType+';',FImportsList.Strings[i]) > 0 then
          begin
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

function TFrmCompCreate.GetParamSignature(param: string): string;
var
  typeValue: string;
  nameValue: string;
begin
  nameValue:= TrimChar(param,'~');
  typeValue:= SplitStr(nameValue,'~');
  Result:= TrimChar(nameValue,'~');
  Result:= GetJTypeSignature(typeValue);
end;

procedure TFrmCompCreate.InsertJControlCodeTemplate(txt: string);
var
  strList: TStringList;
  txtCaption, newJavaClassName: string;
begin
   FIsKotlin:= False;

   txtCaption:= txt;
   if Pos('Java jControl', txtCaption) > 0 then
   begin
     newJavaClassName:= 'jMyControl';
     strList:= TStringList.Create;
     strList.Add(' ');
     strList.Add(' ');
     strList.Add('import android.content.Context;');
     strList.Add(' ');
     strList.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     strList.Add('/*jControl LAMW template*/');
     strList.Add(' ');
     strList.Add('public class '+newJavaClassName+' /*extends ...*/ {');
     strList.Add('  ');
     strList.Add('    private long pascalObj = 0;        //Pascal Object');
     strList.Add('    private Controls controls  = null; //Java/Pascal [events] Interface ...');
     strList.Add('    private Context  context   = null;');
     strList.Add('  ');
     strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('  ');
     strList.Add('    public '+newJavaClassName+'(Controls _ctrls, long _self) { //Add more others news "_xxx" params if needed!');
     strList.Add('       //super(_ctrls.activity);');
     strList.Add('       context   = _ctrls.activity;');
     strList.Add('       pascalObj = _self;');
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
     SynMemo1.Clear;
     SynMemo1.Lines.Text:= strList.Text;
     strList.Free;
   end;

   if Pos('Kotlin jControl', txtCaption) > 0 then
   begin
     FIsKotlin:= True;
     newJavaClassName:= 'KMyControl';
     strList:= TStringList.Create;
     strList.Add(' ');
     strList.Add(' ');
     strList.Add('import android.content.Context;');
     strList.Add(' ');
     strList.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     strList.Add('/*Kotlin jControl LAMW template*/');
     strList.Add(' ');
     strList.Add('class '+newJavaClassName+'(_ctrls: Controls, _self: Long)/*: ???*/ {');
     strList.Add('  ');
     strList.Add('    private var pascalObj: Long = 0    //Pascal Object');
     strList.Add('    private var controls: Controls? = null //Java/Pascal [events] Interface ...');
     strList.Add('    private var context: Context? = null');
     strList.Add('  ');
     strList.Add('    init {');
     strList.Add('       context = _ctrls.activity');
     strList.Add('       pascalObj = _self');
     strList.Add('       controls = _ctrls');
     strList.Add('    }');
     strList.Add('  ');
     strList.Add('    fun kFree() {');
     strList.Add('      //free local objects...');
     strList.Add('    }');
     strList.Add('  ');
     strList.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('  ');
     strList.Add('  //write others [public] methods code here......');
     strList.Add('  ');
     strList.Add('}');
     SynMemo1.Clear;
     SynMemo1.Lines.Text:= strList.Text;
     strList.Free;
   end;

   if Pos('Java jVisualControl', txtCaption) > 0 then
   begin
     newJavaClassName:= 'jMyVisualControl';
     strList:= TStringList.Create;
     strList.Add(' ');
     strList.Add(' ');
     strList.Add('import android.widget.RelativeLayout'); //dummy
     strList.Add('import android.content.Context;');
     strList.Add('import android.view.View;');
     strList.Add('import android.view.ViewGroup;');
     strList.Add(' ');
     strList.Add('/*Draft Java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     strList.Add('/*LAMW jVisualControl template*/');
     strList.Add('  ');
     strList.Add('public class '+newJavaClassName+' extends RelativeLayout /*dummy*/ { //please, fix what GUI object will be extended!');
     strList.Add(' ');
     strList.Add('    private long pascalObj = 0;        // Pascal Object');
     strList.Add('    private Controls controls  = null; //Java/Pascal [events] Interface ...');
     strList.Add('    private jCommons LAMWCommon;');
     strList.Add('    private Context context = null;');
     strList.Add(' ');
     strList.Add('    private OnClickListener onClickListener;   // click event');
     strList.Add('    private Boolean enabled  = true;           // click-touch enabled!');
     strList.Add(' ');
     strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('    public '+newJavaClassName+'(Controls _ctrls, long _self) { //Add more others news "_xxx" params if needed!');
     strList.Add(' ');
     strList.Add('       super(_ctrls.activity);');
     strList.Add('       context   = _ctrls.activity;');
     strList.Add('       pascalObj = _self;');
     strList.Add('       controls  = _ctrls;');
      strList.Add(' ');
     strList.Add('       LAMWCommon = new jCommons(this,context,pascalObj);');
     strList.Add(' ');
     strList.Add('       onClickListener = new OnClickListener(){');
     strList.Add('       /*.*/public void onClick(View view){     // *.* is a mask to future parse...;');
     strList.Add('               if (enabled) {');
     strList.Add('                  controls.pOnClickGeneric(pascalObj); //JNI event onClick!');
     strList.Add('               }');
     strList.Add('            };');
     strList.Add('       };');
     strList.Add('       setOnClickListener(onClickListener);');
     strList.Add('    } //end constructor');
     strList.Add(' ');
     strList.Add('    public void jFree() {');
     strList.Add('       //free local objects...');
     strList.Add('   	 setOnClickListener(null);');
     strList.Add('	 LAMWCommon.free();');
     strList.Add('    }');
     strList.Add('  ');
     strList.Add('    public void SetViewParent(ViewGroup _viewgroup) {');
     strList.Add('	 LAMWCommon.setParent(_viewgroup);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public ViewGroup GetParent() {');
     strList.Add('       return LAMWCommon.getParent();');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void RemoveFromViewParent() {');
     strList.Add('   	 LAMWCommon.removeFromViewParent();');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public View GetView() {');
     strList.Add('       return this;');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void SetLParamWidth(int _w) {');
     strList.Add('   	 LAMWCommon.setLParamWidth(_w);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void SetLParamHeight(int _h) {');
     strList.Add('   	 LAMWCommon.setLParamHeight(_h);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public int GetLParamWidth() {');
     strList.Add('       return LAMWCommon.getLParamWidth();');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public int GetLParamHeight() {');
     strList.Add('	 return  LAMWCommon.getLParamHeight();');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void SetLGravity(int _g) {');
     strList.Add('   	 LAMWCommon.setLGravity(_g);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void SetLWeight(float _w) {');
     strList.Add('   	 LAMWCommon.setLWeight(_w);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {');
     strList.Add('       LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void AddLParamsAnchorRule(int _rule) {');
     strList.Add('	 LAMWCommon.addLParamsAnchorRule(_rule);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void AddLParamsParentRule(int _rule) {');
     strList.Add('	 LAMWCommon.addLParamsParentRule(_rule);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void SetLayoutAll(int _idAnchor) {');
     strList.Add('   	 LAMWCommon.setLayoutAll(_idAnchor);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    public void ClearLayoutAll() {');
     strList.Add('	 LAMWCommon.clearLayoutAll();');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('    public void SetId(int _id) {');  //need by code generation....
     strList.Add('       this.setId(_id);');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('}');

     SynMemo1.Clear;
     SynMemo1.Lines.Text:= strList.Text;
     strList.Free;
   end;

   if Pos('Kotlin jVisualControl', txtCaption) > 0 then
   begin
     FIsKotlin:= True;
     newJavaClassName:= 'KMyToyButton';
     strList:= TStringList.Create;
     strList.Add(' ');
     strList.Add(' ');
     strList.Add('import android.view.View');
     strList.Add('import android.view.ViewGroup');
     strList.Add('import androidx.appcompat.widget.AppCompatButton');//"AppCompatButton" just as demo...change It!
     strList.Add(' ');
     strList.Add('/*Draft Kotlin code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     strList.Add('/*LAMW Kotlin jVisualControl template*/');
     strList.Add('  ');
     strList.Add('class '+newJavaClassName+'(_ctrls: Controls, _self: Long) : AppCompatButton(_ctrls.activity) {');
     strList.Add(' ');
     strList.Add('    private var pascalObj: Long = 0        // Pascal Object');
     strList.Add('    private var controls: Controls? = null //Java/Pascal [events] Interface ...');
     strList.Add('    private val LAMWCommon: jCommons');
     strList.Add(' ');
     strList.Add('    private val onClickListener: OnClickListener   // click event');
     strList.Add('    private var clicktouchEnable: Boolean = true           // click-touch enabled!');
     strList.Add(' ');
     strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('    init {');
     strList.Add('       pascalObj = _self');
     strList.Add('       controls = _ctrls');
     strList.Add('       LAMWCommon = jCommons(this, context, pascalObj)');
     strList.Add(' ');
     strList.Add('       onClickListener = OnClickListener {');
     strList.Add('          if (clicktouchEnable) {');
     strList.Add('              controls?.pOnClickGeneric(pascalObj) //JNI event onClick!');
     strList.Add('          }');
     strList.Add('       }');
     strList.Add('       setOnClickListener(onClickListener)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun kFree() {');
     strList.Add('       //free local objects...');
     strList.Add('   	 setOnClickListener(null)');
     strList.Add('	 LAMWCommon.free()');
     strList.Add('    }');
     strList.Add('  ');
     strList.Add('    fun SetViewParent(_viewgroup: ViewGroup?) {');
     strList.Add('	 LAMWCommon.setParent(_viewgroup)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun GetParent(): ViewGroup {');
     strList.Add('       return LAMWCommon.getParent()');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun RemoveFromViewParent() {');
     strList.Add('   	 LAMWCommon.removeFromViewParent()');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun GetView(): View {');
     strList.Add('       return this');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetLParamWidth(_w: Int) {');
     strList.Add('   	 LAMWCommon.setLParamWidth(_w)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetLParamHeight(_h: Int) {');
     strList.Add('   	 LAMWCommon.setLParamHeight(_h)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun GetLParamWidth(): Int {');
     strList.Add('       return LAMWCommon.getLParamWidth()');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun GetLParamHeight(): Int {');
     strList.Add('	 return  LAMWCommon.getLParamHeight()');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetLGravity(_g: Int) {');
     strList.Add('   	 LAMWCommon.setLGravity(_g)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetLWeight(_w: Float) {');
     strList.Add('   	 LAMWCommon.setLWeight(_w)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetLeftTopRightBottomWidthHeight(_left: Int, _top: Int, _right: Int, _bottom: Int, _w: Int, _h: Int) {');
     strList.Add('       LAMWCommon.setLeftTopRightBottomWidthHeight(_left, _top, _right, _bottom, _w, _h)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun AddLParamsAnchorRule(_rule: Int) {');
     strList.Add('	 LAMWCommon.addLParamsAnchorRule(_rule)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun AddLParamsParentRule(_rule: Int) {');
     strList.Add('	 LAMWCommon.addLParamsParentRule(_rule)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetLayoutAll(_idAnchor: Int) {');
     strList.Add('   	 LAMWCommon.setLayoutAll(_idAnchor)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun ClearLayoutAll() {');
     strList.Add('	 LAMWCommon.clearLayoutAll()');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     strList.Add('    fun SetId(_id: Int) {');  //need by code generation....
     strList.Add('       this.setId(_id)');
     strList.Add('    }');
     strList.Add(' ');
     strList.Add('    fun SetEnable(_value: Boolean) {');
     strList.Add('       clicktouchEnable = _value;');
     strList.Add('       this.setEnabled(_value)');
     strList.Add('    }');
      strList.Add(' ');
     strList.Add('}');

     SynMemo1.Clear;
     SynMemo1.Lines.Text:= strList.Text;
     strList.Free;
   end;

end;

function TFrmCompCreate.GetHackListPascalClassInterf(produceAll: boolean): string;
var
  listPascal, listProperties: TStringList;
  i: integer;
begin
  listPascal:= TStringList.Create;

  listPascal.Add('unit u'+LowerCase(FJavaClassName)+';');
  listPascal.Add(' ');
  listPascal.Add('{$mode delphi}');
  listPascal.Add(' ');
  listPascal.Add('interface');
  listPascal.Add(' ');
  listPascal.Add('uses');
  if produceAll then
  begin
    if Pos('jVisualControl', FProjectModel) > 0  then
      listPascal.Add('  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;')
    else
      listPascal.Add('  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;');
  end
  else
     listPascal.Add('  Classes, SysUtils, And_jni, AndroidWidget;');

  listPascal.Add(' ');
  listPascal.Add('type');
  listPascal.Add(' ');
  if produceAll then
  begin
    listPascal.Add('{Draft Component code by "LAMW: Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']}');
    listPascal.Add('{https://github.com/jmpessoa/lazandroidmodulewizard} ');
  end;
  listPascal.Add(' ');
  if Pos('jVisualControl', FProjectModel) > 0  then
  begin
    listPascal.Add('{jVisualControl template}');
    listPascal.Add(' ');
    listPascal.Add(FJavaClassName+' = class(jVisualControl)')
  end
  else
  begin
    if produceAll then
    begin
      listPascal.Add('{jControl template}');
      listPascal.Add(' ');
      listPascal.Add(FJavaClassName+' = class(jControl)');
    end
    else
    begin
      listPascal.Add('{warning: draft "'+FJavaClassName+'" complement....}');
      listPascal.Add('{         copy/add to *'+LowerCase(FJavaClassName)+'.pas" file}');
      listPascal.Add(' ');
      listPascal.Add(FJavaClassName+' = class');
      listPascal.Add(' public');
    end;
  end;

  if produceAll then
  begin
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
    end;

    listPascal.Add(' ');
    //listPascal.Add(' protected');
    //if Pos('jVisualControl', FProjectModel) > 0  then
    //   listPascal.Add('    procedure SetParentComponent(Value: TComponent); override;');
    //listPascal.Add(' ');
    listPascal.Add(' public');
    listPascal.Add('    constructor Create(AOwner: TComponent); override;');
    listPascal.Add('    destructor  Destroy; override;');
    listPascal.Add('    procedure Init; override;');

    if Pos('jVisualControl', FProjectModel) > 0  then
    begin
      listPascal.Add('    procedure Refresh;');
      listPascal.Add('    procedure UpdateLayout; override;');
      listPascal.Add('    procedure ClearLayout;');
      listPascal.Add('    ');
      listPascal.Add('    procedure GenEvent_OnClick(Obj: TObject);');
    end;
  end;

  listPascal.Add(FHackListPascalClass.Text);

  if produceAll then
  begin
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

  end;

  listPascal.Add('end;');
  listPascal.Add(' ');
  listPascal.Add(FHackListJNIHeader.Text);
  listPascal.Add(' ');

  listPascal.Add('implementation');
  listPascal.Add('  ');
  listPascal.Add('{---------  '+  FJavaClassName +'  --------------}');
  listPascal.Add(' ');

  if produceAll then
  begin
    listPascal.Add('constructor '+FJavaClassName+'.Create(AOwner: TComponent);');
    listPascal.Add('begin');
    listPascal.Add('  inherited Create(AOwner);');

    if Pos('jVisualControl', FProjectModel) > 0  then
    begin
      listPascal.Add(' ');
      listPascal.Add('  if gapp <> nil then FId := gapp.GetNewId();');
      listPascal.Add(' ');
      listPascal.Add('  FMarginLeft   := 10;');
      listPascal.Add('  FMarginTop    := 10;');
      listPascal.Add('  FMarginBottom := 10;');
      listPascal.Add('  FMarginRight  := 10;');
      listPascal.Add('  FHeight       := 96; //??');
      listPascal.Add('  FWidth        := 96; //??');
      listPascal.Add('  FLParamWidth  := lpMatchParent;  //lpWrapContent');
      listPascal.Add('  FLParamHeight := lpWrapContent; //lpMatchParent');
      listPascal.Add('  FAcceptChildrenAtDesignTime:= False;');
    end;
    listPascal.Add('//your code here....');
    listPascal.Add('end;');
    listPascal.Add(' ');

    {if Pos('jVisualControl', FProjectModel) > 0  then
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
    end;}

    listPascal.Add('destructor '+FJavaClassName+'.Destroy;');
    listPascal.Add('begin');
    listPascal.Add('  if not (csDesigning in ComponentState) then');
    listPascal.Add('  begin');
    listPascal.Add('     if FjObject <> nil then');
    listPascal.Add('     begin');
    if not FIsKotlin then
       listPascal.Add('       jFree();')
    else
       listPascal.Add('       kFree();');
    listPascal.Add('       FjObject:= nil;');
    listPascal.Add('     end;');
    listPascal.Add('  end;');
    listPascal.Add('  //you others free code here...''');
    listPascal.Add('  inherited Destroy;');
    listPascal.Add('end;');
    listPascal.Add(' ');

    listPascal.Add('procedure '+FJavaClassName+'.Init;');
    if Pos('jVisualControl', FProjectModel) > 0  then
    begin
     listPascal.Add('var');
     listPascal.Add('  rToP: TPositionRelativeToParent;');
     listPascal.Add('  rToA: TPositionRelativeToAnchorID;');
    end;

    listPascal.Add('begin');
    listPascal.Add('   ');

    if Pos('jVisualControl', FProjectModel) > 0  then
    begin
     listPascal.Add(' if not FInitialized then');
     listPascal.Add(' begin');
    end else
     listPascal.Add('  if FInitialized  then Exit;');

    listPascal.Add('  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!');
    listPascal.Add('  //your code here: set/initialize create params....');

    listProperties:= TStringList.Create;

    if Pos('_', FHackCreateParam) > 0 then
    begin
      listPascal.Add('  FjObject := jCreate('+StringReplace(FHackCreateParam,'_','F',[rfReplaceAll])+'); //jSelf !');   //** add F
      listPascal.Add('  ');
      listPascal.Add('  if FjObject = nil then exit;');
      listPascal.Add('  ');

      if Pos('jControl', FProjectModel) > 0  then
         listPascal.Add('  FInitialized:= True;');

    end
    else
    begin
      listProperties.StrictDelimiter:= True;
      listProperties.Delimiter:= ',';
      listProperties.DelimitedText:= FHackCreateParam;
      for i:= 0 to listProperties.Count-1 do
      begin
        listProperties.Strings[i]:= 'FP'+Trim(listProperties.Strings[i]); //ReplaceCharFirst(Trim(listProperties.Strings[i]),'F')+';'; //** Add F
      end;
      listPascal.Add('  FjObject := jCreate('+listProperties.DelimitedText+'); //jSelf !');   //** add F
      listPascal.Add('  ');
      listPascal.Add('  if FjObject = nil then exit;');
      listPascal.Add('  ');

      if Pos('jControl', FProjectModel) > 0  then
         listPascal.Add('  FInitialized:= True;');

    end;

    listProperties.Free;

    if Pos('jVisualControl', FProjectModel) > 0  then
    begin
     listPascal.Add('  if FParent <> nil then');
     listPascal.Add('   sysTryNewParent( FjPRLayout, FParent);');
     listPascal.Add(' ');
     listPascal.Add('  FjPRLayoutHome:= FjPRLayout;');
     listPascal.Add(' ');
     listPascal.Add('  '+FJavaClassName+'_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);');
     listPascal.Add('  '+FJavaClassName+'_SetId(gApp.jni.jEnv, FjObject, Self.Id);');
     listPascal.Add(' end;');
     listPascal.Add(' ');
     listPascal.Add('  '+FJavaClassName+'_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,');
     listPascal.Add('                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,');
     listPascal.Add('                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),');
     listPascal.Add('                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));');

     listPascal.Add('  ');

     listPascal.Add('  for rToA := raAbove to raAlignRight do');
     listPascal.Add('  begin');
     listPascal.Add('    if rToA in FPositionRelativeToAnchor then');
     listPascal.Add('    begin');
     listPascal.Add('      '+FJavaClassName+'_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));');
     listPascal.Add('    end;');
     listPascal.Add('  end;');
     listPascal.Add('  for rToP := rpBottom to rpCenterVertical do');
     listPascal.Add('  begin');
     listPascal.Add('    if rToP in FPositionRelativeToParent then');
     listPascal.Add('    begin');
     listPascal.Add('      '+FJavaClassName+'_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));');
     listPascal.Add('    end;');
     listPascal.Add('  end;');
     listPascal.Add('  ');
     listPascal.Add('  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id');
     listPascal.Add('  else Self.AnchorId:= -1; //dummy');
     listPascal.Add('  ');
     listPascal.Add('  '+FJavaClassName+'_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);');
     listPascal.Add('  ');
     listPascal.Add(' if not FInitialized then');
     listPascal.Add(' begin');
     listPascal.Add('  FInitialized := true;');
     listPascal.Add('  ');
     listPascal.Add('  if  FColor <> colbrDefault then');
     listPascal.Add('    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));');
     listPascal.Add('  ');
     listPascal.Add('  View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);');
     listPascal.Add(' end;');
    end;
    listPascal.Add('end;');
    listPascal.Add('  ');
    if Pos('jVisualControl', FProjectModel) > 0  then
    begin
     listPascal.Add('procedure '+FJavaClassName+'.SetColor(Value: TARGBColorBridge);');
     listPascal.Add('begin');
     listPascal.Add('  FColor:= Value;');
     listPascal.Add('  if (FInitialized = True) and (FColor <> colbrDefault)  then');
     listPascal.Add('    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));');
     listPascal.Add('end;');

     listPascal.Add('procedure '+FJavaClassName+'.SetVisible(Value : Boolean);');
     listPascal.Add('begin');
     listPascal.Add('  FVisible:= Value;');
     listPascal.Add('  if FInitialized then');
     listPascal.Add('    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);');
     listPascal.Add('end;');
     listPascal.Add('   ');
     listPascal.Add('procedure '+FJavaClassName+'.UpdateLayout;');
     listPascal.Add('begin');
     listPascal.Add('   ');
     listPascal.Add('  if not FInitialized then exit;');
     listPascal.Add('   ');
     listPascal.Add('  ClearLayout();');
     listPascal.Add('   ');
     listPascal.Add('  inherited UpdateLayout;');
     listPascal.Add('   ');
     listPascal.Add('  init;');
     listPascal.Add('   ');
     listPascal.Add('end;');
     listPascal.Add('   ');
     listPascal.Add('procedure '+FJavaClassName+'.Refresh;');
     listPascal.Add('begin');
     listPascal.Add('  if FInitialized then');
     listPascal.Add('    View_Invalidate(gApp.jni.jEnv, FjObject);');
     listPascal.Add('end;');
     listPascal.Add('   ');
     listPascal.Add('procedure '+FJavaClassName+'.ClearLayout;');
     listPascal.Add('var');
     listPascal.Add('   rToP: TPositionRelativeToParent;');
     listPascal.Add('   rToA: TPositionRelativeToAnchorID;');
     listPascal.Add('begin');
     listPascal.Add('   ');
     listPascal.Add('   if not FInitialized then Exit;');
     listPascal.Add('   ');
     listPascal.Add('  '+FJavaClassName+'_ClearLayoutAll(gApp.jni.jEnv, FjObject );');
     listPascal.Add('   ');
     listPascal.Add('   for rToP := rpBottom to rpCenterVertical do');
     listPascal.Add('      if rToP in FPositionRelativeToParent then');
     listPascal.Add('        '+FJavaClassName+'_AddLParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));');
     listPascal.Add('   ');
     listPascal.Add('   for rToA := raAbove to raAlignRight do');
     listPascal.Add('     if rToA in FPositionRelativeToAnchor then');
     listPascal.Add('       '+FJavaClassName+'_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));');
     listPascal.Add('   ');
     listPascal.Add('end;');
     listPascal.Add(' ');
     listPascal.Add('//Event : Java -> Pascal');
     listPascal.Add('procedure '+FJavaClassName+'.GenEvent_OnClick(Obj: TObject);');
     listPascal.Add('begin');
     listPascal.Add('  if Assigned(FOnClick) then FOnClick(Obj);');
     listPascal.Add('end;');
    end;
  end;
  Result:= listPascal.Text;

  listPascal.Free;
end;

//public native void pOnSpinnerItemSeleceted(long pasobj, int position, String caption); //Spinner
procedure TFrmCompCreate.GetNativeMethodList(selList: TStringList; nativeEventMethodList: TStringList; namingBypassList: TStringList);
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

procedure TFrmCompCreate.PopupMenu1Close(Sender: TObject);
var
  clsName: string;
  strCaption: string;
  responseStr : string;
  auxList: TStringList;
  auxStr: string;
  indexFound, i: integer;
  produceAll: boolean;
  nativeEventMethodList, namingBypassList: TStringList;
begin
  strCaption:= (Sender as TMenuItem).Caption;
  if Pos('Search ', strCaption) > 0 then
  begin
     responseStr := InputBox('Java Source:', 'Search: [MatchCase+WholeWord]', '');
     if responseStr <> '' then
        SynMemo1.SearchReplace(responseStr, responseStr,[ssoMatchCase,ssoWholeWord]);
  end;

  if Pos('Native Method', strCaption) > 0 then
  begin
     auxList:= TStringList.Create;
     if  SynMemo1.SelText <> '' then
         auxList.Text:= SynMemo1.SelText; //java class code...

     if auxList.Text = '' then auxList.Text:= SynMemo1.Text; //java class code...
     if auxList.Text = '' then Exit;

//     if not Self.FIsKotlin then
        clsName:= Trim(GetJavaClassName(auxList));
  //   else
        //clsName:= Trim(GetKotlinClassName(auxList))

     nativeEventMethodList:= TStringList.Create;
     namingBypassList:= TStringList.Create;

     //nativeEventMethod:= GetNativeMethod(auxList, namingBypass);
     GetNativeMethodList(auxList, nativeEventMethodList, namingBypassList);

     PageControl1.ActivePage:= TabSheet2;
     SynMemo2.Lines.Clear;

     //GetNativeMethodInterface(clsName,nativeEventMethod,namingBypass, SynMemo2.Lines);
     if nativeEventMethodList.Count > 0 then
             GetNativeMethodInterfaceList(clsName,
                                       nativeEventMethodList,
                                       namingBypassList,
                                       SynMemo2.Lines)
     else ShowMessage('Sorry... Empty Native Method List...');

     nativeEventMethodList.Free;
     namingBypassList.Free;
     auxList.Free;

     Exit;
  end;

  if Pos('Insert ', strCaption) > 0 then
  begin
    //FModeImport:= miDraft;
    InsertJControlCodeTemplate(strCaption);
    Exit;
  end;

  if strCaption <> 'Cancel' then
  begin

    produceAll:= True;
    if Pos('complementary', strCaption) > 0  then
    begin
      produceAll:= False;
      FIsKotlin:= TryIsKotlinComplementary(SynMemo1.Lines);
    end;

    for i:= 0 to SynMemo1.Lines.Count-1 do  //import local....
    begin
         auxStr:= SynMemo1.Lines.Strings[i];
         if auxStr <> '' then
         begin
           if Pos('import ', auxStr) > 0 then
           begin
              SplitStr(auxStr,' ');
              auxStr:= ReplaceChar(auxStr,'.','/');
              FImportsList.Add('L'+trim(auxStr));
           end;
         end;
    end;

    auxList:= TStringList.create;
    auxList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'Controls.java');
    for i:= 0 to auxList.Count-1 do
    begin
        auxStr:= auxList.Strings[i];
        if auxStr <> '' then
        begin
          if Pos('import ', auxStr) > 0 then
          begin
             SplitStr(auxStr,' ');
             auxStr:= ReplaceChar(auxStr,'.','/');
             if not FImportsList.Find('L'+trim(auxStr), indexFound) then
                FImportsList.Add('L'+trim(auxStr));
          end;
        end;
    end;

    auxList.Clear;
    SplitStr(strCaption, ' ');
    FProjectModel:= strCaption;   //ex. Write  "[Draft] Pascal jVisualControl Interface"
    if  SynMemo1.SelText <> '' then
        auxList.Text:= SynMemo1.SelText; //java class code...

    if auxList.Text = '' then auxList.Text:= SynMemo1.Text; //java class code...

    if auxList.Text = '' then Exit;

    if not FIsKotlin then
      clsName:= GetJavaClassName(auxList)
    else
      clsName:= GetKotlinClassName(auxList);

    if clsName <> '' then
    begin
      FJavaClassName:= clsName;

      FHackListJNIHeader.Clear;
      FHackListPascalClass.Clear;
      FHackListPascalClassImpl.Clear;

      if not FIsKotlin then
         DoJavaParse(produceAll)    //process...   FPascalJNIInterfaceCode
      else
         DoKotlinParse(produceAll);    //process...   FPascalJNIInterfaceCode

      FHackListPascalClassImpl.Add(' ');
      FHackListPascalClassImpl.Add('{-------- '+FJavaClassName +'_JNI_Bridge ----------}');
      FHackListPascalClassImpl.Add(' ');

      SynMemo2.Lines.Clear;
      SynMemo2.Lines.Text:= GetHackListPascalClassInterf(produceAll) + FHackListPascalClassImpl.Text + FPascalJNIInterfaceCode;

      SynMemo2.Lines.Add('end.');

      PageControl1.ActivePage:= TabSheet2;
      SynMemo2.SelectAll;
      SynMemo2.CopyToClipboard;
      SynMemo2.ClearSelection;
      SynMemo2.PasteFromClipboard;

      if produceAll then   //here?
        AddComplements(FJavaClassName); // "FJavaClassName.libjar"   "FJavaClassName.libso" ,  etc...

    end;
    auxList.Free;
  end;
end;

{
permission   <uses-permission android:name="android.permission.INTERNET"/>
libjar exp4j-0.4.8.jar
libso  libiconv.so
anim in_from_left.xml
compound jPanel jTextView
dependencies  implementation 'com.android.support:design:25.3.1'     //"implementation" -> androidPluginNumber >= 300
}


//implementation 'com.android.support:design:25.3.1'
function TFrmCompCreate.GetCleanDepData(aux: string): string;
var
  p: integer;
  temp, temp2: string;
begin
  temp:= aux;
  p:= Pos(' ', aux);
  if p > 0 then
    temp:= Trim(Copy(aux, p+1, MaxInt));

  temp2:= StringReplace(temp, '"', '', [rfReplaceAll]);      // "com.android.support:design:25.3.1"
  Result:= StringReplace(temp2, '''', '', [rfReplaceAll]);   // 'com.android.support:design:25.3.1'
end;

procedure TFrmCompCreate.AddComplements(javaclassName: string);
var
  frm: TFormAddComplements;
  i, count: integer;
  ext, filename,  aux, data: string;
  list: TStringList;
begin
  frm:= TFormAddComplements.Create(nil);
  if frm.ShowModal = mrOK then
  begin  //FPathToJavaTemplates: "C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\java"

     if frm.ListBoxGradleDep.Count > 0 then
     begin
      if StrToInt(frm.ComboBoxMinSdkApi.Text) < 18 then
      begin
         frm.ComboBoxMinSdkApi.Text:= '18';
         ShowMessage('warning: [online] library dependencies need MinsSdkApi=18 and Grandle....');
      end;
     end;

     count:= frm.ListBoxPath.Count;
     list:= TStringList.Create;

     list.Add(Trim(frm.ComboBoxMinSdkApi.Text));
     list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.minsdk');
     list.Clear;
     for i:= 0 to count-1 do
     begin
        ext:= ExtractFileExt(frm.ListBoxPath.Items.Strings[i]);
        filename:= ExtractFileName(frm.ListBoxPath.Items.Strings[i]);
        case ext of
          '.so': begin
                    if FileExists(FPathToJavaTemplates + PathDelim + javaclassName + '.libso') then
                        list.LoadFromFile(FPathToJavaTemplates + PathDelim + javaclassName + '.libso');
                    list.Add(filename);
                    list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.libso');
                    CopyFile(frm.ListBoxPath.Items.Strings[i], FPathToJavaTemplates + PathDelim + 'libso' + PathDelim + filename);
                 end;
          '.jar': begin
                    if FileExists(FPathToJavaTemplates + PathDelim + javaclassName + '.libjar') then
                        list.LoadFromFile(FPathToJavaTemplates + PathDelim + javaclassName + '.libjar');
                    list.Add(filename);
                    list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.libjar');
                    CopyFile(frm.ListBoxPath.Items.Strings[i], FPathToJavaTemplates + PathDelim + 'libjar' + PathDelim + filename);
                  end;
        end;
     end;

     count:= frm.ListBoxGradleDep.Count; //dependencies

    if count > 0 then
     begin
       list.Clear;
       list.Add('Gradle');
       list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.buildsys');
     end;

     for i:= 0 to count-1 do
     begin
        aux:= Trim(frm.ListBoxGradleDep.Items.Strings[i]);
        list.Clear;

        if Pos('implementation', aux) > 0 then
        begin
          if FileExists(FPathToJavaTemplates + PathDelim + javaclassName + '.dependencies') then
               list.LoadFromFile(FPathToJavaTemplates + PathDelim + javaclassName + '.dependencies');
          list.Add(aux);
          list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.dependencies');
        end;

        if Pos('classpath', aux) > 0 then
        begin
          if FileExists(FPathToJavaTemplates + PathDelim + javaclassName + '.classpath') then
               list.LoadFromFile(FPathToJavaTemplates + PathDelim + javaclassName + '.classpath');

          list.Add(aux);
          list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.classpath');
        end;

        if Pos('apply', aux) > 0 then
        begin
          if FileExists(FPathToJavaTemplates + PathDelim + javaclassName + '.plugin') then
               list.LoadFromFile(FPathToJavaTemplates + PathDelim + javaclassName + '.plugin');
          list.Add(aux);
          list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.plugin');
        end;

     end;

     count:= frm.ListBoxPermission.Count; //<uses-permission android:name="android.permission.INTERNET"/>
     for i:= 0 to count-1 do
     begin
        data:= frm.ListBoxPermission.Items.Strings[i];
        list.Clear;

        if FileExists(FPathToJavaTemplates + PathDelim + javaclassName + '.permission') then
            list.LoadFromFile(FPathToJavaTemplates + PathDelim + javaclassName + '.permission');

        if Pos('<uses-permission', data) > 0 then
           list.Add(data)
        else
           list.Add('<uses-permission android:name="'+data+'"/>');

        list.SaveToFile(FPathToJavaTemplates + PathDelim + javaclassName + '.permission');
     end;

     list.Free;
  end;
  frm.Free;
end;

function TFrmCompCreate.GetJavaClassName(selList: TStringList): string;
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

procedure TFrmCompCreate.PopupMenu2Close(Sender: TObject);
var
 AProcess: TProcess;
 iconPath, regFile, userTab: string;
 auxStr, lastStr: string;
 strList: TStringList;
 i: integer;
 frm: TFormRegisterComp;
 fileExt: string;
begin
  if (Sender as TMenuItem).Caption <> 'Cancel' then
  begin
    if Pos('unit ', SynMemo2.Lines.Strings[0] ) = 0  then  // In case Substr isn't found, 0 is returned. The search is case-sensitive.
    begin
       ShowMessage('Sorry... You don''t have the code to create a new component!');
       Exit;
    end;

    frm:= TFormRegisterComp.Create(nil);
    frm.PathToLAMW:= FPathToLAMW+DirectorySeparator+'android_bridges'+DirectorySeparator;
    frm.EditRegisterPath.Text:= FPathToLAMW+DirectorySeparator+'android_bridges'+DirectorySeparator+'register_extras.pas';
    frm.EditRegisterPath.ReadOnly:= True;

    if frm.ShowModal = mrOK then
    begin
      iconPath:= frm.EditIconPath.Text;
      regFile:=  frm.EditRegisterPath.Text;

      if iconPath <> '' then
      begin
         if iconPath <> FPathToLAMW+DirectorySeparator+'ide_tools'+DirectorySeparator+LowerCase(FJavaClassName)+'.png' then
            CopyFile(iconPath,FPathToLAMW+DirectorySeparator+'ide_tools'+DirectorySeparator+LowerCase(FJavaClassName)+'.png');
         try
           AProcess:= TProcess.Create(nil);
           AProcess.CurrentDirectory:= FPathToLAMW+DirectorySeparator+'ide_tools';
           AProcess.Executable:= FPathToLAMW+DirectorySeparator+'ide_tools'+DirectorySeparator+'lazres.exe';
           {$IFDEF UNIX}
              AProcess.Executable:= FPathToLAMW+DirectorySeparator+'ide_tools'+DirectorySeparator+'lazres';
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
             if Pos('_template', regFile) > 0 then
             begin
               userTab:= InputBox('Register [Tab] Component', 'Tab Name', 'Android Bridges ???');
               auxStr:= Lowercase(ReplaceChar(userTab,' ','_'));
               regFile:= StringReplace(regFile,'template', auxStr,[]); //new file name
               strList.Strings[0]:= 'unit register_'+auxStr+';';
               lastStr:= StringReplace(strList.Text,'#TAB',userTab,[]); //
               strList.Text:= lastStr;
             end;
             i:= 0;
             while i < strList.Count-1 do
             begin
               if (Pos('RegisterClasses', strList.strings[i]) > 0) or (Pos('RegisterNoIcon', strList.strings[i]) > 0) then
               begin
                 inc(i);
               end
               else
               begin
                 if Pos('Classes,', strList.strings[i]) > 0 then
                 begin
                   Inc(i);
                   strList.Insert(i, '  '+'u'+LowerCase(FJavaClassName)+',');
                 end else if Pos('begin', strList.strings[i]) > 0 then
                 begin
                    Inc(i);
                    strList.Insert(i, '  {$I '+LowerCase(FJavaClassName)+'_icon.lrs}');
                 end else if Pos('[', strList.strings[i]) > 0 then
                 begin
                    if Pos(']', strList.strings[i+1]) > 0 then //empty
                    begin
                       Inc(i);
                       strList.Insert(i, '      '+FJavaClassName); //add first
                    end
                    else //not empty
                    begin
                       Inc(i);
                       strList.Insert(i, '      '+FJavaClassName + ',');
                    end;
                 end;
                 Inc(i);
               end;

             end;
             strList.SaveToFile(regFile);
           end;
           strList.Free;
           SynMemo2.SelectAll;
           SynMemo2.CopyToClipboard;
           SynMemo2.ClearSelection;
           SynMemo2.PasteFromClipboard;

           if not FileExists(FPathToLAMW+DirectorySeparator+'android_bridges'+DirectorySeparator+'u'+LowerCase(FJavaClassName)+'.pas') then
              SynMemo2.Lines.SaveToFile(FPathToLAMW+DirectorySeparator+'android_bridges'+DirectorySeparator+'u'+LowerCase(FJavaClassName)+'.pas')
           else
           begin
              case QuestionDlg ('FileExists!','Overwrite the ".pas" File?',mtWarning,[mrYes,'Yes', mrNo, 'No'], '') of
                  mrYes: SynMemo2.Lines.SaveToFile(FPathToLAMW+DirectorySeparator+'android_bridges'+DirectorySeparator+'u'+LowerCase(FJavaClassName)+'.pas');
              end;
           end;

           fileExt:= '.kt';
           if not FIsKotlin then
             fileExt:= '.java';

           if not FileExists(FPathToJavaTemplates+PathDelim+FJavaClassName+fileExt) then
              SynMemo1.Lines.SaveToFile(FPathToJavaTemplates+PathDelim+FJavaClassName+fileExt)
           else
           begin   //save java/kotlin class template
             case QuestionDlg ('FileExists!','Overwrite the "'+fileExt+'" File?',mtWarning,[mrYes,'Yes', mrNo, 'No'],'') of
                 mrYes: SynMemo1.Lines.SaveToFile(FPathToJavaTemplates+PathDelim+FJavaClassName+fileExt);
             end;
           end;

           if FileExists(FPathToLAMW+DirectorySeparator+'ide_tools'+DirectorySeparator+LowerCase(FJavaClassName)+'_icon.lrs') then
           begin
              CopyFile(FPathToLAMW+DirectorySeparator+'ide_tools'+DirectorySeparator+LowerCase(FJavaClassName)+'_icon.lrs',
                       FPathToLAMW+DirectorySeparator+'android_bridges'+DirectorySeparator+LowerCase(FJavaClassName)+'_icon.lrs');
           end;
         end; //finally
      end;     //if iconPath
    end      //showModal
    else
    begin //cancel -> clean up
      if not FileExists(FPathToJavaTemplates+PathDelim+FJavaClassName+fileExt) then
      begin
          if FileExists(FPathToJavaTemplates+PathDelim+FJavaClassName+'.create') then
          begin
            DeleteFile(FPathToJavaTemplates+PathDelim+FJavaClassName+'.create');
          end;
      end;
    end;
    frm.Free;
  end;
end;

procedure TFrmCompCreate.RadioGroupPasInterfaceSelectionChanged(Sender: TObject);
begin
  if RadioGroupPasInterface.ItemIndex <> 0 then
  begin
    ProduceImportsDictionary();
    GroupBoxMainUnit.Visible:= True;
    GroupBoxJavaClass.Visible:= True;
  end
  else
  begin
     GroupBoxMainUnit.Visible:= False;
     GroupBoxJavaClass.Visible:= False;
  end;

end;

procedure TFrmCompCreate.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('About Android Bridges components palettes' + sLineBreak +
            'and Android system builder (Ant/Gradle):' + sLineBreak + sLineBreak +
            '"Android Bridges" [visual controls] support "Ant" and "Gradle": prefix class "j"' + sLineBreak +
            '"Android Bridges Extra" [not visual] support "Ant" and "Gradle": prefix class "j"'+ sLineBreak + sLineBreak+
            '"Android Bridges jCenter" support only "Gradle": prefix class "jc"' + sLineBreak +
            '(here we put bridges for generics "online" jar libraries)' + sLineBreak + sLineBreak +
            '"Android Bridges AppCompat" support only "Gradle" prefix class "js" or "K" for Kotlin' + sLineBreak +
            '(here we put bridges for Android AppCompat/Material libraries and Koltlin based component)');
end;

procedure TFrmCompCreate.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog1.DefaultExt:= '.java';
  OpenDialog1.Filter:= 'Java|*.java';
  if OpenDialog1.Execute then
  begin
     SynMemo1.Lines.Clear;
     SynMemo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TFrmCompCreate.FormCreate(Sender: TObject);
begin
    FHackListJNIHeader:= TStringList.Create;
    FHackListPascalClass:= TStringList.Create;
    FHackListPascalClassImpl:= TStringList.Create;
    Memo2List:= TStringList.Create;
    FImportsList:= TStringLIst.Create;
    FImportsList.Sorted:=true;
    Self.LoadSettings(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
    FFirstFocus:= True;
    PageControl1.ActivePage:= TabSheet1;
end;

procedure TFrmCompCreate.FormActivate(Sender: TObject);
begin
    FListJarClass:= TStringList.Create;
    if FFirstFocus then
    begin
      SynMemo1.SetFocus;
      SynMemo1.CaretX:= 0;
      SynMemo1.CaretY:= 0;
      FFirstFocus:= False;
    end;
end;

//public Eq2GSolver(float, float, float);
function GetSupperParam(signature: string; var listParam: TstringList): integer;
var
  p1, p2, i: integer;
  temp: string;
begin
  Result:= 0;
  p1:= Pos('(',signature);
  p2:= Pos(')',signature);

  if (p2-p1) < 3 then Exit;

  listParam.Clear;
  listParam.Delimiter:=',';
  listParam.StrictDelimiter:=True;
  temp:= Copy(signature, p1+1, p2-p1-1); //float, float, float
  listParam.DelimitedText:=StringReplace(temp, ' ', '', [rfIgnoreCase, rfReplaceAll]);

  for i:= 0 to  listParam.Count-1 do
  begin
    listParam.Strings[i]:= listParam.Strings[i] + ' _arg'+ IntToStr(i);
  end;

  Result:= listParam.Count;
end;

function GetMethodSignature(signature: string; out newsignature: string): integer;
var
  p1, p2, i: integer;
  temp: string;
  listParam: TStringList;
  header: string;
begin
  Result:= 0;
  p1:= Pos('(',signature);
  p2:= Pos(')',signature);

  if (p2-p1) < 3 then
  begin
    newsignature:= signature;
    Exit;
  end;

  header:= Copy(signature, 1, p1);

  listParam:= TStringList.Create;
  listParam.Delimiter:=',';
  listParam.StrictDelimiter:=True;
  temp:= Copy(signature, p1+1, p2-p1-1); //float, float, float
  listParam.DelimitedText:=StringReplace(temp, ' ', '', [rfIgnoreCase, rfReplaceAll]);

  //public Eq2GSolver(float, float, float);
  for i:= 0 to  listParam.Count-1 do
  begin
    listParam.Strings[i]:= listParam.Strings[i] + ' _arg'+ IntToStr(i);
  end;

  newsignature:= header + listParam.DelimitedText + ')';

  Result:= listParam.Count;
  listParam.Free;

end;

function GetPosSpace(header: string): integer;
var
  i, len: integer;
begin
  len:= Length(header);
  i:= len;
  while header[i] <> ' ' do
  begin
     Dec(i);
  end;
  Result:= i;
end;

function UppercaseChar(s: String; p: integer): String;
var
  header, tail, ch: String;
begin
  header := Copy(s, 1, p-1);
  ch:= Copy(s, p,1);
  tail := Copy(s, p+1, MaxInt);
  Result := header + Uppercase(ch) + tail;
end;

function GetMethodSignatureEx(signature: string; out newsignature: string; out methname: string; outListParams: TStrings): integer;
var
  p1, p2, i, ps: integer;
  temp: string;
  listParam: TStringList;
  header: string;
  outParams: TStringList;
begin
  Result:= 0;
  p1:= Pos('(',signature);
  p2:= Pos(')',signature);

  header:= Copy(signature, 1, p1); //public void Foo(

  ps:= GetPosSpace(header);
  methname:= Copy(header, ps+1, p1-(ps+1));

  if (p2-p1) < 3 then
  begin
    temp:= UppercaseChar(signature, ps+1);
    newsignature:= StringReplace(temp, '...', '[]', [rfIgnoreCase, rfReplaceAll]);
    Exit;
  end;

  listParam:= TStringList.Create;
  listParam.Delimiter:=',';
  listParam.StrictDelimiter:=True;
  temp:= Copy(signature, p1+1, p2-p1-1); //float, float, float   //java.util.Map<java.lang.String, java.lang.Double>

  listParam.DelimitedText:=StringReplace(temp, ' ', '', [rfIgnoreCase, rfReplaceAll]);

  outParams:= TStringList.Create;
  outParams.Delimiter:=',';
  outParams.StrictDelimiter:= True;

  //public net.objecthunter.exp4j.Expression setVariables(java.util.Map<java.lang.String, java.lang.Double>)
  //public Eq2GSolver(float, float, float);
  for i:= 0 to  listParam.Count-1 do
  begin
    if (Pos('<',listParam.Strings[i]) <= 0) then
    begin
       listParam.Strings[i]:= listParam.Strings[i] + ' _arg'+ IntToStr(i);
       outParams.Add(' _arg'+ IntToStr(i));
    end
    else
    begin
       if listParam.Count = 1 then //java.util.Map<java.lang.String, java.lang.Double>  or   java.util.Set<java.lang.String>
       begin
         listParam.Strings[i]:= listParam.Strings[i] + ' _arg'+ IntToStr(i);
         outParams.Add(' _arg'+ IntToStr(i));
       end
       else
       begin   //  public SetVariables(java.util.Map<java.lang.String _arg0,java.lang.Double> _arg1) {
         if Pos('>', listParam.Strings[i]) >  0 then //java.util.Set<java.lang.String>, java.util.Set<java.lang.Integer>
         begin
             listParam.Strings[i]:= listParam.Strings[i] + ' _arg'+ IntToStr(i);
             outParams.Add(' _arg'+ IntToStr(i));
         end;
       end;
    end;
  end;
  temp:= UppercaseChar(header + listParam.DelimitedText + ')', ps+1);
  newsignature:= StringReplace(temp, '...', '[]', [rfIgnoreCase, rfReplaceAll]);
  outListParams.Text:= outParams.Text;
  Result:= outParams.Count;

  listParam.Free;

end;

function RunCmdProcess(const cmd: string): integer;
begin
  with TProcess.Create(nil) do  //UTF8
  try
    Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    Executable := cmd;
    ShowWindow := swoHIDE;
    Execute;
    Result := ExitCode;
  finally
    Free;
  end;
end;

//FPathToJavaTemplates: string;
//C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\java
procedure TFrmCompCreate.BitBtnJARClick(Sender: TObject);
var
    strList: TstringList;
    pathLibjar, importPack, javaClass, constructorSignature: string;
    success: boolean;
    p, i: integer;
    methodSignatureList, outParams: TStringList;
    listSupperParam: TStringList;
    countSupperParam: integer;
    supperParamEx, supperParam, methodSignature,  ext, methnam: string;
    codeDesign, codeFrom: integer;
    this: string;
begin
  if OpenDialog1.Execute then
  begin
    FPathToJARFile:= OpenDialog1.FileName;
    FJARFilename:= ExtractFileName(FPathToJARFile);
    FListJarClass.Clear;
    FListJarClass.Add(FJARFilename);
    pathLibjar:= FPathToJavaTemplates+PathDelim+'libjar';
    CopyFile(FPathToJARFile,pathLibjar+PathDelim+FJARFilename);

    methodSignatureList:= TStringList.Create;
    strList:= TstringList.Create;
    listSupperParam:= TStringList.Create;
    outParams:= TStringList.Create;
    outParams.Delimiter:=',';
    outParams.StrictDelimiter:= True;

    ext:= '.bat';
    {$IFDEF UNIX}
    ext:='.sh';
    {$Endif}

    strList.Add('@echo off');
    strList.Add('CD '+pathLibjar);
    strList.Add('SET JAVA_TEMP="'+FPathToJavaJDK+PathDelim+'bin"');
    strList.Add('SET PATH=%PATH%;%JAVA_TEMP%');
    strList.Add('SET ESCAPE=".class"');
    strList.Add('jar -tf '+FJARFilename+' | findstr %ESCAPE% > jar-tf_' + ChangeFileExt(FJARFilename,'.txt'));
    strList.SaveToFile(pathLibjar+PathDelim+ 'jar-tf_' + ChangeFileExt(FJARFilename,ext));

    RunCmdProcess(pathLibjar+PathDelim+'jar-tf_' + ChangeFileExt(FJARFilename,ext));

    strList.Clear;
    strList.LoadFromFile(pathLibjar+PathDelim+'jar-tf_' + ChangeFileExt(FJARFilename,'.txt'));

    FormImportJAR:= TFormImportJAR.Create(Self);
    FormImportJAR.Caption:= 'Form Import Java class';
    FormImportJAR.LabelSelect.Caption:= 'Select a class:';
    FormImportJAR.SpeedButtonShowMethods.Visible:= False;
    FormImportJAR.TaskMode:= 0;
    FormImportJAR.MethodSignatureList.Text:= strList.Text;
    FormImportJAR.ShowModal;
    success:= False;
    if FormImportJAR.ModalResult = mrOk then
    begin
       importPack:= FormImportJAR.ListBox1.GetSelectedText; //org.lamw.simplemath.Eq2GSolver
       p:= LastDelimiter('.', importPack);
       javaClass:= Copy(importPack, p+1, MaxInt);    //Eq2GSolver
       strList.Clear;
       strList.Add('@echo off');
       strList.Add('CD '+pathLibjar);
       strList.Add('SET JAVA_TEMP="'+FPathToJavaJDK+PathDelim+'bin"');
       strList.Add('SET PATH=%PATH%;%JAVA_TEMP%');
       strList.Add('javap -classpath '+FJARFilename+' '+importPack + ' > javap_'+ChangeFileExt(FJARFilename,'')+'_'+javaClass+'.txt');  //+ ' > javap2.txt'
       strList.SaveToFile(pathLibjar+PathDelim+ 'javap_'+ChangeFileExt(FJARFilename,'')+'_'+javaClass+ext);
       success:= True;
    end;

    if success then
    begin

      RunCmdProcess(pathLibjar+PathDelim+ 'javap_'+ChangeFileExt(FJARFilename,'')+'_'+javaClass+ext);
      if FormImportJAR <> nil then FormImportJAR.Free;
      FormImportJAR:= TFormImportJAR.Create(Self);

      FormImportJAR.SpeedButtonShowMethods.Visible:= True;
      FormImportJAR.Caption:= 'Form Import '+ javaClass;
      FormImportJAR.LabelSelect.Caption:= 'Select a constructor:';
      FormImportJAR.ConstructorSignature:= 'public ' + importPack + '(';
      FormImportJAR.TaskMode:= 1;
      strList.LoadFromFile(pathLibjar+PathDelim+'javap_'+ChangeFileExt(FJARFilename,'')+'_'+javaClass+'.txt');
      FormImportJAR.MethodSignatureList.Text:= strList.Text;
      FormImportJAR.ShowModal;
      if FormImportJAR.ModalResult = mrOk then
      begin
         constructorSignature:= FormImportJAR.ListBox1.GetSelectedText;
         countSupperParam:= GetSupperParam(constructorSignature, listSupperParam);
         methodSignatureList.Text:= FormImportJAR.FListMethods.Text;  //only methods...
         codeDesign:= FormImportJAR.RadioGroupDesign.ItemIndex;
         codeFrom:= FormImportJAR.RadioGroupFrom.ItemIndex;
      end
      else success:= False;
    end;

    if codeDesign = 1 then this:= 'this'
    else this:= 'm'+javaClass;

    if success then
    begin
      strList.Clear;
      strList.Add(' ');
      strList.Add('/*'+FJARFilename+'*/');
      strList.Add('import '+ importPack+';');
      strList.Add('import android.content.Context;');

      if codeFrom = 1 then //VisualControl
      begin
        strList.Add('import android.view.View;');
        strList.Add('import android.view.ViewGroup;');
      end;

      strList.Add(' ');
      strList.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
      strList.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
      strList.Add('/*jControl LAMW template*/');
      strList.Add(' ');

      if  codeDesign =  1 then
        strList.Add('public class j'+javaClass+' extends '+javaClass+' {')
      else
        strList.Add('public class j'+javaClass+' {');

      strList.Add('  ');
      strList.Add('    private long pasobj = 0;        //Pascal Object');
      strList.Add('    private Controls controls  = null; //Java/Pascal [events] Interface ...');
      strList.Add('    private Context  context   = null;');
      if codeFrom = 1then //VisualControl
      begin
        strList.Add('    private jCommons LAMWCommon;');
        strList.Add(' ');
        strList.Add('    private OnClickListener onClickListener;   // click event');
        strList.Add('    private Boolean enabled  = true;           // click-touch enabled!');
      end;
      strList.Add('  ');
      if codeDesign = 0 then
         strList.Add('    private '+importPack+' m'+javaClass+';');
      strList.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
      strList.Add('  ');
      supperParamEx:= listSupperParam.DelimitedText;

      if countSupperParam > 0 then
           strList.Add('    public j'+javaClass+'(Controls _ctrls, long _self,'+supperParamEx+') {')
      else
           strList.Add('    public j'+javaClass+'(Controls _ctrls, long _self) {');

      if countSupperParam > 0 then
      begin
        supperParam:= '_arq0';
        for i:= 1 to countSupperParam-1 do
        begin
          supperParam:= supperParam + ',' + '_arg'+ IntToStr(i);
        end;
      end
      else supperParam:= '';

      if codeFrom = 0 then
      begin
        if codeDesign = 1 then
          strList.Add('       super('+supperParam+');')
        else
          strList.Add('       m'+javaClass+' = new '+importPack+'('+supperParam+');');
      end
      else
      begin
         strList.Add('       super(_ctrls.activity);');
         strList.Add('       LAMWCommon = new jCommons(this,_ctrls.activity,pasobj);');
      end;
      strList.Add('       context   = _ctrls.activity;');
      strList.Add('       pasobj = _self;');
      strList.Add('       controls  = _ctrls;');
      if codeFrom = 1 then
      begin
        strList.Add('       onClickListener = new OnClickListener(){');
        strList.Add('       /*.*/public void onClick(View view){     // *.* is a mask to future parse...;');
        strList.Add('               if (enabled) {');
        strList.Add('                  controls.pOnClickGeneric(pasobj); //JNI event onClick!');
        strList.Add('               }');
        strList.Add('            };');
        strList.Add('       };');
        strList.Add('       setOnClickListener(onClickListener);');
      end;
      strList.Add('    }');
      strList.Add('  ');
      strList.Add('    public void jFree() {');
      strList.Add('      //free local objects...');
      if codeFrom = 1 then
      begin
        strList.Add('    setOnClickListener(null);');
        strList.Add('	 LAMWCommon.free();');
      end;
      strList.Add('      m'+javaClass+' = null;');
      strList.Add('    }');
      strList.Add('  ');

      if codeFrom = 1 then
      begin
         strList.Add('    public void SetViewParent(ViewGroup _viewgroup) {');
         strList.Add('	    LAMWCommon.setParent(_viewgroup);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public ViewGroup GetParent() {');
         strList.Add('      return LAMWCommon.getParent();');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void RemoveFromViewParent() {');
         strList.Add('      LAMWCommon.removeFromViewParent();');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public View GetView() {');
         strList.Add('       return this;');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void SetLParamWidth(int _w) {');
         strList.Add('       LAMWCommon.setLParamWidth(_w);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void SetLParamHeight(int _h) {');
         strList.Add('       LAMWCommon.setLParamHeight(_h);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public int GetLParamWidth() {');
         strList.Add('       return LAMWCommon.getLParamWidth();');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public int GetLParamHeight() {');
         strList.Add('	     return  LAMWCommon.getLParamHeight();');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void SetLGravity(int _g) {');
         strList.Add('       LAMWCommon.setLGravity(_g);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void SetLWeight(float _w) {');
         strList.Add('       LAMWCommon.setLWeight(_w);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {');
         strList.Add('       LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void AddLParamsAnchorRule(int _rule) {');
         strList.Add('	     LAMWCommon.addLParamsAnchorRule(_rule);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void AddLParamsParentRule(int _rule) {');
         strList.Add('	     LAMWCommon.addLParamsParentRule(_rule);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void SetLayoutAll(int _idAnchor) {');
         strList.Add('       LAMWCommon.setLayoutAll(_idAnchor);');
         strList.Add('    }');
         strList.Add(' ');
         strList.Add('    public void ClearLayoutAll() {');
         strList.Add('	     LAMWCommon.clearLayoutAll();');
         strList.Add('    }');
      end;
      strList.Add(' ');
      strList.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
      strList.Add('  //write others [public] methods code here......');
      strList.Add(' ');

      //add test here:
      //methodSignatureList.Add('public void foo1(java.lang.String, java.util.Set<java.lang.String>, java.util.Set<java.lang.Integer>)');

      for i:= 0 to methodSignatureList.Count - 1 do
      begin
          countSupperParam:= GetMethodSignatureEx(Trim(methodSignatureList.Strings[i]), methodSignature, methnam, outParams);
          strList.Add('   '+methodSignature+' {');

          if countSupperParam > 0 then
             supperParam:= outParams.DelimitedText//supperParam + ',' + '_arg'+ IntToStr(k);
          else supperParam:= '';

          if Pos(' void ', methodSignature) > 0 then
            strList.Add('      '+this+'.'+methnam+'('+supperParam+');')
          else
            strList.Add('      return '+this+'.'+methnam+'('+supperParam+');');

          strList.Add('   }');
          strList.Add(' ');

      end;
      strList.Add('}');

      SynMemo1.Clear;
      SynMemo1.Lines.Text:= strList.Text;

    end else SynMemo1.Clear;

    outParams.Free;
    listSupperParam.Free;
    strList.Free;
    methodSignatureList.Free;
  end;


end;

procedure TFrmCompCreate.ProduceImportsDictionary();
var
    imports: TStringList;
    auxList: TStringList;
    auxStr: string;
    i: integer;
begin
  auxList:= TStringList.Create;
  Imports:= TStringList.Create;

  Imports.Sorted:= True;
  Imports.Duplicates:= dupIgnore;

  auxList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'Controls.java');
  for i:= 0 to auxList.Count-1 do
  begin
      auxStr:= auxList.Strings[i];
      if auxStr <> '' then
      begin
        if Pos('import ', auxStr) > 0 then
        begin
           Imports.Add( Trim(auxStr) );
        end;
      end;
      Imports.SaveToFile(FPathToJavaTemplates+DirectorySeparator+'Controls.imports');
  end;

  Imports.Free;
  auxList.Free;

end;


procedure TFrmCompCreate.FormDestroy(Sender: TObject);
begin
   FListJarClass.Free; //jEq2GSolver.libjar
   FHackListJNIHeader.Free;
   FHackListPascalClass.Free;
   FHackListPascalClassImpl.Free;
   Memo2List.Free;
   FImportsList.Free;
end;

function TFrmCompCreate.GetJSignature(params, res: string): string;
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

function TFrmCompCreate.GetPascalCodeHack(funcName, funcParam, funcResult, jniSignature: string): string;
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
    FHackListPascalClassImpl.Add('     '+FJavaClassName+'_'+funcName+'(gApp.jni.jEnv, FjObject'+pascalParamName+');');
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
       FHackListPascalClassImpl.Add('   Result:= '+FJavaClassName+'_'+funcName+'(gApp.jni.jEnv, FjObject'+StringReplace(pascalParamName,'_self', 'int64(Self)',[])+');')
    else
    begin
      FHackListPascalClassImpl.Add('   Result:= '+FJavaClassName+'_jCreate(gApp.jni.jEnv'+StringReplace(pascalParamName,'_self', 'int64(Self)',[])+', gApp.jni.jThis);');
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

  strList.Add('label');
  strList.Add('  _exceptionOcurred;');
  strList.Add('begin');

  strList.Add('  ');
  if funcResult = 'constructor' then  //constructor
  begin
    strList.Add('  Result := nil;');
    strList.Add('  ');
    strList.Add('  if (env = nil) or (this = nil) then exit;');
    strList.Add('  jCls:= Get_gjClass(env);');
    strList.Add('  if jCls = nil then goto _exceptionOcurred;');
    strList.Add('  jMethod:= env^.GetMethodID(env, jCls, '''+funcName+'_jCreate'+''', '''+jniSignature+'''); ');
    strList.Add('  if jMethod = nil then goto _exceptionOcurred;');
  end
  else
  begin
    strList.Add('  if (env = nil) or (_'+LowerCase(FJavaClassName)+' = nil) then exit;');
    strList.Add('  jCls:= env^.GetObjectClass(env, _'+LowerCase(FJavaClassName)+');');
    strList.Add('  if jCls = nil then goto _exceptionOcurred;');
    strList.Add('  jMethod:= env^.GetMethodID(env, jCls, '''+funcName+''', '''+jniSignature+'''); ');
    strList.Add('  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;');
  end;
  strList.Add('  ');

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
     else if paramType = 'Z' then paramName:= 'JBool('+paramName+')'
     else if paramType = 'C' then paramName:= 'JChar('+paramName+')';   //Canvas

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
       else if paramType = 'Z' then paramName:= 'JBool('+paramName+')'
       else if paramType = 'C' then paramName:= 'JChar('+paramName+')';

       strList.Add('  jParams['+IntToStr(i-ix)+'].'+GetJParamHack(paramType)+':= '+paramName +';');
    end;
  end;

  if Pos('()', jniSignature) = 0 then //has params
  begin
     strList.Add('  ');

     if funcResult = 'constructor' then
     begin
        strList.Add('  Result:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, this, jMethod, @jParams);');
        strList.Add('  ');
        strList.Add('  Result:= env^.NewGlobalRef(env, Result);');
     end
     else if funcResult = 'void' then
     begin
        strList.Add('  env^.CallVoidMethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
     end
     else
     begin
       if Pos('boolean',funcResult) > 0 then
       begin
         strList.Add('  jBoo:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
         strList.Add('  ');
         strList.Add('  Result:= boolean(jBoo);')
       end
       else if Pos('char',funcResult) > 0 then
       begin
         strList.Add('  jCh:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
         strList.Add('  ');
         strList.Add('  Result:= char(jCh);');
       end
       else if Pos('[',funcResult) > 0 then
       begin
         strList.Add('  jResultArray:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod,  @jParams);');
         strList.Add('  if jResultArray <> nil then'); //***
         strList.Add('  begin');
         strList.Add('    resultSize:= env^.GetArrayLength(env, jResultArray);');
         strList.Add('    SetLength(Result, resultSize);');
         if Pos('String', funcResult) > 0 then
         begin
             strList.Add('    for i:= 0 to resultsize - 1 do');
             strList.Add('    begin');
             strList.Add('      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);');
             strList.Add('      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);');
             strList.Add('    end;');
         end
         else
         begin
             strList.Add('    env^.Get'+GetArrayTypeByFuncResultHack(funcResult)+'ArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});');
         end;
         strList.Add('  end;');
       end
       else if Pos('String',funcResult) > 0 then
       begin
         strList.Add('  ');
         strList.Add('  jStr:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
         strList.Add('  ');
         strList.Add('  Result:= GetPStringAndDeleteLocalRef(env, jStr);');
       end
       else
       begin
         strList.Add('  ');
         strList.Add('  Result:= env^.Call'+GetMethodNameHack(funcResult)+'MethodA(env, _'+LowerCase(FJavaClassName)+', jMethod, @jParams);');
       end;
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
         strList.Add('  ');
         strList.Add('  Result:= boolean(jBoo);');
      end
      else if Pos('char',funcResult) > 0 then
      begin
         strList.Add('  jCh:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
         strList.Add('  ');
         strList.Add('  Result:= boolean(jCh);');
      end
      else if Pos('[',funcResult) > 0 then
      begin
        strList.Add('  jresultArray:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
        strList.Add('  if jResultArray <> nil then');
        strList.Add('  begin');
        strList.Add('    resultsize:= env^.GetArrayLength(env, jresultArray);');
        strList.Add('    SetLength(Result, resultsize);');
        if Pos('String', funcResult) > 0 then
        begin
            strList.Add('    for i:= 0 to resultsize - 1 do');
            strList.Add('    begin');
            strList.Add('      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);');
            strList.Add('      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);');
            strList.Add('    end;');
        end
        else
        begin
            strList.Add('    env^.Get'+GetArrayTypeByFuncResultHack(funcResult)+'ArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});');
        end;
        strList.Add('  end;');
      end
      else if Pos('String',funcResult) > 0 then
      begin
         strList.Add('  jStr:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
         strList.Add('  ');
         strList.Add('  Result := GetPStringAndDeleteLocalRef(env, jStr);');
      end
      else strList.Add('  Result:= env^.Call'+GetMethodNameHack(funcResult)+'Method(env, _'+LowerCase(FJavaClassName)+', jMethod);');
    end;
  end;

  if listDeleteLocalRef.Text <> '' then
     strList.Add(Trim(listDeleteLocalRef.Text));

  if funcResult <> 'constructor' then
  begin
     strList.Add('  ');
     strList.Add('  env^.DeleteLocalRef(env, jCls);');
  end;

  strList.Add(' ');

  if funcResult = 'constructor' then
   strList.Add('  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;')
  else
   strList.Add('  _exceptionOcurred: jni_ExceptionOccurred(env);');

  strList.Add('end;');

  if funcResult = 'constructor' then
  begin
    listJCreate:= TStringList.Create;
    auxStr:= funcParam;
    SplitStr(auxStr,',');
    listJCreate.Add('public java.lang.Object '+funcName+'_jCreate('+Trim(auxStr)+') {');
    auxStr2:= Trim(auxStr);
    SplitStr(auxStr2,' ');
    auxStr:='';
    ix:=1;
    for i:= ix to lstParam.Count-1 do
    begin
       lstParam.GetNameValue(i, paramName, paramType);
       auxStr:= auxStr + ',' +paramName;
    end;
    listJCreate.Add('  return (java.lang.Object)(new '+FJavaClassName+'(this'+auxStr+'));');
    listJCreate.Add('}');
    listJCreate.SaveToFile(FPathToJavaTemplates+DirectorySeparator+FJavaClassName+'.create');
    listJCreate.Free;
  end;

  strList.Add(' ');

  lstParam.Free;
  listDeleteLocalRef.Free;

  Result:= strList.Text;
  strList.Free;
end;

procedure TFrmCompCreate.DoJavaParse(produceAll: boolean);
var
  pNative, pPublic, pComment1, pComment2, pSemicolon: integer;
  s1, s2: string;
  i, p1, p2: integer;
  strList, Memo3List, Memo4List, Memo5List, Memo6List: TStringList;
  auxStr, auxName, auxParam, strPascalCode, {auxPathJNI,} methSignature, auxSignature: string;
  strOnLoadList: TStringList;
  clipList: TStringList;
begin
    Memo2List.Clear;   //global
    SynMemo2.Clear;    //global

    Memo3List:= TStringList.Create;
    Memo4List:= TStringList.Create;
    Memo5List:= TStringList.Create;
    Memo6List:= TStringList.Create;
    strOnLoadList:= TStringList.Create;

    strList:= TStringList.Create;
    clipList:= TStringList.Create;

    if  SynMemo1.SelText <> '' then
       clipList.Text:= SynMemo1.SelText
    else
       clipList.Text:= SynMemo1.Text;

    i:= 0;
    while i < clipList.Count do
    begin
        s1:= clipList.Strings[i];
        pNative:= Pos('public ', s1);
        if pNative > 0  then
        begin
          if Pos('class ', s1) <= 0 then
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
             strList.Add(Trim(Copy(s2, 1, pSemicolon)));
          end;
        end;
        inc(i);
    end;
    clipList.Free;

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

      //auxPathJNI:= FJNIDecoratedMethodName;
      //SplitStr(auxPathJNI,'_');

      auxSignature:= Trim(strList.Strings[strList.Count-2]);
      methSignature:= GetJSignature(Trim(auxParam), auxSignature);

      if produceAll then
         strPascalCode:= GetPascalCodeHack(Trim(strList.Strings[strList.Count-1]) {funct},
                                           Trim(auxParam),
                                           auxSignature{result}, methSignature)

      else if auxSignature <> 'public' then
             strPascalCode:= GetPascalCodeHack(Trim(strList.Strings[strList.Count-1]) {funct},
                                               Trim(auxParam),
                                               auxSignature{result}, methSignature);
      Memo5List.Add(strPascalCode);
      Memo6List.Add('  '+Trim(strList.Strings[strList.Count-1])+' name '''+
                       FJNIDecoratedMethodName+'_'+Trim(strList.Strings[strList.Count-1])+''',');
    end;

    auxStr:= Memo6List.Strings[Memo6List.Count-1];
    Memo6List.Strings[Memo6List.Count-1]:= ReplaceChar(auxStr,',',';');

    FPascalJNIInterfaceCode:= Memo5List.Text + LineEnding;

    Memo3List.Free;
    Memo4List.Free;
    Memo5List.Free;
    Memo6List.Free;

    strList.Free;
    strOnLoadList.Free;
end;

             {New Kotlin Support!}

//Int -> int
function TFrmCompCreate.GetJavaTypeFromKotlin(ktType: string): string;
var
  storeList: TStringList;
  javaType: string;
  index: integer;
begin
  storeList:= TStringList.Create;

  storeList.Sorted:= True;
  storeList.AddPair('Long', 'long');
  storeList.AddPair('Int', 'int');
  storeList.AddPair('Short', 'short');
  storeList.AddPair('Byte', 'byte');
  storeList.AddPair('Float','float');
  storeList.AddPair('Double','double');
  storeList.AddPair('Boolean', 'boolean');
  storeList.AddPair('Unit', 'void');
  storeList.AddPair('Void', 'void');

  index:= storeList.IndexOfName(ktType);
  if index >=0 then
    javaType:= storeList.ValueFromIndex[index]
  else
    javaType:= ktType;

  Result:= javaType;

  storeList.Free;
end;

//a: Int  --> Int a
function TFrmCompCreate.SwapKotlinParams(params: string): string;
var
  listParam, listJavaParam: TStringList;
  paramName, paramValue: string;
  i, count: integer;
begin
   listJavaParam:= TStringList.Create;
   listJavaParam.StrictDelimiter:= True;
   listJavaParam.Delimiter:= ',';
   listParam:= TStringList.Create;
   listParam.StrictDelimiter:= True;
   listParam.Delimiter:= ',';
   listParam.DelimitedText:= params;
   count:=listParam.Count;
   for i:= 0 to count-1 do
   begin
      paramValue:=listParam.Strings[i];
      paramName:= SplitStr(paramValue, ':');

      if Pos('?',paramValue) > 0 then
         paramValue:= ReplaceChar(paramValue, '?', ' ');

      listJavaParam.Add( GetJavaTypeFromKotlin( Trim(paramValue) ) + ' ' + Trim(paramName) );

   end;
   Result:= listJavaParam.DelimitedText;
   listParam.Free;
   listJavaParam.Free;
end;

function TFrmCompCreate.GetJavaSignatureFromKotlin(ktSign: string): string;
var
  kotlinParams, javaParams: string;
  kotlinMethodName: string;
  methodResult: string;
  p0, p1, p2, p3: integer;
begin
   p1:= Pos('(', ktSign);
   p2:= Pos(')', ktSign);

   kotlinParams:= Copy(ktSign, p1+1,  p2-(p1+1));

   javaParams:= SwapKotlinParams(kotlinParams);

   p0:= Pos('fun', ktSign);

   kotlinMethodName:= Copy(ktSign, p0+4,  p1 - (p0+4) );

   methodResult:=  ktSign;
   SplitStr(methodResult, ')');

   methodResult:= Trim(methodResult);

   if Length(methodResult) > 0 then
   begin
      p3:= Pos(':',methodResult);
      if p3 > 0 then
      begin
        methodResult:= Copy(methodResult, p3+1,Length(methodResult));
      end else methodResult:= 'Unit';
   end else methodResult:= 'Unit';

   Result:= 'public '+GetJavaTypeFromKotlin(Trim(methodResult))+' '+kotlinMethodName+'('+javaParams+')';

end;

//TKControl(_ctrls: Controls, _self: Long)/*: ???*/ {
function TFrmCompCreate.GetKotlinClassName(selList: TStringList): string;
var
  clsLine: string;
  foundClass: boolean;
  i, p1, p2: integer;
begin
    Result:= 'MyKotlinControl';
    if selList.Text = '' then Exit;
    foundClass:= False;
    i:= 0;
    while (not foundClass) and (i < selList.Count) do
    begin
       clsLine:= selList.Strings[i];
       p1:= Pos('class ', clsLine);
       if  p1 > 0 then foundClass:= True;
       Inc(i);
    end;
    if foundClass then
    begin
      p1:= p1 + 6; //'class '
      p2:= Pos('(',clsLine);
      Result:= Trim(Copy(clsLine,p1,p2-p1));  //get class name
    end;
end;

//public TKControl(Controls _ctrls, long _self)
function TFrmCompCreate.GetKotlinClassConstructorSignature(selList: TStringList): string;
var
  clsLine: string;
  foundClass: boolean;
  i, p1, p2: integer;
  kotlinParams, kotlinSignature: string;
begin
    Result:= 'public '+Self.FJavaClassName+'(Controls _ctrls, long _self)';

    if selList.Text = '' then Exit;
    foundClass:= False;
    i:= 0;
    while (not foundClass) and (i < selList.Count) do
    begin
       clsLine:= selList.Strings[i];
       p1:= Pos('class ', clsLine);
       if  p1 > 0 then foundClass:= True;
       Inc(i);
    end;
    if foundClass then
    begin
      p1:= Pos('(', clsLine);
      p2:= Pos (')', clsLine);
      kotlinParams:= Trim( Copy( clsLine,p1+1,p2-(p1+1) ) );  //get class name
    end;
    kotlinSignature:='fun '+Self.FJavaClassName+'('+kotlinParams+')';
    kotlinSignature:= GetJavaSignatureFromKotlin(kotlinSignature);
    Result:= StringReplace(kotlinSignature,'void', '', [rfIgnoreCase, rfReplaceAll]);
end;

procedure TFrmCompCreate.DoKotlinParse(produceAll: boolean);
var
  pNative, pPublic, pComment1, pComment2, pSemicolon: integer;
  s1, s2: string;
  i, p1, p2: integer;
  strList, Memo3List, Memo4List, Memo5List, Memo6List: TStringList;
  auxStr, auxName, auxParam, strPascalCode, {auxPathJNI,} methSignature, auxSignature: string;
  strOnLoadList: TStringList;
  clipList: TStringList;
  javaSignature, kotlinClassConstructorSignature: string;
begin
    Memo2List.Clear;   //global
    SynMemo2.Clear;    //global

    Memo3List:= TStringList.Create;
    Memo4List:= TStringList.Create;
    Memo5List:= TStringList.Create;
    Memo6List:= TStringList.Create;
    strOnLoadList:= TStringList.Create;

    strList:= TStringList.Create;
    clipList:= TStringList.Create;

    if  SynMemo1.SelText <> '' then
       clipList.Text:= SynMemo1.SelText
    else
       clipList.Text:= SynMemo1.Text;

    kotlinClassConstructorSignature:= GetKotlinClassConstructorSignature(clipList);
    strList.Add(kotlinClassConstructorSignature);

    i:= 0;
    while i < clipList.Count do
    begin
        s1:= clipList.Strings[i];
        pNative:= Pos('fun ', s1);
        if pNative > 0  then
        begin
             s2:= s1;
             pSemicolon:= Pos('{', s1);
             while pSemicolon = 0 do
             begin
               inc(i);
               s1:= s1 + clipList.Strings[i];
               s2:=DeleteLineBreaks(s1);
               pSemicolon:= Pos('{', s2);
             end;
             javaSignature:= GetJavaSignatureFromKotlin(Trim(Copy(s2, 1, pSemicolon-1)));
             strList.Add(javaSignature);
        end;
        inc(i);
    end;
    clipList.Free;

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

         if (pPublic < pComment1) and (pPublic < pComment2) then
            Memo2List.Add(s1);

       end;
    end;
    strList.Clear;

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

      //auxPathJNI:= FJNIDecoratedMethodName;
      //SplitStr(auxPathJNI,'_');

      auxSignature:= Trim(strList.Strings[strList.Count-2]);
      methSignature:= GetJSignature(Trim(auxParam), auxSignature);

      if produceAll then
         strPascalCode:= GetPascalCodeHack(Trim(strList.Strings[strList.Count-1]) {funct},
                                           Trim(auxParam),
                                           auxSignature{result}, methSignature)

      else if auxSignature <> 'public' then
             strPascalCode:= GetPascalCodeHack(Trim(strList.Strings[strList.Count-1]) {funct},
                                               Trim(auxParam),
                                               auxSignature{result}, methSignature);
      Memo5List.Add(strPascalCode);
      Memo6List.Add('  '+Trim(strList.Strings[strList.Count-1])+' name '''+
                       FJNIDecoratedMethodName+'_'+Trim(strList.Strings[strList.Count-1])+''',');
    end;

    auxStr:= Memo6List.Strings[Memo6List.Count-1];
    Memo6List.Strings[Memo6List.Count-1]:= ReplaceChar(auxStr,',',';');

    FPascalJNIInterfaceCode:= Memo5List.Text + LineEnding;

    Memo3List.Free;
    Memo4List.Free;
    Memo5List.Free;
    Memo6List.Free;

    strList.Free;
    strOnLoadList.Free;
end;

function TFrmCompCreate.TryIsKotlinComplementary(selList: TStrings): boolean;
var
  i, count, index: integer;
  flag1, flag2: boolean;
begin

   flag1:= False;
   flag2:= False;

   count:= selList.Count;
   i:= 0;
   while( i < count) do
   begin
      if Pos('class ', selList.Strings[i]) > 0 then
      begin
         index:= i;
         i:= count;
      end;
      inc(i);
   end;

   if Pos('()', selList.Strings[index]) > 0 then
   begin
      flag1:= True;
   end;

   if Pos(' fun ',  selList.Text) >  0 then
   begin
     flag2:= True;
   end
   else
   begin
      if flag1 then
      begin
         if Pos('fun ',  selList.Text) >  0 then
           flag2:= True;
      end
   end;

   if flag1 and flag2 then
   begin
     ShowMessage('warning: Handling as Kotlin code!');
     Result:= True
   end
   else
   begin
     ShowMessage('warning: Handling as Java code!');
      Result:= False;
   end;

end;

function GetPathToWizard(): string;
var
  Pkg: TIDEPackage;
begin
  Result:= '';
  Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
  if Pkg<>nil then
  begin
      Result:= ExtractFilePath(Pkg.Filename);
      Result:= Copy(Result, 1, Length(Result)-1);
      //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\
  end;
end;

procedure TFrmCompCreate.LoadSettings(const fileName: string);
var
  k: integer;
  pathToWizard: string;
begin
  if FileExistsUTF8(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      FPathToJavaJDK:=  ReadString('NewProject','PathToJavaJDK', '');
    finally
      Free;
    end;
  end;
  pathToWizard:= GetPathToWizard(); //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard
  k:= LastPos(DirectorySeparator, pathToWizard);
  FPathToLAMW:= Copy(pathToWizard, 1, k-1); //C:\laz4android18FPC304\components\androidmodulewizard
end;

//----------------------------Native Envent Pascal Interface------------------
function TFrmCompCreate.GetNativePascalTypeSignature(jSignature: string): string;
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

function TFrmCompCreate.GetNativePascalFuncResultHack(jType: string): string;
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

//public native void pOnTelephonyCallStateChanged(long pasobj, int state, String phoneNumber);
function TFrmCompCreate.GetNativePascalSignature(const methodNative: string; out eventname: string; out outType: string): string;
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

  if Self.RadioGroupPasInterface.ItemIndex = 0 then //GUI
  begin
    if fTypereturn = 'void' then
      Result:= 'procedure Java_Event_'+method+signature+');'
    else
    begin
      outType:= GetNativePascalFuncResultHack(fTypereturn) ;
      Result:= 'function Java_Event_'+method+signature+'):'+GetNativePascalTypeSignature(fTypereturn)+';';
    end;
  end
  else //raw jni/NoGUI
  begin
    if fTypereturn = 'void' then
      Result:= 'procedure Java_Call_'+method+signature+');'
    else
    begin
      outType:= GetNativePascalFuncResultHack(fTypereturn) ;
      Result:= 'function Java_Call_'+method+signature+'):'+GetNativePascalTypeSignature(fTypereturn)+';';
    end;
  end;

  if Self.RadioGroupPasInterface.ItemIndex = 0 then  //GUI
     eventname:= Copy(method, 2, MaxInt) //drop 'p'
  else
     eventname:= method;  //raw jni

  listParam.Free;
end;

function TFrmCompCreate.TryNativeConvertSignature(param: string): string;
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

function TFrmCompCreate.TryNativeConvertParam(param: string): string;
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

function TFrmCompCreate.GetNativeParamName(param: string): string;
var
  pname, ptype: string;
begin
  ptype:= param;
  pname:= SplitStr(ptype, ':');
  Result:= pname;
end;

function TFrmCompCreate.TryNativeReConvertOutSignature(ptype: string): string;
begin
  Result:= ptype;
  if ptype = 'TDynArrayOfInteger' then Result:= 'array of integer'
  else if ptype = 'TDynArrayOfString'  then Result:= 'array of string'
  else if ptype = 'TDynArrayOfSingle'  then Result:= 'array of single'
  else if ptype = 'TDynArrayOfDouble'  then Result:= 'array of double'
  else if ptype = 'TDynArrayOfJByte'   then Result:= 'array of shortint'
  else if ptype = 'jBoolean' then Result:= 'boolean'
  else if ptype = 'jString'  then Result:= 'string';
end;

function TFrmCompCreate.GetNativeOutPascalReturnInit(ptype: string): string;
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

procedure TFrmCompCreate.GetNativeMethodInterfaceList(jclassname: string; nativeMethod: TStringList; namingBypass: TStringList; MemoLines: TStrings);
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
    if Self.RadioGroupPasInterface.ItemIndex = 0 then  //GUI
    begin
       LazAndControlsEventsBody.Add('  gApp.Jni.jEnv:= env;');
       LazAndControlsEventsBody.Add('  gApp.Jni.jThis:= this;');
    end
    else  //raw jni/NoGUI
    begin
      //LazAndControlsEventsBody.Add('  //'+Self.EditMainUnit.Text+'.EnvJni.Jni.jEnv:= env;');
      //LazAndControlsEventsBody.Add('  //'+Self.EditMainUnit.Text+'.EnvJni.Jni.jThis:= this;');
    end;

    if Self.RadioGroupPasInterface.ItemIndex = 0 then  //GUI
    begin
      if outPascalReturnType <> '' then
      begin
        LazAndControlsEventsBody.Add('  outReturn:='+GetNativeOutPascalReturnInit(outPascalReturnType)+';');
      end;
    end;

    if Self.RadioGroupPasInterface.ItemIndex = 0 then    //GUI
    begin

      LazAndControlsEventsBody.Add('  if Sender is '+jclassname+' then');
      LazAndControlsEventsBody.Add('  begin');

      if outPascalReturnType = '' then
        LazAndControlsEventsBody.Add('    '+jclassname+'(Sender).GenEvent_'+outEventname+'('+params+');')
      else
        LazAndControlsEventsBody.Add('    '+jclassname+'(Sender).GenEvent_'+outEventname+'('+params+',outReturn);');

      LazAndControlsEventsBody.Add('  end;');

    end
    else //Raw jni / NoGUI
    begin
      //LazAndControlsEventsBody.Add('//if Sender is '+jclassname+' then');
      //LazAndControlsEventsBody.Add('//begin');
      if outPascalReturnType = '' then
        LazAndControlsEventsBody.Add('   '+EditMainUnit.Text+'.'+outEventname+'('+params+');')
      else
        LazAndControlsEventsBody.Add('    outReturn:= '+EditMainUnit.Text+'.'+outEventname+'('+params+');');

      //LazAndControlsEventsBody.Add('//end;');
    end;

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

    if Self.RadioGroupPasInterface.ItemIndex = 0 then //GUI
    begin
      if outPascalReturnType = '' then
         PasHeaderType.Add('T'+outEventname+'=procedure('+pasSignature+') of object;')
      else                                                                        //TryNativeReConvertOutSignature
         PasHeaderType.Add('T'+outEventname+'=procedure('+pasSignature+';var outReturn:'+outPascalReturnType+') of object;');
    end
    else //raw jni  / NoGUI
    begin
      if outPascalReturnType = '' then
         PasHeaderType.Add('procedure '+outEventname+'('+pasSignature+');')
      else                                                                        //TryNativeReConvertOutSignature
         PasHeaderType.Add('function '+outEventname+'('+pasSignature+'): '+ outPascalReturnType+';');
    end;

    if Self.RadioGroupPasInterface.ItemIndex = 0 then //GUI
    begin

      //jclassname = class
      //private;
      PasHeaderProperty.Add('  F'+smallEventName+': T'+outEventname+';');

      //public;
      if outPascalReturnType = '' then
        PasHeaderProcedure.Add('  procedure GenEvent_'+outEventname+'('+pasSignature+');')
      else                                                                                 //TryNativeReConvertOutSignature(
        PasHeaderProcedure.Add('  procedure GenEvent_'+outEventname+'('+pasSignature+';var outReturn:'+outPascalReturnType+');');

      //published
      PasHeaderPublished.Add('  property '+smallEventName+': T'+outEventname+' read F'+smallEventName+' write F'+smallEventName+';');

      //implementation;
      if outPascalReturnType = '' then
        PasBody.Add('procedure '+jclassname+'.GenEvent_'+outEventname+'('+pasSignature+');')
      else                                                                                              //TryNativeReConvertOutSignature(
        PasBody.Add('procedure '+jclassname+'.GenEvent_'+outEventname+'('+pasSignature+';var outReturn:'+outPascalReturnType+');');

      PasBody.Add('begin');

      if outPascalReturnType = '' then
        PasBody.Add('  if Assigned(F'+smallEventName+') then F'+smallEventName+'('+pasParams+');')
      else
        PasBody.Add('  if Assigned(F'+smallEventName+') then F'+smallEventName+'('+pasParams+',outReturn);');

      PasBody.Add('end;');
    end; //not raw jni

  end;//for

  MemoLines.Clear;

  MemoLines.Add(' ');
  if Self.RadioGroupPasInterface.ItemIndex = 0 then
  begin
    MemoLines.Add('//------------------ Laz_And_Controls_Events.pas -------------------------------------------');
    MemoLines.Add('//------------------(or Laz_And_Controls.pas ) ---------------------------------------------');
  end
  else
  begin
    MemoLines.Add('//------------------- java_call_bridge_'+jclassname+'.pas  ----------------------');
  end;

  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
      MemoLines.Add('unit java_call_bridge_'+jclassname+';');

  MemoLines.Add(' ');
  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
  begin
       MemoLines.Add('{$mode delphi} ');
       MemoLines.Add(' ');
  end;

  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
    MemoLines.Add('interface')
  else
    MemoLines.Add('//interface');

  MemoLines.Add(' ');
  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
  begin
    MemoLines.Add('uses');
    MemoLines.Add('  jni, jnihelper;');
  end
  else
    MemoLines.Add('//uses');
  MemoLines.Add(' ');
  for j:= 0 to  (LazAndControlsEventsHeader.Count-1) do
  begin
     MemoLines.Add(LazAndControlsEventsHeader.Strings[j]);
  end;

  MemoLines.Add(' ');
  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
    MemoLines.Add('implementation')
  else
    MemoLines.Add('//implementation');

  MemoLines.Add(' ');
  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
    MemoLines.Add('uses')
  else
    MemoLines.Add('//uses');

  if Self.RadioGroupPasInterface.ItemIndex = 0 then
     MemoLines.Add('  '+Lowercase(Copy(jclassname,2,MaxInt))+';')
  else
     MemoLines.Add('  '+EditMainUnit.Text+';');

  MemoLines.Add(' ');

  for j:= 0 to  (LazAndControlsEventsBody.Count-1) do
  begin
     MemoLines.Add(LazAndControlsEventsBody.Strings[j]);
  end;

  MemoLines.Add(' ');
  MemoLines.Add('end. ');

  MemoLines.Add(' ');
  if Self.RadioGroupPasInterface.ItemIndex = 0 then
     MemoLines.Add('//--------------------'+Lowercase(Copy(jclassname,2,MaxInt))+'.pas -------')
  else
     MemoLines.Add('//--------------------'+EditMainUnit.Text+'.pas ------------------------');

  MemoLines.Add('//' + EditMainUnit.Text+'.pas ');
  MemoLines.Add(' ');
  MemoLines.Add('//interface');
  MemoLines.Add(' ');
  MemoLines.Add('//type');
  //if raw jni
  if Self.RadioGroupPasInterface.ItemIndex <> 0 then
  begin
  //MemoLines.Add('//TEnvJni=record');
  //MemoLines.Add('//  jEnv: PJNIEnv;');  //a pointer reference to the JNI environment,
  //MemoLines.Add('//  jThis: jObject;');  //a reference to the object making this call (or class if static-> lamwrawlib1.java).
  //MemoLines.Add('//end;');
  //MemoLines.Add(' ');
  //MemoLines.Add('//var');
  //MemoLines.Add('   //EnvJni: TEnvJni');
  end;

  for j:= 0 to (PasHeaderType.Count-1) do
  begin
     MemoLines.Add(PasHeaderType.Strings[j]);
  end;

  if Self.RadioGroupPasInterface.ItemIndex = 0 then
  begin

    MemoLines.Add(' ');
    MemoLines.Add('//'+jclassname+' = class');

    MemoLines.Add('//private');
    for j:= 0 to (PasHeaderProperty.Count-1) do
    begin
      MemoLines.Add(PasHeaderProperty.Strings[j]);
    end;

    MemoLines.Add('//public');
    for j:= 0 to (PasHeaderProcedure.Count-1) do
    begin
      MemoLines.Add(PasHeaderProcedure.Strings[j]);
    end;

    MemoLines.Add('//published');
    for j:= 0 to (PasHeaderPublished.Count-1) do
    begin
      MemoLines.Add(PasHeaderPublished.Strings[j]);
    end;

    MemoLines.Add('//end;');
    MemoLines.Add(' ');
    MemoLines.Add(' ');
    MemoLines.Add('//implementation');
    MemoLines.Add(' ');
    for j:= 0 to (PasBody.Count-1) do
    begin
      MemoLines.Add(PasBody.Strings[j]);
    end;
    MemoLines.Add('//end.');
  end
  else //raw jni
  begin
     MemoLines.Add(' ');
     MemoLines.Add('//implementation');
     MemoLines.Add(' ');
      for j:= 0 to (PasHeaderType.Count-1) do
      begin
         MemoLines.Add(PasHeaderType.Strings[j]);
         MemoLines.Add('begin');
         MemoLines.Add('   //');
         MemoLines.Add('end;');
      end;
      MemoLines.Add(' ');
      MemoLines.Add('//end.');
  end;

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

//generics...
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

end.

