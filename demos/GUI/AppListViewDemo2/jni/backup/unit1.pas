{Hint: save all files to location: C:\Development3\lazandroidmodulewizard\demos\Eclipse\AppListViewDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, And_jni;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jCanvas1: jCanvas;
    jListView1: jListView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jListView1AfterDispatchDraw(Obj: TObject; canvas: JObject;
      tag: integer);
  private
    TotalListViewHeight:integer;
    ItemHeight:integer;
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}
  
const
  DividerHeight = 3;

{ TAndroidModule1 }

procedure TAndroidModule1.jListView1AfterDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
var
  x:double;
begin
  jCanvas1.SetCanvas(canvas);
  x:=ItemHeight;

  // fake some appointments !!
  // draw rect
  jCanvas1.PaintStrokeWidth:=2;
  jCanvas1.PaintStyle:=psFillAndStroke;
  jCanvas1.PaintColor:=colbrBlue;

  jCanvas1.drawRoundRect(200,0-tag,500,x*2-tag,25,25);
  jCanvas1.drawRoundRect(200,x*10-tag,500,x*12-tag,25,25);
  jCanvas1.drawRoundRect(200,x*30-tag,500,x*35-tag,25,25);

  // draw text
  jCanvas1.PaintStrokeWidth:=1;
  jCanvas1.PaintStyle:=psFillAndStroke;
  jCanvas1.PaintColor:=colbrYellow;
  jCanvas1.PaintTextSize:=30;

  jCanvas1.drawText('Appointment 1', 220, 0-tag+50);
  jCanvas1.drawText('Appointment 2', 220, x*10-tag+50);
  jCanvas1.drawText('Appointment 3', 220, x*30-tag+50);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  i:integer;
  formattedDate : string;
begin
  jListView1.Clear;
  for i:=0 to 48 do
  begin
    DateTimeToString(formattedDate, 'hh nn', EncodeTime(((i div 2) mod 24),(i mod 2)*30,0,0));
    jListView1.Add(formattedDate);
  end;
  TotalListViewHeight:=jListView1.GetTotalHeight-DividerHeight;
  ItemHeight:=jListView1.GetItemHeight(0)+2;
end;

end.
