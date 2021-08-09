{hint: Pascal files location: ...\pascalid1\jni }
unit u_main;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, srecyclerview, And_jni;

type

  { Tf_main }

  Tf_main = class(jForm)
    dashboarrdDetailtext1: jTextView;
    dashboarrdDetailtext: jTextView;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jPanel1: jPanel;
    jsRecyclerView2: jsRecyclerView;
    menuView: jPanel;
    jsRecyclerView1: jsRecyclerView;
    jTextView1: jTextView;
    jTimer1: jTimer;
    menutext: jTextView;
    dashboardText: jTextView;
    menutext1: jTextView;
    procedure f_mainActivityCreate(Sender: TObject; intentData: jObject);
    procedure f_mainJNIPrompt(Sender: TObject);
    procedure f_mainRotate(Sender: TObject; rotate: TScreenStyle);
    procedure jImageBtn1Click(Sender: TObject);
    procedure jImageBtn2Click(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
    procedure jTimer1Timer(Sender: TObject);
    procedure menutextClick(Sender: TObject);
  private
    procedure rotasi(rotasi: string);
    {private declarations}
  public
    {public declarations}
  end;

var
  f_main: Tf_main;
  rotation: string;

implementation

uses u_detail;

{$R *.lfm}


{ Tf_main }
procedure Tf_main.rotasi(rotasi: string);
var
  image, menu: string;
  i: integer;
begin
  //----- menu
  if rotasi = 'berdiri' then
  begin
    jsRecyclerView1.Visible := True;
    jsRecyclerView2.Visible := False;
  end;
  if rotasi = 'tidur' then
  begin
    jsRecyclerView1.Visible := False;
    jsRecyclerView2.Visible := True;
  end;

end;

procedure Tf_main.f_mainJNIPrompt(Sender: TObject);
var
  image, menu: string;
  i: integer;
begin
  menutext.SetFontFromAssets('materialdesignicons-webfont.ttf');
  menutext.Text := self.ParseHtmlFontAwesome('f522');
  menutext1.SetFontFromAssets('GoogleSans-Regular.ttf');
  menutext1.Text := 'pascal-id koin';
  dashboardtext.SetFontFromAssets('GoogleSans-Bold.ttf');
  dashboarrdDetailtext.SetFontFromAssets('Roboto-Light.ttf');
  dashboarrdDetailtext1.SetFontFromAssets('Roboto-Light.ttf');

  jTextView1.SetFontFromAssets('GoogleSans-Bold.ttf');

  //----- menu recycler1
  jsRecyclerView1.Model := lmGrid;
  jsRecyclerView1.Orientation := loVertical;
  jsRecyclerView1.PosRelativeToAnchor := [raBelow];
  jsRecyclerView1.Anchor := jPanel1;

  jsRecyclerView1.SetItemContentLayout(MenuView.View,
    False {cardview});   //custom item view!
  //jsRecyclerView2.Init(gapp);
  jsRecyclerView1.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView1.AddItemContentFormat(cfPanel);
  jsRecyclerView1.AddItemContentFormat(cfImage);
  jsRecyclerView1.AddItemContentFormat(cfText);   // one text
  jsRecyclerView1.SetItemsRound(20);
  jsRecyclerView1.SetItemContentFormat();
  //----menu
  jsRecyclerView1.removeAll;

  ///----- recycler 2
  //----- menu recycler1
  jsRecyclerView2.Model := lmGrid;
  jsRecyclerView2.Orientation := loVertical;
  jsRecyclerView2.PosRelativeToAnchor := [raBelow];
  jsRecyclerView2.Anchor := jPanel1;

  jsRecyclerView2.SetItemContentLayout(MenuView.View,
    False {cardview});   //custom item view!
  //jsRecyclerView2.Init(gapp);
  jsRecyclerView2.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView2.AddItemContentFormat(cfPanel);
  jsRecyclerView2.AddItemContentFormat(cfImage);
  jsRecyclerView2.AddItemContentFormat(cfText);   // one text
  jsRecyclerView2.SetItemsRound(20);
  jsRecyclerView2.SetItemContentFormat();
  //----menu
  jsRecyclerView2.removeAll;

  for i := 0 to 5 do
  begin
    if i = 0 then
    begin
      image := 'b1';
      menu := 'Makan';
    end;
    if i = 1 then
    begin
      image := 'b2';
      menu := 'Laporan';
    end;
    if i = 2 then
    begin
      image := 'b3';
      menu := 'Riwayat';
    end;
    if i = 3 then
    begin
      image := 'b4';
      menu := 'Kirim';
    end;
    if i = 4 then
    begin
      image := 'b5';
      menu := 'Keamanan';
    end;
    if i = 5 then
    begin
      image := 'b6';
      menu := 'Ajak teman';
    end;
    //---recycler1
    jsRecyclerView1.Add(
      IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@30' + '|' +
      //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
      image + '@drawable|' + menu);
    //---recycler2
    jsRecyclerView2.Add(
      IntToStr(GetARGBJava(Fcustomcolor, colbrWhiteSmoke)) + '@30' + '|' +
      //'@30|url@https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/18/e93d8df2-2671-41e8-9d75-087b8e23cf23.jpg.webp?ect=4g|Parts item '+inttostr(i+1)+
      image + '@drawable|' + menu);
  end;
  jsRecyclerView1.Refresh;

end;

procedure Tf_main.f_mainRotate(Sender: TObject; rotate: TScreenStyle);
begin
  //---Rensponsiveness events
  if rotate = ssPortrait then // berdiri
  begin
    rotation := 'berdiri';
    rotasi(rotation);
    jImageView1.LayoutParamWidth := lpOneSixthOfParent;
    jImageView1.LayoutParamHeight := lpOneQuarterOfParent;
    dashboardText.FontSize := 40;
    jsRecyclerView1.MarginTop := -50;
    jsRecyclerView2.MarginTop := -50;
  end;
  if rotate = ssLandscape then // tidur
  begin
    rotation := 'tidur';
    rotasi(rotation);
    jImageView1.LayoutParamWidth := lpOneEighthOfParent;
    jImageView1.LayoutParamHeight := lptwoThirdOfParent;
    dashboardText.FontSize := 20;
    jsRecyclerView1.MarginTop := -20;
    jsRecyclerView2.MarginTop := -20;
  end;
end;

procedure Tf_main.f_mainActivityCreate(Sender: TObject; intentData: jObject);
begin
  if f_detail = nil then
  begin
    gApp.CreateForm(Tf_detail, f_detail);
    //f_main.TryBacktrackOnClose := True;
    f_detail.Init(gApp);
  end;
end;

procedure Tf_main.jImageBtn1Click(Sender: TObject);
begin
  jtimer1.Enabled := True;
end;

procedure Tf_main.jImageBtn2Click(Sender: TObject);
begin
  jtimer1.Enabled := False;
end;

procedure Tf_main.jImageView1Click(Sender: TObject);
begin
  f_detail.Show;
end;

procedure Tf_main.jTimer1Timer(Sender: TObject);
begin
  if menutext1.FontColor = colbrGold then
  begin
    menutext1.FontColor := colbrDefault;
    ShowMessage('default');
    Exit;
  end;
  if menutext1.FontColor = colbrDefault then
  begin
    menutext1.FontColor := colbrGold;
    ShowMessage('colbrgold');
    Exit;
  end;
  menutext1.Init(gApp);
end;

procedure Tf_main.menutextClick(Sender: TObject);
begin
  f_detail.Show;
end;

end.
