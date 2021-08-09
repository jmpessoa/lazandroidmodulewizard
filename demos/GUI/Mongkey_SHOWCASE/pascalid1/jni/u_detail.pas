{hint: Pascal files location: ...\\jni }
unit u_detail;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sfloatingbutton,
  srecyclerview;

type

  { Tf_detail }

  Tf_detail = class(jForm)
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    cardView: jPanel;
    jsFloatingButton1: jsFloatingButton;
    jsRecyclerView1: jsRecyclerView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    jTextView6: jTextView;
    jTextView7: jTextView;
    jTextView8: jTextView;
    notifText: jTextView;
    procedure f_detailJNIPrompt(Sender: TObject);
    procedure f_detailRotate(Sender: TObject; rotate: TScreenStyle);
    procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
    procedure jPanel1Up(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
    procedure jsRecyclerView1ItemTouchDown(Sender: TObject; itemPosition: integer);
    procedure jsRecyclerView1ItemTouchUp(Sender: TObject; itemPosition: integer);
    procedure jTextView5Click(Sender: TObject);
  private
    procedure klikitem(posisi: integer);
    {private declarations}
  public
    {public declarations}
  end;

var
  f_detail: Tf_detail;
  rotation: String;

implementation

uses u_main;

{$R *.lfm}


{ Tf_detail }
procedure Tf_detail.klikitem(posisi: integer);
var
  i: integer;
begin
  for i := 0 to jsRecyclerView1.GetItemCount() - 1 do
  begin
    jsRecyclerView1.SetWidgetTextColor(i, cftext, jTextView3.Id,
      colbrDefault);
    jsRecyclerView1.SetItemBackgroundColor(i, colbrWhiteSmoke, 30);
  end;
  jsRecyclerView1.SetWidgetTextColor(posisi, cftext, jTextView3.Id,
    colbrRoyalBlue);
  jsRecyclerView1.SetItemBackgroundColor(posisi, colbrBisque, 30);
  jsRecyclerView1.Refresh;
  if posisi + 3 >= jsRecyclerView1.GetItemCount() - 1 then
    jsRecyclerView1.SmoothScrollToPosition(posisi + 1)
  else begin
    if rotation='berdiri' then
    jsRecyclerView1.SmoothScrollToPosition(posisi + 3) else
    jsRecyclerView1.SmoothScrollToPosition(posisi + 1);
  end;

  exit;
  if posisi > 5 then
  begin
    jImageView1.ImageIdentifier := 'backgrounddown1';
    jsFloatingButton1.BackgroundColor := colBrGray;
  end;
  if posisi <= 5 then
  begin
    jImageView1.ImageIdentifier := 'backgrounddown';
    jsFloatingButton1.BackgroundColor := colBrDodgerBlue;
  end;

end;

procedure Tf_detail.f_detailJNIPrompt(Sender: TObject);
var
  i: integer;
  image, image1: string;
begin
  jTextView1.SetFontFromAssets('materialdesignicons-webfont.ttf');
  jTextView1.Text := self.ParseHtmlFontAwesome('f2e5');
  jTextView2.SetFontFromAssets('materialdesignicons-webfont.ttf');
  jTextView2.Text := self.ParseHtmlFontAwesome('f112');

  jTextView5.SetFontFromAssets('materialdesignicons-webfont.ttf');
  jTextView5.Text := self.ParseHtmlFontAwesome('f522');
  jTextView7.SetFontFromAssets('materialdesignicons-webfont.ttf');
  jTextView7.Text := self.ParseHtmlFontAwesome('f193');
  jTextView6.SetFontFromAssets('GoogleSans-Bold.ttf');

  jTextView3.SetFontFromAssets('GoogleSans-Bold.ttf');
  jTextView4.SetFontFromAssets('GoogleSans-Bold.ttf');

  //----- notif styling
  notifText.SetRadiusRoundCorner(50);
  notifText.SetRoundCorner();


  //----- menu
  jsRecyclerView1.SetItemContentLayout(cardView.View,
    False {cardview});   //custom item view!
  //jsRecyclerView2.Init(gapp);
  jsRecyclerView1.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView1.AddItemContentFormat(cfPanel);
  jsRecyclerView1.AddItemContentFormat(cfImage);
  jsRecyclerView1.AddItemContentFormat(cfText);   // one text
  jsRecyclerView1.AddItemContentFormat(cfText);   // one text
  jsRecyclerView1.AddItemContentFormat(cfImage);
  jsRecyclerView1.AddItemContentFormat(cfText);   // one text
  jsRecyclerView1.SetItemsRound(20);
  jsRecyclerView1.SetItemContentFormat();
  //----menu
  jsRecyclerView1.removeAll;
  for i := 0 to 9 do
  begin
    if i = 0 then
      image := 'h1';
    if i = 1 then
      image := 'h2';
    if i = 2 then
      image := 'h3';
    if i = 3 then
      image := 'h4';
    if i = 4 then
      image := 'h5';
    if i = 5 then
      image := 'h6';
    if i = 6 then
      image := 'h7';
    if i = 7 then
      image := 'h8';
    if i = 8 then
      image := 'h9';
    if i = 9 then
      image := 'h10';

    if i = 0 then
      image1 := 'c1';
    if i = 1 then
      image1 := 'c2';
    if i = 2 then
      image1 := 'c3';
    if i = 3 then
      image1 := 'c4';
    if i = 4 then
      image1 := 'c5';
    if i = 5 then
      image1 := 'c6';
    if i = 6 then
      image1 := 'c7';
    if i = 7 then
      image1 := 'c8';
    if i = 8 then
      image1 := 'c9';
    if i = 9 then
      image1 := 'c10';

    jsRecyclerView1.Add(
      IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@30' + '|' +
      //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
      image + '@drawable|' + 'User ' + IntToStr(i + 1) + '|' + '$ ' +
      IntToStr(i + 100) + '|' + image1 + '@drawable' + '|' +
      'Ambrose street ' + IntToStr(i));
  end;
  jsRecyclerView1.Add(
    IntToStr(GetARGBJava(Fcustomcolor, colbrWhite)) + '@10' + '|' +
    //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
    image + '9@drawable| | |' + image1 + '8@drawable' + '| ');

  jsRecyclerView1.Refresh;
end;

procedure Tf_detail.f_detailRotate(Sender: TObject; rotate: TScreenStyle);
begin
  //---Rensponsiveness events
  if rotate = ssPortrait then // berdiri
  begin
    rotation:='berdiri';
    jimageView1.LayoutParamHeight := lpOneEighthOfParent;
    notifText.MarginTop:=35;
    jTextview5.FontSize:=30;
  end;
  if rotate = ssLandscape then // tidur
  begin
    rotation:='tidur';
    jimageView1.LayoutParamHeight := LpOneQuarterOfParent;
    notifText.MarginTop:=15;
    jTextview5.FontSize:=20;
  end;
end;

procedure Tf_detail.jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
begin
  if flingGesture = flitoptobottom then
  begin
    jImageView1.ImageIdentifier := 'backgrounddown1';
    jsFloatingButton1.BackgroundColor := colBrGray;
  end;
  if flingGesture = fliBottomToTop then
  begin
    jImageView1.ImageIdentifier := 'backgrounddown';
    jsFloatingButton1.BackgroundColor := colBrDodgerBlue;
  end;
end;

procedure Tf_detail.jPanel1Up(Sender: TObject);
begin

end;

procedure Tf_detail.jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
begin
  klikItem(itemPosition);
end;

procedure Tf_detail.jsRecyclerView1ItemTouchDown(Sender: TObject;
  itemPosition: integer);
begin
  if itemposition < 5 then
  begin
    jImageView1.ImageIdentifier := 'backgrounddown1';
    jsFloatingButton1.BackgroundColor := colBrGray;
  end;
end;

procedure Tf_detail.jsRecyclerView1ItemTouchUp(Sender: TObject; itemPosition: integer);
begin
  if itemposition >= 5 then
  begin
    jImageView1.ImageIdentifier := 'backgrounddown';
    jsFloatingButton1.BackgroundColor := colBrDodgerBlue;
  end;
end;


procedure Tf_detail.jTextView5Click(Sender: TObject);
begin
  Close;
  f_main.Show;
end;

end.
