unit unit1;
//

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, scoordinatorlayout, sappbarlayout,
  scollapsingtoolbarlayout, stoolbar, Laz_And_Controls, srecyclerview,
  sfloatingbutton, snestedscrollview, texttospeech, sdrawerlayout,
  snavigationview, framelayout, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jFrameLayout1: jFrameLayout;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jsAppBarLayout1: jsAppBarLayout;
    jsCollapsingToolbarLayout1: jsCollapsingToolbarLayout;
    jsCoordinatorLayout1: jsCoordinatorLayout;
    jsDrawerLayout1: jsDrawerLayout;
    jsFloatingButton1: jsFloatingButton;
    jsNavigationView1: jsNavigationView;
    jsNestedScrollView1: jsNestedScrollView;
    jsToolbar1: jsToolbar;
    jTextToSpeech1: jTextToSpeech;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jsFloatingButton1Click(Sender: TObject);
    procedure jsNavigationView1ClickItem(Sender: TObject; itemId: integer;
      itemCaption: string);
    procedure jsToolbar1ClickNavigationIcon(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    ActiveScene: integer;
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

(*

We have two possible way to define the scrolling layout Height:

Option A: (by setting a Height value for the AppBarLayout )

a1) AppBarLayout
        LayoutParamHeight = lpOneThirdOfParent  (or other well-defined value)
        LayoutParamWidth = lpMatchParent

a2) CollapsingToolbarLayout
        LayoutParamHeight = lpMatchParent
        LayoutParamWidth = lpMatchParent

 a3) Toolbar
        LayoutParamHeight = lpOneQuarterOfParent  (or other well-defined value)
        LayoutParamWidth = lpMatchParent

a4) jImageView
        ImageScaleType = scaleFitXY   (test others values!!)
        LayoutParamHeight = lpMatchParent
        LayoutParamWidth = lpMatchParent

or

Option B:  (by setting Height = WrapContent for the ImageView )

b1) AppBarLayout
      LayoutParamHeight = lpWrapContent
      LayoutParamWidth = lpMatchParent

b2) CollapsingToolbarLayout
      LayoutParamHeight =lpWrapContent
      LayoutParamWidth = lpMatchParent

 b3) Toolbar
       LayoutParamHeight = lpOneQuarterOfParent  (or ....)
       LayoutParamWidth = lpMatchParent

b4) ImageView
       LayoutParamHeight = lpWrapContent
       LayoutParamWidth = lpMatchParent
*)

//NOTE: theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  myMenu: jObjectRef;
begin

  jsAppBarLayout1.SetFitsSystemWindows(True);

  jsCollapsingToolbarLayout1.SetFitsSystemWindows(True);
  jsCollapsingToolbarLayout1.SetScrollFlag(csfExitUntilCollapsed);
  jsCollapsingToolbarLayout1.SetExpandedTitleColor(colbrWhite);
  jsCollapsingToolbarLayout1.SetCollapsedTitleTextColor(colbrWhite);

  jsCollapsingToolbarLayout1.SetContentScrimColor(jsToolbar1.GetPrimaryColor());  //default primary colors in "res\values\style.xml"

  //jsToolbar1.AsActionBar:= True;             //need be seted in design time!
  //jsToolbar1.BackgroundColor:= colbrDefault; //need be seted in design time!
  //jsToolbar1.SetHeightByDisplayMetricsDensity(54);//optional absolut value....
  jsToolbar1.SetCollapseMode(cmPin);

  jImageView1.SetFitsSystemWindows(True);
  jImageView1.SetCollapseMode(cmParallax);

  jTextView1.Text:= Self.LoadFromAssetsTextContent('london.txt');
  jsNestedScrollView1.SetAppBarLayoutScrollingViewBehavior();


  //jsFloatingButton1.GravityInParent:= lgNone; //need be seted in design time!
  jsFloatingButton1.SetPressedRippleColor(colbrCyan);
  jsFloatingButton1.SetAnchorGravity(lgBottomRight, jsAppBarLayout1.Id);

  jsNavigationView1.SetTitleTextSize(20);
  jsNavigationView1.SetTitleSizeDecorated(sdDecreasing);  //default = none
  jsNavigationView1.SetTitleSizeDecoratedGap(4); //default = 3
  jsNavigationView1.SetLogoPosition(rpCenterInParent); //default =   //rpCenterHorizontal

  jsNavigationView1.AddHeaderView('bg_material', 'ic_earphones_128', 'by LAMW', 240);
  //or
  //jsNavigationView1.AddHeaderView(colbrGreen, 'ic_cervantes', 'Miguel de Cervantes|LAMW 0.8', 240);


  myMenu:= jsNavigationView1.AddMenu('Lessons'); // make a group
  //or
  //myMenu:= jsNavigationView1.GetMenu();  //no group

  jsNavigationView1.AddItem(myMenu, 101, 'Scene 1', 'ic_don_quixote');
  jsNavigationView1.AddItem(myMenu, 102, 'Scene 2', 'ic_lance');

end;

procedure TAndroidModule1.jsFloatingButton1Click(Sender: TObject);
begin
  case ActiveScene of
     101: jTextToSpeech1.SpeakOn(jTextView1.Text);
     102: jTextToSpeech1.SpeakOn(AndroidModule2.jTextView1.Text);
  end;
end;

procedure TAndroidModule1.jsNavigationView1ClickItem(Sender: TObject;
  itemId: integer; itemCaption: string);
begin
  if itemId =  101 then //local Self.jPanel1
  begin

    if AndroidModule2 <> nil then
        AndroidModule2.jPanel1.Visible:= False;  //hidden

    ActiveScene:= 101;
    Self.jPanel1.BringToFront();
  end;

  if itemId =  102 then
  begin
    //prepare scene at first launch...
    //put initialize here to not "delay" the application at startup...
    if AndroidModule2 = nil then
    begin
       gApp.CreateForm(TAndroidModule2, AndroidModule2); //hint: property "ActiveMode = actEasel" dont "show"  form
       AndroidModule2.Init(gApp);   //fire OnJNIPrompt event on AndroidModule2...
       AndroidModule2.jPanel1.Parent:= Self.jFrameLayout1;   // <<-------- need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
       AndroidModule2.jPanel1.SetViewParent(Self.jFrameLayout1.View); //add scene 2  to Self.jFrameLayout1
       AndroidModule2.jTextView1.Text:= Self.LoadFromAssetsTextContent('london.txt');
       AndroidModule2.jPanel1.Visible:= False;
    end;
    ActiveScene:= 102;
    Self.jPanel1.Visible:= False;
    AndroidModule2.jPanel1.Visible:= True;
    AndroidModule2.jPanel1.BringToFront();
  end;

  jsDrawerLayout1.CloseDrawers();
end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
  //ShowMessage('Don Quixote by Miguel de Cervantes')
  jsDrawerLayout1.OpenDrawer();
end;

end.
