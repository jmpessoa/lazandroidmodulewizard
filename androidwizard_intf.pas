unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
 Classes, SysUtils, FileUtil, Controls, Forms, Dialogs, Graphics,
 LCLProc, LCLType, LCLIntf, LazIDEIntf, ProjectIntf, FormEditingIntf, AndroidWidget, uFormAndroidProject,
 uformworkspace,Laz_And_Controls, FPimage;

type


  TAndroidModule = class(jForm)            //GUI Module
  end;

  TNoGUIAndroidModule = class(TDataModule) //raw ".so"
  end;

  TDraftWidget = class
  private
    FColor: TARGBColorBridge;
    FFontColor: TARGBColorBridge;

    procedure SetColor(color: TARGBColorBridge);
    procedure SetFontColor(color: TARGBColorBridge);
  public

    BackGroundColor: TColor;
    TextColor: TColor;


    MarginBottom: integer;
    MarginLeft: integer;
    MarginRight: integer;
    MarginTop: integer;

    Height: integer;
    Width: integer;

    constructor Create; virtual;
    procedure Draw(canvas: TCanvas;  txt: string); virtual;

    property Color: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
  end;

  TDraftTextView = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftEditText = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftButton = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftCheckBox = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftRadioButton = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftProgressBar = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftListView = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftImageBtn = class(TDraftWidget)
  public
    constructor Create; override;
    procedure Draw(canvas: TCanvas;  txt: string); override;
  end;

  TDraftSpinner = class(TDraftWidget)
  private
    FDropListTextColor: TARGBColorBridge;
    DropListFontColor: TColor;

    FDropListBackgroundColor: TARGBColorBridge;
    DropListColor: TColor;

    FSelectedFontColor: TARGBColorBridge;
    SelectedTextColor: TColor;

    procedure SetDropListTextColor(color: TARGBColorBridge);
    procedure SetDropListBackgroundColor(color: TARGBColorBridge);
    procedure SetSelectedFontColor(color: TARGBColorBridge);

  public
     constructor Create; override;
     procedure Draw(canvas: TCanvas; txt: string); override;

     property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
     property DropListBackgroundColor: TARGBColorBridge  read FDropListBackgroundColor write SetDropListBackgroundColor;
     property SelectedFontColor: TARGBColorBridge  read FSelectedFontColor write SetSelectedFontColor;
  end;

  TDraftWebView = class(TDraftWidget)
  public
     constructor Create; override;
     procedure Draw(canvas: TCanvas; txt: string); override;
  end;

  TDraftScrollView = class(TDraftWidget)
  public
     constructor Create; override;
     procedure Draw(canvas: TCanvas; txt: string); override;
  end;

  { TAndroidWidgetMediator :: thanks to x2nie !}

  TAndroidWidgetMediator = class(TDesignerMediator,IAndroidWidgetDesigner)
  private
    FAndroidForm: jForm;
    FDefaultBrushColor: TColor;
    FDefaultPenColor: TColor;
    FDefaultFontColor: TColor;
  public
    //needed by the lazarus form editor
    class function CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator; override;
    class function FormClass: TComponentClass; override;

    class procedure InitFormInstance(TheForm: TComponent); override; // called after NewInstance, before constructor

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

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIInterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJavaClass: string;
     FPathToJNIFolder: string;
     FPathToNdkPlataforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}
     FPathToJavaTemplates: string;
     FAndroidProjectName: string;
     FModuleType: integer;     {0: GUI; 1: NoGUI}
     FSyntaxMode: TSyntaxMode;   {}

     FPathToJavaJDK: string;
     FPathToAndroidSDK: string;
     FPathToAndroidNDK: string;
     FNDK: string;

     FPathToAntBin: string;
     FProjectModel: string;
     FAntPackageName: string;
     FMinApi: string;
     FTargetApi: string;
     FSupportV4: string;
     FTouchtestEnabled: string;
     FAntBuildMode: string;
     FMainActivity: string;
     FPathToJavaSrc: string;
     FAndroidPlatform: string;

     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode: boolean;
     function GetPathToJNIFolder(fullPath: string): string;
     function GetWorkSpaceFromForm: boolean;
     function GetAppName(className: string): string;
     function GetIdFromApi(api: integer): string;
     function GetFolderFromApi(api: integer): string;

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
    ModuleType: integer;   //0: GUI; 1: No GUI
    constructor Create; override;

    function CreateSource(const Filename     : string;
                          const SourceName   : string;
                          const ResourceName : string): string; override;

    function GetInterfaceUsesSection: string; override;

    function GetInterfaceSource(const Filename     : string;
                                const SourceName   : string;
                                const ResourceName : string): string; override;

    function GetResourceType: TResourceType; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetImplementationSource(const Filename     : string;
                                     const SourceName   : string;
                                     const ResourceName : string): string; override;
  end;

var
  AndroidProjectDescriptor: TAndroidProjectDescriptor;
  AndroidFileDescriptor: TAndroidFileDescPascalUnitWithResource;
  i: integer;

procedure Register;

function ReplaceChar(query: string; oldchar, newchar: char):string;
function SplitStr(var theString: string; delimiter: string): string;

procedure GetRedGreenBlue(rgb: longInt; out Red, Green, Blue: word);
function ToTFPColor(colbrColor: TARGBColorBridge):  TFPColor;




implementation

uses
   Laz_And_GLESv2_Canvas, Laz_And_GLESv1_Canvas, Spinner, customdialog;

procedure Register;
begin

  FormEditingHook.RegisterDesignerMediator(TAndroidWidgetMediator);
  AndroidFileDescriptor := TAndroidFileDescPascalUnitWithResource.Create;
  RegisterProjectFileDescriptor(AndroidFileDescriptor);

  AndroidProjectDescriptor:= TAndroidProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidProjectDescriptor);

  FormEditingHook.RegisterDesignerBaseClass(TAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TNoGUIAndroidModule);

end;

{ TAndroidWidgetMediator }

constructor TAndroidWidgetMediator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDefaultBrushColor:= clForm;
  FDefaultPenColor:= clMedGray;
  FDefaultFontColor:= clMedGray;
end;

destructor TAndroidWidgetMediator.Destroy;
begin
  if FAndroidForm<>nil then FAndroidForm.Designer:=nil;
  FAndroidForm:=nil;
  inherited Destroy;
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
  Mediator.FAndroidForm.Designer:= Mediator;
end;

class function TAndroidWidgetMediator.FormClass: TComponentClass;
begin
  Result:=TAndroidForm;
end;

class procedure TAndroidWidgetMediator.InitFormInstance(TheForm: TComponent); // called after NewInstance, before constructor
begin
   //
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
          Brush.Color:= clBlack;

        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as TAndroidWidget).Text);
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
        fWidget:= TDraftScrollView.Create;
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

        fWidget.Draw(LCLForm.Canvas, (AWidget as jScrollView).Text);
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
        Font.Color:= clMedGray;
        TextOut(5,4,(AWidget as jVisualControl).Text);
      end else if (AWidget is jWebView) then
      begin

        fWidget:= TDraftWebView.Create;
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jWebView).BackgroundColor;
        //fWidget.FontColor:= (AWidget as jVisualControl).FFontColor;
        fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
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
        Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);
      end else if (AWidget is jCanvasES1) then
      begin
         Brush.Color:= clNone;
         Brush.Style:= bsClear;
         Pen.Color:= clMedGray;
         Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
         Font.Color:= clMedGray;
         TextOut(5,4,(AWidget as jVisualControl).Text);
       end else if (AWidget is jCanvasES2) then
       begin
         Brush.Color:= clNone;
         Brush.Style:= bsClear;
         Pen.Color:= clMedGray;
         Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
         Font.Color:= clMedGray;
         TextOut(5,4,(AWidget as jVisualControl).Text);
      end else if (AWidget is jTextView) then
      begin
        fWidget:= TDraftTextView.Create;
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jTextView).BackgroundColor;
        fWidget.FontColor:= (AWidget as jTextView).FontColor;
        fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
        fWidget.Free;
      end else if (AWidget is jCheckBox) then
      begin
        fWidget:= TDraftCheckBox.Create;
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jCheckBox).BackgroundColor;
        fWidget.FontColor:= (AWidget as jCheckBox).FontColor;
        fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
        fWidget.Free;
      end else if (AWidget is jRadioButton) then
      begin
        fWidget:= TDraftRadioButton.Create;
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jRadioButton).BackgroundColor;
        fWidget.FontColor:= (AWidget as jRadioButton).FontColor;
        fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
        fWidget.Free;
      end else if (AWidget is jImageBtn) then
      begin
        fWidget:= TDraftImageBtn.Create;
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jImageBtn).BackgroundColor;
        fWidget.FontColor:= colbrGray;
        fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
        fWidget.Free;
      end
      else if (AWidget is jButton) then
      begin
         fWidget:= TDraftButton.Create;
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.FontColor:= (AWidget as jButton).FontColor;
         fWidget.Color:= (AWidget as jButton).BackgroundColor;


         if (AWidget as jButton).Parent is jPanel  then
         begin
           if (AWidget as jButton).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jButton).Parent as jPanel).BackgroundColor;
         end;

        if (AWidget as jButton).Parent is jCustomDialog  then
        begin
          if (AWidget as jButton).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jButton).Parent as jCustomDialog).BackgroundColor;
        end;

         fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
         fWidget.Free;

      end else if (AWidget is jEditText) then
      begin
         fWidget:= TDraftEditText.Create;
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.Color:= (AWidget as jEditText).BackgroundColor;
         fWidget.FontColor:= (AWidget as jEditText).FontColor;

         fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
         fWidget.Free;
      end else if (AWidget is jListView)  then
      begin
         fWidget:= TDraftListView.Create;
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

         fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
         fWidget.Free;
      end else if (AWidget is jSpinner) then
      begin
         fWidget:= TDraftSpinner.Create;
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

         fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
         fWidget.Free;
      end else if (AWidget is jProgressBar) then
      begin
         fWidget:= TDraftProgressBar.Create;
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;
         fWidget.Color:= (AWidget as jProgressBar).BackgroundColor;
         fWidget.FontColor:= colbrBlack;

         if (AWidget as jProgressBar).Parent is jPanel  then
         begin
           if (AWidget as jProgressBar).BackgroundColor = colbrDefault then
               fWidget.Color:= ((AWidget as jProgressBar).Parent as jPanel).BackgroundColor;
         end;

        if (AWidget as jProgressBar).Parent is jCustomDialog  then
        begin
          if (AWidget as jProgressBar).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jProgressBar).Parent as jCustomDialog).BackgroundColor;
        end;

         fWidget.Draw(LCLForm.Canvas, (AWidget as jVisualControl).Text);
         fWidget.Free
      end else if (AWidget is jVisualControl) then     ////generic
      begin
        Brush.Color:= Self.FDefaultBrushColor;
        FillRect(0,0,AWidget.Width,AWidget.Height);
        Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
        //generic
        Font.Color:= clMedGray;
        TextOut(5,4,(AWidget as TAndroidWidget).Text);
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
                             AWidget.Height-AWidget.MarginTop-AWidget.MarginBottom)<>NullRegion then
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

{TAndroidProjectDescriptor}

function TAndroidProjectDescriptor.SettingsFilename: string;
begin
  Result := AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini'
end;

function TAndroidProjectDescriptor.GetPathToJNIFolder(fullPath: string): string;
var
  i: integer;
begin
  //fix by Leledumbo - for linux compatility
  i:= Pos('src',fullPath);
  if i > 2 then
    Result:= Copy(fullPath,1,i - 2)// we don't need the trailing slash
  else raise Exception.Create('src folder not found...');
end;

function TAndroidProjectDescriptor.TryNewJNIAndroidInterfaceCode: boolean;
var
  frm: TFormAndroidProject;
begin

  Result := False;
  frm:= TFormAndroidProject.Create(nil);

  frm.ShellTreeView1.ShowRoot:= False;
  frm.ShellTreeView1.Root:= FAndroidProjectName; {seleceted project}

  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;

  frm.MainActivity:= FMainActivity;
  frm.MinApi:= FMinApi;
  frm.TargetApi:= FTargetApi;

  frm.ProjectModel:= FProjectModel;

  if frm.ShowModal = mrOK then
  begin
    Result := True;
    FSyntaxMode:= frm.SyntaxMode;

    FPathToJavaClass:= frm.PathToJavaClass;
    FPathToJNIFolder:=GetPathToJNIFolder(FPathToJavaClass);

    FModuleType:= frm.ModuleType;  //fix bug - 09-June-2014!

    AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
    AndroidFileDescriptor.ModuleType:= FModuleType;
    AndroidFileDescriptor.SyntaxMode:= FSyntaxMode;

    FJavaClassName:= frm.JavaClassName;
    FPathToClassName:= frm.PathToClassName;
    FPascalJNIInterfaceCode:= frm.PascalJNIInterfaceCode;
    {$I-}
    ChDir(FAndroidProjectName+DirectorySeparator+ 'jni');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'jni');

    ChDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
    if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');

    ChDir(FAndroidProjectName+DirectorySeparator+ 'libs');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'libs');

    if FSupportV4 = 'yes' then  //add android 4.0 support to olds devices ...
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
               FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');



    ChDir(FAndroidProjectName+DirectorySeparator+ 'obj');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'obj');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj'+DirectorySeparator+FJavaClassName);
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'x86');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'x86');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi-v7a');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi-v7a');

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
  Result := 'JNI Android Module'; //fix thanks to Stephano!
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'A JNI Android loadable module (.so)'+ LineEnding +
            'in Free Pascal using datamodule like form.'+ LineEnding +
            'The library file is maintained by Lazarus.'
end;

     //just for test! not realistic!
function TAndroidProjectDescriptor.GetIdFromApi(api: integer): string;
begin
  {
  case api of
     17: result:= '1';
     18: result:= '2';
     19: result:= '3';
  end;
  }
  Result:= '1';
end;
     //just for test!  not realistic!
function TAndroidProjectDescriptor.GetFolderFromApi(api: integer): string;
begin
  case api of
     17: result:= 'android-4.2.2';
     18: result:= 'android-4.3';
     19: result:= 'android-4.4';
  end;
end;

function TAndroidProjectDescriptor.GetWorkSpaceFromForm: boolean;
var
  frm: TFormWorkspace;
  projName: string;
  strList: TStringList;
  i: integer;

  linuxDirSeparator: string;
  linuxPathToJavaJDK: string;
  linuxPathToAndroidSdk: string;

  linuxAndroidProjectName: string;
  tempStr: string;

  linuxPathToAdbBin: string;
  linuxPathToAntBin: string;
begin
  Result:= False;
  frm:= TFormWorkspace.Create(nil);
  frm.LoadSettings(SettingsFilename);
  if frm.ShowModal = mrOK then
  begin
    frm.SaveSettings(SettingsFilename);
    strList:= TStringList.Create;

    FPathToJNIFolder:= frm.PathToWorkspace;

    FInstructionSet:= frm.InstructionSet;{ ex. ArmV6}
    FFPUSet:= frm.FPUSet; {ex. Soft}

    FAndroidProjectName:= frm.AndroidProjectName;    //warning: full project name = path + name !

    FPathToJavaTemplates:= frm.PathToJavaTemplates;
    FPathToJavaJDK:= frm.PathToJavaJDK;
    FPathToAndroidSDK:= frm.PathToAndroidSDK;
    FPathToAndroidNDK:= frm.PathToAndroidNDK;
    FNDK:= frm.NDK;
    FAndroidPlatform:= frm.AndroidPlatform;
    FPathToAntBin:= frm.PathToAntBin;

    FMinApi:= frm.MinApi;
    FTargetApi:= frm.TargetApi;
    FSupportV4:= frm.SupportV4;

    FMainActivity:= frm.MainActivity;

    if  frm.TouchtestEnabled = 'True' then
        FTouchtestEnabled:= '-Dtouchtest.enabled=true'
    else
       FTouchtestEnabled:='';

    FAntBuildMode:= frm.AntBuildMode;

    FProjectModel:= frm.ProjectModel; //Eclipse Project or Ant Project

    strList.StrictDelimiter:= True;
    strList.Delimiter:= DirectorySeparator;
    strList.DelimitedText:= TrimChar(FAndroidProjectName, DirectorySeparator);
    projName:= strList.Strings[strList.Count-1]; //ex. AppTest1

    FAntPackageName:= frm.AntPackageName;

    if  FProjectModel = 'Ant' then
    begin
      FAntPackageName:= frm.AntPackageName;   //ex.: org.lazarus
      strList.Clear;
      strList.StrictDelimiter:= True;
      strList.Delimiter:= '.';
      strList.DelimitedText:= FAntPackageName+'.'+LowerCase(projName);
      if strList.Count < 3 then strList.DelimitedText:= 'org.'+FAntPackageName+'.'+LowerCase(projName);

      ChDir(FAndroidProjectName+DirectorySeparator+ 'src');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'src');

      FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';
      for i:= 0 to strList.Count -1 do
      begin
         FPathToJavaSrc:= FPathToJavaSrc + DirectorySeparator + strList.Strings[i];
         ChDir(FPathToJavaSrc);
         if IOResult <> 0 then MkDir(FPathToJavaSrc);
      end;

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'res');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');

      strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');

      {
      <?xml version="1.0" encoding="utf-8"?>
      <resources>
         <string name="app_name">LazAndroidWizard</string>
         <string name="hello_world">Hello world!</string>
      </resources>
      }

      strList.Strings[2]:='<string name="app_name">'+projName+'</string>';
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');

      CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'styles.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');


      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');

      CopyFile(FPathToJavaTemplates+DirectorySeparator+'values-v11'+DirectorySeparator+'styles.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11'+DirectorySeparator+'styles.xml');


      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');


      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'assets');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'assets');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'bin');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'bin');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'gen');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'gen');

      if FModuleType = 0 then     //Android Bridges Controls...
      begin
        strList.Clear;    //dummy App.java - will be replaced with simonsayz's "App.java" template!
        strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
        strList.Add('public class App extends Activity {');
        strList.Add('     //dummy app');
        strList.Add('}');
        strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'App.java');
      end;

      if FModuleType = 1 then     //Not Android Bridges  Controls...
      begin
         strList.Clear;    //dummy App.java - will be replaced with simonsayz's "App.java" template!
         strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
         strList.Add(' ');
         strList.Add('import android.os.Bundle;');
         strList.Add('import android.app.Activity;');
         strList.Add('import android.widget.Toast;');
         strList.Add(' ');
         strList.Add('public class App extends Activity {');
         strList.Add('  ');
         strList.Add('   JNIHello myHello;  //just for demo...');
         strList.Add('  ');
         strList.Add('   @Override');
         strList.Add('   protected void onCreate(Bundle savedInstanceState) {');
         strList.Add('       super.onCreate(savedInstanceState);');
         strList.Add('       setContentView(R.layout.activity_app);');
         strList.Add(' ');
         strList.Add('       myHello = new JNIHello(); //just for demo...');
         strList.Add(' ');
         strList.Add('       int sum = myHello.getSum(2,3); //just for demo...');
         strList.Add(' ');
         strList.Add('       String mens = myHello.getString(1); //just for demo...');
         strList.Add(' ');
         strList.Add('       Toast.makeText(getApplicationContext(), mens, Toast.LENGTH_SHORT).show();');
         strList.Add('       Toast.makeText(getApplicationContext(), "Total = " + sum, Toast.LENGTH_SHORT).show();');
         strList.Add('   }');
         strList.Add('}');
         strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'App.java');

         strList.Clear;
         strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
         strList.Add(' ');
         strList.Add('public class JNIHello { //just for demo...');
         strList.Add(' ');
	 strList.Add('  public native String getString(int flag);');
	 strList.Add('  public native int getSum(int x, int y);');
         strList.Add(' ');
         strList.Add('  static {');
	 strList.Add('	  try {');
     	 strList.Add('	      System.loadLibrary("jnihello");');
	 strList.Add('	  } catch(UnsatisfiedLinkError ule) {');
 	 strList.Add('	      ule.printStackTrace();');
 	 strList.Add('	  }');
         strList.Add('  }');
         strList.Add(' ');
         strList.Add('}');
         strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'JNIHello.java');

         strList.Clear;
         strList.Add('<?xml version="1.0" encoding="utf-8"?>');
         strList.Add('<manifest xmlns:android="http://schemas.android.com/apk/res/android"');
         strList.Add('    package="'+FAntPackageName+'.'+LowerCase(projName)+'"');
         strList.Add('    android:versionCode="1"');
         strList.Add('    android:versionName="1.0" >');
         strList.Add('    <uses-sdk android:minSdkVersion="10"/>');
         strList.Add('    <application');
         strList.Add('        android:allowBackup="true"');
         strList.Add('        android:icon="@drawable/ic_launcher"');
         strList.Add('        android:label="@string/app_name"');
         strList.Add('        android:theme="@style/AppTheme" >');
         strList.Add('        <activity');
         strList.Add('            android:name="'+FAntPackageName+'.'+LowerCase(projName)+'.App"');
         strList.Add('            android:label="@string/app_name" >');
         strList.Add('            <intent-filter>');
         strList.Add('                <action android:name="android.intent.action.MAIN" />');
         strList.Add('                <category android:name="android.intent.category.LAUNCHER" />');
         strList.Add('            </intent-filter>');
         strList.Add('        </activity>');
         strList.Add('    </application>');
         strList.Add('</manifest>');
         strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');

         strList.Clear;
         strList.Add(FAntPackageName+'.'+LowerCase(projName));
         strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'packagename.txt');

      end;
    end; //just Ant project

    //*.bat utils...
    ChDir(FAndroidProjectName+DirectorySeparator+ 'utils');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'utils');

    strList.Clear;
    strList.Add('set path='+FPathToAntBin);        //set path=C:\adt32\ant\bin
    strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    strList.Add('cd '+FAndroidProjectName);

    if FAntBuildMode = 'debug' then
    begin
      if FTouchtestEnabled='' then
         strList.Add('ant debug')
      else
        strList.Add('ant -Dtouchtest.enabled=true debug');
    end
    else
    begin
     strList.Add('ant release');
    end;
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build.bat'); //build Apk using "Ant"

    {"android list targets" to see the available targets...}
    strList.Clear;
    strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
    strList.Add('android list targets');
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'list_target.bat');

    //need to pause on double-click use...
    strList.Clear;
    strList.Add('cmd /K list_target.bat');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_list_target.bat');

    strList.Clear;
    strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
    strList.Add('android create avd -n avd_default -t 1 -c 32M');
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'create_avd_default.bat');

    //need to pause on double-click use...
    strList.Clear;
    strList.Add('cmd /K create_avd_default.bat');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_create_avd_default.bat');

    strList.Clear;
    strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
    if StrToInt(FMinApi) >= 15 then
      strList.Add('emulator -avd avd_default +  -gpu on &')  //gpu: api >= 15,,,
    else
      strList.Add('tools emulator -avd avd_api_'+FMinApi + ' &');
    strList.Add('cd '+FAndroidProjectName);
   //strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_avd_default.bat');

    strList.Clear;
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
               DirectorySeparator+'adb install -r '+projName+'-'+FAntBuildMode+'.apk');
    strList.Add('cd ..');
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'install.bat');

    strList.Clear;
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
               DirectorySeparator+'adb uninstall '+FAntPackageName+'.'+LowerCase(projName));
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'uninstall.bat');

    strList.Clear;
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
               DirectorySeparator+'adb logcat');
    strList.Add('cd ..');
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+{'utils'+}DirectorySeparator+'logcat.bat');

    strList.Clear;
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
               DirectorySeparator+'adb logcat AndroidRuntime:E *:S');
    strList.Add('cd ..');
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat_error.bat');

    strList.Clear;
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+DirectorySeparator+
               'adb logcat ActivityManager:I '+projName+'-'+FAntBuildMode+'.apk:D *:S');
    strList.Add('cd ..');
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat_app_perform.bat');

   (* //causes instability in the simulator! why ?
   strList.Clear;
   strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
   strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+DirectorySeparator+
               'adb shell am start -a android.intent.action.MAIN -n '+
                FAntPackageName+'.'+LowerCase(projName)+'/.'+FMainActivity);
   strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_apk.bat');
   *)

    strList.Clear;
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+DirectorySeparator+
               'build-tools'+DirectorySeparator+ GetFolderFromApi(StrToInt(FMinApi))+
               DirectorySeparator + 'aapt list '+projName+'-'+FAntBuildMode+'.apk');
    strList.Add('cd ..');
    strList.Add('pause');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'aapt.bat'); //Android Asset Packaging Tool

    strList.Clear;
    strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
    strList.Add('<project name="'+projName+'" default="help">');
    strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');
    strList.Add('<property name="target"  value="android-'+Trim(FTargetApi)+'"/>');
    strList.Add('<property file="ant.properties"/>');
    strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');
    strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');
    strList.Add('</project>');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build.xml');

    strList.Clear;
    strList.Add('Tutorial: How to get your Android Application [Apk] using "Ant":');
    strList.Add(' ');
    strList.Add('1. Double click "build.bat" to build Apk');
    strList.Add(' ');
    strList.Add('2. If Android Virtual Device[AVD]/Emulator [or real device] is running then:');
    strList.Add('   2.1 double click "install.bat" to install the Apk on the Emulator');
    strList.Add('   2.2 look for the App "'+projName+'" in the Emulator and click it!');
    strList.Add(' ');
    strList.Add('3. If AVD/Emulator is NOT running:');
    strList.Add('   3.1 If AVD/Emulator NOT exist:');
    strList.Add('        3.1.1 double click "paused_create_avd_default.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
    strList.Add('   3.2 double click "launch_avd_default.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
    strList.Add('   3.3 look for the App "'+projName+'" in the Emulator and click it!');
    strList.Add(' ');
    strList.Add('4. Log/Debug');
    strList.Add('   4.1 double click "logcat*.bat" to read Emulator logs and bugs! ['+DirectorySeparator+'utils folder]');
    strList.Add(' ');
    strList.Add('5. Uninstall Apk');
    strList.Add('   5.1 double click "uninstall.bat" to remove Apk from the Emulator!');
    strList.Add(' ');
    strList.Add('6. To find your app Look for the "'+projName+'-'+FAntBuildMode+'.apk" in '+DirectorySeparator+'bin folder!');
    strList.Add(' ');
    strList.Add('7. Android Asset Packaging Tool: to know which files were packed in "'+projName+'-'+FAntBuildMode+'.apk"');
    strList.Add('   7.1 double click "aapt.bat" ['+DirectorySeparator+'utils folder]' );
    strList.Add(' ');
    strList.Add('8. To see all available Android targets in your system ['+DirectorySeparator+'utils folder]');
    strList.Add('   8.1 double click "paused_list_target.bat" ');
    strList.Add(' ');
    strList.Add('9. Hint 1: you can edit "*.bat" to extend/modify some command or to fix some incorrect info/path!');
    strList.Add(' ');
    strList.Add('10.Hint 2: you can edit "build.xml" to set another Android target ex. "android-18" or "android-19" etc.');
    strList.Add('   WARNING: Yes, if after run  "build.*" the folder "...\bin" is still empty then try another target!' );
    strList.Add(' ');
    strList.Add('11.WARNING: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "build.bat" and "install.bat" !');
    strList.Add(' ');
    strList.Add('12. Linux users: use "build.sh" , "install.sh" , "uninstall.sh" and "logcat.sh" [thanks to Stephano!]');
    strList.Add('    WARNING: All demos Apps was generate on windows system! So, please,  edit the *.sh to correct paths one!');
    strList.Add(' ');
    strList.Add('13. PLEASE, look for "How to use the Demos" in "readme.txt"!!');
    strList.Add(' ');
    strList.Add('....  Thank you!');
    strList.Add(' ');
    strList.Add('....  by jmpessoa_hotmail_com');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme.txt');


    linuxDirSeparator:=  DirectorySeparator;    //  C:\adt32\eclipse\workspace\AppTest1
    linuxPathToJavaJDK:=  FPathToJavaJDK;       //  C:\adt32\sdk
    linuxAndroidProjectName:= FAndroidProjectName;
    linuxPathToAntBin:= FPathToAntBin;
    linuxPathToAndroidSdk:= FPathToAndroidSDK;
    {$IFDEF WINDOWS}
       linuxDirSeparator:= '/';
       tempStr:= FPathToJavaJDK;
       SplitStr(tempStr, ':');
       linuxPathToJavaJDK:= ReplaceChar (tempStr, '\', '/');

       tempStr:= FAndroidProjectName;
       SplitStr(tempStr, ':');
       linuxAndroidProjectName:= ReplaceChar (tempStr, '\', '/');

       tempStr:= FPathToAntBin;
       SplitStr(tempStr, ':');
       linuxPathToAntBin:= ReplaceChar (tempStr, '\', '/');

       tempStr:= FPathToAndroidSDK;
       SplitStr(tempStr, ':');
       linuxPathToAndroidSdk:= ReplaceChar (tempStr, '\', '/');
    {$ENDIF}

    //linux build Apk using "Ant"  ---- Thanks to Stephano!
    strList.Clear;
    if FPathToAntBin <> '' then
      strList.Add('export PATH='+linuxPathToAntBin+':PATH'); //export PATH=/usr/bin/ant:PATH

    strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    strList.Add('cd '+linuxAndroidProjectName);

    if FAntBuildMode = 'debug' then
    begin
      if FTouchtestEnabled='' then
         strList.Add('ant debug')
      else
        strList.Add('ant -Dtouchtest.enabled=true debug');
    end
    else
    begin
     strList.Add('ant release');
    end;
    strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'build.sh');

    linuxPathToAdbBin:= linuxPathToAndroidSdk+linuxDirSeparator+'platform-tools';

    //linux install - thanks to Stephano!
    strList.Clear;
    strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FAntPackageName+'.'+LowerCase(projName));
    strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r '+linuxDirSeparator+'bin'+linuxDirSeparator+projName+'-'+FAntBuildMode+'.apk');
    strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
    strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'install.sh');

    //linux uninstall  - thanks to Stephano!
    strList.Clear;
    strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FAntPackageName+'.'+LowerCase(projName));
    strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'uninstall.sh');

    //linux logcat  - thanks to Stephano!
    strList.Clear;
    strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
    strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'logcat.sh');

    strList.Free;
    Result := True;
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
  listAux.StrictDelimiter:= True;
  listAux.Delimiter:= '.';
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
  auxList: TStringList;

  libraries_x86: string;
  libraries_arm: string;

  customOptions_x86: string;
  customOptions_default: string;

  customOptions_armV6: string;

  customOptions_armV7a: string;

  pathToNdkPlataformsArm: string;
  pathToNdkPlataformsX86: string;

  pathToNdkToolchainsX86: string;
  pathToNdkToolchainsArm: string;

   //by Stephano
  pathToNdkToolchainsBinX86: string;
  pathToNdkToolchainsBinArm: string;

  osys: string;      {windows or linux-x86}
begin

  inherited InitProject(AProject);

  sourceList:= TStringList.Create;

  projName:= LowerCase(FJavaClassName) + '.lpr';

  MainFile := AProject.CreateProjectFile(projName);
  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType = 0 then
    AProject.AddPackageDependency('tfpandroidbridge_pack'); //GUI controls

  sourceList.Add('{hint: save all files to location: ' +FPathToJNIFolder+DirectorySeparator+'jni }');
  sourceList.Add('library '+ LowerCase(FJavaClassName) +'; '+ ' //[by LazAndroidWizard: '+DateTimeToStr(Now)+']');
  sourceList.Add(' ');
  sourceList.Add('{$mode delphi}');
  sourceList.Add(' ');
  sourceList.Add('uses');
  if FModuleType = 0 then  //GUI controls
  begin
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls, Laz_And_Controls_Events;');
    sourceList.Add(' ');
  end
  else //generic module :  Not Android Bridges Controls
  begin
    sourceList.Add('  Classes, SysUtils, CustApp, jni;');
    sourceList.Add(' ');
    sourceList.Add('type');
    sourceList.Add(' ');
    sourceList.Add('  jApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add(' ');
    sourceList.Add('procedure jApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('constructor jApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('destructor jApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('var');
    sourceList.Add('  gApp: jApp;');
    sourceList.Add(' ');
  end;

  sourceList.Add(Trim(FPascalJNIInterfaceCode));  {from form...}

  sourceList.Add(' ');
  sourceList.Add('begin');
  if FModuleType = 0 then  //Android Bridges ontrols...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);{Laz_And_Controls}');
    sourceList.Add('  gApp.Title:= ''My Android Bridges Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';{And_jni_Bridge}');
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';{And_jni_Bridge}');
    sourceList.Add('  gApp.AppName:=gjAppName;');
    sourceList.Add('  gApp.ClassName:=gjClassName;');
    sourceList.Add('  gApp.Initialize;');
    sourceList.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else
  begin
     sourceList.Add('  gApp:= jApp.Create(nil);');
     sourceList.Add('  gApp.Title:= ''My Android Pure Library'';');
     sourceList.Add('  gApp.Initialize;');
     sourceList.Add('  gApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);');
  end;

  sourceList.Add('end.');

  AProject.MainFile.SetSourceText(sourceList.Text);

  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  if (Pos('\', FPathToAndroidNDK) > 0) or (Pos(':', FPathToAndroidNDK) > 0) then osys:= 'windows'
  else osys:= 'linux-x86';

  {Set compiler options for Android requirements}

  pathToNdkPlataformsArm:= FPathToAndroidNDK+DirectorySeparator+'platforms'+DirectorySeparator+
                                                FAndroidPlatform +DirectorySeparator+'arch-arm'+DirectorySeparator+
                                                'usr'+DirectorySeparator+'lib';

  if FNDK = '7' then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.4.3';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.6';

  if FNDK = '7' then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

  libraries_arm:= pathToNdkPlataformsArm+';'+pathToNdkToolchainsArm;

  pathToNdkPlataformsX86:= FPathToAndroidNDK+DirectorySeparator+'platforms'+DirectorySeparator+
                                             FAndroidPlatform+DirectorySeparator+'arch-x86'+DirectorySeparator+
                                             'usr'+DirectorySeparator+'lib';
  if FNdk = '7' then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+
                                                 'gcc'+DirectorySeparator+'i686-android-linux'+DirectorySeparator+'4.4.3';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.6';

  if FNDK = '7' then
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  libraries_x86:= pathToNdkPlataformsX86+';'+pathToNdkToolchainsX86;

  if Pos('x86', FInstructionSet) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'i386';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_x86;
     FPathToNdkPlataforms:= pathToNdkPlataformsX86;
     FPathToNdkToolchains:= pathToNdkToolchainsX86;
  end
  else
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_arm;
     FPathToNdkPlataforms:= pathToNdkPlataformsArm;
     FPathToNdkToolchains:= pathToNdkToolchainsArm
  end;

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

  AProject.LazCompilerOptions.OptimizationLevel:= 1;
  AProject.LazCompilerOptions.Win32GraphicApp:= False;

  {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;

  {Verbose}
      //.....................

  auxList:= TStringList.Create;

  auxStr:= 'armeabi';  //ARMv6
  if FInstructionSet = 'ARMv7a' then auxStr:='armeabi-v7a';
  if FInstructionSet = 'x86' then auxStr:='x86';

  if FInstructionSet <> 'x86' then
  begin
     customOptions_default:='-Xd'+' -Cf'+ FFPUSet;
     customOptions_default:= customOptions_default + ' -Cp'+ UpperCase(FInstructionSet); //until laz bug fix for ARMV7A
  end
  else
  begin
     customOptions_default:= '-Xd';
  end;

  customOptions_armV6:= '-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV6';  //until laz bug fix for ARMV7A
  customOptions_armV7a:='-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV7A'; //until laz bug fix for ARMV7A
  customOptions_x86:=   '-Xd';

  customOptions_default:=customOptions_default+' -XParm-linux-androideabi-';
  customOptions_armV6:=  customOptions_armV6  +' -XParm-linux-androideabi-';
  customOptions_armV7a:= customOptions_armV7a +' -XParm-linux-androideabi-';
  customOptions_x86:=    customOptions_x86    +' -XPi686-linux-android-';   //fix by jmpessoa

  if FInstructionSet <> 'x86' then
  begin
    customOptions_default:= customOptions_default+' -FD'+pathToNdkToolchainsBinArm;
  end
  else
  begin
    customOptions_default:= customOptions_default+' -FD'+pathToNdkToolchainsBinX86;
  end;

  customOptions_armV6:= customOptions_armV6+' -FD'+pathToNdkToolchainsBinArm;
  customOptions_armV7a:= customOptions_armV7a+' -FD'+pathToNdkToolchainsBinArm;
  customOptions_x86:= customOptions_x86+' -FD'+pathToNdkToolchainsBinX86;

  {$IFDEF WINDOWS}
     //to others :: just to [fix a bug]  lazarus  rev < 46598 .... //thanks to Stephano!
     // ThierryDijoux - change auxStr by value of the correct folder
     customOptions_default:= customOptions_default+' -o..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr       +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_armV6:=   customOptions_armV6  +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'armeabi'    +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_armV7a:=  customOptions_armV7a +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a'+DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_x86:=     customOptions_x86    +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'x86'        +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
  {$ENDIF}

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_x86+'"/>');
  auxList.Add('<TargetCPU Value="i386"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV6"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt');

  auxList.Clear;
  auxList.Add('How To Get More Builds:');
  auxList.Add(' ');
  auxList.Add('   :: Warning: Your system [Laz4Android ?] needs to be prepared for the various builds!');
  auxList.Add(' ');
  auxList.Add('1. Edit Lazarus project file "*.lpi": [use notepad like editor]');
  auxList.Add(' ');
  auxList.Add('   > Open the "*.lpi" project file');
  auxList.Add(' ');
  auxList.Add('       -If needed replace the line <Libraries ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetCPU ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <CustomOptions ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetProcessor...../> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add(' ');
  auxList.Add('   > Save the modified "*.lpi" project file ');
  auxList.Add(' ');
  auxList.Add('2. From Laz4Android IDE');
  auxList.Add(' ');
  auxList.Add('   >Reopen the Project');
  auxList.Add(' ');
  auxList.Add('   > Run -> Build');
  auxList.Add(' ');
  auxList.Add('4. Repeat for others "build_*.txt" if needed...');
  auxList.Add(' ');

  if FProjectModel = 'Ant' then
    auxList.Add('4. Execute [double click] the "build.bat" file to get the Apk !')
  else
  begin
    auxList.Add('4. From Eclipse IDE:');
    auxList.Add(' ');
    auxList.Add('   -right click your  project: -> Refresh');
    auxList.Add(' ');
    auxList.Add('   -right click your  project: -> Run as -> Android Application');
  end;

  auxList.Add(' ');
  auxList.Add(' ');
  auxList.Add(' ');
  auxList.Add('      Thank you!');
  auxList.Add('      By  ___jmpessoa_hotmail.com_____');

  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt');

  auxList.Free;

  AProject.LazCompilerOptions.TargetFilename:=
          '..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+LowerCase(FJavaClassName){+'.so'};

  AProject.LazCompilerOptions.UnitOutputDirectory :=
         '..'+DirectorySeparator+'obj'+ DirectorySeparator+LowerCase(FJavaClassName); {-FU}

  {TargetProcessor}

  (* //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FInstructionSet <> 'x86' then
     AProject.LazCompilerOptions.TargetProcessor:= UpperCase(FInstructionSet); {-Cp}
  *)

  {Others}
  AProject.LazCompilerOptions.CustomOptions:= customOptions_default;

  sourceList.Free;
  Result := mrOK;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  //AndroidFileDescriptor.ResourceClass:= TAndroidForm;

  //ShowMessage('ModuleType = '+ IntToStr(FModuleType));
  if FModuleType = 0 then  //GUI Controls
  begin
    AndroidFileDescriptor.ResourceClass:= TAndroidModule;
  end
  else // =1 -> No GUI Controls
  begin
    AndroidFileDescriptor.ResourceClass:= TNoGUIAndroidModule;
  end;


  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
  Result := mrOK;
end;

{ TAndroidFileDescriptor}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;

  Name := 'Android DataModule';

  if ModuleType = 0 then
    ResourceClass := TAndroidModule
  else
    ResourceClass := TNoGUIAndroidModule;

  UseCreateFormStatements:=true;

end;

function TAndroidFileDescPascalUnitWithResource.GetResourceType: TResourceType;
begin
   Result:= rtRes;
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedName: string;
begin
   Result := 'Android DataModule'
   //Result:='AndroidForm';
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
   Result := 'Create a new Unit with a DataModule for JNI Android module (.so)';
   //Result:='Create a New AndroidForm [Not LCL AndroidWidgets ToolKit]';
end;

function TAndroidFileDescPascalUnitWithResource.CreateSource(const Filename     : string;
                                                       const SourceName   : string;
                                                       const ResourceName : string): string;
var
   sourceList: TStringList;
   uName:  string;
begin
   uName:= FileName;
   uName:= SplitStr(uName,'.');
   sourceList:= TStringList.Create;
   sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }');
   sourceList.Add('unit '+uName+';');
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
   if ModuleType = 1 then //no GUI
   begin
    sourceList.Add(' ');
    sourceList.Add('const');
    sourceList.Add('  gjClassPath: string='''';');
    sourceList.Add('  gjClass: JClass=nil;');
    sourceList.Add('  gPDalvikVM: PJavaVM=nil;');
   end;
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
  if ModuleType = 1 then //generic module: No GUI Controls
    Result := 'Classes, SysUtils, jni, AndroidWidget;'
  else  //GUI controls module
    Result := 'Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;';

   //Result:='Classes, SysUtils, AndroidWidget;';
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
  begin
    if ResourceName <> '' then
       strList.Add('  T' + ResourceName + ' = class(jForm)')
    else
       strList.Add('  TAndroidModuleXX = class(jForm)');
  end
  else //generic module
  begin
    if ResourceName <> '' then
      strList.Add('  T' + ResourceName + ' = class(TDataModule)')
    else
      strList.Add('  TNoGUIAndroidModuleXX  = class(TDataModule)');
  end;
  strList.Add('   private');
  strList.Add('     {private declarations}');
  strList.Add('   public');
  strList.Add('     {public declarations}');
  strList.Add('  end;');
  strList.Add(' ');
  strList.Add('var');
  //strList.Add('  ' + ResourceName + ': T' + ResourceName + ';');
  if ModuleType = 0 then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
       strList.Add('  AndroidModuleXX: TDataMoule');
  end
  else //generic module
  begin
    if ResourceName <> '' then
      strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
      strList.Add('  NoGUIAndroidModuleXX: TNoGUIDataMoule');
  end;
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
       Result:= theString;
       theString:= '';
    end;
  end;
end;

procedure GetRedGreenBlue(rgb: longInt; out Red, Green, Blue: word);
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

      {TDraftWidget}

constructor TDraftWidget.Create;
begin
  TextColor:= clNone;
  BackGroundColor:= clNone;
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

procedure TDraftWidget.Draw(canvas: TCanvas; txt: string);
begin
   //
end;

      {TDraftButton}

constructor TDraftButton.Create;
begin
  inherited Create;
  //BackGroundColor:= clActiveCaption;
end;

procedure TDraftButton.Draw(canvas: TCanvas; txt: string);
begin

  canvas.Brush.Color:= Self.BackGroundColor;
  canvas.Pen.Color:= clForm; //clWindowFrame; //clWhite;
  canvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
    canvas.Brush.Color:= clGray; //clMedGray;

  if Self.TextColor = clNone then
     canvas.Font.Color:= clBlack;

  canvas.FillRect(0,0,Self.Width,Self.Height);
  //outer frame
  canvas.Rectangle(0,0,Self.Width,Self.Height);

  canvas.Pen.Color:= clMedGray; //clForm; //clWhite; //clWindowFrame; //clWindowFrame; //clBlack;//clGray; //Self.FDefaultPenColor;
  canvas.Brush.Style:= bsClear;
  canvas.Rectangle(3,3,Self.Width-3,Self.Height-3);

  canvas.TextOut(5,4,txt);

end;

      {TDraftTextView}

constructor TDraftTextView.Create;
begin
  inherited Create;
  BackGroundColor:= clNone; //clForm; //clActiveCaption;
end;

procedure TDraftTextView.Draw(canvas: TCanvas; txt: string);
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

  canvas.TextOut(5,4,txt);

  canvas.Brush.Style:= bsSolid;
end;
      {TDraftEditText}
constructor TDraftEditText.Create;
begin
  inherited Create;
  BackGroundColor:= clNone; //clActiveCaption;
end;

procedure TDraftEditText.Draw(canvas: TCanvas; txt: string);
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


  canvas.TextOut(5,4,txt);
end;
      {TDraftCheckBox}
constructor TDraftCheckBox.Create;
begin
  inherited Create;
  BackGroundColor:= clNone; //clActiveCaption;
end;

procedure TDraftCheckBox.Draw(canvas: TCanvas; txt: string);
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

  canvas.TextOut(28,8,txt);

  canvas.Brush.Style:= bsSolid;
  canvas.Brush.Color:= clWhite;
  canvas.Pen.Color:= canvas.Font.Color;
  canvas.Rectangle(Self.MarginLeft+1,Self.MarginTop+1,
            Self.MarginLeft+18,
            Self.MarginTop+18);
end;
      {TDraftRadioButton}

constructor TDraftRadioButton.Create;
begin
  inherited Create;
  BackGroundColor:= clNone; //clActiveCaption;
end;

procedure TDraftRadioButton.Draw(canvas: TCanvas;  txt: string);
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
  canvas.TextOut(28,8,txt);

  canvas.Brush.Style:= bsSolid;
  canvas.Brush.Color:= clWhite;
  canvas.Pen.Color:= canvas.Font.Color;
  canvas.Ellipse(Self.MarginLeft+1,Self.MarginTop+1,
            Self.MarginLeft+18,
            Self.MarginTop+18);
end;
      {TDraftProgressBar}

constructor TDraftProgressBar.Create;
begin
  inherited Create;
end;

procedure TDraftProgressBar.Draw(canvas: TCanvas; txt: string);
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
  canvas.Font.Color:= clBlack;
  canvas.TextOut(12,8, txt);

end;
      {TDraftListView}

constructor TDraftListView.Create;
begin
  inherited Create;
end;

procedure TDraftListView.Draw(canvas: TCanvas; txt: string);
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

  canvas.Brush.Style:= bsClear;
  canvas.Font.Color:= Self.TextColor;
  canvas.TextOut(5,4, txt);

end;
      {TDraftImageBtn}

constructor TDraftImageBtn.Create;
begin
  inherited Create;
  BackGroundColor:= clActiveCaption;; //clMenuHighlight;
end;

procedure TDraftImageBtn.Draw(canvas: TCanvas; txt: string);
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

      {TDraftSpinner}

constructor TDraftSpinner.Create;
begin
  inherited Create;
  //BackGroundColor:= clInactiveBorder; //clActiveCaption;
end;

procedure TDraftSpinner.SetDropListBackgroundColor(color: TARGBColorBridge);
begin
  FDropListBackgroundColor:= color;
  if color <> colbrDefault then
    DropListColor:= FPColorToTColor(ToTFPColor(color))
  else
    DropListColor:= clNone;
end;

procedure TDraftSpinner.SetDropListTextColor(color: TARGBColorBridge);
var
  fpColor: TFPColor;
begin
  FDropListTextColor:= color;
  if color <> colbrDefault then
  begin
    fpColor:= ToTFPColor(color);
    DropListFontColor:= FPColorToTColor(fpColor);
  end
  else DropListFontColor:= clNone;
end;

procedure TDraftSpinner.SetSelectedFontColor(color: TARGBColorBridge);
var
  fpColor: TFPColor;
begin
  FSelectedFontColor:= color;
  if color <> colbrDefault then
  begin
    fpColor:= ToTFPColor(color);
    SelectedTextColor:= FPColorToTColor(fpColor);
  end
  else SelectedTextColor:= clNone;
end;

procedure TDraftSpinner.Draw(canvas: TCanvas;  txt: string);
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

  canvas.TextOut(5,4,txt);

end;

   {TDraftWebView}

constructor TDraftWebView.Create;
begin
 inherited Create;
 BackGroundColor:= clWhite; //clMoneyGreen; //clInactiveBorder; //clActiveCaption;
end;

procedure TDraftWebView.Draw(canvas: TCanvas;  txt: string);
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

 canvas.TextOut(10,6,txt);
end;

{TDraftScrollView}

constructor TDraftScrollView.Create;
begin
  inherited Create;
end;

procedure TDraftScrollView.Draw(canvas: TCanvas;  txt: string);
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
  canvas.Brush.Style:= bsClear;
  canvas.TextOut(10,6,txt);

end;

end.

