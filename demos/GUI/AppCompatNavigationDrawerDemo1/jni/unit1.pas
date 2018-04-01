{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatNavigationDrawerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, sdrawerlayout, stoolbar,
  Laz_And_Controls, snavigationview, unit2, unit3;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jsDrawerLayout1: jsDrawerLayout;
    jsNavigationView1: jsNavigationView;
    jsToolbar1: jsToolbar;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView4: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
    procedure jsNavigationView1ClickItem(Sender: TObject; itemId: integer;
      itemCaption: string);
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

//NOTE: app theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  myMenu: jObjectRef;
begin

  //jsToolbar1.AsActionBar:= True;  //warning: must be seted in  design time!
  jsToolbar1.SetFitsSystemWindows(True);

  jsToolbar1.SetBackgroundToPrimaryColor();   // in "...\res\values\style.xml"
  jsToolbar1.NavigationIconIdentifier:= 'ic_menu_white_36dp';
  jsToolbar1.SetTitleTextColor(colbrWhite);
  jsToolbar1.SetTitle('Navigation Drawer Demo1');
  jsToolbar1.SetSubtitleTextColor(colbrWhite);
  jsToolbar1.SetSubtitle('LAMW 0.8');

  jsNavigationView1.AddHeaderView(colbrGreen, 'ic_cervantes', 'Miguel de Cervantes|LAMW 0.8', 240);

  myMenu:= jsNavigationView1.AddMenu('Don Quixote'); // make a group
  //or myMenu:= jsNavigationView1.GetMenu();  //no group
  jsNavigationView1.AddItem(myMenu, 101, 'Scene 1', 'ic_don_quixote');
  jsNavigationView1.AddItem(myMenu, 102, 'Scene 2', 'ic_lance');
  jsNavigationView1.AddItem(myMenu, 103, 'Scene 3', 'ic_windmil');

  //prepare scenes
  if AndroidModule2 = nil then  //hint: property "ActiveMode = actEasel" dont "show"
  begin
     gApp.CreateForm(TAndroidModule2, AndroidModule2);
     AndroidModule2.Init(gApp);   //fire OnJNIPrompt ...
     AndroidModule2.jPanel1.SetViewParent(Self.jPanel2.View); //add scene 2  to Self.jPanel2
  end;
  if AndroidModule3 = nil then  //hint: property "ActiveMode = actEasel" dont "show"
  begin
    gApp.CreateForm(TAndroidModule3, AndroidModule3);
    AndroidModule3.Init(gApp); //fire OnJNIPrompt ...
    AndroidModule3.jPanel1.SetViewParent(Self.jPanel2.View); //add scene 3 to Self.jPanel2
  end;

  Self.jPanel3.BringToFront();  //retrieve scene 1 into/front Self.jPanel2

end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  ShowMessage('Scene 1');
end;

//Easel: "a self-supporting wooden frame for holding an artist's work while it is being painted or drawn".

procedure TAndroidModule1.jsNavigationView1ClickItem(Sender: TObject; itemId: integer; itemCaption: string);
begin

  if itemId =  101 then
  begin
    Self.jPanel3.BringToFront();
  end;

  if itemId =  102 then
  begin
    AndroidModule2.jPanel1.BringToFront();
  end;

  if itemId =  103 then
  begin
    AndroidModule3.jPanel1.BringToFront();
  end;

  jsDrawerLayout1.CloseDrawers();

end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
  //ShowMessage('Hello!');
  jsDrawerLayout1.OpenDrawer();
end;

end.
