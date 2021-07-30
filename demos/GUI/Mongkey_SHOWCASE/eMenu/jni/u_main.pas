{hint: Pascal files location: ...\eMenu\jni }
unit u_main;
//{$mode delphi}
{$mode objfpc}{$H+}
interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,  And_jni,
  srecyclerview,  http_listen;

type

  { Tf_main }
  //  TPassMessage = procedure(AMsg: string) of object;

  Tf_main = class(jForm)

    cari_brg_text: jEditText;
    jAsyncTask1: jAsyncTask;
    btnView: jPanel;
    jImageView7: jImageView;
    jImageView8: jImageView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    deskripsilogo: jTextView;
    jTimer1: jTimer;
    qtyText: jTextView;
    qtyimage: jImageView;
    plusImage: jImageView;
    minusimage: jImageView;
    jButton1: jButton;
    infoimage: jImageView;
    jImageView6: jImageView;
    jPanel1: jPanel;
    jPanel5: jPanel;
    jScrollView1: jScrollView;
    menuView: jPanel;
    panelBtn: jPanel;
    panelinfo: jPanel;
    panelMain: jPanel;
    panelMenu: jPanel;
    searchtext: jEditText;
    jImageView1: jImageView;
    jImageView4: jImageView;
    jImageView5: jImageView;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jPanel4: jPanel;
    jsRecyclerView1: jsRecyclerView;
    jsRecyclerView2: jsRecyclerView;
    itemtext: jTextView;
    pricetext: jTextView;
    kategoriText: jTextView;
    cartText: jTextView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    timerMati: jTimer;

    procedure cari_brg_textAfterDispatchDraw(Sender: TObject; canvas: JObject);
    procedure cari_brg_textBackPressed(Sender: TObject);
    procedure cari_brg_textChange(Sender: TObject; txt: string; Count: integer);
    procedure cari_brg_textChanged(Sender: TObject; txt: string; Count: integer);
    procedure cartTextClick(Sender: TObject);
    procedure f_mainActivityCreate(Sender: TObject; intentData: jObject);
    procedure f_mainDestroy(Sender: TObject);
    procedure f_mainJNIPrompt(Sender: TObject);
    procedure f_mainRotate(Sender: TObject; rotate: TScreenStyle);
    procedure f_mainShow(Sender: TObject);
    procedure f_mainSpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure jAsyncTask1DoInBackground(Sender: TObject; progress: integer;
      out keepInBackground: boolean);
    procedure jButton1Click(Sender: TObject);
    procedure jImageView6TouchUp(Sender: TObject; Touch: TMouch);
    procedure jsRecyclerView2ItemWidgetClick(Sender: TObject;
      itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
      status: TItemWidgetStatus);
    procedure jsRecyclerView2ItemWidgetTouchUp(Sender: TObject;
      itemPosition: integer; widget: TItemContentFormat; widgetId: integer);
    procedure jTimer1Timer(Sender: TObject);
    procedure panelinfoFlingGesture(Sender: TObject; flingGesture: TFlingGesture);
    procedure searchtextClick(Sender: TObject);
    procedure jSearchView1Click(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
    procedure jsRecyclerView1ItemWidgetClick(Sender: TObject;
      itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
      status: TItemWidgetStatus);
    procedure jTextView1Click(Sender: TObject);
    procedure searchtextEnter(Sender: TObject);
    procedure searchtextFocus(Sender: TObject; textContent: string);
    procedure timerMatiTimer(Sender: TObject);
  private
    procedure RunServer;
  public
    procedure klik_kategori(posisi: integer);
    {public declarations}
  end;


var
  f_main: Tf_main;
  notif_mati: integer;
  server_start: integer = 0;

implementation

uses u_menu_view;

{$R *.lfm}


{ Tf_main }

//--- web server
procedure Tf_main.Runserver;
var
  webserver: TLightWeb;
begin
  webserver := TLightWeb.Create(8080);
  webserver.start;
end;

//--- web server
procedure Tf_main.klik_kategori(posisi: integer);
var
  i: integer;
begin
  for i := 0 to jsRecyclerView1.GetItemCount() - 1 do
  begin
    jsRecyclerView1.SetWidgetTextColor(i, cftext, kategoriText.Id,
      colbrDefault);
    jsRecyclerView1.SetItemBackgroundColor(i, colbrWhite, 10);
  end;
  jsRecyclerView1.SetWidgetTextColor(posisi, cftext, kategoriText.Id,
    colbrWhite);
  jsRecyclerView1.SetItemBackgroundColor(posisi, colbrorange, 10);
  jsRecyclerView1.Refresh;
  jsRecyclerView1.SmoothScrollToPosition(posisi);
end;


procedure Tf_main.f_mainJNIPrompt(Sender: TObject);
var
  i: integer;
begin
  ShowMessage(self.GetDeviceManufacturer() + ' - ' + self.GetDeviceModel());
  ShowMessage('your wifi ip - ' + self.GetDeviceWifiIPAddress());
  ShowMessage('your data ip - ' + self.GetDeviceDataMobileIPAddress());

  kategoriText.SetFontFromAssets('GoogleSans-Medium.ttf');
  searchText.SetFontFromAssets('GoogleSans-Medium.ttf');
  itemText.SetFontFromAssets('GoogleSans-Bold.ttf');
  priceText.SetFontFromAssets('GoogleSans-Bold.ttf');
  QtyText.SetFontFromAssets('GoogleSans-Bold.ttf');
  deskripsilogo.SetFontFromAssets('GoogleSans-Bold.ttf');
  deskripsilogo.Text := 'Kitchen json server';
  //----menu
  jsRecyclerView2.SetItemContentLayout(MenuView.View,
    False {cardview});   //custom item view!
  //jsRecyclerView2.Init(gapp);
  jsRecyclerView2.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfText);   // one text
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfText);   // another text
  jsRecyclerView2.AddItemContentFormat(cfPanel);
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfText);   // another text
  jsRecyclerView2.SetItemsRound(20);
  jsRecyclerView2.SetItemContentFormat();
  //----menu

  //---load menu
  jsRecyclerView2.removeAll;
  for i := 0 to 20 do
  begin
    jsRecyclerView2.Add(
      //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
      'm1@drawable|' + 'ITEM ' + IntToStr(i) + '|' + 'ic_veg@drawable|' +
      '$ 3.5|' + IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) +
      '@30' + '|info@drawable' + '|plus@drawable' + '|minus@drawable' +
      '|qty@drawable|0');
    //jsRecyclerView2.SetWidgetText(i,cfImage,infoimage.id,inttostr(i));
    {if i = 0 then
      jsRecyclerView2.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'm1@drawable|' + 'FAST FOOD|' + 'ic_veg@drawable|' +
        'FAST FOOD|' + IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@10');
    if i = 1 then
      jsRecyclerView2.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'm2@drawable|' + 'FAST FOOD|' + 'ic_veg@drawable|' +
        'FAST FOOD|' + IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@10');
    if i = 2 then
      jsRecyclerView2.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'm3@drawable|' + 'FAST FOOD|' + 'ic_veg@drawable|' +
        'FAST FOOD|' + IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@10');
    if i = 3 then
      jsRecyclerView2.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'm4@drawable|' + 'FAST FOOD|' + 'ic_veg@drawable|' +
        'FAST FOOD|' + IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@10');
    //jsRecyclerView1.SetItemTag(i, f_setting.kursor1.GetValueAsstring('nomor'));
    //f_setting.kursor1.MoveToNext;
    }
  end;
  jsRecyclerView2.Refresh;
  //--- load menu


  //----button
  jsRecyclerView1.SetItemContentLayout(btnView.View,
    False {cardview});   //custom item view!
  //jsRecyclerView2.Init(gapp);
  jsRecyclerView1.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView1.AddItemContentFormat(cfImage);
  jsRecyclerView1.AddItemContentFormat(cfText);   // one text
  jsRecyclerView1.AddItemContentFormat(cfPanel);
  jsRecyclerView1.SetItemContentFormat();

  //----button

  //---load btn
  jsRecyclerView1.removeAll;
  for i := 0 to 3 do
  begin
    if i = 0 then
      jsRecyclerView1.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'cat_fastfood@drawable|' + 'FAST FOOD|' + IntToStr(
        GetARGBJava(Fcustomcolor, colbrWhite)) + '@10');
    if i = 1 then
      jsRecyclerView1.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'cat_seafood@drawable|' + 'SEA FOOD|' + IntToStr(
        GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@10');
    if i = 2 then
      jsRecyclerView1.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'cat_chinese@drawable|' + 'CHINESE|' +
        IntToStr(GetARGBJava(Fcustomcolor, colbrWhite)) + '@10');
    if i = 3 then
      jsRecyclerView1.Add(
        //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
        'cat_dessert@drawable|' + 'DESSERT|' +
        IntToStr(GetARGBJava(Fcustomcolor, colbrWhite)) + '@10');
    //jsRecyclerView1.SetItemTag(i, f_setting.kursor1.GetValueAsstring('nomor'));
    //f_setting.kursor1.MoveToNext;
  end;
  jsRecyclerView1.Refresh;
  //--- load btn

  cartText.SetFontFromAssets('Roboto-Light.ttf');
  cartText.Text := '  Items in Cart (0)  ';
  jtextview1.SetFontFromAssets('GoogleSans-Bold.ttf');
  jtextview1.Text := 'LAMW';
  jtextview2.SetFontFromAssets('GoogleSans-Bold.ttf');
  jtextview2.Text := ' eMenu';

  cari_brg_text.SetBackgroundByResIdentifier('searchitem1');
  cari_brg_text.SetImeOptions(imeActionGo);
  cari_brg_text.CloseSoftInputOnEnter := True;
  cari_brg_text.SetSoftInputOptions(imeFlagNoFullScreen);
  cari_brg_text.SetFontFromAssets('GoogleSans-Bold.ttf');

  cartText.SetRadiusRoundCorner(30);
  cartText.SetRoundCorner();
  //cartText.SetCompoundDrawables('searchitem', cdsAbove);
end;

procedure Tf_main.f_mainRotate(Sender: TObject; rotate: TScreenStyle);
begin
  case rotate of
    ssLandscape:
    begin
      f_menu_view.panelMenu.LayoutParamWidth := lpMatchParent;
      f_menu_view.panelMenu.UpdateLayout;
      f_menu_view.panelMenu.Width := self.GetScreenWidth();
      searchText.Init(gApp);
    end;
  end;
end;

procedure Tf_main.f_mainShow(Sender: TObject);
begin
  //jtimer1.Enabled := True;
  if server_start = 0 then
  begin
    server_start := 1;
    //jAsyncTask1.Execute;
  end;
  //  f_menu_view.panelmenu.Parent := Self.panelmenu;
  //  f_menu_view.panelmenu.SetViewParent(Self.panelmenu.View);
  ///  f_menu_view.panelBtn.Parent := Self.panelBtn;
  //  f_menu_view.panelBtn.SetViewParent(Self.panelBtn.View);

  {
  case rotate of
     ssLandscape:
     begin

       jPanel3.LayoutParamWidth:= lpMatchParent;
       jPanel3.PosRelativeToParent:= [rpTop];

       jPanel4.LayoutParamWidth:= lpMatchParent;
       jPanel4.PosRelativeToAnchor:= [raBelow];

       jPanel1.LayoutParamHeight := lpMatchParent;
       jPanel1.LayoutParamWidth := lpThreeQuarterOfParent;
       jPanel1.PosRelativeToParent := [rpLeft];

       jPanel2.LayoutParamHeight := lpMatchParent;
       jPanel2.LayoutParamWidth := lpOneQuarterOfParent;
       jPanel2.PosRelativeToAnchor := [raToRightOf, raAlignBaseline];

     end;
     ssPortrait:
     begin

       jPanel3.LayoutParamWidth:= lpHalfOfParent;
       jPanel3.PosRelativeToParent:= [rpTop];

       jPanel4.LayoutParamWidth:= lpHalfOfParent;
       jPanel4.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];


       jPanel1.LayoutParamHeight := lpFourFifthOfParent;
       jPanel1.LayoutParamWidth := lpMatchParent;
       jPanel1.PosRelativeToParent := [rpTop];

       jPanel2.LayoutParamHeight := lpOneFifthOfParent;
       jPanel2.LayoutParamWidth := lpMatchParent;
       jPanel2.PosRelativeToAnchor := [raBelow];

     end;
  end;

  if rotate in [ssLandscape, ssPortrait] then
  begin

    jPanel1.ClearLayout;
    jPanel2.ClearLayout;
    jPanel3.ClearLayout;
    jPanel4.ClearLayout;

    Self.UpdateLayout;
  end;


  }

end;

procedure Tf_main.f_mainSpecialKeyDown(Sender: TObject; keyChar: char;
  keyCode: integer; keyCodeString: string; var mute: boolean);
begin

  if keyCode = 4 then  //KEYCODE_BACK
  begin
    panelmain.BringToFront;
    if notif_mati = 2 then
      F_main.Close;
    if notif_mati = 1 then
      ShowMessage('press once again to exit');
    notif_mati := notif_mati + 1;
    timerMati.Enabled := True;
    mute := True; //dont close app
  end;

end;

procedure Tf_main.jAsyncTask1DoInBackground(Sender: TObject;
  progress: integer; out keepInBackground: boolean);
begin
  keepInBackground := True;
  RunServer;
end;

procedure Tf_main.jButton1Click(Sender: TObject);
begin
  jAsyncTask1.AsyncTaskState:=atsInBackground;
  jAsyncTask1.Execute;
end;

procedure Tf_main.jImageView6TouchUp(Sender: TObject; Touch: TMouch);
begin
  panelmain.BringToFront;
end;

procedure Tf_main.jsRecyclerView2ItemWidgetClick(Sender: TObject;
  itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
  status: TItemWidgetStatus);
begin
  //if widget=cfImage then showmessage(jsRecyclerView2.GetWidgetText(itemPosition,cfImage,infoimage.Id));
  if jsRecyclerView2.GetWidgetText(itemPosition, cfImage, widgetId) = 'info@drawable' then
    panelinfo.BringToFront;
  if jsRecyclerView2.GetWidgetText(itemPosition, cfImage, widgetId) = 'plus@drawable' then
  begin
    jsRecyclerView2.SetWidgetText(itemposition, cftext, qtyText.id,
      IntToStr(StrToInt(jsRecyclerView2.GetWidgetText(itemposition,
      cftext, qtyText.id)) + 1));
    jsRecyclerView2.Refresh(itemPosition);
  end;
  if jsRecyclerView2.GetWidgetText(itemPosition, cfImage, widgetId) = 'minus@drawable' then
  begin
    if StrToInt(jsRecyclerView2.GetWidgetText(itemposition, cftext, qtyText.id)) -
    1 = -1 then
      exit;
    jsRecyclerView2.SetWidgetText(itemposition, cftext, qtyText.id,
      IntToStr(StrToInt(jsRecyclerView2.GetWidgetText(itemposition,
      cftext, qtyText.id)) - 1));
    jsRecyclerView2.Refresh(itemPosition);
  end;
  // showmessage('info - '+jsRecyclerView2.GetWidgetText(itemposition,cfText,itemtext.id));
  //if widgetId=14 then   showmessage('menu');
  //if widget=cfImage then showmessage(inttostr(widgetId));
  //exit;
  //if (jsRecyclerView2.GetWidgetText(itemposition,cfImage,infoimage.id))='info@drawable' then
  //showmessage('info');
end;

procedure Tf_main.jsRecyclerView2ItemWidgetTouchUp(Sender: TObject;
  itemPosition: integer; widget: TItemContentFormat; widgetId: integer);
begin

end;

procedure Tf_main.jTimer1Timer(Sender: TObject);
begin
  exit;
end;

procedure Tf_main.panelinfoFlingGesture(Sender: TObject; flingGesture: TFlingGesture);
begin
end;

procedure Tf_main.searchtextClick(Sender: TObject);
begin
  //jimageview3.ImageIdentifier := 'searchitem1';
  //jimageview3.Init(gApp);
end;

procedure Tf_main.jSearchView1Click(Sender: TObject);
begin
end;

procedure Tf_main.jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
begin
  klik_kategori(itemposition);
end;

procedure Tf_main.jsRecyclerView1ItemWidgetClick(Sender: TObject;
  itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
  status: TItemWidgetStatus);
begin
  klik_kategori(itemposition);
end;

procedure Tf_main.jTextView1Click(Sender: TObject);
begin
  //f_menu_view.panelMenu.ClearLayout;
  //f_menu_view.panelMenu.LayoutParamWidth := lpMatchParent;
  f_menu_view.panelMenu.Width := panelMenu.Width * 2;

  f_menu_view.panelMenu.Init(gApp);
  //f_menu_view.panelMenu.UpdateLayout;
end;

procedure Tf_main.searchtextEnter(Sender: TObject);
begin
  //jimageview3.ImageIdentifier := 'searchitem1';
end;

procedure Tf_main.searchtextFocus(Sender: TObject; textContent: string);
begin
  //jimageview3.ImageIdentifier := 'searchitem1';
end;

procedure Tf_main.timerMatiTimer(Sender: TObject);
begin
  notif_mati := 0;
  timerMati.Enabled := False;
end;

procedure Tf_main.cartTextClick(Sender: TObject);
begin
end;

procedure Tf_main.cari_brg_textChange(Sender: TObject; txt: string; Count: integer);
begin

end;

procedure Tf_main.cari_brg_textAfterDispatchDraw(Sender: TObject; canvas: JObject);
begin

end;

procedure Tf_main.cari_brg_textBackPressed(Sender: TObject);
begin

end;

procedure Tf_main.cari_brg_textChanged(Sender: TObject; txt: string; Count: integer);
begin
  cari_brg_text.SetBackgroundByResIdentifier('searchitem');

  cari_brg_text.SetMovementMethod;
end;

procedure Tf_main.f_mainActivityCreate(Sender: TObject; intentData: jObject);
begin
  if f_menu_view = nil then
  begin
    gApp.CreateForm(Tf_menu_view, f_menu_view);
    //f_landing.TryBacktrackOnClose := True;
    f_menu_view.Init(gApp);
  end;
  //inherited Create(False);
end;

procedure Tf_main.f_mainDestroy(Sender: TObject);
begin

end;

end.
