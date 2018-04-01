{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatFloatingButtonDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, stoolbar, scoordinatorlayout,
  sfloatingbutton, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jsCoordinatorLayout1: jsCoordinatorLayout;
    jsFloatingButton1: jsFloatingButton;
    jsToolbar1: jsToolbar;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jsFloatingButton1Click(Sender: TObject);
    procedure jsToolbar1ClickNavigationIcon(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
  ShowMessage('NavigationIcon Clicked!!');
end;

//NOTE: theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //jsToolbar1.AsActionBar:= True;  need be seted in design time !!! --> Object Inspector
  jsToolbar1.SetFitsSystemWindows(True);
  jsToolbar1.SetBackgroundToPrimaryColor();

  jsToolbar1.SetSubtitle('LAMW 0.8');
  jsToolbar1.SetSubtitleTextColor(colbrWhite);

  jsFloatingButton1.ImageIdentifier:= 'ic_add_white_36dp';  //  res/drawable ...
  jsFloatingButton1.SetPressedRippleColor(colbrCyan);
end;

procedure TAndroidModule1.jsFloatingButton1Click(Sender: TObject);
begin
  //ShowMessage('Floating Button Clicked!');
  jsFloatingButton1.ShowSnackbar('Hello FAB!');
end;

end.
