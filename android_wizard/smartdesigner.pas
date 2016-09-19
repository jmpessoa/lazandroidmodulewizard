unit SmartDesigner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Forms, AndroidWidget;

type

  { TLamwSmartDesigner }

  TLamwSmartDesigner = class
  private
    FProjFile: TLazProjectFile;
    FPackageName: string;
    FStartModuleVarName: string;
    // all Paths have trailing PathDelim
    FPathToJavaSource: string;
    FPathToAndroidProject: string;

    {%region 'To remove'}
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    {%endregion}

    procedure CleanupAllJControlsSource;
    procedure GetAllJControlsFromForms(jControlsList: TStrings);
    function GetEventSignature(const nativeMethod: string): string;
    function GetPackageNameFromAndroidManifest(pathToAndroidManifest: string): string;
    function TryAddJControl(jclassname: string; out nativeAdded: boolean): boolean;
    procedure UpdateProjectLPR;
    procedure InitSmartDesignerHelpers;
    procedure UpdateStartModuleVarName;
    procedure UpdateAllJControls(AProject: TLazProject);
    {%region 'To remove'}
    function IsDemoProject: boolean;
    procedure TryChangeDemoProjecPaths;
    procedure TryFindDemoPathsFromReadme(out pathToDemoNDK, pathToDemoSDK: string);
    {%endregion}
  protected
    function OnProjectOpened(Sender: TObject; AProject: TLazProject): TModalResult;
    function OnProjectSavingAll(Sender: TObject): TModalResult;
  public
    destructor Destroy; override;
    procedure Init;
    procedure Init4Project(AProject: TLazProject);

    // called from Designer
    procedure UpdateJContros(ProjFile: TLazProjectFile; AndroidForm: TAndroidForm);
    procedure UpdateProjectStartModule(const NewName: string);
  end;


var
  LamwSmartDesigner: TLamwSmartDesigner;

implementation

uses
  Controls, Dialogs, SrcEditorIntf, LazIDEIntf, CodeToolManager, CodeTree,
  CodeCache, SourceChanger, LinkScanner, Laz2_DOM, laz2_XMLRead, FileUtil,
  LazFileUtils, LamwSettings, uJavaParser, strutils;

const
  LAMW_JAVA_NAMESPACE = 'org.lamw.common';
  LAMW_JAVA_LIBRARY = 'jLAMWcommons';

function ReplaceChar(const query: string; oldchar, newchar: char): string;
var
  i: Integer;
begin
  Result := query;
  for i := 1 to Length(Result) do
    if Result[i] = oldchar then Result[i] := newchar;
end;

{%region 'To remove'}
function GetPathToSDKFromBuildXML(fullPathToBuildXML: string): string;
var
  i, pk: integer;
  strAux: string;
  packList: TStringList;
begin
  Result:= '';
  if FileExists(fullPathToBuildXML) then
  begin
    packList:= TStringList.Create;
    packList.LoadFromFile(fullPathToBuildXML);
    pk:= Pos('location="',packList.Text);  //ex. location="C:\adt32\sdk"
    strAux:= Copy(packList.Text, pk+Length('location="'), MaxInt);
    i := PosEx('"', strAux, 2);
    Result:= Trim(Copy(strAux, 1, i-1));
    packList.Free;
  end;
end;
{%endregion}

{ TLamwSmartDesigner }

function TLamwSmartDesigner.OnProjectOpened(Sender: TObject;
 AProject: TLazProject): TModalResult;
begin
  Init4Project(AProject);
  Result := mrOK;
end;

function TLamwSmartDesigner.GetPackageNameFromAndroidManifest(pathToAndroidManifest: string): string;
var
  str: string;
  xml: TXMLDocument;
begin
  str := pathToAndroidManifest + 'AndroidManifest.xml';
  if not FileExists(str) then Exit('');
  ReadXMLFile(xml, str);
  try
    Result := xml.DocumentElement.AttribStrings['package'];
  finally
    xml.Free
  end;
end;

procedure TLamwSmartDesigner.Init4Project(AProject: TLazProject);
var
  i: Integer;
  auxList: TStringList;
begin

  if not AProject.CustomData.Contains('LAMW') then
  begin
    if not FileExists(AProject.ProjectInfoFile) then Exit;
    auxList:= TStringList.Create;
    try
      auxList.LoadFromFile(AProject.ProjectInfoFile); //full path to 'controls.lpi';
      if Pos('tfpandroidbridge_pack', auxList.Text) <= 0 then
         Exit;
      AProject.CustomData['LAMW']:= 'GUI';
    finally
      auxList.Free;
    end;
  end;

  FProjFile := AProject.MainFile;

  with AProject do
  begin
    if CustomData['LamwVersion'] <> LamwGlobalSettings.Version then
    begin
      Modified := True;
      CustomData['LamwVersion'] := LamwGlobalSettings.Version;
      UpdateAllJControls(AProject);
    end;
    FPathToAndroidProject := ExtractFilePath(AProject.MainFile.Filename);
    FPathToAndroidProject := Copy(FPathToAndroidProject, 1, RPosEX(PathDelim, FPathToAndroidProject, Length(FPathToAndroidProject) - 1));

    FPackageName := CustomData['Package'];  //legacy
    if FPackageName = '' then
    begin
      FPackageName := GetPackageNameFromAndroidManifest(FPathToAndroidProject);
      CustomData['Package'] := FPackageName;
    end;

    FPathToJavaSource := FPathToAndroidProject + 'src' + PathDelim
      + AppendPathDelim(ReplaceChar(FPackageName, '.', PathDelim));
  end;

  {%region 'To remove'}
  FPathToAndroidSDK := LamwGlobalSettings.PathToAndroidSDK;
  FPathToAndroidNDK := LamwGlobalSettings.PathToAndroidNDK;
  {%endregion}

  if not DirectoryExists(FPathToAndroidProject + 'lamwdesigner') then
    InitSmartDesignerHelpers;

{%region 'To remove'}
  // try fix/repair project paths [demos, etc..]
  if IsDemoProject() then
  begin
    TryChangeDemoProjecPaths();
  end
  else
  begin  // add/update custom
    LazarusIDE.ActiveProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
    LazarusIDE.ActiveProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK
  end;
{%endregion}

end;

procedure TLamwSmartDesigner.UpdateJContros(ProjFile: TLazProjectFile;
  AndroidForm: TAndroidForm);
var
  jControls: TStringList;
  i: Integer;
  c: TComponent;
begin
  if (ProjFile = nil) or (AndroidForm = nil) then Exit;
  jControls := TStringList.Create;
  jControls.Sorted := True;
  jControls.Duplicates := dupIgnore;
  jControls.Add('jForm');
  for i := 0 to AndroidForm.ComponentCount - 1 do
  begin
    c := AndroidForm.Components[i];
    if c is jControl then
      jControls.Add(c.ClassName)
    else
    if c.ClassName = 'TFPNoGUIGraphicsBridge' then
      jControls.Add(c.ClassName);
  end;
  jControls.Delimiter := ';';
  ProjFile.CustomData['jControls'] := jControls.DelimitedText;
  jControls.Free;
end;

procedure TLamwSmartDesigner.UpdateProjectStartModule(const NewName: string);
var
  cb: TCodeBuffer;
  IdentList: TStringList;
  OldName: string;
begin
  if not FProjFile.IsPartOfProject then Exit;

  OldName := LazarusIDE.ActiveProject.CustomData['StartModule'];
  if OldName = '' then OldName := 'AndroidModule1';
  if (NewName = '') or (OldName = NewName) then Exit;
  IdentList := TStringList.Create;
  try
    IdentList.Add(OldName);
    IdentList.Add(NewName);
    IdentList.Add('T' + OldName);
    IdentList.Add('T' + NewName);
    with CodeToolBoss do
    begin
      cb := FindFile(LazarusIDE.ActiveProject.MainFile.GetFullFilename);
      InitCurCodeTool(cb);
      SourceChangeCache.MainScanner := CurCodeTool.Scanner;
      CurCodeTool.ReplaceWords(IdentList, True, SourceChangeCache);
    end;
  finally
    IdentList.Free;
  end;
  LazarusIDE.ActiveProject.CustomData['StartModule'] := NewName;
end;

{ backup & remove all *.java from /src and all *.native from /lamwdesigner }
procedure TLamwSmartDesigner.CleanupAllJControlsSource;
var
  contentList: TStringList;
  i: integer;
  fileName: string;
begin
  ForceDirectory(FPathToJavaSource+DirectorySeparator+'bak');
  contentList := FindAllFiles(FPathToJavaSource, '*.java', False);
  for i:= 0 to contentList.Count-1 do
  begin         //do backup
    CopyFile(contentList.Strings[i],
          FPathToJavaSource+DirectorySeparator+'bak'+DirectorySeparator+ExtractFileName(contentList.Strings[i])+'.bak');

    fileName:= ExtractFileName(contentList.Strings[i]); //not delete custom java code [support to jActivityLauncher]
    if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + fileName) then
      DeleteFile(contentList.Strings[i]);

  end;
  contentList.Free;

  ForceDirectory(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+'bak');
  contentList := FindAllFiles(FPathToAndroidProject+'lamwdesigner', '*.native', False);
  for i:= 0 to contentList.Count-1 do
  begin     //do backup
    CopyFile(contentList.Strings[i],
         FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+'bak'+DirectorySeparator+ExtractFileName(contentList.Strings[i])+'.bak');

    DeleteFile(contentList.Strings[i]);
  end;
  contentList.Free;
end;

procedure TLamwSmartDesigner.GetAllJControlsFromForms(jControlsList: TStrings);
var
  list, contentList: TStringList;
  i, j, p1: integer;
  aux: string;
begin
  list := TStringList.Create;
  list.Delimiter := ';';
  with LazarusIDE.ActiveProject do
    for i := 0 to FileCount - 1 do
    begin
      list.DelimitedText := Files[i].CustomData['jControls'];
      jControlsList.AddStrings(list);
    end;
  list.Free;
  Exit;

  //No need to create the stringlist...
  if jControlsList <> nil then
  begin
    list:= TStringList.Create;
    contentList := FindAllFiles(FPathToAndroidProject+DirectorySeparator+'jni', '*.lfm', False);
    for i:= 0 to contentList.Count-1 do
    begin
      list.LoadFromFile(contentList.Strings[i]);
      for j:= 1 to list.Count - 1 do  // "1" --> skip form
      begin
        aux:= list.Strings[j];
        if Pos('object ', aux) > 0 then  //object jTextView1: jTextView
        begin
           p1:= Pos(':', aux);
           aux:=  Copy(aux, p1+1, Length(aux));
           jControlsList.Add(Trim(aux));
        end;
      end;
    end;
    list.Free;
    contentList.Free;
  end;

end;

//experimental....
function TLamwSmartDesigner.TryAddJControl(jclassname: string;
  out nativeAdded: boolean): boolean;
var
  list, listRequirements, auxList, manifestList: TStringList;
  p1, p2, i: integer;
  aux: string;
  insertRef: string;
  c: char;
begin
   nativeAdded:= False;
   Result:= False;

   if FPackageName = '' then Exit;

   if FileExists(FPathToJavaSource+DirectorySeparator+jclassname+'.java') then
     Exit; //do not duplicated!

   list:= TStringList.Create;
   manifestList:= TStringList.Create;
   listRequirements:= TStringList.Create;  //android maninfest Requirements
   auxList:= TStringList.Create;

   //try insert "jControl.java" in java project source
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.java') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.java');
     if (jclassname<>LAMW_JAVA_LIBRARY) then
     begin
       list.Strings[0]:= 'package '+FPackageName+';';
       if FileExists(FPathToJavaSource+LAMW_JAVA_LIBRARY+'.java') then
       begin
         if list.IndexOf('import '+LAMW_JAVA_NAMESPACE+'.'+LAMW_JAVA_LIBRARY+';') = -1 then
         begin
           list.Insert(1,'');
           list.Insert(1,'import '+LAMW_JAVA_NAMESPACE+'.'+LAMW_JAVA_LIBRARY+';');
           list.Insert(1,'//common LAMW library functions');
           list.Insert(1,'');
         end;
       end;
     end;

     // to be decided
     // we could add the Controls, to also include the controls variables
     if (jclassname=LAMW_JAVA_LIBRARY) then
     begin
       if FileExists(FPathToJavaSource+'Controls.java') then
       begin
         if list.IndexOf('import '+FPackageName+'.Controls;') = -1 then
         begin
           list.Insert(1,'');
           list.Insert(1,'import '+FPackageName+'.Controls;');
           list.Insert(1,'//LAMW Controls');
           list.Insert(1,'');
         end;
       end;
     end;

     list.SaveToFile(FPathToJavaSource+jclassname+'.java');
     Result:= True;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator+jclassname+'.native') then
   begin
       CopyFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator+jclassname+'.native',
                FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.native');
        nativeAdded:= True;
   end;

   //try insert "jControl.create" constructor in "Controls.java"
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.create') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.create');
     if FileExists(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.native') then
     begin
       auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.native');
       for i:= 0 to auxList.Count-1 do
           list.Add(auxList.Strings[i]);
     end;
     aux:= list.Text;
     list.LoadFromFile(FPathToJavaSource+'Controls.java');
     list.Insert(list.Count-1, aux);
     list.SaveToFile(FPathToJavaSource+'Controls.java');
   end;

   //try insert reference required by the jControl in AndroidManifest ..
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.permission') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.permission');
     if auxList.Count > 0 then
     begin
       insertRef:= '<uses-sdk android:minSdkVersion'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add permissions
       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then list.Add(Trim(auxList.Strings[i])); //not duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         p2:= p1 + Length(insertRef);
         c:= aux[p2];
         while c <> '>' do
         begin
            Inc(p2);
            c:= aux[p2];
         end;
         Inc(p2);
         insertRef:= Trim(Copy(aux, p1, p2-p1));
         p1:= Pos(insertRef, aux);
         if Length(list.Text) >  10 then  //dummy
         begin
           Insert(sLineBreak + Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.feature') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.feature');
     if auxList.Count > 0 then
     begin
       insertRef:= '<uses-sdk android:minSdkVersion'; //insert reference point

       manifestList.LoadFromFile(FPathToAndroidProject+DirectorySeparator+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add feature
       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then
           list.Add(Trim(auxList.Strings[i])); //do not insert duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         p2:= p1 + Length(insertRef);
         c:= aux[p2];
         while c <> '>' do
         begin
            Inc(p2);
            c:= aux[p2];
         end;
         Inc(p2);
         insertRef:= Trim(Copy(aux, p1, p2-p1));
         p1:= Pos(insertRef, aux);
         if Length(list.Text) > 10 then  //dummy
         begin
           Insert(sLineBreak + Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+DirectorySeparator+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.intentfilter') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.intentfilter');
     if auxList.Count > 0 then
     begin
       insertRef:= '<intent-filter>'; //insert reference point

       manifestList.LoadFromFile(FPathToAndroidProject+DirectorySeparator+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add intentfilters

       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then list.Add(Trim(auxList.Strings[i])); //not duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         if Length(list.Text) > 10 then  //dummy
         begin
           Insert(sLineBreak + Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+DirectorySeparator+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.service') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.service');
     if auxList.Count > 0 then
     begin
       insertRef:= '</activity>'; //insert reference point

       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add services

       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then list.Add(Trim(auxList.Strings[i])); //not duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         if Length(list.Text) > 10 then //dummy
         begin
           Insert(sLineBreak+Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if listRequirements.Count > 0 then
     listRequirements.SaveToFile(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.required');

   manifestList.Free;
   listRequirements.Free;
   list.Free;
   auxList.Free;

   //if doUpdateLPR then UpdateLPRProject;

end;

function TLamwSmartDesigner.GetEventSignature(const nativeMethod: string): string;
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
  end;

  Result:= method+'=Java_Event_'+method+signature+');';

  if method = 'pAppOnCreate' then
  begin
    Result := Result + FStartModuleVarName + '.Init(gApp);'
  end;

  listParam.Free;
end;

procedure TLamwSmartDesigner.UpdateProjectLPR;
var
  tempList, importList, javaClassList, nativeMethodList: TStringList;
  i, k, FromPos, ToPos: Integer;
  n: TCodeTreeNode;
  cb: TCodeBuffer;
  PosFound: Boolean;
  str: string;
  Beauty: TBeautifyCodeOptions;
begin
  if not FProjFile.IsPartOfProject then Exit;
  if FPackageName = '' then Exit;

  nativeMethodList:= TStringList.Create;
  tempList:= TStringList.Create;
  importList:= TStringList.Create;
  importList.Sorted := True;
  importList.Duplicates := dupIgnore;

  javaClassList := FindAllFiles(FPathToAndroidProject+DirectorySeparator+'lamwdesigner', '*.native', False);
  for k := 0 to javaClassList.Count - 1 do
  begin
    tempList.LoadFromFile(javaClassList.Strings[k]);
    for i := 0 to tempList.Count - 1 do
      nativeMethodList.Add(Trim(tempList.Strings[i]));
  end;
  javaClassList.Free;

  javaClassList := FindAllFiles(FPathToJavaSource, '*.java', False);
  for k := 0 to javaClassList.Count - 1 do
  begin
    tempList.LoadFromFile(javaClassList.Strings[k]);
    for i := 0 to tempList.Count - 1 do
    begin
      if Pos('import ', tempList.Strings[i]) > 0 then
        importList.Add(Trim(tempList.Strings[i]));
    end;
  end;

  tempList.Clear;
  for i:= 0 to nativeMethodList.Count-1 do
  begin
    tempList.Add(GetEventSignature(nativeMethodList.Strings[i]));
  end;

  javaClassList.Clear;
  javaClassList.Add('package ' + FPackageName + ';');
  javaClassList.Add('');
  javaClassList.AddStrings(importList);
  javaClassList.Add('public class Controls {');
  javaClassList.Add('');
  javaClassList.AddStrings(nativeMethodList);
  javaClassList.Add('}');

  if nativeMethodList.Count > 0 then
  begin
    with TJavaParser.Create(javaClassList) do
    try
      str := GetPascalJNIInterfaceCode(tempList);
      // str := '(*last [smart] upgrade: '+DateTimeToStr(Now)+'*)' + sLineBreak + str;
    finally
      Free
    end;

    with CodeToolBoss do
    begin
      cb := FindFile(FProjFile.GetFullFilename);
      PosFound := False;
      InitCurCodeTool(cb);
      CurCodeTool.BuildTree(lsrEnd);
      // search first "{%region /fold ... }"
      i := PosEx('{%', CurCodeTool.Src);
      while i > 0 do
      begin
        if CurCodeTool.CompareSrcIdentifiers(i + 2, 'region') then
        begin
          FromPos := PosEx('}', CurCodeTool.Src, i) + 1;
          k := PosEx('/fold', CurCodeTool.Src, i);
          if (k = 0) or (k > FromPos) then
          begin
            i := PosEx('{%', CurCodeTool.Src, i);
            Continue;
          end;
          i := RPos('{%', CurCodeTool.Src);
          while (i > 0) and (i > FromPos) do
          begin
            if CurCodeTool.CompareSrcIdentifiers(i + 2, 'endregion') then
            begin
              ToPos := i - 1;
              PosFound := True;
              Break;
            end;
            i := RPosEx('{%', CurCodeTool.Src, i - 1);
          end;
          Break;
        end;
        i := PosEx('{%', CurCodeTool.Src, i + 1);
      end;

      if not PosFound then // fallback
      begin
        str := '{%region /fold ''LAMW generated code''}' + sLineBreak + sLineBreak
          + str + sLineBreak + '{%endregion}' + sLineBreak;
        n := CurCodeTool.Tree.Root;
        FromPos := n.FirstChild.EndPos; // should be the end of uses-clause
        ToPos := n.LastChild.StartPos;  // should be the start of begin..end section
      end;

      Beauty := SourceChangeCache.BeautifyCodeOptions;
      SourceChangeCache.MainScanner := CurCodeTool.Scanner;
      SourceChangeCache.Replace(gtEmptyLine, gtNewLine,
        FromPos, ToPos,
        Beauty.BeautifyStatement(str, Beauty.Indent, [bcfDoNotIndentFirstLine]));
      SourceChangeCache.Apply;
    end;
  end;

  importList.Free;
  nativeMethodList.Free;
  tempList.Free;
  javaClassList.Free;
end;

procedure TLamwSmartDesigner.InitSmartDesignerHelpers;
var
  dlgMessage: string;
begin
  // FProjFile = nil if it is a just created project
  if (FProjFile = nil) or not FProjFile.IsPartOfProject then Exit;

  if not DirectoryExists(FPathToAndroidProject+'lamwdesigner') then
  begin
    ForceDirectory(FPathToJavaSource + 'bak');

    dlgMessage:= 'Hello!'+sLineBreak+sLineBreak+'We need to do an important change/update in your project.'+sLineBreak+sLineBreak+
                 'Don''t worry.'+sLineBreak+sLineBreak+'The project''s backup files will be saved as *.bak.OLD'+sLineBreak+sLineBreak+
                 'Please, whenever a dialog prompt select "Reload from disk" ';

    if QuestionDlg ('\o/ \o/ \o/    ' +
         'Welcome to LAMW version ' + LamwGlobalSettings.Version + '!',
         dlgMessage,mtCustom,[mrYes,'OK'],'') = mrYes
    then  begin
      CopyFile(FPathToJavaSource+'Controls.java',
               FPathToJavaSource+'bak'+DirectorySeparator+'Controls.java.bak.OLD');

      CopyFile(FPathToJavaSource+'App.java',
               FPathToJavaSource+'bak'+DirectorySeparator+'App.java.bak.OLD');

      CopyFile(FPathToAndroidProject+'jni'+DirectorySeparator+'controls.lpr',
               FPathToAndroidProject+'jni'+DirectorySeparator+'controls.lpr.bak.OLD');
    end;
    ForceDirectory(FPathToAndroidProject+DirectorySeparator+'lamwdesigner');
    // old [fat] *.lpr will be cleanup on project saving
  end;

end;

procedure TLamwSmartDesigner.UpdateStartModuleVarName;
var
  j: Integer;
begin
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(FProjFile.GetFullFilename));
    with CurCodeTool do
    begin
      BuildTree(lsrEnd);
      MoveCursorToCleanPos(CurCodeTool.SrcLen);
      ReadPriorAtom;
      j := Tree.Root.LastChild.StartPos;
      while CurPos.StartPos >= j do
      begin
        if UpAtomIs('CREATEFORM') then
        begin
          ReadNextAtom; // (
          ReadNextAtom; // StartModule Class Name
          ReadNextAtom; // ,
          ReadNextAtom; // StartModule Var Name
          FStartModuleVarName := GetAtom;
          Break;
        end;
        ReadPriorAtom;
      end;
    end;
    if FStartModuleVarName = '' then
      FStartModuleVarName := 'AndroidModule1';
  end;
end;

procedure TLamwSmartDesigner.UpdateAllJControls(AProject: TLazProject);
var
  jControls, LFM: TStringList;
  lfmFileName, str: string;
  i, j, k: Integer;
begin
  jControls := TStringList.Create;
  jControls.Sorted := True;
  jControls.Duplicates := dupIgnore;
  jControls.Delimiter := ';';
  LFM := TStringList.Create;
  try
    for i := 0 to AProject.FileCount - 1 do
      with AProject.Files[i] do
      begin
        lfmFileName := ChangeFileExt(Filename, '.lfm');
        if FileExists(lfmFileName) then
        begin
          jControls.Clear;
          LFM.LoadFromFile(lfmFileName);
          for j := 0 to LFM.Count - 1 do
          begin
            str := LFM[j];
            k := Pos(':', str);
            if k > 0 then
            begin
              str := Trim(Copy(str, k + 1, MaxInt));
              if (str = 'TFPNoGUIGraphicsBridge')
              or FileExists(LamwGlobalSettings.PathToJavaTemplates + 'lamwdesigner' + PathDelim + str + '.java')
              then
                jControls.Add(str);
            end;
          end;
          CustomData['jControls'] := jControls.DelimitedText;
        end;
      end;
  finally
    LFM.Free;
    jControls.Free;
  end;
end;

function TLamwSmartDesigner.OnProjectSavingAll(Sender: TObject): TModalResult;
var
  auxList, jcontrolsList: TStringList;
  j: Integer;
  nativeExists: Boolean;
  aux, PathToJavaTemplates, chipArchitecture: string;
begin
  Result := mrOk;
  if not LazarusIDE.ActiveProject.CustomData.Contains('LAMW') then Exit;

  PathToJavaTemplates := LamwGlobalSettings.PathToJavaTemplates;
  UpdateStartModuleVarName;
  auxList := TStringList.Create;

  if LamwGlobalSettings.CanUpdateJavaTemplate then
  begin
    CleanupAllJControlsSource;
    //update all java code ...
    if FileExists(PathToJavaTemplates+DirectorySeparator+'App.java') then
    begin
      auxList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+'App.java');
      auxList.Strings[0]:= 'package '+FPackageName+';';
      auxList.SaveToFile(FPathToJavaSource+'App.java');
    end;

    if FileExists(PathToJavaTemplates+'Controls.java') then
    begin
      auxList.LoadFromFile(PathToJavaTemplates+'Controls.java');
      auxList.Strings[0]:= 'package '+FPackageName+';';
      auxList.SaveToFile(FPathToJavaSource+'Controls.java');
    end;
  end;

  if FileExists(PathToJavaTemplates + 'Controls.native') then
  begin
    CopyFile(PathToJavaTemplates + 'Controls.native',
             FPathToAndroidProject+'lamwdesigner'+PathDelim+'Controls.native');
  end;

  jcontrolsList := TStringList.Create;
  jcontrolsList.Sorted := True;
  jcontrolsList.Duplicates := dupIgnore;
  GetAllJControlsFromForms(jcontrolsList);

  if FileExists(PathToJavaTemplates+'lamwdesigner'+PathDelim+LAMW_JAVA_LIBRARY+'.java') then
    TryAddJControl(LAMW_JAVA_LIBRARY, nativeExists);

  //re-add all [updated] java code ...
  for j := 0 to jcontrolsList.Count - 1 do
    if FileExists(PathToJavaTemplates+'lamwdesigner'+PathDelim+jcontrolsList.Strings[j]+'.java') then
      TryAddJControl(jcontrolsList[j], nativeExists);

  if jcontrolsList.IndexOf('TFPNoGUIGraphicsBridge') >= 0 then   //handle lib freetype need by TFPNoGUIGraphicsBridge
  begin
    auxList.LoadFromFile(FPathToJavaSource+DirectorySeparator+'Controls.java');
    aux:=  StringReplace(auxList.Text, '/*--nogui--' , '/*--nogui--*/' , [rfReplaceAll,rfIgnoreCase]);
    aux:=  StringReplace(aux, '--graphics--*/' , '/*--graphics--*/' , [rfReplaceAll,rfIgnoreCase]);
    auxList.Text:= aux;
    auxList.SaveToFile(FPathToJavaSource+DirectorySeparator+'Controls.java');

    chipArchitecture:= 'x86';
    //aux := LazarusIDE.ActiveProject.LazCompilerOptions.TargetProcessor;
    aux := LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions;
//    auxList.LoadFromFile(LazarusIDE.ActiveProject.ProjectInfoFile); //full path to 'controls.lpi';
    if Pos('-CpARMV6', aux) > 0 then chipArchitecture:= 'armeabi'
    else
    if Pos('-CpARMV7A', aux) > 0 then chipArchitecture:= 'armeabi-v7a';

    if FileExists(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libfreetype.so') then
    begin
      CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libfreetype.so',
               FPathToAndroidProject+'libs'+PathDelim+
               chipArchitecture+PathDelim+'libfreetype.so');
    end;
  end;

  if jcontrolsList.IndexOf('jActive') >= 0 then
  begin

  end;

  jcontrolsList.Free;
  auxList.Free;

  UpdateProjectLPR;
end;

destructor TLamwSmartDesigner.Destroy;
begin
  if LazarusIDE <> nil then
    LazarusIDE.RemoveAllHandlersOfObject(Self);
  inherited Destroy;
end;

procedure TLamwSmartDesigner.Init;
begin
  LazarusIDE.AddHandlerOnProjectOpened(@OnProjectOpened);
  LazarusIDE.AddHandlerOnSavingAll(@OnProjectSavingAll);
end;

procedure TLamwSmartDesigner.TryChangeDemoProjecPaths();
var
  strList: TStringList;
  strResult: string;
  lpiFileName: string;
  strLibraries: string;
  strCustom: string;
  pathToDemoNDK: string;
  pathToDemoSDK, FNDKIndex: string;
begin

  strList:= TStringList.Create;

  if FPathToAndroidSDK <> '' then
  begin
    if FileExists(FPathToAndroidProject+'build.xml') then
    begin

      pathToDemoSDK:= GetPathToSDKFromBuildXML(FPathToAndroidProject+'build.xml');
      if pathToDemoSDK <> '' then
      begin
        strList.LoadFromFile(FPathToAndroidProject+'build.xml');
        strList.SaveToFile(FPathToAndroidProject+'build.xml.bak2');
        strResult := StringReplace(strList.Text, pathToDemoSDK, FPathToAndroidSDK , [rfReplaceAll,rfIgnoreCase]);
        strList.Text := strResult;
        strList.SaveToFile(FPathToAndroidProject+'build.xml');
      end;

    end;
  end else
    ShowMessage('Sorry.. Project "build.xml" Path  to SDK not fixed... [Please, change it by hand!]');

  lpiFileName := LazarusIDE.ActiveProject.ProjectInfoFile; //full path to 'controls.lpi';
  CopyFile(lpiFileName, lpiFileName+'.bak2');

  pathToDemoNDK := LazarusIDE.ActiveProject.CustomData.Values['NdkPath'];
  FNDKIndex := LamwGlobalSettings.GetNDK;
  if (pathToDemoNDK <> '') and (FPathToAndroidNDK <> '') then
  begin
      strLibraries:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries;
      strResult:= StringReplace(strLibraries, pathToDemoNDK, FPathToAndroidNDK, [rfReplaceAll,rfIgnoreCase]);
      if (FNDKIndex = '3') or  (FNDKIndex = '4') then
      begin
        strResult:= StringReplace(strResult, '4.6', '4.9', [rfReplaceAll,rfIgnoreCase]);
      end;
      LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= strResult;

      strCustom:= LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions;
      strResult:= StringReplace(strCustom, pathToDemoNDK, FPathToAndroidNDK, [rfReplaceAll,rfIgnoreCase]);
      if (FNDKIndex = '3') or  (FNDKIndex = '4') then
      begin
        strResult:= StringReplace(strResult, '4.6', '4.9', [rfReplaceAll,rfIgnoreCase]);
      end;
      LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= strResult;

      //  add/update  custom ...
      LazarusIDE.ActiveProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
      LazarusIDE.ActiveProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK;

  end else
    ShowMessage('Sorry.. path to NDK not fixed ... [Please, change it by hand!]');

  strList.Free;
end;

procedure TLamwSmartDesigner.TryFindDemoPathsFromReadme(
  out pathToDemoNDK, pathToDemoSDK: string);
var
  strList: TStringList;
  p: integer;
  p2: integer;
begin

  strList:= TStringList.Create;
  if FileExists(FPathToAndroidProject + DirectorySeparator+'readme.txt') then
  begin
    strList.LoadFromFile(FPathToAndroidProject + DirectorySeparator+'readme.txt');

    p := Pos('System Path to Android SDK=', strList.Text);
    p := p+length('System Path to Android SDK=');

    p2 := Pos('System Path to Android NDK=', strList.Text);
    pathToDemoSDK := Trim(copy(strList.Text,p,p2-p));

    p := Pos('System Path to Android NDK=', strList.Text);
    p := p+length('System Path to Android NDK=');

    pathToDemoNDK := Trim(copy(strList.Text,p,strList.Count));
  end;

  strList.Free;
end;

function TLamwSmartDesigner.IsDemoProject(): boolean;
var
  pathToDemoNDK: string;
  pathToDemoSDK: string;
begin

  Result := False;

  pathToDemoNDK:= LazarusIDE.ActiveProject.CustomData.Values['NdkPath'];
  pathToDemoSDK:= LazarusIDE.ActiveProject.CustomData.Values['SdkPath'];

  if (pathToDemoNDK = '') and (pathToDemoSDK = '') then
  begin

    TryFindDemoPathsFromReadme(pathToDemoNDK, pathToDemoSDK);  // try "readme.txt"

    if (pathToDemoNDK = '') and (pathToDemoSDK = '') then Exit;

    //create custom data
    LazarusIDE.ActiveProject.CustomData.Values['NdkPath']:= pathToDemoNDK;
    LazarusIDE.ActiveProject.CustomData.Values['SdkPath']:= pathToDemoSDK

  end;

  if (pathToDemoNDK = FPathToAndroidNDK) and (pathToDemoSDK = FPathToAndroidSDK) then Exit;

  Result:= True;
end;

initialization
  LamwSmartDesigner := TLamwSmartDesigner.Create;

finalization
  LamwSmartDesigner.Free;

end.

