{Hint: save all files to location: C:\android\workspace\AppListViewDemo5\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jListView1: jListView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jListView1DrawItemBackColor(Sender: TObject; itemIndex: integer;
      out backColor: TARGBColorBridge);
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if jEditText1.Text <> '' then
    jListView1.Add(jEditText1.Text);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //jListView1.SetDrawItemBackColorAlpha(5);  //in  0..255  // <-- Try It!!
end;

procedure TAndroidModule1.jListView1DrawItemBackColor(Sender: TObject;
  itemIndex: integer; out backColor: TARGBColorBridge);
begin
  if  (itemIndex mod 2) = 0 then  backColor:= colbrLinen
  else  backColor:= colbrLightGrey;
end;

end.
