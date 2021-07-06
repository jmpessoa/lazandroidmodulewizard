{hint: Pascal files location: ...\AppCompatBasicDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, scoordinatorlayout, sappbarlayout, stoolbar,
  sfloatingbutton, And_jni, Laz_And_Controls, menu, Unit2, Unit3;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jMenu1: jMenu;
    jPanel1: jPanel; //base panel
    jPanel2: jPanel; //scene 1
    jsAppBarLayout1: jsAppBarLayout;
    jsCoordinatorLayout1: jsCoordinatorLayout;
    jsFloatingButton1: jsFloatingButton;
    jsToolbar1: jsToolbar;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      checked: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jsFloatingButton1Click(Sender: TObject);
    procedure jsToolbar1ClickNavigationIcon(Sender: TObject);
  private
    {private declarations}
    FScene: integer;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
begin
  if AndroidModule2 = nil then
     gApp.CreateForm(TAndroidModule2, AndroidModule2);

  if AndroidModule3 = nil then
     gApp.CreateForm(TAndroidModule3, AndroidModule3);
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
   ShowMessage(itemCaption);
end;

procedure TAndroidModule1.AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
var
   i: integer;
begin
  for i:=0 to jMenu1.Options.Count-1 do
  begin
    jMenu1.AddItem(jObjMenu, 10+i {itemID}, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] , mitDefault, misNever {misAlways});
  end;
end;

// Easel: a self-supporting wooden frame for holding an artist's work while it is being painted or drawn
// https://www.dreamstime.com/easel-canvas-painted-children-handprints-art-therapy-easel-canvas-painted-children-handprints-art-therapy-image179760269
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  Self.jPanel1.LayoutParamHeight:= lpMatchParent; //later set here, so will preserve others components visible in design time....

  //jsToolbar1.AsActionBar:= True;  need be seted in design time !!! --> Object Inspector
  jsToolbar1.SetFitsSystemWindows(True);
  jsToolbar1.SetBackgroundToPrimaryColor();
  jsToolbar1.SetSubtitle('LAMW!');
  //jsToolbar1.SetSubtitleTextColor(colbrWhite);

  //jsToolbar1.SetDisplayHomeAsUpEnabled(False); //default
  jsToolbar1.NavigationIconIdentifier:='menu_black';

  jsFloatingButton1.SetPressedRippleColor(colbrCyan);

  FScene:=1;

end;

procedure TAndroidModule1.jsFloatingButton1Click(Sender: TObject);
begin
    if jsFloatingButton1.ImageIdentifier = 'navigate_next' then
    begin

      if FScene = 1 then
      begin
         //jsFloatingButton1.ShowSnackbar('Scene1');

         if not AndroidModule2.Initialized then     //AndroidModule2 "ActiveMode = actEasel" dont "show" !
         begin
           AndroidModule2.Init(gApp);
           AndroidModule2.jPanel1.Parent:= Self.jPanel1;   // <--need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
           AndroidModule2.jPanel1.SetViewParent(Self.jPanel1.View); //add scene1  to [container] Self.jPanel1
         end;

         FScene:= 2;
         AndroidModule2.jPanel1.BringToFront();

         jsFloatingButton1.ImageIdentifier:= 'navigate_next';  // res/drawable
         jsToolbar1.SetDisplayHomeAsUpEnabled(True);
      end
      else if FScene = 2  then
      begin
         //jsFloatingButton1.ShowSnackbar('Scene2');

         if not AndroidModule3.Initialized then     //AndroidModule3 "ActiveMode = actEasel" dont "show" !
         begin
          AndroidModule3.Init(gApp);
          AndroidModule3.jPanel1.Parent:= Self.jPanel1;   // <--need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
          AndroidModule3.jPanel1.SetViewParent(Self.jPanel1.View); //add scene3  to [container] Self.jPanel1
         end;

         FScene:= 3;
         AndroidModule3.jPanel1.BringToFront();

         jsFloatingButton1.ImageIdentifier:= 'navigate_previous';  // res/drawable
         jsToolbar1.SetDisplayHomeAsUpEnabled(True);
    end
    end else if jsFloatingButton1.ImageIdentifier = 'navigate_previous' then
    begin
      if FScene = 3 then
      begin
         FScene:= 2;
         AndroidModule2.jPanel1.BringToFront();
         jsFloatingButton1.ImageIdentifier:= 'navigate_next';  // res/drawable
         jsToolbar1.SetDisplayHomeAsUpEnabled(True);
      end
      else if FScene = 2  then
      begin
         FScene:= 1;
         Self.jPanel2.BringToFront();
         jsFloatingButton1.ImageIdentifier:= 'navigate_next';  // res/drawable
         jsToolbar1.SetDisplayHomeAsUpEnabled(False);
         jsToolbar1.NavigationIconIdentifier:='menu_black';
      end
    end;
end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
    if FScene = 3 then
    begin
       FScene:= 2;
       AndroidModule2.jPanel1.BringToFront();
       jsFloatingButton1.ImageIdentifier:= 'navigate_next';  // res/drawable
       jsToolbar1.SetDisplayHomeAsUpEnabled(True);
    end
    else if FScene = 2  then
    begin
       FScene:= 1;
       Self.jPanel2.BringToFront();  //scene 1
       jsFloatingButton1.ImageIdentifier:= 'navigate_next';  // res/drawable
       jsToolbar1.SetDisplayHomeAsUpEnabled(False);
       jsToolbar1.NavigationIconIdentifier:='menu_black';
    end
    else
    begin
      ShowMessage('hamburger menu...');
    end
end;

end.
