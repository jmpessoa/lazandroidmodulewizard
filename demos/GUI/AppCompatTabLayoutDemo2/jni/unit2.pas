{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatNestedScrollViewDemo1\jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  srecyclerview;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jImageView1: jImageView;
    jPanel1: jPanel;
    jsRecyclerView1: jsRecyclerView;
    jTextView1: jTextView;
    procedure AndroidModule2JNIPrompt(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer; itemArrayOfStringCount: integer);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation

{$R *.lfm}

{ TAndroidModule2 }

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin

 //jsRecyclerView1.SetClipToPadding(False);
 jsRecyclerView1.SetItemContentLayout(jPanel1.View, True);
 jsRecyclerView1.SetItemContentFormat('image|text');
 jsRecyclerView1.Add('smile.png@assets|Client 01');
 jsRecyclerView1.Add('smile.png@assets|Client 02');
 jsRecyclerView1.Add('smile.png@assets|Client 03');
 jsRecyclerView1.Add('smile.png@assets|Client 04');
 jsRecyclerView1.Add('smile.png@assets|Client 05');
 jsRecyclerView1.Add('smile.png@assets|Client 06');
 jsRecyclerView1.Add('smile.png@assets|Client 07');
 jsRecyclerView1.Add('smile.png@assets|Client 08');
 jsRecyclerView1.Add('smile.png@assets|Client 09');
 jsRecyclerView1.Add('smile.png@assets|Client 10');
 jsRecyclerView1.Add('smile.png@assets|Client 11');
 jsRecyclerView1.Add('smile.png@assets|Client 12');
 jsRecyclerView1.Add('smile.png@assets|Client 13');
 jsRecyclerView1.Add('smile.png@assets|Client 14');
 jsRecyclerView1.Add('smile.png@assets|Client 15');
 jsRecyclerView1.Add('smile.png@assets|Client 16');
 jsRecyclerView1.Add('smile.png@assets|Client 17');
 jsRecyclerView1.Add('smile.png@assets|Client 18');
 jsRecyclerView1.Add('smile.png@assets|Client 19');
 jsRecyclerView1.Add('smile.png@assets|Client 20');
end;

procedure TAndroidModule2.jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer; itemArrayOfStringCount: integer);
var
  i: integer;
begin
  ShowMessage('itemPosition = ' + IntToStr(itemPosition) );
  for i:= 0 to itemArrayOfStringCount-1 do
  begin
    ShowMessage(jsRecyclerView1.GetSelectedContent(i));
  end;
end;


end.
