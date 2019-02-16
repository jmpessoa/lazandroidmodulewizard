unit gridview;

{$mode delphi}

{Draft Component code by "Lazarus Android Module Wizard" [1/9/2015 21:12:18]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, systryparent;

const
  DEFAULT_COLCOUNT=4;
  DEFAULT_ROWCOUNT=1;

type

  TOnClickGridItem = procedure(Sender: TObject; ItemIndex: integer; itemCaption: string) of object;
  TGridItemLayout = (ilImageText, ilTextImage);
  TGridStretchMode = (smNone, smSpacingWidth, smColumnWidth, smSpacingWidthUniform);
  {
  0  Stretching is disabled.
  1  The spacing between each column is stretched.
  2  Each column is stretched equally.
  3  The spacing between each column is uniformly stretched
  }

  { Additions by Tintinux
    - R/W access to cell's contents, by Cells[Col,Row]
    - New public methods : AddCol, DeleteCol, AddRow, DeleteRow

    The content is stored in a private unidimensional dynamic array (FCells)
    It seems that the content is already stored via an "Adapter" linked to the
    jGridView object but I did'nt found how to access it...if anyone knows, he is welcome

    if a cell is set with a row greater than rowcount, new cells(s) will be added
    before with a blank content. One space and not the empty string (not working).
  }
  TCell = record
    Item, ImgIdentifier: string;
  end;
  TCells = array of TCell;

  { jGridView }
  jGridView = class(jVisualControl)
  private
    FOnClickGridItem: TOnClickGridItem;
    FOnLongClickGridItem: TOnClickGridItem;
    FOnDrawItemTextColor: TOnDrawItemTextColor;
    FOnDrawItemBitmap: TOnDrawItemBitmap;
    FColCount: integer; {new name of FColumns confusing with TStringGrid}
    FRowCount: integer;
    FItemCount:integer;
    FItemsLayout: TGridItemLayout;
    // added by tintinux
    FCells: TCells;

    function GetImages(ACol, ARow: integer): string;
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure SetImages(ACol, ARow: integer; AImgIdentifier: string);
    procedure SetRowCount(AValue: integer);
    
    // added by tintinux
    function GetImgIdentifier(const col, row: integer): string;
    procedure BlankValue(const I: integer);
    procedure DeleteItems(const Start: integer);
    procedure RestoreItems(const Start: integer);
    procedure ShiftValue(const Dest, From: integer);
    function Count: integer;
    function GetCells(ACol, ARow: integer): string;
    function GetColCount: integer;
    function GetRowCount: integer;
    procedure SetCells(ACol, ARow: integer; AValue: string);
    procedure SetCellAndImg(const col, row: integer; const Item: string = '';
      const ImgIdentifier: string = '');
    procedure SetColCount(AValue: integer);
    function CoordToIndex(const col, row: integer): integer;
    procedure AddInternal(_item: string; _imgIdentifier: string);
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure GenEvent_OnClickGridItem(Obj: TObject; position: integer; Caption: string);
    procedure GenEvent_OnLongClickGridItem(Obj: TObject; position: integer;
      Caption: string);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer;
      _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetNumColumns(_value: integer);
    procedure SetColumnWidth(_value: integer);
    procedure Clear();
    procedure Delete(_index: integer);
    procedure SetItemsLayout(_value: TGridItemLayout);
    function GetItemIndex(): integer;
    function GetItemCaption(): string;
    procedure DispatchOnDrawItemTextColor(_value: boolean);
    procedure DispatchOnDrawItemBitmap(_value: boolean);
    procedure SetFontSize(_size: Dword);
    procedure SetFontColor(_color: TARGBColorBridge);
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure UpdateItemTitle(_index: integer; _title: string);
    procedure SetHorizontalSpacing(_horizontalSpacingPixels: integer);
    procedure SetVerticalSpacing(_verticalSpacingPixels: integer);
    procedure SetSelection(_index: integer);
    procedure SetStretchMode(_stretchMode: TGridStretchMode);
    procedure GenEvent_OnDrawItemCaptionColor(Obj: TObject; index: integer;
      Caption: string; out color: dword);
    procedure GenEvent_OnDrawItemBitmap(Obj: TObject; index: integer;
      Caption: string; out bitmap: JObject);
    // added by Tintinux
    procedure IndexToCoord(const index: integer; out col, row: integer);
    procedure Add(const Item: string = ''; const ImgIdentifier: string = '');
    procedure AddRow(AfterRow: integer = -1);
    procedure DeleteRow(const Row: integer);
    procedure AddCol(const AfterCol: integer = -1);
    procedure DeleteCol(const Col: integer);
    property Cells[ACol, ARow: integer]: string read GetCells write SetCells;
    property Images[ACol, ARow: integer]: string read GetImages write SetImages;
  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Columns: integer read FColCount write SetNumColumns; deprecated 'Please, use ColCount instead';
    property ItemsLayout: TGridItemLayout read FItemsLayout write SetItemsLayout;
    property FontSize: Dword read FFontSize write SetFontSize;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property OnClickItem: TOnClickGridItem read FOnClickGridItem write FOnClickGridItem;
    property OnLongClickItem: TOnClickGridItem
      read FOnLongClickGridItem write FOnLongClickGridItem;
    property OnDrawItemTextColor: TOnDrawItemTextColor
      read FOnDrawItemTextColor write FOnDrawItemTextColor;
    property OnDrawItemBitmap: TOnDrawItemBitmap
      read FOnDrawItemBitmap write FOnDrawItemBitmap;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    // added by tintinux
    property RowCount: integer read GetRowCount write SetRowCount;
    property ColCount: integer read GetColCount write SetColCount;
  end;

// for test only (can be removed)
//function GridView_PrintCoord(const col, row: integer): string;
//procedure GridView_Log ( test : string; text1 : string = ''; value1 : integer = 0 );

function jGridView_jCreate(env: PJNIEnv; _Self: int64; this: jObject): jObject;
procedure jGridView_jFree(env: PJNIEnv; _jgridview: JObject);
procedure jGridView_SetViewParent(env: PJNIEnv; _jgridview: JObject;
  _viewgroup: jObject);
procedure jGridView_RemoveFromViewParent(env: PJNIEnv; _jgridview: JObject);
function jGridView_GetView(env: PJNIEnv; _jgridview: JObject): jObject;
procedure jGridView_SetLParamWidth(env: PJNIEnv; _jgridview: JObject; _w: integer);
procedure jGridView_SetLParamHeight(env: PJNIEnv; _jgridview: JObject; _h: integer);
procedure jGridView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv;
  _jgridview: JObject; _left: integer; _top: integer; _right: integer;
  _bottom: integer; _w: integer; _h: integer);
procedure jGridView_AddLParamsAnchorRule(env: PJNIEnv; _jgridview: JObject;
  _rule: integer);
procedure jGridView_AddLParamsParentRule(env: PJNIEnv; _jgridview: JObject;
  _rule: integer);
procedure jGridView_SetLayoutAll(env: PJNIEnv; _jgridview: JObject; _idAnchor: integer);
procedure jGridView_ClearLayoutAll(env: PJNIEnv; _jgridview: JObject);
procedure jGridView_SetId(env: PJNIEnv; _jgridview: JObject; _id: integer);
procedure jGridView_Add(env: PJNIEnv; _jgridview: JObject; _item: string;
  _imgIdentifier: string);
procedure jGridView_SetNumColumns(env: PJNIEnv; _jgridview: JObject; _value: integer);
procedure jGridView_SetColumnWidth(env: PJNIEnv; _jgridview: JObject; _value: integer);
procedure jGridView_Clear(env: PJNIEnv; _jgridview: JObject);
procedure jGridView_Delete(env: PJNIEnv; _jgridview: JObject; _index: integer);
procedure jGridView_SetItemsLayout(env: PJNIEnv; _jgridview: JObject; _value: integer);
function jGridView_GetItemIndex(env: PJNIEnv; _jgridview: JObject): integer;
function jGridView_GetItemCaption(env: PJNIEnv; _jgridview: JObject): string;

procedure jGridView_DispatchOnDrawItemTextColor(env: PJNIEnv;
  _jgridview: JObject; _value: boolean);
procedure jGridView_DispatchOnDrawItemBitmap(env: PJNIEnv; _jgridview: JObject;
  _value: boolean);
procedure jGridView_SetFontSize(env: PJNIEnv; _jgridview: JObject; _size: integer);
procedure jGridView_SetFontColor(env: PJNIEnv; _jgridview: JObject; _color: integer);
procedure jGridView_SetFontSizeUnit(env: PJNIEnv; _jgridview: JObject; _unit: integer);
procedure jGridView_UpdateItemTitle(env: PJNIEnv; _jgridview: JObject;
  _index: integer; _title: string);

procedure jGridView_SetHorizontalSpacing(env: PJNIEnv; _jgridview: JObject;
  _horizontalSpacingPixels: integer);
procedure jGridView_SetVerticalSpacing(env: PJNIEnv; _jgridview: JObject;
  _verticalSpacingPixels: integer);
procedure jGridView_SetSelection(env: PJNIEnv; _jgridview: JObject; _index: integer);
procedure jGridView_SetStretchMode(env: PJNIEnv; _jgridview: JObject;
  _stretchMode: integer);

implementation

{---------  jGridView  --------------}

constructor jGridView.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  FMarginLeft := 10;
  FMarginTop := 10;
  FMarginBottom := 10;
  FMarginRight := 10;
  FLParamWidth := lpMatchParent;
  FLParamHeight := lpMatchParent;
  FHeight := 160; //??
  FWidth := 96; //??
  FAcceptChildrenAtDesignTime := False;
  FItemsLayout := ilImageText;
  Clear;
  SetLength(FCells, 0);
  FColCount := 0;
  FRowCount := 0;
  FItemCount := 0;
end;

destructor jGridView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jFree();
      FjObject := nil;
    end;
  end;
  SetLength(FCells, 0);
  inherited Destroy;
end;

procedure jGridView.Loaded;

begin
  inherited Loaded;
  if FColCount < 0 then
    FColCount := DEFAULT_COLCOUNT ;
  if RowCount < 0 then
    FRowCount := DEFAULT_ROWCOUNT;
end;

procedure jGridView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   FjObject := jCreate(); //jSelf !

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jGridView_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jGridView_SetId(FjEnv, FjObject, Self.Id);
  end;

  jGridView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jGridView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jGridView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then
    Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1; //dummy

  jGridView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFontColor <> colbrDefault then
    jGridView_SetFontColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

   if FFontSizeUnit <> unitDefault then
    jGridView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

   if FFontSize <> 0 then
    jGridView_SetFontSize(FjEnv, FjObject, FFontSize);

   if FItemsLayout <> ilImageText then
    jGridView_SetItemsLayout(FjEnv, FjObject, Ord(FItemsLayout));

   if FColCount <> -1 then
    jGridView_SetNumColumns(FjEnv, FjObject, FColCount);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jGridView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

//==== Added by tintinux

//--------------------------------------------------------------------------
// if rowcount is increased, add new rows at the bottom
// if rowcount is decreased, delete rows from the bottom
//--------------------------------------------------------------------------
procedure jGridView.SetRowCount(AValue: integer);

begin
  if AValue = FRowCount then
    exit;
  while RowCount > aValue do
    DeleteRow(RowCount - 1);
  while RowCount < aValue do
    AddRow(RowCount - 1);
end;

//--------------------------------------------------------------------------
// returns item value in a cell by its coordinates
// don't raise an error but returns empty string if col or row is out of range
//--------------------------------------------------------------------------
function jGridView.GetCells(ACol, ARow: integer): string;

begin
  if (Acol < 0) or (Acol >= ColCount) or (aRow < 0) or (ARow >= RowCount) then
    Result := ''
  else
    Result := FCells[CoordToIndex(aCol, aRow)].Item;
end;

//--------------------------------------------------------------------------
// returns image in a cell by its coordinates
// don't raise an error but returns empty string if col or row is out of range
//--------------------------------------------------------------------------
function jGridView.GetImages(ACol, ARow: integer): string;

begin
  if (Acol < 0) or (Acol >= ColCount) or (aRow < 0) or (ARow >= RowCount) then
    Result := ''
  else
    Result := FCells[CoordToIndex(aCol, aRow)].ImgIdentifier;
end;

function jGridView.GetRowCount: integer;

begin
  result := FRowCount;
end;

procedure jGridView.SetCells(ACol, ARow: integer; AValue: string);
begin
  SetCellAndImg(aCol, aRow, aValue);
end;

procedure jGridView.SetImages(ACol, ARow: integer; AImgIdentifier: string);

begin
  SetCellAndImg(aCol, aRow, Cells[ACol,ARow], aImgIdentifier);
end;

//==== end added by tintinux

procedure jGridView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jGridView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jGridView.GenEvent_OnClickGridItem(Obj: TObject; position: integer;
  Caption: string);
begin
  if Assigned(FOnClickGridItem) then
    FOnClickGridItem(Obj, position, Caption);
end;

procedure jGridView.GenEvent_OnLongClickGridItem(Obj: TObject;
  position: integer; Caption: string);
begin
  if Assigned(FOnLongClickGridItem) then
    FOnLongClickGridItem(Obj, position, Caption);
end;

function jGridView.jCreate(): jObject;
begin
  Result := jGridView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGridView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_jFree(FjEnv, FjObject);
end;

procedure jGridView.SetViewParent(_viewgroup: jObject);
begin
  inherited SetViewParent(_viewgroup);
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jGridView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jGridView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jGridView_GetView(FjEnv, FjObject);
end;

procedure jGridView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jGridView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jGridView.SetLeftTopRightBottomWidthHeight(_left: integer;
  _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
      _left, _top, _right, _bottom, _w, _h);
end;

procedure jGridView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jGridView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jGridView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jGridView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jGridView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jGridView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jGridView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jGridView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetId(FjEnv, FjObject, _id);
end;

procedure jGridView.AddInternal(_item: string; _imgIdentifier: string);
begin
  if FInitialized then
  begin
    // workaround because adding empty _item does nothing
    if (_item = '') and (_imgIdentifier = '') then
      _item := ' ';
    jGridView_Add(FjEnv, FjObject, _item, _imgIdentifier);
    inc(FItemCount);
  end;
end;

procedure jGridView.SetNumColumns(_value: integer);
begin
  //in designing component state: set value here...
  FColCount := _value;
  if FInitialized then
    jGridView_SetNumColumns(FjEnv, FjObject, _value);
end;

procedure jGridView.SetColumnWidth(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetColumnWidth(FjEnv, FjObject, _value);
end;

procedure jGridView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_Clear(FjEnv, FjObject);
end;

procedure jGridView.Delete(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    begin
    jGridView_Delete(FjEnv, FjObject, _index);
    Dec(FItemCount);
    end;
end;

procedure jGridView.SetItemsLayout(_value: TGridItemLayout);
begin
  //in designing component state: set value here...
  FItemsLayout := _value;
  if FInitialized then
    jGridView_SetItemsLayout(FjEnv, FjObject, Ord(_value));
end;

function jGridView.GetItemIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jGridView_GetItemIndex(FjEnv, FjObject);
end;

function jGridView.GetItemCaption(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result := jGridView_GetItemCaption(FjEnv, FjObject);
end;

procedure jGridView.DispatchOnDrawItemTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_DispatchOnDrawItemTextColor(FjEnv, FjObject, _value);
end;

procedure jGridView.DispatchOnDrawItemBitmap(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_DispatchOnDrawItemBitmap(FjEnv, FjObject, _value);
end;

procedure jGridView.SetFontSize(_size: Dword);
begin
  //in designing component state: set value here...
  FFontSize := _size;
  if FInitialized then
    jGridView_SetFontSize(FjEnv, FjObject, _size);
end;

procedure jGridView.SetFontColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontColor := _color;
  if FInitialized then
    jGridView_SetFontColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jGridView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FInitialized then
    jGridView_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jGridView.GenEvent_OnDrawItemCaptionColor(Obj: TObject;
  index: integer; Caption: string; out color: dword);
var
  outColor: TARGBColorBridge;
begin
  outColor := Self.FontColor;
  color := 0; //default;
  if Assigned(FOnDrawItemTextColor) then
    FOnDrawItemTextColor(Obj, index, Caption, outColor);
  if (outColor <> colbrNone) and (outColor <> colbrDefault) then
    color := GetARGB(FCustomColor, outColor);
end;

procedure jGridView.GenEvent_OnDrawItemBitmap(Obj: TObject; index: integer;
  Caption: string; out bitmap: JObject);
begin
  bitmap := nil;
  if Assigned(FOnDrawItemBitmap) then
    FOnDrawItemBitmap(Obj, index, Caption, bitmap);
end;

function jGridView.Count: integer;
begin
  Result := Length(FCells);
end;

procedure jGridView.UpdateItemTitle(_index: integer; _title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_UpdateItemTitle(FjEnv, FjObject, _index, _title);
end;

procedure jGridView.SetHorizontalSpacing(_horizontalSpacingPixels: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetHorizontalSpacing(FjEnv, FjObject, _horizontalSpacingPixels);
end;

procedure jGridView.SetVerticalSpacing(_verticalSpacingPixels: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetVerticalSpacing(FjEnv, FjObject, _verticalSpacingPixels);
end;

procedure jGridView.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetSelection(FjEnv, FjObject, _index);
end;

procedure jGridView.SetStretchMode(_stretchMode: TGridStretchMode);
begin
  //in designing component state: set value here...
  if FInitialized then
    jGridView_SetStretchMode(FjEnv, FjObject, Ord(_stretchMode));
end;

///----  Added by tintinux

procedure jGridView.IndexToCoord(const index: integer; out col, row: integer);

begin
  Row := Index div FColCount;
  Col := Index mod FColCount;
end;

function jGridView.CoordToIndex(const col, row: integer): integer;

begin
  Result := Row * FColCount + Col;
end;

function jGridView.GetImgIdentifier(const col, row: integer): string;

begin
  Result := FCells[CoordToIndex(col, row)].ImgIdentifier;
end;

procedure jGridView.Add(const Item: string = ''; const ImgIdentifier: string = '');

var
  L: integer;

begin
  L := Length(FCells);
  AddInternal(Item, ImgIdentifier);
  SetLength(FCells, L + 1);
  FCells[L].Item := Item;
  FCells[L].ImgIdentifier := ImgIdentifier;
end;

procedure jGridView.ShiftValue ( const Dest, From : integer );

begin
  FCells[Dest].Item := FCells[From].Item;
  FCells[Dest].ImgIdentifier := FCells[From].ImgIdentifier;
end;

procedure jGridView.BlankValue ( const I : integer );

begin
  FCells[I].Item := ' ';
  FCells[I].ImgIdentifier := '';
end;

//-----------------------------------------------------------------------------
//  For debug
//-----------------------------------------------------------------------------
{
procedure GridView_Log ( test : string; text1 : string = ''; value1 : integer = 0 );

var
  Z : string ;

begin
z := test ;
if text1 <> '' then
  z += ' ' + text1 + '=' + inttostr(value1);
__android_log_write(ANDROID_LOG_INFO,'*****', Pchar(z) );
end;

function GridView_PrintCoord(const col, row: integer): string;
begin
  Result := IntToStr(Col) + 'x' + IntToStr(Row);
end;
}

//-----------------------------------------------------------------------------
//  Add or Insert a row after Row passed in parameter >= 0
//  Insert a row before first row when no parameter or parameter < 0
//-----------------------------------------------------------------------------
procedure jGridView.AddRow(AfterRow: integer = -1);

var
  i, start, col: integer;

begin
  if AfterRow < RowCount - 1 then
  begin
    //--> add a row before existing one
    // 1- increase FCells size
    SetLength(FCells, Count + ColCount);
    start := CoordToIndex(0, AfterRow + 1);
    // 3- Shift FCells values
    for I := Count - 1 downto start do
    begin
      if I <= Count - ColCount - 1 then
      begin
        ShiftValue(I + ColCount, I);
        Delete(I);
      end
      else
        BlankValue(I);
    end;
    // 3- add empty items for new row
    for I := 0 to ColCount - 1 do
      AddInternal('', '');
    // 4- restore existing rows
    RestoreItems(start + ColCount);
  end
  else
  begin
    //--> add after last row
    if FColCount <= 0 then
       FColCount := 1;
    col := Count mod FColCount;
    // 1- add missing cells before end of partial last row
    if col > 0 then
      for i := col to FColCount do
        Add('', '');
    // 2- add cells to make a new row
    for i := 1 to FColCount do
      Add('', '');
  end;
  FRowCount := FRowCount+1;
end;

//-----------------------------------------------------------------------------
// Delete 1 Row # passed in parameter
//-----------------------------------------------------------------------------
procedure jGridView.DeleteRow(const Row: integer);

var
  First, Last, P: integer;

begin
  Assert((Row >= 0) and (Row < RowCount));
  // items and cells to delete
  First := CoordToIndex(0, Row);
  Last := CoordToIndex(ColCount - 1, Row);
  if Last > Count - 1 then
    Last := Count - 1;
  // delete in jgrid
  for P := First to Last do
    Delete(First);
  // shift values and images in FCells
  for P := First + ColCount to Count - 1 do
  begin
    Fcells[P - ColCount].Item := Fcells[P].Item;
    Fcells[P - ColCount].ImgIdentifier := Fcells[P].ImgIdentifier;
  end;
  SetLength(FCells, Length(FCells) - (Last - First + 1));
  FRowCount := FRowCount-1;
end;

//-----------------------------------------------------------------------------
// Delete 1 Column # passed in parameter
//-----------------------------------------------------------------------------
procedure jGridView.DeleteCol(const Col: integer);

var
  I, NbItems, NbCols, NbRows, R : integer;

begin
  NbItems := Count ;
  NbCols := ColCount-1;
  NbRows := RowCount;
  SetLength( FCells, NbItems + NbRows );
  Assert((Col >= 0) and (Col < ColCount));
  // shift values
  for I := Col to NbItems-NbRows-1 do
    begin
    R := (I - Col) div (NbCols)+1;
    FCells[I].Item := FCells[I+R].Item;
    FCells[I].ImgIdentifier := FCells[I+R].ImgIdentifier ;
    end;
  DeleteItems ( Col );
  SetLength ( FCells, NbItems-NbRows);
  RestoreItems( Col );
  // to avoid use of deprecated Columns setter
  FColCount := NbCols;
  jGridView_SetNumColumns(FjEnv, FjObject, NbCols);
end;

//------------------------------------------------------------------------------
// Delete items from a position to the end
//------------------------------------------------------------------------------
procedure jGridView.DeleteItems ( const Start : integer );

var
  I : integer ;

begin
for I := Count-1 downto Start do
  begin
  if I < FItemCount then
    Delete(I);
  end;
end;

//------------------------------------------------------------------------------
// Re-create Items with values saved in FCells from a position to the end
//------------------------------------------------------------------------------
procedure jGridView.RestoreItems ( const Start : integer);

var
  I : integer ;

begin
  for I := Start to Count-1 do
    AddInternal(Fcells[I].Item, Fcells[I].ImgIdentifier );
end;

procedure jGridView.AddCol(const AfterCol: integer = -1);

var
  I, Start, NbItems, NbCols, NbRows, R, C : integer;

begin
  Start := CoordToIndex (AfterCol, 0)+1;
  NbItems := Count ;
  NbCols := ColCount+1;
  NbRows := RowCount;
  if NbRows < 0 then
    NbRows := 1;
  // increase FCells
  SetLength( FCells, NbItems + NbRows );
  // shift values
  for I := Count-1 downto Start do
    begin
    C := I mod NbCols;
    R := I div NbCols;
    if C = AfterCol+1 then
      BlankValue(I)
    else
      begin
      if C > AfterCol then
        inc(R);
      FCells[I].Item := FCells[I-R].Item;
      FCells[I].ImgIdentifier := FCells[I-R].ImgIdentifier ;
      end ;
    end;
  DeleteItems ( Start);
  RestoreItems(Start);
  FColCount := NbCols;
  jGridView_SetNumColumns(FjEnv, FjObject, NbCols);
end;

// To have the same property name as in StringGrid
function jGridView.GetColCount: integer;

begin
  Result := FColCount;
end;

procedure jGridView.SetCellAndImg(const col, row: integer;
  const Item: string = ''; const ImgIdentifier: string = '');

var
  i, p, l: integer;

begin
  Assert(Col < FColCount);
  P := CoordToIndex(Col, Row);

  // Add missing items and cells before
  while Count < P do
    Add('', '');
  L := Count;

  if L - 1 < P then
    SetLength(FCells, P + 1)
  else
    DeleteItems(P);

  // Add item with new value
  AddInternal(Item, ImgIdentifier);
  FCells[P].Item := Item;
  FCells[P].ImgIdentifier := ImgIdentifier;

  // Restore next items and values
  for I := P + 1 to L - 1 do
    AddInternal(FCells[I].Item, FCells[I].ImgIdentifier);
end;

procedure jGridView.SetColCount(AValue: integer);
begin
  if AValue = FColCount then
    exit;
  while ColCount > aValue do
    DeleteCol(ColCount - 1);
  while ColCount < aValue do
    AddCol(ColCount - 1);
end;

{-------- jGridView_JNI_Bridge ----------}

function jGridView_jCreate(env: PJNIEnv; _Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].j := _Self;
  jCls := Get_gjClass(env);
  jMethod := env^.GetMethodID(env, jCls, 'jGridView_jCreate', '(J)Ljava/lang/Object;');
  Result := env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result := env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jGridView_jCreate(long _Self) {
      return (java.lang.Object)(new jGridView(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jGridView_jFree(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetViewParent(env: PJNIEnv; _jgridview: JObject;
  _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].l := _viewgroup;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_RemoveFromViewParent(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGridView_GetView(env: PJNIEnv; _jgridview: JObject): jObject;
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result := env^.CallObjectMethod(env, _jgridview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetLParamWidth(env: PJNIEnv; _jgridview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _w;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetLParamHeight(env: PJNIEnv; _jgridview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _h;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv;
  _jgridview: JObject; _left: integer; _top: integer; _right: integer;
  _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _left;
  jParams[1].i := _top;
  jParams[2].i := _right;
  jParams[3].i := _bottom;
  jParams[4].i := _w;
  jParams[5].i := _h;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_AddLParamsAnchorRule(env: PJNIEnv; _jgridview: JObject;
  _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _rule;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_AddLParamsParentRule(env: PJNIEnv; _jgridview: JObject;
  _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _rule;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetLayoutAll(env: PJNIEnv; _jgridview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _idAnchor;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_ClearLayoutAll(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetId(env: PJNIEnv; _jgridview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _id;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_Add(env: PJNIEnv; _jgridview: JObject; _item: string;
  _imgIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].l := env^.NewStringUTF(env, PChar(_item));
  jParams[1].l := env^.NewStringUTF(env, PChar(_imgIdentifier));
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'Add',
    '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_SetNumColumns(env: PJNIEnv; _jgridview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _value;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetNumColumns', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetColumnWidth(env: PJNIEnv; _jgridview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _value;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetColumnWidth', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_Clear(env: PJNIEnv; _jgridview: JObject);
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jgridview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_Delete(env: PJNIEnv; _jgridview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _index;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'Delete', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_SetItemsLayout(env: PJNIEnv; _jgridview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _value;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetItemsLayout', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jGridView_GetItemIndex(env: PJNIEnv; _jgridview: JObject): integer;
var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'GetItemIndex', '()I');
  Result := env^.CallIntMethod(env, _jgridview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGridView_GetItemCaption(env: PJNIEnv; _jgridview: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'GetItemCaption', '()Ljava/lang/String;');
  jStr := env^.CallObjectMethod(env, _jgridview, jMethod);
  case jStr = nil of
    True: Result := '';
    False:
    begin
      jBoo := JNI_False;
      Result := string(env^.GetStringUTFChars(env, jStr, @jBoo));
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_DispatchOnDrawItemTextColor(env: PJNIEnv;
  _jgridview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].z := JBool(_value);
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'DispatchOnDrawItemTextColor', '(Z)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_DispatchOnDrawItemBitmap(env: PJNIEnv; _jgridview: JObject;
  _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].z := JBool(_value);
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'DispatchOnDrawItemBitmap', '(Z)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetFontSize(env: PJNIEnv; _jgridview: JObject; _size: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _size;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetFontSize', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetFontColor(env: PJNIEnv; _jgridview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _color;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetFontColor', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_SetFontSizeUnit(env: PJNIEnv; _jgridview: JObject; _unit: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _unit;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_UpdateItemTitle(env: PJNIEnv; _jgridview: JObject;
  _index: integer; _title: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _index;
  jParams[1].l := env^.NewStringUTF(env, PChar(_title));
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'UpdateItemTitle', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGridView_SetHorizontalSpacing(env: PJNIEnv; _jgridview: JObject;
  _horizontalSpacingPixels: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _horizontalSpacingPixels;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetHorizontalSpacing', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetVerticalSpacing(env: PJNIEnv; _jgridview: JObject;
  _verticalSpacingPixels: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _verticalSpacingPixels;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetVerticalSpacing', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetSelection(env: PJNIEnv; _jgridview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _index;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetSelection', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGridView_SetStretchMode(env: PJNIEnv; _jgridview: JObject;
  _stretchMode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jParams[0].i := _stretchMode;
  jCls := env^.GetObjectClass(env, _jgridview);
  jMethod := env^.GetMethodID(env, jCls, 'SetStretchMode', '(I)V');
  env^.CallVoidMethodA(env, _jgridview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
