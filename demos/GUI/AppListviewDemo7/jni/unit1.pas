{Hint: save all files to location: C:\android\workspace\AppListviewDemo7\jni }
unit unit1;            //by juank1971

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jCanvas1: jCanvas;
    jListView1: jListView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jListView1AfterDispatchDraw(Sender: TObject; canvas: JObject;
      tag: integer);
  private
    {private declarations}

    TotalListViewHeight:integer;
    ItemHeight:integer;

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

procedure TAndroidModule1.jListView1AfterDispatchDraw(Sender: TObject;
  canvas: JObject; tag: integer);
var
  x:double; i,densidad:integer;
begin
  jCanvas1.SetCanvas(canvas);
  x:=ItemHeight;

  jCanvas1.PaintStrokeWidth:=1;
  jCanvas1.PaintStyle:=psStroke;
  jCanvas1.PaintColor:=colbrYellow;
  jCanvas1.PaintTextSize:=20;

  densidad := jCanvas1.Density.ToString.ToInteger;
  i:= trunc(x/3/densidad) * densidad;

  jCanvas1.drawText('First1 Text Size 20', 50, 0-tag+i);
  jCanvas1.drawText('First2 Text Size 20', 50, x*1-tag+i);
  jCanvas1.drawText('First3 Text Size 20', 50, x*2-tag+i);
  jCanvas1.drawText('First4 Text Size 20', 50, x*3-tag+i);
  jCanvas1.drawText('First5 Text Size 20', 50, x*4-tag+i);
  jCanvas1.drawText('First6 Text Size 20', 50, x*5-tag+i);

   // draw text
  jCanvas1.PaintStrokeWidth:=1;
  jCanvas1.PaintStyle:=psStroke;
  jCanvas1.PaintColor:=colbrGhostWhite;
  jCanvas1.PaintTextSize:=17;

  jCanvas1.drawText('Second1 Text Size 17', 50, x/4-tag+i);
  jCanvas1.drawText('Second2 Text Size 17', 50, x*1+x/4-tag+i);
  jCanvas1.drawText('Second3 Text Size 17', 50, x*2+x/4-tag+i);
  jCanvas1.drawText('Second4 Text Size 17', 50, x*3+x/4-tag+i);
  jCanvas1.drawText('Second5 Text Size 17', 50, x*4+x/4-tag+i);
  jCanvas1.drawText('Second6 Text Size 17', 50, x*5+x/4-tag+i);

   // draw text
  jCanvas1.PaintStrokeWidth:=1;
  jCanvas1.PaintStyle:=psStroke;
  jCanvas1.PaintColor:=colbrNavajoWhite;
  jCanvas1.PaintTextSize:=15;

  jCanvas1.drawText('Third1 Text Size 15', 50, x/2-tag+i);
  jCanvas1.drawText('Third2 Text Size 15', 50, x*1+x/2-tag+i);
  jCanvas1.drawText('Third3 Text Size 15', 50, x*2+x/2-tag+i);
  jCanvas1.drawText('Third4 Text Size 15', 50, x*3+x/2-tag+i);
  jCanvas1.drawText('Third5 Text Size 15', 50, x*4+x/2-tag+i);
  jCanvas1.drawText('Third6 Text Size 15', 50, x*5+x/2-tag+i);
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
    jListView1.Add( IntToStr(i)+'(       |     |       )'+ formattedDate);
  end;
  TotalListViewHeight:=jListView1.GetTotalHeight-DividerHeight;
  ItemHeight:=jListView1.GetItemHeight(0)+2;
end;

end.
