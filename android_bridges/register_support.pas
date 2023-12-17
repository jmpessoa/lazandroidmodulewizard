unit register_support;
  
{$mode objfpc}{$H+}
  
interface
  
//please, do not change this code format/layout!

uses
  Classes,
  ujsarduinoaflakserial,
  ujsescposthermalprinter,
  uktoybutton,
  sfirebasepushnotificationlistener,
  scontinuousscrollableimageview,
  sadmob,
  sdrawerlayout,
  snavigationview,
  scoordinatorlayout,
  sappbarlayout,
  scollapsingtoolbarlayout,
  stoolbar,
  stablayout,
  snestedscrollview,
  srecyclerview,
  sviewpager,
  scardview,
  sfloatingbutton,
  sbottomnavigationview,
  stextinput,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin
  {$I jsarduinoaflakserial_icon.lrs}
  {$I jsescposthermalprinter_icon.lrs}
  {$I ktoybutton_icon.lrs}
  {$I jsfirebasepushnotificationlistener_icon.lrs}
  {$I jsadmob_icon.lrs}
  {$I jscontinuousscrollableimageview_icon.lrs}
  {$I jsdrawerlayout_icon.lrs}
  {$I jsnavigationview_icon.lrs}
  {$I jscoordinatorlayout_icon.lrs}
  {$I jsappbarlayout_icon.lrs}
  {$I jscollapsingtoolbarlayout_icon.lrs}
  {$I jstoolbar_icon.lrs}
  {$I jstablayout_icon.lrs}
  {$I jsnestedscrollview_icon.lrs}
  {$I jsrecyclerview_icon.lrs}
  {$I jsviewpager_icon.lrs}
  {$I jscardview_icon.lrs}
  {$I jsfloatingbutton_icon.lrs}
  {$I jsbottomnavigationview_icon.lrs}
  {$I jstextinput_icon.lrs}
  RegisterComponents('Android Bridges AppCompat',
    [
      jsArduinoAflakSerial,
      jsEscPosThermalPrinter,
      KToyButton,
      jsFirebasePushNotificationListener,
      jsAdMob,
      jsContinuousScrollableImageView,
      jsDrawerLayout,
      jsNavigationView,
      jsCoordinatorLayout,
      jsAppBarLayout,
      jsCollapsingToolbarLayout,
      jsToolbar,
      jsTabLayout,
      jsNestedScrollView,
      jsRecyclerView,
      jsViewPager,
      jsCardView,
      jsFloatingButton,
      jsBottomNavigationView,
      jsTextInput
    ]
  );
end;
  
end.
