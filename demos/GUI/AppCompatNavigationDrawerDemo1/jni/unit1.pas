{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatNavigationDrawerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, sdrawerlayout, stoolbar,
  Laz_And_Controls, snavigationview, unit2, unit3, unit4;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jEditText1: jEditText;
    jEditText2: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jsDrawerLayout1: jsDrawerLayout;
    jsNavigationView1: jsNavigationView;
    jsToolbar1: jsToolbar;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure AndroidModule1SpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure jImageView1Click(Sender: TObject);
    procedure jsNavigationView1ClickItem(Sender: TObject; itemId: integer;
      itemCaption: string);
    procedure jsToolbar1ClickNavigationIcon(Sender: TObject);

  private
    {private declarations}
    ActiveScene: integer;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }


//Easel: "a self-supporting wooden frame for holding an artist's work while it is being painted or drawn".
//Easel picture:  http://paintingproperly.com/best-easel-reviews/

//NOTE: usng app theme:  "Theme.AppCompat.Light.NoActionBar"  in "...\res\values\style.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  myMenu: jObjectRef;
begin

  //jsToolbar1.AsActionBar:= True;  //warning: must be seted in design time!

  jsToolbar1.SetFitsSystemWindows(True);

  jsToolbar1.SetBackgroundToPrimaryColor();   // in "...\res\values\style.xml"
  jsToolbar1.NavigationIconIdentifier:= 'ic_menu_white_36dp';
  jsToolbar1.SetTitleTextColor(colbrWhite);
  jsToolbar1.SetTitle('Navigation Drawer Demo1');
  jsToolbar1.SetSubtitleTextColor(colbrWhite);
  jsToolbar1.SetSubtitle('LAMW 0.8');

  jsNavigationView1.AddHeaderView('bg_material', 'ic_cervantes', 'Miguel de Cervantes|LAMW 0.8', 240);
  //or
  //jsNavigationView1.AddHeaderView(colbrGreen, 'ic_cervantes', 'Miguel de Cervantes|LAMW 0.8', 240);


  myMenu:= jsNavigationView1.AddMenu('Don Quixote'); // make a group
  //or
  //myMenu:= jsNavigationView1.GetMenu();  //no group

  jsNavigationView1.AddItem(myMenu, 101, 'Scene 1', 'ic_don_quixote');
  jsNavigationView1.AddItem(myMenu, 102, 'Scene 2', 'ic_lance');
  jsNavigationView1.AddItem(myMenu, 103, 'Scene 3', 'ic_windmil');
  jsNavigationView1.AddItem(myMenu, 104, 'Scene 4', 'ic_launcher'); //just a "real" form demo [by Dio Affriza]


  //handle App Startup screen state/style....
  if Self.GetScreenOrientationStyle =  ssLandscape then
  begin
     Self.jEditText1.LayoutParamWidth:= lpOneThirdOfParent;
     Self.jEditText2.LayoutParamWidth:= lpTwoThirdOfParent;

     Self.jEditText1.UpdateLayout;
     Self.jEditText2.UpdateLayout;
  end;

  ActiveScene:= 101;

end;

procedure TAndroidModule1.jsNavigationView1ClickItem(Sender: TObject; itemId: integer; itemCaption: string);
begin

  if itemId =  101 then //local Self.jPanel3
  begin
    ActiveScene:= 101;
    Self.jPanel3.BringToFront();
  end;

  if itemId =  102 then
  begin

    //prepare scene at first launch...
    //put initialize here to not "delay" the application at startup...
    if AndroidModule2 = nil then
    begin
       gApp.CreateForm(TAndroidModule2, AndroidModule2); //hint: property "ActiveMode = actEasel" dont "show"  form
       AndroidModule2.Init;   //fire OnJNIPrompt ...
       AndroidModule2.jPanel1.Parent:= Self.jPanel2;   // <<-------- need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
       AndroidModule2.jPanel1.SetViewParent(Self.jPanel2.View); //add scene 2  to Self.jPanel2
    end;

    ActiveScene:= 102;
    AndroidModule2.jPanel1.BringToFront();
  end;

  if itemId =  103 then
  begin

    //prepare scene at first launch...
    //put initialize here to not "delay" the application at startup...
    if AndroidModule3 = nil then  //hint: property "ActiveMode = actEasel" dont "show" form
    begin
      gApp.CreateForm(TAndroidModule3, AndroidModule3);
      AndroidModule3.Init; //fire OnJNIPrompt ...
      AndroidModule3.jPanel1.Parent:= Self.jPanel2;  // <<-------- need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
      AndroidModule3.jPanel1.SetViewParent(Self.jPanel2.View); //add scene 3 to Self.jPanel2
    end;

    ActiveScene:= 103;
    AndroidModule3.jPanel1.BringToFront();
  end;

  if itemId =  104 then
  begin

    //prepare scene at first launch...
    //put initialize here to not "delay" the application at startup...
    if AndroidModule4 = nil then
    begin
      gApp.CreateForm(TAndroidModule4, AndroidModule4); //property "ActiveMode = actEasel" dont "show" form
      AndroidModule4.Init; //fire OnJNIPrompt ...
      AndroidModule4.jPanel1.Parent:= Self.jPanel2; // <<-------- need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
      AndroidModule4.jPanel1.SetViewParent(Self.jPanel2.View); //add scene 4 to Self.jPanel2
    end;

    ActiveScene:= 104;
    AndroidModule4.jPanel1.BringToFront();
  end;

  jsDrawerLayout1.CloseDrawers();

end;

procedure TAndroidModule1.jsToolbar1ClickNavigationIcon(Sender: TObject);
begin
  jsDrawerLayout1.OpenDrawer();
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin

   if ActiveScene = 101 then //local: Self.jPanel3
   begin
     if rotate =  ssLandscape then   //just as a demonstration....
     begin
       Self.jEditText1.LayoutParamWidth:= lpOneThirdOfParent;
       Self.jEditText2.LayoutParamWidth:= lpTwoThirdOfParent;
     end
     else
     begin
       Self.jEditText1.LayoutParamWidth:= lpHalfOfParent;
       Self.jEditText2.LayoutParamWidth:= lpHalfOfParent;
     end;
     Self.UpdateLayout;
   end;

   if ActiveScene = 102 then  //just as a demonstration....
   begin
      AndroidModule2.AndroidModule2Rotate(Sender, rotate);
   end;

   if ActiveScene = 103 then  //just as a demonstration....
   begin
      AndroidModule3.AndroidModule3Rotate(Sender, rotate);
   end;

   if ActiveScene = 104 then //just as a demonstration....
   begin
      AndroidModule4.AndroidModule4Rotate(Sender, rotate);
   end;
end;

procedure TAndroidModule1.AndroidModule1SpecialKeyDown(Sender: TObject;
  keyChar: char; keyCode: integer; keyCodeString: string; var mute: boolean);
begin
  if keyCode = 4 then  //KEYCODE_BACK
  begin
    if ActiveScene <> 101 then
    begin
      ActiveScene:= 101;
      Self.jPanel3.BringToFront();
      mute:= True; //dont close app
    end;
  end;
end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  ShowMessage('Scene 1');
end;

end.
