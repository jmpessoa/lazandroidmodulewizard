{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppToolbarDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, toolbar, Laz_And_Controls, menu, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jMenu1: jMenu;
    jTextView1: jTextView;
    jToolbar1: jToolbar;
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      checked: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
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
NEW! jToolbar component  [to use only with  "minSkd=21" and "targetSdk >= 21"] <<--- a request from @Tomash

NEW! demo AppToolbarDemo2 [use Toolbar as "Actionbar": configured
                          theme/style as "android:Theme.Material.Light.NoActionBar"
			  in "...res\values-21\style.xml"]

HINT 1: Configure your project colors:

     Go to project folder "....res/values/colors.xml"   <----- change [only content, NOT the file name]
                                                                      to configure colors

     Reference is here:
     http://www.vogella.com/tutorials/AndroidStylesThemes/article.html#styling-the-color-palette

HINT 2: if you change default ["colbrRoyalBlue"] jToolbar background color in design time,
			You should change "primary_dark" in "color.xml" according "material" guideline
			[a little more darker than the toolbar color]

			Reference is here: https://www.materialpalette.com/
*)

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  jToolbar1.SetAsActionBar(True);  // now we lost custom "OnClickNavigationIcon" event handle
  jToolbar1.SetSubtitle('LAMW');   //exists only when we have the toolbar "as actionbar"

  //if you dont provide an Icon as "NavigationIconIdentifier" property
  //then you nedd enable the default "home" button (in the corner of the action bar).
  //jToolbar1.SetHomeButtonEnabled(True);

  // or  set a custom  "home" button  res/drawable-xxxx
  jToolbar1.NavigationIconIdentifier:='ic_action_home';

end;

procedure TAndroidModule1.AndroidModule1CreateOptionMenu(Sender: TObject;
  jObjMenu: jObject);
var
  i: integer;
begin
  for i:=0 to jMenu1.Options.Count-1 do
  begin
      jMenu1.AddItem(jObjMenu, 10+i,  //item Id
                     jMenu1.Options.Strings[i],
                     jMenu1.IconIdentifiers.Strings[i],   //..res/drawable-xxx
                     mitDefault,
                     misIfRoomWithText);
   end;
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
  ShowMessage(itemCaption + '    [item = ' + IntToStr(itemID)+']');
end;

end.
