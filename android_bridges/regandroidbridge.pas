unit regandroidbridge;
  
{$mode objfpc}{$H+}
  
interface

//please, do not change this code format/layout!

uses 
  Classes,
  tablelayout,
  SysUtils,
  LResources,
  AndroidWidget,
  gif,
  zoomableimageview,
  Laz_And_Controls,
  {$IFNDEF Darwin}
  Laz_And_GLESv1_Canvas,
  Laz_And_GLESv2_Canvas,
  {$ENDIF}
  comboedittext,
  customdialog,
  digitalClock,
  analogClock,
  chronometer,
  calendarview,
  drawingview,
  autocompletetextview,
  radiogroup,
  ratingbar,
  seekbar,
  surfaceview,
  gridview,
  switchbutton,
  togglebutton,
  actionbartab,
  menu,
  contextmenu,
  spinner,
  viewflipper,
  videoview,
  toolbar,
  expandablelistview,
  linearlayout,
  framelayout,
  captionpanel,
  customcamera,
  searchview,
  zbarcodescannerview,
  paintshader,
  imagebutton;

Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin
  {$I jmenu_icon.lrs}
  {$I jcontextmenu_icon.lrs}
  {$I jtextview_icon.lrs}
  {$I jedittext_icon.lrs}
  {$I jbutton_icon.lrs}
  {$I jCheckBox_icon.lrs}
  {$I jRadioButton_icon.lrs}
  {$I jradiogroup_icon.lrs}
  {$I jProgressBar_icon.lrs}
  {$I jratingbar_icon.lrs}
  {$I jseekbar_icon.lrs}
  {$I jspinner_icon.lrs}
  {$I jcomboedittext_icon.lrs}
  {$I jautotextview_icon.lrs}
  {$I jsearchview_icon.lrs}
  {$I jgridview_icon.lrs}
  {$I jListView_icon.lrs}
  {$I jdblistview_icon.lrs}
  {$I jScrollView_icon.lrs}
  {$I jHorizontalScrollView_icon.lrs}
  {$I jactionbartab_icon.lrs}
  {$I jpanel_icon.lrs}
  {$I jcustomdialog_icon.lrs}
  {$I jchronometer_icon.lrs}
  {$I jdigitalclock_icon.lrs}
  {$I janalogclock_icon.lrs}
  {$I jcalendarview_icon.lrs}
  {$I jswitchbutton_icon.lrs}
  {$I jtogglebutton_icon.lrs}
  {$I jImageBtn_icon.lrs}
  {$I jWebView_icon.lrs}
  {$I jImageView_icon.lrs}
  {$I jzoomableimageview_icon.lrs}
  {$I jImageList_icon.lrs}
  {$I jimagebutton_icon.lrs}
  {$I jView_icon.lrs}
  {$I jcanvas_icon.lrs}
  {$I jdrawingview_icon.lrs}
  {$I jPaintShader_icon.lrs}
  {$I jsurfaceview_icon.lrs}
  {$I jcustomcamera_icon.lrs}
  {$I jBitmap_icon.lrs}
  {$I jgif_icon.lrs}
  {$IFNDEF Darwin}
  {$I jcanvases1_icon.lrs}
  {$I jcanvases2_icon.lrs}
  {$ENDIF}
  {$I jviewflipper_icon.lrs}
  {$I jvideoview_icon.lrs}
  {$I jtoolbar_icon.lrs}
  {$I jexpandablelistview_icon.lrs}
  {$I jtablelayout_icon.lrs}
  {$I jlinearlayout_icon.lrs}
  {$I jframelayout_icon.lrs}
  {$I jcaptionpanel_icon.lrs}
  {$I jzbarcodescannerview_icon.lrs}
  RegisterComponents('Android Bridges',
    [
      jMenu,
      jContextMenu,
      jTextView,
      jEditText,
      jButton,
      jCheckBox,
      jRadioButton,
      jRadioGroup,
      jProgressBar,
      jRatingBar,
      jSeekBar,
      jSpinner,
      jComboEditText,
      jAutoTextView,
      jSearchView,
      jGridView,
      jListView,
      jDBListView,
      jScrollView,
      jHorizontalScrollView,
      jActionBarTab,
      jPanel,
      jCustomDialog,
      jChronometer,
      jDigitalClock,
      jAnalogClock,
      jCalendarView,
      jSwitchButton,
      jToggleButton,
      jImageBtn,
      jWebView,
      jImageView,
      jZoomableImageView,
      jImageList,
      jImageButton,
      jView,
      jCanvas,
      jDrawingView,
      jPaintShader,
      jSurfaceView,
      jCustomCamera,
      jBitmap,
      jGif,
      {$IFNDEF Darwin}
      jCanvasES1,
      jCanvasES2,
      {$ENDIF}
      jViewFlipper,
      jVideoView,
      jToolbar,
      jExpandableListView,
      jTableLayout,
      jLinearLayout,
      jFrameLayout,
      jCaptionPanel,
      jZBarcodeScannerView
    ]
  );
  RegisterClasses([jApp, jForm, jControl, jVisualControl{$IFNDEF Darwin}, jGLViewEvent{$ENDIF}]);
  RegisterNoIcon([jApp, jForm, jControl, jVisualControl{$IFNDEF Darwin}, jGLViewEvent{$ENDIF}]);
end;
  
end.
