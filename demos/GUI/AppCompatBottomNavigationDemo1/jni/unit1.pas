{hint: Pascal files location: ...\AppCompatBottomNavigationDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, sbottomnavigationview, Laz_And_Controls, Unit2, Unit3,
  And_jni, menu;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jMenu1: jMenu;
    jPanel1: jPanel;  //base panel  [container]
    jPanel2: jPanel;  //"home" content
    jsBottomNavigationView1: jsBottomNavigationView;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      checked: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1Show(Sender: TObject);
    procedure jsBottomNavigationView1ClickItem(Sender: TObject;
      itemId: integer; itemCaption: string);
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

//App theme: "Theme.AppCompat.Light.DarkActionBar"  in file "...res/value/style.xml"
procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
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
    showmessage(intTostr(i));
    jMenu1.AddItem(jObjMenu, 10+i {itemID}, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] ,  mitDefault, misAlways);
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  navigationMenu: jObjectRef;
begin
  jPanel1.LayoutParamHeight:= lpMatchParent;

  Self.SetTitleActionBar('Home');

  navigationMenu:= jsBottomNavigationView1.GetMenu();
  jsBottomNavigationView1.AddItem(navigationMenu, 101, 'Home', 'ic_home_36');
  jsBottomNavigationView1.AddItem(navigationMenu, 102, 'Dashboard', 'ic_dashboard_36');
  jsBottomNavigationView1.AddItem(navigationMenu, 103, 'Notifications', 'ic_notifications_36');

end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  jMenu1.InvalidateOptionsMenu();
end;

procedure TAndroidModule1.jsBottomNavigationView1ClickItem(Sender: TObject; itemId: integer; itemCaption: string);
begin

    if itemId = 101 then     //'Home'
    begin
      Self.SetTitleActionBar('Home');
      Self.jPanel2.BringToFront();   //scene 1

    end
    else if itemId = 102 then     //'Dashboard'
    begin
       if not AndroidModule2.Initialized then     //AndroidModule2 "ActiveMode = actEasel" dont "show" !
       begin
         AndroidModule2.Init;
         AndroidModule2.jPanel1.Parent:= Self.jPanel1;   // <--need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
         AndroidModule2.jPanel1.SetViewParent(Self.jPanel1.View); //add scene1  to [container] Self.jPanel1
       end;

       Self.SetTitleActionBar('Dashboard');
       AndroidModule2.jPanel1.BringToFront();  //scene 2

    end else if itemId = 103 then     //'Notifications'
    begin
       if not AndroidModule3.Initialized then     //AndroidModule3 "ActiveMode = actEasel" dont "show" !
       begin
         AndroidModule3.Init;
         AndroidModule3.jPanel1.Parent:= Self.jPanel1;   // <--need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
         AndroidModule3.jPanel1.SetViewParent(Self.jPanel1.View); //add scene1  to [container] Self.jPanel1
       end;

        Self.SetTitleActionBar('Notifications');
        AndroidModule3.jPanel1.BringToFront();    //scene 3
    end;
end;

end.
