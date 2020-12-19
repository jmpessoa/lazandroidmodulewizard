{Hint: save all files to location: D:\lamw\projects\AppGridColorPickerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, gridview, Laz_And_Controls, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jGridView1: jGridView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jGridView1ClickItem(Sender: TObject; ItemIndex: integer;
      itemCaption: string);
    procedure jGridView1DrawItemBitmap(Sender: TObject; itemIndex: integer;
      itemCaption: string; out bimap: JObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;
  gridcolorcount:integer=0;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  i:TARGBColorBridge;
begin
  if gridcolorcount<1 then
  begin
    for i:=Low(TARGBColorBridge) to High(TARGBColorBridge) do
    begin
      jGridView1.Add(inttostr(gridcolorcount), '');
      inc(gridcolorcount);
    end;
    jGridView1.Add(' + ', '');
  end;
end;

procedure TAndroidModule1.jGridView1ClickItem(Sender: TObject;
  ItemIndex: integer; itemCaption: string);
begin
  if ItemIndex<gridcolorcount then
  begin
    //AndroidModule1.BackgroundColor := TARGBColorBridge(ItemIndex);
    jTextView1.FontColor:=TARGBColorBridge(ItemIndex);
    jPanel1.BackgroundColor:=TARGBColorBridge(ItemIndex);
    jButton1.BackgroundColor:=TARGBColorBridge(ItemIndex);
    //Some diferent color to the fonts to some contrarst
    jButton1.FontColor:=TARGBColorBridge(gridcolorcount-ItemIndex);
    jTextView2.FontColor:=TARGBColorBridge(gridcolorcount-ItemIndex);;
  end
end;

procedure TAndroidModule1.jGridView1DrawItemBitmap(Sender: TObject;
  itemIndex: integer; itemCaption: string; out bimap: JObject);
begin
  jBitmap1.CreateBitmap(100,100,TARGBColorBridge(itemIndex));
  if itemindex>=gridcolorcount then
    jBitmap1.DrawText('...',40,50,16,colbrBlack);
  bimap:= jBitmap1.GetImage();
end;

end.
