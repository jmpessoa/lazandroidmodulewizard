unit LamwDesigner;

{$mode objfpc}{$h+}

interface

uses
  Classes, SysUtils, Graphics, FormEditingIntf, PropEdits, GraphPropEdits,
  AndroidWidget;

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
    procedure OnDesignerModified(Sender: TObject);
  private
    FAndroidForm: jForm;
    FDefaultBrushColor: TColor;
    FDefaultPenColor: TColor;
    FDefaultFontColor: TColor;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    //needed by the lazarus form editor
    class function CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator; override;
    class function FormClass: TComponentClass; override;

    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); override;
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); override;
    procedure GetClientArea(AComponent: TComponent; out CurClientArea: TRect; out ScrollOffset: TPoint); override;
    procedure Paint; override;
    function ComponentIsIcon(AComponent: TComponent): boolean; override;
    function ParentAcceptsChild(Parent: TComponent; Child: TComponentClass): boolean; override;
    {
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean); override;
    procedure MouseMove(Shift: TShiftState; p: TPoint; var Handled: boolean); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean); override;
     }
  public
    // needed by TAndroidWidget
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
    property AndroidForm: jForm read FAndroidForm;
  public
    procedure GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer); override;
  end;


  { TDraftWidget }

  TDraftWidget = class
  private
    FColor: TARGBColorBridge;
    FFontColor: TARGBColorBridge;
    procedure SetColor(color: TARGBColorBridge);
    procedure SetFontColor(color: TARGBColorBridge);
  protected
    FAndroidWidget: TAndroidWidget; // original
  public
    BackGroundColor: TColor;
    TextColor: TColor;
    MarginBottom: integer;
    MarginLeft: integer;
    MarginRight: integer;
    MarginTop: integer;
    Height: integer;
    Width: integer;
    constructor Create(AWidget: TAndroidWidget); virtual;
    procedure Draw(canvas: TCanvas); virtual; abstract;
    property Color: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
  end;

  { TDraftTextView }

  TDraftTextView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftEditText }

  TDraftEditText = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftButton }

  TDraftButton = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftCheckBox }

  TDraftCheckBox = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftRadioButton }

  TDraftRadioButton = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftProgressBar }

  TDraftProgressBar = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftListView }

  TDraftListView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftImageBtn }

  TDraftImageBtn = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget); override;
    procedure Draw(canvas: TCanvas); override;
  end;

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
     constructor Create(AWidget: TAndroidWidget); override;
     procedure Draw(canvas: TCanvas); override;

     property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
     property DropListBackgroundColor: TARGBColorBridge  read FDropListBackgroundColor write SetDropListBackgroundColor;
     property SelectedFontColor: TARGBColorBridge  read FSelectedFontColor write SetSelectedFontColor;
  end;

  { TDraftWebView }

  TDraftWebView = class(TDraftWidget)
  public
     constructor Create(AWidget: TAndroidWidget); override;
     procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftScrollView }

  TDraftScrollView = class(TDraftWidget)
  public
     constructor Create(AWidget: TAndroidWidget); override;
     procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftToggleButton }

  TDraftToggleButton = class(TDraftWidget)
  public
     OnOff: boolean;
     constructor Create(AWidget: TAndroidWidget); override;
     procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftSwitchButton }

  TDraftSwitchButton = class(TDraftWidget)
  public
     OnOff: boolean;
     constructor Create(AWidget: TAndroidWidget); override;
     procedure Draw(canvas: TCanvas); override;
  end;

  { TDraftGridView }

  TDraftGridView = class(TDraftWidget)
  public
     constructor Create(AWidget: TAndroidWidget); override;
     procedure Draw(canvas: TCanvas); override;
  end;

  { TARGBColorBridgePropertyEditor }

  TARGBColorBridgePropertyEditor = class(TEnumPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure ListDrawValue(const CurValue: ansistring; Index: integer;
      ACanvas: TCanvas; const ARect:TRect; AState: TPropEditDrawState); override;
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      AState: TPropEditDrawState); override;
  end;

implementation

uses
  LCLIntf, LCLType, FPimage, typinfo, Laz_And_Controls, customdialog,
  togglebutton, switchbutton, Laz_And_GLESv1_Canvas, Laz_And_GLESv2_Canvas,
  gridview, Spinner;

var
  DraftClassesMap: TDraftControlHash;

procedure GetRedGreenBlue(rgb: longInt; out Red, Green, Blue: word); inline;
begin
    red:=   ( (rgb and $ff0000)  shr 16) shl 8;
    Green:= ( (rgb and $ff00  )  shr  8) shl 8;
    blue:=  ( (rgb and $ff)            ) shl 8;
end;

function ToTFPColor(colbrColor: TARGBColorBridge):  TFPColor;
var
    index: integer;
    red, green, blue: word;
begin
    index:= (Ord(colbrColor));
    GetRedGreenBlue(TFPColorBridgeArray[index], red, green, blue);
    Result.Red:=   red;
    Result.Green:= green;
    Result.Blue:=  blue;
    Result.Alpha:= AlphaOpaque;
end;

function AndroidToLCLFontSize(asize: DWord): Integer; inline;
begin
  case asize of
  0: Result := 13;
  1: Result := 1;
  else Result := asize * 3 div 4;
  end;
end;

procedure RegisterAndroidWidgetDraftClass(AWidgetClass: jVisualControlClass;
  ADraftClass: TDraftWidgetClass);
begin
  DraftClassesMap.Add(AWidgetClass, ADraftClass);
end;

{ TDraftControlHash }

function TDraftControlHash.Hash1(c: TClass): PtrUInt;
begin
  Result := (PtrUInt(c) + PtrUInt(c) shr 7) mod PtrUInt(Length(FItems));
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

function TDraftControlHash.Find(VisualControlClass: TClass): TDraftWidgetClass;
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

function TARGBColorBridgePropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect,paValueList,paCustomDrawn];
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
      Brush.Color := FPColorToTColor(ToTFPColor(TARGBColorBridge(Index)));
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
  FDefaultBrushColor:= clForm;
  FDefaultPenColor:= clMedGray;
  FDefaultFontColor:= clMedGray;
  GlobalDesignHook.AddHandlerModified(@OnDesignerModified);
end;

destructor TAndroidWidgetMediator.Destroy;
begin
  if FAndroidForm<>nil then FAndroidForm.Designer:=nil;
  FAndroidForm:=nil;
  if GlobalDesignHook <> nil then
    GlobalDesignHook.RemoveAllHandlersForObject(Self);
  inherited Destroy;
end;

procedure TAndroidWidgetMediator.OnDesignerModified(Sender: TObject);
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
    if (Instance is jVisualControl)
    and (jVisualControl(Instance).Owner = FAndroidForm) then
    begin
      InvalidateNeeded := True;
      Break;
    end;
  end;
  if InvalidateNeeded then
    LCLForm.Invalidate;
end;

procedure TAndroidWidgetMediator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAndroidForm) then
    FAndroidForm := nil;
end;

class function TAndroidWidgetMediator.CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator;
var
  Mediator: TAndroidWidgetMediator;
begin
  Result:=inherited CreateMediator(TheOwner,TheForm);

  Mediator:= TAndroidWidgetMediator(Result);

  Mediator.FDefaultBrushColor:= clForm;
  Mediator.FDefaultPenColor:= clMedGray;
  Mediator.FDefaultFontColor:= clMedGray;

  Mediator.FAndroidForm:= TheForm as jForm;
  TheForm.FreeNotification(Mediator);
  Mediator.FAndroidForm.Designer:= Mediator;
end;

class function TAndroidWidgetMediator.FormClass: TComponentClass;
begin
  Result:=TAndroidForm;
end;

procedure TAndroidWidgetMediator.GetBounds(AComponent: TComponent; out CurBounds: TRect);
var
  w: TAndroidWidget;
begin
  if AComponent is TAndroidWidget then
  begin
    w:=TAndroidWidget(AComponent);
    CurBounds:=Bounds(w.Left,w.Top,w.Width,w.Height);
  end else inherited GetBounds(AComponent,CurBounds);
end;

procedure TAndroidWidgetMediator.InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
begin
  if (LCLForm=nil) or (not LCLForm.HandleAllocated) then exit;
  LCLIntf.InvalidateRect(LCLForm.Handle,@ARect,Erase);
end;

procedure TAndroidWidgetMediator.GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer);
begin
  if Assigned(APersistent) then
  begin
    if (APersistent is TAndroidWidget) and (TAndroidWidget(APersistent).AcceptChildrenAtDesignTime) then
      AIndex:= FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexBox
    else if (APersistent is TAndroidWidget) then
      AIndex:= FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexControl
    else
      inherited GetObjInspNodeImageIndex(APersistent, AIndex);
  end
end;

procedure TAndroidWidgetMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  if AComponent is TAndroidWidget then
  begin
    TAndroidWidget(AComponent).SetBounds(NewBounds.Left,NewBounds.Top,
      NewBounds.Right-NewBounds.Left,NewBounds.Bottom-NewBounds.Top);
  end else inherited SetBounds(AComponent,NewBounds);
end;

procedure TAndroidWidgetMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
var
  Widget: TAndroidWidget;
begin
  if AComponent is TAndroidWidget then
  begin
    Widget:=TAndroidWidget(AComponent);
    CurClientArea:=Rect(Widget.MarginLeft,Widget.MarginTop,
                        Widget.Width-Widget.MarginRight,
                        Widget.Height-Widget.MarginBottom);
    ScrollOffset:=Point(0,0);
  end
  else inherited GetClientArea(AComponent, CurClientArea, ScrollOffset);
end;

procedure TAndroidWidgetMediator.Paint;

  procedure PaintWidget(AWidget: TAndroidWidget);
  var
    i: Integer;
    Child: TAndroidWidget;
    fpcolor: TFPColor;
    //fpFontColor: TFPColor;
    fWidget: TDraftWidget;
    fWidgetClass: TDraftWidgetClass;
  begin

    with LCLForm.Canvas do begin
      //fill background

      Brush.Style:= bsSolid;
      Brush.Color:= Self.FDefaultBrushColor;
      Pen.Color:= Self.FDefaultPenColor;      //MedGray...
      Font.Color:= Self.FDefaultFontColor;

      if (AWidget is jVisualControl) then
      begin
        if ( (AWidget as jVisualControl).LayoutParamWidth  <> lpWrapContent) and
           ( (AWidget as jVisualControl).LayoutParamWidth  <> lpMatchParent) then
        begin
          (AWidget as jVisualControl).LayoutParamWidth:= GetDesignerLayoutByWH(AWidget.Width, AWidget.Parent.Width);
        end;
        if ((AWidget as jVisualControl).LayoutParamHeight  <> lpWrapContent) and
           ((AWidget as jVisualControl).LayoutParamHeight  <> lpMatchParent) then
        begin
          (AWidget as jVisualControl).LayoutParamHeight:= GetDesignerLayoutByWH(AWidget.Height, AWidget.Parent.Height);
        end;
      end;

      if (AWidget is jForm) then
      begin

        if (AWidget as jForm).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jForm).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
        end
        else
        begin
          Brush.Color:= clBlack;
        end;
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
      end else if (AWidget is jPanel) then
      begin
        if (AWidget as jPanel).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jPanel).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
        end
        else
        begin
          Brush.Color:= clNone;
          Brush.Style:= bsClear;
        end;
        Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
        Font.Color:= clMedGray;
        //TextOut(6,4,(AWidget as jVisualControl).Text);

      end else if (AWidget is jCustomDialog) then
      begin
        if (AWidget as jCustomDialog).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jCustomDialog).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
        end;
        {
        else
        begin
          Brush.Color:= clNone;
          Brush.Style:= bsClear;
        end;
        }
        Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
        Font.Color:= clMedGray;
        TextOut(6,4,(AWidget as jVisualControl).Text);

      end else if (AWidget is jScrollView)  then
      begin
        fWidget:= TDraftScrollView.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jScrollView).BackgroundColor;

         if (AWidget as jScrollView).Parent is jPanel  then
         begin
           if (AWidget as jScrollView).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jScrollView).Parent as jPanel).BackgroundColor;
         end;

        if (AWidget as jScrollView).Parent is jCustomDialog  then
        begin
          if (AWidget as jScrollView).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jScrollView).Parent as jCustomDialog).BackgroundColor;
        end;
        fWidget.Draw(LCLForm.Canvas);
        fWidget.Free;
      end else if (AWidget is jToggleButton) then
      begin
        fWidget:= TDraftToggleButton.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jToggleButton).BackgroundColor;
        fWidget.FontColor:= colbrGray;

        if (AWidget as jToggleButton).State = tsOff then
        begin
         (fWidget as TDraftToggleButton).OnOff:= False;
          fWidget.Draw(LCLForm.Canvas)
        end
        else
        begin
          (fWidget as TDraftToggleButton).OnOff:= True;
          fWidget.Draw(LCLForm.Canvas);
        end;
        fWidget.Free;
      end else if (AWidget is jSwitchButton) then
      begin
        fWidget:= TDraftSwitchButton.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jSwitchButton).BackgroundColor;
        fWidget.FontColor:= colbrGray;

        if (AWidget as jSwitchButton).State = tsOff then
        begin
         (fWidget as TDraftSwitchButton).OnOff:= False;
          fWidget.Draw(LCLForm.Canvas)
        end
        else
        begin
          (fWidget as TDraftSwitchButton).OnOff:= True;
          fWidget.Draw(LCLForm.Canvas);
        end;
        fWidget.Free;

      end else if (AWidget is jView) then
      begin
        if (AWidget as jView).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jView).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
        end
        else
        begin
          Brush.Color:= clNone; //clMoneyGreen;
          Brush.Style:= bsClear;
        end;
        Pen.Color:= clMedGray;
        //FillRect(0,0,AWidget.Width,AWidget.Height);
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);
      end else if (AWidget is jWebView) then
      begin
        fWidget:= TDraftWebView.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jWebView).BackgroundColor;
        //fWidget.FontColor:= (AWidget as jVisualControl).FFontColor;
        fWidget.Draw(LCLForm.Canvas);
        fWidget.Free;

      end else if (AWidget is jImageView) then
      begin
        if (AWidget as jImageView).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jImageView).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor)
        end
        else
        begin
          Brush.Color:= clNone; //clMoneyGreen;
          Brush.Style:= bsClear;
        end;
        Pen.Color:= clMedGray;
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);
      end else if (AWidget is jCanvasES1) then
      begin
        Brush.Color:= clMoneyGreen; //clNone;
        Brush.Style:= bsClear;
        Pen.Color:= clMedGray;
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);

      end else if (AWidget is jCanvasES2) then
      begin
         Brush.Color:= clMoneyGreen;//clNone;
         Brush.Style:= bsClear;
         Pen.Color:= clMedGray;
         Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
         //Font.Color:= clMedGray;
         //TextOut(5,4,(AWidget as jVisualControl).Text);

      end else if (AWidget is jTextView) then
      begin
        fWidget:= TDraftTextView.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jTextView).BackgroundColor;
        fWidget.FontColor:= (AWidget as jTextView).FontColor;
        fWidget.Draw(LCLForm.Canvas);
        fWidget.Free;
      end else if (AWidget is jCheckBox) then
      begin
        fWidget:= TDraftCheckBox.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jCheckBox).BackgroundColor;
        fWidget.FontColor:= (AWidget as jCheckBox).FontColor;
        fWidget.Draw(LCLForm.Canvas);
        fWidget.Free;
      end else if (AWidget is jRadioButton) then
      begin
        fWidget:= TDraftRadioButton.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jRadioButton).BackgroundColor;
        fWidget.FontColor:= (AWidget as jRadioButton).FontColor;
        fWidget.Draw(LCLForm.Canvas);
        fWidget.Free;
      end else if (AWidget is jImageBtn) then
      begin
        fWidget:= TDraftImageBtn.Create(AWidget);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jImageBtn).BackgroundColor;
        fWidget.FontColor:= colbrGray;
        fWidget.Draw(LCLForm.Canvas);
        fWidget.Free;
      end else if (AWidget is jEditText) then
      begin
         fWidget:= TDraftEditText.Create(AWidget);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.Color:= (AWidget as jEditText).BackgroundColor;
         fWidget.FontColor:= (AWidget as jEditText).FontColor;

         fWidget.Draw(LCLForm.Canvas);
         fWidget.Free;
      end else if (AWidget is jListView)  then
      begin
         fWidget:= TDraftListView.Create(AWidget);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.Color:= (AWidget as jListView).BackgroundColor;
         fWidget.FontColor:= (AWidget as jListView).FontColor;
         if (AWidget as jListView).Parent is jPanel  then
         begin
           if (AWidget as jListView).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jListView).Parent as jPanel).BackgroundColor;
         end;
         if (AWidget as jListView).Parent is jCustomDialog  then
         begin
          if (AWidget as jListView).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jListView).Parent as jCustomDialog).BackgroundColor;
         end;
         fWidget.Draw(LCLForm.Canvas);
         fWidget.Free;

      end else if (AWidget is jGridView)  then
      begin
         fWidget:= TDraftGridView.Create(AWidget);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.Color:= (AWidget as jGridView).BackgroundColor;
         //fWidget.FontColor:= (AWidget as jGridView).FontColor;

         if (AWidget as jGridView).Parent is jPanel  then
         begin
           if (AWidget as jGridView).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jGridView).Parent as jPanel).BackgroundColor;
         end;
         if (AWidget as jGridView).Parent is jCustomDialog  then
         begin
          if (AWidget as jGridView).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jGridView).Parent as jCustomDialog).BackgroundColor;
         end;
         fWidget.Draw(LCLForm.Canvas);
         fWidget.Free;
      end else if (AWidget is jSpinner) then
      begin
         fWidget:= TDraftSpinner.Create(AWidget);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

        (fWidget as TDraftSpinner).Color:= (AWidget as jSpinner).BackgroundColor;
        (fWidget as TDraftSpinner).FontColor:= (AWidget as jSpinner).DropListBackgroundColor;
        (fWidget as TDraftSpinner).DropListTextColor:= (AWidget as jSpinner).DropListTextColor;
        (fWidget as TDraftSpinner).DropListBackgroundColor:= (AWidget as jSpinner).DropListBackgroundColor;
        (fWidget as TDraftSpinner).SelectedFontColor:= (AWidget as jSpinner).SelectedFontColor;

         if (AWidget as jSpinner).Parent is jPanel  then
         begin
           if (AWidget as jSpinner).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jSpinner).Parent as jPanel).BackgroundColor;
         end;

        if (AWidget as jSpinner).Parent is jCustomDialog  then
        begin
          if (AWidget as jSpinner).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jSpinner).Parent as jCustomDialog).BackgroundColor;
        end;

         fWidget.Draw(LCLForm.Canvas);
         fWidget.Free;
      end else
      begin
        fWidgetClass := DraftClassesMap.Find(AWidget.ClassType);
        if Assigned(fWidgetClass) then
        begin
          fWidget := fWidgetClass.Create(AWidget);
          fWidget.Draw(LCLForm.Canvas);
          fWidget.Free;
        end
        else if (AWidget is jVisualControl) then     ////generic
        begin
          Brush.Color:= Self.FDefaultBrushColor;
          FillRect(0,0,AWidget.Width,AWidget.Height);
          Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
          //generic
          Font.Color:= clMedGray;
          TextOut(5,4,(AWidget as TAndroidWidget).Text);
        end;
      end;

      if AWidget.AcceptChildrenAtDesignTime then
      begin       //inner rect...
        if (AWidget is jPanel) then
        begin
          Pen.Color:= clSilver; //clWhite;
          Frame(4,4,AWidget.Width-4,AWidget.Height-4); // inner frame
        end
        else if (AWidget is jCustomDialog) then
        begin
          Pen.Color:= clSilver; //clWhite;
          Frame(4,4,AWidget.Width-4,AWidget.Height-4); // inner frame
        end
        else
        begin
          Pen.Color:= clSilver;
          Frame(2,2,AWidget.Width-2,AWidget.Height-2); // inner frame
        end;
      end;

      // children
      if AWidget.ChildCount>0 then
      begin
        SaveHandleState;
        // clip client area
        MoveWindowOrgEx(Handle,AWidget.MarginLeft,AWidget.MarginTop);
        if IntersectClipRect(Handle, 0, 0, AWidget.Width-AWidget.MarginLeft-AWidget.MarginRight,
                             AWidget.Height-AWidget.MarginTop-AWidget.MarginBottom)<>NULLREGION then
        begin
          for i:=0 to AWidget.ChildCount-1 do
          begin
            SaveHandleState;
            Child:=AWidget.Children[i];
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
  end;

begin
  PaintWidget(AndroidForm);
  inherited Paint;
end;

function TAndroidWidgetMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result:=not (AComponent is TAndroidWidget);
end;

function TAndroidWidgetMediator.ParentAcceptsChild(Parent: TComponent; Child: TComponentClass): boolean;
begin
  Result:=(Parent is TAndroidWidget) and
          (Child.InheritsFrom(TAndroidWidget)) and
          (TAndroidWidget(Parent).AcceptChildrenAtDesignTime);
end;

  {
procedure TAndroidWidgetMediator.MouseDown(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
   Handled:= False;
end;

procedure TAndroidWidgetMediator.MouseMove(Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
  Handled:= False;
end;

procedure TAndroidWidgetMediator.MouseUp(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
  Handled:= True;
end;
 }

{ TDraftWidget }

constructor TDraftWidget.Create(AWidget: TAndroidWidget);
begin
  TextColor:= clNone;
  BackGroundColor:= clNone;
  FAndroidWidget := AWidget;
end;

procedure TDraftWidget.SetColor(color: TARGBColorBridge);
begin
  FColor:= color;
  if color <> colbrDefault then
    BackGroundColor:= FPColorToTColor(ToTFPColor(color))
  else
    BackGroundColor:= clNone;
end;

procedure TDraftWidget.SetFontColor(color: TARGBColorBridge);
begin
  FFontColor:= color;
  if color <> colbrDefault then
  begin
    TextColor:= FPColorToTColor(ToTFPColor(color));
  end
  else TextColor:= clNone;
end;

{ TDraftButton }

constructor TDraftButton.Create(AWidget: TAndroidWidget);
begin
  inherited;
  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
  FontColor := jButton(AWidget).FontColor;
  Color := jButton(AWidget).BackgroundColor;

  if AWidget.Parent is jPanel then
  begin
    if jButton(AWidget).BackgroundColor = colbrDefault then
      Color := jPanel(AWidget.Parent).BackgroundColor;
  end else
  if AWidget.Parent is jCustomDialog then
  begin
    if jButton(AWidget).BackgroundColor = colbrDefault then
      Color := jCustomDialog(AWidget.Parent).BackgroundColor;
  end;
end;

procedure TDraftButton.Draw(canvas: TCanvas);
var
  r: TRect;
  ts: TTextStyle;
  lastFontSize: Integer;
begin
  with canvas do
  begin
    Brush.Color := BackGroundColor;
    Pen.Color := clForm;
    Font.Color := TextColor;

    if BackGroundColor = clNone then
      Brush.Color := RGBToColor($cc, $cc, $cc);

    if TextColor = clNone then
      Font.Color:= clBlack;
    lastFontSize := Font.Size;
    Font.Size := AndroidToLCLFontSize(jButton(FAndroidWidget).FontSize);

    r := Rect(0, 0, Self.Width, Self.Height);
    FillRect(r);
    //outer frame
    Rectangle(r);

    Pen.Color := clMedGray;
    Brush.Style := bsClear;
    InflateRect(r, -1, -1);
    Rectangle(r);

    ts := TextStyle;
    ts.Layout := tlCenter;
    ts.Alignment := Classes.taCenter;
    TextRect(r, r.Left, r.Top, FAndroidWidget.Text, ts);
    Font.Size := lastFontSize;
  end;
end;

{ TDraftTextView }

constructor TDraftTextView.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clNone; //clForm; //clActiveCaption;
end;

procedure TDraftTextView.Draw(canvas: TCanvas);
//var
  //txtW: integer;
  //txtH: integer;
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:=  Self.TextColor;
  //txtH:= canvas.TextHeight(txt);
  //txtW:= canvas.TextWidth(txt);
  if Self.BackGroundColor <>  clNone then
  begin
    canvas.FillRect(0,0,Self.Width,Self.Height);
    //canvas.FillRect(0,0,txtW{Self.Width}+2,txtH{Self.Height}+2);
  end
  else
  begin
    canvas.Brush.Style:= bsClear;
     //outer frame
    //canvas.Rectangle(0,0,Self.Width,Self.Height);
  end;


  canvas.Font.Color:=  Self.TextColor;

  if Self.TextColor = clNone then
     canvas.Font.Color:= clSilver;

  canvas.TextOut(5, 4, FAndroidWidget.Text);

  canvas.Brush.Style:= bsSolid;
end;

{ TDraftEditText }

constructor TDraftEditText.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clNone; //clActiveCaption;
end;

procedure TDraftEditText.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clActiveCaption;
  canvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
    canvas.Brush.Color:= clWhite;

  if Self.TextColor = clNone then
     canvas.Font.Color:= clBlack;

  canvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

 (* canvas.Pen.Color:= clBlack;
  canvas.MoveTo(Self.Width-Self.MarginRight+9, {x2}Self.MarginTop-9); {y1}
  canvas.LineTo(Self.MarginLeft-9,Self.MarginTop-9);  {x1, y1}
  canvas.LineTo(Self.MarginLeft-9,Self.Height-Self.MarginBottom+9); {x1, y2}*)

  canvas.Pen.Color:= clBlack; //clWindowFrame; //clBlack;//clGray; //Self.FDefaultPenColor;

  canvas.Brush.Style:= bsClear;
  canvas.Rectangle(2,2,Self.Width-2,Self.Height-2);


  canvas.TextOut(5, 4, FAndroidWidget.Text);
end;

{ TDraftCheckBox }

constructor TDraftCheckBox.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clNone; //clActiveCaption;
end;

procedure TDraftCheckBox.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Font.Color:= Self.TextColor;
  if Self.BackGroundColor <>  clNone then
  begin
    canvas.FillRect(0,0,Self.Width,Self.Height);
  end
  else
  begin
    canvas.Brush.Style:= bsClear;
       //outer frame
  end;

  if Self.TextColor = clNone then
       canvas.Font.Color:= clSilver;

  canvas.TextOut(28, 8, FAndroidWidget.Text);

  canvas.Brush.Style:= bsSolid;
  canvas.Brush.Color:= clWhite;
  canvas.Pen.Color:= canvas.Font.Color;
  canvas.Rectangle(Self.MarginLeft+1,Self.MarginTop+1,
            Self.MarginLeft+18,
            Self.MarginTop+18);
end;

{ TDraftRadioButton }

constructor TDraftRadioButton.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clNone; //clActiveCaption;
end;

procedure TDraftRadioButton.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Font.Color:= Self.TextColor;
  if Self.BackGroundColor <>  clNone then
  begin
    canvas.FillRect(0,0,Self.Width,Self.Height);
  end
  else
  begin
    canvas.Brush.Style:= bsClear;
  end;

  if Self.TextColor = clNone then
       canvas.Font.Color:= clSilver;
  canvas.TextOut(28, 8, FAndroidWidget.Text);

  canvas.Brush.Style:= bsSolid;
  canvas.Brush.Color:= clWhite;
  canvas.Pen.Color:= canvas.Font.Color;
  canvas.Ellipse(Self.MarginLeft+1,Self.MarginTop+1,
            Self.MarginLeft+18,
            Self.MarginTop+18);
end;

{ TDraftProgressBar }

constructor TDraftProgressBar.Create(AWidget: TAndroidWidget);
begin
  inherited;
  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
  Color := jProgressBar(AWidget).BackgroundColor;
  FontColor := colbrBlack;

  if AWidget.Parent is jPanel then
  begin
    if jProgressBar(AWidget).BackgroundColor = colbrDefault then
      Color := jPanel(AWidget.Parent).BackgroundColor;
  end else
  if AWidget.Parent is jCustomDialog then
  begin
    if jProgressBar(AWidget).BackgroundColor = colbrDefault then
      Color := jCustomDialog(AWidget.Parent).BackgroundColor;
  end;
end;

procedure TDraftProgressBar.Draw(canvas: TCanvas);
var
  i, k: integer;
  fpcolor: TFPColor;
begin
  fpcolor:= ToTFPColor(colbrLightSlateBlue);

  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clWhite;

  if Self.BackGroundColor = clNone then canvas.Brush.Style:= bsClear;

  canvas.FillRect(0,0,Self.Width,Self.Height);
  canvas.Brush.Color:= FPColorToTColor(fpcolor);
  canvas.FillRect(0,10,Trunc(2*Self.Width/3),Self.Height-10);

  canvas.Brush.Style:= bsSolid;

  k:= Trunc(Self.Width/25) - 1;
  for i:= 1 to k-1 do
  begin
    canvas.MoveTo(0+i*20, 0+10);  {x1, y1}
    canvas.LineTo(0+i*20,Self.Height-10); {x1, y2}
  end;

  canvas.Brush.Style:= bsClear;
  canvas.Pen.Color:= FPColorToTColor(fpcolor);
  // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);
  //canvas.Font.Color:= clBlack;
  //canvas.TextOut(12,8, txt);
end;

{ TDraftListView }

constructor TDraftListView.Create(AWidget: TAndroidWidget);
begin
  inherited;
end;

procedure TDraftListView.Draw(canvas: TCanvas);
var
  i, k: integer;
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then canvas.Brush.Style:= bsClear;

  canvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Brush.Style:= bsSolid;

  canvas.Pen.Color:= clSilver;
  k:= Trunc(Self.Height/20);
  for i:= 1 to k-1 do
  begin
    canvas.MoveTo(Self.Width-Self.MarginRight+10, {x2}
    Self.MarginTop+i*20); {y1}
    canvas.LineTo(Self.MarginLeft-10,Self.MarginTop+i*20);  {x1, y1}
  end;

  //canvas.Brush.Style:= bsClear;
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4, txt);
end;

{ TDraftImageBtn }

constructor TDraftImageBtn.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;
end;

procedure TDraftImageBtn.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clWhite;
  canvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
     canvas.Brush.Color:= clSilver; //clMedGray;

  if Self.TextColor = clNone then
      canvas.Font.Color:= clBlack;

  canvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Pen.Color:= clWindowFrame;
  canvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.MarginTop-3,  {y1}
             Self.Width-Self.MarginRight+3,  {x2}
             Self.Height-Self.MarginBottom+3); {y2}

  canvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.Height-Self.MarginBottom+3,{y2}
             Self.MarginLeft-4,                {x1}
             Self.Height-Self.MarginBottom+3);  {y2}

  canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4,txt);
end;

{ TDraftSpinner }

constructor TDraftSpinner.Create(AWidget: TAndroidWidget);
begin
  inherited;
  //BackGroundColor:= clInactiveBorder; //clActiveCaption;
end;

procedure TDraftSpinner.SetDropListBackgroundColor(Acolor: TARGBColorBridge);
begin
  FDropListBackgroundColor:= Acolor;
  if Acolor <> colbrDefault then
    DropListColor:= FPColorToTColor(ToTFPColor(Acolor))
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

procedure TDraftSpinner.Draw(canvas: TCanvas);
var
  saveColor: TColor;
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= Self.DropListColor;

  if DropListColor = clNone then
     canvas.Pen.Color:= clMedGray;

  if BackGroundColor = clNone then
     canvas.Brush.Color:= clWhite;

  canvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Brush.Color:= Self.DropListColor; //clActiveCaption;

  if DropListColor = clNone then
     canvas.Brush.Color:= clSilver;

  canvas.Rectangle(Self.Width-47,0+7,Self.Width-7,Self.Height-7);
  saveColor:= canvas.Brush.Color;

  canvas.Brush.Style:= bsClear;
  canvas.Pen.Color:= clWhite;
  canvas.Rectangle(Self.Width-48,0+6,Self.Width-6,Self.Height-6);


  canvas.Pen.Color:= Self.DropListFontColor;

  if saveColor <> clBlack then
     canvas.Pen.Color:= clBlack
  else
     canvas.Pen.Color:= clSilver;

  canvas.Line(Self.Width-42, 12,Self.Width-11, 12);
  canvas.Line(Self.Width-42-1, 12,Self.Width-42+Trunc(31/2), Self.Height-12);
  canvas.Line(Self.Width-42+Trunc(31/2),Self.Height-12,Self.Width-11,12);

  canvas.Font.Color:= Self.SelectedTextColor;
  if SelectedTextColor = clNone then
     canvas.Font.Color:= clMedGray;

  //canvas.TextOut(5,4,txt);
end;

{ TDraftWebView }

constructor TDraftWebView.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clWhite; //clMoneyGreen; //clInactiveBorder; //clActiveCaption;
end;

procedure TDraftWebView.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clTeal; //clGreen;//clActiveCaption;
  canvas.FillRect(0,0,Self.Width,Self.Height);
  canvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
  //----
  canvas.Brush.Color:= clWhite;
  canvas.Pen.Color:= clMoneyGreen;//clActiveCaption;

  canvas.FillRect(5,5,Self.Width-5,25);
  canvas.Rectangle(5,5,Self.Width-5,25);

  canvas.FillRect (5,30,Trunc(Self.Width/2)-5,Self.Height-5);
  canvas.Rectangle(5,30,Trunc(Self.Width/2)-5,Self.Height-5);

  canvas.FillRect (Trunc(Self.Width/2),30,Self.Width-5,Trunc(0.5*Self.Height));
  canvas.Rectangle(Trunc(Self.Width/2),30,Self.Width-5,Trunc(0.5*Self.Height));

  canvas.FillRect (Trunc(Self.Width/2),Trunc(0.5*Self.Height)+5,Self.Width-5,Self.Height-5);
  canvas.Rectangle(Trunc(Self.Width/2),Trunc(0.5*Self.Height)+5,Self.Width-5,Self.Height-5);
 //-----

 //canvas.Font.Color:= Self.FontColor;

 //canvas.TextOut(10,6,txt);
end;

{ TDraftScrollView }

constructor TDraftScrollView.Create(AWidget: TAndroidWidget);
begin
  inherited;
end;

procedure TDraftScrollView.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;

  if Self.BackGroundColor = clNone then canvas.Brush.Style:= bsClear;

  canvas.FillRect(0,0,Self.Width,Self.Height);
  canvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame

  canvas.Brush.Style:= bsSolid;
  canvas.Brush.Color:= clWhite;
  canvas.FillRect(Self.Width-20,5,Self.Width-5,Self.Height-5);

  canvas.Brush.Color:= clMedGray; //Self.BackGroundColor;
  canvas.FillRect(Self.Width-20+5,5+25,Self.Width-5-5,Self.Height-5-25);

  canvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;
  canvas.Frame(Self.Width-20,5,Self.Width-5,Self.Height-5);

  canvas.Pen.Color:= clBlack; //clGreen;//clActiveCaption;
  canvas.MoveTo(Self.Width-5-1,5+1);
  canvas.LineTo(Self.Width-20+1,5+1);
  canvas.LineTo(Self.Width-20+1,Self.Height-5-1);

  canvas.Pen.Color:= clWindowFrame; //clGreen;//clActiveCaption;
  canvas.MoveTo(Self.Width-5-5,5+25+1);
  canvas.LineTo(Self.Width-5-5,Self.Height-5-25);
  canvas.LineTo(Self.Width-20+5,Self.Height-5-25);

  //-----
  //canvas.Brush.Style:= bsClear;
 // canvas.TextOut(10,6,txt);
end;

{ TDraftToggleButton }

constructor TDraftToggleButton.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clActiveCaption;; //clMenuHighlight;
end;

procedure TDraftToggleButton.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clWhite;
  canvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
     canvas.Brush.Color:= clSilver; //clMedGray;

  if Self.TextColor = clNone then
      canvas.Font.Color:= clBlack;

  canvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Pen.Color:= clWindowFrame;
  if Self.OnOff = True then  //on
  begin

    canvas.Brush.Style:= bsSolid;
    canvas.Brush.Color:= clSkyBlue;
    canvas.FillRect(Self.MarginRight-4,
                    Self.MarginTop-3,
                    Self.Width-Self.MarginLeft+2,
                    Self.Height-Self.MarginBottom+3);

    canvas.Brush.Style:= bsClear;
    canvas.Pen.Color:= clWindowFrame;

     canvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.MarginTop-3,  {y1}
             Self.Width-Self.MarginRight+3,  {x2}
             Self.Height-Self.MarginBottom+3); {y2}

     canvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.Height-Self.MarginBottom+3,{y2}
             Self.MarginLeft-4,                {x1}
             Self.Height-Self.MarginBottom+3);  {y2}


     canvas.Pen.Color:= clWhite;
     canvas.Line(Self.MarginLeft-4, {x1}
                   Self.MarginTop-3,  {y1}
                   Self.MarginLeft-4, {x1}
                   Self.Height-Self.MarginBottom+3); {y2}

     canvas.Line(Self.Width-Self.MarginRight+3, {x2}
                Self.MarginTop-3,  {y1}
                Self.MarginLeft-4, {x1}
                Self.MarginTop-3);{y1}
  end
  else  //off
  begin

    (*
    canvas.Brush.Style:= bsSolid;
    canvas.Brush.Color:= clSkyBlue;
    canvas.FillRect(Self.MarginRight-4,
                    Self.MarginTop-3,
                    Self.Width-Self.MarginLeft+2,
                    Self.Height-Self.MarginBottom+3);

    *)
    canvas.Brush.Style:= bsClear;
    canvas.Pen.Color:= clWindowFrame;

    //V
    canvas.Line(Self.MarginLeft-4, {x1}
               Self.MarginTop-3,  {y1}
               Self.MarginLeft-4, {x1}
               Self.Height-Self.MarginBottom+3); {y2}

     //H
    canvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.MarginLeft-4, {x1}
            Self.MarginTop-3);{y1}

    canvas.Pen.Color:= clWhite;
    canvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.Width-Self.MarginRight+3,  {x2}
            Self.Height-Self.MarginBottom+3); {y2}

    canvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.Height-Self.MarginBottom+3,{y2}
            Self.MarginLeft-4,                {x1}
            Self.Height-Self.MarginBottom+3);  {y2}


  end;
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4,txt);
end;

{ TDraftSwitchButton }

constructor TDraftSwitchButton.Create(AWidget: TAndroidWidget);
begin
  inherited;
  BackGroundColor:= clActiveCaption;; //clMenuHighlight;
end;

procedure TDraftSwitchButton.Draw(canvas: TCanvas);
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clWhite;
  canvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
     canvas.Brush.Color:= clSilver; //clMedGray;

  if Self.TextColor = clNone then
      canvas.Font.Color:= clBlack;

  canvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Pen.Color:= clWindowFrame;
    //V
  canvas.Line(Self.MarginLeft-4, {x1}
               Self.MarginTop-3,  {y1}
               Self.MarginLeft-4, {x1}
               Self.Height-Self.MarginBottom+3); {y2}

     //H
  canvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.MarginLeft-4, {x1}
            Self.MarginTop-3);{y1}

  canvas.Pen.Color:= clWhite;
  canvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.Width-Self.MarginRight+3,  {x2}
            Self.Height-Self.MarginBottom+3); {y2}

   canvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.Height-Self.MarginBottom+3,{y2}
            Self.MarginLeft-4,                {x1}
            Self.Height-Self.MarginBottom+3);  {y2}

   //tumbl
  if Self.OnOff = False then  //on
  begin
    canvas.Brush.Style:= bsSolid;
    canvas.FillRect(
               Self.MarginLeft-1, {x1}
               Self.MarginTop,
               Trunc(Self.Width/2),
               Self.Height-Self.MarginBottom+1);

    canvas.Brush.Style:= bsClear;
    canvas.Pen.Color:= clWhite; //clWindowFrame

    canvas.Rectangle(
               Self.MarginLeft-1, {x1}
               Self.MarginTop,
               Trunc(Self.Width/2),
               Self.Height-Self.MarginBottom+1);
  end
  else  //True
  begin
    canvas.Brush.Style:= bsSolid;
    canvas.Brush.Color:= clSkyBlue;

    canvas.FillRect(
               Trunc(Self.Width/2), {x1}
               Self.MarginTop,
               Self.Width - Self.MarginRight,
               Self.Height - Self.MarginBottom+1);

    canvas.Pen.Color:= clWhite; //clWindowFrame
    canvas.Brush.Style:= bsClear;

    canvas.Rectangle(
               Trunc(Self.Width/2), {x1}
               Self.MarginTop,
               Self.Width - Self.MarginRight,
               Self.Height - Self.MarginBottom+1);
  end;
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4,txt);
end;

{TDraftGridView}

constructor TDraftGridView.Create(AWidget: TAndroidWidget);
begin
  inherited;
end;

procedure TDraftGridView.Draw(canvas: TCanvas);
var
  i, k: integer;
begin
  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then canvas.Brush.Style:= bsClear;

  canvas.FillRect(0,0,Self.Width,Self.Height);
  // outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Brush.Style:= bsSolid;

  canvas.Pen.Color:= clSilver;

  //H lines
  k:= Trunc((Self.Height-Self.MarginTop-Self.MarginBottom)/70);
  for i:= 1 to k do
  begin
    canvas.MoveTo(Self.Width-Self.MarginRight+10, {x2} Self.MarginTop+i*70); {y1}
    canvas.LineTo(Self.MarginLeft-10,Self.MarginTop+i*70);  {x1, y1}
  end;

  //V  lines
  k:= Trunc((Self.Width-Self.MarginLeft-Self.MarginRight)/70);
  for i:= 1 to k do
  begin
    canvas.MoveTo((Self.MarginLeft-10)+i*70, Self.MarginTop-10);  {x1, y1}
    canvas.LineTo((Self.MarginLeft-10)+i*70, Self.Height); {y1}
  end;

  //canvas.Brush.Style:= bs
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4, txt);
end;

initialization
  DraftClassesMap := TDraftControlHash.Create(64); // power of 2 for efficiency
  RegisterPropertyEditor(TypeInfo(TARGBColorBridge), nil, '', TARGBColorBridgePropertyEditor);

  // registering DraftClasses:
  RegisterAndroidWidgetDraftClass(jProgressBar, TDraftProgressBar);
  RegisterAndroidWidgetDraftClass(jButton, TDraftButton);

finalization
  DraftClassesMap.Free;
end.

