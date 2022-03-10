// SPDX-License-Identifier: LGPL-3.0-linking-exception
unit BGRAFreeType;

{$mode objfpc}{$H+}

{
  Font rendering units : BGRAText, BGRATextFX, BGRAVectorize, BGRAFreeType

  This units provide a font renderer with FreeType fonts, using the integrated FreeType font engine in Lazarus.
  The simplest way to render effects is to use TBGRAFreeTypeFontRenderer class.
  To do this, create an instance of this class and assign it to a TBGRABitmap.FontRenderer property. Now functions
  to draw text like TBGRABitmap.TextOut will use the chosen renderer.

  >> Note that you need to define the default FreeType font collection
  >> using EasyLazFreeType unit.

  To set the effects, keep a variable containing
  the TBGRAFreeTypeFontRenderer class and modify ShadowVisible and other effects parameters. The FontHinted property
  allows you to choose if the font is snapped to pixels to make it more readable.

  TBGRAFreeTypeDrawer class is the class that provides basic FreeType drawing
  by deriving the TFreeTypeDrawer type. You can use it directly, but it is not
  recommended, because there are less text layout parameters. However, it is
  necessary if you want to create TBGRATextEffect objects using FreeType fonts.
}

interface

{$IF not Defined (ANDROID)} // Workaround fix for Android compilation

{$i bgrabitmap.inc}

uses
  BGRAClasses, SysUtils, BGRAGraphics, BGRABitmapTypes, EasyLazFreeType, FPimage,
  BGRACustomTextFX, BGRAPhongTypes, BGRATypewriter, LazVersion;

{$IF laz_fullversion >= 2001000}
  {$DEFINE LAZFREETYPE_GLYPH_BOX_FIXED}
{$ENDIF}

{$IF laz_fullversion >= 2010000}
  {$DEFINE LAZFREETYPE_PROVIDE_KERNING}
{$ENDIF}

type
  TBGRAFreeTypeDrawer = class;

  //this is the class to assign to FontRenderer property of TBGRABitmap
  { TBGRAFreeTypeFontRenderer }

  TBGRAFreeTypeFontRenderer = class(TBGRACustomFontRenderer)
  private
    FDrawer: TBGRAFreeTypeDrawer;
    FFont: TFreeTypeFont;
    FLastFontSize: single;
    function GetCollection: TCustomFreeTypeFontCollection;
    function GetDrawer(ASurface: TBGRACustomBitmap): TBGRAFreeTypeDrawer;
    function GetShaderLightPosition: TPoint;
    function GetShaderLightPositionF: TPointF;
    procedure SetShaderLightPosition(const AValue: TPoint);
    procedure SetShaderLightPositionF(const AValue: TPointF);
  protected
    FShaderOwner: boolean;
    FShader: TCustomPhongShading;
    FTypeWriter: TBGRACustomTypeWriter;
    function GetTypeWriter: TBGRACustomTypeWriter;
    procedure UpdateFont(ADisableClearType: boolean = false);
    procedure Init;
    procedure TextOutAnglePatch(ADest: TBGRACustomBitmap; x, y: single; orientation: integer; s: string;
              c: TBGRAPixel; tex: IBGRAScanner; align: TAlignment);
    procedure InternalTextOut(ADest: TBGRACustomBitmap; x, y: single; s: string; c: TBGRAPixel; align: TAlignment);
    property TypeWriter: TBGRACustomTypeWriter read GetTypeWriter;
  public
    FontHinted: boolean;

    ShaderActive: boolean;

    ShadowVisible: boolean;
    ShadowColor: TBGRAPixel;
    ShadowRadius: integer;
    ShadowOffset: TPoint;
    ShadowQuality: TRadialBlurType;

    OutlineColor: TBGRAPixel;
    OutlineVisible,OuterOutlineOnly: boolean;
    OutlineTexture: IBGRAScanner;

    constructor Create; overload;
    constructor Create(AShader: TCustomPhongShading; AShaderOwner: boolean); overload;
    function FontExists(AName: string): boolean; override;
    function GetFontPixelMetric: TFontPixelMetric; override;
    function GetFontPixelMetricF: TFontPixelMetricF; override;
    procedure TextOutAngle(ADest: TBGRACustomBitmap; x, y: single; orientation: integer; s: string; c: TBGRAPixel; align: TAlignment); overload; override;
    procedure TextOutAngle(ADest: TBGRACustomBitmap; x, y: single; orientation: integer; s: string; texture: IBGRAScanner; align: TAlignment); overload; override;
    procedure TextOut(ADest: TBGRACustomBitmap; x, y: single; s: string; texture: IBGRAScanner; align: TAlignment); overload; override;
    procedure TextOut(ADest: TBGRACustomBitmap; x, y: single; s: string; c: TBGRAPixel; align: TAlignment); overload; override;
    procedure TextRect(ADest: TBGRACustomBitmap; ARect: TRect; x, y: integer; s: string; style: TTextStyle; c: TBGRAPixel); overload; override;
    procedure TextRect(ADest: TBGRACustomBitmap; ARect: TRect; x, y: integer; s: string; style: TTextStyle; texture: IBGRAScanner); overload; override;
    function TextSize(sUTF8: string): TSize; overload; override;
    function TextSizeF(sUTF8: string): TPointF; overload; override;
    function TextSize(sUTF8: string; AMaxWidth: integer; {%H-}ARightToLeft: boolean): TSize; overload; override;
    function TextSizeF(sUTF8: string; AMaxWidthF: single; {%H-}ARightToLeft: boolean): TPointF; overload; override;
    function TextFitInfo(sUTF8: string; AMaxWidth: integer): integer; override;
    function TextFitInfoF(sUTF8: string; AMaxWidthF: single): integer; override;
    destructor Destroy; override;
    property Collection: TCustomFreeTypeFontCollection read GetCollection;
    property ShaderLightPosition: TPoint read GetShaderLightPosition write SetShaderLightPosition;
    property ShaderLightPositionF: TPointF read GetShaderLightPositionF write SetShaderLightPositionF;
  end;

  { TBGRAFreeTypeDrawer }

  TBGRAFreeTypeDrawer = class(TFreeTypeDrawer)
  private
    FMask: TBGRACustomBitmap;
    FColor: TBGRAPixel;
    FInCreateTextEffect: boolean;
    procedure RenderDirectly(x, y, tx: integer; data: pointer);
    procedure RenderDirectlyClearType(x, y, tx: integer; data: pointer);
    function ShadowActuallyVisible :boolean;
    function OutlineActuallyVisible: boolean;
    function ShaderActuallyActive : boolean;
  public
    Destination: TBGRACustomBitmap;
    ClearTypeRGBOrder: boolean;
    Texture: IBGRAScanner;

    Shader: TCustomPhongShading;
    ShaderActive: boolean;

    ShadowVisible: boolean;
    ShadowColor: TBGRAPixel;
    ShadowRadius: integer;
    ShadowOffset: TPoint;
    ShadowQuality: TRadialBlurType;

    OutlineColor: TBGRAPixel;
    OutlineVisible,OuterOutlineOnly: boolean;
    OutlineTexture: IBGRAScanner;

    constructor Create(ADestination: TBGRACustomBitmap);
    procedure DrawText(AText: string; AFont: TFreeTypeRenderableFont; x,y: single; AColor: TFPColor); overload; override;
    procedure DrawText(AText: string; AFont: TFreeTypeRenderableFont; x,y: single; AColor: TBGRAPixel); overload;
    procedure DrawText(AText: string; AFont: TFreeTypeRenderableFont; x,y: single; AColor: TBGRAPixel; AAlign: TFreeTypeAlignments); overload;
    { If this code does not compile, you probably have an older version of Lazarus. To fix the problem,
      go into "bgrabitmap.inc" and comment the compiler directives }
    {$IFDEF BGRABITMAP_USE_LCL12}
    procedure DrawTextWordBreak(AText: string; AFont: TFreeTypeRenderableFont; x, y, AMaxWidth: Single; AColor: TBGRAPixel; AAlign: TFreeTypeAlignments); overload;
    procedure DrawTextRect(AText: string; AFont: TFreeTypeRenderableFont; X1,Y1,X2,Y2: Single; AColor: TBGRAPixel; AAlign: TFreeTypeAlignments); overload;
    {$ENDIF}
    {$IFDEF BGRABITMAP_USE_LCL15}
    procedure DrawGlyph(AGlyph: integer; AFont: TFreeTypeRenderableFont; x,y: single; AColor: TFPColor); overload; override;
    procedure DrawGlyph(AGlyph: integer; AFont: TFreeTypeRenderableFont; x,y: single; AColor: TBGRAPixel); overload;
    procedure DrawGlyph(AGlyph: integer; AFont: TFreeTypeRenderableFont; x,y: single; AColor: TBGRAPixel; AAlign: TFreeTypeAlignments); overload;
    {$ENDIF}
    function CreateTextEffect(AText: string; AFont: TFreeTypeRenderableFont): TBGRACustomTextEffect;
    destructor Destroy; override;
  end;

  {$ENDIF} // Workaround fix for Android compilation

implementation

{$IF not Defined (ANDROID)} // Workaround fix for Android compilation

uses BGRABlend, Math, BGRATransform, BGRAUnicode, BGRAUTF8;

{$i generatedutf8.inc}

procedure RecomposeUTF8(AFont: TFreeTypeFont; ADecomposed: string; out ARecomposed: string; out AMarks, AInnerMarks: string);
var
  joinBefore, joinAfter: boolean;
  lookFor: string;

  function FindChars(AText: string): boolean;
  var
    p, charLen: Integer;
    u: LongWord;
  begin
    if AFont = nil then exit(true);

    p := 1;
    while p <= length(AText) do
    begin
      charLen := UTF8CharacterLength(@AText[p]);
      u := UTF8CodepointToUnicode(@AText[p], charLen);
      if AFont.CharIndex[u] = 0 then exit(false);
      inc(p, charLen);
    end;
    result := true;
  end;

  function RecomposeRec(AMin,AMax: integer): boolean;

    procedure TryExactMatch;
    var
      i, extra: Integer;
      newExtra: String;
    begin
      for i := AMin to AMax do
        if UTF8Decomposition[i].de = ARecomposed then
        begin
          if UTF8Decomposition[i].join <> arNone then
            if (joinBefore xor (UTF8Decomposition[i].join in[arMedial,arFinal])) or
               (joinAfter xor (UTF8Decomposition[i].join in[arInitial,arMedial])) then continue;
          if not FindChars(UTF8Decomposition[i].re) then continue;
          ARecomposed := UTF8Decomposition[i].re;
          result := true;
          exit;
        end;
      for i := AMin to AMax do
        if ARecomposed.StartsWith(UTF8Decomposition[i].de, true) then
        begin
          extra := length(ARecomposed) - length(UTF8Decomposition[i].de);
          if UTF8Decomposition[i].join <> arNone then
            if (joinBefore xor (UTF8Decomposition[i].join in[arMedial,arFinal])) or
               (joinAfter xor (UTF8Decomposition[i].join in[arInitial,arMedial])) then continue;
          if not FindChars(UTF8Decomposition[i].re) then continue;
          newExtra := copy(ARecomposed, length(ARecomposed)+1-extra, extra);
          if GetFirstStrongBidiClassUTF8(newExtra) <> ubcUnknown then continue;
          AMarks := newExtra + AMarks;
          ARecomposed := UTF8Decomposition[i].re;
          result := true;
          exit;
        end;
      result := false;
    end;

  var i,j: integer;
  begin
    if AMax <= AMin+9 then
    begin
      TryExactMatch;
    end else
    begin
      i := (AMin+AMax) div 2;
      if UTF8Decomposition[i].de.StartsWith(lookFor, true) then
      begin
        j := i;
        while (j > AMin) and UTF8Decomposition[j-1].de.StartsWith(lookFor, true) do dec(j);
        AMin := j;
        j := i;
        while (j < AMax) and UTF8Decomposition[j+1].de.StartsWith(lookFor, true) do inc(j);
        AMax := j;
        TryExactMatch;
      end else
      if CompareStr(lookFor, UTF8Decomposition[i].de) > 0 then
        result := RecomposeRec(i+1, AMax)
      else
        result := RecomposeRec(AMin, i-1);
    end;
  end;

  procedure ExtractInnerMarks;
  var
    p, charLen, pStart: Integer;
    u: LongWord;
  begin
    if ARecomposed.StartsWith(UTF8_ARABIC_LAM, true) then
    begin
      pStart := length(UTF8_ARABIC_LAM)+1;
      p := pStart;
      while p <= length(ARecomposed) do
      begin
        charLen := UTF8CharacterLength(@ARecomposed[p]);
        u := UTF8CodepointToUnicode(@ARecomposed[p], charLen);
        if GetUnicodeBidiClass(u) = ubcNonSpacingMark then
          inc(p, charLen)
          else break;
      end;
      if p>pStart then
      begin
        AppendStr(AInnerMarks, copy(ARecomposed, pStart, p-pStart));
        delete(ARecomposed, pStart, p-pStart);
      end;
    end;
  end;

  procedure ExtractFinalMarks;
  var
    p,pStart,pPrev: Integer;
  begin
    pStart := length(ARecomposed)+1;
    p := pStart;
    while p > 1 do
    begin
      pPrev := p;
      dec(p);
      while (p > 1) and (ARecomposed[p] in[#$80..#$BF]) do dec(p);
      if (p = 1) or (ARecomposed[p] in [#$80..#$BF]) or
        not (GetUnicodeBidiClassEx(UTF8CodepointToUnicode(@ARecomposed[p], pPrev-p))
            in [ubcNonSpacingMark, ubcCombiningLeftToRight]) then
      begin
        p := pPrev;
        break;
      end;
    end;
    if p < pStart then
    begin
      AMarks := copy(ARecomposed, p, pStart-p) + AMarks;
      delete(ARecomposed, p, pStart-p);
    end;
  end;

begin
  joinBefore := ADecomposed.StartsWith(UTF8_ZERO_WIDTH_JOINER, true);
  joinAfter := ADecomposed.EndsWith(UTF8_ZERO_WIDTH_JOINER, true);
  if joinBefore and joinAfter then
    ADecomposed := copy(ADecomposed, length(UTF8_ZERO_WIDTH_JOINER)+1,
                   length(ADecomposed) - (length(UTF8_ZERO_WIDTH_JOINER) shl 1)) else
  if joinBefore then Delete(ADecomposed, 1, length(UTF8_ZERO_WIDTH_JOINER)) else
  if joinAfter then Delete(ADecomposed, length(ADecomposed) - length(UTF8_ZERO_WIDTH_JOINER) + 1, length(UTF8_ZERO_WIDTH_JOINER));

  ARecomposed := ADecomposed;
  AMarks := '';
  AInnerMarks := '';
  ExtractInnerMarks;
  repeat
    if length(ADecomposed)<=1 then break;
    lookFor := copy(ARecomposed, 1, UTF8CharacterLength(@ARecomposed[1]));
  until not RecomposeRec(0, high(UTF8Decomposition));
  ExtractFinalMarks;
end;

type
  TMarkGlyph = record
    FreeTypeGlyph: TFreeTypeGlyph;
    Index: integer;
    Bounds: TRect;
    CombiningClass: Byte;
  end;

  { TBGRAFreeTypeGlyph }

  TBGRAFreeTypeGlyph = class(TBGRAGlyph)
  protected
    FFont: TFreeTypeFont;
    FCentralText: string;
    FCentralTextWidth: Single;
    FMarks, FInnerMarks: TUnicodeArray;
    FBounds: TRect;
    function RetrieveMarkGlyph(AMark: LongWord; out AMarkGlyph: TMarkGlyph; AAllowTranslate: boolean): boolean;
    procedure DrawNonSpacingMarks(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; RTL: boolean; AColor: TBGRAPixel);
    procedure DrawCentralGlyph(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; AColor: TBGRAPixel);
    procedure DrawCombiningMarks(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; AColor: TBGRAPixel; out ACentralLeft: single);
  public
    constructor Create(AFont: TFreeTypeFont; AIdentifier: string);
    constructor Create({%H-}AIdentifier: string); override;
    procedure Draw(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; RTL: boolean; AColor: TBGRAPixel);
  end;

  { TFreeTypeTypeWriter }

  TFreeTypeTypeWriter = class(TBGRACustomTypeWriter)
  protected
    FFont: TFreeTypeFont;
    function GetGlyph(AIdentifier: string): TBGRAGlyph; override;
    function GetKerningOffset(AIdBefore, AIdAfter: string; ARightToLeft: boolean): single; override;
    function ComputeKerning({%H-}AIdLeft, {%H-}AIdRight: string): single; override;
  public
    constructor Create(AFont: TFreeTypeFont);
    procedure DrawText(ADrawer: TBGRAFreeTypeDrawer; ATextUTF8: string; X,Y: Single;
              AColor: TBGRAPixel; AAlign: TBGRATypeWriterAlignment = twaTopLeft); overload;
  end;

{ TFreeTypeGlyph }

constructor TBGRAFreeTypeGlyph.Create(AFont: TFreeTypeFont; AIdentifier: string);

  procedure SortMarks(A: TUnicodeArray);
    procedure MoveBefore(AFrom, ATo: integer);
    var k: integer;
      backU: LongWord;
    begin
      if ATo >= AFrom then exit;
      backU := A[AFrom];
      for k := AFrom downto ATo+1 do
        A[k] := A[k-1];
      A[ATo] := backU;
    end;

    procedure SortByCombiningClass;
    var
      start, i, j: Integer;
      newCC: Byte;
    begin
      start := 0;
      i := start+1;
      while i <= high(a) do
      begin
        //sequence is split
        if A[i] = UNICODE_COMBINING_GRAPHEME_JOINER then
        begin
          start := i+1;
          i := start+1;
          continue;
        end else
        begin
          newCC := GetUnicodeCombiningClass(A[i]);
          j := i;
          while (j > start) and (newCC < GetUnicodeCombiningClass(A[j-1])) do dec(j);
          MoveBefore(i, j);
          inc(i);
        end;
      end;
    end;

    procedure PutShaddaFirst;
    var
      i, j: Integer;
    begin
      j := 0;
      for i := 0 to high(A) do
        if A[i] = UNICODE_COMBINING_GRAPHEME_JOINER then
          j := i+1 else
        if GetUnicodeCombiningClass(A[i]) = 33 then
        begin
          MoveBefore(i, j);
          inc(j);
        end;
    end;

    procedure PutLeadingMCMFirst(ACombiningClass: byte);
    var
      i, j: Integer;
    begin
      j := 0;
      i := 0;
      while i <= high(A) do
      begin
        if A[i] = UNICODE_COMBINING_GRAPHEME_JOINER then
        begin
          j := i+1;
          inc(i);
        end else
        if GetUnicodeCombiningClass(A[i]) = ACombiningClass then
        begin
          //put leading MCM first
          while IsModifierCombiningMark(A[i]) do
          begin
            MoveBefore(i, j);
            inc(j);
            inc(i);
            if (i >= length(A)) or
              not (GetUnicodeCombiningClass(A[i]) = ACombiningClass) then
                break;
          end;
          //skip rest of combining class
          while (i <= high(A)) and (GetUnicodeCombiningClass(A[i]) = ACombiningClass) do
            inc(i);
        end else
          inc(i);
      end;
    end;

  begin
    if A = nil then exit;
    SortByCombiningClass;
    PutShaddaFirst;
    PutLeadingMCMFirst(230);
    PutLeadingMCMFirst(220);
  end;

  //some marks are combined both from left and right, so they need to be split
  procedure SplitMarks;
    procedure SplitMark(AFrom: LongWord; ATo1, ATo2: LongWord);
    var
      i, j: Integer;
    begin
      for i := high(FMarks) downto 0 do
        if FMarks[i] = AFrom then
        begin
          FMarks[i] := ATo1;
          setlength(FMarks, length(FMarks)+1);
          for j := high(FMarks) downto i+2 do
            FMarks[j] := FMarks[j-1];
          FMarks[i+1] := ATo2;
        end;
    end;

  begin
    {BENGALI}
    SplitMark($09CB, $09C7, $09BE);
    SplitMark($09CC, $09C7, $09D7);
    {TAMIL}
    SplitMark($0BCA, $0BC6, $0BBE);
    SplitMark($0BCB, $0BC7, $0BBE);
    SplitMark($0BCC, $0BC6, $0BD7);
    {MALAYALAM}
    SplitMark($0D4A, $0D46, $0D3E);
    SplitMark($0D4B, $0D47, $0D3E);
    SplitMark($0D4C, $0D46, $0D57);
    {BALINESE}
    SplitMark($1B3D, $1B3C, $1B35);
    SplitMark($1B40, $1B3E, $1B35);
    SplitMark($1B41, $1B3F, $1B35);
  end;

var
  marksStr, innerMarksStr: string;
  ofs: TIntegerArray;
  u: LongWord;
  glyphIndex: LongInt;
  ftGlyph: TFreeTypeGlyph;
  i: Integer;
begin
  inherited Create(AIdentifier);
  FFont := AFont;
  RecomposeUTF8(FFont, AIdentifier, FCentralText, marksStr, innerMarksStr);
  UTF8ToUnicodeArray(marksStr, FMarks, ofs);
  SortMarks(FMarks);
  UTF8ToUnicodeArray(innerMarksStr, FInnerMarks, ofs);
  SortMarks(FInnerMarks);
  SplitMarks;
  FCentralTextWidth := AFont.TextWidth(FCentralText);
  Width := FCentralTextWidth;
  for i := 0 to high(FMarks) do
  if GetUnicodeBidiClassEx(FMarks[i]) = ubcCombiningLeftToRight then
  begin
    glyphIndex := AFont.CharIndex[FMarks[i]];
    if glyphIndex <> 0 then
    begin
      if AFont.ClearType then
        Width += AFont.Glyph[glyphIndex].Advance/3
        else Width += AFont.Glyph[glyphIndex].Advance;
    end;
  end;
  Height := AFont.LineFullHeight;
  FBounds := EmptyRect;
  if length(FCentralText) <> 0 then
  begin
    u := UTF8CodepointToUnicode(@FCentralText[1], UTF8CharacterLength(@FCentralText[1]));
    glyphIndex := AFont.CharIndex[u];
    if glyphIndex <> 0 then
    begin
      ftGlyph := AFont.Glyph[glyphIndex];
      FBounds := ftGlyph.Bounds;
    end;
  end;
end;

constructor TBGRAFreeTypeGlyph.Create(AIdentifier: string);
begin
  raise exception.Create('Requires a font');
end;

function TBGRAFreeTypeGlyph.RetrieveMarkGlyph(AMark: LongWord; out AMarkGlyph: TMarkGlyph; AAllowTranslate: boolean): boolean;
  const
    ArabicMarkAbove: array[0..10] of LongWord =
      ($0618, $0619, $064B, $064C, $064E, $064F,
       $0651, $0652, $0670, $08F0, $08F1);

    ArabicMarkBelow: array[0..3] of LongWord =
      ($061A, $064D, $0650, $08F2);

  type
    TMarkFallback = record
      NonSpacing: LongWord;
      Spacing: LongWord;
      Moved: boolean;
    end;

  const
    MarkFallback: array[0..40] of TMarkFallback = (
    (NonSpacing: $300; Spacing: $2CA; Moved: false),
    (NonSpacing: $301; Spacing: $B4; Moved: false),
    (NonSpacing: $302; Spacing: $5E; Moved: false),
    (NonSpacing: $303; Spacing: $2DC; Moved: false),
    (NonSpacing: $304; Spacing: $AF; Moved: false),
    (NonSpacing: $305; Spacing: $203E; Moved: false),
    (NonSpacing: $306; Spacing: $2D8; Moved: false),
    (NonSpacing: $307; Spacing: $2D9; Moved: false),
    (NonSpacing: $308; Spacing: $A8; Moved: false),
    (NonSpacing: $30A; Spacing: $2DA; Moved: false),
    (NonSpacing: $30B; Spacing: $2DD; Moved: false),
    (NonSpacing: $30E; Spacing: $22; Moved: false),
    (NonSpacing: $313; Spacing: $1FBD; Moved: false),
    (NonSpacing: $314; Spacing: $1FFE; Moved: false),
    (NonSpacing: $316; Spacing: $2CA; Moved: true),
    (NonSpacing: $317; Spacing: $B4; Moved: true),
    (NonSpacing: $320; Spacing: $AF; Moved: true),
    (NonSpacing: $324; Spacing: $A8; Moved: true),
    (NonSpacing: $325; Spacing: $2DA; Moved: true),
    (NonSpacing: $327; Spacing: $B8; Moved: false),
    (NonSpacing: $328; Spacing: $2DB; Moved: false),
    (NonSpacing: $32D; Spacing: $5E; Moved: true),
    (NonSpacing: $32E; Spacing: $2D8; Moved: true),
    (NonSpacing: $330; Spacing: $2DC; Moved: true),
    (NonSpacing: $331; Spacing: $AF; Moved: true),
    (NonSpacing: $332; Spacing: $203E; Moved: true),
    (NonSpacing: $333; Spacing: $2017; Moved: false),
    (NonSpacing: $336; Spacing: $2013; Moved: false),
    (NonSpacing: $337; Spacing: $2F; Moved: false),
    (NonSpacing: $338; Spacing: $2F; Moved: false),
    (NonSpacing: $33F; Spacing: $2017; Moved: true),
    (NonSpacing: $340; Spacing: $2CA; Moved: false),
    (NonSpacing: $341; Spacing: $B4; Moved: false),
    (NonSpacing: $342; Spacing: $1FC0; Moved: false),
    (NonSpacing: $343; Spacing: $1FBD; Moved: false),
    (NonSpacing: $345; Spacing: $37A; Moved: false),
    (NonSpacing: $348; Spacing: $22; Moved: true),
    (NonSpacing: $35E; Spacing: $203E; Moved: false),
    (NonSpacing: $35F; Spacing: $5F; Moved: false),
    (NonSpacing: $3099; Spacing: $309B; Moved: false),
    (NonSpacing: $309A; Spacing: $309C; Moved: false));

  function IsArabicMarkAbove(u: LongWord): boolean;
  var
    i: Integer;
  begin
    for i := 0 to high(ArabicMarkAbove) do
      if ArabicMarkAbove[i] = u then exit(true);
    result := false;
  end;

  function IsArabicMarkBelow(u: LongWord): boolean;
  var
    i: Integer;
  begin
    for i := 0 to high(ArabicMarkBelow) do
      if ArabicMarkBelow[i] = u then exit(true);
    result := false;
  end;

var k: integer;
begin
  AMarkGlyph.Index := FFont.CharIndex[AMark];
  if AMarkGlyph.Index = 0 then
  begin
    for k := 0 to high(MarkFallback) do
      if (MarkFallback[k].NonSpacing = AMark) and
         (not MarkFallback[k].Moved or AAllowTranslate) then
      begin
        AMarkGlyph.Index := FFont.CharIndex[MarkFallback[k].Spacing];
        if AMarkGlyph.Index = 0 then
        begin
          if MarkFallback[k].Spacing = $1FBD then AMarkGlyph.Index:= FFont.CharIndex[$27] else
          if MarkFallback[k].Spacing = $1FC0 then AMarkGlyph.Index:= FFont.CharIndex[$2DC] else
          if MarkFallback[k].Spacing = $2CA then AMarkGlyph.Index:= FFont.CharIndex[$60];
        end;
        break;
      end;
  end;
  if AMarkGlyph.Index <> 0 then
  begin
    AMarkGlyph.FreeTypeGlyph := FFont.Glyph[AMarkGlyph.Index];
    AMarkGlyph.Bounds := AMarkGlyph.FreeTypeGlyph.Bounds;
    AMarkGlyph.CombiningClass := GetUnicodeCombiningClass(AMark);
    if AMarkGlyph.CombiningClass in[27..35] then
    begin
      if IsArabicMarkAbove(AMark) then AMarkGlyph.CombiningClass := 230 else
      if IsArabicMarkBelow(AMark) then AMarkGlyph.CombiningClass := 220;
    end;
    result := true;
  end
  else result := false;
end;

procedure TBGRAFreeTypeGlyph.DrawNonSpacingMarks(ADrawer: TBGRAFreeTypeDrawer;
  ALeft, ATop: single; RTL: boolean; AColor: TBGRAPixel);
var
  markGlyph: TMarkGlyph;
  aboveOfs, belowOfs, xRef, xRefBelow, xAfter: Single;
  justBelow, justAbove: boolean;

  procedure DoJustAbove(const ALetterBounds: TRect);
  begin
    if justAbove then
    begin
      {$IFDEF LAZFREETYPE_GLYPH_BOX_FIXED}
        DecF(aboveOfs, ALetterBounds.Top - markGlyph.Bounds.Bottom);
        incF(aboveOfs, FFont.SizeInPixels/12);
      {$ELSE}
        DecF(aboveOfs, ALetterBounds.Top + FFont.Ascent/3);
      {$ENDIF}
      justAbove := false;
    end;
  end;

  procedure DoJustBelow(const ALetterBounds: TRect);
  begin
    if justBelow then
    begin
      {$IFDEF LAZFREETYPE_GLYPH_BOX_FIXED}
        incF(belowOfs, ALetterBounds.Bottom - markGlyph.Bounds.Top);
        incF(belowOfs, FFont.SizeInPixels/12);
      {$ELSE}
        incF(belowOfs, ALetterBounds.Bottom);
      {$ENDIF}
      justBelow := false;
    end;
  end;

  function GetMarkOffsetY(AMark: LongWord): single;
  begin
    if (AMark = $304) or (AMark= $305)  or (AMark= $33F) or
       (AMark = $320) or (AMark = $331) or (AMark = $332) or (AMark = $333) then
    begin
      result := FFont.SizeInPixels/8;
    end else
    begin
      {$IFDEF LAZFREETYPE_GLYPH_BOX_FIXED}
        result := markGlyph.Bounds.Height + FFont.SizeInPixels/20
      {$ELSE}
        result := FFont.SizeInPixels/4;
      {$ENDIF}
    end;
  end;

  procedure DrawMark(AMark: LongWord; const ALetterBounds: TRect);
  var
    ofsX, ofsY: Single;
  begin
    if GetUnicodeBidiClassEx(AMark) <> ubcNonSpacingMark then exit;
    if RetrieveMarkGlyph(AMark, markGlyph, {$IFDEF LAZFREETYPE_GLYPH_BOX_FIXED}true{$ELSE}false{$ENDIF}) then
    begin
      if markGlyph.CombiningClass = 230 then
      begin
        DoJustAbove(ALetterBounds);
        ofsX := -(markGlyph.Bounds.Left + markGlyph.Bounds.Right)/2;
        ofsY := -aboveOfs;
        IncF(aboveOfs, GetMarkOffsetY(AMark));
        ADrawer.DrawGlyph(markGlyph.Index, FFont,
            xRef + ofsX, ATop + ofsY, BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
      end else
      if markGlyph.CombiningClass in[220,240] then
      begin
        if justBelow then incF(ofsX, xRefBelow - xRef);
        DoJustBelow(ALetterBounds);
        ofsX := -(markGlyph.Bounds.Left + markGlyph.Bounds.Right)/2;
        ofsY := belowOfs;
        IncF(belowOfs, GetMarkOffsetY(AMark));
        ADrawer.DrawGlyph(markGlyph.Index, FFont,
            xRefBelow + ofsX, ATop + ofsY, BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
      end else
      if markGlyph.CombiningClass = 1 then //overlay
      begin
        ofsX := -(markGlyph.Bounds.Left + markGlyph.Bounds.Right)/2;
        ADrawer.DrawGlyph(markGlyph.Index, FFont,
            xRef + ofsX, ATop, BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
      end else
        ADrawer.DrawGlyph(markGlyph.Index, FFont,
            xAfter, ATop, BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
    end;
  end;

var
  j: integer;
begin
  if RTL then xAfter := ALeft else xAfter := ALeft + FCentralTextWidth;

  if FMarks <> nil then
  begin
    justAbove := false;
    if (FCentralText = 'ﻁ') or (FCentralText = 'ﻂ') or (FCentralText = 'ﻃ') or (FCentralText = 'ﻄ') or
       (FCentralText = 'ﻅ') or (FCentralText = 'ﻆ') or (FCentralText = 'ﻇ') or (FCentralText = 'ﻈ') then
    begin
      aboveOfs := 0;
      xRef := ALeft + Width*3/4;
      xRefBelow := xRef;
    end else
    if (FCentralText = 'ﻝ') or (FCentralText = 'ﻞ') or (FCentralText = 'ﻚ') or (FCentralText = 'ﻙ') then
    begin
      aboveOfs := 0;
      xRef := ALeft + Width/2;
      xRefBelow := xRef;
    end else
    if (FCentralText = 'ﻵ') or (FCentralText = 'ﻶ') or (FCentralText = 'ﻷ') or (FCentralText = 'ﻸ') or
       (FCentralText = 'ﻹ') or (FCentralText = 'ﻺ') or (FCentralText = 'ﻻ') or (FCentralText = 'ﻼ') then
    begin
      justAbove := true;
      aboveOfs := - FFont.SizeInPixels/10;
      xRef := ALeft + Width/6;
      xRefBelow := ALeft + Width/4;
    end else
    begin
      justAbove := true;
      aboveOfs := 0;
      xRef := ALeft + Width/2;
      xRefBelow := xRef;
    end;
    if (FCentralText = 'ﻅ') or (FCentralText = 'ﻆ') or (FCentralText = 'ﻇ') or (FCentralText = 'ﻈ') or
     (FCentralText = 'ﻚ') or (FCentralText = 'ﻙ') then
    begin
      IncF(aboveOfs, FFont.SizeInPixels/12);
    end;
    if (FCentralText = 'ﺏ') or (FCentralText = 'ﺐ') or (FCentralText = 'ﭒ') or (FCentralText = 'ﭓ') or
       (FCentralText = 'ﭖ') or (FCentralText = 'ﭗ') or (FCentralText = 'ﭚ') or (FCentralText = 'ﭛ') or
       (FCentralText = 'ٮ') then
    begin
      DecF(aboveOfs, FFont.SizeInPixels/16);
    end;

    belowOfs := 0;
    justBelow := true;
    for j := 0 to high(FMarks) do
      DrawMark(FMarks[j], FBounds);
  end;
  if FInnerMarks <> nil then
  begin
    xRef := ALeft + Width*3/4;
    xRefBelow := xRef;
    aboveOfs := 0;
    justAbove := true;
    belowOfs := 0;
    justBelow := true;
    for j := 0 to high(FInnerMarks) do
      DrawMark(FInnerMarks[j], FBounds);
  end;
end;

procedure TBGRAFreeTypeGlyph.DrawCentralGlyph(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; AColor: TBGRAPixel);
begin
  ADrawer.DrawText(FCentralText, FFont, ALeft, ATop, BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
end;

procedure TBGRAFreeTypeGlyph.DrawCombiningMarks(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; AColor: TBGRAPixel; out ACentralLeft: single);
var
  xRight: Single;
  widthFactor: single;

  procedure DrawCombiningMark(AMark: LongWord);
  var
    markGlyph: TMarkGlyph;
  begin
    if GetUnicodeBidiClassEx(AMark) <> ubcCombiningLeftToRight then exit;
    if RetrieveMarkGlyph(AMark, markGlyph, false) then
    begin
      if markGlyph.CombiningClass in[208,224] then
      begin
        ADrawer.DrawGlyph(markGlyph.Index, FFont, ALeft, ATop,
                          BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
        IncF(ALeft, markGlyph.FreeTypeGlyph.Advance*widthFactor);
        IncF(xRight, markGlyph.FreeTypeGlyph.Advance*widthFactor);
      end else
      if markGlyph.CombiningClass in[210,226,9] then
      begin
        ADrawer.DrawGlyph(markGlyph.Index, FFont, xRight, ATop,
                          BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
        IncF(xRight, markGlyph.FreeTypeGlyph.Advance*widthFactor);
      end else
      begin
        ADrawer.DrawGlyph(markGlyph.Index, FFont, ALeft, ATop,
                          BGRAToFPColor(AColor), [ftaTop,ftaLeft]);
        IncF(ALeft, markGlyph.FreeTypeGlyph.Advance/2*widthFactor);
        IncF(xRight, markGlyph.FreeTypeGlyph.Advance*widthFactor);
      end;
    end;
  end;

var
  j: Integer;
begin
  if FFont.ClearType then
    widthFactor := 1/3
    else widthFactor:= 1;
  xRight := ALeft + FCentralTextWidth;
  for j := 0 to high(FMarks) do
    DrawCombiningMark(FMarks[j]);
  ACentralLeft:= ALeft;
end;

procedure TBGRAFreeTypeGlyph.Draw(ADrawer: TBGRAFreeTypeDrawer; ALeft, ATop: single; RTL: boolean; AColor: TBGRAPixel);
var
  xLeft: single;
begin
  DrawCombiningMarks(ADrawer, ALeft, ATop, AColor, xLeft);
  DrawCentralGlyph(ADrawer, xLeft, ATop, AColor);
  DrawNonSpacingMarks(ADrawer, xLeft, ATop, RTL, AColor);
end;

{ TFreeTypeTypeWriter }

function TFreeTypeTypeWriter.GetGlyph(AIdentifier: string): TBGRAGlyph;
var
  g: TBGRAFreeTypeGlyph;
begin
  Result:= inherited GetGlyph(AIdentifier);
  if result = nil then
  begin
    g := TBGRAFreeTypeGlyph.Create(FFont, AIdentifier);
    SetGlyph(AIdentifier, g);
    result := g;
  end;
end;

function TFreeTypeTypeWriter.GetKerningOffset(AIdBefore, AIdAfter: string;
  ARightToLeft: boolean): single;
var
  temp: String;
begin
  //don't store kerning as it is stored in TFreeTypeFont font object
  if ARightToLeft then
  begin
    temp := AIdBefore;
    AIdBefore := AIdAfter;
    AIdAfter := temp;
  end;
  result := ComputeKerning(AIdBefore, AIdAfter);
end;

function TFreeTypeTypeWriter.ComputeKerning(AIdLeft, AIdRight: string): single;
{$IFDEF LAZFREETYPE_PROVIDE_KERNING}
var
  uLeft, uRight: LongWord;
begin
  if (AIdLeft = '') or (AIdRight = '') then exit(0);
  uLeft := UTF8CodepointToUnicode(@AIdLeft[1], UTF8CharacterLength(@AIdLeft[1]));
  uRight := UTF8CodepointToUnicode(@AIdRight[1], UTF8CharacterLength(@AIdRight[1]));
  Result:= FFont.CharKerning[uLeft, uRight].Kerning.x;
end;
{$ELSE}
begin
  result := 0;
end;{$ENDIF}

constructor TFreeTypeTypeWriter.Create(AFont: TFreeTypeFont);
begin
  inherited Create;
  FFont := AFont;
  SubstituteBidiBracket:= true;
end;

procedure TFreeTypeTypeWriter.DrawText(ADrawer: TBGRAFreeTypeDrawer;
  ATextUTF8: string; X, Y: Single; AColor: TBGRAPixel; AAlign: TBGRATypeWriterAlignment);
var
  i : Integer;
  ptGlyph: TPointF;
  di: TBGRATextDisplayInfo;
begin
  di := GetDisplayInfo(ATextUTF8, x, y, AAlign);
  for i := 0 to high(di) do
  begin
    if di[i].Mirrored then
      ptGlyph := di[i].Matrix * PointF(di[i].Glyph.Width, 0)
      else ptGlyph := di[i].Matrix * PointF(0, 0);
    TBGRAFreeTypeGlyph(di[i].Glyph).Draw(ADrawer, ptGlyph.x, ptGlyph.y, di[i].RTL, AColor);
  end;
end;

{ TBGRAFreeTypeFontRenderer }

function TBGRAFreeTypeFontRenderer.GetCollection: TCustomFreeTypeFontCollection;
begin
  result := EasyLazFreeType.FontCollection;
end;

function TBGRAFreeTypeFontRenderer.GetDrawer(ASurface: TBGRACustomBitmap): TBGRAFreeTypeDrawer;
begin
  result := FDrawer;
  result.ShadowColor := ShadowColor;
  result.ShadowOffset := ShadowOffset;
  result.ShadowRadius := ShadowRadius;
  result.ShadowVisible := ShadowVisible;
  result.ShadowQuality := ShadowQuality;
  result.ClearTypeRGBOrder := FontQuality <> fqFineClearTypeBGR;
  result.Destination := ASurface;
  result.OutlineColor := OutlineColor;
  result.OutlineVisible := OutlineVisible;
  result.OuterOutlineOnly := OuterOutlineOnly;
  result.OutlineTexture := OutlineTexture;
  if ShaderActive then result.Shader := FShader
   else result.Shader := nil;
end;

function TBGRAFreeTypeFontRenderer.GetShaderLightPosition: TPoint;
begin
  if FShader = nil then
    result := point(0,0)
  else
    result := FShader.LightPosition;
end;

function TBGRAFreeTypeFontRenderer.GetShaderLightPositionF: TPointF;
begin
  if FShader = nil then
    result := pointF(0,0)
  else
    result := FShader.LightPositionF;
end;

procedure TBGRAFreeTypeFontRenderer.SetShaderLightPosition(const AValue: TPoint);
begin
  if FShader <> nil then
    FShader.LightPosition := AValue;
end;

procedure TBGRAFreeTypeFontRenderer.SetShaderLightPositionF(
  const AValue: TPointF);
begin
  if FShader <> nil then
    FShader.LightPositionF := AValue;
end;

function TBGRAFreeTypeFontRenderer.GetTypeWriter: TBGRACustomTypeWriter;
begin
  if FTypeWriter = nil then
    FTypeWriter := TFreeTypeTypeWriter.Create(FFont);
  result := FTypeWriter;
end;

procedure TBGRAFreeTypeFontRenderer.UpdateFont(ADisableClearType: boolean);
var fts: TFreeTypeStyles;
  filename: string;
  twChange, newClearType: boolean;
  newSize: Single;
begin
  twChange := false;
  fts := [];
  if fsBold in FontStyle then include(fts, ftsBold);
  if fsItalic in FontStyle then include(fts, ftsItalic);
  try
    filename := FontName;
    if (filename <> FFont.Name) or (fts <> FFont.Style) then
    begin
      twChange := true;
      {$IFDEF BGRABITMAP_USE_LCL12}
      FFont.SetNameAndStyle(filename,fts);
      {$ELSE}
      FFont.Name := filename;
      FFont.Style := fts;
      {$ENDIF}
    end;
  except
    on ex: exception do
    begin
    end;
  end;
  newSize := FontEmHeightF;
  if newSize <> FLastFontSize then
  begin
    twChange := true;
    if FontEmHeightF >= 0 then
      FFont.SizeInPixels := FontEmHeightF
    else
      FFont.LineFullHeight := -FontEmHeightF;
    FLastFontSize := newSize;
  end;
  case FontQuality of
    fqSystem:
    begin
      FFont.Quality := grqMonochrome;
      newClearType := false;
    end;
    fqSystemClearType:
    begin
      FFont.Quality:= grqLowQuality;
      newClearType:= true;
    end;
    fqFineAntialiasing:
    begin
      FFont.Quality:= grqHighQuality;
      newClearType:= false;
    end;
    fqFineClearTypeRGB,fqFineClearTypeBGR:
    begin
      FFont.Quality:= grqHighQuality;
      newClearType:= true;
    end;
  end;
  if ADisableClearType then newClearType:= false;
  if newClearType <> FFont.ClearType then
  begin
    twChange := true;
    FFont.ClearType:= newClearType;
  end;
  if FFont.Hinted <> FontHinted then
  begin
    twChange := true;
    FFont.Hinted := FontHinted;
  end;
  {$IFDEF BGRABITMAP_USE_LCL12}
    FFont.StrikeOutDecoration := fsStrikeOut in FontStyle;
    FFont.UnderlineDecoration := fsUnderline in FontStyle;
  {$ENDIF}
  if twChange then FreeAndNil(FTypeWriter);
end;

procedure TBGRAFreeTypeFontRenderer.Init;
begin
  ShaderActive := true;

  FDrawer := TBGRAFreeTypeDrawer.Create(nil);
  FFont := TFreeTypeFont.Create;
  FLastFontSize:= EmptySingle;
  FontHinted:= True;

  ShadowColor := BGRABlack;
  ShadowVisible := false;
  ShadowOffset := Point(5,5);
  ShadowRadius := 5;
  ShadowQuality:= rbFast;
end;

procedure TBGRAFreeTypeFontRenderer.TextOutAnglePatch(ADest: TBGRACustomBitmap;
  x, y: single; orientation: integer; s: string; c: TBGRAPixel;
  tex: IBGRAScanner; align: TAlignment);
const orientationToDeg = -0.1;
var
  temp: TBGRACustomBitmap;
  coord: TPointF;
  angleDeg: single;
  OldOrientation: integer;
  filter: TResampleFilter;
begin
  OldOrientation := FontOrientation;
  FontOrientation:= 0;
  UpdateFont(true);

  temp := BGRABitmapFactory.Create;
  with TypeWriter.GetTextSizeBeforeTransform(s) do
    temp.SetSize(ceil(x),ceil(y));
  temp.FillTransparent;
  if tex<>nil then
  begin
    FDrawer.Texture := tex;
    InternalTextOut(temp,0,0, s, BGRAWhite, taLeftJustify);
    FDrawer.Texture := nil;
  end
  else
    InternalTextOut(temp,0,0, s, c, taLeftJustify);

  orientation:= orientation mod 3600;
  if orientation < 0 then inc(orientation, 3600);

  angleDeg := orientation * orientationToDeg;
  coord := PointF(x,y);
  case align of
  taRightJustify: coord.Offset( AffineMatrixRotationDeg(angleDeg)*PointF(-temp.Width,0) );
  taCenter: coord.Offset( AffineMatrixRotationDeg(angleDeg)*PointF(-0.5*temp.Width,0) );
  end;
  case orientation of
  0,900,1800,2700: filter := rfBox;
  else filter := rfCosine;
  end;
  ADest.PutImageAngle(coord.x,coord.y, temp, angleDeg, filter);
  temp.Free;

  FontOrientation:= OldOrientation;
end;

procedure TBGRAFreeTypeFontRenderer.InternalTextOut(ADest: TBGRACustomBitmap;
  x, y: single; s: string; c: TBGRAPixel; align: TAlignment);
var
  twAlign: TBGRATypeWriterAlignment;
begin
  case align of
    taCenter: twAlign:= twaTop;
    taRightJustify: twAlign := twaTopRight
  else
    twAlign := twaTopLeft;
  end;
  TFreeTypeTypeWriter(TypeWriter).DrawText(GetDrawer(ADest), s, x,y, c, twAlign);
end;

constructor TBGRAFreeTypeFontRenderer.Create;
begin
  Init;
end;

constructor TBGRAFreeTypeFontRenderer.Create(AShader: TCustomPhongShading;
  AShaderOwner: boolean);
begin
  Init;
  FShader := AShader;
  FShaderOwner := AShaderOwner;
end;

function TBGRAFreeTypeFontRenderer.FontExists(AName: string): boolean;
var
  enum: IFreeTypeFamilyEnumerator;
begin
  if Assigned(Collection) then
  begin
    enum := Collection.FamilyEnumerator;
    while enum.MoveNext do
      if CompareText(enum.Current.FamilyName, AName) = 0 then exit(true);
    result := false;
  end else
    result := true;
end;

function TBGRAFreeTypeFontRenderer.GetFontPixelMetric: TFontPixelMetric;
begin
  UpdateFont;
  result.Baseline := round(FFont.Ascent);
  result.CapLine:= round(FFont.Ascent*0.2);
  result.DescentLine:= round(FFont.Ascent+FFont.Descent);
  result.Lineheight := round(FFont.LineFullHeight);
  result.xLine := round(FFont.Ascent*0.45);
  result.Defined := True;
end;

function TBGRAFreeTypeFontRenderer.GetFontPixelMetricF: TFontPixelMetricF;
begin
  UpdateFont;
  result.Baseline := FFont.Ascent;
  result.CapLine:= FFont.Ascent*0.2;
  result.DescentLine:= FFont.Ascent+FFont.Descent;
  result.Lineheight := FFont.LineFullHeight;
  result.xLine := FFont.Ascent*0.45;
  result.Defined := True;
end;

procedure TBGRAFreeTypeFontRenderer.TextOutAngle(ADest: TBGRACustomBitmap; x,
  y: single; orientation: integer; s: string; c: TBGRAPixel; align: TAlignment);
begin
  TextOutAnglePatch(ADest, x,y, orientation, s, c, nil, align);
end;

procedure TBGRAFreeTypeFontRenderer.TextOutAngle(ADest: TBGRACustomBitmap; x,
  y: single; orientation: integer; s: string; texture: IBGRAScanner;
  align: TAlignment);
begin
  TextOutAnglePatch(ADest, x,y, orientation, s, BGRAPixelTransparent, texture, align);
end;

procedure TBGRAFreeTypeFontRenderer.TextOut(ADest: TBGRACustomBitmap; x,
  y: single; s: string; texture: IBGRAScanner; align: TAlignment);
begin
  if FontOrientation mod 3600 <> 0 then
    TextOutAngle(ADest, x,y, FontOrientation, s, texture, align)
  else
  begin
    FDrawer.Texture := texture;
    TextOut(ADest,x,y,s,BGRAWhite,align);
    FDrawer.Texture := nil;
  end;
end;

procedure TBGRAFreeTypeFontRenderer.TextOut(ADest: TBGRACustomBitmap; x,
  y: single; s: string; c: TBGRAPixel; align: TAlignment);
begin
  if FontOrientation mod 3600 <> 0 then
    TextOutAngle(ADest, x,y, FontOrientation, s, c, align)
  else
  begin
    UpdateFont;
    InternalTextOut(ADest, x,y, s, c, align);
  end;
end;

procedure TBGRAFreeTypeFontRenderer.TextRect(ADest: TBGRACustomBitmap;
  ARect: TRect; x, y: integer; s: string; style: TTextStyle; c: TBGRAPixel);
var align: TFreeTypeAlignments;
    intersectedClip,previousClip: TRect;
begin
  previousClip := ADest.ClipRect;
  if style.Clipping then
  begin
    intersectedClip := TRect.Intersect(previousClip, ARect);
    if intersectedClip.IsEmpty then exit;
    ADest.ClipRect := intersectedClip;
  end;
  UpdateFont;
  align := [];
  case style.Alignment of
  taCenter: begin ARect.Left := x; include(align, ftaCenter); end;
  taRightJustify: begin ARect.Left := x; include(align, ftaRight); end;
  else
    include(align, ftaLeft);
  end;
  case style.Layout of
  {$IFDEF BGRABITMAP_USE_LCL12}
    tlCenter: begin ARect.Top := y; include(align, ftaVerticalCenter); end;
  {$ENDIF}
  tlBottom: begin ARect.top := y; include(align, ftaBottom); end;
  else include(align, ftaTop);
  end;
  try
    {$IFDEF BGRABITMAP_USE_LCL12}
      if style.Wordbreak then
        GetDrawer(ADest).DrawTextRect(s, FFont, ARect.Left,ARect.Top,ARect.Right,ARect.Bottom,BGRAToFPColor(c),align)
      else
    {$ENDIF}
    begin
      case style.Layout of
      tlCenter: y := (ARect.Top+ARect.Bottom) div 2;
      tlBottom: y := ARect.Bottom;
      else
        y := ARect.Top;
      end;
      case style.Alignment of
      taLeftJustify: GetDrawer(ADest).DrawText(s,FFont,ARect.Left,y,BGRAToFPColor(c),align);
      taCenter: GetDrawer(ADest).DrawText(s,FFont,(ARect.Left+ARect.Right-1) div 2,y,BGRAToFPColor(c),align);
      taRightJustify: GetDrawer(ADest).DrawText(s,FFont,ARect.Right,y,BGRAToFPColor(c),align);
      end;
    end;
  finally
    if style.Clipping then
      ADest.ClipRect := previousClip;
  end;
end;

procedure TBGRAFreeTypeFontRenderer.TextRect(ADest: TBGRACustomBitmap;
  ARect: TRect; x, y: integer; s: string; style: TTextStyle;
  texture: IBGRAScanner);
begin
  FDrawer.Texture := texture;
  TextRect(ADest,ARect,x,y,s,style,BGRAWhite);
  FDrawer.Texture := nil;
end;

function TBGRAFreeTypeFontRenderer.TextSize(sUTF8: string): TSize;
begin
  with TextSizeF(sUTF8) do
    result := Size(System.Round(x),System.Round(y));
end;

function TBGRAFreeTypeFontRenderer.TextSizeF(sUTF8: string): TPointF;
begin
  UpdateFont;
  result := TypeWriter.GetTextSizeBeforeTransform(sUTF8);
end;

function TBGRAFreeTypeFontRenderer.TextSize(sUTF8: string; AMaxWidth: integer;
  ARightToLeft: boolean): TSize;
begin
  with TextSizeF(sUTF8, AMaxWidth, ARightToLeft) do
    result := Size(System.Round(x),System.Round(y));
end;

function TBGRAFreeTypeFontRenderer.TextSizeF(sUTF8: string; AMaxWidthF: single;
  ARightToLeft: boolean): TPointF;
var
  w,h: single;
  charCount, byteCount: integer;
begin
  UpdateFont;
  result.x := 0;
  result.y := 0;
  h := FFont.LineFullHeight;
  repeat
    TypeWriter.TextFitInfoBeforeTransform(sUTF8, AMaxWidthF, charCount, byteCount, w);
    if w>result.x then result.x := w;
    IncF(result.y, h);
    sUTF8 := copy(sUTF8, byteCount+1, length(sUTF8)-byteCount);
  until sUTF8 = '';
end;

function TBGRAFreeTypeFontRenderer.TextFitInfo(sUTF8: string; AMaxWidth: integer): integer;
begin
  result := TextFitInfoF(sUTF8, AMaxWidth);
end;

function TBGRAFreeTypeFontRenderer.TextFitInfoF(sUTF8: string;
  AMaxWidthF: single): integer;
var
  byteCount: integer;
  usedWidth: single;
begin
  UpdateFont;
  TypeWriter.TextFitInfoBeforeTransform(sUTF8, AMaxWidthF, result, byteCount, usedWidth);
end;

destructor TBGRAFreeTypeFontRenderer.Destroy;
begin
  FTypeWriter.Free;
  FDrawer.Free;
  FFont.Free;
  if FShaderOwner then FShader.Free;
  inherited Destroy;
end;

{ TBGRAFreeTypeDrawer }

procedure TBGRAFreeTypeDrawer.RenderDirectly( x,y,tx: integer;
                          data: pointer );
var psrc: pbyte;
    pdest: PBGRAPixel;
    c: TBGRAPixel;
begin
  if Destination <> nil then
  begin
    //ensure rendering in bounds
    if (y < 0) or (y >= Destination.height) or (x < 0) or (x > Destination.width-tx) then exit;

    psrc := pbyte(data);
    pdest := Destination.ScanLine[y]+x;
    if Texture = nil then
    begin
      c := FColor;
      while tx > 0 do
      begin
        DrawPixelInlineWithAlphaCheck(pdest,c,psrc^);
        inc(psrc);
        inc(pdest);
        dec(tx);
      end;
    end else
    begin
      Texture.ScanMoveTo(x,y);
      while tx > 0 do
      begin
        DrawPixelInlineWithAlphaCheck(pdest,Texture.ScanNextPixel,psrc^);
        inc(psrc);
        inc(pdest);
        dec(tx);
      end;
    end;
  end;
end;

procedure TBGRAFreeTypeDrawer.RenderDirectlyClearType(x, y, tx: integer; data: pointer);
var xb: integer;
    psrc: pbyte;
    pdest: PBGRAPixel;
begin
  if Destination <> nil then
  begin
    tx := tx div 3;
    if tx=0 then exit;
    if (FMask <> nil) and (FMask.Width <> tx) then
      FMask.SetSize(tx,1)
    else if FMask = nil then FMask := BGRABitmapFactory.create(tx,1);

    pdest := FMask.Data;
    psrc := pbyte(data);
    pdest^.red := (psrc^ + psrc^ + (psrc+1)^) div 3;
    pdest^.green := (psrc^+ (psrc+1)^ + (psrc+2)^) div 3;
    if tx > 1 then
      pdest^.blue := ((psrc+1)^ + (psrc+2)^ + (psrc+3)^) div 3
    else
      pdest^.blue := ((psrc+1)^ + (psrc+2)^ + (psrc+2)^) div 3;
    inc(pdest);
    inc(psrc,3);
    for xb := 1 to tx-2 do
    begin
      pdest^.red := ((psrc-1)^+ psrc^ + (psrc+1)^) div 3;
      pdest^.green := (psrc^+ (psrc+1)^ + (psrc+2)^) div 3;
      pdest^.blue := ((psrc+1)^ + (psrc+2)^ + (psrc+3)^) div 3;
      inc(pdest);
      inc(psrc,3);
    end;
    if tx > 1 then
    begin
      pdest^.red := ((psrc-1)^+ psrc^ + (psrc+1)^) div 3;
      pdest^.green := (psrc^+ (psrc+1)^ + (psrc+2)^) div 3;
      pdest^.blue := ((psrc+1)^ + (psrc+2)^ + (psrc+2)^) div 3;
    end;
    BGRAFillClearTypeRGBMask(Destination,x div 3,y,FMask,FColor,Texture,ClearTypeRGBOrder);
  end;
end;

function TBGRAFreeTypeDrawer.ShadowActuallyVisible: boolean;
begin
  result := ShadowVisible and (ShadowColor.alpha <> 0);
end;

function TBGRAFreeTypeDrawer.OutlineActuallyVisible: boolean;
begin
  result := ((OutlineTexture <> nil) or (OutlineColor.alpha <> 0)) and OutlineVisible;
end;

function TBGRAFreeTypeDrawer.ShaderActuallyActive: boolean;
begin
  result := (Shader <> nil) and ShaderActive;
end;

constructor TBGRAFreeTypeDrawer.Create(ADestination: TBGRACustomBitmap);
begin
  Destination := ADestination;
  ClearTypeRGBOrder:= true;
  ShaderActive := true;
  ShadowQuality:= rbFast;
end;

procedure TBGRAFreeTypeDrawer.DrawText(AText: string;
  AFont: TFreeTypeRenderableFont; x, y: single; AColor: TFPColor);
var fx: TBGRACustomTextEffect;
  procedure DoOutline;
  begin
    if OutlineActuallyVisible then
    begin
      if OutlineTexture <> nil then
        fx.DrawOutline(Destination,round(x),round(y), OutlineTexture)
      else
        fx.DrawOutline(Destination,round(x),round(y), OutlineColor);
    end;
  end;
begin
  if not FInCreateTextEffect and (ShadowActuallyVisible or OutlineActuallyVisible or ShaderActuallyActive) then
  begin
    fx := CreateTextEffect(AText, AFont);
    fx.ShadowQuality := ShadowQuality;
    DecF(y, AFont.Ascent);
    if ShadowActuallyVisible then fx.DrawShadow(Destination, round(x+ShadowOffset.X),round(y+ShadowOffset.Y), ShadowRadius, ShadowColor);
    if OuterOutlineOnly then DoOutline;

    if texture <> nil then
    begin
      if ShaderActuallyActive then
        fx.DrawShaded(Destination,floor(x),floor(y), Shader, round(fx.TextSize.cy*0.05), texture)
      else
        fx.Draw(Destination,round(x),round(y), texture);
    end else
    begin
      if ShaderActuallyActive then
        fx.DrawShaded(Destination,floor(x),floor(y), Shader, round(fx.TextSize.cy*0.05), FPColorToBGRA(AColor))
      else
        fx.Draw(Destination,round(x),round(y), FPColorToBGRA(AColor));
    end;
    if not OuterOutlineOnly then DoOutline;
    fx.Free;
  end else
  begin
    FColor := FPColorToBGRA(AColor);
    if AFont.ClearType then
      AFont.RenderText(AText, x, y, Destination.ClipRect, @RenderDirectlyClearType)
    else
      AFont.RenderText(AText, x, y, Destination.ClipRect, @RenderDirectly);
  end;
end;

procedure TBGRAFreeTypeDrawer.DrawText(AText: string;
  AFont: TFreeTypeRenderableFont; x, y: single; AColor: TBGRAPixel);
begin
  DrawText(AText, AFont, x,y, BGRAToFPColor(AColor));
end;

procedure TBGRAFreeTypeDrawer.DrawText(AText: string;
  AFont: TFreeTypeRenderableFont; x, y: single; AColor: TBGRAPixel;
  AAlign: TFreeTypeAlignments);
begin
  DrawText(AText, AFont, x,y, BGRAToFPColor(AColor), AAlign);
end;

{$IFDEF BGRABITMAP_USE_LCL12}
procedure TBGRAFreeTypeDrawer.DrawTextWordBreak(AText: string;
  AFont: TFreeTypeRenderableFont; x, y, AMaxWidth: Single; AColor: TBGRAPixel;
  AAlign: TFreeTypeAlignments);
begin
  DrawTextWordBreak(AText,AFont,x,y,AMaxWidth,BGRAToFPColor(AColor),AAlign);
end;

procedure TBGRAFreeTypeDrawer.DrawTextRect(AText: string;
  AFont: TFreeTypeRenderableFont; X1, Y1, X2, Y2: Single; AColor: TBGRAPixel;
  AAlign: TFreeTypeAlignments);
begin
  DrawTextRect(AText,AFont,X1,Y1,X2,Y2,BGRAToFPColor(AColor),AAlign);
end;
{$ENDIF}

{$IFDEF BGRABITMAP_USE_LCL15}
procedure TBGRAFreeTypeDrawer.DrawGlyph(AGlyph: integer;
  AFont: TFreeTypeRenderableFont; x, y: single; AColor: TFPColor);
var f: TFreeTypeFont;
begin
  if not (AFont is TFreeTypeFont) then exit;
  f := TFreeTypeFont(Afont);
  FColor := FPColorToBGRA(AColor);
  if AFont.ClearType then
    f.RenderGlyph(AGlyph, x, y, Destination.ClipRect, @RenderDirectlyClearType)
  else
    f.RenderGlyph(AGlyph, x, y, Destination.ClipRect, @RenderDirectly);
end;

procedure TBGRAFreeTypeDrawer.DrawGlyph(AGlyph: integer;
  AFont: TFreeTypeRenderableFont; x, y: single; AColor: TBGRAPixel);
begin
  DrawGlyph(AGlyph, AFont, x,y, BGRAToFPColor(AColor));
end;

procedure TBGRAFreeTypeDrawer.DrawGlyph(AGlyph: integer;
  AFont: TFreeTypeRenderableFont; x, y: single; AColor: TBGRAPixel;
  AAlign: TFreeTypeAlignments);
begin
  DrawGlyph(AGlyph, AFont, x,y, BGRAToFPColor(AColor), AAlign);
end;
{$ENDIF}

function TBGRAFreeTypeDrawer.CreateTextEffect(AText: string;
  AFont: TFreeTypeRenderableFont): TBGRACustomTextEffect;
var
  mask: TBGRACustomBitmap;
  tx,ty,marginHoriz,marginVert: integer;
  tempDest: TBGRACustomBitmap;
  tempTex: IBGRAScanner;
  tempClearType: boolean;
begin
  FInCreateTextEffect:= True;
  try
    tx := ceil(AFont.TextWidth(AText));
    ty := ceil(AFont.TextHeight(AText));
    marginHoriz := ty div 2;
    marginVert := 1;
    mask := BGRABitmapFactory.Create(tx+2*marginHoriz,ty+2*marginVert,BGRABlack);
    tempDest := Destination;
    tempTex := Texture;
    tempClearType:= AFont.ClearType;
    Destination := mask;
    Texture := nil;
    AFont.ClearType := false;
    DrawText(AText,AFont,marginHoriz,marginVert,BGRAWhite,[ftaTop,ftaLeft]);
    Destination := tempDest;
    Texture := tempTex;
    AFont.ClearType := tempClearType;
    mask.ConvertToLinearRGB;
    result := TBGRACustomTextEffect.Create(mask, true,tx,ty,point(-marginHoriz,-marginVert));
  finally
    FInCreateTextEffect:= false;
  end;
end;

destructor TBGRAFreeTypeDrawer.Destroy;
begin
  FMask.Free;
  inherited Destroy;
end;

{$ENDIF} // Workaround fix for Android compilation

end.
