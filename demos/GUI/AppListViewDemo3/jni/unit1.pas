{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppListViewDemo3\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, And_jni,
  imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jImageFileManager1: jImageFileManager;
    jListView1: jListView;
    jListView2: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
    procedure jListView1DrawItemTextColor(Sender: TObject; itemIndex: integer;
      itemCaption: string; out textColor: TARGBColorBridge);
    procedure jListView2DrawItemBitmap(Sender: TObject; itemIndex: integer;
      itemCaption: string; out bimap: JObject);
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
USE 1
sintaxe:
leftText(center|text)rightText
ItemLayout = layText

USE 2
sintaxe:
leftText(center|text)rightText
ItemLayout = layImageTextWidget  or  layWidgetTextImage
NOTE: if ItemLayout <> layText  THEN in the absence of image [or widget] leftText/rightText will be used to
replace its!
*)

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
   ShowMessage(itemCaption);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //jListView1.SetAllPartsOnDrawItemTextColor(False); //Uncomment here ... to not color  leftPart and rightPart
end;

procedure TAndroidModule1.jListView1DrawItemTextColor(Sender: TObject;
  itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
begin
   if itemIndex = 1 then
   begin
      textColor:= colbrLightSlateBlue;    //Should I color leftPart and rightPart, too?
   end;                                   //if not, Uncomment in AndroidModule1JNIPrompt
end;

//if ItemLayout <> layText  THEN in the absence of image [or widget]
//leftText/rightText will be used to replace its!
procedure TAndroidModule1.jListView2DrawItemBitmap(Sender: TObject;
  itemIndex: integer; itemCaption: string; out bimap: JObject);
begin
  if itemIndex = 1 then   //only item index = 1 has a image ...
  begin
    ShowMessage(itemCaption);
    bimap:= jImageFileManager1.LoadFromAssets('lamw_logo_mini.png');
  end;
end;

end.
