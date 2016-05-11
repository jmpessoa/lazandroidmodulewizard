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
      jButton2: jButton;
      jListView1: jListView;
      jMenu1: jMenu;
      jContextMenu1: jContextMenu;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;

      procedure AndroidModule1SpecialKeyDown(Sender: TObject; keyChar: char;
        keyCode: integer; keyCodeString: string; var mute: boolean);
      procedure DataModuleClickContextMenuItem(Sender: TObject;
        jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
      procedure DataModuleClickOptionMenuItem(Sender: TObject;
        jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);

      procedure DataModuleCreateContextMenu(Sender: TObject; jObjMenu: jObject);
      procedure DataModuleCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);

      procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jListView1DrawItemTextColor(Sender: TObject;
        itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
      procedure jListView1LongClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);

    private
      {private declarations}
       FSavedListViewItemCaption: string;
    public
      {public declarations}
      Procedure CallBackNotify_Form2Closed(Sender: TObject);
      //Procedure CallBackData(Sender: TObject; strData: string; intData: integer; doubleData: double);
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

uses

  Unit2;

{ TAndroidModule1 }

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

Procedure TAndroidModule1.CallBackNotify_Form2Closed(Sender: TObject); //form2 was closed ...
begin
  //ShowMessage('from CallBack ... ');
  jMenu1.Clear();
  jMenu1.InvalidateOptionsMenu();  //fire OnCreateOptionsMenu [--> OnPrepareOptionsMenu] to rebuild original menu!!!
end;

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

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  //jContextMenu1.RegisterForContextMenu(jButton1.View); //<--register jButton1 for Context Menu [long pressed]
  jContextMenu1.RegisterForContextMenu(jListView1.View);
  Self.SetSubTitleActionBar('jForm [1]');
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
    begin                                                                                      //0:mitDefault, 1:mitCheckable
       jItem:= jContextMenu1.AddItem(jObjMenu, 10+i {itemID}, jContextMenu1.Options.Strings[i], mitCheckable);

       if jContextMenu1.IsItemChecked(10+i) then //Checkable persistence need for Context Menu
       begin
          jContextMenu1.CheckItem(jItem);
       end;
    end;

    if  jListView1.GetItemIndex() > -1 then
    begin
       jContextMenu1.AddItem(jObjMenu, 100{itemID},jListView1.GetItemCaption(), mitDefault);
    end;

    (* OR ...
    if  FSavedListViewItemCaption <> '' then
    begin
        jContextMenu1.AddItem(jObjMenu, 100{itemID},FSavedListViewItemCaption , mitDefault);
    end;
    *)

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
      100: begin
             case jListView1.GetItemIndex() of
                0: jButton1.FontColor:= colbrDarkKhaki;
                1: jButton1.FontColor:= colbrThistle;
                2: jButton1.FontColor:= colbrPeru;
                3: jButton1.FontColor:= colbrSienna;
             end;
           end;
    end;
  end
  else
  begin
    jContextMenu1.UnCheckItem(jObjMenuItem);
    jButton1.FontColor:= colbrBlack; //the colbrDefault was gone!
  end;
end;

procedure TAndroidModule1.AndroidModule1SpecialKeyDown(Sender: TObject;
  keyChar: char; keyCode: integer; keyCodeString: string; var mute: boolean);
begin
  ShowMessage(keyCodeString);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage('Hello !');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jMenu1.Clear(); //clean up ....
  if(AndroidModule2 = nil) then
  begin
      gApp.CreateForm(TAndroidModule2, AndroidModule2);
      AndroidModule2.SetCloseCallBack(CallBackNotify_Form2Closed, Self);
      //AndroidModule2.SetCloseCallBack(CallBackData, Self);
      AndroidModule2.Init(gApp);
  end
  else
  begin
    AndroidModule2.Show;
  end;
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
   ShowMessage('itemIndex = '+ IntToStr(itemIndex) + '     itemCaption = '+ itemCaption);
end;

procedure TAndroidModule1.jListView1DrawItemTextColor(Sender: TObject;
  itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
begin
  case itemIndex of
    0: textColor:= colbrDarkKhaki;
    1: textColor:= colbrThistle;
    2: textColor:= colbrPeru;
    3: textColor:= colbrSienna;
  end;
end;

procedure TAndroidModule1.jListView1LongClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
   FSavedListViewItemCaption:= itemCaption; //here !
end;

end.
