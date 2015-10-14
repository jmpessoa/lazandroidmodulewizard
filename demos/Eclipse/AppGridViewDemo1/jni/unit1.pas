{Hint: save all files to location: C:\adt32\eclipse\workspace\AppGridViewDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, gridview, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jGridView1: jGridView;
      jImageFileManager1: jImageFileManager;
      jTextView1: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);

      procedure jGridView1ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jGridView1DrawItemBitmap(Sender: TObject; itemIndex: integer;
        itemCaption: string; out bimap: JObject);
      procedure jGridView1DrawItemTextColor(Sender: TObject;
        itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
      procedure jGridView1LongClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
    private
      {private declarations}
       FCount: integer;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jGridView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  //ShowMessage(itemCaption +' ['+IntToStr(itemIndex) +'] Clicked!');
  jGridView1.UpdateItemTitle(itemIndex, 'Changed!!');
end;

procedure TAndroidModule1.jGridView1DrawItemBitmap(Sender: TObject;
  itemIndex: integer; itemCaption: string; out bimap: JObject);
begin
  if (itemIndex mod 2 = 0) then
      bimap:= jImageFileManager1.LoadFromAssets('lemur_toy.jpg');
end;

procedure TAndroidModule1.jGridView1DrawItemTextColor(Sender: TObject;
  itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
begin
  if (itemIndex mod 2 = 0) then  //pair
      textColor:=  colbrGreen;
end;

procedure TAndroidModule1.jGridView1LongClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  ShowMessage(itemCaption +' ['+IntToStr(itemIndex) +']  LONG Click!');
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   inc(FCount);
   jGridView1.Add('Item_'+IntToStr(FCount), 'ic_launcher');  //from:  ../res/drawable
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  // jGridView1.DispatchOnDrawItemTextColor(False);    //improve performace!
  // jGridView1.DispatchOnDrawItemBitmap(False);       //improve performace!
end;

end.
