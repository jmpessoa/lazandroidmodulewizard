unit uformupdatecodetemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Buttons, IDEIntf, ProjectIntf, LazIDEIntf, MacroIntf, LCLIntf,
  ExtCtrls, IniFiles, ThreadProcess, Clipbrd;

type

  { TFormUpdateCodeTemplate }

  TFormUpdateCodeTemplate = class(TForm)
    BitBtnOK: TBitBtn;
    BitBtnClose: TBitBtn;
    CheckGroupUpgradeTemplates: TCheckGroup;
    ComboBoxSelectProject: TComboBox;
    EditPathToWorkspace: TEdit;
    LabelPathToWorkspace: TLabel;
    LabelSelectProject: TLabel;
    sddPath: TSelectDirectoryDialog;
    SpBPathToWorkspace: TSpeedButton;
    SpBSelectProject: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure ComboBoxSelectProjectChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpBPathToWorkspaceClick(Sender: TObject);
    procedure SpBSelectProjectClick(Sender: TObject);
  private
    { private declarations }
    MemoLog: TStringList;
    ImportsList: TStringList;
    SynMemo1: TStringList;
    SynMemo2: TStringList;

    ListJNIBridge: TStringList;

    ProjectPath: string;

    JNIProjectPath: string;

    PathToWorkspace: string;
    PathToJavaTemplates: string;
    PathToJavaClass: string;

    PackageName: string;
    JNIDecoratedMethodName: string;
    JavaClassName: string;  //"Controls"

    CmdShell: string;
    APKProcess: TThreadProcess;

    procedure GetImportsList;
    function DoJavaParse: string;
    function GetJSignature(params, res: string): string;
    function GetParamSignature(param: string): string;
    function GetJTypeSignature(jType: string): string;
    function GetPascalCode(funcName, funcParam, funcResult: string): string;
    function GetFuncParam(funcParam: string): string;
    function GetParam(param: string): string;
    function GetPascalJType(jType: string): string;
    function GetFuncResult(funcResult: string): string;

    procedure RebuildLibrary; //by jmpessoa
    procedure ShowProcOutput(AOutput: TStrings);
    function ApkProcessRunning: boolean;
    procedure DoTerminated(Sender: TObject);

  public
    { public declarations }
  end;


  procedure GetSubDirectories(const directory : string; list : TStrings);
  function ReplaceChar(query: string; oldchar, newchar: char):string;
  function SplitStr(var theString: string; delimiter: string): string;
  function DeleteLineBreaks(const S: string): string;
  function TrimChar(query: string; delimiter: char): string;

var
  FormUpdateCodeTemplate: TFormUpdateCodeTemplate;

implementation

{$R *.lfm}

{ TFormUpdateCodeTemplate }

procedure TFormUpdateCodeTemplate.DoTerminated(Sender: TObject);
begin
  Clipboard.AsText:=(MemoLog.Text);
  ShowMessage('The Upgrade is Done! Please, Get the Log from Clipboard!');
end;

procedure TFormUpdateCodeTemplate.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  AmwFile: string;
begin
   AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
   with TInifile.Create(AmwFile) do
   try
      WriteString('NewProject', 'FullProjectName', ProjectPath);
      WriteString('NewProject', 'PathToWorkspace', PathToWorkspace);
   finally
      Free;
   end;

  if Assigned(APKProcess) then
    if not APKProcess.IsTerminated then APKProcess.Terminate;
end;

procedure TFormUpdateCodeTemplate.ShowProcOutput(AOutput: TStrings);
begin
   MemoLog.Add(AOutput.Text);
end;

function TFormUpdateCodeTemplate.ApkProcessRunning: boolean;
begin
  Result:= False;
  if Assigned(APKProcess) then
    if not APKProcess.IsTerminated then
      Result:= True
    else
    begin
      APKProcess:= nil;
      Result:= False;
    end;
end;

procedure TFormUpdateCodeTemplate.RebuildLibrary; //by jmpessoa
var str: string;
begin
  if JNIProjectPath = '' then
  begin
    ShowMessage('Fail! PathToLazbuild not found!' );
    Exit;
  end;
  if Assigned(APKProcess) then
  begin
    if not APKProcess.IsTerminated then APKProcess.Terminate;
  end;
  //MemoLog.Clear;
  APKProcess:= TThreadProcess.Create(True);
  with APKProcess do
  begin
    OnTerminated:= @DoTerminated;
    Dir:= Self.JNIProjectPath;  //controls.lpi
    //TODO: : [by jmpessoa] CommandLine need fix: deprecated!
    str := CmdShell + '$Path($(LazarusDir))lazbuild controls.lpi';
    IDEMacros.SubstituteMacros(str);
    CommandLine := str;
   (* TODO: [by jmpessoa]  test it!
     Executable:= 'lazbuild'
     Parameters.Add('controls.lpi');
   *)
    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;

procedure TFormUpdateCodeTemplate.BitBtnOKClick(Sender: TObject);
var
  packList: TstringList;
  fileList: TStringList;
  pk, i: integer;
  strAux: string;
begin
  MemoLog.Clear;
  if ProjectPath = '' then
  begin
     ShowMessage('Fail! Please, select a Project!');
     Exit;
  end;

  packList:= TstringList.Create;

  if FileExists(ComboBoxSelectProject.Text+DirectorySeparator+'packagename.txt') then //for release >= 0.6/05
  begin
    packList.LoadFromFile(ComboBoxSelectProject.Text+DirectorySeparator+'packagename.txt');
    PackageName:= Trim(packList.Strings[0]);  //ex. com.example.appbuttondemo1
    PathToJavaClass:= ComboBoxSelectProject.Text+DirectorySeparator+'src'+
                 DirectorySeparator+ReplaceChar(PackageName, '.',DirectorySeparator);
  end
  else  //try get PackageName from 'AndroidManifest.xml'
  begin
     packList.LoadFromFile(ComboBoxSelectProject.Text+DirectorySeparator+'AndroidManifest.xml');
     pk:= Pos('package="',packList.Text);  //ex. package="com.example.appbuttondemo1"
     strAux:= Copy(packList.Text, pk+Length('package="'), 200);

     i:= 2; //scape first[ " ]
     while strAux[i]<>'"' do
     begin
        i:= i+1;
     end;
     PackageName:= Trim(Copy(strAux, 1, i-1));

     PathToJavaClass:= ComboBoxSelectProject.Text+DirectorySeparator+'src'+
                 DirectorySeparator+ReplaceChar(PackageName, '.',DirectorySeparator);
  end;

  //upgrade "App.java"
  if  CheckGroupUpgradeTemplates.Checked[0] then
  begin
    if FileExists(PathToJavaClass+DirectorySeparator+'App.java') then
    begin
      fileList:= TStringList.Create;
      fileList.LoadFromFile(PathToJavaClass+DirectorySeparator+'App.java');
      fileList.SaveToFile(PathToJavaClass+DirectorySeparator+'App.java'+'.bak');
      fileList.Free;
    end;
    packList.Clear;
    packList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+'App.java');
    packList.Strings[0]:= 'package '+ PackageName+';'; //ex. package com.example.appbuttondemo1;
    packList.SaveToFile(PathToJavaClass+DirectorySeparator+'App.java');
    MemoLog.Add('["App.java"  :: updated!]');
    ShowMessage('"App.java"  :: updated!');
  end;

  //upgrade "Controls.java"
  if  CheckGroupUpgradeTemplates.Checked[1] then
  begin
    if FileExists(PathToJavaClass+DirectorySeparator+'Controls.java') then
    begin
      fileList:= TStringList.Create;
      fileList.LoadFromFile(PathToJavaClass+DirectorySeparator+'Controls.java');
      fileList.SaveToFile(PathToJavaClass+DirectorySeparator+'Controls.java'+'.bak');
      fileList.Free;
    end;
    packList.Clear;                                              //JavaClassName
    packList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+'Controls.java');
    packList.Strings[0]:= 'package '+ PackageName+';'; //ex. package com.example.appbuttondemo1;
    packList.SaveToFile(PathToJavaClass+DirectorySeparator+'Controls.java');
    MemoLog.Add('["Controls.java"  :: updated!]');
    ShowMessage('"Controls.java"  :: updated!');
  end;
  packList.Free;

  //upgrade [library] controls.lpr
  if  CheckGroupUpgradeTemplates.Checked[2] then
  begin
    SynMemo1.Clear; //Controls.java
    SynMemo1.LoadFromFile(PathToJavaClass+DirectorySeparator+JavaClassName+'.java');

    GetImportsList;

    SynMemo2.Clear;
    SynMemo2.Add('{hint: save all files to location: '+ProjectPath+DirectorySeparator+'jni}');
    SynMemo2.Add('library controls;  //by Lamw: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']');
    SynMemo2.Add(' ');
    SynMemo2.Add('{$mode delphi}');
    SynMemo2.Add(' ');
    SynMemo2.Add('uses');
    SynMemo2.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,');
    SynMemo2.Add('  Laz_And_Controls_Events, unit1;');
    SynMemo2.Add(' ');

    SynMemo2.Add(DoJavaParse);

    SynMemo2.Add('begin');
    SynMemo2.Add('  gApp:= jApp.Create(nil);{AndroidWidget.pas}');
    SynMemo2.Add('  gApp.Title:= ''My Android Bridges Library'';');
    SynMemo2.Add('  gjAppName:= '''+PackageName+''';{AndroidWidget.pas}');
    SynMemo2.Add('  gjClassName:= '''+ReplaceChar(PackageName, '.','/')+'/Controls'';{AndroidWidget.pas}');
    SynMemo2.Add('  gApp.AppName:=gjAppName;');
    SynMemo2.Add('  gApp.ClassName:=gjClassName;');
    SynMemo2.Add('  gApp.Initialize;');
    SynMemo2.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
    SynMemo2.Add('end.');

    if FileExists(JNIProjectPath+DirectorySeparator+'controls.lpr') then
    begin
      fileList:= TStringList.Create;
      fileList.LoadFromFile(JNIProjectPath+DirectorySeparator+'controls.lpr');
      fileList.SaveToFile(JNIProjectPath+DirectorySeparator+'controls.lpr'+'.bak');
      fileList.Free;
    end;
    SynMemo2.SaveToFile(JNIProjectPath+DirectorySeparator+'controls.lpr');

    if MessageDlg('Question', 'Do you wish to re-build ".so" library?', mtConfirmation,[mbYes, mbNo],0) = mrYes then
    begin
      MemoLog.Add('["controls.lpr"  :: update!--> ".so" :: rebuilding!]');
      RebuildLibrary;
    end;

  end;
end;

procedure TFormUpdateCodeTemplate.ComboBoxSelectProjectChange(Sender: TObject);
begin
  if ComboBoxSelectProject.ItemIndex > -1 then
  begin
    ProjectPath:= ComboBoxSelectProject.Items.Strings[ComboBoxSelectProject.ItemIndex];
    JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
    StatusBar1.SimpleText:= ProjectPath;
  end;
end;


procedure TFormUpdateCodeTemplate.FormCreate(Sender: TObject);
var
  AmwFile: string;
begin

  {$IFDEF WINDOWS}
    CmdShell:= 'cmd /c ';
  {$ENDIF}
  {$IFDEF LINUX}
    CmdShell:= 'sh -c ';
  {$ENDIF}

  MemoLog:= TStringList.Create;

  JavaClassName:= 'Controls';

  SynMemo1:= TStringList.Create;
  SynMemo2:= TStringList.Create;
  ImportsList:= TStringList.Create;
  ListJNIBridge:= TStringList.Create;

  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExists(AmwFile) then
  begin
      with TIniFile.Create(AmwFile) do  // Try to use settings from Android module wizard
      try
        ProjectPath:= ReadString('NewProject', 'FullProjectName', '');
        PathToWorkspace:=  ReadString('NewProject', 'PathToWorkspace', '');
        PathToJavaTemplates:= ReadString('NewProject', 'PathToJavaTemplates', '');
      finally
        Free
      end;
  end
end;

procedure TFormUpdateCodeTemplate.FormDestroy(Sender: TObject);
begin
  MemoLog.Free;
  SynMemo1.Free;
  SynMemo2.Free;
  ImportsList.Free;
  ListJNIBridge.Free;
end;

procedure TFormUpdateCodeTemplate.FormShow(Sender: TObject);
begin
  EditPathToWorkspace.Text:= PathToWorkspace; //by jmpessoa
  ComboBoxSelectProject.Items.Clear;  //by jmpessoa
  if PathToWorkspace <> '' then
  begin
    GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
    if ProjectPath <> '' then
    begin
      ComboBoxSelectProject.Text:= ProjectPath;
      StatusBar1.SimpleText:= 'Recent: '+ ProjectPath; //path to most recent project ...   by jmpessoa
      JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
    end;
  end;
  CheckGroupUpgradeTemplates.Checked[0]:= True;
  CheckGroupUpgradeTemplates.Checked[1]:= True;
  CheckGroupUpgradeTemplates.Checked[2]:= True;
end;

procedure TFormUpdateCodeTemplate.SpBPathToWorkspaceClick(Sender: TObject);
begin
    sddPath.Title:= 'Select Projects Workspace Path';
  if Trim(EditPathToWorkspace.Text) <> '' then
    if DirPathExists(EditPathToWorkspace.Text) then
      sddPath.InitialDir:= EditPathToWorkspace.Text;
  if sddPath.Execute then
  begin
     PathToWorkspace:= sddPath.FileName;
     EditPathToWorkspace.Text:= PathToWorkspace;
     ComboBoxSelectProject.Items.Clear;
     GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
  end;
end;

procedure TFormUpdateCodeTemplate.SpBSelectProjectClick(Sender: TObject);
begin
  PathToWorkspace:= EditPathToWorkspace.Text;   //change Workspace...
  ComboBoxSelectProject.Items.Clear;
  GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
  ComboBoxSelectProject.ItemIndex:= -1;
  ComboBoxSelectProject.Text:='';
end;

function TFormUpdateCodeTemplate.GetJTypeSignature(jType: string): string;
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
        for i:= 0 to ImportsList.Count-1 do
        begin
          if Pos(jType+';',ImportsList.Strings[i]) > 0 then   //fix here 09-september-2013
          begin                                                //again fix here 21-sept-2013
             auxList:= TStringList.Create;
             auxList.StrictDelimiter:=True;
             auxList.Delimiter:='/';
             auxList.DelimitedText:= ImportsList.Strings[i];
             if CompareText(jType+';', auxList.Strings[auxList.Count-1]) = 0 then
             begin
                Result:= ImportsList.Strings[i];
             end;
             auxList.Free;
          end;
        end;
    end;

    if Result = '' then Result:= 'UNKNOWN';
    if Pos('Controls', jType) > 0 then Result:= '';
  end;
end;

function TFormUpdateCodeTemplate.GetParamSignature(param: string): string;
var
  typeValue: string;
  nameValue: string;
begin
  nameValue:= TrimChar(param,'~');
  typeValue:= SplitStr(nameValue,'~');
  Result:= TrimChar(nameValue,'~');
  Result:= GetJTypeSignature(typeValue);
end;


function TFormUpdateCodeTemplate.GetJSignature(params, res: string): string;
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


function TFormUpdateCodeTemplate.GetPascalJType(jType: string): string;
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


function TFormUpdateCodeTemplate.GetParam(param: string): string;
var
  typeValue: string;
  nameValue: string;
begin
  nameValue:= TrimChar(param,'~');
  typeValue:= SplitStr(nameValue,'~');
  Result:= TrimChar(nameValue,'~');
  Result:= Result +': ' +GetPascalJType(typeValue);
end;

function TFormUpdateCodeTemplate.GetFuncParam(funcParam: string): string;
var
  paramList: TStringList;
  k, count: integer;
  auxParam: string;
begin
  auxParam:= ReplaceChar(Trim(funcParam),' ','~');
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

  Result:= '(PEnv: PJNIEnv; this: JObject; '+TrimChar(Result,';')+')';

  paramList.Free;
end;

function TFormUpdateCodeTemplate.GetFuncResult(funcResult: string): string;
begin
    Result:=GetPascalJType(funcResult)+'; cdecl;'
end;

function TFormUpdateCodeTemplate.GetPascalCode(funcName, funcParam, funcResult: string): string;
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
    strAux:= ListJNIBridge.Values[funcName];
    strList.Add('  '+strAux);
    strList.Add('end;');
  end
  else
  begin
    signature:= 'function '+funcName+ auxFuncParam+': '+ GetFuncResult(funcResult);
    strList.Add(signature);
    strList.Add('begin');
    strAux:= ListJNIBridge.Values[funcName];
    strList.Add('  Result:='+strAux);
    strList.Add('end;');
  end;
  Result:= strList.Text;
  strList.Free;
end;

function TFormUpdateCodeTemplate.DoJavaParse: string;
var
  pNative, pPublic, pComment1, pComment2, pSemicolon: integer;
  s1, s2: string;
  i, p1, p2: integer;
  strList, Memo3List, Memo4List, Memo5List, Memo6List: TStringList;
  auxStr, auxName, auxParam, strPascalCode, auxSignature, auxPathJNI,
  strNativeMethodsHeader, strNativeMethodsBody, methSignature, methName: string;
  strOnLoadList: TStringList;
  Memo2List: TStringList;
  pathToClassName: string;
begin

    Memo2List:= TStringList.Create;

    Memo3List:= TStringList.Create;
    Memo4List:= TStringList.Create;
    Memo5List:= TStringList.Create;
    Memo6List:= TStringList.Create;

    strOnLoadList:= TStringList.Create;

    strList:= TStringList.Create;

    i:= 0;
    while i < SynMemo1.Count do   //global -->> "Controls.java"
    begin
       s1:= SynMemo1.Strings[i];
       pNative:= Pos(' native ', s1);
       if pNative > 0  then
       begin
          s2:= s1;
          pSemicolon:= Pos(';', s1);
          while pSemicolon = 0 do
          begin
            inc(i);
            s1:= s1 + SynMemo1.Strings[i];
            s2:=DeleteLineBreaks(s1);
            pSemicolon:= Pos(';', s2);
          end;
          strList.Add(s2)
       end;
       inc(i);
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

      auxPathJNI:= JNIDecoratedMethodName;
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
                       JNIDecoratedMethodName+'_'+Trim(strList.Strings[strList.Count-1])+''',');
    end;

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
    pathToClassName:= ReplaceChar(auxPathJNI, '_', '/');
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
    strOnLoadList.Add('     RegisterNativeMethods(curEnv, '''+pathToClassName+''');');
    strOnLoadList.Add('  end;');
    strOnLoadList.Add('  gVM:= VM;{AndroidWidget.pas}');
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
    strOnLoadList.Add('    (curEnv^).DeleteGlobalRef(curEnv, gjClass);   {AndroidWidget.pas}');
    strOnLoadList.Add('    gVM:= nil;{AndroidWidget.pas}');
    strOnLoadList.Add('  end;');
    strOnLoadList.Add('  gApp.Terminate;');
    strOnLoadList.Add('  FreeAndNil(gApp);');
    strOnLoadList.Add('end;');

    auxStr:= Memo6List.Strings[Memo6List.Count-1];
    Memo6List.Strings[Memo6List.Count-1]:= ReplaceChar(auxStr,',',';');

    Result:= Memo5List.Text + strNativeMethodsHeader + LineEnding+
                                 strOnLoadList.Text + LineEnding+Memo6List.Text;
    Memo3List.Free;
    Memo4List.Free;
    Memo5List.Free;
    Memo6List.Free;
    Memo2List.Free;
    strList.Free;
    strOnLoadList.Free;
end;

procedure TFormUpdateCodeTemplate.GetImportsList;
var
  i: integer;
  auxStr: string;
  Memo2List: TStringList;
  pathList: TStringList;

begin

     ListJNIBridge.Clear;
     ListJNIBridge.LoadFromFile(PathToJavaTemplates + DirectorySeparator + 'ControlsEvents.txt');

     Memo2List:= TStringList.Create;
     pathList:= TStringList.Create;

     pathList.StrictDelimiter:= True;

     pathList.Delimiter:= '.';
     pathList.DelimitedText:= PathToJavaClass;

     JNIDecoratedMethodName:= 'Java_'+ReplaceChar(PackageName, '.','_')+'_'+ JavaClassName;

     ImportsList.Clear;
     for i:= 0 to SynMemo1.Count-1 do
     begin
        auxStr:= SynMemo1.Strings[i];
        if auxStr <> '' then
        begin
          if Pos('import ', auxStr) > 0 then
          begin
             SplitStr(auxStr,' ');
             auxStr:= ReplaceChar(auxStr,'.','/');
             ImportsList.Add('L'+trim(auxStr));
          end;
        end;
     end;

     pathList.Free;
     Memo2List.Free;

end;

//helper... by jmpessoa

//http://delphi.about.com/od/delphitips2008/qt/subdirectories.htm
//fils the "list" TStrings with the subdirectories of the "directory" directory
//Warning: if not  subdirectories was found return empty list [list.count = 0]!
procedure GetSubDirectories(const directory : string; list : TStrings);
var
   sr : TSearchRec;
begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..')) then
       begin
           List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name);
       end;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;

//helper... by jmpessoa
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
       Result:= theString;
       theString:= '';
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


end.

