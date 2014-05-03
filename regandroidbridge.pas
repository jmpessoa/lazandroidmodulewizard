unit regandroidbridge;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Laz_And_Controls, Laz_And_GLESv1_Canvas, Laz_And_GLESv2_Canvas, LResources;

Procedure Register;

implementation

Procedure Register;
begin
  {$I jtextview_icon.lrs}
  {$I jedittext_icon.lrs}
  {$I jbutton_icon.lrs}
  {$I jCheckBox_icon.lrs}
  {$I jRadioButton_icon.lrs}
  {$I jProgressBar_icon.lrs}
  {$I jViewFlipper_icon.lrs}
  {$I jListView_icon.lrs}
  {$I jScrollView_icon.lrs}
  {$I jHorizontalScrollView_icon.lrs}
  {$I jpanel_icon.lrs}
  {$I jImageBtn_icon.lrs}
  {$I jImageView_icon.lrs}
  {$I jImageList_icon.lrs}
  {$I jView_icon.lrs}
  {$I jcanvas_icon.lrs}
  {$I jBitmap_icon.lrs}
  {$I jDialogYN_icon.lrs}
  {$I jDialogProgress_icon.lrs}
  {$I jcanvases1_icon.lrs}
  {$I jcanvases2_icon.lrs}
  {$I jTimer_icon.lrs}
  {$I jAsyncTask_icon.lrs}
  {$I jsms_icon.lrs}
  {$I jcamera_icon.lrs}
  {$I jWebView_icon.lrs}
  {$I jhttpclient_icon.lrs}
  {$I jsmtpclient_icon.lrs}
  {$I jsqlitedataaccess_icon.lrs}
  {$I jsqlitecursor_icon.lrs}
  RegisterComponents('Android Bridges',[jTextView, jEditText, jButton ,jCheckBox, jRadioButton,
                                        jProgressBar, jViewFlipper, jListView,
                                        jScrollView,jHorizontalScrollView, jPanel,
                                        jImageBtn, jImageView, jImageList,
                                        jView, jCanvas, jBitmap,
                                        jDialogYN, jDialogProgress,
                                        jCanvasES1, jCanvasES2,
                                        jTimer, jAsyncTask, jSMS, jCamera, jWebView, jHttpClient, jSmtpClient,
                                        jSqliteDataAccess, jSqliteCursor]);

  RegisterClasses([jApp, jForm, jControl, jVisualControl, jGLViewEvent]);
  RegisterNoIcon([jApp, jForm, jControl, jVisualControl, jGLViewEvent]);
end;

initialization

end.

