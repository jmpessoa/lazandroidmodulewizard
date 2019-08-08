{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatTabLayoutDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, scoordinatorlayout, sappbarlayout, stoolbar,
  stablayout, sviewpager, Laz_And_Controls, sfloatingbutton, unit2, unit3;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jsAppBarLayout1: jsAppBarLayout;
    jsCoordinatorLayout1: jsCoordinatorLayout;
    jsFloatingButton1: jsFloatingButton;
    jsTabLayout1: jsTabLayout;
    jsToolbar1: jsToolbar;
    jsViewPager1: jsViewPager;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jsFloatingButton1Click(Sender: TObject);
    procedure jsTabLayout1TabSelected(Sender: TObject; position: integer;
      title: string);
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

//NOTE: theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if AndroidModule2 = nil then
   begin
       gApp.CreateForm(TAndroidModule2, AndroidModule2);
       AndroidModule2.Init(gApp);
       AndroidModule2.Show;        //NOTE: form "ActiveMode = actEasel" dont show!
   end;
   if AndroidModule3 = nil then
   begin
      gApp.CreateForm(TAndroidModule3, AndroidModule3);
      AndroidModule3.Init(gApp);
      AndroidModule3.Show;         //NOTE: form "ActiveMode = actEasel" dont show!
   end;

  jsCoordinatorLayout1.SetFitsSystemWindows(True);
  jsAppBarLayout1.SetFitsSystemWindows(True);

  //jsToolbar1.AsActionBar:= True;             //need be seted in design time!
  jsToolbar1.SetFitsSystemWindows(True);
  jsToolbar1.SetScrollFlag(csfEnterAlways);

  jsViewPager1.SetClipToPadding(False);
  jsViewPager1.AddPage(AndroidModule2.jsRecyclerView1.View, 'Client');
  jsViewPager1.AddPage(AndroidModule3.jsRecyclerView1.View, 'Company');

  jsViewPager1.SetAppBarLayoutScrollingViewBehavior();

  jsTabLayout1.SetTabGravity(tgFill);
  jsTabLayout1.SetSelectedTabIndicatorColor(colbrLime);
  jsTabLayout1.SetSelectedTabIndicatorHeight(3);
  jsTabLayout1.SetupWithViewPager(jsViewPager1.View);

  jsFloatingButton1.SetPressedRippleColor(colbrCyan);
  jsFloatingButton1.SetAnchorGravity({lgBottomRight} lgBottomCenter, jsAppBarLayout1.Id);

end;

procedure TAndroidModule1.jsFloatingButton1Click(Sender: TObject);
begin
  ShowMessage('LAMW 0.8');
end;

procedure TAndroidModule1.jsTabLayout1TabSelected(Sender: TObject;
  position: integer; title: string);
begin
  if  position = 0 then  jsViewPager1.SetPosition(0);
  if  position = 1 then  jsViewPager1.SetPosition(1);
end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
   ShowMessage('LAMW 0.8');
end;

end.
