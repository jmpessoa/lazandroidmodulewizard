{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDemo1\jni }
unit unit1;
  
{$mode delphi}

interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jImageList1: jImageList;
      jImageList2: jImageList;
      jImageView1: jImageView;
      jImageView2: jImageView;
      jTextView1: jTextView;
      jTimer1: jTimer;
      procedure AndroidModule1Close(Sender: TObject);
      procedure AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean
        );
      procedure AndroidModule1Create(Sender: TObject);
      procedure AndroidModule1Init(Sender: TObject);
      procedure AndroidModule1RequestPermissionResult(Sender: TObject;
        requestCode: integer; manifestPermission: string;
        grantResult: TManifestPermissionResult);
      procedure AndroidModule1Show(Sender: TObject);
      procedure jTimer1Timer(Sender: TObject);
    private
      {private declarations}
      cnt_Timer: integer;
      cnt_Image: integer;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  cnt_Timer:= 0;
  cnt_Image:= -1;
end;

procedure TAndroidModule1.AndroidModule1CloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  ShowMessage('form 1 can close....');
end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  jTimer1.Enabled:= False;   //Stop Timer

  AndroidModule2.InitShowing;
end;

procedure TAndroidModule1.AndroidModule1Init(Sender: TObject);
begin
 self.SetDensityAssets(daHIGH);
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     2003:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
   end;
end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
  begin
      ShowMessage('RequestRuntimePermission....');
      //hint: if you  get "write" permission then you have "read", too!
      Self.RequestRuntimePermission(['android.permission.WRITE_EXTERNAL_STORAGE'], 2003);  // some/any value...
  end;

  jTimer1.Enabled:= True;
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  jTextView1.Text:= IntToStr(Cnt_Timer) + '%';
  Inc(cnt_Timer, 5);
  Inc(cnt_Image);
  if cnt_Image = jImageView1.Count-1 then cnt_Image:= 0;
  jImageView1.ImageIndex:= cnt_Image;
  if cnt_timer < 200 then Exit;

  jTimer1.Enabled:= False;   //Stop Timer

  self.Close;
end;

end.
