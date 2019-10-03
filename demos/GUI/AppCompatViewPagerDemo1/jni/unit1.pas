{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatViewPagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sviewpager,
  sfloatingbutton, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jListView1: jListView;
    jListView2: jListView;
    jListView3: jListView;
    jPanel1: jPanel;
    jsFloatingButton1: jsFloatingButton;
    jsViewPager1: jsViewPager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
    procedure jListView2ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
    procedure jListView3ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
    procedure jsFloatingButton1Click(Sender: TObject);
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



// NOTE: "Theme.AppCompat.Light.DarkActionBar"  in "....res\values\styles.xml"
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jsFloatingButton1.SetImageIdentifier('ic_add_white_36dp');
   jsFloatingButton1.SetPressedRippleColor(colbrCyan);

   //jsViewPager1.PagerStrip:= psTabTop;   //seted in desgin time...
   //jsViewPager1.SetBackgroundToPrimaryColor();
   jsViewPager1.SetClipToPadding(False);
   jsViewPager1.AddPage(jListView1.View, 'Client');
   jsViewPager1.AddPage(jListView2.View, 'Company');
   jsViewPager1.AddPage(jListView3.View, 'Employe');
   jsViewPager1.AddPage(jPanel1.View, 'About');
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  ShowMessage(itemCaption);
end;

procedure TAndroidModule1.jListView2ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
    ShowMessage(itemCaption);
end;

procedure TAndroidModule1.jListView3ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
    ShowMessage(itemCaption);
end;

procedure TAndroidModule1.jsFloatingButton1Click(Sender: TObject);
var
  p: integer;
begin
  p:= jsViewPager1.GetPosition();
  case p of
      0: jListView1.Add('New Client '  + IntToStr(jListView1.Count+1));
      1: jListView2.Add('New Company ' + IntToStr(jListView2.Count+1));
      2: jListView3.Add('New Employe ' + IntToStr(jListView3.Count+1));
      3: ShowMessage(jsViewPager1.GetPageTitle(p));
  end;
end;

end.
