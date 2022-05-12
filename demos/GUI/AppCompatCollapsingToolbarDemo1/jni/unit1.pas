{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatCollapsingToolbarDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, scoordinatorlayout, sappbarlayout,
  scollapsingtoolbarlayout, stoolbar, Laz_And_Controls, srecyclerview,
  sfloatingbutton, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jImageView1: jImageView;
    jsAppBarLayout1: jsAppBarLayout;
    jsCollapsingToolbarLayout1: jsCollapsingToolbarLayout;
    jsCoordinatorLayout1: jsCoordinatorLayout;
    jsFloatingButton1: jsFloatingButton;
    jsRecyclerView1: jsRecyclerView;
    jsToolbar1: jsToolbar;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jsFloatingButton1Click(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer;
      itemArrayOfStringCount: integer);
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
       LayoutParamHeight = lpOneQuarterOfParent  (or ....)     // I apply this to fix the demo bug! [thanks to @Segator!]
       LayoutParamWidth = lpMatchParent

b4) ImageView
       LayoutParamHeight = lpWrapContent
       LayoutParamWidth = lpMatchParent
*)

//NOTE: theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if AndroidModule2 = nil then   //NOTE: "ActivityMode = actEasel" --> dont show!!
  begin
    gApp.CreateForm(TAndroidModule2, AndroidModule2);
    AndroidModule2.Init;  //dispatch "OnJNIPrompt" in  AndroidModule2
  end;

  //jsCoordinatorLayout1.SetFitsSystemWindows(True);   //**   need this???
  jsAppBarLayout1.SetFitsSystemWindows(True);

  jsCollapsingToolbarLayout1.SetFitsSystemWindows(True);
  jsCollapsingToolbarLayout1.SetScrollFlag(csfExitUntilCollapsed);
  jsCollapsingToolbarLayout1.SetExpandedTitleColor(colbrWhite);
  jsCollapsingToolbarLayout1.SetCollapsedTitleTextColor(colbrWhite);

  jsCollapsingToolbarLayout1.SetContentScrimColor(jsToolbar1.GetPrimaryColor());  //default primary colors in "res\values\style.xml"

  //jsToolbar1.AsActionBar:= True;             //need be seted in design time!
  //jsToolbar1.BackgroundColor:= colbrDefault; //need be seted in design time!

  //jsToolbar1.SetHeightByDisplayMetricsDensity(60);//** need be seted to an absolute value!  //need this ??
  jsToolbar1.SetCollapseMode(cmPin);

  jImageView1.SetFitsSystemWindows(True);
  jImageView1.SetCollapseMode(cmParallax);

  jsRecyclerView1.SetClipToPadding(False);
  jsRecyclerView1.SetAppBarLayoutScrollingViewBehavior();
  jsRecyclerView1.SetItemContentLayout(AndroidModule2.jPanel1.View,  True {cardview});   //custom item view!
  jsRecyclerView1.SetItemContentFormat('IMAGE|TEXT');

  jsRecyclerView1.Add('lance.png@assets|Do you see over yonder, friend Sancho, thirty or forty hulking giants? I intend to do battle with them and slay them...');
  jsRecyclerView1.Add('windmil.png@assets|Take care... those things over there are not giants but windmills...');
  jsRecyclerView1.Add('don_quixote.png@assets|The poet can recount or sing about things not as they were, but as they should have been...');
  jsRecyclerView1.Add('lance.png@assets|The historian must write about them not as they should have been, but as they were, without adding or subtracting anything from the truth...');
  jsRecyclerView1.Add('windmil.png@assets|Until death it is all life...');
  jsRecyclerView1.Add('don_quixote.png@assets|The proof of the pudding is in the eating...');
  jsRecyclerView1.Add('lance.png@assets|The maddest thing a man can do in this life is to let himself die...');
  jsRecyclerView1.Add('windmil.png@assets|Wit and humor do not reside in slow minds...');
  jsRecyclerView1.Add('don_quixote.png@assets|The wounds received in battle bestow honor, they do not take it away...');
  jsRecyclerView1.Add('lance.png@assets|The most perceptive character in a play is the fool, because the man who wishes to seem simple cannot possibly be a simpleton...');
  jsRecyclerView1.Add('windmil.png@assets|After the gratifications of brutish appetites are past, the greatest pleasure then is to get rid of that which entertained it...');
  jsRecyclerView1.Add('don_quixote.png@assets|Bear in mind... one man is no more than another, unless he does more than another...');
  jsRecyclerView1.Add('lance.png@assets|Love and War are the same thing, and stratagems and policy are as allowable in the one as in the other...');
  jsRecyclerView1.Add('windmil.png@assets|My idea is to become a lunatic for no good reason at all...');

  jsRecyclerView1.GravityInParent:= lgTop;

  //jsFloatingButton1.GravityInParent:= lgNone; //need be seted in design time!
  jsFloatingButton1.ImageIdentifier:= 'ic_lemur';
  jsFloatingButton1.SetPressedRippleColor(colbrCyan);
  jsFloatingButton1.SetAnchorGravity(lgBottomRight, jsAppBarLayout1.Id);

  ShowMessage('Prompt....');
end;

procedure TAndroidModule1.jsFloatingButton1Click(Sender: TObject);
begin
  ShowMessage('LAMW 0.8');
end;

procedure TAndroidModule1.jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer; itemArrayOfStringCount: integer);
var
  i: integer;
begin
  ShowMessage('itemIndex = ' + IntToStr(itemPosition) );
  for i:= 0 to itemArrayOfStringCount-1 do
  begin
    //ShowMessage(jsRecyclerView1.GetSelectedContent(i));
  end;
end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
  ShowMessage('Don Quixote by Miguel de Cervantes')
end;

end.
