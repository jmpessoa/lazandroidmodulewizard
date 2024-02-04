unit LamwDesigner;

{$mode objfpc}{$h+}

interface

uses
  Classes, SysUtils, Graphics, Controls, FormEditingIntf, PropEdits,
  ComponentEditors, ProjectIntf, Laz2_DOM, AndroidWidget, Laz_And_Controls,
  Dialogs, Forms, AndroidThemes, ImgCache,  LCLVersion, Math;

type
  TDraftWidget = class;

  jVisualControlClass = class of jVisualControl;
  TDraftWidgetClass = class of TDraftWidget;

  { TDraftControlHash }

  TDraftControlHash = class
  private
    FFreeLeft: Integer;
    FItems: array of record
      VisualControl: jVisualControlClass;
      Draft: TDraftWidgetClass;
    end;
    function Hash1(c: TClass): PtrUInt; inline;
    function Hash2(i: PtrUInt): PtrUInt; inline;
  public
    constructor Create(MaxCapacity: Integer);
    procedure Add(VisualControlClass: jVisualControlClass; DraftWidgetClass: TDraftWidgetClass);
    function Find(VisualControlClass: TClass): TDraftWidgetClass;
  end;

  { TAndroidWidgetMediator :: thanks to x2nie !}

  TAndroidWidgetMediator = class(TDesignerMediator,IAndroidWidgetDesigner)
  private
    FDefaultBrushColor: TColor;
    FDefaultPenColor: TColor;
    FDefaultFontColor: TColor;
    FImageCache: TImageCache;
    FSizing: Boolean;
    FStarted, FDone, FCustomDialogs, FShownCustomDialogs: TFPList;
    FLastSelectedContainer: jVisualControl;
    FSelection: TFPList;
    FProjFile: TLazProjectFile;
    FjControlDeleted: Boolean;
    FTheme: TAndroidTheme;
    FSplashExists: boolean;

    function GetAndroidForm: TandroidForm; //jForm;

    //Smart Designer helpers
    procedure InitSmartDesignerHelpers;
    procedure UpdateJControlsList; //inline;
    procedure UpdateFCLControlsList; //inline;

  protected
    //procedure OnDesignerModified(Sender: TObject);
    procedure OnDesignerModified(Sender: TObject{$If lcl_fullversion=1070000}; {%H-}PropName: ShortString{$ENDIF});
    procedure OnPersistentAdded(APersistent: TPersistent; {%H-}Select: boolean);
    //procedure OnPersistentDeleted;
    procedure OnPersistentDeleted({$IF LCL_FULLVERSION >= 2010000}APersistent: TPersistent{$endif}); //thanks to @Coldzer0 !
    procedure OnPersistentDeleting(APersistent: TPersistent);
    procedure OnSetSelection(const ASelection: TPersistentSelectionList);
    // tk
    //procedure OnAutoAssignIDs(Sender: TObject);
    procedure SetRoot(const AValue: TComponent); override;
    // end tk
  public

    //needed by the lazarus form editor
    class function CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator; override;
    class function FormClass: TComponentClass; override;

    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); override;
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); override;
    procedure GetClientArea(AComponent: TComponent; out CurClientArea: TRect; out ScrollOffset: TPoint); override;
    procedure InitComponent(AComponent, NewParent: TComponent; NewBounds: TRect); override;
    procedure Paint; override;
    function ComponentIsIcon(AComponent: TComponent): boolean; override;
    function ComponentIsVisible(AComponent: TComponent): Boolean; override;
    function ParentAcceptsChild(Parent: TComponent; Child: TComponentClass): boolean; override;
    procedure UpdateTheme;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean); override;
    procedure MouseMove(Shift: TShiftState; p: TPoint; var Handled: boolean); override;

  public
    // needed by TAndroidWidget
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
    function RootDir: string;
    function AssetsDir: string;// inline;
    function ResDir: string; //inline;
    function FindDrawable(AResourceName: string): string;
    property AndroidForm: TAndroidForm{jForm} read GetAndroidForm;  //gdx
    property AndroidTheme: TAndroidTheme read FTheme;
    property ImageCache: TImageCache read FImageCache;
  public
    procedure GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer); override;
  end;


  { TDraftWidget }

  TDraftWidget = class
  private
    FColor: TARGBColorBridge;
    FFontColor: TARGBColorBridge;
    BaseStyle: string;
    lpHeight, lpWidth: TLayoutParams;
    procedure SetColor(AColor: TARGBColorBridge);
    procedure SetFontColor(AColor: TARGBColorBridge);
    function Designer: TAndroidWidgetMediator;
    function WrapContentHeightByChildren: Integer;
    function WrapContentWidthByChildren: Integer;
  protected
    FAndroidWidget: TAndroidWidget;      // original
    FCanvas: TCanvas;                    // canvas to draw onto
    FLeftTop, FRightBottom: TPoint;      // layout
    FMinWidth, FMinHeight: Integer;
    function GetParentBackgroundColor: TARGBColorBridge;
    function GetBackGroundColor: TColor;
    function DefaultTextColor: TColor; virtual;
    function GetNewWidth: Integer;
    function GetNewHeight: Integer;
    procedure SetBounds;
  public
    BackGroundColor: TColor;
    TextColor: TColor;
    MarginBottom: integer;
    MarginLeft: integer;
    MarginRight: integer;
    MarginTop: integer;
    Height: integer;
    Width: integer;
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); virtual;
    procedure Draw; virtual;
    procedure UpdateLayout; virtual;
    property Color: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
  end;


  { TDraftDrawableWidget }

  TDraftDrawableWidget = class(TDraftWidget)
  protected
    DrawableDest: string;
    DrawableAttribs: string;
    Drawable: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  { TDraftTextView }

  TDraftTextView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftEditText }

  TDraftEditText = class(TDraftDrawableWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftAutoTextView }

  TDraftAutoTextView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftComboEditText }

  TDraftComboEditText = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftSearchView }

  TDraftSearchView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftButton }

  TDraftButton = class(TDraftDrawableWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftKToyButton }

  TDraftKToyButton = class(TDraftDrawableWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftCheckBox }

  TDraftCheckBox = class(TDraftDrawableWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftRadioButton }

  TDraftRadioButton = class(TDraftDrawableWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftRadioGroup }

  TDraftRadioGroup = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftRatingBar }

  TDraftRatingBar = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  TDraftDigitalClock = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  TDraftAnalogClock = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  { TDraftProgressBar }

  TDraftProgressBar = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  TDraftSeekBar = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftListView }

  TDraftListView = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    FDrfCount: integer;
    FDrfItems: TStringList;
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    destructor Destroy; override;
    procedure Draw; override;
  end;

  { TDraftExpandableListView }

  TDraftExpandableListView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftImageBtn }

  TDraftImageBtn = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;


  { TDraftImageView }

  TDraftImageView = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftImageButton }

  TDraftImageButton = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;


  { TDraftZoomableImageView }

  TDraftZoomableImageView = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  {TDraftDrawingView}

  TDraftDrawingView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  {TDraftSurfaceView}

  TDraftSurfaceView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  {TDraftCOpenMapView}

  TDraftCOpenMapView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  {TDraftCSignaturePad}

  TDraftCSignaturePad = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  {TDraftCustomCamera}

  TDraftCustomCamera = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  {TDraftGL2SurfaceView}

  (*
  TDraftGL2SurfaceView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;
   *)

  { TDraftSpinner }

  TDraftSpinner = class(TDraftWidget)
  private
    FDropListTextColor: TARGBColorBridge;
    DropListFontColor: TColor;

    FDropListBackgroundColor: TARGBColorBridge;
    DropListColor: TColor;

    FSelectedFontColor: TARGBColorBridge;
    SelectedTextColor: TColor;

    procedure SetDropListTextColor(Acolor: TARGBColorBridge);
    procedure SetDropListBackgroundColor(Acolor: TARGBColorBridge);
    procedure SetSelectedFontColor(Acolor: TARGBColorBridge);

  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;

    property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
    property DropListBackgroundColor: TARGBColorBridge  read FDropListBackgroundColor write SetDropListBackgroundColor;
    property SelectedFontColor: TARGBColorBridge  read FSelectedFontColor write SetSelectedFontColor;
  end;

  { TDraftWebView }

  TDraftWebView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftScrollView }

  TDraftScrollView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  TDraftHorizontalScrollView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftToggleButton }

  TDraftToggleButton = class(TDraftWidget)
  private
    FOnOff: boolean;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftSwitchButton }

  TDraftSwitchButton = class(TDraftWidget)
  public
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftGridView }

  TDraftGridView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;


  { TDraftDBListView }

  TDraftDBListView = class(TDraftGridView);

  {TDraftTreeListView}

  TDraftTreeListView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;


  { TDraftView }

  TDraftView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
  end;

  { TDraftPanel }

  TDraftPanel = class(TDraftWidget)
  public
    procedure Draw; override;
  end;

  { TDraftCaptionPanel }

  TDraftCaptionPanel = class(TDraftWidget)
  public
    procedure Draw; override;
  end;

  { TDraftToolbar }

  TDraftToolbar = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

    { TDraftFrameLayout }

  TDraftFrameLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftZBarcodeScannerView }

  TDraftZBarcodeScannerView = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSFloatingButton }

  TDraftSFloatingButton = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftSBottomNavigationView }

  TDraftSBottomNavigationView = class(TDraftWidget)
  public
    procedure Draw; override;
  end;

  { TDraftSCoordinatorLayout }

  TDraftSCoordinatorLayout = class(TDraftWidget)
  public
    procedure Draw; override;
  end;

  { TDraftSToolbar }

  TDraftSToolbar = class(TDraftWidget)
  private
   FImageLogo: TPortableNetworkGraphic;
   FImageNavigation: TPortableNetworkGraphic;
   function GetImageLogo: TPortableNetworkGraphic;
   function GetImageNavigation: TPortableNetworkGraphic;
  public
     constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
     procedure Draw; override;
     procedure UpdateLayout; override;
  end;

  { TDraftSDrawerLayout }

  TDraftSDrawerLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

    { TDraftSNavigationView }

  TDraftSNavigationView = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftLinearLayout }

  TDraftLinearLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftTableLayout }

  TDraftTableLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftCalendarView }
  TDraftCalendarView = class(TDraftWidget)
  public
     procedure Draw; override;
  end;


  { TDraftSAdMob }

  TDraftSAdMob = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSCardView }

  TDraftSCardView = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSRecyclerView }

  TDraftSRecyclerView = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSTextInput }

  TDraftSTextInput = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftSViewPager }

  TDraftSViewPager = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSAppBarLayout }

  TDraftSAppBarLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSCollapsingToolbarLayout }

  TDraftSCollapsingToolbarLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSTabLayout }

  TDraftSTabLayout = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSNestedScrollView }

  TDraftSNestedScrollView = class(TDraftWidget)
  public
     procedure Draw; override;
  end;

  { TDraftSContinuousScrollableImageView }

  TDraftSContinuousScrollableImageView = class(TDraftWidget)
  private
    FImage: TPortableNetworkGraphic;
    function GetImage: TPortableNetworkGraphic;
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;


  { TARGBColorBridgePropertyEditor }

  TARGBColorBridgePropertyEditor = class(TEnumPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure ListDrawValue(const CurValue: ansistring; Index: integer;
      ACanvas: TCanvas; const ARect:TRect; AState: TPropEditDrawState); override;
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      {%H-}AState: TPropEditDrawState); override;
  end;

  { TAnchorPropertyEditor }

  TAnchorPropertyEditor = class(TPersistentPropertyEditor)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TImageListPropertyEditor
    Only jImageList from the same form can be used }

  TImageListPropertyEditor = class(TPersistentPropertyEditor)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TAndroidFormComponentEditor }

  TAndroidFormComponentEditor = class(TDefaultComponentEditor)
  private
    procedure ChangeSize(AWidth, AHeight: Integer);
    procedure ShowSelectSizeDialog;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  { TAndroidFormSizePropertyEditor }

  TAndroidFormSizePropertyEditor = class(TIntegerPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TjImageListImagesEditor }

  TjImageListImagesEditor = class(TClassPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TjImageListEditor }

  TjImageListEditor = class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb({%H-}Index: Integer); override;
    function GetVerb({%H-}Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  { TImageIndexPropertyEditor }

  TImageIndexPropertyEditor = class(TIntegerPropertyEditor)
  private
    FAssetsDir: string;
    FImageCache: TImageCache;
    FImages: jImageList;
    function GetImageList: jImageList;
    procedure GetAssets;
  public
    procedure Activate; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const NewValue: ansistring); override;
    procedure ListDrawValue(const CurValue: ansistring; Index:integer;
      ACanvas: TCanvas;  const ARect: TRect; AState: TPropEditDrawState); override;
  end;

  { TImageIdentifierPropertyEditor }

  TImageIdentifierPropertyEditor = class(TStringPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TjCustomDialogComponentEditor }

  TjCustomDialogComponentEditor = class(TComponentEditor)
  public
    function GetVerbCount: Integer; override;
    function GetVerb({%H-}Index: Integer): string; override;
    procedure ExecuteVerb({%H-}Index: Integer); override;
  end;

implementation

uses
  LCLIntf, LCLType, strutils, ObjInspStrConsts, IDEMsgIntf, LazIDEIntf,
  IDEExternToolIntf, laz2_XMLRead, FileUtil, LazFileUtils, FPimage, typinfo,
  uFormSizeSelect, LamwSettings, SmartDesigner, jImageListEditDlg, NinePatchPNG,
  customdialog, togglebutton, switchbutton,
  Laz_And_GLESv1_Canvas, Laz_And_GLESv2_Canvas, gridview, Spinner, seekbar,
  radiogroup, ratingbar, digitalclock, analogclock, surfaceview,
  autocompletetextview, drawingview, chronometer, viewflipper, videoview,
  comboedittext, toolbar, expandablelistview, framelayout, linearlayout, captionpanel,
  sfloatingbutton, scoordinatorlayout, stoolbar, sdrawerlayout,
  snavigationview, scardview, srecyclerview, stextinput,
  sviewpager, scollapsingtoolbarlayout, stablayout, sappbarlayout,
  sbottomnavigationview, snestedscrollview, treelistview{, gl2SurfaceView},
  customcamera, sadmob, calendarview, searchview, zbarcodescannerview,
  scontinuousscrollableimageview, copenmapview, csignaturepad,
  zoomableimageview, tablelayout, imagebutton, uktoybutton;

const
  DrawableSearchPaths: array [0..4] of string = (
    'drawable-mdpi', 'drawable-ldpi', 'drawable-hdpi', 'drawable-xhdpi', 'drawable'
  );

var
  DraftClassesMap: TDraftControlHash;

procedure GetRedGreenBlue(rgb: longInt; out Red, Green, Blue: word); inline;
begin
  Red   := ( (rgb and $ff0000)  shr 16);
  Red   := Red shl 8 or Red;
  Green := ( (rgb and $ff00  )  shr  8);
  Green := Green shl 8 or Green;
  Blue  := ( (rgb and $ff    )        );
  Blue  := Blue shl 8 or Blue;
end;

function ToTFPColor(colbrColor: TARGBColorBridge): TFPColor;
var
  index: integer;
  red, green, blue: word;
begin
  index := Ord(colbrColor);
  GetRedGreenBlue(TFPColorBridgeArray[index], red, green, blue);
  Result.Red   := red;
  Result.Green := green;
  Result.Blue  := blue;
  Result.Alpha := AlphaOpaque;
end;

function ToTColor(colbrColor: TARGBColorBridge): TColor; inline;
begin
  // note: it can be done in more efficient way, but...
  Result := FPColorToTColor(ToTFPColor(colbrColor));
end;

function AndroidToLCLFontSize(asize: DWord; Default: Integer): Integer; inline;
begin
  case asize of
  0: Result := Default;
  1: Result := 1;
  else Result := asize * 3 div 4;
  end;
end;

function BlendColors(c: TColor; alpha: Double; r, g, b: Byte): TColor; inline;
var
  r1, g1, b1: Byte;
begin
  RedGreenBlue(ColorToRGB(c), r1, g1, b1);
  Result := RGBToColor(Byte(Trunc(r1 * alpha + r * (1 - alpha))),
                       Byte(Trunc(g1 * alpha + g * (1 - alpha))),
                       Byte(Trunc(b1 * alpha + b * (1 - alpha))));
end;

procedure SetupFont(Font: TFont; FontSize, DefaultSize: Integer; FontFace: TTextTypeFace);
begin
  Font.Size := AndroidToLCLFontSize(FontSize, DefaultSize);
  case FontFace of
    tfNormal: Font.Style := [];
    tfBold: Font.Style := [fsBold];
    tfItalic: Font.Style := [fsItalic];
    tfBoldItalic: Font.Style := [fsBold, fsItalic];
  end;
end;

procedure RegisterAndroidWidgetDraftClass(AWidgetClass: jVisualControlClass;
  ADraftClass: TDraftWidgetClass);
begin
  DraftClassesMap.Add(AWidgetClass, ADraftClass);
end;

{ TImageIdentifierPropertyEditor }

function TImageIdentifierPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paRevertable];
end;

procedure TImageIdentifierPropertyEditor.GetValues(Proc: TGetStrProc);
var
  o: TPersistent;
  d: TAndroidWidgetMediator;
  imgs, files: TStringList;
  i, j: Integer;
begin
  Proc('');

  o := GetComponent(0);

  if not (o is TComponent) then
     Exit;

  if not (o is TAndroidForm)  then  //so we can use for "jForm" BackgrounImageIdentifier property
  begin
    o := TComponent(o).Owner;
    if not (o is TAndroidForm) then
      Exit;
  end;

  d := TAndroidForm(o).Designer as TAndroidWidgetMediator;

  imgs := TStringList.Create;
  try
    imgs.Sorted := True;
    imgs.Duplicates := dupIgnore;
    files := TStringList.Create;
    try
      for i := Low(DrawableSearchPaths) to High(DrawableSearchPaths) do
      begin
        files.Clear;
        FindAllFiles(files, d.ResDir + PathDelim + DrawableSearchPaths[i], '*.png;*.jpg', False);
        for j := 0 to files.Count - 1 do
          imgs.Add(ExtractFileNameOnly(files[j]));
      end;
    finally
      files.Free;
    end;
    for i := 0 to imgs.Count - 1 do
      Proc(imgs[i]);
  finally
    imgs.Free;
  end;
end;

{ TDraftDrawableWidget }

constructor TDraftDrawableWidget.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
var
  fname: string;
begin
  inherited Create(AWidget, Canvas);
  if Designer.AndroidTheme <> nil then
  begin
    fname := Designer.AndroidTheme.FindDrawable([BaseStyle, DrawableDest], DrawableAttribs);
    if fname <> '' then
      Drawable := Designer.ImageCache.GetImageAsPNG(fname);
  end;
end;

{ TjCustomDialogComponentEditor }

function TjCustomDialogComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TjCustomDialogComponentEditor.GetVerb(Index: Integer): string;
begin
  with ((Component.Owner as TAndroidForm).Designer as TAndroidWidgetMediator) do
    if ComponentIsIcon(Self.Component) then
      Result := 'Show custom dialog'
    else
      Result := 'Hide custom dialog';
end;

procedure TjCustomDialogComponentEditor.ExecuteVerb(Index: Integer);
var
  i, maxH: Integer;
begin
  with ((Component.Owner as TAndroidForm).Designer as TAndroidWidgetMediator) do
  begin
    i := FShownCustomDialogs.IndexOf(Component);
    if i >= 0 then
    begin
      FShownCustomDialogs.Delete(i);
      TAndroidWidget(Component).Left := LeftFromDesignInfo(Component.DesignInfo);
      TAndroidWidget(Component).Top := TopFromDesignInfo(Component.DesignInfo);
    end else begin
      FShownCustomDialogs.Add(Component);
      with TAndroidWidget(Component) do
      begin
        Left := 5;
        Width := TAndroidForm(Owner).Width - 10;
        jVisualControl(Component).LayoutParamWidth:= lpMatchParent; //jmpessoa
        maxH := 100;
        for i := 0 to ChildCount - 1 do
          with Children[i] do
            if maxH < Top + Height + MarginBottom then
              maxH := Top + Height + MarginBottom;
        Height := maxH;
        Top := (TAndroidForm(Owner).Height - maxH) div 2;
        if Top < 0 then Top := 0;
      end;
    end;
  end;
end;

{ TImageListPropertyEditor }

procedure TImageListPropertyEditor.GetValues(Proc: TGetStrProc);

  procedure TraverseComponents(Root: TComponent);
  var
    i: Integer;
  begin
    for i := 0 to Root.ComponentCount - 1 do
      if Root.Components[i] is jImageList then // in general "is GetTypeData(GetPropType)^.ClassType"
        Proc(Root.Components[i].Name);
  end;

begin
  Proc(oisNone);
  if Assigned(PropertyHook) and (PropertyHook.LookupRoot is TComponent) then
    TraverseComponents(TComponent(PropertyHook.LookupRoot));
end;

{ TImageIndexPropertyEditor }

function TImageIndexPropertyEditor.GetImageList: jImageList;
var
  Persistent: TPersistent;
  Component: jVisualControl;
  PropInfo: PPropInfo;
  Obj: TObject;
begin
  Result := nil;
  Persistent := GetComponent(0);
  if not (Persistent is jControl) then
    Exit;

  Component := jVisualControl(Persistent);
  PropInfo := TypInfo.GetPropInfo(Component, 'Images');
  if PropInfo = nil then
    Exit;

  Obj := GetObjectProp(Component, PropInfo);
  if Obj is jImageList then
    Exit(jImageList(Obj));
end;

procedure TImageIndexPropertyEditor.GetAssets;
var
  o: TPersistent;
  d: TAndroidWidgetMediator;
begin
  o := GetComponent(0);
  if not (o is TComponent) then
    Exit;
  o := TComponent(o).Owner;
  if not (o is TAndroidForm) then
    Exit;
  d := TAndroidForm(o).Designer as TAndroidWidgetMediator;
  FAssetsDir := d.AssetsDir;
  FImageCache := d.ImageCache;
end;

procedure TImageIndexPropertyEditor.Activate;
begin
  inherited Activate;
  GetAssets;
  FImages := GetImageList;
end;

function TImageIndexPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paCustomDrawn, paRevertable];
end;

procedure TImageIndexPropertyEditor.GetValues(Proc: TGetStrProc);
var
  i: Integer;
begin
  if GetDefaultOrdValue <> NoDefaultValue then
    Proc(IntToStr(GetDefaultOrdValue));
  if Assigned(FImages) then
    for i := 0 to FImages.Count - 1 do
      Proc(IntToStr(i) + ' (' + FImages.Images[i] + ')');
end;

procedure TImageIndexPropertyEditor.SetValue(const NewValue: ansistring);
var
  Value: string;
  i: Integer;
begin
  Value := NewValue;
  i := Pos(' ', Value);
  if i > 0 then
    SetLength(Value, i - 1);
  inherited SetValue(Value);
end;

procedure TImageIndexPropertyEditor.ListDrawValue(const CurValue: ansistring;
  Index: integer; ACanvas: TCanvas; const ARect: TRect;
  AState: TPropEditDrawState);
var
  R: TRect;
  OldColor: TColor;
  bmp: TBitmap;
  x: Integer;
begin
  if GetDefaultOrdValue <> NoDefaultValue then
    Dec(Index);
  R := ARect;
  x := R.Bottom - R.Top - 2;
  if (pedsInComboList in AState) and not (pedsInEdit in AState) then
  begin
    OldColor := ACanvas.Brush.Color;
    if pedsSelected in AState then
      ACanvas.Brush.Color := clHighlight
    else
      ACanvas.Brush.Color := clWhite;
    ACanvas.FillRect(R);
    ACanvas.Brush.Color := OldColor;
  end;
  if Assigned(FImages) and Assigned(FImageCache)
  and (Index >= 0) and (Index < FImages.Images.Count) then
  begin
    bmp := FImageCache.GetImageAsBMP(FAssetsDir + FImages.Images[Index]);
    ACanvas.StretchDraw(Rect(R.Left+1, R.Top+1, R.Left+x+1, R.Top+x+1), bmp);
  end;
  R.Left := R.Left + x + 3;
  inherited ListDrawValue(CurValue, Index, ACanvas, R, AState);
end;

{ TjImageListEditor }

procedure TjImageListEditor.Edit;
var
  o: TComponent;
  d: TAndroidWidgetMediator;
  fn: string;
  TheDialog: TjImagesEditorDlg;
begin
  try
    o := TComponent(GetComponent).Owner;
    if not (o is TAndroidForm) then
      raise Exception.CreateFmt('%s owner is not TAndroidForm', [TComponent(GetComponent).Name]);
    d := TAndroidForm(o).Designer as TAndroidWidgetMediator;
    fn := d.AssetsDir;
    TheDialog := TjImagesEditorDlg.Create(Application, jImageList(GetComponent).Images,
      fn, d.ImageCache);
    try
      if TheDialog.ShowModal = mrOK then
      begin
        jImageList(GetComponent).Images.Assign(TheDialog.ImageList);
        Modified;
      end;
    finally
      TheDialog.Free;
    end;
  except
    on e: Exception do
      MessageDlg(e.Message, mtError, [mbOK], 0)
  end;
end;

procedure TjImageListEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TjImageListEditor.GetVerb(Index: Integer): string;
begin
  Result := 'jImages Editor...';
end;

function TjImageListEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TjImageListImagesEditor }

procedure TjImageListImagesEditor.Edit;
var
  o: TComponent;
  d: TAndroidWidgetMediator;
  pr: TLazProjectFile;
  fn: string;
  TheDialog: TjImagesEditorDlg;
begin
  try
    o := TComponent(GetComponent(0)).Owner;
    if not (o is TAndroidForm) then
      raise Exception.CreateFmt('%s owner is not TAndroidForm', [TComponent(GetComponent(0)).Name]);
    d := TAndroidForm(o).Designer as TAndroidWidgetMediator;
    pr := LazarusIDE.GetProjectFileWithRootComponent(o);
    if pr = nil then
      raise Exception.CreateFmt('Project file for %s is not available!', [o.Name]);
    if not (pr.GetFileOwner is TLazProject) then
      raise Exception.Create('!!! ' + pr.GetFileOwner.ClassName);
    fn := ExtractFilePath(TLazProject(pr.GetFileOwner).MainFile.GetFullFilename);
    fn := Copy(fn, 1, RPosEx(PathDelim, fn, Length(fn) - 1)) + 'assets' + PathDelim;
    TheDialog := TjImagesEditorDlg.Create(Application, TStrings(GetObjectValue),
      fn, d.ImageCache);
    try
      if TheDialog.ShowModal = mrOK then
        SetPtrValue(TheDialog.ImageList);
    finally
      TheDialog.Free;
    end;
  except
    on e: Exception do
      MessageDlg(e.Message, mtError, [mbOK], 0)
  end;
end;

function TjImageListImagesEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ TAndroidFormSizePropertyEditor }

procedure TAndroidFormSizePropertyEditor.Edit;
begin
  with TAndroidFormComponentEditor.Create(GetComponent(0) as TComponent, nil) do
  try
    ShowSelectSizeDialog
  finally
    Free
  end;
end;

function TAndroidFormSizePropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TAndroidFormComponentEditor }

procedure TAndroidFormComponentEditor.ChangeSize(AWidth, AHeight: Integer);
begin
  with jForm(Component) do
  begin
    if Assigned(Designer) then
      with Designer as TAndroidWidgetMediator, LCLForm do
        SetBounds(Left, Top, AWidth, AHeight);
    SetBounds(Left, Top, AWidth, AHeight);
  end;
end;

procedure TAndroidFormComponentEditor.ShowSelectSizeDialog;
begin
  with TfrmFormSizeSelect.Create(nil) do
  try
    with jForm(Component) do
      SetInitSize(Width, Height);
    if ShowModal = mrOk then
      ChangeSize(seWidth.Value, seHeight.Value);
  finally
    Free
  end;
end;

procedure TAndroidFormComponentEditor.ExecuteVerb(Index: Integer);
var
  pr: TLazProjectFile;
begin
  case Index of
  0: // Rotate
    with jForm(Component) do
      ChangeSize(Height, Width);
  1: ShowSelectSizeDialog; // Select size
  2: begin
       pr := LazarusIDE.GetProjectFileWithRootComponent(Component);
       if pr <> nil then
         pr.CustomData['DisableLayout'] :=
           BoolToStr(not SameText(pr.CustomData['DisableLayout'], 'True'),
                     'True', 'False');
     end;
  else
    inherited ExecuteVerb(Index);
  end;
end;

function TAndroidFormComponentEditor.GetVerb(Index: Integer): string;
var
  pr: TLazProjectFile;
begin
  case Index of
  0: Result := 'Rotate';
  1: Result := 'Select size...';
  2: begin
       pr := LazarusIDE.GetProjectFileWithRootComponent(Component);
       if pr = nil then
         Result := '[--------------]'
       else
       if not SameText(pr.CustomData['DisableLayout'], 'True') then
         Result := 'Disable design-time layout'
       else
         Result := 'Enable design-time layout';
     end;
  else
    Result := inherited;
  end
end;

function TAndroidFormComponentEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;

{ TAnchorPropertyEditor }

procedure TAnchorPropertyEditor.GetValues(Proc: TGetStrProc);
var
  i, j: Integer;
  p: TAndroidWidget;
  sl: TStringList;
begin
  Proc(oisNone);
  p := jVisualControl(GetComponent(0)).Parent;
  for i := 1 to PropCount - 1 do
    if jVisualControl(GetComponent(i)).Parent <> p then
      Exit;
  sl := TStringList.Create;
  try
    for i := 0 to p.ChildCount - 1 do
      if not (p.Children[i] is jCustomDialog) then
        sl.Add(p.Children[i].Name);
    sl.Sorted := True;
    for i := 0 to PropCount - 1 do
    begin
      j := sl.IndexOf(TComponent(GetComponent(i)).Name);
      if j >= 0 then sl.Delete(j);
    end;
    for i := 0 to sl.Count - 1 do
      Proc(sl[i]);
  finally
    sl.Free;
  end;
end;

{ TDraftPanel }

procedure TDraftPanel.Draw;
begin
  with Fcanvas do
  begin
    if jPanel(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jPanel(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;


{ TDraftCaptionPanel }  //experimental!

procedure TDraftCaptionPanel.Draw;
begin
  with Fcanvas do
  begin
    if jCaptionPanel(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jCaptionPanel(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftToolbar }

procedure TDraftToolbar.Draw;
begin
  with Fcanvas do
  begin
    if jToolbar(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jToolbar(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftFrameLayout }

procedure TDraftFrameLayout.Draw;
begin
  with Fcanvas do
  begin
    if jFrameLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jFrameLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

 { TDraftZBarcodeScannerView }

procedure TDraftZBarcodeScannerView.Draw;
begin
  with Fcanvas do
  begin
    if jZBarcodeScannerView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jZBarcodeScannerView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSBottomNavigationView }

procedure TDraftSBottomNavigationView.Draw;
begin
  with Fcanvas do
  begin
    if jsBottomNavigationView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsBottomNavigationView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSCoordinatorLayout }

procedure TDraftSCoordinatorLayout.Draw;
begin
  with Fcanvas do
  begin
    if jsCoordinatorLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsCoordinatorLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSToolbar }

function TDraftSToolbar.GetImageLogo: TPortableNetworkGraphic;
begin
  if FImageLogo <> nil then
    Result := FImageLogo
  else
    with jsToolbar(FAndroidWidget) do
    begin
      if LogoIconIdentifier <> '' then
      begin
        FImageLogo := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(LogoIconIdentifier));
        Result := FImageLogo;
      end else
      Result := nil;
    end;
end;

function TDraftSToolbar.GetImageNavigation: TPortableNetworkGraphic;
begin
  if FImageNavigation <> nil then
    Result := FImageNavigation
  else
    with jsToolbar(FAndroidWidget) do
    begin
      if NavigationIconIdentifier <> '' then
      begin
        FImageNavigation := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(NavigationIconIdentifier));
        Result := FImageNavigation;
      end else
      Result := nil;
    end;
end;

constructor TDraftSToolbar.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := '';  //'autoTextViewStyle';
  inherited;
  Color := jsToolbar(AWidget).BackgroundColor;
  FontColor := jsToolbar(AWidget).FontColor;

  {
   if jsToolBar(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
  }
end;

procedure TDraftSToolbar.Draw;
var
  r: TRect;
begin

  with Fcanvas do
  begin

    if jsToolbar(FAndroidWidget).BackgroundColor <> colbrDefault then
    begin
      Brush.Color := ToTColor(jsToolbar(FAndroidWidget).BackgroundColor)
    end
    else
    begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;

    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
    TextOut(80, 9, FAndroidWidget.Text); //12, 9,

    if GetImageNavigation <> nil then
    begin
      r := Rect(0, 0, 32, 32);
      StretchDraw(r, GetImageNavigation);
      //Draw(0, 0, GetImageNavigation);
    end;


    if GetImageLogo <> nil then
    begin
      r := Rect(48, 0, 80, 32);  //ALeft, ATop, ARight, ABottom
      StretchDraw(r, GetImageLogo);
      //Draw(0, 0, GetImageLogo);
    end;

  end;

end;

procedure TDraftSToolbar.UpdateLayout;
begin
  inherited UpdateLayout;
end;

{ TDraftSNavigationView }

procedure TDraftSNavigationView.Draw;
begin
  with Fcanvas do
  begin
    if jsNavigationView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsNavigationView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSDrawerLayout }

procedure TDraftSDrawerLayout.Draw;
begin
  with Fcanvas do
  begin
    if jsDrawerLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsDrawerLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftLinearLayout }

procedure TDraftLinearLayout.Draw;
begin
  with Fcanvas do
  begin
    if jLinearLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jLinearLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftTableLayout }

procedure TDraftTableLayout.Draw;
begin
  with Fcanvas do
  begin
    if jTableLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jTableLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftCalendarView }

procedure TDraftCalendarView.Draw;
begin
  with Fcanvas do
  begin
    if jCalendarView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jCalendarView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

  { TDraftSAdMob }
procedure TDraftSAdMob.Draw;
begin
  with Fcanvas do
  begin
    if jsAdMob(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsAdMob(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSCardView }

procedure TDraftSCardView.Draw;
begin
  with Fcanvas do
  begin
    if jsCardView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsCardView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSRecyclerView }

procedure TDraftSRecyclerView.Draw;
begin
  with Fcanvas do
  begin
    if jsRecyclerView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsRecyclerView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSViewPager }

procedure TDraftSViewPager.Draw;
begin
  with Fcanvas do
  begin
    if jsViewPager(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsViewPager(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSCollapsingToolbarLayout }

procedure TDraftSCollapsingToolbarLayout.Draw;
begin
  with Fcanvas do
  begin
    if jsCollapsingToolbarLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsCollapsingToolbarLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSTabLayout }

procedure TDraftSTabLayout.Draw;
begin
  with Fcanvas do
  begin
    if jsTabLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsTabLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftSAppBarLayout }

procedure TDraftSAppBarLayout.Draw;
begin
  with Fcanvas do
  begin
    if jsAppBarLayout(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsAppBarLayout(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

procedure TDraftSNestedScrollView.Draw;
begin
  with Fcanvas do
  begin
    if jsNestedScrollView(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := ToTColor(jsNestedScrollView(FAndroidWidget).BackgroundColor)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

{ TDraftControlHash }

function TDraftControlHash.Hash1(c: TClass): PtrUInt;
begin
  Result := ({%H-}PtrUInt(c) + {%H-}PtrUInt(c) shr 7) mod PtrUInt(Length(FItems));
end;

function TDraftControlHash.Hash2(i: PtrUInt): PtrUInt;
begin
  Result := (i + 7) mod PtrUInt(Length(FItems));
end;

constructor TDraftControlHash.Create(MaxCapacity: Integer);
begin
  SetLength(FItems, MaxCapacity);
  FFreeLeft := MaxCapacity;
end;

procedure TDraftControlHash.Add(VisualControlClass: jVisualControlClass;
  DraftWidgetClass: TDraftWidgetClass);
var
  i: PtrUInt;
begin
  if FFreeLeft = 0 then
    raise Exception.Create('[DraftControlHash] Overfull!');
  i := Hash1(VisualControlClass);
  while FItems[i].VisualControl <> nil do
    i := Hash2(i);
  with FItems[i] do
  begin
    VisualControl := VisualControlClass;
    Draft := DraftWidgetClass;
  end;
  Dec(FFreeLeft);
end;

function TDraftControlHash.Find(VisualControlClass: TClass): TDraftWidgetClass;  //??
var i: PtrUInt;
begin
  Result := nil;
  i := Hash1(VisualControlClass);
  if FItems[i].VisualControl = nil then Exit;
  while FItems[i].VisualControl <> VisualControlClass do
  begin
    i := Hash2(i);
    if FItems[i].VisualControl = nil then Exit;
  end;
  Result := FItems[i].Draft;
end;

{ TARGBColorBridgePropertyEditor }

procedure TARGBColorBridgePropertyEditor.Edit;
var
  r1, g1, b1, r2, g2, b2: Byte;
  i, nearest: TARGBColorBridge;
  d, diff: Integer;
begin
  with TColorDialog.Create(nil) do
  try
    Color := ToTColor(TARGBColorBridge(GetOrdValue));
    if Execute then
    begin
      RedGreenBlue(Color, r1, g1, b1);
      i := Low(TARGBColorBridge);
      RedGreenBlue(ToTColor(i), r2, g2, b2);
      diff := Sqr(r1 - r2) + Sqr(g1 - g2) + Sqr(b1 - b2);
      nearest := i;
      if diff > 0 then
        for i := Succ(i) to High(TARGBColorBridge) do
        begin
          RedGreenBlue(ToTColor(i), r2, g2, b2);
          d := Sqr(r1 - r2) + Sqr(g1 - g2) + Sqr(b1 - b2);
          if diff > d then
          begin
            diff := d;
            nearest := i;
            if diff = 0 then Break;
          end;
        end;
      SetOrdValue(Ord(nearest));
    end;
  finally
    Free;
  end;
end;

function TARGBColorBridgePropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect,paValueList,paCustomDrawn,paDialog];
end;

procedure TARGBColorBridgePropertyEditor.ListDrawValue(const CurValue: ansistring;
  Index: integer; ACanvas: TCanvas; const ARect: TRect;
  AState: TPropEditDrawState);
var
  h: Integer;
  r: TRect;
  bc: TColor;
begin
  h := ARect.Bottom - ARect.Top;
  with ACanvas do
  begin
    FillRect(ARect);
    bc := Pen.Color;
    Pen.Color := clBlack;
    r := ARect;
    r.Right := r.Left + h;
    InflateRect(r, -2, -2);
    Rectangle(r);
    if (TARGBColorBridge(Index) in [colbrDefault, colbrCustom]) then
    begin
      InflateRect(r, -1, -1);
      MoveTo(r.Left, r.Top); LineTo(r.Right, r.Bottom);
      MoveTo(r.Right - 1, r.Top); LineTo(r.Left - 1, r.Bottom);
      Pen.Color := bc;
    end else begin
      Pen.Color := bc;
      bc := Brush.Color;
      Brush.Color := ToTColor(TARGBColorBridge(Index));
      InflateRect(r, -1, -1);
      FillRect(r);
      Brush.Color := bc;
    end;
  end;
  r := ARect;
  r.Left := r.Left + h + 2;
  inherited ListDrawValue(CurValue, Index, ACanvas, r, AState);
end;

procedure TARGBColorBridgePropertyEditor.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; AState: TPropEditDrawState);
var
  s: string;
  i: Integer;
begin
  s := GetVisualValue;
  for i := 0 to Ord(High(TARGBColorBridge)) do
    if GetEnumName(TypeInfo(TARGBColorBridge), i) = s then
    begin
      ListDrawValue(s, i, ACanvas, ARect, [pedsInEdit]);
      Exit;
    end;
end;

{ TAndroidWidgetMediator }

constructor TAndroidWidgetMediator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDefaultBrushColor := clWhite;
  FDefaultPenColor := clMedGray;
  FDefaultFontColor := clBlack;

  GlobalDesignHook.AddHandlerModified(@OnDesignerModified);
  GlobalDesignHook.AddHandlerPersistentAdded(@OnPersistentAdded);
  GlobalDesignHook.AddHandlerPersistentDeleted(@OnPersistentDeleted);
  GlobalDesignHook.AddHandlerPersistentDeleting(@OnPersistentDeleting);
  GlobalDesignHook.AddHandlerSetSelection(@OnSetSelection);

  FStarted := TFPList.Create;
  FDone := TFPList.Create;
  FCustomDialogs := TFPList.Create;
  FShownCustomDialogs := TFPList.Create;
  FSelection := TFPList.Create;
  FImageCache := TImageCache.Create;

end;

destructor TAndroidWidgetMediator.Destroy;
begin

  if GlobalDesignHook <> nil then
  begin
    //GlobalDesignHook.RemoveAllHandlersForObject(Self);
    GlobalDesignHook.RemoveHandlerModified(@OnDesignerModified);
    GlobalDesignHook.RemoveHandlerPersistentAdded(@OnPersistentAdded);
    GlobalDesignHook.RemoveHandlerPersistentDeleted(@OnPersistentDeleted);
    GlobalDesignHook.RemoveHandlerPersistentDeleting(@OnPersistentDeleting);
    GlobalDesignHook.RemoveHandlerSetSelection(@OnSetSelection);
  end;

  if LazarusIDE <> nil then
    LazarusIDE.RemoveAllHandlersOfObject(Self);

  if Assigned(AndroidForm) then AndroidForm.Designer := nil;

  FImageCache.Free;
  FStarted.Free;
  FDone.Free;
  FSelection.Free;
  FCustomDialogs.Free;
  FShownCustomDialogs.Free;

  inherited Destroy;
end;

//procedure TAndroidWidgetMediator.OnDesignerModified(Sender: TObject);
procedure TAndroidWidgetMediator.OnDesignerModified(Sender: TObject{$If lcl_fullversion=1070000}; {%H-}PropName: ShortString{$ENDIF});
var
  Instance: TPersistent;
  InvalidateNeeded: Boolean;
  i: Integer;
begin
  if not (Sender is TPropertyEditor) or (LCLForm = nil) then Exit;
  InvalidateNeeded := False;
  for i := 0 to TPropertyEditor(Sender).PropCount - 1 do
  begin
    Instance := TPropertyEditor(Sender).GetComponent(i);
    if (Instance = AndroidForm) and (AndroidForm.ActivityMode in [actMain, actSplash]) and FProjFile.IsPartOfProject then
    begin

      FSplashExists:= False;           //try Dio Affriza suggestion!
      if AndroidForm.ActivityMode = actSplash then
      begin
        FSplashExists:= True;
        LamwSmartDesigner.UpdateProjectStartModule(AndroidForm.Name, AndroidForm.ModuleType)
      end;

      if not FSplashExists then
        LamwSmartDesigner.UpdateProjectStartModule(AndroidForm.Name, AndroidForm.ModuleType);

    end;

    if (Instance = AndroidForm) or (Instance is jVisualControl)
    and (jVisualControl(Instance).Owner = AndroidForm) then
    begin
      InvalidateNeeded := True;
      Break;
    end;
  end;
  if InvalidateNeeded then
    LCLForm.Invalidate;
end;

procedure TAndroidWidgetMediator.OnPersistentAdded(APersistent: TPersistent; {%H-}Select: boolean);
begin
  if (APersistent is jVisualControl)
  and (jVisualControl(APersistent).Parent = nil)
  and (jVisualControl(APersistent).Owner = AndroidForm)
  then
    if Assigned(FLastSelectedContainer) then
      jVisualControl(APersistent).Parent := FLastSelectedContainer
    else
      jVisualControl(APersistent).Parent := AndroidForm;

  //smart designer helpers
  if (APersistent is jControl) and (jControl(APersistent).Owner = AndroidForm) then
      UpdateJControlsList
  else UpdateFCLControlsList;

end;

procedure TAndroidWidgetMediator.OnSetSelection(const ASelection: TPersistentSelectionList);
var
  i: Integer;
begin
  FLastSelectedContainer := nil;
  if (ASelection.Count = 1) and (ASelection[0] is jVisualControl) then
    with jVisualControl(ASelection[0]) do
      if (Owner = AndroidForm) and AcceptChildrenAtDesignTime then
        FLastSelectedContainer := jVisualControl(ASelection[0]);

  FSelection.Clear;
  for i := 0 to ASelection.Count - 1 do
    FSelection.Add(ASelection[i]);
end;

(*
procedure TAndroidWidgetMediator.OnAutoAssignIDs(Sender: TObject);
begin
  if (Sender is TAndroidForm) and TAndroidForm(Sender).AutoAssignIDs then
    if QuestionDlg('LAMW', 'Reassign Id properties now (otherwise they will be reassigned on next form open)?', mtConfirmation, [mrYes, mrNo], 0) = mrYes then
      TAndroidForm(Sender).ReassignIds;
end;
*)

procedure TAndroidWidgetMediator.SetRoot(const AValue: TComponent);
begin
  inherited SetRoot(AValue);
  (*if AValue is jForm then
    jForm(AValue).OnAutoAssignIDs := @OnAutoAssignIDs;*)
end;

function TAndroidWidgetMediator.GetAndroidForm: TAndroidForm; //jForm;
begin
   Result := TAndroidForm(Root); //jForms
end;

procedure TAndroidWidgetMediator.InitSmartDesignerHelpers;
begin
  if (FProjFile<>nil) and FProjFile.IsPartOfProject
      and not FProjFile.CustomData.Contains('jControls') then
        UpdateJControlsList;
end;

procedure TAndroidWidgetMediator.OnPersistentDeleting(APersistent: TPersistent);
begin
  FjControlDeleted := (APersistent is jControl)
    and (Root <> nil) and (TComponent(APersistent).Owner = Root);

  if FjControlDeleted then
    FShownCustomDialogs.Remove(APersistent)
  else UpdateFCLControlsList;
end;

procedure TAndroidWidgetMediator.UpdateJControlsList;
begin
  LamwSmartDesigner.UpdateJControls(FProjFile, AndroidForm);
end;

procedure TAndroidWidgetMediator.UpdateFCLControlsList;
begin
  LamwSmartDesigner.UpdateFCLControls(FProjFile, AndroidForm);
end;

class function TAndroidWidgetMediator.CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator;
var
  Mediator: TAndroidWidgetMediator;
  i: Integer;
begin
  Result := inherited CreateMediator(TheOwner, nil);

  Mediator := TAndroidWidgetMediator(Result);

  Mediator.Root := TheForm;
  Mediator.AndroidForm.Designer:= Mediator;

  Mediator.UpdateTheme;
  Mediator.FProjFile := LazarusIDE.GetProjectFileWithRootComponent(TheForm);
  Mediator.InitSmartDesignerHelpers;

  for i := 0 to TheForm.ComponentCount - 1 do
    if TheForm.Components[i] is jCustomDialog then
      with jCustomDialog(TheForm.Components[i]) do
        DesignInfo := LeftTopToDesignInfo(Left, Top);

end;

class function TAndroidWidgetMediator.FormClass: TComponentClass;
begin
  Result := TAndroidForm;
end;

procedure TAndroidWidgetMediator.GetBounds(AComponent: TComponent; out CurBounds: TRect);
var
  w: TAndroidWidget;
begin
  if AComponent is TAndroidWidget then
  begin
    w := TAndroidWidget(AComponent);
    if ComponentIsIcon(AComponent) then
      CurBounds := Bounds(LeftFromDesignInfo(w.DesignInfo),
                          TopFromDesignInfo(w.DesignInfo), 28, 28)
    else
      CurBounds := Bounds(w.Left, w.Top, w.Width, w.Height);
  end else inherited GetBounds(AComponent,CurBounds);
end;

// procedure TAndroidWidgetMediator.OnPersistentDeleted(APersistent: TPersistent);
procedure TAndroidWidgetMediator.OnPersistentDeleted({$IF LCL_FULLVERSION >= 2010000}APersistent: TPersistent{$endif});
begin
  if FjControlDeleted then
    UpdateJControlsList;
end;

procedure TAndroidWidgetMediator.InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
begin
  if (LCLForm=nil) or (not LCLForm.HandleAllocated) then exit;
  LCLIntf.InvalidateRect(LCLForm.Handle,@ARect,Erase);
end;

function TAndroidWidgetMediator.RootDir: string;
begin
  if FProjFile = nil then
    raise Exception.CreateFmt('Project file for %s is not available!', [Root.Name]);
  Result := ExtractFilePath(TLazProject(FProjFile.GetFileOwner).MainFile.GetFullFilename);
  Result := Copy(Result, 1, RPosEx(PathDelim, Result, Length(Result) - 1));
end;

function TAndroidWidgetMediator.AssetsDir: string;
begin
  Result := RootDir + 'assets' + PathDelim;
end;

function TAndroidWidgetMediator.ResDir: string;
begin
  Result := RootDir + 'res' + PathDelim;
end;

function TAndroidWidgetMediator.FindDrawable(AResourceName: string): string;
const
  ResExts: array [0..1] of string = ('.png', '.jpg');
var
  AResDir: string;
  i, j: Integer;
begin
  AResDir := ResDir;
  for i := Low(DrawableSearchPaths) to High(DrawableSearchPaths) do
    for j := Low(ResExts) to High(ResExts) do
    begin
      Result := AResDir + DrawableSearchPaths[i] + PathDelim
        + AResourceName + ResExts[j];
      if FileExists(Result) then Exit;
    end;
  Result := '';
end;

procedure TAndroidWidgetMediator.GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer);
begin
  if (APersistent is TAndroidWidget) and (TAndroidWidget(APersistent).AcceptChildrenAtDesignTime) then
    AIndex:= FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexBox
  else if (APersistent is TAndroidWidget) then
    AIndex:= FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexControl
  else
    inherited GetObjInspNodeImageIndex(APersistent, AIndex);
end;

procedure TAndroidWidgetMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  if AComponent is TAndroidWidget then
  begin
    TAndroidWidget(AComponent).SetBounds(NewBounds.Left,NewBounds.Top,
      NewBounds.Right-NewBounds.Left,NewBounds.Bottom-NewBounds.Top);
    if ComponentIsIcon(AComponent) then
      with TAndroidWidget(AComponent) do
        DesignInfo := LeftTopToDesignInfo(NewBounds.Left, NewBounds.Top);
  end else inherited SetBounds(AComponent,NewBounds);
end;

procedure TAndroidWidgetMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
var
  Widget: TAndroidWidget;
begin
  if (AComponent is TAndroidWidget) and not ComponentIsIcon(AComponent) then
  begin
    Widget:=TAndroidWidget(AComponent);
    CurClientArea:=Rect(0, 0, Widget.Width, Widget.Height);
    ScrollOffset:=Point(0, 0);
  end
  else inherited GetClientArea(AComponent, CurClientArea, ScrollOffset);
end;

procedure TAndroidWidgetMediator.InitComponent(AComponent, NewParent: TComponent; NewBounds: TRect);
var
  newName: string;
  i: Integer;
  oldName: string;
begin
  if AComponent <> AndroidForm then // to preserve jForm size
  begin
    if Acomponent is jControl then
    begin
      //if AComponent.Name.StartsWith(AComponent.ClassName) then
      if string(AComponent.Name).StartsWith(AComponent.ClassName) then
      begin
          if (AComponent.Name[1] = 'j') or (AComponent.Name[1] = 'J') or (AComponent.Name[1] = 'K') then
          begin
              newName := AComponent.ClassName;
              Delete(newName, 1, 1); // drop j

              //for jc or js  prefix
              if (newName[1] = 'c') or  (newName[1] = 's') then
              begin
                 Delete(newName, 1, 1); //drop c or s
              end;

              i := 1;

              //begin legacy
              oldName:=  AComponent.ClassName;
              while (Root.FindComponent(oldName + IntToStr(i)) <> nil)  do
              begin
                 Inc(i);
              end;
              //end legacy

              if i > 1 then i := i - 1;
              while (Root.FindComponent(newName + IntToStr(i)) <> nil)  do
              begin
                 Inc(i);
              end;
              AComponent.Name := newName + IntToStr(i);
          end;
      end;
    end; //jControl

    if AComponent is TAndroidWidget then
    begin
      with NewBounds do
      begin
        if (Right - Left = 50) and (Bottom - Top = 50) then // ugly check, but IDE makes 50x50 default size for non TControl
        begin
          // restore default size
          Right := Left + TAndroidWidget(AComponent).Width;
          Bottom := Top + TAndroidWidget(AComponent).Height;
        end;
        inherited InitComponent(AComponent, NewParent, NewBounds);
      end;
    end; //visual control

    if (AComponent is jVisualControl) and Assigned(jVisualControl(AComponent).Parent) then
    begin
      with jVisualControl(AComponent) do
      begin
        if not (LayoutParamWidth in [lpWrapContent, lpExact, lpUseWeight]) then
          LayoutParamWidth := GetDesignerLayoutByWH(Width, Parent.Width);
        if not (LayoutParamHeight in [lpWrapContent, lpExact, lpUseWeight]) then
          LayoutParamHeight := GetDesignerLayoutByWH(Height, Parent.Height);
      end;
    end;

  end; //not AndroidForm

end;

procedure TAndroidWidgetMediator.Paint;
var
  CanUpdateLayout: Boolean;

  procedure PaintWidget(AWidget: TAndroidWidget);
  var
    i: Integer;
    Child: TAndroidWidget;
    fpcolor: TFPColor;
    fWidget: TDraftWidget;
    fWidgetClass: TDraftWidgetClass;
    saveW: integer;
    saveColor: TColor;
    dsgnMediator: TAndroidWidgetMediator;
    fbkImage: TPortableNetworkGraphic;
    strImage: string;
  begin

    if FDone.IndexOf(AWidget) >= 0 then Exit;
    if FStarted.IndexOf(AWidget) >= 0 then
    begin
      jVisualControl(AWidget).Anchor := nil;
      MessageBox(0, 'Circular dependency detected!', '[Lamw] Designer', MB_ICONERROR);
      Abort;
    end;
    FStarted.Add(AWidget);
    with LCLForm.Canvas do begin
      //fill background
      Brush.Style:= bsSolid;
      Brush.Color:= Self.FDefaultBrushColor;
      Pen.Color:= Self.FDefaultPenColor;      //MedGray...
      saveColor:= Pen.Color;
      Font.Color:= Self.FDefaultFontColor;

      if AWidget is jVisualControl then
      begin
        with jVisualControl(AWidget) do
        begin
          if Assigned(Anchor) then
          begin
            RestoreHandleState;
            SaveHandleState;
            MoveWindowOrgEx(Handle, Anchor.Left, Anchor.Top);
            IntersectClipRect(Handle, 0, 0, Anchor.Width, Anchor.Height);
            PaintWidget(Anchor); // needed for update its layout
            RestoreHandleState;
            SaveHandleState;
            MoveWindowOrgEx(Handle, AWidget.Left, AWidget.Top);
          end;
        end;
      end;

      if (AWidget is jForm) then
      begin
        if jForm(AWidget).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor(jForm(AWidget).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
          //Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        end
        else
        begin
          Brush.Color := FDefaultBrushColor;
          GradientFill(Rect(0,0,AWidget.Width,AWidget.Height),
            BlendColors(FDefaultBrushColor, 0.92, 0, 0, 0),
            BlendColors(FDefaultBrushColor, 0.81, 255, 255, 255),gdVertical);
            Pen.Color:= clDkGray;
        end;

        saveW:= Pen.Width;
        Pen.Width:= 10;
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        Pen.Width:= saveW;
        Pen.Color:= saveColor;

        strImage:= jForm(AWidget).BackgroundImageIdentifier;
        if strImage <> '' then
        begin
           dsgnMediator := TAndroidForm(AWidget).Designer as TAndroidWidgetMediator;
           fbkImage:= dsgnMediator.ImageCache.GetImageAsPNG(dsgnMediator.FindDrawable(strImage));
           //StretchDraw(Rect(0,0,AWidget.Width,AWidget.Height), fbkImage);
           Draw(0, 0, fbkImage);
        end;
      end else
      begin  // generic visualcontrol

        fWidgetClass := DraftClassesMap.Find(AWidget.ClassType); //warning! capacty = 128 ... update when needed! --> DraftClassesMap := TDraftControlHash.Create(256)

        if Assigned(fWidgetClass) then
        begin
          fWidget := fWidgetClass.Create(AWidget, LCLForm.Canvas);
          if CanUpdateLayout and (not FSizing or (FSelection.IndexOf(AWidget) < 0)) then
          begin
            fWidget.UpdateLayout;
          end;
          fWidget.Draw;
          fWidget.Free;
        end
        else if (AWidget is jVisualControl) then  // default drawing: rect with Text
        begin
          Brush.Color:= Self.FDefaultBrushColor;
          FillRect(0,0,AWidget.Width,AWidget.Height);
          Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
          //generic
          Font.Color:= clMedGray;
          TextOut(5,4,AWidget.Text);
        end;

      end; //generic visual control

      if AWidget.AcceptChildrenAtDesignTime then
      begin       //inner rect...
        if not (AWidget is jForm) then
        begin
          Pen.Color:= clSilver;
          Frame(2, 2, AWidget.Width - 2, AWidget.Height - 2); // inner frame
        end;
      end;

      // children
      if AWidget.ChildCount>0 then
      begin
        SaveHandleState;
        // clip client area
        if IntersectClipRect(Handle, 0, 0, AWidget.Width, AWidget.Height)<>NullRegion then
        begin
          for i:=0 to AWidget.ChildCount-1 do
          begin
            Child:=AWidget.Children[i];
            if Child is jCustomDialog then
            begin
              if not ComponentIsIcon(Child) then
                FCustomDialogs.Add(Child);
              Continue;
            end;
            SaveHandleState;
            // clip child area
            MoveWindowOrgEx(Handle,Child.Left,Child.Top);
            if IntersectClipRect(Handle,0,0,Child.Width,Child.Height)<>NullRegion then
               PaintWidget(Child);
            RestoreHandleState;
          end;
        end;
        RestoreHandleState;
      end;
    end;
    FStarted.Remove(AWidget);
    FDone.Add(AWidget);
  end;

  procedure PaintCustomDialog(cd: jCustomDialog);
  var
     i: Integer;
    Child: TAndroidWidget;
  begin
    with LCLForm.Canvas do begin
      SaveHandleState;
      if cd.BackgroundColor <> colbrDefault then
        Brush.Color:= FPColorToTColor(ToTFPColor(cd.BackgroundColor))
      else
        Brush.Color:= FDefaultBrushColor;
      MoveWindowOrgEx(Handle,cd.Left,cd.Top);
      IntersectClipRect(Handle, 0, 0, cd.Width, cd.Height);
      Brush.Style := bsSolid;
      Rectangle(0, 0, cd.Width, cd.Height);    // outer frame
      Brush.Style := bsClear;
      Font.Color := clMedGray;
      TextOut(6, 4, cd.Text);
      Pen.Color:= clSilver; //clWhite;
      Frame(4, 4, cd.Width-4, cd.Height-4); // inner frame

      // children
      if cd.ChildCount > 0 then
        for i := 0 to cd.ChildCount - 1 do
        begin
          SaveHandleState;
          Child := cd.Children[i];
          // clip child area
          MoveWindowOrgEx(Handle, Child.Left, Child.Top);
          if IntersectClipRect(Handle, 0, 0, Child.Width, Child.Height) <> NullRegion then
            PaintWidget(Child);
          RestoreHandleState;
        end;
      RestoreHandleState;
    end;
  end;

var
  i: Integer;
begin

  CanUpdateLayout := (FProjFile = nil) or not SameText(FProjFile.CustomData['DisableLayout'], 'True');

  FStarted.Clear;
  FDone.Clear;

  FCustomDialogs.Clear; // jCustomDialogs are drawn after all other components

  PaintWidget(AndroidForm);

  for i := 0 to FCustomDialogs.Count - 1 do
    PaintCustomDialog(jCustomDialog(FCustomDialogs[i]));

  inherited Paint;
end;

function TAndroidWidgetMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result := not (AComponent is TAndroidWidget)
    or (AComponent is jCustomDialog)
       and (FShownCustomDialogs.IndexOf(AComponent) < 0);
end;

function TAndroidWidgetMediator.ComponentIsVisible(AComponent: TComponent): Boolean;
begin
  Result := inherited ComponentIsVisible(AComponent);
  while Result and (AComponent is jVisualControl) do
  begin
    AComponent := jVisualControl(AComponent).Parent;
    if AComponent is jCustomDialog then
      Result := not ComponentIsIcon(AComponent)
  end;
end;

function TAndroidWidgetMediator.ParentAcceptsChild(Parent: TComponent; Child: TComponentClass): boolean;
begin
  Result:=(Parent is TAndroidWidget) and
          (Child.InheritsFrom(TAndroidWidget)) and
          (TAndroidWidget(Parent).AcceptChildrenAtDesignTime);
end;

procedure TAndroidWidgetMediator.UpdateTheme;
var
  proj: TLazProjectFile;
  fn: string;
begin
  try
    proj := LazarusIDE.GetProjectFileWithRootComponent(Root);

    if proj <> nil then
    begin
      if proj.IsPartOfProject then
        fn := LazarusIDE.ActiveProject.MainFile.GetFullFilename
      else
        fn := proj.GetFullFilename;
      if (Pos(PathDelim + 'jni' + PathDelim, fn) = 0)
      and (proj.GetFileOwner is TLazProject) then
      begin // main file is not saved yet => get path of first module
        proj := TLazProject(proj.GetFileOwner).Files[1];
        fn := proj.GetFullFilename;
      end;
      fn := Copy(fn, 1, Pos(PathDelim + 'jni' + PathDelim, fn));
      fn := fn + 'AndroidManifest.xml';
      FTheme := Themes.GetTheme(fn);
      if FTheme <> nil then
      begin
        FDefaultBrushColor := FTheme.GetColorDef('colorBackground', clWhite);
        FDefaultFontColor := FTheme.GetColorDef('textColorPrimary', clBlack);
        if Assigned(LCLForm) then LCLForm.Invalidate;
      end;
    end;
  except
    on e: Exception do
      IDEMessagesWindow.AddCustomMessage(mluError, e.Message);
  end;
end;

procedure TAndroidWidgetMediator.MouseDown(Button: TMouseButton;
  Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
  inherited MouseDown(Button, Shift, p, Handled);
end;

procedure TAndroidWidgetMediator.MouseUp(Button: TMouseButton;
  Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
  inherited MouseUp(Button, Shift, p, Handled);
  FSizing := False;
  LCLForm.Invalidate;
end;

procedure TAndroidWidgetMediator.MouseMove(Shift: TShiftState; p: TPoint;
  var Handled: boolean);
begin
  if ssLeft in Shift then FSizing := True;
  inherited MouseMove(Shift, p, Handled);
end;

{ TDraftWidget }

constructor TDraftWidget.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
var
  x: TLayoutParams;
  y, z, FnewW, FnewH: Integer;
begin
  TextColor:= clNone;
  BackGroundColor:= clNone;
  FAndroidWidget := AWidget;
  FCanvas := Canvas;
  FColor := colbrDefault;

  with jVisualControl(FAndroidWidget) do
  begin
    FLeftTop := Point(-1, -1);
    FRightBottom := Point(-1, -1);
    FMinWidth := 0;
    FMinHeight := 0;
    with Designer do
      if FSizing and (FSelection.IndexOf(AWidget) >= 0)
      and (Parent <> nil) then
      begin
        if not (LayoutParamWidth in [lpWrapContent, lpExact, lpUseWeight]) then
        begin
          FnewW := Width;
          x := GetDesignerLayoutByWH(FnewW, Parent.Width);
          y := GetLayoutParamsByParent2(Parent, x, sdW);
          if LayoutParamWidth = lpMatchParent then
            z := Parent.Width - MarginLeft - FLeftTop.x - MarginRight
          else
            z := GetLayoutParamsByParent2(Parent, LayoutParamWidth, sdW);
          if (z <> FnewW) and (Abs(y - FnewW) < Abs(z - FnewW)) then
            LayoutParamWidth := x;
        end;
        if not (LayoutParamHeight in [lpWrapContent, lpExact, lpUseWeight]) then
        begin
          FnewH := Height;
          x := GetDesignerLayoutByWH(FnewH, Parent.Height);
          y := GetLayoutParamsByParent2(Parent, x, sdH);
          if LayoutParamHeight = lpMatchParent then
            z := Parent.Height - MarginTop - FLeftTop.y - MarginBottom
          else
            z := GetLayoutParamsByParent2(Parent, LayoutParamHeight, sdH);
          if (z <> FnewH) and (Abs(y - FnewH) < Abs(z - FnewH)) then
            LayoutParamHeight := x;
        end;
      end;
  end;

  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
end;


procedure TDraftWidget.Draw;
begin
  with FCanvas do
  begin
    if Color <> colbrDefault then
      Brush.Color := ToTColor(Color)
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
    TextOut(12, 9, FAndroidWidget.Text);
  end;
end;

procedure TDraftWidget.UpdateLayout;
var
  FnewW, FnewH: Integer;
begin
  with jVisualControl(FAndroidWidget) do
  begin
    lpWidth := LayoutParamWidth;
    lpHeight := LayoutParamHeight;
    if Assigned(Parent) then
    begin
      case lpWidth of
        lpExact: ;
        lpMatchParent:
          if Assigned(Parent) then
          begin
            FLeftTop.x := MarginLeft;
            FRightBottom.x := Parent.Width - MarginRight;
          end;
        lpWrapContent:
          if ChildCount > 0 then
          begin
            FnewW := WrapContentWidthByChildren;
            if FMinWidth < FnewW then FMinWidth := FnewW;
          end;
        else begin
          FnewW := GetLayoutParamsByParent2(Parent, lpWidth, sdW);
          if FMinWidth < FnewW then FMinWidth := FnewW;
        end;
      end;
      case lpHeight of
        lpExact: ;
        lpMatchParent:
          if Assigned(Parent) then
          begin
            FLeftTop.y := MarginTop;
            FRightBottom.y := Parent.Height - MarginBottom;
          end;
        lpWrapContent:
          if ChildCount > 0 then
          begin
            FnewH := WrapContentHeightByChildren;
            if FMinHeight < FnewH then FMinHeight := FnewH;
          end;
        else begin
          FnewH := GetLayoutParamsByParent2(Parent, lpHeight, sdH);
          if FMinHeight < FnewH then FMinHeight := FnewH;
        end;
      end;
    end;
    if Anchor <> nil then
    begin
      if raBelow in PosRelativeToAnchor then
        FLeftTop.y := Anchor.Top + Anchor.Height + Anchor.MarginBottom + MarginTop;
      if raAbove in PosRelativeToAnchor then
        FRightBottom.y := Anchor.Top - MarginBottom - Anchor.MarginTop;
      if raToRightOf in PosRelativeToAnchor then
        FLeftTop.x := Anchor.Left + Anchor.Width + Anchor.MarginRight + MarginLeft;
      if raAlignBaseline in PosRelativeToAnchor then
        FLeftTop.y := Anchor.Top + (Anchor.Height - Height) div 2; // hack
      if raAlignLeft in PosRelativeToAnchor then
        FLeftTop.x := Anchor.Left + MarginLeft;
      if raAlignRight in PosRelativeToAnchor then
        FRightBottom.x := Anchor.Left + Anchor.Width - MarginRight;
      if raToEndOf in PosRelativeToAnchor then
        FLeftTop.x := Anchor.Left + Anchor.Width + Anchor.MarginRight + MarginLeft;
      if raAlignTop in PosRelativeToAnchor then
        FLeftTop.y := Anchor.Top + MarginTop;
      if raAlignBottom in PosRelativeToAnchor then
        FRightBottom.y := Anchor.Top + Anchor.Height - MarginBottom;
      if raToLeftOf in PosRelativeToAnchor then
        FRightBottom.x := Anchor.Left - Anchor.MarginLeft - MarginRight;
      { TODO: other combinations raToStartOf, raAlignStart, raAlignEnd }
      if ([raBelow, raAlignBottom] * PosRelativeToAnchor <> [])
      and Assigned(Parent) and (rpBottom in PosRelativeToParent) then
        FRightBottom.y := Parent.Height - MarginBottom;
    end;
    if Assigned(Parent) then
    begin
      if rpRight in PosRelativeToParent then
        FRightBottom.x := Parent.Width - MarginRight;
      if rpLeft in PosRelativeToParent then
        FLeftTop.x := MarginLeft;
      if rpTop in PosRelativeToParent then
        FLeftTop.y := MarginTop;
      if rpBottom in PosRelativeToParent then
        FRightBottom.y := Parent.Height - MarginBottom;
      if rpCenterHorizontal in PosRelativeToParent then
        FLeftTop.x := (Parent.Width - GetNewWidth) div 2;
      if rpCenterVertical in PosRelativeToParent then
        FLeftTop.y := (Parent.Height - GetNewHeight) div 2;
      if rpCenterInParent in PosRelativeToParent then
      begin
        FLeftTop.x := (Parent.Width - GetNewWidth) div 2;
        FLeftTop.y := (Parent.Height - GetNewHeight) div 2;
      end;
      { TODO: rpStart, rpEnd }
    end;
  end;
  SetBounds;
end;

procedure TDraftWidget.SetColor(AColor: TARGBColorBridge);
begin
  FColor := AColor;
  if AColor <> colbrDefault then
    BackGroundColor := ToTColor(AColor)
  else
    BackGroundColor := clNone;
end;

procedure TDraftWidget.SetFontColor(AColor: TARGBColorBridge);
begin
  FFontColor := AColor;
  if AColor <> colbrDefault then
    TextColor := ToTColor(AColor)
  else
    TextColor := DefaultTextColor;
end;

function TDraftWidget.Designer: TAndroidWidgetMediator;
var
  t: TAndroidWidget;
begin
  Result := nil;
  if FAndroidWidget = nil then Exit;
  t := FAndroidWidget;
  while Assigned(t.Parent) do t := t.Parent;
  if t is TAndroidForm then
    Result := TAndroidForm(t).Designer as TAndroidWidgetMediator;
end;

function TDraftWidget.WrapContentWidthByChildren: Integer;
var
  i, t: Integer;
begin
  with jVisualControl(FAndroidWidget) do
  begin
    Result := 0;
    for i := 0 to ChildCount - 1 do
      with jVisualControl(Children[i]) do
      begin
        if LayoutParamWidth = lpMatchParent then
          lpWidth := lpMatchParent;
        t := Left + Width + MarginRight;
        if t > Result then Result := t;
      end;
  end;
end;

function TDraftWidget.WrapContentHeightByChildren: Integer;
var
  i, t: Integer;
begin
  with jVisualControl(FAndroidWidget) do
  begin
    Result := 0;
    for i := 0 to ChildCount - 1 do
      with jVisualControl(Children[i]) do
      begin
        if (LayoutParamHeight = lpMatchParent) then
          lpHeight := lpMatchParent;
        t := Top + Height + MarginBottom;
        if t > Result then Result := t;
      end;
  end;
end;

function TDraftWidget.GetParentBackgroundColor: TARGBColorBridge;
begin
  // TODO: Parent.AcceptChildrenAtDesignTime
  if FAndroidWidget.Parent is jPanel then
  begin
    Result := jPanel(FAndroidWidget.Parent).BackgroundColor;
  end else
  if FAndroidWidget.Parent is jCustomDialog then
  begin
    Result := jCustomDialog(FAndroidWidget.Parent).BackgroundColor;
  end else
    Result := Color;
end;

function TDraftWidget.GetBackGroundColor: TColor;
var
  w: TAndroidWidget;
  d: TDraftWidgetClass;
begin
  Result := BackGroundColor;
  if Result = clNone then
  begin
    w := FAndroidWidget.Parent;
    while (Result = clNone) and (w is jVisualControl) do
    begin
      d := DraftClassesMap.Find(w.ClassType);
      if d = nil then Break;
      with d.Create(w, FCanvas) do
      begin
        Result := BackGroundColor;
        w := w.Parent;
        Free;
      end;
    end;
    if (Result = clNone) and (w is jForm)
    and (jForm(w).BackgroundColor <> colbrDefault) then
      Result := ToTColor(jForm(w).BackgroundColor)
    else
      Result := Designer.FDefaultBrushColor;
  end;
end;

function TDraftWidget.DefaultTextColor: TColor;
var
  t: TAndroidTheme;
  a: string;
begin
  if BaseStyle <> '' then
  begin
    t := Designer.AndroidTheme;
    if t <> nil then
    begin
      a := 'android:state_enabled=' + IfThen(FAndroidWidget.Enabled, '!false', 'false');
      if t.TryGetColor([BaseStyle, 'android:textColor'], a, Result) then Exit;
      if t.TryGetColor([BaseStyle,
                       'android:textAppearance',
                       'android:textColor'], a, Result) then Exit;
      if t.TryGetColor(['textAppearance',
                        'android:textColor'], a, Result) then Exit;
    end;
  end;
  Result := Designer.FDefaultFontColor;
end;

function TDraftWidget.GetNewWidth: Integer;
begin
  if (FLeftTop.x >= 0) and (FRightBottom.x >= 0) then
    Result := FRightBottom.x - FLeftTop.x
  else
  if FMinWidth > 0 then
    Result := FMinWidth
  else
    Result := Width;
  if Result < FMinWidth then
    Result := FMinWidth;
end;

function TDraftWidget.GetNewHeight: Integer;
begin
  if (FLeftTop.y >= 0) and (FRightBottom.y >= 0) then
    Result := FRightBottom.y - FLeftTop.y
  else
  if FMinHeight > 0 then
    Result := FMinHeight
  else
    Result := Height;
  if Result < FMinHeight then
    Result := FMinHeight;
end;

procedure TDraftWidget.SetBounds;
var
  newWidth, newHeight: Integer;
begin
  newWidth := GetNewWidth;
  newHeight := GetNewHeight;

  if FLeftTop.x < 0 then
    if FRightBottom.x >= 0 then
      FLeftTop.x := FRightBottom.x - newWidth
    else
      FLeftTop.x := jVisualControl(FAndroidWidget).Left;

  if FLeftTop.y < 0 then
    if FRightBottom.y >= 0 then
      FLeftTop.y := FRightBottom.y - newHeight
    else
      FLeftTop.y := jVisualControl(FAndroidWidget).Top;

  with jVisualControl(FAndroidWidget) do
    SetBounds(FLeftTop.x, FLeftTop.y, newWidth, newHeight);
end;

{ TDraftButton }

constructor TDraftButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'buttonStyle';
  DrawableDest := 'android:background';
  DrawableAttribs := 'android:state_enabled=' + IfThen(jButton(AWidget).Enabled, 'true', 'false');
  inherited;
  Color := jButton(AWidget).BackgroundColor;
  FontColor := jButton(AWidget).FontColor;
end;

procedure TDraftButton.Draw;
var
  r: TRect;
  ts: TTextStyle;
  lastFontSize: Integer;
  auxText: string;
begin
  with Fcanvas do
  begin
    Brush.Color := BackGroundColor;
    Pen.Color := clForm;
    Font.Color := TextColor;

    r := Rect(0, 0, Self.Width, Self.Height);

    if Drawable <> nil then
    begin
      if BackGroundColor <> clNone then
        FillRect(r)
      else
        StretchDraw(r, Drawable);
    end else begin
      if BackGroundColor = clNone then
        Brush.Color := BlendColors(GetBackgroundColor, 2/5, 153, 153, 153);
      FillRect(r);

      //outer frame
      Rectangle(r);

      Pen.Color := clMedGray;
      Brush.Style := bsClear;
      InflateRect(r, -1, -1);
      Rectangle(r);
    end;

    Brush.Style := bsClear;
    lastFontSize := Font.Size;
    Font.Size := AndroidToLCLFontSize(jButton(FAndroidWidget).FontSize, 12);
    ts := TextStyle;
    ts.Layout := tlCenter;
    ts.Alignment := Classes.taCenter;

    auxText:= FAndroidWidget.Text;

    if jButton(FAndroidWidget).AllCaps then
    begin
       auxText:= UpperCase(auxText);
    end;

    TextRect(r, r.Left, r.Top, auxText, ts);
    Font.Size := lastFontSize;
  end;
end;

procedure TDraftButton.UpdateLayout;
var
  lastSize: Integer;
  lastStyle: TFontStyles;
begin
  with jButton(FAndroidWidget), FCanvas do
    if (LayoutParamHeight = lpWrapContent)
    or (LayoutParamWidth = lpWrapContent) then
    begin
      lastSize := Font.Size;
      lastStyle := Font.Style;
      SetupFont(Font, FontSize, 13, tfNormal);

      with TextExtent(Text) do
      begin
        if LayoutParamWidth = lpWrapContent then
        begin
          FMinWidth := cx;
          if Drawable is T9PatchPNG then
            with T9PatchPNG(Drawable).Padding do
              FMinWidth := FMinWidth + Left + Right
          else
            FMinWidth := FMinWidth + 14 + 13
        end;
        if LayoutParamHeight = lpWrapContent then
        begin
          FMinHeight := cy;
          if Drawable is T9PatchPNG then
            with T9PatchPNG(Drawable).Padding do
              FMinHeight := FMinHeight + Top + Bottom + 11
          else
            FMinHeight := FMinHeight + 14 + 13
        end;
      end;

      Font.Size := lastSize;
      Font.Style := lastStyle;
    end;
  inherited UpdateLayout;
end;


{ TDraftKToyButton }

constructor TDraftKToyButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'buttonStyle';
  DrawableDest := 'android:background';
  DrawableAttribs := 'android:state_enabled=' + IfThen(KToyButton(AWidget).Enabled, 'true', 'false');
  inherited;
  Color := KToyButton(AWidget).BackgroundColor;
  FontColor := KToyButton(AWidget).FontColor;
end;

procedure TDraftKToyButton.Draw;
var
  r: TRect;
  ts: TTextStyle;
  lastFontSize: Integer;
  auxText: string;
begin
  with Fcanvas do
  begin
    Brush.Color := BackGroundColor;
    Pen.Color := clForm;
    Font.Color := TextColor;

    r := Rect(0, 0, Self.Width, Self.Height);

    if Drawable <> nil then
    begin
      if BackGroundColor <> clNone then
        FillRect(r)
      else
        StretchDraw(r, Drawable);
    end else begin
      if BackGroundColor = clNone then
        Brush.Color := BlendColors(GetBackgroundColor, 2/5, 153, 153, 153);
      FillRect(r);

      //outer frame
      Rectangle(r);

      Pen.Color := clMedGray;
      Brush.Style := bsClear;
      InflateRect(r, -1, -1);
      Rectangle(r);
    end;

    Brush.Style := bsClear;
    lastFontSize := Font.Size;
    Font.Size := AndroidToLCLFontSize(KToyButton(FAndroidWidget).FontSize, 12);
    ts := TextStyle;
    ts.Layout := tlCenter;
    ts.Alignment := Classes.taCenter;

    auxText:= FAndroidWidget.Text;

    if KToyButton(FAndroidWidget).AllCaps then
    begin
       auxText:= UpperCase(auxText);
    end;

    TextRect(r, r.Left, r.Top, auxText, ts);
    Font.Size := lastFontSize;
  end;
end;

procedure TDraftKToyButton.UpdateLayout;
var
  lastSize: Integer;
  lastStyle: TFontStyles;
begin

  with KToyButton(FAndroidWidget), FCanvas do
    if (LayoutParamHeight = lpWrapContent)
    or (LayoutParamWidth = lpWrapContent) then
    begin
      lastSize := Font.Size;
      lastStyle := Font.Style;
      SetupFont(Font, FontSize, 13, tfNormal);

      with TextExtent(Text) do
      begin
        if LayoutParamWidth = lpWrapContent then
        begin
          FMinWidth := cx;
          if Drawable is T9PatchPNG then
            with T9PatchPNG(Drawable).Padding do
              FMinWidth := FMinWidth + Left + Right
          else
            FMinWidth := FMinWidth + 14 + 13
        end;
        if LayoutParamHeight = lpWrapContent then
        begin
          FMinHeight := cy;
          if Drawable is T9PatchPNG then
            with T9PatchPNG(Drawable).Padding do
              FMinHeight := FMinHeight + Top + Bottom + 11
          else
            FMinHeight := FMinHeight + 14 + 13
        end;
      end;

      Font.Size := lastSize;
      Font.Style := lastStyle;
    end;

  inherited UpdateLayout;
end;

{ TDraftTextView }

constructor TDraftTextView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'textViewStyle';
  inherited;
  Color := jTextView(AWidget).BackgroundColor;
  if Color = colbrDefault then
    Color := GetParentBackgroundColor;
  FontColor := jTextView(AWidget).FontColor;
end;

procedure TDraftTextView.Draw;
var
  lastSize: Integer;
  fs: TFontStyles;
  auxText: string;
begin
  with Fcanvas do
  begin
    lastSize := Font.Size;
    fs := Font.Style;
    with jTextView(FAndroidWidget) do
      SetupFont(Font, FontSize, 10, TextTypeFace);

    Brush.Color := BackGroundColor;
    Pen.Color := TextColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, Self.Width, Self.Height)
    else
      Brush.Style := bsClear;

    auxText:= jTextView(FAndroidWidget).Text;

    if jTextView(FAndroidWidget).AllCaps then
    begin
       auxText:= UpperCase(auxText);
    end;

    Font.Color := TextColor;
    TextOut(0, (Font.Size + 5) div 10, auxText);

    Font.Size := lastSize;
    Font.Style := fs;
  end;
end;

procedure TDraftTextView.UpdateLayout;
var
  lastSize: Integer;
  lastStyle: TFontStyles;
begin
  with jTextView(FAndroidWidget), FCanvas do
    if (LayoutParamWidth = lpWrapContent)
    or (LayoutParamHeight = lpWrapContent) then
    begin
      lastSize := Font.Size;
      lastStyle := Font.Style;
      SetupFont(Font, FontSize, 10, TextTypeFace);

      with TextExtent(Text) do
      begin
        if LayoutParamWidth = lpWrapContent then
          FMinWidth := cx;
        if LayoutParamHeight = lpWrapContent then
          FMinHeight := cy + 2 + (Font.Size + 5) div 10;
      end;

      Font.Size := lastSize;
      Font.Style := lastStyle;
    end;
  inherited UpdateLayout;
end;

{ TDraftEditText }

constructor TDraftEditText.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'editTextStyle';
  DrawableDest := 'android:background';
  DrawableAttribs :=
    'android:state_focused=true;' +
    'android:state_enabled=' + IfThen(jEditText(AWidget).Enabled, 'true', '!true') + ';' +
    'android:state_multiline=' + IfThen(jEditText(AWidget).MaxLines > 1, 'true', '!true');
  inherited;
  Color := jEditText(AWidget).BackgroundColor;
  if Color = colbrDefault then
    Color := GetParentBackgroundColor;
  FontColor := jEditText(AWidget).FontColor;
end;

{
procedure TDraftImageBtn.Draw;
var
  r: TRect;
  w, h: integer;
begin

  if Color <> colbrDefault then
     Fcanvas.Brush.Color := ToTColor(Color)
  else
  begin
     Fcanvas.Brush.Color:= clNone;
     Fcanvas.Brush.Style:= bsClear;
  end;

  if GetImage <> nil then
  begin

    w:= Trunc(FImage.Width/3);
    h:= Trunc(FImage.Height/3);

    w:= Max(w,h);
    h:= w;

    if w < 64 then
    begin
      w:= 64;
      h:= 64;
    end;

    Fcanvas.RoundRect(0, 0, w+8, h+8, 12, 12);    // outer frame

    r:= Rect(4, 4, w+4, h+4);
    Fcanvas.StretchDraw(r, GetImage);
  end
  else
  begin
    Fcanvas.RoundRect(0, 0, 72, 72, 12,12);  //outer frame
    Fcanvas.Ellipse(4,4,68,68);            //inner
  end;

end;

}
procedure TDraftEditText.Draw;
var
  ls: Integer;
  r: TRect;
  auxText: string;

  r2: TRect;
  w, h: integer;
begin
  with FCanvas do
  begin
    r := Rect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);

    if BackGroundColor <> clNone then
    begin
      Brush.Color := BackGroundColor;
      FillRect(r)
    end else
    begin
      if Drawable <> nil then
        StretchDraw(r, Drawable)
      else begin
        Brush.Style := bsClear;
        Pen.Color := RGBToColor(175,175,175);
        with r do
        begin
          MoveTo(4, Bottom - 8);
          Lineto(4, Bottom - 5);
          Lineto(Right - 4, Bottom - 5);
          Lineto(Right - 4, Bottom - 8);
        end;
      end;
    end;

    auxText:= jEditText(FAndroidWidget).Text;

    Font.Color := TextColor;
    Brush.Style := bsClear;
    ls := Font.Size;
    Font.Size := AndroidToLCLFontSize(jEditText(FAndroidWidget).FontSize, 12);
    TextOut(12, 9, auxText);
    Font.Size := ls;
  end;

  if GetImage <> nil then
  begin

    w:= Trunc(FImage.Width/4);
    h:= Trunc(FImage.Height/4);

    w:= Max(w,h);
    h:= w;

    if w < 32 then
    begin
      w:= 32;
      h:= 32;
    end;
    //Fcanvas.RoundRect(FAndroidWidget.Width-w, 0, FAndroidWidget.Width, h, 12, 12);    // outer frame
    r2:= Rect(FAndroidWidget.Width-w, 0, FAndroidWidget.Width, h);
    Fcanvas.StretchDraw(r2, GetImage);
  end
  else
  begin
    //Fcanvas.RoundRect(0, 0, 72, 72, 12,12);  //outer frame
    //Fcanvas.Ellipse(4,4,68,68);            //inner
  end;

end;

procedure TDraftEditText.UpdateLayout;
var
  fs: Integer;
begin
  with jEditText(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      fs := FontSize;
      if fs = 0 then fs := 18;
      FMinHeight := 29 + (fs - 10) * 4 div 3; // todo: multiline
    end;
  inherited;
end;

function TDraftEditText.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
    Result := FImage
  else
    with jEditText(FAndroidWidget) do
    begin
      if ActionIconIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ActionIconIdentifier));
        Result := FImage;
      end else Result := nil;
    end;
end;

{ TDraftSTextInput }

constructor TDraftSTextInput.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'autoTextViewStyle';
  inherited;
  Color := jsTextInput(AWidget).BackgroundColor;
  FontColor := jsTextInput(AWidget).FontColor;
end;

procedure TDraftSTextInput.Draw;
var
  ls: Integer;
begin
  with FCanvas do
  begin
    if BackgroundColor <> clNone then
    begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);
    end else
      Brush.Style := bsClear;
    Font.Color := TextColor;

    ls := Font.Size;
    Font.Size := AndroidToLCLFontSize(jsTextInput(FAndroidWidget).FontSize, 11);
    TextOut(4, 12, jsTextInput(FAndroidWidget).Text);
    Font.Size := ls;

    if BackgroundColor = clNone then
    begin
      Pen.Color := RGBToColor(175,175,175);
      with FAndroidWidget do
      begin
        MoveTo(4, Height - 8);
        Lineto(4, Height - 5);
        Lineto(Width - 4, Height - 5);
        Lineto(Width - 4, Height - 8);
      end;
    end;
  end;
end;

procedure TDraftSTextInput.UpdateLayout;
var
  fs: Integer;
begin
  with jsTextInput(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      fs := FontSize;
      if fs = 0 then fs := 18;
      FMinHeight := 29 + (fs - 10) * 4 div 3; // todo: multiline
    end;
  inherited UpdateLayout;
end;

{TDraftAutoTextView}

constructor TDraftAutoTextView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'autoTextViewStyle';
  inherited;
  Color := jAutoTextView(AWidget).BackgroundColor;
  FontColor := jAutoTextView(AWidget).FontColor;
end;

procedure TDraftAutoTextView.Draw;
var
  ls: Integer;
begin
  with FCanvas do
  begin
    if BackgroundColor <> clNone then
    begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);
    end else
      Brush.Style := bsClear;
    Font.Color := TextColor;

    ls := Font.Size;
    Font.Size := AndroidToLCLFontSize(jAutoTextView(FAndroidWidget).FontSize, 11);
    TextOut(4, 12, jAutoTextView(FAndroidWidget).Text);
    Font.Size := ls;

    if BackgroundColor = clNone then
    begin
      Pen.Color := RGBToColor(175,175,175);
      with FAndroidWidget do
      begin
        MoveTo(4, Height - 8);
        Lineto(4, Height - 5);
        Lineto(Width - 4, Height - 5);
        Lineto(Width - 4, Height - 8);
      end;
    end;
  end;
end;

procedure TDraftAutoTextView.UpdateLayout;
var
  fs: Integer;
begin
  with jAutoTextView(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      fs := FontSize;
      if fs = 0 then fs := 18;
      FMinHeight := 29 + (fs - 10) * 4 div 3; // todo: multiline
    end;
  inherited UpdateLayout;
end;

{ TDraftComboEditText }

constructor TDraftComboEditText.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'autoTextViewStyle';   //comboEditTextStyle  TODO!
  inherited;
  Color := jComboEditText(AWidget).BackgroundColor;
  FontColor := jComboEditText(AWidget).FontColor;
end;

procedure TDraftComboEditText.Draw;
var
  ls: Integer;
begin
  with FCanvas do
  begin
    if BackgroundColor <> clNone then
    begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);
    end else
      Brush.Style := bsClear;
    Font.Color := TextColor;

    ls := Font.Size;
    Font.Size := AndroidToLCLFontSize(jComboEditText(FAndroidWidget).FontSize, 11);
    TextOut(4, 12, jComboEditText(FAndroidWidget).Text);
    Font.Size := ls;

    if BackgroundColor = clNone then
    begin
      Pen.Color := RGBToColor(175,175,175);
      with FAndroidWidget do
      begin
        MoveTo(4, Height - 8);
        Lineto(4, Height - 5);
        Lineto(Width - 4, Height - 5);
        Lineto(Width - 4, Height - 8);
      end;
    end;
  end;
end;

procedure TDraftComboEditText.UpdateLayout;
var
  fs: Integer;
begin
  with jComboEditText(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      fs := FontSize;
      if fs = 0 then fs := 18;
      FMinHeight := 29 + (fs - 10) * 4 div 3; // todo: multiline
    end;
  inherited UpdateLayout;
end;


{ TDraftSearchView }

constructor TDraftSearchView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'autoTextViewStyle';   //SearchViewStyle  TODO!
  inherited;
  Color := jSearchView(AWidget).BackgroundColor;
  //FontColor := jSearchView(AWidget).FontColor;
end;

procedure TDraftSearchView.Draw;
var
  ls: Integer;
begin
  with FCanvas do
  begin
    if BackgroundColor <> clNone then
    begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);
    end else
      Brush.Style := bsClear;
    Font.Color := TextColor;

    ls := Font.Size;
    Font.Size := AndroidToLCLFontSize(jComboEditText(FAndroidWidget).FontSize, 11);
    TextOut(4, 12, jSearchView(FAndroidWidget).Text);
    Font.Size := ls;

    if BackgroundColor = clNone then
    begin
      Pen.Color := RGBToColor(175,175,175);
      with FAndroidWidget do
      begin
        MoveTo(4, Height - 8);
        Lineto(4, Height - 5);
        Lineto(Width - 4, Height - 5);
        Lineto(Width - 4, Height - 8);
      end;
    end;
  end;
end;

procedure TDraftSearchView.UpdateLayout;
//var
  //fs: Integer;
begin
  with jSearchView(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      {
      fs := FontSize;
      if fs = 0 then fs := 18;
      FMinHeight := 29 + (fs - 10) * 4 div 3; // todo: multiline
      }
    end;
  inherited UpdateLayout;
end;

{ TDraftCheckBox }

constructor TDraftCheckBox.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'checkboxStyle';
  DrawableDest := 'android:button';
  DrawableAttribs :=
    'android:state_enabled=' + IfThen(jCheckBox(AWidget).Enabled, 'true', 'false') + ';' +
    'android:state_checked=' + IfThen(jCheckBox(AWidget).Checked, 'true', 'false');
  inherited;
  Color := jCheckBox(AWidget).BackgroundColor;
  FontColor := jCheckBox(AWidget).FontColor;
end;

procedure TDraftCheckBox.Draw;
var
  lastSize, ps: Integer;
begin
  with Fcanvas do
  begin
    Brush.Color := Self.BackGroundColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, Self.Width, Self.Height)
    else
      Brush.Style := bsClear;

    if Drawable <> nil then
    begin
      Draw(0, 0, Drawable)
    end else begin
      Brush.Color := clWhite;
      Brush.Style := bsClear;
      Pen.Color := RGBToColor($A1,$A1,$A1);
      Rectangle(8, 8, 24, 24);
      if jCheckBox(FAndroidWidget).Checked then
      begin
        lastSize := Pen.Width;
        Pen.Width := 4;
        Pen.Color := RGBToColor($44,$B3,$DD);
        MoveTo(12, 13);
        LineTo(16, 18);
        LineTo(26, 7);
        Pen.Width := lastSize;
      end;
    end;

    Brush.Style := bsClear;
    Font.Color := TextColor;
    lastSize := Font.Size;
    ps := AndroidToLCLFontSize(jCheckBox(FAndroidWidget).FontSize, 12);
    Font.Size := ps;
    TextOut(32, 14 - Abs(Font.Height) div 2, FAndroidWidget.Text);
    Font.Size := lastSize;
  end;
end;

procedure TDraftCheckBox.UpdateLayout;
var
  ls, ps: Integer;
begin
  with jCheckBox(FAndroidWidget) do
  begin
    if LayoutParamHeight = lpWrapContent then
      FMinHeight := 32;
    if LayoutParamWidth = lpWrapContent then
    begin
      ps := AndroidToLCLFontSize(FontSize, 12);
      ls := FCanvas.Font.Size;
      FCanvas.Font.Size := ps;
      FMinWidth := 33 + FCanvas.TextWidth(Text);
      FCanvas.Font.Size := ls;
    end;
  end;
  inherited UpdateLayout;
end;

{ TDraftRadioButton }

constructor TDraftRadioButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  BaseStyle := 'radioButtonStyle';
  DrawableDest := 'android:button';
  DrawableAttribs :=
    'android:state_enabled=' + IfThen(jCheckBox(AWidget).Enabled, 'true', 'false') + ';' +
    'android:state_checked=' + IfThen(jCheckBox(AWidget).Checked, 'true', 'false');
  inherited;
  Color := jRadioButton(AWidget).BackgroundColor;
  FontColor := jRadioButton(AWidget).FontColor;
end;

procedure TDraftRadioButton.Draw;
var
  lastSize: Integer;
begin
  with Fcanvas do
  begin
    Brush.Color := BackGroundColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, Self.Width, Self.Height)
    else
      Brush.Style := bsClear;

    if Drawable <> nil then
      Draw(0, 0, Drawable)
    else begin
      Brush.Style := bsClear;
      Pen.Color := RGBToColor(155,155,155);
      Ellipse(7, 6, 25, 24);
      if jRadioButton(FAndroidWidget).Checked then
      begin
        Brush.Color := RGBToColor(0,$99,$CC);
        Ellipse(7+3, 6+3, 25-3, 24-3);
      end;
    end;

    Brush.Style := bsClear;
    Font.Color := TextColor;
    lastSize := Font.Size;
    Font.Size := AndroidToLCLFontSize(jCheckBox(FAndroidWidget).FontSize, 12);
    TextOut(32, 14 - Abs(Font.Height) div 2, FAndroidWidget.Text);
    Font.Size := lastSize;
  end;
end;

procedure TDraftRadioButton.UpdateLayout;
var
  ps, ls: Integer;
begin
  with jRadioButton(FAndroidWidget) do
  begin
    if LayoutParamHeight = lpWrapContent then
      FMinHeight := 32;
    if LayoutParamWidth = lpWrapContent then
    begin
      ps := AndroidToLCLFontSize(FontSize, 12);
      ls := FCanvas.Font.Size;
      FCanvas.Font.Size := ps;
      FMinWidth := 33 + FCanvas.TextWidth(Text);
      FCanvas.Font.Size := ls;
    end;
  end;
  inherited UpdateLayout;
end;

{ TDraftProgressBar }

constructor TDraftProgressBar.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jProgressBar(AWidget).BackgroundColor;
  FontColor := colbrBlack;

  if jProgressBar(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftProgressBar.Draw;
var
  x: integer;
  r: TRect;
begin
  with Fcanvas do
  begin
    Brush.Color := RGBToColor($ad,$ad,$ad);
    r := Rect(0, 10, Self.Width, 13);
    FillRect(r);
    Brush.Color := RGBToColor($44,$B3,$DD);
    r.Top := 9;
    r.Bottom := 12;
    if jProgressBar(FAndroidWidget).Max <= 0 then
      jProgressBar(FAndroidWidget).Max := 100;
    x := Self.Width * jProgressBar(FAndroidWidget).Progress
         div jProgressBar(FAndroidWidget).Max;
    { "inverse" does not work... yet?
    if not (jProgressBar(FAndroidWidget).Style
            in [cjProgressBarStyleInverse, cjProgressBarStyleLargeInverse])
    then}
      r.Right := x
    {else begin
      r.Right := Self.Width;
      r.Left := Self.Width - x;
    end};
    FillRect(r);
  end;
end;

procedure TDraftProgressBar.UpdateLayout;
begin
  with jProgressBar(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
      FMinHeight := 23;
  inherited UpdateLayout;
end;


{ TDraftSeekBar }

constructor TDraftSeekBar.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jSeekBar(AWidget).BackgroundColor;
  FontColor := colbrBlack;

  if jSeekBar(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftSeekBar.Draw;
var
  x: integer;
  r: TRect;
begin
  with Fcanvas do
  begin
    Brush.Color := RGBToColor($ad,$ad,$ad);
    r := Rect(0, 10, Self.Width, 13);
    FillRect(r);
    Brush.Color := RGBToColor($44,$B3,$DD);
    r.Top := 9;
    r.Bottom := 12;
    if jSeekBar(FAndroidWidget).Max <= 0 then
      jSeekBar(FAndroidWidget).Max := 100;
    x := Self.Width * jSeekBar(FAndroidWidget).Progress div jSeekBar(FAndroidWidget).Max;
    { "inverse" does not work... yet?
    if not (jProgressBar(FAndroidWidget).Style
            in [cjProgressBarStyleInverse, cjProgressBarStyleLargeInverse])
    then}
      r.Right := x;
    {else begin
      r.Right := Self.Width;
      r.Left := Self.Width - x;
    end};
    FillRect(r);
    Brush.Color := RGBToColor($ff,$ff,$00);
    Ellipse(Rect(x, 6, x+12 , 18));
  end;
end;

procedure TDraftSeekBar.UpdateLayout;
begin
  with jSeekBar(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
      FMinHeight := 23;
  inherited UpdateLayout;
end;

{ TDraftListView }

constructor TDraftListView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jListView(AWidget).BackgroundColor;
  FontColor := jListView(AWidget).FontColor; //colbrBlack;

  FDrfItems:= TStringList.Create;

  FDrfItems.Text:= jListView(AWidget).Items.Text;

  FDrfCount:=  jListView(AWidget).Items.Count;

  if jListView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

function TDraftListView.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
  begin
    Result := FImage
  end
  else
    with jListView(FAndroidWidget) do
    begin
      if ImageItemIdentifier <> '' then
      begin
        FImage:= Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageItemIdentifier));
        Result:= FImage;
      end else Result := nil;
    end;
end;

procedure TDraftListView.Draw;
var
  i, k,  count: integer;
  r: TRect;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  count:= FDrfItems.Count;

  Fcanvas.Pen.Color:= clSilver;
  Fcanvas.Font.Color:= Self.TextColor;

  k:= Trunc(Self.Height/30);

  for i:= 1 to k-1 do
  begin
    Fcanvas.MoveTo(Self.Width, {x2} Self.MarginTop+i*30); {y1}
    Fcanvas.LineTo(0,Self.MarginTop+i*30);  {x1, y1}
    if i <= count then
    begin
       if GetImage <> nil then
       begin
           r := Rect(5, 3 + Self.MarginTop+(i-1)*30, 24, Self.MarginTop+(i-1)*30 + 24);
           Fcanvas.StretchDraw(r, GetImage);
           Fcanvas.TextOut(40, 3 + Self.MarginTop+(i-1)*30, FDrfItems.Strings[i-1]);
       end
       else
          Fcanvas.TextOut(5, 3 + Self.MarginTop+(i-1)*30, FDrfItems.Strings[i-1]);
    end;
  end;

  //canvas.Brush.Style:= bsClear;
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4, txt);

  Fcanvas.Brush.Style:= bsSolid;

end;

destructor TDraftListView.Destroy;
begin
  FDrfItems.Free;
  inherited;
end;

{ TDraftExpandableListView }

constructor TDraftExpandableListView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jExpandableListView(AWidget).BackgroundColor;
  FontColor := jExpandableListView(AWidget).FontColor; //colbrBlack;

  if jExpandableListView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftExpandableListView.Draw;
var
  i, k: integer;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Pen.Color:= clSilver;
  k:= Trunc(Self.Height/30);
  for i:= 1 to k-1 do
  begin
    Fcanvas.MoveTo(Self.Width{-Self.MarginRight+10}, {x2} Self.MarginTop+i*30); {y1}
    Fcanvas.LineTo(0,Self.MarginTop+i*30);  {x1, y1}
  end;

  Fcanvas.Brush.Style:= bsSolid;
  //canvas.Brush.Style:= bsClear;
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4, txt);

end;

{ TDraftImageBtn }

function TDraftImageBtn.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
    Result := FImage
  else
    with jImageBtn(FAndroidWidget) do
    begin
      if ImageUpIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageUpIdentifier));
        Result := FImage;
      end else
      if (Images <> nil)
      and (IndexImageUp >= 0) and (IndexImageUp < Images.Count) then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.AssetsDir + Images.Images[IndexImageUp]);
        Result := FImage;
      end else
        Result := nil;
    end;
end;

constructor TDraftImageBtn.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jImageBtn(AWidget).BackgroundColor;
  FontColor:= colbrGray;

  if jImageBtn(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftImageBtn.Draw;
var
  r: TRect;
  w, h: integer;
begin

  if Color <> colbrDefault then
     Fcanvas.Brush.Color := ToTColor(Color)
  else
  begin
     Fcanvas.Brush.Color:= clNone;
     Fcanvas.Brush.Style:= bsClear;
  end;

  if GetImage <> nil then
  begin

    w:= Trunc(FImage.Width/3);
    h:= Trunc(FImage.Height/3);

    w:= Max(w,h);
    h:= w;

    if w < 64 then
    begin
      w:= 64;
      h:= 64;
    end;

    Fcanvas.RoundRect(0, 0, w+8, h+8, 12, 12);    // outer frame

    r:= Rect(4, 4, w+4, h+4);
    Fcanvas.StretchDraw(r, GetImage);
  end
  else
  begin
    Fcanvas.RoundRect(0, 0, 72, 72, 12,12);  //outer frame
    Fcanvas.Ellipse(4,4,68,68);            //inner
  end;

end;

procedure TDraftImageBtn.UpdateLayout;
var
  im: TPortableNetworkGraphic;
begin
  im := GetImage;
  if im <> nil  then
    with jImageBtn(FAndroidWidget) do
    begin

      FMinWidth:= Trunc(FImage.Width/3);
      FMinHeight:= Trunc(FImage.Height/3);

      FMinWidth:= Max(FMinWidth,FMinHeight) + 8;
      FMinHeight:= FMinWidth;

      if FMinWidth < 72 then
      begin
        FMinWidth:= 72;
        FMinHeight:= FMinWidth;
      end;

    end;
  inherited UpdateLayout;
end;

{ TDraftImageView }

function TDraftImageView.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
    Result := FImage
  else
    with jImageView(FAndroidWidget) do
    begin
      if ImageIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageIdentifier));
        Result := FImage;
      end else
      if (Images <> nil)
      and (ImageIndex >= 0) and (ImageIndex < Images.Count) then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.AssetsDir + Images.Images[ImageIndex]);
        Result := FImage;
      end else
        Result := nil;
    end;
end;

constructor TDraftImageView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jImageView(AWidget).BackgroundColor;
  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;

  if jImageView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftImageView.Draw;
var
  r: TRect;
begin

  if Color <> colbrDefault then
     Fcanvas.Brush.Color := ToTColor(Color)
  else
  begin
     Fcanvas.Brush.Color:= clNone;
     Fcanvas.Brush.Style:= bsClear;
  end;

  if GetImage <> nil then
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
    //r:= Rect(6, 6, Self.Width-6,Self.Height-6);
    r:= Rect(6, 6, FMinWidth-6, FMinHeight-6);
    Fcanvas.StretchDraw(r, GetImage);
  end
  else
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
  end;

end;

procedure TDraftImageView.UpdateLayout;
var
  im: TPortableNetworkGraphic;
  aspectratio: single;
  adjustedheight: integer;
begin
  im := GetImage;
  if im <> nil then
  begin
    with jImageView(FAndroidWidget) do
    begin

        if FImage.Width > Self.Width then
           FMinWidth:= Self.Width
        else
           FMinWidth:= FImage.Width;

        aspectratio    := FImage.Width/FImage.Height;
        adjustedheight := Trunc(FMinWidth/aspectratio);

        FMinHeight:= adjustedheight;

        if FMinWidth < 32 then FMinWidth:= 32;
        if FMinHeight < 32 then FMinHeight:= 32;

    end;
  end;
  inherited UpdateLayout;
end;


{ TDraftImageButton }


function TDraftImageButton.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
    Result := FImage
  else
    with jImageButton(FAndroidWidget) do
    begin
      if ImageIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageIdentifier));
        Result := FImage;
      end
      else
      Result := nil;
    end;
end;


constructor TDraftImageButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jImageButton(AWidget).BackgroundColor;
  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;

  if jImageButton(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftImageButton.Draw;
var
  r: TRect;
begin

  if Color <> colbrDefault then
     Fcanvas.Brush.Color := ToTColor(Color)
  else
  begin
     Fcanvas.Brush.Color:= clNone;
     Fcanvas.Brush.Style:= bsClear;
  end;

  if GetImage <> nil then
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
    //r:= Rect(6, 6, Self.Width-6,Self.Height-6);
    r:= Rect(6, 6, FMinWidth-6, FMinHeight-6);
    Fcanvas.StretchDraw(r, GetImage);
  end
  else
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
  end;

end;

procedure TDraftImageButton.UpdateLayout;
var
  im: TPortableNetworkGraphic;
  aspectratio: single;
  adjustedheight: integer;
begin
  im := GetImage;
  if im <> nil then
  begin
    with jImageButton(FAndroidWidget) do  //jsContinuousScrollableImageView
    begin

        if FImage.Width > Self.Width then
           FMinWidth:= Self.Width
        else
           FMinWidth:= FImage.Width;

        aspectratio    := FImage.Width/FImage.Height;
        adjustedheight := Trunc(FMinWidth/aspectratio);

        FMinHeight:= adjustedheight;

        if FMinWidth < 32 then FMinWidth:= 32;
        if FMinHeight < 32 then FMinHeight:= 32;

    end;
  end;
  inherited UpdateLayout;
end;

///----------

{ TDraftZoomableImageView }

function TDraftZoomableImageView.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
    Result := FImage
  else
    with jZoomableImageView(FAndroidWidget) do
    begin
      if ImageIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageIdentifier));
        Result := FImage;
      end
      {else
      if (Images <> nil)
      and (ImageIndex >= 0) and (ImageIndex < Images.Count) then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.AssetsDir + Images.Images[ImageIndex]);
        Result := FImage;
      end} else
        Result := nil;
    end;
end;

constructor TDraftZoomableImageView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jZoomableImageView(AWidget).BackgroundColor;
  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;

  if jZoomableImageView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftZoomableImageView.Draw;
var
  r: TRect;
begin

  if Color <> colbrDefault then
     Fcanvas.Brush.Color := ToTColor(Color)
  else
  begin
     Fcanvas.Brush.Color:= clNone;
     Fcanvas.Brush.Style:= bsClear;
  end;

  if GetImage <> nil then
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
    //r:= Rect(6, 6, Self.Width-6,Self.Height-6);
    r:= Rect(6, 6, FMinWidth-6, FMinHeight-6);
    Fcanvas.StretchDraw(r, GetImage);
  end
  else
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
  end;

end;

procedure TDraftZoomableImageView.UpdateLayout;
var
  im: TPortableNetworkGraphic;
  aspectratio: single;
  adjustedheight: integer;
begin
  im := GetImage;
  if im <> nil then
  begin
    with jZoomableImageView(FAndroidWidget) do //jsContinuousScrollableImageView
    begin

        if FImage.Width > Self.Width then
          FMinWidth:= Self.Width
        else
          FMinWidth:= FImage.Width;

        aspectratio:= FImage.Width/FImage.Height;
        adjustedheight:= Trunc(FMinWidth/aspectratio);

        if adjustedheight < 200 then
           FMinHeight:= adjustedheight
        else
           FMinHeight:= 200;

        //FMinWidth:= Min(FMinWidth,FImage.Width) + 8;
        //FMinHeight:= Min(FMinHeight,FImage.Height) + 8;

        if FMinWidth < 72 then FMinWidth:= 72;
        if FMinHeight < 72 then FMinHeight:= 72;

    end;
  end;
  inherited UpdateLayout;
end;

//-----------

{ TDraftSFloatingButton }

function TDraftSFloatingButton.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
    Result := FImage
  else
    with jsFloatingButton(FAndroidWidget) do
    begin
      if ImageIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageIdentifier));
        Result := FImage;
      end else
      Result := nil;
    end;
end;

constructor TDraftSFloatingButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jsFloatingButton(AWidget).BackgroundColor;
  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;

  if jsFloatingButton(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftSFloatingButton.Draw;
var
  r: TRect;
begin
  with Fcanvas do
  begin
    if jsFloatingButton(FAndroidWidget).BackgroundColor <> colbrDefault then
    begin
      Brush.Color := ToTColor(jsFloatingButton(FAndroidWidget).BackgroundColor)
    end
    else
    begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    //Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
    Ellipse(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
    if GetImage <> nil then
    begin
      r := Rect(0, 0, 48, 48);
      StretchDraw(r, GetImage);
      //Draw(0, 0, GetImage);
    end;
  end;
end;

procedure TDraftSFloatingButton.UpdateLayout;
begin
  inherited UpdateLayout;
end;

{ TDraftSContinuousScrollableImageView }

function TDraftSContinuousScrollableImageView.GetImage: TPortableNetworkGraphic;
begin
  if FImage <> nil then
  begin
    Result := FImage
  end
  else
  begin
    with jsContinuousScrollableImageView(FAndroidWidget) do
    begin
      if ImageIdentifier <> '' then
      begin
        FImage := Designer.ImageCache.GetImageAsPNG(Designer.FindDrawable(ImageIdentifier));
        Result := FImage;
      end
      else Result := nil;
    end;
  end;
end;

constructor TDraftSContinuousScrollableImageView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Color := jsContinuousScrollableImageView(AWidget).BackgroundColor;
  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;
  if jsContinuousScrollableImageView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftSContinuousScrollableImageView.Draw;
var
  r: TRect;
begin

  if Color <> colbrDefault then
     Fcanvas.Brush.Color := ToTColor(Color)
  else
  begin
     Fcanvas.Brush.Color:= clNone;
     Fcanvas.Brush.Style:= bsClear;
  end;

  if GetImage <> nil then
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
    //r:= Rect(6, 6, Self.Width-6,Self.Height-6);
    r:= Rect(6, 6, FMinWidth-6, FMinHeight-6);
    Fcanvas.StretchDraw(r, GetImage);
  end
  else
  begin
    Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
    Fcanvas.RoundRect(4, 4, Self.Width-4, Self.Height-4, 12,12);  //inner frame
  end;

end;

procedure TDraftSContinuousScrollableImageView.UpdateLayout;
var
  im: TPortableNetworkGraphic;
  aspectratio: single;
  adjustedheight: integer;
begin
  im := GetImage;
  if im <> nil then
  begin
    with jsContinuousScrollableImageView(FAndroidWidget) do
    begin

        if FImage.Width > Self.Width then
          FMinWidth:= Self.Width
        else
          FMinWidth:= FImage.Width;

        aspectratio:= FImage.Width/FImage.Height;
        adjustedheight:= Trunc(FMinWidth/aspectratio);

        if adjustedheight < 200 then
           FMinHeight:= adjustedheight
        else
           FMinHeight:= 200;

        //FMinWidth:= Min(FMinWidth,FImage.Width) + 8;
        //FMinHeight:= Min(FMinHeight,FImage.Height) + 8;

        if FMinWidth < 72 then FMinWidth:= 72;
        if FMinHeight < 72 then FMinHeight:= 72;


    end;
  end;
  inherited UpdateLayout;
end;

{ TDrafDrawingView }

constructor TDraftDrawingView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jDrawingView(AWidget).BackgroundColor;
  FontColor := colbrGray;
  BackGroundColor := clActiveCaption; //clMenuHighlight;

  if jDrawingView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

{ TDraftSurfaceView }

constructor TDraftSurfaceView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jSurfaceView(AWidget).BackgroundColor;
  FontColor := colbrGray;
  BackGroundColor := clActiveCaption; //clMenuHighlight;

  if jSurfaceView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;


{ TDraftCOpenMapView }

constructor TDraftCOpenMapView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jcOpenMapView(AWidget).BackgroundColor;
  FontColor := colbrGray;
  BackGroundColor := clActiveCaption; //clMenuHighlight;

  if jcOpenMapView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

{ TDraftCSignaturePad }

constructor TDraftCSignaturePad.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jcSignaturePad(AWidget).BackgroundColor;
  FontColor := colbrGray;
  BackGroundColor := clActiveCaption; //clMenuHighlight;

  if jcSignaturePad(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

{ TDraftCustomCamera }

constructor TDraftCustomCamera.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jCustomCamera(AWidget).BackgroundColor;
  FontColor := colbrGray;
  BackGroundColor := clActiveCaption; //clMenuHighlight;

  if jCustomCamera(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

{ TDraftGL2SurfaceView }

(*
constructor TDraftGL2SurfaceView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Color := jGL2SurfaceView(AWidget).BackgroundColor;
  FontColor := colbrGray;
  BackGroundColor := clActiveCaption; //clMenuHighlight;

  if jGL2SurfaceView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;
*)

{ TDraftSpinner }

constructor TDraftSpinner.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jSpinner(AWidget).BackgroundColor;
  FontColor := jSpinner(AWidget).DropListBackgroundColor;
  DropListTextColor := jSpinner(AWidget).DropListTextColor;
  DropListBackgroundColor := jSpinner(AWidget).DropListBackgroundColor;
  SelectedFontColor := jSpinner(AWidget).SelectedFontColor;

  if jSpinner(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftSpinner.SetDropListBackgroundColor(Acolor: TARGBColorBridge);
begin
  FDropListBackgroundColor:= Acolor;
  if Acolor <> colbrDefault then
    DropListColor:= ToTColor(Acolor)
  else
    DropListColor:= clNone;
end;

procedure TDraftSpinner.SetDropListTextColor(Acolor: TARGBColorBridge);
var
  fpColor: TFPColor;
begin
  FDropListTextColor:= Acolor;
  if Acolor <> colbrDefault then
  begin
    fpColor:= ToTFPColor(Acolor);
    DropListFontColor:= FPColorToTColor(fpColor);
  end
  else DropListFontColor:= clNone;
end;

procedure TDraftSpinner.SetSelectedFontColor(Acolor: TARGBColorBridge);
var
  fpColor: TFPColor;
begin
  FSelectedFontColor:= Acolor;
  if Acolor <> colbrDefault then
  begin
    fpColor:= ToTFPColor(Acolor);
    SelectedTextColor:= FPColorToTColor(fpColor);
  end
  else SelectedTextColor:= clNone;
end;

procedure TDraftSpinner.Draw;
var
  r: TRect;
  saveColor: TColor;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= Self.DropListColor;

  if DropListColor = clNone then
     Fcanvas.Pen.Color:= clMedGray;

  if BackGroundColor = clNone then
     Fcanvas.Brush.Color:= clWhite;

  r := Rect(0, 0, Self.Width, Self.Height);
  Fcanvas.FillRect(r);
      // outer frame
  Fcanvas.Rectangle(r);

  InflateRect(r, -1, -1);
  Fcanvas.Rectangle(r);

  Fcanvas.Brush.Color:= Self.DropListColor; //clActiveCaption;

  if DropListColor = clNone then
     Fcanvas.Brush.Color:= clSilver;

  Fcanvas.Rectangle(Self.Width-47,0+7,Self.Width-7,Self.Height-7);

  saveColor:= Fcanvas.Brush.Color;

  Fcanvas.Brush.Style:= bsClear;
  Fcanvas.Pen.Color:= clWhite;

  Fcanvas.Rectangle(Self.Width-48,0+6,Self.Width-6,Self.Height-6);

  Fcanvas.Pen.Color:= Self.DropListFontColor;

  if saveColor <> clBlack then
     Fcanvas.Pen.Color:= clBlack
  else
     Fcanvas.Pen.Color:= clSilver;

  Fcanvas.Line(Self.Width-42, 12,Self.Width-11, 12);
  Fcanvas.Line(Self.Width-42-1, 12,Self.Width-42+31 div 2, Self.Height-12);
  Fcanvas.Line(Self.Width-42+31 div 2,Self.Height-12,Self.Width-11,12);

  Fcanvas.Font.Color:= Self.SelectedTextColor;
  if SelectedTextColor = clNone then
     Fcanvas.Font.Color:= clMedGray;

  //Fcanvas.TextOut(5,4,txt);
end;

{ TDraftWebView }

constructor TDraftWebView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jWebView(AWidget).BackgroundColor;
  BackGroundColor := clWhite;

  if jWebView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftWebView.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clTeal; //clGreen;//clActiveCaption;
  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame

  Fcanvas.Brush.Color:= clWhite;
  Fcanvas.Pen.Color:= clMoneyGreen;//clActiveCaption;

  Fcanvas.FillRect(5,5,Self.Width-5,25);
  Fcanvas.Rectangle(5,5,Self.Width-5,25);

  Fcanvas.FillRect (5,30,Trunc(Self.Width/2)-5,Self.Height-5);
  Fcanvas.Rectangle(5,30,Trunc(Self.Width/2)-5,Self.Height-5);

  Fcanvas.FillRect (Trunc(Self.Width/2),30,Self.Width-5,Trunc(0.5*Self.Height));
  Fcanvas.Rectangle(Trunc(Self.Width/2),30,Self.Width-5,Trunc(0.5*Self.Height));

  Fcanvas.FillRect (Trunc(Self.Width/2),Trunc(0.5*Self.Height)+5,Self.Width-5,Self.Height-5);
  Fcanvas.Rectangle(Trunc(Self.Width/2),Trunc(0.5*Self.Height)+5,Self.Width-5,Self.Height-5);
end;

{ TDraftScrollView }

constructor TDraftScrollView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jScrollView(AWidget).BackgroundColor;

  if jScrollView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftScrollView.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;

  if Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame

  Fcanvas.Brush.Style:= bsSolid;
  Fcanvas.Brush.Color:= clWhite;
  Fcanvas.FillRect(Self.Width-20,5,Self.Width-5,Self.Height-5);

  Fcanvas.Brush.Color:= clMedGray; //Self.BackGroundColor;
  Fcanvas.FillRect(Self.Width-20+5,5+25,Self.Width-5-5,Self.Height-5-25);

  Fcanvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;
  Fcanvas.Frame(Self.Width-20,5,Self.Width-5,Self.Height-5);

  Fcanvas.Pen.Color:= clBlack; //clGreen;//clActiveCaption;
  Fcanvas.MoveTo(Self.Width-5-1,5+1);
  Fcanvas.LineTo(Self.Width-20+1,5+1);
  Fcanvas.LineTo(Self.Width-20+1,Self.Height-5-1);

  Fcanvas.Pen.Color:= clWindowFrame; //clGreen;//clActiveCaption;
  Fcanvas.MoveTo(Self.Width-5-5,5+25+1);
  Fcanvas.LineTo(Self.Width-5-5,Self.Height-5-25);
  Fcanvas.LineTo(Self.Width-20+5,Self.Height-5-25);
end;

{ TDraftHorizontalScrollView }

constructor TDraftHorizontalScrollView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jHorizontalScrollView(AWidget).BackgroundColor;

  if jHorizontalScrollView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftHorizontalScrollView.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clMedGray;

  if Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
  Fcanvas.TextOut(12, 9, jHorizontalScrollView(FAndroidWidget).Text);

(*  TODO :: Horizontal!
  Fcanvas.Brush.Style:= bsSolid;
  Fcanvas.Brush.Color:= clWhite;
  Fcanvas.FillRect(Self.Width-20,5,Self.Width-5,Self.Height-5);

  Fcanvas.Brush.Color:= clMedGray; //Self.BackGroundColor;
  Fcanvas.FillRect(Self.Width-20+5,5+25,Self.Width-5-5,Self.Height-5-25);

  Fcanvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;
  Fcanvas.Frame(Self.Width-20,5,Self.Width-5,Self.Height-5);

  Fcanvas.Pen.Color:= clBlack; //clGreen;//clActiveCaption;
  Fcanvas.MoveTo(Self.Width-5-1,5+1);
  Fcanvas.LineTo(Self.Width-20+1,5+1);
  Fcanvas.LineTo(Self.Width-20+1,Self.Height-5-1);

  Fcanvas.Pen.Color:= clWindowFrame; //clGreen;//clActiveCaption;
  Fcanvas.MoveTo(Self.Width-5-5,5+25+1);
  Fcanvas.LineTo(Self.Width-5-5,Self.Height-5-25);
  Fcanvas.LineTo(Self.Width-20+5,Self.Height-5-25);
  *)

end;

{ TDraftRadioGroup}

constructor TDraftRadioGroup.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jRadioGroup(AWidget).BackgroundColor;

  if jRadioGroup(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftRadioGroup.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;

  if Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame

  Fcanvas.TextOut(12, 9, jRadioGroup(FAndroidWidget).Text);
end;

{ TDraftRatingBar}

constructor TDraftRatingBar.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jRatingBar(AWidget).BackgroundColor;

  if jRatingBar(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftRatingBar.Draw;

  procedure DrawStar(cx, cy: Integer);
  const
    R1 = 18.8;
    R2 = 8.4;
  var
    i: Integer;
    p: array of TPoint;
  begin
    SetLength(p, 5*2);
    for i := 0 to 4 do
    begin
      with p[i * 2] do
      begin
        x := cx + Round(R1 * Sin(i * 72 * pi / 180));
        y := cy - Round(R1 * Cos(i * 72 * pi / 180));
      end;
      with p[i * 2 + 1] do
      begin
        x := cx + Round(R2 * Sin((i + 0.5) * 72 * pi / 180));
        y := cy - Round(R2 * Cos((i + 0.5) * 72 * pi / 180));
      end;
    end;
    with FCanvas.Brush do
    begin
      Style := bsSolid;
      Color := RGBToColor(183, 183, 183);
    end;
    with FCanvas.Pen do
    begin
      Style := psSolid;
      Width := 1;
      Color := BlendColors(BackGroundColor, 62/114, 2, 2, 2);
    end;
    FCanvas.Polygon(p);
  end;

var
  i: Integer;
begin
  with Fcanvas do
  begin
    Brush.Color := BackGroundColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, Self.Width, Self.Height)
  end;
  for i := 0 to jRatingBar(FAndroidWidget).NumStars - 1 do
    DrawStar(24 + 48 * i, 6 + 19)
end;

procedure TDraftRatingBar.UpdateLayout;
begin
  with jRatingBar(FAndroidWidget) do
  begin
    if LayoutParamHeight = lpWrapContent then
      FMinHeight := 57;
    if LayoutParamWidth = lpWrapContent then
      FMinWidth := 48 * NumStars;
  end;
  inherited UpdateLayout;
end;

{ TDraftDigitalClock}

constructor TDraftDigitalClock.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jDigitalClock(AWidget).BackgroundColor;

  if jDigitalClock(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

{ TDraftAnalogClock }

constructor TDraftAnalogClock.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;

  Color := jAnalogClock(AWidget).BackgroundColor;

  if jAnalogClock(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

{ TDraftToggleButton }

constructor TDraftToggleButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor := clActiveCaption;; //clMenuHighlight;
  Color := jToggleButton(AWidget).BackgroundColor;
  FontColor := colbrGray;

  FOnOff := jToggleButton(AWidget).State <> tsOff
  {
  if jToggleButton(AWidget).BackgroundColor = colbrDefault then
    if AWidget.Parent is jPanel then
    begin
      Color := jPanel(AWidget.Parent).BackgroundColor;
    end else
    if AWidget.Parent is jCustomDialog then
    begin
      Color := jCustomDialog(AWidget.Parent).BackgroundColor;
    end;
  }
end;

procedure TDraftToggleButton.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clWhite;
  Fcanvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
     Fcanvas.Brush.Color:= clSilver; //clMedGray;

  if Self.TextColor = clNone then
      Fcanvas.Font.Color:= clBlack;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Pen.Color:= clWindowFrame;
  if Self.FOnOff = True then  //on
  begin

    Fcanvas.Brush.Style:= bsSolid;
    Fcanvas.Brush.Color:= clSkyBlue;
    Fcanvas.FillRect(Self.MarginRight-4,
                    Self.MarginTop-3,
                    Self.Width-Self.MarginLeft+2,
                    Self.Height-Self.MarginBottom+3);

    Fcanvas.Brush.Style:= bsClear;
    Fcanvas.Pen.Color:= clWindowFrame;

     Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.MarginTop-3,  {y1}
             Self.Width-Self.MarginRight+3,  {x2}
             Self.Height-Self.MarginBottom+3); {y2}

     Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.Height-Self.MarginBottom+3,{y2}
             Self.MarginLeft-4,                {x1}
             Self.Height-Self.MarginBottom+3);  {y2}


     Fcanvas.Pen.Color:= clWhite;
     Fcanvas.Line(Self.MarginLeft-4, {x1}
                   Self.MarginTop-3,  {y1}
                   Self.MarginLeft-4, {x1}
                   Self.Height-Self.MarginBottom+3); {y2}

     Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
                Self.MarginTop-3,  {y1}
                Self.MarginLeft-4, {x1}
                Self.MarginTop-3);{y1}
  end
  else  //off
  begin
    (*
    Fcanvas.Brush.Style:= bsSolid;
    Fcanvas.Brush.Color:= clSkyBlue;
    Fcanvas.FillRect(Self.MarginRight-4,
                    Self.MarginTop-3,
                    Self.Width-Self.MarginLeft+2,
                    Self.Height-Self.MarginBottom+3);

    *)
    Fcanvas.Brush.Style:= bsClear;
    Fcanvas.Pen.Color:= clWindowFrame;

    //V
    Fcanvas.Line(Self.MarginLeft-4, {x1}
               Self.MarginTop-3,  {y1}
               Self.MarginLeft-4, {x1}
               Self.Height-Self.MarginBottom+3); {y2}

     //H
    Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.MarginLeft-4, {x1}
            Self.MarginTop-3);{y1}

    Fcanvas.Pen.Color:= clWhite;
    Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.Width-Self.MarginRight+3,  {x2}
            Self.Height-Self.MarginBottom+3); {y2}

    Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.Height-Self.MarginBottom+3,{y2}
            Self.MarginLeft-4,                {x1}
            Self.Height-Self.MarginBottom+3);  {y2}


  end;
end;

{ TDraftSwitchButton }

procedure TDraftSwitchButton.Draw;
var
  x, y, z, i, ps: Integer;
  r, rb: TRect;
  ts: TTextStyle;
  s: string;
begin
  with FCanvas do
  begin
    if BackGroundColor = clNone then
      BackGroundColor := GetBackGroundColor
    else begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, Self.Width, Self.Height);
    end;
    x := Self.Height div 2 - 12;
    Brush.Color := BlendColors(BackGroundColor, 0.7, 153,153,153);
    ps := Font.Size;
    Font.Size := 10;
    with jSwitchButton(FAndroidWidget) do
    begin
      y := TextWidth(TextOn);
      z := TextWidth(TextOff);
      if y < z then y := z;
      y := y + 22; // button width

      i := 2 * (y + 2);
      if i < 92 then i := 92;
      z := Self.Width - 2 - i;
      rb := Rect(z, x, z + i, x + 24);

      FillRect(rb);
      if State = tsOff then
      begin
        z := rb.Left + 1;
        Brush.Color := BlendColors(Self.BackgroundColor, 0.414, 153,153,153);
        Font.Color := RGBToColor(234,234,234);
        s := TextOff;
      end else begin
        z := rb.Right - 1 - y;
        Brush.Color := BlendColors(Self.BackgroundColor, 0.14, 11,153,200);
        Font.Color := clWhite;
        s := TextOn;
      end;
    end;
    r := Rect(z, x + 1, z + y, x + 23);
    FillRect(r);
    ts := TextStyle;
    ts.Layout := tlCenter;
    ts.Alignment := Classes.taCenter;
    TextRect(r, 0, 0, s, ts);
    Font.Size := ps;
  end;
end;

procedure TDraftSwitchButton.UpdateLayout;
var
  ps, x, y: Integer;
begin
  FMinHeight := 28;
  with jSwitchButton(FAndroidWidget) do
  begin
    if LayoutParamWidth = lpWrapContent then
      with FCanvas do
      begin
        ps := Font.Size;
        Font.Size := 10;
        x := TextWidth(TextOn);
        y := TextWidth(TextOff);
        if y > x then x := y;
        x := 2 * (x + 22 + 2);
        if x < 92 then x := 92;
        x := x + 4;
        FMinWidth := x;
        Font.Size := ps;
      end;
    if LayoutParamHeight = lpWrapContent then
      FMinHeight := 28
  end;
  inherited;
end;

{TDraftGridView}

constructor TDraftGridView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Color := jGridView(AWidget).BackgroundColor;
  if jGridView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

procedure TDraftGridView.Draw;
var
  i, k: integer;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
  // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);
  Fcanvas.Brush.Style:= bsSolid;
  Fcanvas.Pen.Color:= clSilver;

  //H lines
  k:= Trunc((Self.Height-Self.MarginTop-Self.MarginBottom)/70);
  for i:= 1 to k do
  begin
    Fcanvas.MoveTo(Self.Width-Self.MarginRight+10, {x2} Self.MarginTop+i*70); {y1}
    Fcanvas.LineTo(Self.MarginLeft-10,Self.MarginTop+i*70);  {x1, y1}
  end;

  //V  lines
  k:= Trunc((Self.Width-Self.MarginLeft-Self.MarginRight)/70);
  for i:= 1 to k do
  begin
    Fcanvas.MoveTo((Self.MarginLeft-10)+i*70, Self.MarginTop-10);  {x1, y1}
    Fcanvas.LineTo((Self.MarginLeft-10)+i*70, Self.Height); {y1}
  end;
end;

{ TDraftView }

constructor TDraftView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Color := jView(AWidget).BackgroundColor;

  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;

  if jView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;

   { TDraftTreeListView }

constructor TDraftTreeListView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Color := jTreeListView(AWidget).BackgroundColor;

  FontColor:= colbrGray;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;

  if jTreeListView(AWidget).BackgroundColor = colbrDefault then
    Color := GetParentBackgroundColor;
end;


initialization
  DraftClassesMap := TDraftControlHash.Create(128); // should be power of 2 for efficiency
  RegisterPropertyEditor(TypeInfo(TARGBColorBridge), nil, '', TARGBColorBridgePropertyEditor);
  RegisterPropertyEditor(TypeInfo(jVisualControl), jVisualControl, 'Anchor', TAnchorPropertyEditor);
  RegisterComponentEditor(jForm, TAndroidFormComponentEditor);
  RegisterPropertyEditor(TypeInfo(Integer), jForm, 'Width', TAndroidFormSizePropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), jForm, 'Height', TAndroidFormSizePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TStrings), jImageList, 'Images', TjImageListImagesEditor);
  RegisterComponentEditor(jImageList, TjImageListEditor);
  RegisterComponentEditor(jCustomDialog, TjCustomDialogComponentEditor);
  RegisterPropertyEditor(TypeInfo(TImageListIndex), jControl, '', TImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(jImageList), nil, '', TImageListPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jImageBtn, 'ImageUpIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jImageBtn, 'ImageDownIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jImageView, 'ImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jImageButton, 'ImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jZoomableImageView, 'ImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jListView, 'ImageItemIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jForm, 'BackgroundImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jBitmap, 'ImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jsFloatingButton, 'ImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jsContinuousScrollableImageView, 'ImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jsToolbar, 'LogoIconIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jsToolbar, 'NavigationIconIdentifier', TImageIdentifierPropertyEditor);

  RegisterPropertyEditor(TypeInfo(string), jsNavigationView, 'HeaderBackgroundImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jsNavigationView, 'HeaderLogoImageIdentifier', TImageIdentifierPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), jEditText, 'ActionIconIdentifier', TImageIdentifierPropertyEditor);
  // DraftClasses registeration:
  //  * default drawing and anchoring => use TDraftWidget
  //    (it is not needed to create draft class without custom drawing)
  //  * do not register custom draft class for default drawing w/o anchoring
  //    (default drawing is implemented in Mediator.Paint)
  RegisterAndroidWidgetDraftClass(jProgressBar, TDraftProgressBar);
  RegisterAndroidWidgetDraftClass(jSeekBar, TDraftSeekBar);
  RegisterAndroidWidgetDraftClass(jButton, TDraftButton);
  RegisterAndroidWidgetDraftClass(KToyButton, TDraftKToyButton);
  RegisterAndroidWidgetDraftClass(jCheckBox, TDraftCheckBox);
  RegisterAndroidWidgetDraftClass(jRadioButton, TDraftRadioButton);
  RegisterAndroidWidgetDraftClass(jTextView, TDraftTextView);
  RegisterAndroidWidgetDraftClass(jPanel, TDraftPanel);
  RegisterAndroidWidgetDraftClass(jEditText, TDraftEditText);
  RegisterAndroidWidgetDraftClass(jToggleButton, TDraftToggleButton);
  RegisterAndroidWidgetDraftClass(jSwitchButton, TDraftSwitchButton);
  RegisterAndroidWidgetDraftClass(jListView, TDraftListView);
  RegisterAndroidWidgetDraftClass(jExpandableListView, TDraftExpandableListView);
  RegisterAndroidWidgetDraftClass(jGridView, TDraftGridView);
  RegisterAndroidWidgetDraftClass(jDBListView, TDraftDBListView);
  RegisterAndroidWidgetDraftClass(jTreeListView, TDraftTreeListView);
  RegisterAndroidWidgetDraftClass(jImageBtn, TDraftImageBtn);

  RegisterAndroidWidgetDraftClass(jImageView, TDraftImageView);
  RegisterAndroidWidgetDraftClass(jImageButton, TDraftImageButton);

  RegisterAndroidWidgetDraftClass(jZoomableImageView, TDraftZoomableImageView);
  RegisterAndroidWidgetDraftClass(jSurfaceView, TDraftSurfaceView);
 // RegisterAndroidWidgetDraftClass(jGL2SurfaceView, TDraftGL2SurfaceView);
  RegisterAndroidWidgetDraftClass(jCustomCamera, TDraftCustomCamera);
  RegisterAndroidWidgetDraftClass(jWebView, TDraftWebView);
  RegisterAndroidWidgetDraftClass(jScrollView, TDraftScrollView);
  RegisterAndroidWidgetDraftClass(jHorizontalScrollView, TDraftHorizontalScrollView);
  RegisterAndroidWidgetDraftClass(jRadioGroup, TDraftRadioGroup);
  RegisterAndroidWidgetDraftClass(jRatingBar, TDraftRatingBar);
  RegisterAndroidWidgetDraftClass(jAnalogClock, TDraftAnalogClock);
  RegisterAndroidWidgetDraftClass(jDigitalClock, TDraftDigitalClock);
  RegisterAndroidWidgetDraftClass(jSpinner, TDraftSpinner);
  RegisterAndroidWidgetDraftClass(jView, TDraftView);
  RegisterAndroidWidgetDraftClass(jAutoTextView, TDraftAutoTextView);
  RegisterAndroidWidgetDraftClass(jComboEditText, TDraftComboEditText);
  RegisterAndroidWidgetDraftClass(jDrawingView, TDraftDrawingView);

  // TODO::(default drawing and layout)
  RegisterAndroidWidgetDraftClass(jCanvasES2, TDraftWidget);
  RegisterAndroidWidgetDraftClass(jCanvasES1, TDraftWidget);

  RegisterAndroidWidgetDraftClass(jChronometer, TDraftWidget);
  RegisterAndroidWidgetDraftClass(jViewFlipper, TDraftWidget);
  RegisterAndroidWidgetDraftClass(jVideoView, TDraftWidget);

  RegisterAndroidWidgetDraftClass(jToolbar, TDraftToolbar);
  RegisterAndroidWidgetDraftClass(jFrameLayout, TDraftFrameLayout);
  RegisterAndroidWidgetDraftClass(jZBarcodeScannerView, TDraftZBarcodeScannerView);

  RegisterAndroidWidgetDraftClass(jLinearLayout, TDraftLinearLayout);
  RegisterAndroidWidgetDraftClass(jTableLayout, TDraftTableLayout);
  RegisterAndroidWidgetDraftClass(jCaptionPanel, TDraftCaptionPanel);
  RegisterAndroidWidgetDraftClass(jCalendarView, TDraftCalendarView);
  RegisterAndroidWidgetDraftClass(jSearchView, TDraftSearchView);

  RegisterAndroidWidgetDraftClass(jsFloatingButton, TDraftSFloatingButton);
  RegisterAndroidWidgetDraftClass(jsBottomNavigationView, TDraftSBottomNavigationView);
  RegisterAndroidWidgetDraftClass(jsCoordinatorLayout, TDraftSCoordinatorLayout);
  RegisterAndroidWidgetDraftClass(jsToolbar, TDraftSToolbar);

  RegisterAndroidWidgetDraftClass(jsDrawerLayout, TDraftSDrawerLayout);
  RegisterAndroidWidgetDraftClass(jsNavigationView, TDraftSNavigationView);
  RegisterAndroidWidgetDraftClass(jsCardView, TDraftSCardView);
  RegisterAndroidWidgetDraftClass(jsRecyclerView, TDraftSRecyclerView);

  RegisterAndroidWidgetDraftClass(jsTextInput, TDraftSTextInput);
  RegisterAndroidWidgetDraftClass(jsViewPager, TDraftSViewPager);
  RegisterAndroidWidgetDraftClass(jsTabLayout, TDraftSTabLayout);
  RegisterAndroidWidgetDraftClass(jsAppBarLayout, TDraftSAppBarLayout);

  RegisterAndroidWidgetDraftClass(jsCollapsingToolbarLayout, TDraftSCollapsingToolbarLayout);
  RegisterAndroidWidgetDraftClass(jsNestedScrollView, TDraftSNestedScrollView);
  RegisterAndroidWidgetDraftClass(jsAdMob, TDraftSAdMob);

  RegisterAndroidWidgetDraftClass(jsContinuousScrollableImageView, TDraftSContinuousScrollableImageView);
  RegisterAndroidWidgetDraftClass(jcOpenMapView, TDraftCOpenMapView);
  RegisterAndroidWidgetDraftClass(jcSignaturePad, TDraftCSignaturePad);

finalization
  DraftClassesMap.Free;
end.

