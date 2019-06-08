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
    jButton2: jButton;
    jExpandableListView1: jExpandableListView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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

  jExpandableListView1.Add('NewGroup 500$NewItem 501;NewItem 502;NewItem 503', '$', ';');

  jExpandableListView1.Add('NewGroup 600', 'NewItem 601;NewItem 602;NewItem 603');

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   //jExpandableListView1.ClearChildren(1);  //clear all Children from group 1
   //jExpandableListView1.ClearGroup(1);     //clear the group 1
  jExpandableListView1.Clear();              //clear all
   ShowMessage('Clear...')
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jExpandableListView1.FontColor:= colbrGreen;
   jExpandableListView1.FontChildColor:= colbrBlue;
end;

procedure TAndroidModule1.jExpandableListView1OnChildItemClick(Sender: TObject;
  groupItemPosition: integer; groupItemHeader: string;
  childItemPosition: integer; childItemCaption: string);
begin
  ShowMessage(childItemCaption);
end;

end.
