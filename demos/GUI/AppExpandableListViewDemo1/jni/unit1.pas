{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppExpandableListViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, expandablelistview, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jExpandableListView1: jExpandableListView;
    jTextView1: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jExpandableListView1OnChildItemClick(Sender: TObject;
      groupItemPosition: integer; groupItemHeader: string;
      childItemPosition: integer; childItemCaption: string);
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
  jExpandableListView1.Add('NewGroup 100$NewItem 101;NewItem 102;NewItem 103', '$', ';');
  jExpandableListView1.Add('NewGroup 200', 'NewItem 201;NewItem 202;NewItem 203');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jExpandableListView1.FontColor:= colbrGreen;
   jExpandableListView1.FontChildColor:= colbrBlue;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin

end;

procedure TAndroidModule1.jExpandableListView1OnChildItemClick(Sender: TObject;
  groupItemPosition: integer; groupItemHeader: string;
  childItemPosition: integer; childItemCaption: string);
begin
  ShowMessage(childItemCaption);
end;

end.
