unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
 Classes, SysUtils, FileUtil, Controls, Forms, Dialogs,
 LazIDEIntf, ProjectIntf, FormEditingIntf, uFormAndroidProject, uformworkspace, Laz_And_Controls;

type

  TAndroidModule = class(jForm)
  end;

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIIterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJavaClass: string;
     FPathToJNIFolder: string;
     FPathToNdkPlataformsAndroidArcharmUsrLib: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}
     FPathToJavaTemplates: string;
     FAndroidProjectName: string;
     FModuleType: integer;
     FSyntaxMode: TSyntaxMode;   {}
     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode: boolean;
     function GetPathToJNIFolder(fullPath: string): string;
     function GetWorkSpaceFromForm: boolean;
     function GetAppName(className: string): string;
   public
     constructor Create; override;
     function GetLocalizedName: string; override;
     function GetLocalizedDescription: string; override;
     function DoInitDescriptor: TModalResult; override;
     function InitProject(AProject: TLazProject): TModalResult; override;
     function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

  TAndroidFileDescPascalUnitWithResource = class(TFileDescPascalUnitWithResource)
  private
    //
  public
    SyntaxMode: TSyntaxMode; {mdDelphi, mdObjFpc}
    PathToJNIFolder: string;
    ModuleType: integer;
    constructor Create; override;
    function CreateSource(const Filename     : string;
                          const SourceName   : string;
                          const ResourceName : string): string; override;
    function GetInterfaceUsesSection: string; override;
    function GetInterfaceSource(const Filename     : string;
                                const SourceName   : string;
                                const ResourceName : string): string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetImplementationSource(const Filename     : string;
                                     const SourceName   : string;
                                     const ResourceName : string): string; override;
  end;

var
  AndroidProjectDescriptor: TAndroidProjectDescriptor;
  AndroidFileDescriptor: TAndroidFileDescPascalUnitWithResource;

procedure Register;

function ReplaceChar(query: string; oldchar, newchar: char):string;
function SplitStr(var theString: string; delimiter: string): string;

implementation

procedure Register;
begin
  AndroidFileDescriptor := TAndroidFileDescPascalUnitWithResource.Create;
  RegisterProjectFileDescriptor(AndroidFileDescriptor);
  AndroidProjectDescriptor:= TAndroidProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidProjectDescriptor);
  FormEditingHook.RegisterDesignerBaseClass(TAndroidModule);
end;

{TAndroidProjectDescriptor}

function TAndroidProjectDescriptor.SettingsFilename: string;
begin
  Result := AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini'
end;

function TAndroidProjectDescriptor.GetPathToJNIFolder(fullPath: string): string;
var
  pathList: TStringList;
  i, j, k: integer;
begin
  pathList:= TStringList.Create;
  pathList.Delimiter:=DirectorySeparator;
  pathList.DelimitedText:= TrimChar(fullPath,DirectorySeparator);

  for i:=0 to pathList.Count-1 do
  begin
     if Pos('src', pathList.Strings[i])>0 then k:= i;
  end;
  Result:= '';
  for j:= 0 to k-1 do
  begin
      Result:= Result + pathList.Strings[j]+DirectorySeparator;
  end;
  Result:= TrimChar(Result, DirectorySeparator);;
  pathList.Free;
end;

function TAndroidProjectDescriptor.TryNewJNIAndroidInterfaceCode: boolean;
var
  frm: TFormAndroidProject;
  auxStr: string;
begin
  Result := False;
  frm := TFormAndroidProject.Create(nil);
  frm.ShellTreeView1.Root:= FPathToJNIFolder;
  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;
  if frm.ShowModal = mrOK then
  begin
    Result := True;

    FModuleType:= frm.ModuleType; //1=generic module; 0: GUI controls module
    FSyntaxMode:= frm.SyntaxMode;
    FPathToJavaClass:= frm.PathToJavaClass;
    FPathToJNIFolder:=GetPathToJNIFolder(FPathToJavaClass);

    AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
    AndroidFileDescriptor.ModuleType:= FModuleType;
    AndroidFileDescriptor.SyntaxMode:= FSyntaxMode;

    FJavaClassName:= frm.JavaClassName;
    FPathToClassName:= frm.PathToClassName;
    FPascalJNIIterfaceCode:= frm.PascalJNIInterfaceCode;

    {$I-}
    ChDir(FPathToJNIFolder+DirectorySeparator+ 'jni');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'jni');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj'+DirectorySeparator+FJavaClassName);
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));

    auxStr:='armeabi';
    if FInstructionSet = 'ArmV7' then auxStr:='armeabi-v7a';

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+auxStr);
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+auxStr);

  end;
  frm.Free;
end;

constructor TAndroidProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create new JNI Android Module (.so)';
end;

function TAndroidProjectDescriptor.GetLocalizedName: string;
begin
  Result := 'JNI Android Module'+ LineEnding;
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'A JNI Android loadable module (.so)'+ LineEnding +
            'in Free Pascal using DataModules.'+ LineEnding +
            'The library file is maintained by Lazarus.'
end;

function TAndroidProjectDescriptor.GetWorkSpaceFromForm: boolean;
var
  frm: TFormWorkspace;
begin
  Result := False;
  frm := TFormWorkspace.Create(nil);
  frm.LoadSettings(SettingsFilename);
  if frm.ShowModal = mrOK then
  begin
    Result := True;
    FPathToJNIFolder:= frm.PathToWorkspace;
    FPathToNdkPlataformsAndroidArcharmUsrLib:= frm.PathToNdkPlataformsAndroidArcharmUsrLib; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
    FPathToNdkToolchains:= frm.PathToNdkToolchains;
    FInstructionSet:= frm.InstructionSet;    {ArmV6}
    FFPUSet:= frm.FPUSet;            {Soft}
    frm.SaveSettings(SettingsFilename);
    FPathToJavaTemplates:= frm.PathToJavaTemplates;
    FAndroidProjectName:= frm.AndroidProjectName;
  end;
  frm.Free;
end;

function TAndroidProjectDescriptor.DoInitDescriptor: TModalResult;
begin
   //MessageDlg('Welcome to Lazarus JNI Android module Wizard!',mtInformation, [mbOK], 0);
   if GetWorkSpaceFromForm then
   begin
      if TryNewJNIAndroidInterfaceCode then
        Result := mrOK
      else
        Result := mrAbort;
   end
   else Result := mrAbort;
end;

function TAndroidProjectDescriptor.GetAppName(className: string): string;
var
  listAux: TStringList;
  lastIndex: integer;
begin
  listAux:= TStringList.Create;
  listAux.Delimiter:= '.';
  listAux.StrictDelimiter:= True;
  listAux.DelimitedText:= ReplaceChar(className,'/','.');
  lastIndex:= listAux.Count-1;
  listAux.Delete(lastIndex);
  Result:= listAux.DelimitedText;
end;

function TAndroidProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
var
  MainFile: TLazProjectFile;
  projName, auxStr: string;
  sourceList: TStringList;
begin
  inherited InitProject(AProject);
  sourceList:= TStringList.Create;
  projName:= LowerCase(FJavaClassName) + '.lpr';
  MainFile := AProject.CreateProjectFile(projName);
  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType = 0 then  //GUI controls
     AProject.AddPackageDependency('tfpandroidbridge_pack');

  sourceList.Add('{hint: save all files to location: ' +FPathToJNIFolder+DirectorySeparator+'jni }');
  sourceList.Add('library '+ LowerCase(FJavaClassName) +';');
  sourceList.Add(' ');
  sourceList.Add('{$mode delphi}');
  sourceList.Add(' ');
  sourceList.Add('uses');

  if FModuleType = 0 then  //GUI controls
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;')
  else //generic module
    sourceList.Add('  Classes, SysUtils, CustApp, And_jni;');

  sourceList.Add(' ');
  sourceList.Add('const');
  sourceList.Add('  curClassPathName: string='''';');
  sourceList.Add('  curClass: JClass=nil;');
  sourceList.Add('  curVM: PJavaVM=nil;');
  sourceList.Add('  curEnv: PJNIEnv=nil;');
  sourceList.Add(' ');
  if FModuleType = 1 then   //generic module
  begin
      sourceList.Add('type');
      sourceList.Add(' ');
      sourceList.Add('  TApp = class(TCustomApplication)');
      sourceList.Add('   public');
      sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
      sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
      sourceList.Add('     destructor Destroy; override;');
      sourceList.Add('  end;');
      sourceList.Add(' ');
      sourceList.Add('procedure TApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
      sourceList.Add('var');
      sourceList.Add('  Instance: TComponent;');
      sourceList.Add('begin');
      sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
      sourceList.Add('  TComponent(Reference):= Instance;');
      sourceList.Add('  Instance.Create(Self);');
      sourceList.Add('end;');
      sourceList.Add(' ');
      sourceList.Add('constructor TApp.Create(TheOwner: TComponent);');
      sourceList.Add('begin');
      sourceList.Add('  inherited Create(TheOwner);');
      sourceList.Add('  StopOnException:=True;');
      sourceList.Add('end;');
      sourceList.Add(' ');
      sourceList.Add('destructor TApp.Destroy;');
      sourceList.Add('begin');
      sourceList.Add('  inherited Destroy;');
      sourceList.Add('end;');
      sourceList.Add(' ');
      sourceList.Add('var');
      sourceList.Add('  App: TApp;');
      sourceList.Add(' ');
  end;
  sourceList.Add(Trim(FPascalJNIIterfaceCode));  {from form...}
  sourceList.Add(' ');
  sourceList.Add('begin');
  if FModuleType = 0 then  //GUI controls...
  begin
    sourceList.Add('  App:= jApp.Create(nil);{Laz_And_Controls}');
    sourceList.Add('  App.Title:= ''My Android GUI Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';{And_jni_Bridge}');
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';{And_jni_Bridge}');
    sourceList.Add('  App.AppName:=gjAppName;');
    sourceList.Add('  App.ClassName:=gjClassName;');
    sourceList.Add('  App.Initialize;');
    sourceList.Add('  App.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else
  begin
     sourceList.Add('  App:= TApp.Create(nil);');
     sourceList.Add('  App.Title:= ''My Android NoGUI Library'';');
     sourceList.Add('  App.Initialize;');
     sourceList.Add('  App.CreateForm(TAndroidModule1, AndroidModule1);');
  end;
  sourceList.Add('end.');

  AProject.MainFile.SetSourceText(sourceList.Text);
  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  {Set compiler options for Android requirements...}

  {Paths}
  AProject.LazCompilerOptions.Libraries:= FPathToNdkPlataformsAndroidArcharmUsrLib + ';' +
                                          FPathToNdkToolchains;
  auxStr:= 'armeabi';
  if FInstructionSet = 'ArmV7' then auxStr:='armeabi-v7a';

  AProject.LazCompilerOptions.TargetFilename:=FPathToJNIFolder+'\libs\'+auxStr;{-o}

  {Parsing}
  AProject.LazCompilerOptions.SyntaxMode:= 'delphi';  {-M}
  AProject.LazCompilerOptions.CStyleOperators:= True;
  AProject.LazCompilerOptions.AllowLabel:= True;
  AProject.LazCompilerOptions.CPPInline:= True;
  AProject.LazCompilerOptions.CStyleMacros:= True;
  AProject.LazCompilerOptions.UseAnsiStrings:= True;
  AProject.LazCompilerOptions.UseLineInfoUnit:= True;
   {Code Generation}
  AProject.LazCompilerOptions.TargetOS:= 'android'; {-T}
  AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
  AProject.LazCompilerOptions.OptimizationLevel:= 1;
  AProject.LazCompilerOptions.Win32GraphicApp:= False;
   {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;
   {Verbose}
   {Others}
  AProject.LazCompilerOptions.CustomOptions:=
                        '-dANDROID -Xd -Cp'+FInstructionSet+ ' -Cf'+FFPUSet+
                        ' -FL'+FPathToNdkPlataformsAndroidArcharmUsrLib+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                        ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+DirectorySeparator+FJavaClassName +
                        ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';  {-o}

  sourceList.Free;
  Result := mrOK;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
  Result := mrOK;
end;

{ TAndroidFileDescriptor}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;
  Name := 'Android DataModule';
  ResourceClass := TAndroidModule;
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedName: string;
begin
   Result := 'Android DataModule'
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
   Result := 'Create a new Unit with a DataModule for JNI Android module (.so)';
end;

function TAndroidFileDescPascalUnitWithResource.CreateSource(const Filename     : string;
                                                       const SourceName   : string;
                                                       const ResourceName : string): string;
var
   sourceList: TStringList;
   unitName:  string;
begin
   unitName:= FileName;
   unitName:= SplitStr(unitName,'.');
   sourceList:= TStringList.Create;
   sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }');
   sourceList.Add('unit '+unitName+';');
   sourceList.Add(' ');
   if SyntaxMode = smDelphi then
      sourceList.Add('{$mode delphi}');
   if SyntaxMode = smObjFpc then
     sourceList.Add('{$mode objfpc}{$H+}');
   sourceList.Add(' ');
   sourceList.Add('interface');
   sourceList.Add(' ');
   sourceList.Add('uses');
   sourceList.Add('  ' + GetInterfaceUsesSection);
   sourceList.Add(GetInterfaceSource(Filename, SourceName, ResourceName));
   sourceList.Add('implementation');
   sourceList.Add(' ');
   sourceList.Add(GetImplementationSource(Filename, SourceName, ResourceName));
   sourceList.Add('end.');
   Result:= sourceList.Text;
   //sourceList.SaveToFile(BasePathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'u'+ResourceName+'.pas');
   sourceList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceUsesSection: string;
begin
  if ModuleType = 1 then //generic module
    Result := 'Classes, SysUtils, And_jni;'
  else  //GUI controls module
    Result := 'Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;';
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceSource(const Filename     : string;
                                                             const SourceName   : string;
                                                           const ResourceName : string): string;
var
  strList: TStringList;
begin
  strList:= TStringList.Create;
  strList.Add(' ');
  strList.Add('type');
  if ModuleType = 0 then //GUI controls module
    strList.Add('  T' + ResourceName + ' = class(jForm)')
  else //generic module
    strList.Add('  T' + ResourceName + ' = class(TDataModule)');
  strList.Add('   private');
  strList.Add('     {private declarations}');
  strList.Add('   public');
  strList.Add('     {public declarations}');
  strList.Add('  end;');
  strList.Add(' ');
  strList.Add('var');
  strList.Add('  ' + ResourceName + ': T' + ResourceName + ';');
  Result := strList.Text;
  strList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetImplementationSource(
                                           const Filename     : string;
                                           const SourceName   : string;
                                           const ResourceName : string): string;
var
  sttList: TStringList;
begin
  sttList:= TStringList.Create;
  sttList.Add('{$R *.lfm}');
 // sttList.Add(' ');
  Result:= sttList.Text;
  sttList.Free;
end;

//helper...
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

end.

