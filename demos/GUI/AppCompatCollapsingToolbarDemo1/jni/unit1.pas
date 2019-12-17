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
    procedure jsRecyclerView1ItemWidgetClick(Sender: TObject;
      itemPosition: integer; widget: TItemContentFormat; caption: string;
      status: TItemWidgetStatus);
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
       LayoutParamHeight = lpOneQuarterOfParent  (or ....)
       LayoutParamWidth = lpMatchParent

b4) ImageView
       LayoutParamHeight = lpWrapContent
       LayoutParamWidth = lpMatchParent
*)

//NOTE: theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if AndroidModule2 = nil then   //NOTE: "ActivityMode = actEasel"  dont show!!
  begin
    gApp.CreateForm(TAndroidModule2, AndroidModule2);
    AndroidModule2.Init(gApp);  //dispatch "OnJNIPrompt" in  AndroidModule2
  end;

  jsCoordinatorLayout1.SetFitsSystemWindows(True);
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

  jsRecyclerView1.SetClipToPadding(False);
  jsRecyclerView1.SetAppBarLayoutScrollingViewBehavior();
  jsRecyclerView1.SetItemContentLayout(AndroidModule2.jPanel1.View,  True {true=cardview});   //custom item view!

  {
  jsRecyclerView1.AddItemContentFormat(cfImage);
  jsRecyclerView1.AddItemContentFormat(cfText);
  jsRecyclerView1.AddItemContentFormat(cfCheck);
  jsRecyclerView1.AddItemContentFormat(cfRating);
  jsRecyclerView1.AddItemContentFormat(cfSwitch);
  jsRecyclerView1.SetItemContentFormat();
   }
   //or
  jsRecyclerView1.SetItemContentFormat('IMAGE|TEXT|CHECK|RATING|SWITCH');
  jsRecyclerView1.Add('lance.png@assets|Do you see over yonder, friend Sancho, thirty or forty hulking giants? I intend to do battle with them and slay them...|OK@1|2.0|OFF:ON@0');
  jsRecyclerView1.Add('windmil.png@assets|Take care... those things over there are not giants but windmills...|OK@0|3.0|Sound@0');
  jsRecyclerView1.Add('don_quixote.png@assets|The poet can recount or sing about things not as they were, but as they should have been...|OK@0|3.0|Sound@1');
  jsRecyclerView1.Add('lance.png@assets|The historian must write about them not as they should have been, but as they were, without adding or subtracting anything from the truth...|OK@0|2.5|OFF:ON@1');
  jsRecyclerView1.Add('don_quixote.png@assets|Bear in mind... one man is no more than another, unless he does more than another...|OK@1|2.5|Sound@1');
  jsRecyclerView1.Add('ic_launcher@drawable|My idea is to become a lunatic for no good reason at all...|OK@0|3.0|Sound@0');

  (* hint:
  windmil.png@assets
  //or
  ic_launcher@drawable
  //or
  url@http://icons.iconarchive.com/icons/alecive/flatwoken/128/Apps-Google-Chrome-App-List-icon.png
  *)

  //jsFloatingButton1.GravityInParent:= lgNone; //need be seted in design time!
  jsFloatingButton1.SetPressedRippleColor(colbrCyan);
  jsFloatingButton1.SetAnchorGravity(lgBottomRight, jsAppBarLayout1.Id);

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
    ShowMessage(jsRecyclerView1.GetSelectedContent(i));
  end;
end;

procedure TAndroidModule1.jsRecyclerView1ItemWidgetClick(Sender: TObject;
  itemPosition: integer; widget: TItemContentFormat; caption: string;
  status: TItemWidgetStatus);
begin
   case widget of
      cfImage: begin ShowMessage('cfImage');  end;
      cfCheck: begin ShowMessage('cfCheck'); end;
      cfRating: begin ShowMessage('cfRating'); end;
      cfSwitch: begin ShowMessage('cfSwitch'); end;
   end;

   ShowMessage(caption + '  index = '+ IntToStr(itemPosition));

   case status of
       wsNone: begin ShowMessage('wsNone');  end;
       wsChecked: begin ShowMessage('wsChecked'); end;
   end;

end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
  ShowMessage('Don Quixote by Miguel de Cervantes')
end;

end.
