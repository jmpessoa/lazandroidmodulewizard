{Hint: save all files to location: \jni }
unit unit7;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule7 }

  TAndroidModule7 = class(jForm)
      jImageBtn1: jImageBtn;
      jImageList1: jImageList;
      jImageList2: jImageList;
      jImageView1: jImageView;
      jImageView2: jImageView;
      jImageView3: jImageView;
      jImageView4: jImageView;
      jImageView5: jImageView;
      jScrollView1: jScrollView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jImageBtn1Click(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule7: TAndroidModule7;

implementation
  
{$R *.lfm}

{ TAndroidModule7 }

procedure TAndroidModule7.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule7.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule7.DataModuleJNIPrompt(Sender: TObject);
begin
  jImageView1.Parent:= jScrollView1.View;
  jImageView2.Parent:= jScrollView1.View;
  jImageView3.Parent:= jScrollView1.View;
  jImageView4.Parent:= jScrollView1.View;
  jImageView5.Parent:= jScrollView1.View;
  Self.Show;
end;

procedure TAndroidModule7.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule7.jImageBtn1Click(Sender: TObject);
begin
   showMessage('ImageBtn : OnClick');
end;

end.
