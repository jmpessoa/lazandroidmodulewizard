{Hint: save all files to location: C:\adt32\eclipse\workspace\AppMenuDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, menu;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jMenu1: jMenu;
      jMenu2: jMenu;
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
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
end;

procedure TAndroidModule1.DataModuleCreateContextMenu(Sender: TObject; jObjMenu: jObject);
var
  i: integer;
begin
  for i:=0 to jMenu1.Options.Count-1 do
  begin
     //warning: Context Menu does not support the Icon and neither Sub Menu!
     jMenu1.Add(jObjMenu, 10+i {itemID}, jMenu1.Options.Strings[i]);   //ok
     //jMenu1.AddCheckable(jObjMenu, 10+i{itemID}, jMenu1.Options.Strings[i]); //ok
  end;
end;

procedure TAndroidModule1.DataModuleCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
var
    i: integer;
    strArray: array of String;
begin
    for i:=0 to jMenu2.Options.Count-1 do
    begin
        //jMenu2.Add(jObjMenu, 10+i {id}, jMenu2.Options.Strings[i]); //ok
        //jMenu2.AddDrawable(jObjMenu, 10+i {{itemID}}, jMenu2.Options.Strings[i]);
        jMenu2.AddCheckable(jObjMenu, 10+i {itemID}, jMenu2.Options.Strings[i]);  // ok
    end;

    //prepare subMenu....
    SetLength(strArray,4);
    strArray[0]:= 'More...';   //sub menu title -->> id=0 !
    strArray[1]:= 'Indigo';    //id 100
    strArray[2]:= 'Magenta';   //id 100
    strArray[3]:= 'Lime';      //id 101

    jMenu2.AddCheckableSubMenu(jObjMenu, 100 {start id}, strArray);

    SetLength(strArray,0);
end;

procedure TAndroidModule1.DataModuleClickContextMenuItem(Sender: TObject;
   jObjMenuItem: jObject; itemID: integer; itemCaption: string;
   checked: boolean);
begin
  //ShowMessage('Context Menu: Index = '+intToStr(itemID)+ ' :: ' + itemCaption);
   if itemID = 10 then jButton1.FontColor:= colbrGreen;
   if itemID = 11 then jButton1.FontColor:= colbrBlue;
   if itemID = 12 then jButton1.FontColor:= colbrYellow;
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

      jMenu2.UnCheckAllMenuItem(); //UnCheck menu items
      for i:= 0  to jMenu2.CountSubMenus()-1 do
      begin
         jMenu2.UnCheckAllSubMenuItemByIndex(i);  //UnCheck All SubMenus items...
      end;

      jMenu2.CheckItem(jObjMenuItem);
      case itemID of
          10: jTextView2.FontColor:= colbrRed;
          11: jTextView2.FontColor:= colbrSalmon;
          12: jTextView2.FontColor:= colbrOlive;
          100: jTextView2.FontColor:= colbrIndigo;
          101: jTextView2.FontColor:= colbrMagenta;
          102: jTextView2.FontColor:= colbrLime;
      end;

    end
    else
    begin
      jMenu2.UnCheckItem(jObjMenuItem);
      jTextView2.FontColor:= colbrSilver; //colbrDefault was gone!
    end;
  end;
  //ShowMessage('itemID='+ IntToStr(itemID));
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  Self.Show;
  jMenu1.RegisterForContextMenu(jButton1.jSelf);  // <------- register jButton1 for Context Menu!
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage('Button clicked!');
end;

end.
