{hint: Pascal files location: ...\eMenu\jni }
unit u_menu_view;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, srecyclerview;

type

  { Tf_menu_view }

  Tf_menu_view = class(jForm)
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    menuView: jPanel;
    itemstext: jTextView;
    priceText: jTextView;
    panelBtn: jPanel;
    btnView: jPanel;
    panelMenu: jPanel;
    jsRecyclerView1: jsRecyclerView;
    jsRecyclerView2: jsRecyclerView;
    kategoriText: jTextView;
    procedure f_menu_viewJNIPrompt(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
    procedure jsRecyclerView1ItemWidgetClick(Sender: TObject;
      itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
      status: TItemWidgetStatus);
  private
    {private declarations}
  public
    procedure klik_kategori(posisi: integer);
    {public declarations}
  end;

var
  f_menu_view: Tf_menu_view;

implementation

{$R *.lfm}


{ Tf_menu_view }

procedure Tf_menu_view.klik_kategori(posisi: integer);
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
end;

procedure Tf_menu_view.f_menu_viewJNIPrompt(Sender: TObject);
var
  i: integer;
begin
  kategoriText.SetFontFromAssets('GoogleSans-Medium.ttf');
  //itemtext.SetFontFromAssets('GoogleSans-Bold.ttf');
  //priceText.SetFontFromAssets('GoogleSans-Bold.ttf');
  //----menu
  jsRecyclerView2.SetItemContentLayout(MenuView.View,
    False {cardview});   //custom item view!
  //jsRecyclerView2.Init;
  jsRecyclerView2.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfText);   // one text
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfText);   // another text
  jsRecyclerView2.AddItemContentFormat(cfPanel);
  jsRecyclerView2.SetItemContentFormat();
  //----menu

  //---load menu
  jsRecyclerView2.removeAll;
  for i := 0 to 20 do
  begin
    jsRecyclerView2.Add(
      //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
      'm1@drawable|' + 'FAST FOOD|' + 'ic_veg@drawable|' +
      '$ 3.5|' + IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@10');

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
  //jsRecyclerView2.Init;
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

end;

procedure Tf_menu_view.jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
begin
  klik_kategori(itemposition);
end;

procedure Tf_menu_view.jsRecyclerView1ItemWidgetClick(Sender: TObject;
  itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
  status: TItemWidgetStatus);
begin
  klik_kategori(itemposition);
end;

end.
