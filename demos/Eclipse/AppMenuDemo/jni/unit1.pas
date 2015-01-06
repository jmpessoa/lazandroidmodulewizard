{Hint: save all files to location: C:\adt32\eclipse\workspace\AppMenuDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget,
  menu, contextmenu;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jMenu1: jMenu;
      jContextMenu1: jContextMenu;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure DataModuleClickContextMenuItem(Sender: TObject;
        jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
      procedure DataModuleClickOptionMenuItem(Sender: TObject;
        jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleCreateContextMenu(Sender: TObject; jObjMenu: jObject);
      procedure DataModuleCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);

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

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
   //
end;


//ref1:http://android-developers.blogspot.com.br/2012/01/say-goodbye-to-menu-button.htmt
//ref2: http://developer.android.com/downloads/design/Android_Design_Icons_20131106.zip
{
 If you do not want action bar: set targetSdkVersion to 13 or below ....  !!
 The overflow icon '...' only appears on phones that have no menu hardware keys.
 Phones with menu keys display the action overflow when the user presses the hardware key.

 For the apps that don't have action bar
 but provide menu items, android creates the "three dots" menu
 item on navigation bar and opens menu when clicked.
 However, to make such a menu bar appear, you have to set a minSdkVersion to be 10 or lower.
}

procedure TAndroidModule1.DataModuleCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
var
   i: integer;
   jSubMenu: jObject;
begin
   for i:=0 to jMenu1.Options.Count-1 do
   begin
      if i <> 1 then
      begin
        //0:mitDefault; 1:misIfRoom
        jMenu1.AddItem(jObjMenu, 10+i {itemID}, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] {..res/drawable-xxx}, mitDefault, misIfRoomWithText);
      end
      else  //i=1 --> add sub menu to "Blue..." item...
      begin
        jSubMenu:= jMenu1.AddSubMenu(jObjMenu, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] {header icon!});  //from ..res/drawable-xxx

        //Sub menus Items: Do not support item icons, or nested sub menus.
        jMenu1.AddItem(jSubMenu, 100 {itemID}, 'LightSlateBlue', mitCheckable);
        jMenu1.AddItem(jSubMenu, 101 {itemID}, 'DarkBlue', mitCheckable);
        jMenu1.AddItem(jSubMenu, 102 {itemID}, 'LightSkyBlue', mitCheckable);
      end;
   end;

   //Add sub menu after last item
   jSubMenu:= jMenu1.AddSubMenu(jObjMenu, 'More...', 'ic_bullets' {header icon!});  //from ..res/drawable-xxx

   //Sub menus Items: Do not support item icons, or nested sub menus.
   jMenu1.AddItem(jSubMenu, 1000 {itemID}, 'Yellow', mitCheckable);
   jMenu1.AddItem(jSubMenu, 1001 {itemID}, 'Red', mitCheckable);
   jMenu1.AddItem(jSubMenu, 1002 {itemID}, 'Green', mitCheckable);

end;

procedure TAndroidModule1.DataModuleClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
var
  i: integer;
begin
  if itemID <> 0 then  // itemID = 0 --> subMenu entry point
  begin
    //just for test!
    if not checked then
    begin

      jMenu1.UnCheckAllMenuItem(); //UnCheck menu items
      for i:= 0  to jMenu1.CountSubMenus()-1 do
      begin
         jMenu1.UnCheckAllSubMenuItemByIndex(i);  //UnCheck All SubMenus items...
      end;

      jMenu1.CheckItem(jObjMenuItem);
      case itemID of

          10: jTextView2.FontColor:= colbrOrange;
          //11: --> sub menu!
          12: jTextView2.FontColor:= colbrPurple;

          //sub menu "Blue..."
          100: jTextView2.FontColor:= colbrLightSlateBlue;
          101: jTextView2.FontColor:= colbrDarkBlue;
          102: jTextView2.FontColor:= colbrLightSkyBlue;

          //sub menu "More.."
          1000: jTextView2.FontColor:= colbrYellow;
          1001: jTextView2.FontColor:= colbrRed;
          1002: jTextView2.FontColor:= colbrGreen;
      end;
    end
    else
    begin
      jMenu1.UnCheckItem(jObjMenuItem);
      jTextView2.FontColor:= colbrSilver; //colbrDefault was gone!
    end;
  end;
end;

//warning: Context Menu Items does not support the Icon and neither Sub Menu!
procedure TAndroidModule1.DataModuleCreateContextMenu(Sender: TObject; jObjMenu: jObject);
var
  i: integer;
  jItem: jObject;
begin
  if jObjMenu <> nil then
  begin
    jContextMenu1.SetHeader(jObjMenu, 'Context Menu!', 'ic_bullets');
    for i:=0 to jContextMenu1.Options.Count-1 do
    begin                                        //0:mitDefault, 1:mitCheckable
       jItem:= jContextMenu1.AddItem(jObjMenu, 10+i {itemID}, jContextMenu1.Options.Strings[i], mitCheckable);

       if jContextMenu1.IsItemChecked(10+i) then //Checkable persistence need for Context Menu
       begin
          jContextMenu1.CheckItem(jItem);
       end;

    end;
  end;
end;

procedure TAndroidModule1.DataModuleClickContextMenuItem(Sender: TObject;
   jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
  if not checked then
  begin
    jContextMenu1.UnCheckAllMenuItem();
    jContextMenu1.CheckItem(jObjMenuItem);
    case itemID of
      10: jButton1.FontColor:= colbrGreen;
      11: jButton1.FontColor:= colbrRed;
      12: jButton1.FontColor:= colbrYellow;
    end;
  end
  else
  begin
    jContextMenu1.UnCheckItem(jObjMenuItem);
    jButton1.FontColor:= colbrBlack; //the colbrDefault was gone!
  end;
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  jContextMenu1.RegisterForContextMenu(jButton1.jSelf);  // <------- register jButton1 for Context Menu!
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage('Button clicked!');
  Self.SetSubTitleActionBar('Hello!');
end;

end.
