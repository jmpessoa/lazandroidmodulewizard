{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatTabLayoutDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, stablayout, Laz_And_Controls, And_jni,
  sbottomnavigationview, sfloatingbutton;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jListView1: jListView;
    jListView2: jListView;
    jListView3: jListView;
    jPanel1: jPanel;
    jsBottomNavigationView1: jsBottomNavigationView;
    jsTabLayout1: jsTabLayout;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jListView3AfterDispatchDraw(Sender: TObject; canvas: JObject;
      tag: integer);
    procedure jsBottomNavigationView1ClickItem(Sender: TObject;
      itemId: integer; itemCaption: string);
    procedure jsTabLayout1TabSelected(Sender: TObject; position: integer;
      title: string);
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

// NOTE: app theme:    "Theme.AppCompat.Light.DarkActionBar"  in "....res\values\styles.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  navigationMenu: jObjectRef;
begin
  //Self.jsTabLayout1.SetBackgroundToPrimaryColor();
  //Self.jsTabLayout1.SetElevation(20);
  Self.jsTabLayout1.SetSelectedTabIndicatorHeight(3);
  Self.jsTabLayout1.SetSelectedTabIndicatorColor(colbrLime);

  Self.jsTabLayout1.AddTab('List 1');
  Self.jsTabLayout1.AddTab('List 2');
  Self.jsTabLayout1.AddTab('List 3');

  jListView2.Visible:= False;
  jListView3.Visible:= False;

  navigationMenu:= jsBottomNavigationView1.GetMenu();

  jsBottomNavigationView1.AddItem(navigationMenu, 102, 'Left', 'ic_chevron_left_black_48dp');
  jsBottomNavigationView1.AddItem(navigationMenu, 101, 'Right', 'ic_chevron_right_black_48dp');


end;

procedure TAndroidModule1.jListView3AfterDispatchDraw(Sender: TObject;
  canvas: JObject; tag: integer);
begin

end;

procedure TAndroidModule1.jsBottomNavigationView1ClickItem(Sender: TObject;
  itemId: integer; itemCaption: string);
var
  p: integer;
  count: integer;
begin
 // ShowMessage('itemId = ' + IntToStr(itemId));

  p:= jsTabLayout1.GetPosition();
  count:= jsTabLayout1.GetTabCount();

  if itemId =  101 then   //Right
  begin
     p:= p + 1;
     if p < count then jsTabLayout1.SetPosition(p);
  end;

  if itemId =  102 then   //Left
  begin
     p:= p - 1;
     if p >= 0 then  jsTabLayout1.SetPosition(p);
  end;

end;

procedure TAndroidModule1.jsTabLayout1TabSelected(Sender: TObject;
  position: integer; title: string);
begin

   if position = 0 then
   begin
     jListView2.Visible:= False;
     jListView3.Visible:= False;
     jListView1.BringToFront();
   end else if position = 1 then
   begin
      jListView1.Visible:= False;
      jListView3.Visible:= False;
      jListView2.BringToFront();
   end else if position = 2 then
   begin
     jListView1.Visible:= False;  //try reduce flicks ...
     jListView2.Visible:= False;  //try reduce flicks ...
     jListView3.BringToFront();
   end;

end;

end.
