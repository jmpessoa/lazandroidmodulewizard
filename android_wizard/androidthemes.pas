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
    FCache: TStringList; // x>y>z -> TColorCacheItem
    function PathToKey(const APath: array of string; const attribs: string): string; { TODO: inline }
    function FindColorInCache(const APath: array of string; attribs: string;
      out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
    function FindColorInCache(const APathStr: string;
      out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
    function FindDrawableInCache(const APathKey: string;
      out WasFound: Boolean; out Drawable: string): Boolean;
    function FindPath(const Path: array of string): TDOMNode;
    procedure AddColorToCache(const APath: array of string;
      WasFound: Boolean; attribs: string; ARed, AGreen, ABlue, AAlpha: Byte);
    procedure AddDrawableToCache(const APathKey: string; WasFound: Boolean; Drawable: string);
    function Loaded: Boolean; // FContent = node from themes.xml
    function TryResolve(n: TDOMNode): TDOMNode;
    function Selector(AParent: TDOMNode; const attribs, aname: string): string;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure ClearCache;
    function ShortName: string;
    function GetColor(const colorName: string): TColor;
    function TryGetColor(const colorName: string; attribs: string;
      out Red, Green, Blue, Alpha: Byte): Boolean;
    function TryGetColor(const Path: array of string; attribs: string;
      out Red, Green, Blue, Alpha: Byte): Boolean;
    function TryGetColor(const Path: array of string; attribs: string;
      out Color: TColor): Boolean;
    function GetColorDef(const colorName: string; DefValue: TColor): TColor;
    function Find(const tagName, attrName, attrVal: string): TDOMElement;
    function FindDrawable(const Path: array of string; const attribs: string): string;
    property MinAPI: Integer read FMinAPI;
    property Name: string read FName;
  end;

  { TAndroidThemes }

  TAndroidThemes = class
  private
    FInited: Boolean;
    FAPI: Integer;
    FThemes: TStringList;
    FXMLs: TStringList; // objects are TXMLDocument
    FBasePath: string; // %{sdk}/platforms/android-XX/data/res/values/
    function AddTheme(const ThemeName: string; MinAPI: Integer): TAndroidTheme;
    procedure Clear;
    function LoadXML(FileName: string; ForceReload: Boolean = False): TXMLDocument;
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

  TDrawableCacheItem = class
  public
    fname: string;
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

function TAndroidThemes.AddTheme(const ThemeName: string;
  MinAPI: Integer): TAndroidTheme;
begin
  Result := TAndroidTheme.Create(ThemeName);
  Result.FMinAPI := MinAPI;
  Result.FOwner := Self;
  FThemes.AddObject(ThemeName, Result);
end;

procedure TAndroidThemes.Clear;
begin
  FThemes.Clear;
  FXMLs.Clear;
end;

function TAndroidThemes.LoadXML(FileName: string; ForceReload: Boolean): TXMLDocument;
var
  i: Integer;
begin
  if Pos(PathDelim, FileName) = 0 then
    FileName := FBasePath + FileName;
  FileName := ExpandFileName(FileName);
  if not FileExists(FileName) then Exit(nil);
  i := FXMLs.IndexOf(FileName);
  if ForceReload and (i >= 0) then
  begin
    FXMLs.Delete(i);
    i := -1;
  end;
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
  n: Integer;
begin
  Result := nil;
  n := FThemes.IndexOf(ThemeName);
  if n >= 0 then
    Result := TAndroidTheme(FThemes.Objects[n])
end;

constructor TAndroidThemes.Create;
begin
  FThemes := TStringList.Create;
  FThemes.Sorted := True;
  FThemes.OwnsObjects := True;
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
  //if FInited and (FAPI >= API) then Exit;
  if FInited then ClearXMLCache('');
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

  function ResolveAndroidDrawable(const search: string): TDOMNode;
  var
    xml: TXMLDocument;
  begin
    Result := nil;
    xml := LoadXML(FBasePath + '../drawable/' + search + '.xml');
    if xml = nil then Exit;
    Result := xml.DocumentElement;
  end;

  function ResolveAndroidColor(const search: string): TDOMNode;
  var
    fn: string;
  begin
    fn := ExpandFileName(FBasePath + '../color/' + search + '.xml');
    if FileExists(fn) then
      Result := LoadXML(fn).DocumentElement
    else
      Result := FindNodeAttribInFiles('colors', 'color', 'name', search);
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
  if LinkType = 'android:drawable' then
    Result := ResolveAndroidDrawable(link)
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
  xml := LoadXML(AndroidManifestFileName, True);
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

function TAndroidTheme.PathToKey(const APath: array of string;
  const attribs: string): string;
var
  i: Integer;
begin
  Result := APath[0];
  for i := 1 to High(APath) do
    Result := Result + '>' + APath[i];
  Result := Result + '|' + attribs;
end;

function TAndroidTheme.FindColorInCache(const APath: array of string;
  attribs: string; out WasFound: Boolean;
  out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
begin
  Result := FindColorInCache(PathToKey(APath, attribs), WasFound, ARed, AGreen, ABlue, AAlpha);
end;

function TAndroidTheme.FindColorInCache(const APathStr: string;
  out WasFound: Boolean; out ARed, AGreen, ABlue, AAlpha: Byte): Boolean;
var
  i: Integer;
begin
  i := FCache.IndexOf(APathStr);
  Result := i >= 0;
  if Result then
  begin
    WasFound := FCache.Objects[i] is TColorCacheItem;
    if WasFound then
      with TColorCacheItem(FCache.Objects[i]) do
      begin
        ARed := Red;
        AGreen := Green;
        ABlue := Blue;
        AAlpha := Alpha;
      end;
  end;
end;

function TAndroidTheme.FindDrawableInCache(const APathKey: string; out
  WasFound: Boolean; out Drawable: string): Boolean;
var
  i: Integer;
begin
  i := FCache.IndexOf(APathKey);
  Result := i >= 0;
  if Result then
  begin
    WasFound := FCache.Objects[i] is TDrawableCacheItem;
    if WasFound then
      Drawable := TDrawableCacheItem(FCache.Objects[i]).fname;
  end;
end;

function TAndroidTheme.FindPath(const Path: array of string): TDOMNode;

  function FindNodeUsingParent(root: TDOMElement; const tag, attr, val: string): TDOMNode;
  begin
    Result := FindNodeAttrib(root, tag, attr, val);
    if (Result = nil) and (root.AttribStrings['parent'] <> '') then
    begin
      root := FOwner.Resolve('@android:' + root.TagName + '/' + root.AttribStrings['parent']) as TDOMElement;
      if root <> nil then
        Result := FindNodeUsingParent(root, tag, attr, val);
    end;
    Result := TryResolve(Result);
  end;

var
  n: TDOMNode;
  i: Integer;
begin
  Result := nil;
  if not Loaded then Exit;
  n := TryResolve(Find('item', 'name', Path[0]));
  if n = nil then Exit;
  for i := 1 to High(Path) do
  begin
    n := FindNodeUsingParent(TDOMElement(n), 'item', 'name', Path[i]);
    if n = nil then Exit;
  end;
  Result := n;
end;

procedure TAndroidTheme.AddColorToCache(const APath: array of string;
  WasFound: Boolean; attribs: string; ARed, AGreen, ABlue, AAlpha: Byte);
var
  i: Integer;
  key: string;
  it: TColorCacheItem;
begin
  key := PathToKey(APath, attribs);
  i := FCache.IndexOf(key);
  if i >= 0 then Exit;
  i := FCache.Add(key);
  if WasFound then
  begin
    it := TColorCacheItem.Create;
    it.Red := ARed;
    it.Green := AGreen;
    it.Blue := ABlue;
    it.Alpha := AAlpha;
    FCache.Objects[i] := it;
  end;
end;

procedure TAndroidTheme.AddDrawableToCache(const APathKey: string;
  WasFound: Boolean; Drawable: string);
var
  i: Integer;
  it: TDrawableCacheItem;
begin
  i := FCache.IndexOf(APathKey);
  if i >= 0 then Exit;
  i := FCache.Add(APathKey);
  if WasFound then
  begin
    it := TDrawableCacheItem.Create;
    it.fname := Drawable;
    FCache.Objects[i] := it;
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

function TAndroidTheme.TryResolve(n: TDOMNode): TDOMNode;
var
  s: string;
begin
  Result := n;
  if n is TDOMElement then
  begin
    s := TDOMElement(n).TextContent;
    if (s <> '') and (s[1] = '@') then
    begin
      n := FOwner.Resolve(s);
    end else
    if Copy(s, 1, 14) = '?android:attr/' then
    begin
      Delete(s, 1, Pos('/', s));
      n := Find('item', 'name', s);
    end;
    if (n <> nil) and (n <> Result) then
      Result := TryResolve(n);
  end;
end;

function TAndroidTheme.Selector(AParent: TDOMNode; const attribs, aname: string): string;
var
  attrT, attrF: TStringList;
  n1: TDOMNode;
  lc: TDOMElement;
  v: string;
  i: Integer;
  match: Boolean;
begin
  Result := '';
  lc := nil;
  attrT := TStringList.Create;
  attrF := TStringList.Create;
  try
    attrT.Delimiter := ';';
    attrT.DelimitedText := attribs;
    for i := attrT.Count - 1 downto 0 do
    begin
      v := attrT.ValueFromIndex[i];
      if (v <> '') and (v[1] = '!') then
      begin
        Delete(v, 1, 1);
        attrF.Values[attrT.Names[i]] := v;
        attrT.Delete(i);
      end;
    end;
    n1 := AParent.FirstChild;
    while n1 <> nil do
    begin
      if n1 is TDOMElement and TDOMElement(n1).hasAttribute(aname) then
        with TDOMElement(n1) do
        begin
          lc := TDOMElement(n1);
          match := True;
          for i := 0 to attrT.Count - 1 do
          begin
            if AttribStrings[attrT.Names[i]] <> attrT.ValueFromIndex[i] then
            begin
              match := False;
              Break;
            end;
          end;
          if match then
            for i := 0 to attrF.Count - 1 do
            begin
              if AttribStrings[attrF.Names[i]] = attrF.ValueFromIndex[i] then
              begin
                match := False;
                Break;
              end;
            end;
          if match then Break;
        end;
      n1 := n1.NextSibling;
    end;
    if n1 <> nil then
      Result := TDOMElement(n1).AttribStrings[aname]
    else
    if lc <> nil then
      Result := lc.AttribStrings[aname];
  finally
    attrT.Free;
    attrF.Free;
  end;
end;

constructor TAndroidTheme.Create(const AName: string);
begin
  FName := AName;
  FCache := TStringList.Create;
  FCache.Sorted := True;
  FCache.OwnsObjects := True;
  FCache.CaseSensitive := True;
end;

destructor TAndroidTheme.Destroy;
begin
  FCache.Free;
  inherited Destroy;
end;

procedure TAndroidTheme.ClearCache;
begin
  FCache.Clear;
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

function TAndroidTheme.TryGetColor(const colorName: string; attribs: string;
  out Red, Green, Blue, Alpha: Byte): Boolean;
var
  i: Integer;
  t: TAndroidTheme;
  s: string;
  n: TDOMNode;
begin
  if FindColorInCache([colorName], attribs, Result, Red, Green, Blue, Alpha) then Exit;
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
          if n.NodeName = 'selector' then
            s := Selector(n, attribs, 'android:color')
          else
            s := n.TextContent;
        end;
      else
        n := FindNodeAttrib(FContent, 'item', 'name', s);
        if n = nil then Break;
        s := n.TextContent;
      end;
    if FParent <> nil then
      Result := FParent.TryGetColor(colorName, attribs, Red, Green, Blue, Alpha);
    if not Result then
    begin
      i := RPos('.', Name);
      if i > 0 then
      begin
        t := FOwner.FindTheme(Copy(Name, 1, i - 1));
        if t <> nil then
          Result := t.TryGetColor(colorName, attribs, Red, Green, Blue, Alpha);
      end;
    end;
  finally
    AddColorToCache([colorName], Result, attribs, Red, Green, Blue, Alpha);
  end;
end;

function TAndroidTheme.TryGetColor(const Path: array of string; attribs: string;
  out Red, Green, Blue, Alpha: Byte): Boolean;
var
  s: string;
  n: TDOMNode;
begin
  if FindColorInCache(Path, attribs, Result, Red, Green, Blue, Alpha) then Exit;
  Result := False;
  if not Loaded then Exit;
  try
    n := FindPath(Path);
    if (n <> nil) and (n.NodeName = 'selector') then
      s := Selector(n, attribs, 'android:color')
    else
    if n is TDOMElement then
      s := TDOMElement(n).TextContent
    else
      Exit;
    if s = '' then Exit;
    Result := TryGetColor(s, attribs, Red, Green, Blue, Alpha);
  finally
    AddColorToCache(Path, Result, attribs, Red, Green, Blue, Alpha);
  end;
end;

function TAndroidTheme.TryGetColor(const Path: array of string;
  attribs: string; out Color: TColor): Boolean;
var
  r, g, b, a: Byte;
begin
  Result := TryGetColor(Path, attribs, r, g, b, a);
  if Result then
    Color := RGBToColor(r, g, b);
end;

function TAndroidTheme.GetColorDef(const colorName: string;
  DefValue: TColor): TColor;
var
  r, g, b, a: Byte;
begin
  if not TryGetColor(colorName, 'android:state_enabled=!false', r, g, b, a) then
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

function TAndroidTheme.FindDrawable(const Path: array of string;
  const attribs: string): string;
var
  n: TDOMNode;
  s: string;
  found: Boolean;
begin
  Result := '';
  if FindDrawableInCache(PathToKey(Path, attribs), found, Result) then Exit;
  try
    if not Loaded then Exit;

    n := TryResolve(FindPath(Path));
    if n = nil then Exit;

    if (n.NodeName = 'selector') then
      s := Selector(n, attribs, 'android:drawable')
    else
    if n is TDOMElement then
      s := TDOMElement(n).TextContent
    else
      Exit;

    if Copy(s, 1, 10) = '@drawable/' then
    begin
      Delete(s, 1, 10);
      s := ExpandFileName(FOwner.FBasePath + '../drawable-mdpi/' + s);
      if FileExists(s + '.9.png') then
        Result := s + '.9.png'
      else
      if FileExists(s + '.png') then
        Result := s + '.png';
    end;
  finally
    AddDrawableToCache(PathToKey(Path, attribs), Result <> '', Result);
  end;
end;

initialization
  Themes := TAndroidThemes.Create;

finalization
  Themes.Free;

end.

