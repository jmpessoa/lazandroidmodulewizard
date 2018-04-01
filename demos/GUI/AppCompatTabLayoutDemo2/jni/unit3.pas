{Hint: save all files to location: C:\Users\jmpessoa\workspace\AppCompatNestedScrollViewDemo1\jni }
unit unit3;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  srecyclerview, menu;
  
type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
    jImageView1: jImageView;
    jMenu1: jMenu;
    jPanel1: jPanel;
    jsRecyclerView1: jsRecyclerView;
    jTextView1: jTextView;
    procedure AndroidModule3JNIPrompt(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer; itemArrayOfStringCount: integer);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule3: TAndroidModule3;

implementation

{$R *.lfm}

{ TAndroidModule3 }

procedure TAndroidModule3.AndroidModule3JNIPrompt(Sender: TObject);
begin

 jsRecyclerView1.SetItemContentLayout(jPanel1.View, True);
 jsRecyclerView1.SetItemContentFormat('image|text');
 jsRecyclerView1.Add('work.png@assets|Company 01');
 jsRecyclerView1.Add('work.png@assets|Company 02');
 jsRecyclerView1.Add('work.png@assets|Company 03');
 jsRecyclerView1.Add('work.png@assets|Company 04');
 jsRecyclerView1.Add('work.png@assets|Company 05');
 jsRecyclerView1.Add('work.png@assets|Company 06');
 jsRecyclerView1.Add('work.png@assets|Company 07');
 jsRecyclerView1.Add('work.png@assets|Company 08');
 jsRecyclerView1.Add('work.png@assets|Company 09');
 jsRecyclerView1.Add('work.png@assets|Company 10');
 jsRecyclerView1.Add('work.png@assets|Company 11');
 jsRecyclerView1.Add('work.png@assets|Company 12');
 jsRecyclerView1.Add('work.png@assets|Company 13');
 jsRecyclerView1.Add('work.png@assets|Company 14');
 jsRecyclerView1.Add('work.png@assets|Company 15');
 jsRecyclerView1.Add('work.png@assets|Company 16');
 jsRecyclerView1.Add('work.png@assets|Company 17');
 jsRecyclerView1.Add('work.png@assets|Company 18');
 jsRecyclerView1.Add('work.png@assets|Company 19');
 jsRecyclerView1.Add('work.png@assets|Company 20');
end;

procedure TAndroidModule3.jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer; itemArrayOfStringCount: integer);
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
