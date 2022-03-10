// SPDX-License-Identifier: LGPL-3.0-linking-exception
unit BGRAOpenGL;

{$mode objfpc}{$H+}
{$I bgrabitmap.inc}

interface

{$IF not Defined (ANDROID)} // Workaround fix for Android compilation

uses
  BGRAClasses, SysUtils, FPimage, BGRAGraphics,
  BGRAOpenGLType, BGRASpriteGL, BGRACanvasGL, GL, GLext, GLU, BGRABitmapTypes,
  BGRAFontGL, BGRASSE, BGRAMatrix3D;

type
  TBGLCustomCanvas = BGRACanvasGL.TBGLCustomCanvas;
  TBGLSprite = TBGLDefaultSprite;
  IBGLTexture = BGRAOpenGLType.IBGLTexture;
  IBGLFont = BGRAOpenGLType.IBGLFont;
  IBGLRenderedFont = BGRAFontGL.IBGLRenderedFont;
  TOpenGLResampleFilter = BGRAOpenGLType.TOpenGLResampleFilter;
  TOpenGLBlendMode = BGRAOpenGLType.TOpenGLBlendMode;
  TBGLPath = BGRACanvasGL.TBGLPath;
  TWaitForGPUOption = BGRAOpenGLType.TWaitForGPUOption;
  TBGLCustomElementArray = BGRACanvasGL.TBGLCustomElementArray;
  TBGLCustomArray = BGRACanvasGL.TBGLCustomArray;
  TOpenGLPrimitive = BGRAOpenGLType.TOpenGLPrimitive;
  TTextLayout = BGRAGraphics.TTextLayout;

const
  tlTop = BGRAGraphics.tlTop;
  tlCenter = BGRAGraphics.tlCenter;
  tlBottom = BGRAGraphics.tlBottom;

type
  { TBGLContext }

  TBGLContext = object
  private
    function GetHeight: integer;
    function GetWidth: integer;
  public
    Canvas: TBGLCustomCanvas;
    Sprites: TBGLCustomSpriteEngine;
    property Width: integer read GetWidth;
    property Height: integer read GetHeight;
  end;

  { TBGLFrameBuffer }

  TBGLFrameBuffer = class(TBGLCustomFrameBuffer)
  protected
    FHeight: integer;
    FMatrix: TAffineMatrix;
    FProjectionMatrix: TMatrix4D;
    FTexture: IBGLTexture;
    FFrameBufferId, FRenderBufferId: GLuint;
    FWidth: integer;
    FSettingMatrices: boolean;
    function GetTexture: IBGLTexture; override;
    function GetHandle: pointer; override;
    function GetHeight: integer; override;
    function GetMatrix: TAffineMatrix; override;
    function GetProjectionMatrix: TMatrix4D; override;
    function GetWidth: integer; override;
    procedure SetMatrix(AValue: TAffineMatrix); override;
    procedure SetProjectionMatrix(AValue: TMatrix4D); override;
  public
    constructor Create(AWidth,AHeight: integer);
    function MakeTextureAndFree: IBGLTexture; override;
    destructor Destroy; override;
  end;

const
  orfBox = BGRAOpenGLType.orfBox;
  orfLinear = BGRAOpenGLType.orfLinear;
  obmNormal = BGRAOpenGLType.obmNormal;
  obmAdd = BGRAOpenGLType.obmAdd;
  obmMultiply = BGRAOpenGLType.obmMultiply;
  wfgQueueAllCommands = BGRAOpenGLType.wfgQueueAllCommands;
  wfgFinishAllCommands = BGRAOpenGLType.wfgFinishAllCommands;
  opPoints = BGRAOpenGLType.opPoints;
  opLineStrip = BGRAOpenGLType.opLineStrip;
  opLineLoop = BGRAOpenGLType.opLineLoop;
  opLines = BGRAOpenGLType.opLines;
  opTriangleStrip = BGRAOpenGLType.opTriangleStrip;
  opTriangleFan = BGRAOpenGLType.opTriangleFan;
  opTriangles = BGRAOpenGLType.opTriangles;

type
  { TBGLBitmap }

  TBGLBitmap = class(TBGLCustomBitmap)
  protected
    function GetOpenGLMaxTexSize: integer; override;
  public
    function NewBitmap: TBGLBitmap; overload; override;
    function NewBitmap(AWidth, AHeight: integer): TBGLBitmap; overload; override;
    function NewBitmap(AWidth, AHeight: integer; const Color: TBGRAPixel): TBGLBitmap; overload; override;
    function NewBitmap(AWidth, AHeight: integer; AColor: Pointer): TBGLBitmap; overload; override;
    function NewBitmap(Filename: string): TBGLBitmap; overload; override;
    function NewBitmap(Filename: string; AIsUtf8: boolean): TBGLBitmap; overload; override;
    function NewBitmap(Filename: string; AIsUtf8: boolean; AOptions: TBGRALoadingOptions): TBGLBitmap; overload; override;
    function NewBitmap(AFPImage: TFPCustomImage): TBGLBitmap; overload; override;
    function NewReference: TBGLBitmap; override;
    function GetUnique: TBGLBitmap; override;
    function Duplicate(DuplicateProperties: Boolean = False): TBGLBitmap; overload; override;
    function Duplicate(DuplicateProperties, DuplicateXorMask: Boolean) : TBGLBitmap; overload; override;
    function GetPart(const ARect: TRect): TBGLBitmap; override;
    function CreateBrushTexture(ABrushStyle: TBrushStyle; APatternColor, ABackgroundColor: TBGRAPixel;
                AWidth: integer = 8; AHeight: integer = 8; APenWidth: single = 1): TBGLBitmap; override;
    function Resample(newWidth, newHeight: integer;
      mode: TResampleMode = rmFineResample): TBGLBitmap; override;
    function FilterSmartZoom3(Option: TMedianOption): TBGLBitmap; override;
    function FilterMedian(Option: TMedianOption): TBGLBitmap; override;
    function FilterSmooth: TBGLBitmap; override;
    function FilterSharpen(Amount: single = 1): TBGLBitmap; overload; override;
    function FilterSharpen(ABounds: TRect; Amount: single = 1): TBGLBitmap; overload; override;
    function FilterContour(AGammaCorrection: boolean = false): TBGLBitmap; override;
    function FilterPixelate(pixelSize: integer; useResample: boolean; filter: TResampleFilter = rfLinear): TBGLBitmap; override;
    function FilterBlurRadial(radius: single; blurType: TRadialBlurType): TBGLBitmap; overload; override;
    function FilterBlurRadial(const ABounds: TRect; radius: single; blurType: TRadialBlurType): TBGLBitmap; overload; override;
    function FilterBlurRadial(radiusX, radiusY: single; blurType: TRadialBlurType): TBGLBitmap; overload; override;
    function FilterBlurRadial(const ABounds: TRect; radiusX, radiusY: single; blurType: TRadialBlurType): TBGLBitmap; overload; override;
    function FilterBlurMotion(distance: single; angle: single; oriented: boolean): TBGLBitmap; overload; override;
    function FilterBlurMotion(const ABounds: TRect; distance: single; angle: single; oriented: boolean): TBGLBitmap; overload; override;
    function FilterCustomBlur(mask: TCustomUniversalBitmap): TBGLBitmap; overload; override;
    function FilterCustomBlur(const ABounds: TRect; mask: TCustomUniversalBitmap): TBGLBitmap; overload; override;
    function FilterEmboss(angle: single; AStrength: integer= 64; AOptions: TEmbossOptions = []): TBGLBitmap; overload; override;
    function FilterEmboss(angle: single; ABounds: TRect; AStrength: integer= 64; AOptions: TEmbossOptions = []): TBGLBitmap; overload; override;
    function FilterEmbossHighlight(FillSelection: boolean): TBGLBitmap; overload; override;
    function FilterEmbossHighlight(FillSelection: boolean; BorderColor: TBGRAPixel): TBGLBitmap; overload; override;
    function FilterEmbossHighlight(FillSelection: boolean; BorderColor: TBGRAPixel; var Offset: TPoint): TBGLBitmap; overload; override;
    function FilterGrayscale: TBGLBitmap; overload; override;
    function FilterGrayscale(ABounds: TRect): TBGLBitmap; overload; override;
    function FilterNormalize(eachChannel: boolean = True): TBGLBitmap; overload; override;
    function FilterNormalize(ABounds: TRect; eachChannel: boolean = True): TBGLBitmap; overload; override;
    function FilterRotate(origin: TPointF; angle: single; correctBlur: boolean = false): TBGLBitmap; override;
    function FilterAffine(AMatrix: TAffineMatrix; correctBlur: boolean = false): TBGLBitmap; override;
    function FilterSphere: TBGLBitmap; override;
    function FilterTwirl(ACenter: TPoint; ARadius: Single; ATurn: Single=1; AExponent: Single=3): TBGLBitmap; overload; override;
    function FilterTwirl(ABounds: TRect; ACenter: TPoint; ARadius: Single; ATurn: Single=1; AExponent: Single=3): TBGLBitmap; overload; override;
    function FilterCylinder: TBGLBitmap; override;
    function FilterPlane: TBGLBitmap; override;
  end;

function BGLTexture(ARGBAData: PLongWord; AllocatedWidth,AllocatedHeight, ActualWidth,ActualHeight: integer): IBGLTexture; overload;
function BGLTexture(AFPImage: TFPCustomImage): IBGLTexture; overload;
function BGLTexture(ABitmap: TBitmap): IBGLTexture; overload;
function BGLTexture(AWidth, AHeight: integer; Color: TColor): IBGLTexture; overload;
function BGLTexture(AWidth, AHeight: integer; Color: TBGRAPixel): IBGLTexture; overload;
function BGLTexture(AFilenameUTF8: string): IBGLTexture; overload;
function BGLTexture(AFilenameUTF8: string; AWidth, AHeight: integer; AResampleFilter: TResampleFilter = rfBox): IBGLTexture; overload;
function BGLTexture(AStream: TStream): IBGLTexture; overload;

function BGLSpriteEngine: TBGLCustomSpriteEngine;

function BGLCanvas: TBGLCustomCanvas;

procedure BGLViewPort(AWidth,AHeight: integer); overload;
procedure BGLViewPort(AWidth,AHeight: integer; AColor: TBGRAPixel); overload;

function BGLFont({%H-}AName: string; {%H-}AEmHeight: integer; {%H-}AStyle: TFontStyles = []): IBGLRenderedFont; overload;
function BGLFont({%H-}AName: string; {%H-}AEmHeight: integer; {%H-}AColor: TBGRAPixel; {%H-}AStyle: TFontStyles = []): IBGLRenderedFont; overload;
function BGLFont({%H-}AName: string; {%H-}AEmHeight: integer; {%H-}AColor: TBGRAPixel; {%H-}AOutlineColor: TBGRAPixel; {%H-}AStyle: TFontStyles = []): IBGLRenderedFont; overload;
function BGLFont({%H-}AName: string; {%H-}AEmHeight: integer; ARenderer: TBGRACustomFontRenderer; ARendererOwned: boolean = true): IBGLRenderedFont; overload;

type
  { TBGLElementArray }

  TBGLElementArray = class(TBGLCustomElementArray)
  protected
    FElements: packed array of GLuint;
    FBuffer: GLuint;
    function GetCount: integer; override;
  public
    constructor Create(const AElements: array of integer); override;
    procedure Draw(ACanvas: TBGLCustomCanvas; APrimitive: TOpenGLPrimitive; AAttributes: array of TAttributeVariable); override;
    destructor Destroy; override;
  end;

  { TBGLArray }

  TBGLArray = class(TBGLCustomArray)
  protected
    FBufferAddress: pointer;
    FCount: integer;
    FRecordSize: integer;
    function GetCount: integer; override;
    function GetRecordSize: integer; override;
  public
    constructor Create(ABufferAddress: Pointer; ACount: integer; ARecordSize: integer); override;
    destructor Destroy; override;
  end;

  {$ENDIF} // Workaround fix for Android compilation

implementation

{$IF not Defined (ANDROID)} // Workaround fix for Android compilation

uses BGRABlurGL, BGRATransform{$IFDEF BGRABITMAP_USE_LCL}, BGRAText, BGRATextFX{$ENDIF};

type
  TBlendFuncSeparateProc = procedure(sfactorRGB: GLenum; dfactorRGB: GLenum; sfactorAlpha: GLenum; dfactorAlpha: GLenum); {$IFDEF Windows} stdcall; {$ELSE} cdecl; {$ENDIF}

function PrimitiveToOpenGL(AValue: TOpenGLPrimitive): GLenum;
begin
  case AValue of
    opPoints: result := GL_POINTS;
    opLineStrip: result := GL_LINE_STRIP;
    opLineLoop: result := GL_LINE_LOOP;
    opLines: result := GL_LINES;
    opTriangleStrip: result := GL_TRIANGLE_STRIP;
    opTriangleFan: result := GL_TRIANGLE_FAN;
    opTriangles: result := GL_TRIANGLES;
  else
    raise exception.Create('Unknown primitive type');
  end;
end;

procedure NeedOpenGL2_0;
begin
  if glUseProgram = nil then
  begin
    if not Load_GL_version_2_0 then
      raise exception.Create('Cannot load OpenGL 2.0');
  end;
end;

function CheckOpenGL2_0: boolean;
begin
  if glUseProgram = nil then
  begin
    result := Load_GL_version_2_0;
  end
  else
    result := true;
end;

var
  BGLCanvasInstance: TBGLCustomCanvas;
  glBlendFuncSeparate: TBlendFuncSeparateProc;
  glBlendFuncSeparateFetched: boolean;

const
  GL_COMBINE_ARB                    = $8570;
  GL_COMBINE_RGB_ARB                = $8571;
  GL_SOURCE0_RGB_ARB                = $8580;
  GL_PRIMARY_COLOR_ARB              = $8577;

type
  { TBGLTexture }

  TBGLTexture = class(TBGLCustomTexture)
  protected
    FFlipX,FFlipY: Boolean;

    function GetOpenGLMaxTexSize: integer; override;
    function CreateOpenGLTexture(ARGBAData: PLongWord; AAllocatedWidth, AAllocatedHeight, AActualWidth, AActualHeight: integer; RGBAOrder: boolean): TBGLTextureHandle; override;
    procedure UpdateOpenGLTexture(ATexture: TBGLTextureHandle; ARGBAData: PLongWord; AAllocatedWidth, AAllocatedHeight, AActualWidth,AActualHeight: integer; RGBAOrder: boolean); override;
    class function SupportsBGRAOrder: boolean; override;
    procedure SetOpenGLTextureSize(ATexture: TBGLTextureHandle; AAllocatedWidth, AAllocatedHeight, AActualWidth, AActualHeight: integer); override;
    procedure ComputeOpenGLFramesCoord(ATexture: TBGLTextureHandle; FramesX: Integer=1; FramesY: Integer=1); override;
    function GetOpenGLFrameCount(ATexture: TBGLTextureHandle): integer; override;
    function GetEmptyTexture: TBGLTextureHandle; override;
    procedure FreeOpenGLTexture(ATexture: TBGLTextureHandle); override;
    procedure UpdateGLResampleFilter(ATexture: TBGLTextureHandle; AFilter: TOpenGLResampleFilter); override;

    procedure InternalSetColor(const AColor: TBGRAPixel);
    procedure DoDrawTriangleOrQuad(const APoints: array of TPointF;
      const APointsZ: array of Single; const APoints3D: array of TPoint3D_128;
      const ANormals3D: array of TPoint3D_128; const ATexCoords: array of TPointF;
      const AColors: array of TColorF); override;
    procedure DoDraw(pt1,pt2,pt3,pt4: TPointF; AColor: TBGRAPixel);
    procedure DoStretchDraw(x,y,w,h: single; AColor: TBGRAPixel); override;
    procedure DoStretchDrawAngle(x,y,w,h,angleDeg: single; rotationCenter: TPointF; AColor: TBGRAPixel); override;
    procedure DoDrawAffine(Origin, HAxis, VAxis: TPointF; AColor: TBGRAPixel); override;
    procedure Init(ATexture: TBGLTextureHandle; AWidth,AHeight: integer; AOwned: boolean); override;
    procedure NotifyInvalidFrameSize; override;
    procedure NotifyErrorLoadingFile(AFilenameUTF8: string); override;

    function NewEmpty: TBGLCustomTexture; override;
    function NewFromTexture(ATexture: TBGLTextureHandle; AWidth,AHeight: integer): TBGLCustomTexture; override;
    function Duplicate: TBGLCustomTexture; override;

  public
    procedure ToggleFlipX; override;
    procedure ToggleFlipY; override;
    procedure Bind(ATextureNumber: integer); override;
    function FilterBlurMotion(ARadius: single; ABlurType: TRadialBlurType; ADirection: TPointF): IBGLTexture; override;
    function FilterBlurRadial(ARadius: single; ABlurType: TRadialBlurType): IBGLTexture; override;

  end;

  POpenGLTexture = ^TOpenGLTexture;
  TOpenGLTexture = record
    ID: GLuint;
    AllocatedWidth,AllocatedHeight,ActualWidth,ActualHeight: integer;
    FramesCoord: array of array[0..3] of TPointF;
  end;

  { TBGLCanvas }

  TBGLCanvas = class(TBGLCustomCanvas)
  protected
    FMatrix: TAffineMatrix;
    FProjectionMatrix: TMatrix4D;
    FBlendMode: TOpenGLBlendMode;
    FLighting: TBGLCustomLighting;
    FFaceCulling: TFaceCulling;

    function GetLighting: TBGLCustomLighting; override;

    function GetMatrix: TAffineMatrix; override;
    procedure SetMatrix(const AValue: TAffineMatrix); override;
    function GetProjectionMatrix: TMatrix4D; override;
    procedure SetProjectionMatrix(const AValue: TMatrix4D); override;

    function GetFaceCulling: TFaceCulling; override;
    procedure SetFaceCulling(AValue: TFaceCulling); override;

    procedure InternalSetColor(const AColor: TBGRAPixel); override;
    procedure InternalSetColorF(const AColor: TColorF); override;

    procedure InternalStartPutPixel(const pt: TPointF); override;
    procedure InternalStartPolyline(const pt: TPointF); override;
    procedure InternalStartPolygon(const pt: TPointF); override;
    procedure InternalStartTriangleFan(const pt: TPointF); override;
    procedure InternalContinueShape(const pt: TPointF); overload; override;

    procedure InternalContinueShape(const pt: TPoint3D); overload; override;
    procedure InternalContinueShape(const pt: TPoint3D_128); overload; override;
    procedure InternalContinueShape(const pt, normal: TPoint3D_128); overload; override;

    procedure InternalEndShape; override;

    procedure InternalStartBlend; override;
    procedure InternalEndBlend; override;

    procedure InternalStartBlendTriangles; override;
    procedure InternalStartBlendQuads; override;
    procedure InternalEndBlendTriangles; override;
    procedure InternalEndBlendQuads; override;

    procedure EnableScissor(AValue: TRect); override;
    procedure DisableScissor; override;

    function GetBlendMode: TOpenGLBlendMode; override;
    procedure SetBlendMode(AValue: TOpenGLBlendMode); override;

    procedure SetActiveFrameBuffer(AValue: TBGLCustomFrameBuffer); override;
  public
    destructor Destroy; override;
    procedure Fill(AColor: TBGRAPixel); override;
    procedure StartZBuffer; override;
    procedure EndZBuffer; override;
    procedure WaitForGPU(AOption: TWaitForGPUOption); override;
    function GetImage(x, y, w, h: integer): TBGRACustomBitmap; override;
    function CreateFrameBuffer(AWidth, AHeight: integer): TBGLCustomFrameBuffer; override;
  end;

  { TBGLLighting }

  TBGLLighting = class(TBGLCustomLighting)
  protected
    FLightUsage: array[0..7] of boolean;
    FCurrentSpecularIndex: single;
    FAmbiantLightF: TColorF;
    FBuiltInLighting: boolean;
    function MakeShaderObject(AShaderType: GLenum; ASource: string): GLuint;
    function AddLight(AColor: TColorF): integer;
    function GetSupportShaders: boolean; override;
    procedure SetAmbiantLightF(AAmbiantLight: TColorF); override;
    function GetAmbiantLightF: TColorF; override;
    function GetBuiltInLightingEnabled: boolean; override;
    procedure SetBuiltInLightingEnabled(AValue: boolean); override;
  public
    constructor Create;
    function AddDirectionalLight(AColor: TColorF; ADirection: TPoint3D): integer; override;
    function AddPointLight(AColor: TColorF; APosition: TPoint3D; ALinearAttenuation, AQuadraticAttenuation: single): integer; override;
    procedure ClearLights; override;
    function RemoveLight(AIndex: integer): boolean; override;
    procedure SetSpecularIndex(AIndex: integer); override;

    function MakeVertexShader(ASource: string): LongWord; override;
    function MakeFragmentShader(ASource: string): LongWord; override;
    function MakeShaderProgram(AVertexShader, AFragmentShader: LongWord): LongWord; override;
    procedure UseProgram(AProgram: LongWord); override;
    procedure DeleteShaderObject(AShader: LongWord); override;
    procedure DeleteShaderProgram(AProgram: LongWord); override;
    function GetUniformVariable(AProgram: LongWord; AName: string): LongWord; override;
    function GetAttribVariable(AProgram: LongWord; AName: string): LongWord; override;
    procedure SetUniformSingle(AVariable: LongWord; const AValue; AElementCount, AComponentCount: integer); override;
    procedure SetUniformInteger(AVariable: LongWord; const AValue; AElementCount, AComponentCount: integer); override;
    procedure BindAttribute(AAttribute: TAttributeVariable); override;
    procedure UnbindAttribute(AAttribute: TAttributeVariable); override;
  end;

{ TBGLFrameBuffer }

procedure TBGLFrameBuffer.SetMatrix(AValue: TAffineMatrix);
begin
  if FSettingMatrices then Exit;
  FSettingMatrices := true;
  FMatrix:=AValue;
  if FCanvas <> nil then
    TBGLCustomCanvas(FCanvas).Matrix := AValue;
  FSettingMatrices := false;
end;

function TBGLFrameBuffer.GetMatrix: TAffineMatrix;
begin
  result := FMatrix;
end;

function TBGLFrameBuffer.GetTexture: IBGLTexture;
begin
  result := FTexture.FlipY;
end;

function TBGLFrameBuffer.GetHandle: pointer;
begin
  result := @FFrameBufferId;
end;

function TBGLFrameBuffer.GetHeight: integer;
begin
  result := FHeight;
end;

function TBGLFrameBuffer.GetProjectionMatrix: TMatrix4D;
begin
  result := FProjectionMatrix;
end;

function TBGLFrameBuffer.GetWidth: integer;
begin
  result := FWidth;
end;

procedure TBGLFrameBuffer.SetProjectionMatrix(AValue: TMatrix4D);
begin
  if FSettingMatrices then Exit;
  FSettingMatrices := true;
  FProjectionMatrix:= AValue;
  if FCanvas <> nil then
    TBGLCustomCanvas(FCanvas).ProjectionMatrix := AValue;
  FSettingMatrices := false;
end;

constructor TBGLFrameBuffer.Create(AWidth, AHeight: integer);
var frameBufferStatus: GLenum;
begin
  if not Load_GL_version_3_0 then
      raise exception.Create('Cannot load OpenGL 3.0');

  FWidth := AWidth;
  FHeight := AHeight;

  FTexture := BGLTextureFactory.Create(nil,AWidth,AHeight,AWidth,AHeight);

  //depth and stencil
  glGenRenderbuffers(1, @FRenderBufferId);
  glBindRenderbuffer(GL_RENDERBUFFER, FRenderBufferId);
  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, AWidth,AHeight);
  glBindRenderbuffer(GL_RENDERBUFFER, 0);

  glGenFramebuffers(1, @FFrameBufferId);
  glBindFramebuffer(GL_FRAMEBUFFER, FFrameBufferId);

  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, PGLuint(FTexture.Handle)^, 0);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, FFrameBufferId);

  frameBufferStatus:= glCheckFramebufferStatus(GL_FRAMEBUFFER);
  glBindFramebuffer(GL_FRAMEBUFFER, 0);

  if frameBufferStatus <> GL_FRAMEBUFFER_COMPLETE then
  begin
    glDeleteFramebuffers(1, @FFrameBufferId);
    glDeleteRenderbuffers(1, @FRenderBufferId);
    FTexture := nil;
    raise exception.Create('Error ' + inttostr(frameBufferStatus) + ' while initializing frame buffer');
  end;

  UseOrthoProjection;
  Matrix := AffineMatrixIdentity;
end;

function TBGLFrameBuffer.MakeTextureAndFree: IBGLTexture;
begin
  result := FTexture;
  FTexture := nil;
  Free;
end;

destructor TBGLFrameBuffer.Destroy;
begin
  glDeleteFramebuffers(1, @FFrameBufferId);
  glDeleteRenderbuffers(1, @FRenderBufferId);
  FTexture := nil;

  inherited Destroy;
end;

procedure ApplyBlendMode(ABlendMode: TOpenGLBlendMode);
var
  srcBlend : LongWord;
  dstBlend : LongWord;
begin
  case ABlendMode of
    obmAdd:
      begin
        srcBlend := GL_SRC_ALPHA;
        dstBlend := GL_ONE;
      end;
    obmMultiply:
      begin
        srcBlend := GL_ZERO;
        dstBlend := GL_SRC_COLOR;
      end
    else
      begin
        srcBlend := GL_SRC_ALPHA;
        dstBlend := GL_ONE_MINUS_SRC_ALPHA;
      end;
  end;
  if not glBlendFuncSeparateFetched then
  begin
    glBlendFuncSeparate := TBlendFuncSeparateProc(wglGetProcAddress('glBlendFuncSeparate'));
    glBlendFuncSeparateFetched := true;
  end;
  if Assigned(glBlendFuncSeparate) then
    glBlendFuncSeparate( srcBlend, dstBlend, GL_ONE, GL_ONE_MINUS_SRC_ALPHA )
  else
    glBlendFunc( srcBlend, dstBlend );
end;

function BGLTexture(ARGBAData: PLongWord; AllocatedWidth, AllocatedHeight,
  ActualWidth, ActualHeight: integer): IBGLTexture;
begin
  result := TBGLTexture.Create(ARGBAData,AllocatedWidth, AllocatedHeight,
        ActualWidth, ActualHeight);
end;

function BGLTexture(AFPImage: TFPCustomImage): IBGLTexture;
begin
  result := TBGLTexture.Create(AFPImage);
end;

function BGLTexture(ABitmap: TBitmap): IBGLTexture;
begin
  result := TBGLTexture.Create(ABitmap);
end;

function BGLTexture(AWidth, AHeight: integer; Color: TColor): IBGLTexture;
begin
  result := TBGLTexture.Create(AWidth,AHeight,Color);
end;

function BGLTexture(AWidth, AHeight: integer; Color: TBGRAPixel): IBGLTexture;
begin
  result := TBGLTexture.Create(AWidth,AHeight,Color);
end;

function BGLTexture(AFilenameUTF8: string): IBGLTexture;
begin
  result := TBGLTexture.Create(AFilenameUTF8);
end;

function BGLTexture(AFilenameUTF8: string; AWidth, AHeight: integer; AResampleFilter: TResampleFilter): IBGLTexture;
begin
  result := TBGLTexture.Create(AFilenameUTF8, AWidth, AHeight, AResampleFilter);
end;

function BGLTexture(AStream: TStream): IBGLTexture;
begin
  result := TBGLTexture.Create(AStream);
end;

function BGLSpriteEngine: TBGLCustomSpriteEngine;
begin
  result := BGRASpriteGL.BGLSpriteEngine;
end;

procedure BGLViewPort(AWidth, AHeight: integer; AColor: TBGRAPixel);
begin
  BGLViewPort(AWidth,AHeight);
  BGLCanvas.Fill(AColor);
end;

function BGLFont(AName: string; AEmHeight: integer; AStyle: TFontStyles = []): IBGLRenderedFont;
begin
  {$IFDEF BGRABITMAP_USE_LCL}
  result := BGLFont(AName, AEmHeight, TLCLFontRenderer.Create);
  result.Style := AStyle;
  {$ELSE}
  result := nil;
  raise exception.Create('LCL renderer not available');
  {$ENDIF}
end;

function BGLFont(AName: string; AEmHeight: integer; AColor: TBGRAPixel;
  AStyle: TFontStyles): IBGLRenderedFont;
begin
  {$IFDEF BGRABITMAP_USE_LCL}
  result := BGLFont(AName, AEmHeight, TLCLFontRenderer.Create);
  result.Color := AColor;
  result.Style := AStyle;
  {$ELSE}
  result := nil;
  raise exception.Create('LCL renderer not available');
  {$ENDIF}
end;

function BGLFont(AName: string; AEmHeight: integer; AColor: TBGRAPixel;
  AOutlineColor: TBGRAPixel; AStyle: TFontStyles = []): IBGLRenderedFont;
{$IFDEF BGRABITMAP_USE_LCL}
var renderer: TBGRATextEffectFontRenderer;
begin
  renderer := TBGRATextEffectFontRenderer.Create;
  renderer.OuterOutlineOnly:= true;
  renderer.OutlineColor := AOutlineColor;
  renderer.OutlineVisible := true;
  result := BGLFont(AName, AEmHeight, renderer, true);
  result.Color := AColor;
  result.Style := AStyle;
end;
{$ELSE}
begin
  result := nil;
  raise exception.Create('LCL renderer not available');
end;
{$ENDIF}

function BGLFont(AName: string; AEmHeight: integer;
  ARenderer: TBGRACustomFontRenderer;
  ARendererOwned: boolean): IBGLRenderedFont;
var f: TBGLRenderedFont;
begin
  f:= TBGLRenderedFont.Create(ARenderer, ARendererOwned);
  f.Name := AName;
  f.EmHeight := AEmHeight;
  result := f;
end;

function BGLCanvas: TBGLCustomCanvas;
begin
  result := BGLCanvasInstance;
end;

procedure BGLViewPort(AWidth, AHeight: integer);
begin
  BGLCanvas.Width := AWidth;
  BGLCanvas.Height := AHeight;
  BGLCanvas.UseOrthoProjection;
  BGLCanvas.Matrix := AffineMatrixIdentity;
  BGLCanvas.FaceCulling := fcNone;
end;

{ TBGLArray }

function TBGLArray.GetCount: integer;
begin
  result := FCount;
end;

function TBGLArray.GetRecordSize: integer;
begin
  result := FRecordSize;
end;

constructor TBGLArray.Create(ABufferAddress: pointer; ACount: integer;
  ARecordSize: integer);
var b: GLuint;
begin
  NeedOpenGL2_0;
  FBufferAddress:= ABufferAddress;
  FCount := ACount;
  FRecordSize:= ARecordSize;
  glGenBuffers(1, @b);
  FBuffer := b;
  glBindBuffer(GL_ARRAY_BUFFER, FBuffer);
  glBufferData(GL_ARRAY_BUFFER, FCount*FRecordSize, FBufferAddress, GL_STATIC_DRAW);
end;

destructor TBGLArray.Destroy;
var b: GLuint;
begin
  b := FBuffer;
  glDeleteBuffers(1, @b);
  inherited Destroy;
end;

{ TBGLElementArray }

function TBGLElementArray.GetCount: integer;
begin
  result := length(FElements);
end;

constructor TBGLElementArray.Create(const AElements: array of integer);
var bufferSize: integer;
  i: Int32or64;
begin
  NeedOpenGL2_0;
  setlength(FElements,length(AElements));
  bufferSize := length(FElements)*sizeof(integer);
  for i := 0 to high(FElements) do
    FElements[i] := AElements[i];
  glGenBuffers(1, @FBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, FBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, bufferSize, @FElements[0], GL_STATIC_DRAW);
end;

procedure TBGLElementArray.Draw(ACanvas: TBGLCustomCanvas; APrimitive: TOpenGLPrimitive; AAttributes: array of TAttributeVariable);
var
  i: Int32or64;
begin
  for i := 0 to high(AAttributes) do
    ACanvas.Lighting.BindAttribute(AAttributes[i]);

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, FBuffer);
  glDrawElements(PrimitiveToOpenGL(APrimitive), Count, GL_UNSIGNED_INT, nil);

  for i := 0 to high(AAttributes) do
    ACanvas.Lighting.UnbindAttribute(AAttributes[i]);
end;

destructor TBGLElementArray.Destroy;
begin
  glDeleteBuffers(1, @FBuffer);
  inherited Destroy;
end;

{ TBGLLighting }

procedure TBGLLighting.SetAmbiantLightF(AAmbiantLight: TColorF);
begin
  FAmbiantLightF := AAmbiantLight;
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, @AAmbiantLight);
end;

constructor TBGLLighting.Create;
begin
  FAmbiantLightF := ColorF(1,1,1,1);
end;

function TBGLLighting.AddPointLight(AColor: TColorF; APosition: TPoint3D; ALinearAttenuation, AQuadraticAttenuation: single): integer;
var
  v: TPoint3D_128;
begin
  result := AddLight(AColor);
  if result <> -1 then
  begin
    v := Point3D_128(APosition);
    v.t := 1;
    glLightfv(GL_LIGHT0 + result, GL_POSITION, @v);
    glLightf(GL_LIGHT0 + result, GL_CONSTANT_ATTENUATION, 0);
    glLightf(GL_LIGHT0 + result, GL_LINEAR_ATTENUATION, ALinearAttenuation);
    glLightf(GL_LIGHT0 + result, GL_QUADRATIC_ATTENUATION, AQuadraticAttenuation);
  end;
end;

procedure TBGLLighting.ClearLights;
var
  i: Integer;
begin
  for i := 0 to High(FLightUsage) do
    if FLightUsage[i] then
      RemoveLight(i);
end;

function TBGLLighting.AddDirectionalLight(AColor: TColorF; ADirection: TPoint3D): integer;
var
  v: TPoint3D_128;
begin
  result := AddLight(AColor);
  if result <> -1 then
  begin
    v := Point3D_128(ADirection);
    Normalize3D_128(v);
    v.t := 0;
    glLightfv(GL_LIGHT0 + result, GL_POSITION, @v);
  end;
end;

procedure TBGLLighting.SetSpecularIndex(AIndex: integer);
var c: TColorF;
  newIndex: single;
begin
  newIndex := AIndex*0.5;
  if newIndex < 0 then newIndex := 0;
  if newIndex > 128 then newIndex := 128;
  if newIndex <> FCurrentSpecularIndex then
  begin
    if newIndex = 0 then
      c := ColorF(0,0,0,1)
    else
      c := ColorF(1,1,1,1);
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, newIndex);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @c);
    FCurrentSpecularIndex := newIndex;
  end;
end;

function TBGLLighting.MakeVertexShader(ASource: string): LongWord;
begin
  result := MakeShaderObject(GL_VERTEX_SHADER, ASource);
end;

function TBGLLighting.MakeFragmentShader(ASource: string): LongWord;
begin
  result := MakeShaderObject(GL_FRAGMENT_SHADER, ASource);
end;

function TBGLLighting.GetAmbiantLightF: TColorF;
begin
  result := FAmbiantLightF;
end;

function TBGLLighting.GetBuiltInLightingEnabled: boolean;
begin
  result := FBuiltInLighting;
end;

procedure TBGLLighting.SetBuiltInLightingEnabled(AValue: boolean);
begin
  if AValue = FBuiltInLighting then exit;
  FBuiltInLighting:= AValue;
  if AValue then
  begin
    glEnable(GL_LIGHTING);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, @FAmbiantLightF);
    glLightModelf(GL_LIGHT_MODEL_LOCAL_VIEWER, 0);
    glLightModelf(GL_LIGHT_MODEL_TWO_SIDE,1);
  end else
  begin
    glDisable(GL_LIGHTING);
  end;
end;

function TBGLLighting.MakeShaderObject(AShaderType: GLenum; ASource: string
  ): GLuint;
var
  psource: pchar;
  sourceLen: GLint;
  shaderId: GLuint;
  shaderOk: GLint;
  log: string;
  logLen: GLint;
begin
  NeedOpenGL2_0;

  if ASource = '' then
    raise exception.Create('Empty code file provided');

  shaderId := glCreateShader(AShaderType);
  psource := @ASource[1];
  sourceLen := length(ASource);
  glShaderSource(shaderId, 1, @psource, @sourceLen);
  glCompileShader(shaderId);

  glGetShaderiv(shaderId, GL_COMPILE_STATUS, @shaderOk);
  if not (shaderOk <> 0) then
  begin
    //retrieve error log
    glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, @logLen);
    setlength(log, logLen);
    if logLen > 0 then
      glGetShaderInfoLog(shaderId, logLen, nil, @log[1]);

    glDeleteShader(shaderId);
    raise exception.Create('Failed to compile shader: ' + log);
  end;
  result := shaderId;
end;

function TBGLLighting.AddLight(AColor: TColorF): integer;
var
  i: Integer;
  black: TColorF;
begin
  for i := 0 to high(FLightUsage) do
    if not FLightUsage[i] then
    begin
      result := i;
      FLightUsage[i] := true;
      black := ColorF(0,0,0,1);
      glLightfv(GL_LIGHT0 + i, GL_AMBIENT, @black);
      glLightfv(GL_LIGHT0 + i, GL_DIFFUSE, @AColor);
      glLightfv(GL_LIGHT0 + i, GL_SPECULAR, @AColor);
      glEnable(GL_LIGHT0 + i);
      exit;
    end;
  result := -1;
end;

function TBGLLighting.GetSupportShaders: boolean;
begin
  result := CheckOpenGL2_0;
end;

function TBGLLighting.MakeShaderProgram(AVertexShader, AFragmentShader: LongWord): LongWord;
var
  programOk: GLint;
  shaderProgram: GLuint;
  log: string;
  logLen: GLint;
begin
  NeedOpenGL2_0;

  shaderProgram := glCreateProgram();
  glAttachShader(shaderProgram, AVertexShader);
  glAttachShader(shaderProgram, AFragmentShader);
  glLinkProgram(shaderProgram);

  glGetProgramiv(shaderProgram, GL_LINK_STATUS, @programOk);
  if not (programOk <> 0) then
  begin
    //retrieve error log
    glGetProgramiv(shaderProgram, GL_INFO_LOG_LENGTH, @logLen);
    setlength(log, logLen);
    if logLen > 0 then
      glGetProgramInfoLog(shaderProgram, logLen, nil, @log[1]);

    glDeleteProgram(shaderProgram);
    raise exception.Create('Failed to link shader program: ' + log);
  end;
  result := shaderProgram;
end;

procedure TBGLLighting.UseProgram(AProgram: LongWord);
begin
  NeedOpenGL2_0;
  glUseProgram(AProgram);
end;

procedure TBGLLighting.DeleteShaderObject(AShader: LongWord);
begin
  NeedOpenGL2_0;
  if AShader<> 0 then
    glDeleteShader(AShader);
end;

procedure TBGLLighting.DeleteShaderProgram(AProgram: LongWord);
begin
  NeedOpenGL2_0;
  if AProgram<> 0 then
    glDeleteProgram(AProgram);
end;

function TBGLLighting.GetUniformVariable(AProgram: LongWord; AName: string): LongWord;
begin
  NeedOpenGL2_0;
  result := glGetUniformLocation(AProgram, @AName[1]);
end;

function TBGLLighting.GetAttribVariable(AProgram: LongWord; AName: string): LongWord;
begin
  NeedOpenGL2_0;
  result := glGetAttribLocation(AProgram, @AName[1]);
end;

procedure TBGLLighting.SetUniformSingle(AVariable: LongWord;
  const AValue; AElementCount, AComponentCount: integer);
begin
  NeedOpenGL2_0;
  case AComponentCount of
    1: glUniform1fv(AVariable, AElementCount, @AValue);
    2: glUniform2fv(AVariable, AElementCount, @AValue);
    3: glUniform3fv(AVariable, AElementCount, @AValue);
    4: glUniform4fv(AVariable, AElementCount, @AValue);
    9: glUniformMatrix3fv(AVariable, AElementCount, GL_FALSE, @AValue);
    16: glUniformMatrix4fv(AVariable, AElementCount, GL_FALSE, @AValue);
  else
    raise exception.Create('Unexpected number of components');
  end;
end;

procedure TBGLLighting.SetUniformInteger(AVariable: LongWord;
  const AValue; AElementCount, AComponentCount: integer);
begin
  NeedOpenGL2_0;
  case AComponentCount of
    1: glUniform1iv(AVariable, AElementCount, @AValue);
    2: glUniform2iv(AVariable, AElementCount, @AValue);
    3: glUniform3iv(AVariable, AElementCount, @AValue);
    4: glUniform4iv(AVariable, AElementCount, @AValue);
  else
    raise exception.Create('Unexpected number of components');
  end;
end;

procedure TBGLLighting.BindAttribute(AAttribute: TAttributeVariable);
var t: GLenum;
begin
  glBindBuffer(GL_ARRAY_BUFFER, AAttribute.Source.Handle);
  if AAttribute.IsFloat then
    t := GL_FLOAT
  else
    t := GL_INT;
  glVertexAttribPointer(AAttribute.Handle, AAttribute.VectorSize,t,GL_FALSE,
     AAttribute.Source.RecordSize, {%H-}pointer(PtrInt(AAttribute.RecordOffset)));
  glEnableVertexAttribArray(AAttribute.Handle);
end;

procedure TBGLLighting.UnbindAttribute(AAttribute: TAttributeVariable);
begin
  glDisableVertexAttribArray(AAttribute.Handle);
end;

function TBGLLighting.RemoveLight(AIndex: integer): boolean;
begin
  if (AIndex >= 0) and (AIndex <= high(FLightUsage)) and
    FLightUsage[AIndex] then
  begin
    glDisable(GL_LIGHT0 + AIndex);
    FLightUsage[AIndex] := false;
    result := true;
  end
  else
    result := false;
end;

{ TBGLContext }

function TBGLContext.GetHeight: integer;
begin
  if Assigned(Canvas) then
    result := Canvas.Height
  else
    result := 0;
end;

function TBGLContext.GetWidth: integer;
begin
  if Assigned(Canvas) then
    result := Canvas.Width
  else
    result := 0;
end;

{ TBGLCanvas }

function TBGLCanvas.GetLighting: TBGLCustomLighting;
begin
  if FLighting = nil then
    FLighting := TBGLLighting.Create;
  result := FLighting;
end;

function TBGLCanvas.GetMatrix: TAffineMatrix;
begin
  if ActiveFrameBuffer <> nil then
    result := ActiveFrameBuffer.Matrix
  else
    result := FMatrix;
end;

procedure TBGLCanvas.SetMatrix(const AValue: TAffineMatrix);
var m: TMatrix4D;
begin
  glMatrixMode(GL_MODELVIEW);
  m := AffineMatrixToMatrix4D(AValue);
  glLoadMatrixf(@m);

  if ActiveFrameBuffer <> nil then
    ActiveFrameBuffer.Matrix := AValue
  else
    FMatrix := AValue;
end;

function TBGLCanvas.GetProjectionMatrix: TMatrix4D;
begin
  if ActiveFrameBuffer <> nil then
    result := ActiveFrameBuffer.ProjectionMatrix
  else
    result := FProjectionMatrix;
end;

procedure TBGLCanvas.SetProjectionMatrix(const AValue: TMatrix4D);
begin
  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@AValue);
  glMatrixMode(GL_MODELVIEW);

  if ActiveFrameBuffer <> nil then
    ActiveFrameBuffer.ProjectionMatrix := AValue
  else
    FProjectionMatrix := AValue;
end;

function TBGLCanvas.GetFaceCulling: TFaceCulling;
begin
  result := FFaceCulling;
end;

procedure TBGLCanvas.SetFaceCulling(AValue: TFaceCulling);
begin
  if AValue = FFaceCulling then exit;
  if FFaceCulling = fcNone then
    glEnable(GL_CULL_FACE);
  case AValue of
    fcNone: glDisable(GL_CULL_FACE);
    fcKeepCW: glFrontFace(GL_CW);
    fcKeepCCW: glFrontFace(GL_CCW);
  end;
  FFaceCulling:= AValue;
end;

procedure TBGLCanvas.InternalStartPutPixel(const pt: TPointF);
begin
  glBegin(GL_POINTS);
  glVertex2fv(@pt);
end;

procedure TBGLCanvas.InternalStartPolyline(const pt: TPointF);
begin
  glBegin(GL_LINE_STRIP);
  glVertex2fv(@pt);
end;

procedure TBGLCanvas.InternalStartPolygon(const pt: TPointF);
begin
  glBegin(GL_LINE_LOOP);
  glVertex2fv(@pt);
end;

procedure TBGLCanvas.InternalStartTriangleFan(const pt: TPointF);
begin
  glBegin(GL_TRIANGLE_FAN);
  glVertex2fv(@pt);
end;

procedure TBGLCanvas.InternalContinueShape(const pt: TPointF);
begin
  glVertex2fv(@pt);
end;

procedure TBGLCanvas.InternalContinueShape(const pt: TPoint3D);
begin
  glVertex3fv(@pt);
end;

procedure TBGLCanvas.InternalContinueShape(const pt: TPoint3D_128);
begin
  glVertex3fv(@pt);
end;

procedure TBGLCanvas.InternalContinueShape(const pt, normal: TPoint3D_128);
begin
  glNormal3fv(@normal);
  glVertex3fv(@pt);
end;

procedure TBGLCanvas.InternalEndShape;
begin
  glEnd();
end;

procedure TBGLCanvas.InternalSetColor(const AColor: TBGRAPixel);
begin
  {$PUSH}{$WARNINGS OFF}
  if TBGRAPixel_RGBAOrder then
    glColor4ubv(@AColor)
  else
    glColor4ub(AColor.red,AColor.green,AColor.blue,AColor.alpha);
  {$POP}
end;

procedure TBGLCanvas.InternalSetColorF(const AColor: TColorF);
begin
  glColor4fv(@AColor[1]);
end;

procedure TBGLCanvas.InternalStartBlend;
begin
  glEnable(GL_BLEND);
  ApplyBlendMode(BlendMode);
end;

procedure TBGLCanvas.InternalEndBlend;
begin
  glDisable(GL_BLEND);
end;

procedure TBGLCanvas.InternalStartBlendTriangles;
begin
  InternalStartBlend;
  glBegin(GL_TRIANGLES);
end;

procedure TBGLCanvas.InternalStartBlendQuads;
begin
  InternalStartBlend;
  glBegin(GL_QUADS);
end;

procedure TBGLCanvas.InternalEndBlendTriangles;
begin
  InternalEndShape;
  InternalEndBlend;
end;

procedure TBGLCanvas.InternalEndBlendQuads;
begin
  InternalEndShape;
  InternalEndBlend;
end;

procedure TBGLCanvas.Fill(AColor: TBGRAPixel);
begin
  glClearColor(AColor.Red/255, AColor.green/255, AColor.blue/255, AColor.alpha/255);
  glClear(GL_COLOR_BUFFER_BIT);
end;

procedure TBGLCanvas.StartZBuffer;
begin
  glEnable(GL_DEPTH_TEST);
  glClear(GL_DEPTH_BUFFER_BIT);
end;

procedure TBGLCanvas.EndZBuffer;
begin
  glDisable(GL_DEPTH_TEST);
end;

procedure TBGLCanvas.WaitForGPU(AOption: TWaitForGPUOption);
begin
  case AOption of
    wfgQueueAllCommands: glFlush;
    wfgFinishAllCommands: glFinish;
  end;
end;

function TBGLCanvas.GetImage(x, y, w, h: integer): TBGRACustomBitmap;
begin
  NeedOpenGL2_0;
  result := BGRABitmapFactory.Create(w,h);
  {$PUSH}{$WARNINGS OFF}
  if TBGRAPixel_RGBAOrder then
    glReadPixels(x,self.Height-y-h, w,h, GL_RGBA, GL_UNSIGNED_BYTE, result.Data)
  else
    glReadPixels(x,self.Height-y-h, w,h, GL_BGRA, GL_UNSIGNED_BYTE, result.Data);
  {$POP}
end;

function TBGLCanvas.CreateFrameBuffer(AWidth, AHeight: integer): TBGLCustomFrameBuffer;
begin
  Result:= TBGLFrameBuffer.Create(AWidth,AHeight);
end;

procedure TBGLCanvas.EnableScissor(AValue: TRect);
begin
  glScissor(AValue.left,Height-AValue.bottom,AValue.right-AValue.left,AValue.Bottom-AValue.Top);
  glEnable(GL_SCISSOR_TEST);
end;

procedure TBGLCanvas.DisableScissor;
begin
  glDisable(GL_SCISSOR_TEST);
end;

function TBGLCanvas.GetBlendMode: TOpenGLBlendMode;
begin
  result := FBlendMode;
end;

procedure TBGLCanvas.SetBlendMode(AValue: TOpenGLBlendMode);
begin
  FBlendMode := AValue;
end;

procedure TBGLCanvas.SetActiveFrameBuffer(AValue: TBGLCustomFrameBuffer);
var
  m: TMatrix4D;
begin
  if AValue = ActiveFrameBuffer then exit;
  inherited SetActiveFrameBuffer(AValue);
  if AValue = nil then
    glBindFramebuffer(GL_FRAMEBUFFER, 0)
  else
    glBindFramebuffer(GL_FRAMEBUFFER, PGLuint(AValue.Handle)^);

  glViewPort(0,0,Width,Height);

  glMatrixMode(GL_PROJECTION);
  m := ProjectionMatrix;
  glLoadMatrixf(@m);

  glMatrixMode(GL_MODELVIEW);
  m := AffineMatrixToMatrix4D(Matrix);
  glLoadMatrixf(@m);
end;

destructor TBGLCanvas.Destroy;
begin
  FLighting.Free;
  inherited Destroy;
end;

{ TBGLTexture }

function TBGLTexture.GetOpenGLMaxTexSize: integer;
begin
  result := 0;
  glGetIntegerv( GL_MAX_TEXTURE_SIZE, @result );
end;

function TBGLTexture.CreateOpenGLTexture(ARGBAData: PLongWord;
  AAllocatedWidth, AAllocatedHeight, AActualWidth, AActualHeight: integer;
  RGBAOrder: boolean): TBGLTextureHandle;
var p: POpenGLTexture;
  providedFormat: GLenum;
begin
  if RGBAOrder then providedFormat:= GL_RGBA else providedFormat:= GL_BGRA;
  New(p);
  p^.AllocatedWidth := AAllocatedWidth;
  p^.AllocatedHeight := AAllocatedHeight;
  p^.ActualWidth := AActualWidth;
  p^.ActualHeight := AActualHeight;

  glGenTextures( 1, @p^.ID );
  glBindTexture( GL_TEXTURE_2D, p^.ID );
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
  glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, AAllocatedWidth, AAllocatedHeight, 0, providedFormat, GL_UNSIGNED_BYTE, ARGBAData );
  result := p;
end;

procedure TBGLTexture.UpdateOpenGLTexture(ATexture: TBGLTextureHandle;
  ARGBAData: PLongWord; AAllocatedWidth, AAllocatedHeight, AActualWidth,
  AActualHeight: integer; RGBAOrder: boolean);
var providedFormat: GLenum;
begin
  if RGBAOrder then providedFormat:= GL_RGBA else providedFormat:= GL_BGRA;
  SetOpenGLTextureSize(ATexture, AAllocatedWidth,AAllocatedHeight, AActualWidth,AActualHeight);
  glBindTexture( GL_TEXTURE_2D, TOpenGLTexture(ATexture^).ID );
  glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, AAllocatedWidth, AAllocatedHeight, 0, providedFormat, GL_UNSIGNED_BYTE, ARGBAData );
end;

class function TBGLTexture.SupportsBGRAOrder: boolean;
begin
  Result:= true;
end;

procedure TBGLTexture.SetOpenGLTextureSize(ATexture: TBGLTextureHandle;
  AAllocatedWidth, AAllocatedHeight, AActualWidth, AActualHeight: integer);
begin
  with TOpenGLTexture(ATexture^) do
  begin
    ActualWidth := AActualWidth;
    ActualHeight:= AActualHeight;
    AllocatedWidth := AAllocatedWidth;
    AllocatedHeight := AAllocatedHeight;
  end;
end;

procedure TBGLTexture.ComputeOpenGLFramesCoord(ATexture: TBGLTextureHandle;
  FramesX: Integer; FramesY: Integer);
var U,V: Single;
  tX, tY, fU, fV : Single;
  ix,iy,i: Integer;
begin
  with TOpenGLTexture(ATexture^) do
  begin
    if AllocatedWidth = 0 then
      U := 1
    else
      U := ActualWidth/AllocatedWidth;
    if AllocatedHeight = 0 then
      V := 1
    else
      V := ActualHeight/AllocatedHeight;

    if FramesX < 1 then FramesX := 1;
    if FramesY < 1 then FramesY := 1;

    SetLength( FramesCoord, FramesX * FramesY + 1 );
    fU := U / FramesX;
    fV := V / FramesY;

    FramesCoord[ 0, 0 ].X := 0;
    FramesCoord[ 0, 0 ].Y := 0;
    FramesCoord[ 0, 1 ].X := U;
    FramesCoord[ 0, 1 ].Y := 0;
    FramesCoord[ 0, 2 ].X := U;
    FramesCoord[ 0, 2 ].Y := V;
    FramesCoord[ 0, 3 ].X := 0;
    FramesCoord[ 0, 3 ].Y := V;

    ix := 1;
    iy := 1;
    for i := 1 to FramesX * FramesY do
      begin
        tX := ix * fU;
        tY := iy * fV;

        FramesCoord[ i, 0 ].X := tX - fU;
        FramesCoord[ i, 0 ].Y := tY - fV;

        FramesCoord[ i, 1 ].X := tX;
        FramesCoord[ i, 1 ].Y := tY - fV;

        FramesCoord[ i, 2 ].X := tX;
        FramesCoord[ i, 2 ].Y := tY;

        FramesCoord[ i, 3 ].X := tX - fU;
        FramesCoord[ i, 3 ].Y := tY;

        inc(ix);
        if ix > FramesX then
        begin
          ix := 1;
          inc(iy);
        end;
      end;

  end;
end;

function TBGLTexture.GetOpenGLFrameCount(ATexture: TBGLTextureHandle): integer;
begin
  if ATexture = nil then
    result := 0
  else
  begin
    result := Length(TOpenGLTexture(ATexture^).FramesCoord);
    if result > 0 then dec(result); //first frame is whole picture
  end;
end;

function TBGLTexture.GetEmptyTexture: TBGLTextureHandle;
begin
  result := nil;
end;

procedure TBGLTexture.FreeOpenGLTexture(ATexture: TBGLTextureHandle);
begin
  glDeleteTextures( 1, @TOpenGLTexture(ATexture^).ID );
  Dispose(POpenGLTexture(ATexture));
end;

procedure TBGLTexture.UpdateGLResampleFilter(ATexture: TBGLTextureHandle;
  AFilter: TOpenGLResampleFilter);
begin
  glBindTexture( GL_TEXTURE_2D, TOpenGLTexture(ATexture^).ID );
  if AFilter = orfLinear then
  begin
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
  end else
  begin
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
  end;
end;

procedure TBGLTexture.InternalSetColor(const AColor: TBGRAPixel);
begin
  {$PUSH}{$WARNINGS OFF}
  if TBGRAPixel_RGBAOrder then
    glColor4ubv(@AColor)
  else
    glColor4ub(AColor.red,AColor.green,AColor.blue,AColor.alpha);
  {$POP}
end;

procedure TBGLTexture.DoDrawTriangleOrQuad(const APoints: array of TPointF;
  const APointsZ: array of Single; const APoints3D: array of TPoint3D_128;
  const ANormals3D: array of TPoint3D_128; const ATexCoords: array of TPointF;
  const AColors: array of TColorF);
var
  i: Integer;
  factorX,factorY: single;
begin
  if (FOpenGLTexture = nil) or (Width = 0) or (Height = 0) then exit;
  with TOpenGLTexture(FOpenGLTexture^) do
  begin
    glEnable( GL_BLEND );

    glEnable( GL_TEXTURE_2D );
    glBindTexture( GL_TEXTURE_2D, ID );

    if FIsMask then
    begin
      glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_ARB );
      glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_RGB_ARB,  GL_REPLACE );
      glTexEnvi( GL_TEXTURE_ENV, GL_SOURCE0_RGB_ARB,  GL_PRIMARY_COLOR_ARB );
    end else
      glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );

    ApplyBlendMode(BlendMode);

    factorX := 1/Width;
    factorY := 1/Height;

    if length(AColors) = 0 then
      glColor4f(1,1,1,1);

    if length(APoints3D) <> 0 then
    begin
      if length(APoints3D) = 3 then
        glBegin( GL_TRIANGLES )
      else
        glBegin( GL_QUADS );

      for i := 0 to high(APoints3D) do
      begin
        if length(AColors) <> 0 then glColor4fv( @AColors[i] );
        glTexCoord2f( (ATexCoords[i].x+0.5)*factorX, (ATexCoords[i].y+0.5)*factorY );
        if length(ANormals3D) <> 0 then glNormal3fv( @ANormals3D[i] );
        glVertex3fv( @APoints3D[i] );
      end;
    end else
    begin
      if length(APoints) = 3 then
        glBegin( GL_TRIANGLES )
      else
        glBegin( GL_QUADS );

      if length(APointsZ) <> 0 then
      begin
        for i := 0 to high(APoints) do
        begin
          if length(AColors) <> 0 then glColor4fv( @AColors[i] );
          glTexCoord2f( (ATexCoords[i].x+0.5)*factorX, (ATexCoords[i].y+0.5)*factorY );
          if length(ANormals3D) <> 0 then glNormal3fv( @ANormals3D[i] );
          glVertex3f( APoints[i].x, APoints[i].y, APointsZ[i] );
        end;
      end else
      begin
        for i := 0 to high(APoints) do
        begin
          if length(AColors) <> 0 then glColor4fv( @AColors[i] );
          glTexCoord2f( (ATexCoords[i].x+0.5)*factorX, (ATexCoords[i].y+0.5)*factorY );
          if length(ANormals3D) <> 0 then glNormal3fv( @ANormals3D[i] );
          glVertex2fv( @APoints[i] );
        end;
      end;
    end;

    glEnd;
    glDisable( GL_TEXTURE_2D );
    glDisable( GL_BLEND );
  end;
end;

procedure TBGLTexture.DoDraw(pt1, pt2, pt3, pt4: TPointF; AColor: TBGRAPixel);
type
  TTexCoordIndex = array[0..3] of integer;
const
  FLIP_TEXCOORD : array[ 0..3 ] of TTexCoordIndex = ( ( 0, 1, 2, 3 ), ( 1, 0, 3, 2 ), ( 3, 2, 1, 0 ), ( 2, 3, 0, 1 ) );
var
  coordFlip: TTexCoordIndex;
begin
  if (FOpenGLTexture = nil) or (FFrame < 0) or (FFrame > FrameCount) then exit;
  with TOpenGLTexture(FOpenGLTexture^) do
  begin
    glEnable( GL_BLEND );
    glEnable( GL_TEXTURE_2D );
    glBindTexture( GL_TEXTURE_2D, ID );

    if FIsMask then
    begin
      glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_ARB );
      glTexEnvi( GL_TEXTURE_ENV, GL_COMBINE_RGB_ARB,  GL_REPLACE );
      glTexEnvi( GL_TEXTURE_ENV, GL_SOURCE0_RGB_ARB,  GL_PRIMARY_COLOR_ARB );
    end else
      glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );

    ApplyBlendMode(BlendMode);

    coordFlip := FLIP_TEXCOORD[ Integer(FFlipX) + Integer(FFlipY)*2 ];

    glBegin( GL_QUADS );

    if GradientColors then
      InternalSetColor(FGradTopLeft)
    else
      InternalSetColor(AColor);

    glTexCoord2fv( @FramesCoord[FFrame,coordFlip[0]] );
    glVertex2fv( @pt1 );

    if GradientColors then
      InternalSetColor(FGradTopRight);

    glTexCoord2fv( @FramesCoord[FFrame,coordFlip[1]] );
    glVertex2fv( @pt2 );

    if GradientColors then
      InternalSetColor(FGradBottomRight);

    glTexCoord2fv( @FramesCoord[FFrame,coordFlip[2]] );
    glVertex2fv( @pt3 );

    if GradientColors then
      InternalSetColor(FGradBottomLeft);

    glTexCoord2fv( @FramesCoord[FFrame,coordFlip[3]] );
    glVertex2fv( @pt4 );

    glEnd;
    glDisable( GL_TEXTURE_2D );
    glDisable( GL_BLEND );
  end;
end;

procedure TBGLTexture.DoStretchDraw(x, y, w, h: single; AColor: TBGRAPixel);
begin
  DoDraw(PointF(x, y), PointF(x+w, y), PointF(x+w, y+h), PointF(x, y+h), AColor);
end;

procedure TBGLTexture.DoStretchDrawAngle(x, y, w, h, angleDeg: single;
  rotationCenter: TPointF; AColor: TBGRAPixel);
var
  m : TAffineMatrix;
begin
  m := AffineMatrixTranslation(rotationCenter.X,rotationCenter.Y)*
       AffineMatrixRotationDeg(angleDeg)*
       AffineMatrixTranslation(-rotationCenter.X,-rotationCenter.Y);
  DoDraw(m*PointF(x, y), m*PointF(x+w, y), m*PointF(x+w, y+h), m*PointF(x, y+h), AColor);
end;

procedure TBGLTexture.DoDrawAffine(Origin, HAxis, VAxis: TPointF;
  AColor: TBGRAPixel);
begin
  DoDraw(Origin, HAxis, HAxis+(VAxis-Origin), VAxis, AColor);
end;

procedure TBGLTexture.ToggleFlipX;
begin
  FFlipX := not FFlipX;
end;

procedure TBGLTexture.ToggleFlipY;
begin
  FFlipY := not FFlipY;
end;

procedure TBGLTexture.Bind(ATextureNumber: integer);
begin
  if (ATextureNumber < 0) or (ATextureNumber > 31) then
    raise exception.Create('Texture number out of bounds');
  if (glActiveTexture = nil) then
  begin
    if not Load_GL_version_1_3 then
      raise exception.Create('Cannot load OpenGL 1.3');
  end;
  glActiveTexture(GL_TEXTURE0 + ATextureNumber);
  glBindTexture(GL_TEXTURE_2D, POpenGLTexture(FOpenGLTexture)^.ID);
  if ATextureNumber<>0 then
    glActiveTexture(GL_TEXTURE0);
end;

function TBGLTexture.FilterBlurMotion(ARadius: single; ABlurType: TRadialBlurType; ADirection: TPointF): IBGLTexture;
var shader: TBGLCustomShader;
  blurName: string;
begin
  blurName := 'TBGLBlurShader(' + RadialBlurTypeToStr[ABlurType] + ')';
  shader := BGLCanvas.Lighting.Shader[blurName];
  if shader = nil then
  begin
    shader := TBGLBlurShader.Create(BGLCanvas, ABlurType);
    BGLCanvas.Lighting.Shader[blurName] := shader;
  end;
  with (shader as TBGLBlurShader) do
  begin
    Radius := ARadius;
    Direction := ADirection;
    result := FilterBlurMotion(self);
  end;
end;

function TBGLTexture.FilterBlurRadial(ARadius: single; ABlurType: TRadialBlurType): IBGLTexture;
var shader: TBGLCustomShader;
  blurName: String;
begin
  blurName := 'TBGLBlurShader(' + RadialBlurTypeToStr[ABlurType] + ')';
  shader := BGLCanvas.Lighting.Shader[blurName];
  if shader = nil then
  begin
    shader := TBGLBlurShader.Create(BGLCanvas, ABlurType);
    BGLCanvas.Lighting.Shader[blurName] := shader;
  end;
  with (shader as TBGLBlurShader) do
  begin
    Radius := ARadius;
    result := FilterBlurRadial(self);
  end;
end;

procedure TBGLTexture.Init(ATexture: TBGLTextureHandle; AWidth,
  AHeight: integer; AOwned: boolean);
begin
  inherited Init(ATexture, AWidth, AHeight, AOwned);
  FFlipX := false;
  FFlipY := false;
  FBlendMode := obmNormal;
end;

procedure TBGLTexture.NotifyInvalidFrameSize;
begin
  raise exception.Create('Invalid frame size');
end;

procedure TBGLTexture.NotifyErrorLoadingFile(AFilenameUTF8: string);
begin
  raise exception.Create('Error loading file "'+AFilenameUTF8+'"');
end;

function TBGLTexture.NewEmpty: TBGLCustomTexture;
begin
  result := TBGLTexture.Create;
end;

function TBGLTexture.NewFromTexture(ATexture: TBGLTextureHandle; AWidth,
  AHeight: integer): TBGLCustomTexture;
begin
  result := TBGLTexture.Create(ATexture,AWidth,AHeight);
end;

function TBGLTexture.Duplicate: TBGLCustomTexture;
begin
  Result:= inherited Duplicate;
  TBGLTexture(result).FFlipX := FFlipX;
  TBGLTexture(result).FFlipY := FFlipY;
end;

{ TBGLBitmap }

function TBGLBitmap.GetOpenGLMaxTexSize: integer;
begin
  result := 0;
  glGetIntegerv( GL_MAX_TEXTURE_SIZE, @result );
end;

function TBGLBitmap.NewBitmap: TBGLBitmap;
begin
  Result:=inherited NewBitmap as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(AWidth, AHeight: integer): TBGLBitmap;
begin
  Result:=inherited NewBitmap(AWidth, AHeight) as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(AWidth, AHeight: integer; const Color: TBGRAPixel
  ): TBGLBitmap;
begin
  Result:=inherited NewBitmap(AWidth, AHeight, Color) as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(AWidth, AHeight: integer; AColor: Pointer
  ): TBGLBitmap;
begin
  Result:=inherited NewBitmap(AWidth, AHeight, AColor) as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(Filename: string): TBGLBitmap;
begin
  Result:=inherited NewBitmap(Filename) as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(Filename: string; AIsUtf8: boolean): TBGLBitmap;
begin
  Result:=inherited NewBitmap(Filename, AIsUtf8) as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(Filename: string; AIsUtf8: boolean;
  AOptions: TBGRALoadingOptions): TBGLBitmap;
begin
  Result:=inherited NewBitmap(Filename, AIsUtf8, AOptions) as TBGLBitmap;
end;

function TBGLBitmap.NewBitmap(AFPImage: TFPCustomImage): TBGLBitmap;
begin
  Result:=inherited NewBitmap(AFPImage) as TBGLBitmap;
end;

function TBGLBitmap.NewReference: TBGLBitmap;
begin
  Result:=inherited NewReference as TBGLBitmap;
end;

function TBGLBitmap.GetUnique: TBGLBitmap;
begin
  Result:=inherited GetUnique as TBGLBitmap;
end;

function TBGLBitmap.Duplicate(DuplicateProperties: Boolean): TBGLBitmap;
begin
  Result:=inherited Duplicate(DuplicateProperties) as TBGLBitmap;
end;

function TBGLBitmap.Duplicate(DuplicateProperties, DuplicateXorMask: Boolean): TBGLBitmap;
begin
  Result:=inherited Duplicate(DuplicateProperties, DuplicateXorMask) as TBGLBitmap;
end;

function TBGLBitmap.GetPart(const ARect: TRect): TBGLBitmap;
begin
  Result:=inherited GetPart(ARect) as TBGLBitmap;
end;

function TBGLBitmap.CreateBrushTexture(ABrushStyle: TBrushStyle; APatternColor,
  ABackgroundColor: TBGRAPixel; AWidth: integer; AHeight: integer;
  APenWidth: single): TBGLBitmap;
begin
  Result:=inherited CreateBrushTexture(ABrushStyle, APatternColor,
    ABackgroundColor, AWidth, AHeight, APenWidth) as TBGLBitmap;
end;

function TBGLBitmap.Resample(newWidth, newHeight: integer; mode: TResampleMode
  ): TBGLBitmap;
begin
  Result:=inherited Resample(newWidth, newHeight, mode) as TBGLBitmap;
end;

function TBGLBitmap.FilterSmartZoom3(Option: TMedianOption): TBGLBitmap;
begin
  Result:=inherited FilterSmartZoom3(Option) as TBGLBitmap;
end;

function TBGLBitmap.FilterMedian(Option: TMedianOption): TBGLBitmap;
begin
  Result:=inherited FilterMedian(Option) as TBGLBitmap;
end;

function TBGLBitmap.FilterSmooth: TBGLBitmap;
begin
  Result:=inherited FilterSmooth as TBGLBitmap;
end;

function TBGLBitmap.FilterSharpen(Amount: single): TBGLBitmap;
begin
  Result:=inherited FilterSharpen(Amount) as TBGLBitmap;
end;

function TBGLBitmap.FilterSharpen(ABounds: TRect; Amount: single): TBGLBitmap;
begin
  Result:=inherited FilterSharpen(ABounds, Amount) as TBGLBitmap;
end;

function TBGLBitmap.FilterContour(AGammaCorrection: boolean = false): TBGLBitmap;
begin
  Result:=inherited FilterContour(AGammaCorrection) as TBGLBitmap;
end;

function TBGLBitmap.FilterPixelate(pixelSize: integer; useResample: boolean;
  filter: TResampleFilter): TBGLBitmap;
begin
  Result:=inherited FilterPixelate(pixelSize, useResample, filter) as TBGLBitmap;
end;

function TBGLBitmap.FilterBlurRadial(radius: single; blurType: TRadialBlurType): TBGLBitmap;
begin
  Result:=inherited FilterBlurRadial(radius, blurType) as TBGLBitmap;
end;

function TBGLBitmap.FilterBlurRadial(const ABounds: TRect; radius: single;
  blurType: TRadialBlurType): TBGLBitmap;
begin
  Result:=inherited FilterBlurRadial(ABounds, radius, blurType) as TBGLBitmap;
end;

function TBGLBitmap.FilterBlurRadial(radiusX, radiusY: single;
  blurType: TRadialBlurType): TBGLBitmap;
begin
  Result:=inherited FilterBlurRadial(radiusX, radiusY, blurType) as TBGLBitmap;
end;

function TBGLBitmap.FilterBlurRadial(const ABounds: TRect; radiusX,
  radiusY: single; blurType: TRadialBlurType): TBGLBitmap;
begin
  Result:=inherited FilterBlurRadial(ABounds, radiusX, radiusY, blurType) as TBGLBitmap;
end;

function TBGLBitmap.FilterBlurMotion(distance: single; angle: single;
  oriented: boolean): TBGLBitmap;
begin
  Result:=inherited FilterBlurMotion(distance, angle, oriented) as TBGLBitmap;
end;

function TBGLBitmap.FilterBlurMotion(const ABounds: TRect; distance: single;
  angle: single; oriented: boolean): TBGLBitmap;
begin
  Result:=inherited FilterBlurMotion(ABounds, distance, angle, oriented) as TBGLBitmap;
end;

function TBGLBitmap.FilterCustomBlur(mask: TCustomUniversalBitmap): TBGLBitmap;
begin
  Result:=inherited FilterCustomBlur(mask) as TBGLBitmap;
end;

function TBGLBitmap.FilterCustomBlur(const ABounds: TRect;
  mask: TCustomUniversalBitmap): TBGLBitmap;
begin
  Result:=inherited FilterCustomBlur(ABounds, mask) as TBGLBitmap;
end;

function TBGLBitmap.FilterEmboss(angle: single; AStrength: integer;
  AOptions: TEmbossOptions): TBGLBitmap;
begin
  Result:=inherited FilterEmboss(angle, AStrength, AOptions) as TBGLBitmap;
end;

function TBGLBitmap.FilterEmboss(angle: single; ABounds: TRect;
  AStrength: integer; AOptions: TEmbossOptions): TBGLBitmap;
begin
  Result:=inherited FilterEmboss(angle, ABounds, AStrength, AOptions) as TBGLBitmap;
end;

function TBGLBitmap.FilterEmbossHighlight(FillSelection: boolean): TBGLBitmap;
begin
  Result:=inherited FilterEmbossHighlight(FillSelection) as TBGLBitmap;
end;

function TBGLBitmap.FilterEmbossHighlight(FillSelection: boolean;
  BorderColor: TBGRAPixel): TBGLBitmap;
begin
  Result:=inherited FilterEmbossHighlight(FillSelection, BorderColor) as TBGLBitmap;
end;

function TBGLBitmap.FilterEmbossHighlight(FillSelection: boolean;
  BorderColor: TBGRAPixel; var Offset: TPoint): TBGLBitmap;
begin
  Result:=inherited FilterEmbossHighlight(FillSelection, BorderColor, Offset) as TBGLBitmap;
end;

function TBGLBitmap.FilterGrayscale: TBGLBitmap;
begin
  Result:=inherited FilterGrayscale as TBGLBitmap;
end;

function TBGLBitmap.FilterGrayscale(ABounds: TRect): TBGLBitmap;
begin
  Result:=inherited FilterGrayscale(ABounds) as TBGLBitmap;
end;

function TBGLBitmap.FilterNormalize(eachChannel: boolean): TBGLBitmap;
begin
  Result:=inherited FilterNormalize(eachChannel) as TBGLBitmap;
end;

function TBGLBitmap.FilterNormalize(ABounds: TRect; eachChannel: boolean
  ): TBGLBitmap;
begin
  Result:=inherited FilterNormalize(ABounds, eachChannel) as TBGLBitmap;
end;

function TBGLBitmap.FilterRotate(origin: TPointF; angle: single;
  correctBlur: boolean): TBGLBitmap;
begin
  Result:=inherited FilterRotate(origin, angle, correctBlur) as TBGLBitmap;
end;

function TBGLBitmap.FilterAffine(AMatrix: TAffineMatrix; correctBlur: boolean
  ): TBGLBitmap;
begin
  Result:=inherited FilterAffine(AMatrix, correctBlur) as TBGLBitmap;
end;

function TBGLBitmap.FilterSphere: TBGLBitmap;
begin
  Result:=inherited FilterSphere as TBGLBitmap;
end;

function TBGLBitmap.FilterTwirl(ACenter: TPoint; ARadius: Single;
  ATurn: Single; AExponent: Single): TBGLBitmap;
begin
  Result:=inherited FilterTwirl(ACenter, ARadius, ATurn, AExponent) as TBGLBitmap;
end;

function TBGLBitmap.FilterTwirl(ABounds: TRect; ACenter: TPoint;
  ARadius: Single; ATurn: Single; AExponent: Single): TBGLBitmap;
begin
  Result:=inherited FilterTwirl(ABounds, ACenter, ARadius, ATurn, AExponent) as TBGLBitmap;
end;

function TBGLBitmap.FilterCylinder: TBGLBitmap;
begin
  Result:=inherited FilterCylinder as TBGLBitmap;
end;

function TBGLBitmap.FilterPlane: TBGLBitmap;
begin
  Result:=inherited FilterPlane as TBGLBitmap;
end;

initialization

  BGLBitmapFactory := TBGLBitmap;
  BGLTextureFactory := TBGLTexture;
  BGRASpriteGL.BGLSpriteEngine := TBGLDefaultSpriteEngine.Create;
  BGLCanvasInstance := TBGLCanvas.Create;

finalization

  BGLCanvasInstance.Free;
  BGLCanvasInstance := nil;
  BGRASpriteGL.BGLSpriteEngine.Free;
  BGRASpriteGL.BGLSpriteEngine := nil;


  {$ENDIF} // Workaround fix for Android compilation

end.

