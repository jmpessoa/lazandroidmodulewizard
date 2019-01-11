{Hint: save all files to location: C:\adt32\eclipse\workspace\AppCameraDemo\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jCamera1: jCamera;
    jCanvas1: jCanvas;
    jEditText1: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jPanel4: jPanel;
    jPanel5: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jView1: jView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1PrepareOptionsMenu(Sender: TObject;
      jObjMenu: jObject; menuSize: integer; out prepareItems: boolean);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure jButton1Click(Sender: TObject);
    procedure jView1Draw(Sender: TObject; Canvas: jCanvas);
  private
    {private declarations}
    FPhotoExist: boolean;
    FSaveRotate: TScreenStyle;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.CAMERA') and
      IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
       jCamera1.RequestCode := 12345;
       jCamera1.TakePhoto;
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

procedure TAndroidModule1.jView1Draw(Sender: TObject; Canvas: jCanvas);
begin
  if FPhotoExist then
  begin
    jView1.Canvas.DrawBitmap(jBitmap1.GetImage, jView1.Width, jView1.Height);
    //just to ilustration.... you can draw and write over....
    jView1.Canvas.PaintColor := colbrRed;
    jView1.Canvas.drawLine(0, 0, Trunc(jView1.Width / 2), Trunc(jView1.Height / 2));
    jView1.Canvas.drawText('Hello People!', 30, 30);
  end;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  FPhotoExist := False;
  FSaveRotate := ssPortrait;  //default: Vertical
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if resultCode = RESULT_CANCELED then
  begin
    ShowMessage('Photo Canceled!')
  end
  else if resultCode = RESULT_OK then //ok...
  begin
    if requestCode = jCamera1.RequestCode then
    begin
      jBitmap1.LoadFromFile(jCamera1.FullPathToBitmapFile);
      jImageView1.SetImageBitmap(jBitmap1.GetImage, jImageView1.Width, jImageView1.Height);

      FPhotoExist:= True;
      jView1.Refresh;   //dispatch   OnDraw!
    end;
  end
  else
    ShowMessage('Photo Fail!');

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;
begin

  if Self.GetScreenOrientationStyle = ssLandscape then   // device is on horizontal...
  begin               //reconfigure....

    FSaveRotate := ssLandscape;

    jPanel1.LayoutParamHeight := lpMatchParent;
    jPanel1.LayoutParamWidth := lpOneQuarterOfParent;
    jPanel1.PosRelativeToParent := [rpLeft];

    jPanel2.LayoutParamHeight := lpMatchParent;
    jPanel2.LayoutParamWidth := lpOneThirdOfParent;
    jPanel2.PosRelativeToAnchor := [raToRightOf, raAlignBaseline];

    jPanel3.LayoutParamHeight := lpMatchParent;
    jPanel3.LayoutParamWidth := lpOneThirdOfParent;
    jPanel3.PosRelativeToAnchor := [raToRightOf, raAlignBaseline];

  end
  else
  begin
    jPanel1.LayoutParamHeight := lpOneThirdOfParent;
    jPanel1.LayoutParamWidth := lpMatchParent;
    jPanel1.PosRelativeToParent := [rpTop];

    jPanel2.LayoutParamHeight := lpOneThirdOfParent;
    jPanel2.LayoutParamWidth := lpMatchParent;
    jPanel2.PosRelativeToAnchor := [raBelow];

    jPanel3.LayoutParamHeight := lpOneThirdOfParent;
    jPanel3.LayoutParamWidth := lpMatchParent;
    jPanel3.PosRelativeToAnchor := [raBelow];
    ;

  end;
  jPanel1.ClearLayout;
  jPanel2.ClearLayout;
  jPanel3.ClearLayout;

  Self.UpdateLayout;
  jEditText1.SetFocus;

  //https://www.captechconsulting.com/blogs/runtime-permissions-best-practices-and-how-to-gracefully-handle-permission-removal
  //https://developer.android.com/guide/topics/security/permissions#normal-dangerous
  if  IsRuntimePermissionNeed() then   // that is, target API >= 23
  begin

      ShowMessage('warning: Requesting Runtime Permission.... please, wait..');

      SetLength(manifestPermissions, 2);

      manifestPermissions[0]:= 'android.permission.CAMERA';  //from AndroodManifest.xml
      manifestPermissions[1]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml

      Self.RequestRuntimePermission(manifestPermissions, 1001);

      SetLength(manifestPermissions, 0);

  end;
end;

procedure TAndroidModule1.AndroidModule1PrepareOptionsMenu(Sender: TObject;
  jObjMenu: jObject; menuSize: integer; out prepareItems: boolean);
begin
  self.UpdateLayout;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
     1001:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
  end;
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
begin
  FSaveRotate := rotate;
  if rotate = ssLandscape then
  begin
    //after rotation device is on horizontal
    jPanel1.LayoutParamHeight := lpMatchParent;
    jPanel1.LayoutParamWidth := lpOneThirdOfParent;
    jPanel1.PosRelativeToParent := [rpLeft];

    jPanel2.LayoutParamHeight := lpMatchParent;
    jPanel2.LayoutParamWidth := lpOneThirdOfParent;
    jPanel2.PosRelativeToAnchor := [raToRightOf, raAlignBaseline];

    jPanel3.LayoutParamHeight := lpMatchParent;
    jPanel3.LayoutParamWidth := lpOneThirdOfParent;
    jPanel3.PosRelativeToAnchor := [raToRightOf, raAlignBaseline];
  end;

  if rotate = ssPortrait then
  begin
    //after rotation device is in vertical :: default
    jPanel1.LayoutParamHeight := lpOneThirdOfParent;
    jPanel1.LayoutParamWidth := lpMatchParent;
    jPanel1.PosRelativeToParent := [rpTop];

    jPanel2.LayoutParamHeight := lpOneThirdOfParent;
    jPanel2.LayoutParamWidth := lpMatchParent;
    jPanel2.PosRelativeToAnchor := [raBelow];

    jPanel3.LayoutParamHeight := lpOneThirdOfParent;
    jPanel3.LayoutParamWidth := lpMatchParent;
    jPanel3.PosRelativeToAnchor := [raBelow];
  end;

  if rotate in [ssLandscape, ssPortrait] then
  begin
    jPanel1.ClearLayout;
    jPanel2.ClearLayout;
    jPanel3.ClearLayout;
    jPanel5.ClearLayout;
    Self.UpdateLayout;
  end;

end;

end.
