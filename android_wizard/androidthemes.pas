unit AndroidThemes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, AvgLvlTree, Laz2_DOM, Graphics;

type
  TAndroidThemes = class;

  { TAndroidTheme }

  TAndroidTheme = class
  private
    FOwner: TAndroidThemes;
    FMinAPI: Integer;
    FName: string; // full dotted name like "Theme.Holo.Light"
    FLoaded: Boolean;
    FParent: TAndroidTheme;
    FContent: TDOMElement;
    FColorCache: TStringList; // x>y>z -> TColorCacheItem
    function PathToKey(const APath: array of string): string; { TODO: inline }
    function FindInColorCache(const APath: array of string;
      out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
    function FindInColorCache(const APathStr: string;
      out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
    procedure AddToColorCache(const APath: array of string;
      WasFound: Boolean; ARed, AGreen, ABlue, AAlpha: Byte);
    function Loaded: Boolean; // FContent = node from themes.xml
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure ClearColorCache;
    function ShortName: string;
    function GetColor(const colorName: string): TColor;
    function TryGetColor(const colorName: string;
      out Red, Green, Blue, Alpha: Byte): Boolean;
    function TryGetColor(const Path: array of string;
      out Red, Green, Blue, Alpha: Byte): Boolean;
    function TryGetColor(const Path: array of string;
      out Color: TColor): Boolean;
    function GetColorDef(const colorName: string; DefValue: TColor): TColor;
    function Find(const tagName, attrName, attrVal: string): TDOMElement;
    property MinAPI: Integer read FMinAPI;
    property Name: string read FName;
  end;

  { TAndroidThemes }

  TAndroidThemes = class
  private
    FInited: Boolean;
    FAPI: Integer;
    FThemes: TAvgLvlTree;
    FXMLs: TStringList; // objects are TXMLDocument
    FBasePath: string; // %{sdk}/platforms/android-XX/data/res/values/
    function AddTheme(const ThemeName: string; MinAPI: Integer): TAndroidTheme;
    procedure Clear;
    function LoadXML(FileName: string): TXMLDocument;
    function FindNodeAttribInFiles(const BaseFileName, ATag, AAttr, AVal: string): TDOMElement;
    procedure ClearXMLCache(const ProjRoot: string);
    function Resolve(link: string; const PathToProjRoot: string = '';
      TargetAPI: Integer = 0): TDOMNode;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init(API: Integer);
    function GetTheme(const AndroidManifestFileName: string): TAndroidTheme;
    function Count: Integer;
    function FindTheme(const ThemeName: string): TAndroidTheme;
    procedure ReInit(API: Integer); // reloading available themes from SDK
  end;

var
  Themes: TAndroidThemes;

implementation

uses LamwSettings, strutils, laz2_XMLRead, FileUtil;

type
  TColorCacheItem = class
  public
    Red, Green, Blue, Alpha: Byte;
  end;

function FindNodeAttrib(root: TDOMElement; const ATag, AAttr, AVal: string): TDOMElement;
var
  n: TDOMNode;
begin
  if not root.HasChildNodes then Exit(nil);
  n := root.FirstChild;
  while n <> nil do
  begin
    if n is TDOMElement then
      with TDOMElement(n) do
        if (TagName = ATag) and (AttribStrings[AAttr] = AVal) then
        begin
          Result := TDOMElement(n);
          Exit;
        end;
    n := n.NextSibling;
  end;
  Result := nil;
end;

{ TAndroidThemes }

function CmpAndroidThemes(p1, p2: Pointer): Integer;
var
  t1: TAndroidTheme absolute p1;
  t2: TAndroidTheme absolute p2;
begin
  Result := CompareStr(t1.Name, t2.Name);
end;

function FindThemeByName(p1, p2: Pointer): Integer;
var
  pname: Pstring absolute p1;
  t: TAndroidTheme absolute p2;
begin
  Result := CompareStr(pname^, t.Name);
end;

function TAndroidThemes.AddTheme(const ThemeName: string;
  MinAPI: Integer): TAndroidTheme;
begin
  Result := TAndroidTheme.Create(ThemeName);
  Result.FMinAPI := MinAPI;
  Result.FOwner := Self;
  FThemes.Add(Result);
end;

procedure TAndroidThemes.Clear;
begin
  FThemes.FreeAndClear;
  FXMLs.Clear;
end;

function TAndroidThemes.LoadXML(FileName: string): TXMLDocument;
var
  i: Integer;
begin
  if Pos(PathDelim, FileName) = 0 then
    FileName := FBasePath + FileName;
  if not FileExists(FileName) then Exit(nil);
  i := FXMLs.IndexOf(FileName);
  if i >= 0 then
    Result := TXMLDocument(FXMLs.Objects[i])
  else begin
    ReadXMLFile(Result, FileName);
    FXMLs.AddObject(FileName, Result);
  end
end;

function TAndroidThemes.FindNodeAttribInFiles(const BaseFileName, ATag, AAttr, AVal: string): TDOMElement;
var
  xml: TXMLDocument;
  files: TStringList;
  i: Integer;
begin
  Result := nil;
  xml := LoadXML(BaseFileName + '.xml');
  if xml <> nil then
  begin
    Result := FindNodeAttrib(xml.DocumentElement, ATag, AAttr, AVal);
    if Result <> nil then Exit;
  end;
  files := FindAllFiles(FBasePath, BaseFileName + '_*.xml', False);
  try
    for i := 0 to files.Count - 1 do
    begin
      xml := LoadXML(files[i]);
      if xml <> nil then
      begin
        Result := FindNodeAttrib(xml.DocumentElement, ATag, AAttr, AVal);
        if Result <> nil then Exit;
      end;
    end;
  finally
    files.Free
  end;
end;

procedure TAndroidThemes.ClearXMLCache(const ProjRoot: string);

  function Starts(const s1, s2: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if Length(s1) > Length(s2) then Exit;
    for i := 1 to Length(s1) do
      if s1[i] <> s2[i] then Exit;
    Result := True;
  end;

var
  i: Integer;
begin
  for i := FXMLs.Count - 1 downto 0 do
    if Starts(ProjRoot, FXMLs[i]) then
      FXMLs.Delete(i);
end;

function TAndroidThemes.FindTheme(const ThemeName: string): TAndroidTheme;
var
  n: TAvgLvlTreeNode;
begin
  n := FThemes.FindKey(@ThemeName, @FindThemeByName);
  if Assigned(n) then
    Result := TAndroidTheme(n.Data)
  else
    Result := nil;
end;

constructor TAndroidThemes.Create;
begin
  FThemes := TAvgLvlTree.Create(@CmpAndroidThemes);
  FXMLs := TStringList.Create;
  FXMLs.CaseSensitive := True;
  FXMLs.OwnsObjects := True;
  FXMLs.Sorted := True;
end;

destructor TAndroidThemes.Destroy;
begin
  Clear;
  FThemes.Free;
  FXMLs.Free;
  inherited Destroy;
end;

procedure TAndroidThemes.Init(API: Integer);
var
  xml: TXMLDocument;
  n, p: TDOMNode;
  FCurAPI: Integer;
  str: DOMString;
  i: SizeInt;
begin
  if FInited and (FAPI >= API) then Exit;
  FInited := False;
  FBasePath := LamwGlobalSettings.PathToAndroidSDK + 'platforms/android-' + IntToStr(API)
    + '/data/res/values/';
  DoDirSeparators(FBasePath);
  if not FileExists(FBasePath + 'public.xml') then Exit;
  ReadXMLFile(xml, FBasePath + 'public.xml');
  try
    Clear;
    FAPI := API;
    FCurAPI := 0;
    p := nil;
    n := xml.DocumentElement.FirstChild;
    while n <> nil do
    begin
      if n is TDOMElement then
        with TDOMElement(n) do
          if (TagName = 'eat-comment') and (p is TDOMComment) then
          begin
            str := TDOMComment(p).TextContent;
            i := Pos('version ', str);
            if i > 0 then
            begin
              Delete(str, 1, i + 6);
              str := TrimLeft(str);
              i := 1;
              while (i < Length(str)) and (str[i] in ['0'..'9']) do Inc(i);
              if (i > 1) then
                FCurAPI := StrToInt(Copy(str, 1, i - 1));
            end;
          end else
          if (TagName = 'public') and (AttribStrings['type'] = 'style') then
          begin
            str := AttribStrings['name'];
            if Copy(str, 1, 5) = 'Theme' then
              AddTheme(str, FCurAPI);
          end;
      p := n;
      n := n.NextSibling;
    end;
  finally
    xml.Free;
  end;
  FInited := True;
end;

function TAndroidThemes.Resolve(link: string; const PathToProjRoot: string;
  TargetAPI: Integer): TDOMNode;

  function ResolveStyle(const search: string): TDOMElement;
  var
    i: Integer;
    s: string;
    xml: TXMLDocument;
    n: TDOMElement;
    Found: Boolean;
  begin
    Result := nil;
    i := TargetAPI;
    repeat
      s := PathToProjRoot + 'res' + PathDelim + 'values-v' + IntToStr(i)
        + PathDelim + 'styles.xml';
      Found := FileExists(s);
      Dec(i);
    until (i <= 0) or Found;
    if not Found then Exit;
    xml := LoadXML(s);
    if xml = nil then Exit;
    n := FindNodeAttrib(xml.DocumentElement, 'style', 'name', search);
    if n <> nil then Exit(n);
    s := PathToProjRoot + 'res' + PathDelim + 'values' + PathDelim + 'styles.xml';
    xml := LoadXML(s);
    if xml = nil then Exit;
    n := FindNodeAttrib(xml.DocumentElement, 'style', 'name', search);
    if n <> nil then Exit(n);
    Result := FindNodeAttribInFiles('styles', 'style', 'name', search);
  end;

  function ResolveAndroidStyle(const search: string): TDOMNode;
  var
    xml: TXMLDocument;
  begin
    Result := nil;
    xml := LoadXML('styles.xml');
    if xml = nil then Exit;
    Result := FindNodeAttrib(xml.DocumentElement, 'style', 'name', search);
    if Result = nil then
    begin
      xml := LoadXML('styles_device_defaults.xml');
      if xml = nil then Exit;
      Result := FindNodeAttrib(xml.DocumentElement, 'style', 'name', search);
    end;
  end;

  function ResolveAndroidColor(const search: string): TDOMNode;
  var
    xml: TXMLDocument;
    fn: string;
    n, n1: TDOMNode;
  begin
    Result := FindNodeAttribInFiles('colors', 'color', 'name', search);
    if Result = nil then
    begin
      fn := FBasePath;
      fn := Copy(fn, 1, RPosEX(PathDelim, fn, Length(fn) - 1));
      fn := fn + 'color' + PathDelim + search + '.xml';
      if FileExists(fn) then
      begin
        xml := LoadXML(fn);
        n := xml.DocumentElement.LastChild;
        while n <> nil do
        begin
          if (n is TDOMElement) and (n.Attributes.Length = 1) then
          begin
            n1 := n.Attributes.GetNamedItem('android:color');
            if n1 <> nil then Exit(n1);
          end;
          n := n.PreviousSibling;
        end;
      end;
    end;
  end;

var
  LinkType: string;
  i: Integer;
begin
  i := Pos('/', link);
  LinkType := Copy(link, 2, i - 2);
  Delete(link, 1, i);
  if LinkType = 'style' then
    Result := ResolveStyle(link)
  else
  if LinkType = 'android:style' then
    Result := ResolveAndroidStyle(link)
  else
  if (LinkType = 'android:color') or (LinkType = 'color') then
    Result := ResolveAndroidColor(link)
  else
    Result := nil;
end;

function TAndroidThemes.GetTheme(const AndroidManifestFileName: string): TAndroidTheme;
var
  TargetAPI: Integer;
  xml: TXMLDocument;
  n: TDOMNode;
  s, pp: string;
begin
  Result := nil;
  if not FileExists(AndroidManifestFileName) then Exit;
  xml := LoadXML(AndroidManifestFileName);
  n := xml.DocumentElement.FindNode('uses-sdk');
  if n = nil then Exit;
  s := TDOMElement(n).AttribStrings['android:targetSdkVersion'];
  if not TryStrToInt(s, TargetAPI) then Exit;
  n := xml.DocumentElement.FindNode('application');
  if n = nil then Exit;
  s := TDOMElement(n).AttribStrings['android:theme'];
  if s = '' then Exit;
  Init(TargetAPI);
  if not FInited then Exit;
  pp := ExtractFilePath(AndroidManifestFileName);
  ClearXMLCache(pp);
  while s[1] = '@' do
  begin
    n := Resolve(s, pp, TargetAPI);
    if not (n is TDOMElement) then Exit;
    s := TDOMElement(n).AttribStrings['parent'];
    if s = '' then Exit;
    if Pos(':', s) = 0 then
      s := '@style/' + s;
  end;
  if Copy(s, 1, 8) = 'android:' then
    Delete(s, 1, 8);
  Result := FindTheme(s);
end;

function TAndroidThemes.Count: Integer;
begin
  Result := FThemes.Count;
end;

procedure TAndroidThemes.ReInit(API: Integer);
begin
  FThemes.Clear;
  FInited := False;
  Init(API);
end;

{ TAndroidTheme }

function TAndroidTheme.PathToKey(const APath: array of string): string;
var
  i: Integer;
begin
  Result := APath[0];
  for i := 1 to High(APath) do
    Result := Result + '>' + APath[i];
end;

function TAndroidTheme.FindInColorCache(const APath: array of string;
  out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
begin
  Result := FindInColorCache(PathToKey(APath), WasFound, ARed, AGreen, ABlue, AAlpha);
end;

function TAndroidTheme.FindInColorCache(const APathStr: string;
  out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
var
  i: Integer;
begin
  i := FColorCache.IndexOf(APathStr);
  Result := i >= 0;
  if Result then
  begin
    WasFound := FColorCache.Objects[i] <> nil;
    if WasFound then
      with TColorCacheItem(FColorCache.Objects[i]) do
      begin
        ARed := Red;
        AGreen := Green;
        ABlue := Blue;
        AAlpha := Alpha;
      end;
  end;
end;

procedure TAndroidTheme.AddToColorCache(const APath: array of string;
  WasFound: Boolean; ARed, AGreen, ABlue, AAlpha: Byte);
var
  i: Integer;
  key: string;
  it: TColorCacheItem;
begin
  key := PathToKey(APath);
  i := FColorCache.IndexOf(key);
  if i >= 0 then Exit;
  i := FColorCache.Add(key);
  if WasFound then
  begin
    it := TColorCacheItem.Create;
    it.Red := ARed;
    it.Green := AGreen;
    it.Blue := ABlue;
    it.Alpha := AAlpha;
    FColorCache.Objects[i] := it;
  end;
end;

function TAndroidTheme.Loaded: Boolean;

  function FindIn(XmlFileName: string): TDOMElement;
  var
    n: TDOMNode;
    xml: TXMLDocument;
  begin
    Result := nil;
    xml := FOwner.LoadXML(XmlFileName);
    if xml = nil then Exit;
    n := xml.DocumentElement.FirstChild;
    while n <> nil do
    begin
      if (n is TDOMElement) then
        with TDOMElement(n) do
          if (TagName = 'style') and (AttribStrings['name'] = FName) then
          begin
            Result := TDOMElement(n);
            Break;
          end;
      n := n.NextSibling;
    end;
  end;

var
  parent: string;
begin
  if FLoaded then Exit(True);
  FContent := FOwner.FindNodeAttribInFiles('themes', 'style', 'name', FName);
  if FContent = nil then Exit(False);
  parent := FContent.AttribStrings['parent'];
  if parent <> '' then
  begin
    FParent := FOwner.FindTheme(parent);
    if FParent = nil then
      raise Exception.CreateFmt('There is no parent theme "%s" for "%s"!', [parent, FName]);
  end;
  FLoaded := True;
  Result := True;
end;

constructor TAndroidTheme.Create(const AName: string);
begin
  FName := AName;
  FColorCache := TStringList.Create;
  FColorCache.Sorted := True;
  FColorCache.OwnsObjects := True;
  FColorCache.CaseSensitive := True;
end;

destructor TAndroidTheme.Destroy;
begin
  FColorCache.Free;
  inherited Destroy;
end;

procedure TAndroidTheme.ClearColorCache;
begin
  FColorCache.Clear;
end;

function TAndroidTheme.ShortName: string;
var
  i: Integer;
begin
  Result := FName;
  i := RPos('.', Result);
  if i > 0 then
    Delete(Result, 1, i);
end;

function TAndroidTheme.GetColor(const colorName: string): TColor;
begin
  Result := GetColorDef(colorName, clNone);
end;

function TAndroidTheme.TryGetColor(const colorName: string; out Red, Green, Blue, Alpha: Byte): Boolean;
var
  i: Integer;
  t: TAndroidTheme;
  s: string;
  n: TDOMNode;
begin
  if FindInColorCache([colorName], Result, Red, Green, Blue, Alpha) then Exit;
  Result := False;
  if not Loaded then Exit;
  try
    s := colorName;
    while s <> '' do
      case s[1] of
      '#':
        begin
          Result := True;
          Delete(s, 1, 1);
          if Length(s) > 8 then
            s := RightStr(s, 8);
          while Length(s) < 6 do s := '0' + s;
          case Length(s) of
          6: s := 'ff' + s;
          7: s := '0' + s;
          end;
          Alpha := StrToInt('$' + Copy(s, 1, 2));
          Red := StrToInt('$' + Copy(s, 3, 2));
          Green := StrToInt('$' + Copy(s, 5, 2));
          Blue := StrToInt('$' + Copy(s, 7, 2));
          Exit;
        end;
      '?':
        begin
          i := Pos('/', s);
          if i = 0 then i := 1;
          Delete(s, 1, i);
        end;
      '@':
        begin
          n := FOwner.Resolve(s);
          if n = nil then Break;
          s := n.TextContent;
        end;
      else
        n := FindNodeAttrib(FContent, 'item', 'name', s);
        if n = nil then Break;
        s := n.TextContent;
      end;
    if FParent <> nil then
      Result := FParent.TryGetColor(colorName, Red, Green, Blue, Alpha);
    if not Result then
    begin
      i := RPos('.', Name);
      if i > 0 then
      begin
        t := FOwner.FindTheme(Copy(Name, 1, i - 1));
        if t <> nil then
          Result := t.TryGetColor(colorName, Red, Green, Blue, Alpha);
      end;
    end;
  finally
    AddToColorCache([colorName], Result, Red, Green, Blue, Alpha);
  end;
end;

function TAndroidTheme.TryGetColor(const Path: array of string;
  out Red, Green, Blue, Alpha: Byte): Boolean;

  function FindNodeUsingParent(root: TDOMElement; const tag, attr, val: string): TDOMNode;
  begin
    Result := FindNodeAttrib(root, tag, attr, val);
    if (Result = nil) and (root.AttribStrings['parent'] <> '') then
    begin
      root := FOwner.Resolve('@android:' + root.TagName + '/' + root.AttribStrings['parent']) as TDOMElement;
      if root <> nil then
        Result := FindNodeUsingParent(root, tag, attr, val);
    end;
  end;

var
  i: Integer;
  s: DOMString;
  n: TDOMNode;
begin
  if FindInColorCache(Path, Result, Red, Green, Blue, Alpha) then Exit;
  Result := False;
  if not Loaded then Exit;
  try
    n := Find('item', 'name', Path[0]);
    for i := 1 to High(Path) do
    begin
      repeat
        if not (n is TDOMElement) then Exit;
        if (n.ChildNodes.Count > 0) and (n.ChildNodes.Item[0].NodeType = TEXT_NODE) then
        begin
          s := TDOMElement(n).TextContent;
          if (s <> '') and (s[1] = '@') then
            n := FOwner.Resolve(s)
          else
          if (s <> '') and (s[1] = '?') then
          begin
            Delete(s, 1, Pos('/', s));
            n := Find('item', 'name', s);
          end else
            Break;
        end else
          Break;
      until False;
      n := FindNodeUsingParent(TDOMElement(n), 'item', 'name', Path[i]);
      if n = nil then Exit;
    end;
    s := TDOMElement(n).TextContent;
    if (s = '') then Exit;
    Result := TryGetColor(s, Red, Green, Blue, Alpha);
  finally
    AddToColorCache(Path, Result, Red, Green, Blue, Alpha);
  end;
end;

function TAndroidTheme.TryGetColor(const Path: array of string; out Color: TColor): Boolean;
var
  r, g, b, a: Byte;
begin
  Result := TryGetColor(Path, r, g, b, a);
  if Result then
    Color := RGBToColor(r, g, b);
end;

function TAndroidTheme.GetColorDef(const colorName: string;
  DefValue: TColor): TColor;
var
  r, g, b, a: Byte;
begin
  if not TryGetColor(colorName, r, g, b, a) then
    Result := DefValue
  else
    Result := RGBToColor(r, g, b);
end;

function TAndroidTheme.Find(const tagName, attrName, attrVal: string): TDOMElement;
var
  i: Integer;
  t: TAndroidTheme;
begin
  Result := nil;
  if not Loaded then Exit;
  Result := FindNodeAttrib(FContent, tagName, attrName, attrVal);
  if Result = nil then
  begin
    if FParent <> nil then
      Result := FParent.Find(tagName, attrName, attrVal)
    else
    begin
      i := RPos('.', Name);
      if i > 0 then
      begin
        t := FOwner.FindTheme(Copy(Name, 1, i - 1));
        if t <> nil then
          Result := t.Find(tagName, attrName, attrVal);
      end;
    end;
  end;
end;

initialization
  Themes := TAndroidThemes.Create;

finalization
  Themes.Free;

end.

